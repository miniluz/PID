= Experimentación
<sec:cuatro>

== Selección del modelo base
<sec_seleccion_hiperparametros>

Se ha realizado la búsqueda en cuadrícula especificada en la sección anterior. Originalmente se tenía pensado realizar
la búsqueda de cuadrícula con 2, 3 y 4 capas convolucionales. Sin embargo, tras notar que no habría suficiente tiempo
para completarla, se decidió sólo entrenar modelos con 2 y 3 capas convolucionales.

=== Resultados modelo base

Para facilitar la lectura de estos datos, hago referencia a la @sec:metricasvalidacion en la que se explican las
distintas métricas usadas para la validación y evaluación de los modelos.

También me remito a la @sec:busquedacuadricula para explicar los nombres de los modelos. Sus nombres definen la
estructura de este.

La siguiente tabla recopila los resultados de todos los modelos obtenidos en la búsqueda de cuadrícula realizada para
hallar los hiperparámetros del modelo base.

Leyenda:
- C.E. -> Coincidencia exacta (exact match ratio)
- P. mic. -> Precisión (precision) *micro*
- E. mic. -> Exhaustividad (recall) *micro*
- F1 mic. -> Puntuación F1 (F1 score) *micro*
- P. mac. -> Precisión (precision) *macro*
- E. mac. -> Exhaustividad (recall) *macro*
- F1 mac. -> Puntuación F1 (F1 score) *macro*
- E. B. -> Exactitud binaria (binary accuracy)

#include "../tables/tabla_resultados_metricas_cuadricula.typ"

Resultó que la combinación con los mejores resultados era de 3 capas convolucionales, con la primera capa con 64
filtros, con una capa densa, con la primera teniendo 512 neuronas. Su código equivalente en TensorFlow se puede ver en
el @cod:modelo_base.

#figure(
  ```python
  model = models.Sequential(
    [
        layers.Input(shape=(*IMG_SIZE, 3)),

        layers.Conv2D(64, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(128, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(256, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.GlobalAveragePooling2D(),

        layers.Dense(512, activation='relu'),

        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
    ]
  )
  ```,
  caption: "Definición modelo base",
)<cod:modelo_base>


== Modelos con mejoras

A continuación se muestra el código usado para definir los modelos con mejoras:
- El modelo con dropout en el @cod:modelo_dropout.
- El modelo con aumentación de datos en el @cod:modelo_aumentacion.
- El modelo con normalización de lotes en el @cod:modelo_normalizacion.
- El modelo con decaimiento de pesos en el @cod:modelo_decaimiento.

#figure(
  ```python
  model = models.Sequential(
    [
        layers.Input(shape=(*IMG_SIZE, 3)),

        layers.Conv2D(64, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),
        layers.Dropout(0.1), # Standard for conv layers is none-0.3

        layers.Conv2D(128, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),
        layers.Dropout(0.1),

        layers.Conv2D(256, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),
        layers.Dropout(0.1),

        layers.GlobalAveragePooling2D(),

        layers.Dense(512, activation='relu'),
        layers.Dropout(0.4), # Standard for dense is 0.3-0.5

        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
    ]
  )
  ```,
  caption: "Definición modelo con dropout",
)<cod:modelo_dropout>

#figure(
  ```python
  model = models.Sequential(
    [
        layers.Input(shape=(*IMG_SIZE, 3)),
        tf.keras.Sequential([
            layers.RandomFlip("horizontal"),
            layers.RandomBrightness(0.05, value_range=(0, 1)),
        ]),

        layers.Conv2D(64, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(128, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(256, (3, 3), padding='same', activation='relu'),
        layers.MaxPooling2D(2, 2),

        layers.GlobalAveragePooling2D(),

        layers.Dense(512, activation='relu'),
        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32'),
    ]
  )
  ```,
  caption: "Definición modelo con aumentación de datos",
)<cod:modelo_aumentacion>

#figure(
  ```python
  model = models.Sequential(
    [
        layers.Input(shape=(*IMG_SIZE, 3)),

        layers.Conv2D(64, (3, 3), padding='same', activation=None),
        layers.BatchNormalization(),
        layers.ReLU(),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(128, (3, 3), padding='same', activation=None),
        layers.BatchNormalization(),
        layers.ReLU(),
        layers.MaxPooling2D(2, 2),

        layers.Conv2D(256, (3, 3), padding='same', activation=None),
        layers.BatchNormalization(),
        layers.ReLU(),
        layers.MaxPooling2D(2, 2),

        layers.GlobalAveragePooling2D(),

        layers.Dense(512, activation=None),
        layers.BatchNormalization(),
        layers.ReLU(),

        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
    ]
  )
  ```,
  caption: "Definición modelo con normalización de lotes",
)<cod:modelo_normalizacion>

#figure(
  ```python
  weight_decay = 1e-4

  model = models.Sequential([
    layers.Input(shape=(*IMG_SIZE, 3)),

    layers.Conv2D(64, (3, 3), padding='same', activation='relu'),
    layers.MaxPooling2D(2, 2),

    layers.Conv2D(128, (3, 3), padding='same', activation='relu'),
    layers.MaxPooling2D(2, 2),

    layers.Conv2D(256, (3, 3), padding='same', activation='relu'),
    layers.MaxPooling2D(2, 2),

    layers.GlobalAveragePooling2D(),

    layers.Dense(512, activation='relu'),

    layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
  ])

  model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3, weight_decay=weight_decay),
    loss='binary_crossentropy',
    metrics=['accuracy']
  )
  ```,
  caption: "Definición modelo decaimiento de pesos",
)<cod:modelo_decaimiento>

=== Resultados mejoras

Para facilitar la lectura de estos datos, hago referencia a la @sec:metricasvalidacion en la que se explican las
distintas métricas usadas para la validación y evaluación de los modelos.

La siguiente tabla recopila las métricas obtenidas de todos los modelos finales obtenidos a lo largo del proyecto (sin
contar con los entrenados en la búsqueda en cuadrícula).

Leyenda:
- C.E. -> Coincidencia exacta (exact match ratio)
- P. mic. -> Precisión (precision) *micro*
- E. mic. -> Exhaustividad (recall) *micro*
- F1 mic. -> Puntuación F1 (F1 score) *micro*
- P. mac. -> Precisión (precision) *macro*
- E. mac. -> Exhaustividad (recall) *macro*
- F1 mac. -> Puntuación F1 (F1 score) *macro*
- E. B. -> Exactitud binaria (binary accuracy)

#include "../tables/tabla_resultados_metricas_finales.typ"

La @fig:grafica_f1_macro y la @fig:grafica_f1_micro representan de forma visual las métricas puntuación f1 macro y
puntuación f1 micro de todos los modelos finales.

#figure(
  image("/figures/f1_macro_model_graph.png", width: 80%),
  caption: "Gráfica que representa la puntuación f1 macro de los modelos",
)<fig:grafica_f1_macro>

#figure(
  image("/figures/f1_micro_model_graph.png", width: 80%),
  caption: "Gráfica que representa la puntuación f1 micro de los modelos",
)<fig:grafica_f1_micro>

En la @fig:grafica_modelo_base tenemos, para el modelo con el que mejores resultados hemos conseguido, la evolución de
la precisión y la pérdida durante el entrenamiento.

#figure(
  image("/figures/grafico_modelo_base.png", width: 80%),
  caption: "Gráfica que representa la precisión y pérdida del modelo base durante el entrenamiento",
)<fig:grafica_modelo_base>
