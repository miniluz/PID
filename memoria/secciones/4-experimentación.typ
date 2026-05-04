= Experimentación
<sec:cuatro>

== Concreto selección hiperparámetros

Recapitulando en lo referente a la búsqueda de cuadrícula y la selección de hiperparámetros: se ha implementado manualmente una función que se encarga de hacer esta búsqueda de cuadrícula (@sec:busquedacuadricula2). También, como se dijo en la @sec:busquedacuadricula, se ha hecho una búsqueda de rejilla siguiendo lo anteriormente definido.

Así, por ejemplo con los hiperparámetros de 
- 3 capas convolucionales
- 64 filtros de la primera capa de convolución
- 1 capas densas
- 512 nodos en la primera capa densa
nos quedaríamos con una red neuronal estructurada de la siguiente forma:

#figure(
  image("/figures/modelo_base.png", width: 80%),
  caption: "Esquema del modelo descrito, que es el modelo base",
)<fig:modelo_base>

/*
capa conv 64 kernel = (3,3)
capa maxpooling (pool size = (2,2))
capa conv 128 kernel = (3,3)
capa maxpooling (pool size = (2,2))
capa conv 256 kernel = (3,3)
capa maxpooling (pool size = (2,2))
capa GAP
capa densa 512 (relu)
capa densa 256 (relu)
capa densa de salida nº de géneros (sigmoide)
*/

Originalmente se tenía pensado realizar la búsqueda de cuadrícula con 2, 3 y 4 capas convolucionales. Sin embargo, tras 
notar el tiempo excesivo que se tardarían a entrenar todos los modelos, se decidió sólo entrenar modelos con 2 y 3 capas 
convolucionales.

== Definición de modelos

En esta sección se mostrará el código de tensorflow que se encarga de definir los diferentes modelos entrenados para así poder ver los
 detalles de estos con todos los parámetros.

=== Modelo base

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
        layers.Dense(256, activation='relu'),
        
        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
    ]
  )
  ```,
  caption: "Definición modelo base",
)<cod:python>

=== Modelo dropout

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

        layers.Dense(256, activation='relu'),
        layers.Dropout(0.4),

        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
    ]
  )
  ```,
  caption: "Definición modelo con dropout",
)<cod:python>

=== Modelo aumentación de datos

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
        layers.Dense(256, activation='relu'),
        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32'),
    ]
  )
  ```,
  caption: "Definición modelo con aumentación de datos",
)<cod:python>

=== Modelo normalización de lotes

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

        layers.Dense(256, activation=None),
        layers.BatchNormalization(),
        layers.ReLU(),

        layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
    ]
  )
  ```,
  caption: "Definición modelo con normalización de lotes",
)<cod:python>

=== Modelo decaimiento de pesos

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
    layers.Dense(256, activation='relu'),

    layers.Dense(len(genre_columns), activation='sigmoid', dtype='float32')
  ])

  model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3, weight_decay=weight_decay),
    loss='binary_crossentropy',
    metrics=['accuracy']
  )
  ```,
  caption: "Definición modelo decaimiento de pesos",
)<cod:python>


== Resultados obtenidos

Para facilitar la lectura de estos datos, hago referencia a la @sec:metricasvalidacion en la que se explican las distintas métricas usadas para la validación y evaluación de los modelos.

También me remito a la @sec:busquedacuadricula para explicar los nombres de los modelos. Sus nombres definen la estructura de este. 

La siguiente tabla recopila los resultados de todos los modelos obtenidos en la búsqueda de cuadrícula realizada para hallar los hiperparámetros del modelo base.

#include "../tables/tabla_resultados_metricas_cuadricula.typ"

La siguiente tabla recopila las métricas obtenidas de todos los modelos finales obtenidos a lo largo del proyecto (sin contar con los entrenados en la búsqueda en cuadrícula).

#include "../tables/tabla_resultados_metricas_finales.typ"

La siguiente gráfica representa, para el modelo con el que mejores resultados hemos conseguido, la evolución de la precisión y la pérdida 
durante el entrenamiento.

#figure(
  image("/figures/grafico_modelo_base.png", width: 80%),
  caption: "Gráfica que representa la precisión y pérdida del modelo base durante el entrenamiento",
)<fig:grafica_modelo_base>
