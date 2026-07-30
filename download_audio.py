#!/usr/bin/env python3
"""
download_audio.py

Descarga SOLO el audio de un video de YouTube usando yt-dlp, pero
UNICAMENTE si el usuario confirma en consola que tiene derecho legal
a descargarlo (video propio, licencia Creative Commons, dominio
publico o permiso explicito del titular de los derechos).

Este script:
  - NO evade DRM, paywalls, restricciones de acceso ni sistemas anticopia.
  - NO descarga contenido si el usuario no confirma que tiene derecho a hacerlo.
  - Muestra la informacion del video (titulo, canal, duracion, licencia)
    antes de pedir confirmacion, para ayudar a tomar esa decision.

------------------------------------------------------------------
INSTALACION DE DEPENDENCIAS (Windows)
------------------------------------------------------------------

1) Instalar yt-dlp (requiere Python 3.8+ y pip):

       pip install yt-dlp

2) Instalar ffmpeg (necesario para extraer/convertir el audio a mp3/m4a):

   Opcion A - usando winget (Windows 10/11):
       winget install ffmpeg

   Opcion B - usando Chocolatey:
       choco install ffmpeg

   Opcion C - instalacion manual:
       1. Descargar el build desde https://www.gyan.dev/ffmpeg/builds/
          (elige "release full" o "release essentials").
       2. Descomprimir, por ejemplo en C:\\ffmpeg
       3. Agregar C:\\ffmpeg\\bin al PATH del sistema:
          Panel de control > Sistema > Configuracion avanzada del sistema
          > Variables de entorno > Path > Editar > Nuevo > C:\\ffmpeg\\bin
       4. Abrir una nueva terminal y verificar con:
              ffmpeg -version

------------------------------------------------------------------
USO
------------------------------------------------------------------

    python download_audio.py "https://youtu.be/XXXXXXXXXXX"

Si no se pasa una URL como argumento, el script la pedira por consola.
"""

import os
import sys
import shutil

try:
    import yt_dlp
except ImportError:
    print(
        "ERROR: No se encontro el paquete 'yt-dlp'.\n"
        "Instalalo con:\n\n    pip install yt-dlp\n"
    )
    sys.exit(1)


DOWNLOADS_DIR = "downloads"
PREFERRED_AUDIO_FORMAT = "mp3"  # cambia a "m4a" si prefieres ese formato
LICENCIAS_PERMITIDAS_INFO = (
    "Recuerda: solo debes continuar si eres el titular del video, "
    "el contenido tiene licencia Creative Commons, es de dominio publico, "
    "o cuentas con permiso explicito para descargarlo."
)


def check_ffmpeg_disponible() -> bool:
    """Verifica que ffmpeg este instalado y accesible en el PATH."""
    return shutil.which("ffmpeg") is not None


def formatear_duracion(segundos):
    """Convierte segundos a formato HH:MM:SS (o MM:SS si dura menos de 1 hora)."""
    if segundos is None:
        return "Desconocida"
    segundos = int(segundos)
    horas, resto = divmod(segundos, 3600)
    minutos, segs = divmod(resto, 60)
    if horas:
        return f"{horas:02d}:{minutos:02d}:{segs:02d}"
    return f"{minutos:02d}:{segs:02d}"


def obtener_info_video(url: str) -> dict:
    """
    Obtiene metadatos del video sin descargarlo (extract_flat / no download).
    Lanza una excepcion si la URL no es valida o el video no permite extraccion.
    """
    opciones_info = {
        "quiet": True,
        "no_warnings": True,
        "skip_download": True,
    }
    with yt_dlp.YoutubeDL(opciones_info) as ydl:
        return ydl.extract_info(url, download=False)


def mostrar_info_video(info: dict) -> None:
    """Imprime en consola los metadatos relevantes del video."""
    titulo = info.get("title", "Desconocido")
    canal = info.get("uploader") or info.get("channel") or "Desconocido"
    duracion = formatear_duracion(info.get("duration"))
    licencia = info.get("license") or "No especificada por el uploader"

    print("\n----- Informacion del video -----")
    print(f"Titulo:    {titulo}")
    print(f"Canal:     {canal}")
    print(f"Duracion:  {duracion}")
    print(f"Licencia:  {licencia}")
    print("----------------------------------\n")


def pedir_confirmacion() -> bool:
    """Pide confirmacion explicita al usuario antes de descargar."""
    print(LICENCIAS_PERMITIDAS_INFO)
    respuesta = input(
        "\n¿Confirmas que tienes derecho a descargar este audio? [s/N]: "
    ).strip().lower()
    return respuesta == "s"


def descargar_audio(url: str) -> None:
    """Descarga solo el audio del video en la carpeta downloads/."""
    os.makedirs(DOWNLOADS_DIR, exist_ok=True)

    opciones_descarga = {
        "format": "bestaudio/best",
        "outtmpl": os.path.join(DOWNLOADS_DIR, "%(title)s.%(ext)s"),
        "postprocessors": [
            {
                "key": "FFmpegExtractAudio",
                "preferredcodec": PREFERRED_AUDIO_FORMAT,
                "preferredquality": "192",
            }
        ],
        "noplaylist": True,
        "quiet": False,
    }

    with yt_dlp.YoutubeDL(opciones_descarga) as ydl:
        ydl.download([url])

    print(f"\nDescarga completada. Archivo guardado en la carpeta '{DOWNLOADS_DIR}/'.")


def main():
    if len(sys.argv) > 1:
        url = sys.argv[1].strip()
    else:
        url = input("Ingresa la URL del video de YouTube: ").strip()

    if not url:
        print("ERROR: No se proporciono ninguna URL.")
        sys.exit(1)

    if not check_ffmpeg_disponible():
        print(
            "ERROR: No se encontro 'ffmpeg' en el PATH del sistema.\n"
            "ffmpeg es necesario para extraer el audio en formato mp3/m4a.\n\n"
            "Instalalo en Windows con alguna de estas opciones:\n"
            "  winget install ffmpeg\n"
            "  choco install ffmpeg\n"
            "  (o descarga manual desde https://www.gyan.dev/ffmpeg/builds/ "
            "y agrega la carpeta 'bin' al PATH)\n"
        )
        sys.exit(1)

    try:
        info = obtener_info_video(url)
    except yt_dlp.utils.DownloadError as e:
        print(f"ERROR: No se pudo obtener informacion del video.\n{e}")
        sys.exit(1)
    except Exception as e:
        print(f"ERROR inesperado al obtener informacion del video: {e}")
        sys.exit(1)

    mostrar_info_video(info)

    if not pedir_confirmacion():
        print("Descarga cancelada. No se ha descargado ningun archivo.")
        sys.exit(0)

    try:
        descargar_audio(url)
    except yt_dlp.utils.DownloadError as e:
        mensaje = str(e)
        if "ffmpeg" in mensaje.lower():
            print(
                "ERROR: Fallo la extraccion de audio porque ffmpeg no esta "
                "disponible o no funciona correctamente.\n"
                f"{mensaje}"
            )
        else:
            print(
                "ERROR: No se pudo descargar el video. Posibles causas:\n"
                "  - La URL no es valida o el video fue eliminado/privado.\n"
                "  - El video no permite la extraccion de audio "
                "(restricciones del uploader o de YouTube).\n"
                f"\nDetalle: {mensaje}"
            )
        sys.exit(1)
    except Exception as e:
        print(f"ERROR inesperado durante la descarga: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
