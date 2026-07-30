# audio_downloader.py

Downloads an audio file from a **direct URL you have the rights to**
(your own file, public domain, or a source that explicitly permits
download), converts it to MP3 at up to 320 kbps, tags metadata, and
validates the result.

It refuses URLs from streaming/DRM platforms (YouTube, Spotify, Apple
Music, Deezer, Tidal, TikTok, ...) by design — it does not extract or
circumvent protections on those services.

## Requirements

- Python 3.9+
- [ffmpeg](https://ffmpeg.org/) (and `ffprobe`, bundled with it) on `PATH`
- `pip install -r requirements.txt`

## Usage

```bash
python audio_downloader.py "https://example.com/path/to/audio-file.wav" \
  --output Daite_Duri.mp3 \
  --title "Дайте дури" \
  --artist "skyemane, fedo DJ, nimphia" \
  --cover cover.jpg
```

If the URL points to a blocked domain (YouTube, Spotify, etc.) the
script exits with an error instead of attempting a download.
