import re
from pathlib import Path

def embed_onnx_files():
    html_path = Path("src/demo.html")
    onnx_dir = Path("src/resultados_onnx")
    output_path = Path("src/demo_with_models.html")
    
    content = html_path.read_text()
    
    # Pattern: /* filename.onnx */ null
    pattern = re.compile(r'/\*\s*(\S+?\.onnx)\s*\*/\s*null')
    
    def replacement(match):
        filename = match.group(1)
        onnx_path = onnx_dir / filename
        
        if not onnx_path.exists():
            raise FileNotFoundError(f"ONNX file not found: {onnx_path}")
        
        data = onnx_path.read_bytes()
        # Convert to Uint8Array literal
        array_values = ",".join(str(b) for b in data)
        return f"new Uint8Array([{array_values}])"
    
    result = pattern.sub(replacement, content)
    output_path.write_text(result)
    print(f"Output written to {output_path}")

if __name__ == "__main__":
    embed_onnx_files()