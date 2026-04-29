import base64
import csv
import json
import re
import zlib
from pathlib import Path


def fill_html_template():
    html_path = Path("src/demo_template.html")
    onnx_dir = Path("src/resultados_onnx")
    movies_csv_path = Path("scripts/movies_preprocesado.csv")
    output_path = Path("src/demo.html")

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
            for row in reader:
                movies.append(row)

        # Convert to JSON string
        json_bytes = json.dumps(movies).encode("utf-8")
        compressed = zlib.compress(json_bytes)
        b64 = base64.b64encode(compressed).decode("ascii")

        # return f'JSON.parse(pako.inflate(Uint8Array.from(atob("{b64}"), c => c.charCodeAt(0)), {{ to: "string" }}))'
        return f'JSON.parse(pako.inflate((b=>{{let t="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",l=b.length,o=new Uint8Array(l*3/4|0),p=0,i=0,c1,c2,c3,c4;for(;i<l;){{c1=t.indexOf(b[i++]);c2=t.indexOf(b[i++]);c3=t.indexOf(b[i++]);c4=t.indexOf(b[i++]);o[p++]=(c1<<2)|(c2>>4);if(c3>=0)o[p++]=((c2&15)<<4)|(c3>>2);if(c4>=0)o[p++]=((c3&3)<<6)|c4;}}return o.subarray(0,p);}})("{b64}"),{{to:"string"}}))'

    # Replace movie database reference
    content = movie_pattern.sub(movie_replacement, content)

    output_path.write_text(content)
    print(f"Output written to {output_path}")


if __name__ == "__main__":
    fill_html_template()
