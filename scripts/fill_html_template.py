import re
import csv
import json
from pathlib import Path


def fill_html_template():
    html_path = Path("src/demo.html")
    onnx_dir = Path("src/resultados_onnx")
    movies_csv_path = Path("training-data/movies_preprocesado.csv")
    output_path = Path("src/demo_with_models.html")

    content = html_path.read_text()

    # Pattern: /* filename.onnx */ null
    onnx_pattern = re.compile(r"/\*\s*(\S+?\.onnx)\s*\*/\s*null")

    def onnx_replacement(match):
        filename = match.group(1)
        onnx_path = onnx_dir / filename

        if not onnx_path.exists():
            raise FileNotFoundError(f"ONNX file not found: {onnx_path}")

        data = onnx_path.read_bytes()
        # Convert to Uint8Array literal
        array_values = ",".join(str(b) for b in data)
        return f"new Uint8Array([{array_values}])"

    # Replace ONNX file references
    content = onnx_pattern.sub(onnx_replacement, content)

    # Pattern: /* movie_database */ null
    movie_pattern = re.compile(r"/\*\s*movie_database\s*\*/\s*null")

    def movie_replacement(match):
        if not movies_csv_path.exists():
            raise FileNotFoundError(f"Movies CSV file not found: {movies_csv_path}")

        movies = []
        with open(movies_csv_path, "r", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)
            # Read only first 5 rows
            for i, row in enumerate(reader):
                if i >= 5:
                    break
                movies.append(row)

        # Convert to JSON string
        json_str = json.dumps(movies, indent=2)
        return json_str

    # Replace movie database reference
    content = movie_pattern.sub(movie_replacement, content)

    output_path.write_text(content)
    print(f"Output written to {output_path}")


if __name__ == "__main__":
    fill_html_template()
