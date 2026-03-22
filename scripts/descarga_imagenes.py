import os
import hashlib
from pathlib import Path
from urllib.parse import urlparse
from concurrent.futures import ThreadPoolExecutor, as_completed

import pandas as pd
import requests
from tqdm import tqdm

# =========================
# CONFIG
# =========================
CSV_PATH = "scripts/movies_preprocesado.csv"
POSTER_COLUMN = "poster_path"
BASE_URL = "https://image.tmdb.org/t/p/w300_and_h450_face"
OUTPUT_DIR = "imagenes"

TIMEOUT = 20
MAX_WORKERS = 64       # prueba 16, 32 o 64 según tu conexión/equipo
CHUNK_SIZE = 8192

# =========================
# SETUP
# =========================
output_path = Path(OUTPUT_DIR)
output_path.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(CSV_PATH)

if POSTER_COLUMN not in df.columns:
    raise ValueError(f"La columna '{POSTER_COLUMN}' no existe en el CSV.")

poster_paths = df[POSTER_COLUMN].dropna().astype(str)
poster_paths = poster_paths[poster_paths != ""]

# opcional: quitar duplicados
poster_paths = poster_paths.drop_duplicates()

items = []
for poster_path in poster_paths:
    poster_path = poster_path.strip()
    if not poster_path:
        continue

    url = BASE_URL + poster_path if poster_path.startswith("/") else BASE_URL + "/" + poster_path
    items.append((poster_path, url))


# =========================
# SESIÓN HTTP
# =========================
session = requests.Session()
session.headers.update({"User-Agent": "Mozilla/5.0"})

adapter = requests.adapters.HTTPAdapter(
    pool_connections=MAX_WORKERS,
    pool_maxsize=MAX_WORKERS
)
session.mount("http://", adapter)
session.mount("https://", adapter)


# =========================
# FUNCIONES
# =========================
def stable_name_from_poster_path(poster_path: str) -> str:
    """
    Nombre estable basado en poster_path.
    """
    return hashlib.md5(poster_path.encode("utf-8")).hexdigest()


def extension_from_poster_path(poster_path: str) -> str:
    """
    TMDB suele traer la extensión en poster_path, p. ej. /abc123.jpg
    """
    ext = os.path.splitext(urlparse(poster_path).path)[1].lower()
    if ext in {".jpg", ".jpeg", ".png", ".webp"}:
        return ext
    return ".jpg"


def build_final_path(directory: Path, poster_path: str) -> Path:
    # Usar el poster_path directamente como nombre de archivo
    # Remover el / inicial si existe
    file_name = poster_path.lstrip('/')
    return directory / file_name


def download_image(item, directory: Path):
    poster_path, url = item

    final_file = build_final_path(directory, poster_path)
    tmp_file = final_file.with_suffix(final_file.suffix + ".part")

    # Ya existe y parece válido
    if final_file.exists() and final_file.stat().st_size > 0:
        return {"status": "skipped", "url": url, "file": str(final_file)}

    # Limpieza de posible archivo temporal previo
    if tmp_file.exists():
        try:
            tmp_file.unlink()
        except Exception:
            pass

    try:
        response = session.get(url, stream=True, timeout=TIMEOUT)
        response.raise_for_status()

        content_type = response.headers.get("Content-Type", "").lower()
        if "image" not in content_type:
            return {"status": "failed", "url": url, "file": "", "reason": f"No es imagen: {content_type}"}

        with open(tmp_file, "wb") as f:
            for chunk in response.iter_content(chunk_size=CHUNK_SIZE):
                if chunk:
                    f.write(chunk)

        tmp_file.rename(final_file)
        return {"status": "downloaded", "url": url, "file": str(final_file)}

    except Exception as e:
        if tmp_file.exists():
            try:
                tmp_file.unlink()
            except Exception:
                pass
        return {"status": "failed", "url": url, "file": "", "reason": str(e)}


# =========================
# DESCARGA PARALELA
# =========================
results = {"downloaded": 0, "skipped": 0, "failed": 0}

with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
    futures = [executor.submit(download_image, item, output_path) for item in items]

    for future in tqdm(as_completed(futures), total=len(futures), desc="Descargando posters", unit="img"):
        result = future.result()
        results[result["status"]] += 1


# =========================
# RESUMEN
# =========================
print("\nResumen:")
print(f"Nuevas descargas: {results['downloaded']}")
print(f"Ya existentes:    {results['skipped']}")
print(f"Fallidas:         {results['failed']}")