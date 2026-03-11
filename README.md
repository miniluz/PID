# Juzgando por la portada

Para ejecutar el código, hace falta [instalar uv](https://docs.astral.sh/uv/getting-started/installation/).
Las dependencias están en el `pyproject.toml`.

Una vez está instalado, se usa de la siguiente manera:
```bash
uv sync # instalar lo ya instalado, crea un venv
uv install paquete # añadir paquete
uv run src/main.py # ejecutar un archivo

source .venv/bin/activate # activar el venv ya instalado
python src/main.py # dentro del venv, no hace falta hacer uv run

jupyter notebook # empezar un cuaderno de jupyter
```
