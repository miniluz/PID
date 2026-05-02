import sys
from pathlib import Path

import numpy as np
import keras

# =========================
# IMPORTAR lib.py DESDE src/
# =========================

PROJECT_ROOT = Path(__file__).resolve().parents[1]
SRC_DIR = PROJECT_ROOT / "src"

sys.path.append(str(SRC_DIR))

import lib


# =========================
# CONFIGURACIÓN
# =========================

MODELS_DIR = PROJECT_ROOT / "src" / "resultados_modelos"

BATCH_SIZE = lib.BATCH_SIZE

# En tu lib.py tienes:
# threshold = 0.5
# pero también puede interesarte usar un valor fijo aquí.
THRESHOLD = getattr(lib, "threshold", 0.5)

# Dataset de validación ya preprocesado:
# carga imagen, resize, normaliza, batch y prefetch
VAL_DATASET = lib.val_dataset


# =========================
# FUNCIÓN PARA CALCULAR BINARY ACCURACY
# =========================

def calculate_binary_accuracy(model_path, dataset):
    model = keras.saving.load_model(model_path, compile=False)

    y_true_all = []
    y_pred_all = []

    for batch_x, batch_y in dataset:
        y_prob = model.predict(batch_x, batch_size=BATCH_SIZE, verbose=0)

        y_pred_bin = (y_prob >= THRESHOLD).astype(int)

        y_true_all.append(batch_y.numpy().astype(int))
        y_pred_all.append(y_pred_bin.astype(int))

    y_true_all = np.concatenate(y_true_all, axis=0)
    y_pred_all = np.concatenate(y_pred_all, axis=0)

    binary_accuracy = np.mean(y_true_all == y_pred_all)

    return float(binary_accuracy)


# =========================
# FUNCIÓN PARA ACTUALIZAR TXT
# =========================

def update_txt_with_binary_accuracy(txt_path, binary_accuracy):
    with open(txt_path, "r", encoding="utf-8") as f:
        content = f.read()

    new_line = f"  binary_accuracy: {binary_accuracy:.4f}"

    # Si ya existe binary_accuracy, la reemplaza
    if "binary_accuracy:" in content:
        lines = content.splitlines()
        updated_lines = []

        for line in lines:
            if "binary_accuracy:" in line:
                updated_lines.append(new_line)
            else:
                updated_lines.append(line)

        new_content = "\n".join(updated_lines) + "\n"

    else:
        # Si existe la sección de métricas, añadimos la métrica al final
        if "=== MÉTRICAS ===" in content:
            new_content = content.rstrip() + "\n" + new_line + "\n"
        else:
            # Por si algún txt no tiene sección de métricas
            new_content = content.rstrip() + "\n\n=== MÉTRICAS ===\n" + new_line + "\n"

    with open(txt_path, "w", encoding="utf-8") as f:
        f.write(new_content)


# =========================
# RECORRER TODOS LOS MODELOS
# =========================

def main():
    if not MODELS_DIR.exists():
        raise FileNotFoundError(f"No existe la carpeta de modelos: {MODELS_DIR}")

    keras_files = list(MODELS_DIR.glob("*.keras"))

    if len(keras_files) == 0:
        print(f"No se encontraron modelos .keras en: {MODELS_DIR}")
        return

    print(f"Modelos encontrados: {len(keras_files)}")
    print(f"Usando threshold: {THRESHOLD}")
    print(f"Carpeta de modelos: {MODELS_DIR}")

    for model_path in keras_files:
        txt_path = model_path.with_suffix(".txt")

        if not txt_path.exists():
            print(f"No existe TXT para {model_path.name}, se omite.")
            continue

        print(f"\nProcesando {model_path.name}...")

        binary_acc = calculate_binary_accuracy(model_path, VAL_DATASET)

        update_txt_with_binary_accuracy(txt_path, binary_acc)

        print(f"  binary_accuracy: {binary_acc:.4f}")

    print("\nProceso terminado.")


if __name__ == "__main__":
    main()