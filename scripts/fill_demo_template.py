import base64
import csv
import hashlib
import json
import re
from pathlib import Path

import brotli

CACHE_DIR = Path("cache")
CACHE_DIR.mkdir(exist_ok=True)


def file_hash(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()


def cache_read(cache_file: Path):
    if cache_file.exists():
        return cache_file.read_text()
    return None


def cache_write(cache_file: Path, value: str):
    cache_file.write_text(value)


def encode_file_brotli_base64(path: Path, cache_prefix: str) -> str:
    h = file_hash(path)
    cache_file = CACHE_DIR / f"{cache_prefix}_{h}.txt"

    cached = cache_read(cache_file)
    if cached:
        return cached

    data = path.read_bytes()
    compressed = brotli.compress(data)
    b64 = base64.b64encode(compressed).decode("ascii")

    cache_write(cache_file, b64)
    return b64


def fill_html_template():
    html_path = Path("src/demo_template.html")
    onnx_dir = Path("src/resultados_onnx")
    movies_csv_path = Path("scripts/movies_preprocesado.csv")
    output_path = Path("pages/demo.html")

    content = html_path.read_text()

    # Pattern: /* filename.onnx */ null
    onnx_pattern = re.compile(r"/\*\s*(\S+?\.onnx)\s*\*/\s*null")

    def onnx_replacement(match):
        filename = match.group(1)
        onnx_path = onnx_dir / filename

        if not onnx_path.exists():
            raise FileNotFoundError(f"ONNX file not found: {onnx_path}")

        b64 = encode_file_brotli_base64(onnx_path, "onnx")

        return f'window.decodeBrotliBase64("{b64}")'

    content = onnx_pattern.sub(onnx_replacement, content)

    # Pattern: /* movie_database */ null
    movie_pattern = re.compile(r"/\*\s*movie_database\s*\*/\s*null")

    def movie_replacement(match):
        if not movies_csv_path.exists():
            raise FileNotFoundError(f"Movies CSV file not found: {movies_csv_path}")

        h = file_hash(movies_csv_path)
        cache_file = CACHE_DIR / f"movies_{h}.txt"

        cached = cache_read(cache_file)
        if cached:
            b64 = cached
        else:
            movies = []
            with open(movies_csv_path, "r", encoding="utf-8") as csvfile:
                reader = csv.DictReader(csvfile)
                for row in reader:
                    for key, value in row.items():
                        if value.isdigit():
                            row[key] = int(value)
                    movies.append(row)

            json_bytes = json.dumps(movies, separators=(",", ":")).encode("utf-8")
            compressed = brotli.compress(json_bytes)
            b64 = base64.b64encode(compressed).decode("ascii")

            cache_write(cache_file, b64)

        return f'window.decodeBrotliBase64("{b64}").then(b => JSON.parse(new TextDecoder().decode(b)))'

    content = movie_pattern.sub(movie_replacement, content)

    output_path.write_text(content)
    print(f"Output written to {output_path}")


if __name__ == "__main__":
    fill_html_template()
