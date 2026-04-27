"""Convierte todos los .keras de src/resultados_modelos a ONNX."""

from pathlib import Path
import traceback

import tensorflow as tf

try:
    import tf2onnx
except ImportError as exc:
    raise SystemExit(
        "No se encontro 'tf2onnx'. Instalala con: pip install tf2onnx"
    ) from exc

INPUT_DIR = Path("src/resultados_modelos")
OUTPUT_DIR = Path("src/resultados_onnx")
OPSET = 13
OVERWRITE_EXISTING = False


def export_model(keras_path: Path, onnx_path: Path, opset: int) -> None:
    model = tf.keras.models.load_model(keras_path, compile=False)

    # Obtiene una firma de entrada para facilitar la conversion robusta.
    input_specs = []
    for tensor in model.inputs:
        shape = [dim if dim is not None else 1 for dim in tensor.shape]
        input_specs.append(
            tf.TensorSpec(shape=shape, dtype=tensor.dtype, name=tensor.name.split(":")[0])
        )

    @tf.function(input_signature=input_specs)
    def model_fn(*args):
        return model(*args, training=False)

    _model_proto, _external_tensor_storage = tf2onnx.convert.from_function(
        model_fn,
        input_signature=input_specs,
        opset=opset,
        output_path=str(onnx_path),
    )


def main() -> int:
    if not INPUT_DIR.exists() or not INPUT_DIR.is_dir():
        print(f"ERROR: La carpeta de entrada no existe o no es valida: {INPUT_DIR}")
        return 1

    keras_files = sorted(INPUT_DIR.rglob("*.keras"))
    if not keras_files:
        print(f"No se encontraron archivos .keras en: {INPUT_DIR}")
        return 0

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    print(f"Modelos encontrados: {len(keras_files)}")
    print(f"Entrada: {INPUT_DIR}")
    print(f"Salida: {OUTPUT_DIR}")
    print(f"Opset: {OPSET}")

    converted = 0
    skipped = 0
    failed = 0

    for keras_path in keras_files:
        relative = keras_path.relative_to(INPUT_DIR)
        onnx_path = (OUTPUT_DIR / relative).with_suffix(".onnx")
        onnx_path.parent.mkdir(parents=True, exist_ok=True)

        if onnx_path.exists() and not OVERWRITE_EXISTING:
            print(f"[SKIP] {relative} -> {onnx_path.name} (ya existe)")
            skipped += 1
            continue

        print(f"[CONVERT] {relative} -> {onnx_path.name}")
        try:
            export_model(keras_path, onnx_path, OPSET)
            converted += 1
        except Exception as exc:  # noqa: BLE001
            failed += 1
            print(f"[ERROR] Fallo al convertir {keras_path}: {exc}")
            traceback.print_exc()

    print("\nResumen:")
    print(f"- Convertidos: {converted}")
    print(f"- Saltados: {skipped}")
    print(f"- Fallidos: {failed}")

    return 0 if failed == 0 else 2


if __name__ == "__main__":
    raise SystemExit(main())
