#!/usr/bin/env python3
"""
Legal-use audio downloader/converter.

Downloads an audio file from a direct URL you have the rights to (your own
file, public domain, or a source that explicitly permits download),
converts it to MP3 (<=320 kbps), tags it with metadata, validates the
result, and writes it to disk.

This tool deliberately refuses to touch streaming/DRM platforms
(YouTube, Spotify, Apple Music, Deezer, Tidal, SoundCloud go+, TikTok...):
it will not attempt to extract or circumvent protections on those
services. Point it only at a direct, permitted download URL.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from urllib.parse import urlparse

import requests

BLOCKED_DOMAINS = {
    "youtube.com", "www.youtube.com", "youtu.be", "music.youtube.com",
    "spotify.com", "open.spotify.com",
    "music.apple.com", "itunes.apple.com",
    "deezer.com", "www.deezer.com",
    "tidal.com", "listen.tidal.com",
    "tiktok.com", "www.tiktok.com",
}

MAX_BITRATE_KBPS = 320
DOWNLOAD_CHUNK = 1 << 16  # 64 KiB


class DownloaderError(RuntimeError):
    pass


def check_url_allowed(url: str) -> None:
    host = (urlparse(url).hostname or "").lower()
    if host in BLOCKED_DOMAINS or any(host.endswith("." + d) for d in BLOCKED_DOMAINS):
        raise DownloaderError(
            f"Refusing to download from '{host}': this is a protected streaming "
            "platform. Only direct URLs you own, that are public domain, or that "
            "explicitly permit download are supported. Stream or purchase the "
            "track legally from that platform instead."
        )


def download_audio(url: str, dest: Path) -> Path:
    check_url_allowed(url)
    with requests.get(url, stream=True, timeout=30) as resp:
        resp.raise_for_status()
        content_type = resp.headers.get("Content-Type", "")
        if content_type and not (
            content_type.startswith("audio/") or content_type == "application/octet-stream"
        ):
            raise DownloaderError(
                f"URL did not return audio content (Content-Type: {content_type})."
            )
        with open(dest, "wb") as f:
            for chunk in resp.iter_content(chunk_size=DOWNLOAD_CHUNK):
                if chunk:
                    f.write(chunk)
    if not dest.exists() or dest.stat().st_size == 0:
        raise DownloaderError("Download completed but produced an empty file.")
    return dest


def convert_to_mp3(src: Path, dest: Path, bitrate_kbps: int = MAX_BITRATE_KBPS) -> Path:
    if shutil.which("ffmpeg") is None:
        raise DownloaderError("ffmpeg is not installed or not on PATH.")
    bitrate_kbps = min(bitrate_kbps, MAX_BITRATE_KBPS)
    cmd = [
        "ffmpeg", "-y",
        "-i", str(src),
        "-vn",
        "-codec:a", "libmp3lame",
        "-b:a", f"{bitrate_kbps}k",
        str(dest),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        raise DownloaderError(f"ffmpeg conversion failed:\n{result.stderr}")
    return dest


def add_metadata(
    mp3_path: Path,
    title: str | None = None,
    artist: str | None = None,
    cover_path: Path | None = None,
) -> None:
    from mutagen.id3 import ID3, ID3NoHeaderError, TIT2, TPE1, APIC

    try:
        tags = ID3(mp3_path)
    except ID3NoHeaderError:
        tags = ID3()

    if title:
        tags["TIT2"] = TIT2(encoding=3, text=title)
    if artist:
        tags["TPE1"] = TPE1(encoding=3, text=artist)
    if cover_path and cover_path.exists():
        mime = "image/png" if cover_path.suffix.lower() == ".png" else "image/jpeg"
        tags["APIC"] = APIC(
            encoding=3, mime=mime, type=3, desc="Cover",
            data=cover_path.read_bytes(),
        )
    tags.save(mp3_path)


def validate_mp3(mp3_path: Path) -> None:
    if not mp3_path.exists() or mp3_path.stat().st_size == 0:
        raise DownloaderError("Output file is missing or empty.")

    if shutil.which("ffprobe") is not None:
        result = subprocess.run(
            ["ffprobe", "-v", "error", "-show_entries", "format=duration",
             "-of", "default=noprint_wrappers=1:nokey=1", str(mp3_path)],
            capture_output=True, text=True,
        )
        if result.returncode != 0 or not result.stdout.strip():
            raise DownloaderError(f"Output file failed integrity check:\n{result.stderr}")
        duration = float(result.stdout.strip())
        if duration <= 0:
            raise DownloaderError("Output file has zero duration; likely corrupt.")


def run(
    url: str,
    output: Path,
    title: str | None,
    artist: str | None,
    cover: Path | None,
    bitrate_kbps: int,
) -> Path:
    with tempfile.TemporaryDirectory() as tmp:
        raw_path = Path(tmp) / "source_audio"
        print(f"Downloading from {url} ...")
        download_audio(url, raw_path)

        print(f"Converting to MP3 (<= {min(bitrate_kbps, MAX_BITRATE_KBPS)} kbps) ...")
        convert_to_mp3(raw_path, output, bitrate_kbps)

    if title or artist or cover:
        print("Writing metadata ...")
        add_metadata(output, title=title, artist=artist, cover_path=cover)

    print("Validating output file ...")
    validate_mp3(output)

    print(f"Done: {output} ({output.stat().st_size} bytes)")
    return output


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("url", help="Direct URL to an audio file you have the right to download")
    parser.add_argument("-o", "--output", default="Daite_Duri.mp3", type=Path)
    parser.add_argument("--title", default=None)
    parser.add_argument("--artist", default=None)
    parser.add_argument("--cover", default=None, type=Path)
    parser.add_argument("--bitrate", default=MAX_BITRATE_KBPS, type=int,
                         help=f"Target bitrate in kbps, capped at {MAX_BITRATE_KBPS}")
    args = parser.parse_args()

    try:
        run(args.url, args.output, args.title, args.artist, args.cover, args.bitrate)
    except DownloaderError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
