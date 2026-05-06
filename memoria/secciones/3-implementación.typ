= Implementación
<sec:tres>
Los datos para el entrenamiento se obtienen de _The Movie Database_, una base de datos pública de películas que incluye
sus pósters y géneros.

== Librerías y herramientas usadas

Estas son las principales librerías y herramientas que se han usado en la implementación de este proyecto:

- *TensorFlow*: esta es una librería open source creada por Google. Sirve para el _deep learning_ el _machine learning_, y permite entrenar, construir y desplegar redes neuronales. Nosotros la usamos concretamente para construir y entrenar la CNN.
- *Keras*: es una librería open sourceescrita en Python que se ejecuta sobre TensorFlow. Permite experimentar de manera eficiente y sencilla con redes de _deep learning_.
- *CUDA*: es una plataforma de computación paralela desarrollada por NVIDIA que permite acelerar el entrenamiento de modelos de deep learning. CUDA permite aprovechar las GPU para hacer que el entrenamiento sea mucho más eficiente. 
- *SciKit Learn*: es una librería de Python que proporciona herramientas para el análisis de datos y el aprendizaje automático. En el proyecto se ha usado principalmente para calcular las métricas que permiten evaluar los modelos.
- *Pandas*: es una librería de Python que permite la manipulación de datos. En el proyecto se usa para procesar los datos de entrada que recibirán las redes neuronales en forma de _DataFrame_.
- *Numpy*: es una librería de Python para el cálculo numérico. Se usa para manejo de arrays y otras operanciones variadas.
- *Matplotlib*: es una librería de Python para la creación de gráficos y visualizaciones. Concretamente, su módulo pyplot es muy útil y sencillo para implementar visualización de gráficos, y esa es la funcionalidad que se le da en el proyecto.
- *Jupyter*: es un entorno de desarrollo interactivo que permite crear y compartir documentos con código, ecuaciones, visualizaciones y texto. Permite un desarrollo muy cómodo ya que funciona por medio de celdas de código. Es muy útil a la hora del aprendizaje y también para algunos proyectos en particular, como es el caso de este proyecto. 
- *IpyKernel*: es un kernel de Jupyter que permite ejecutar código Python en el entorno de Jupyter.

== Selección de hiperparámetros 
<sec:busquedacuadricula>
la manera en la que se va a seleccionar los diferentes hiperparámetros será usando búsqueda en cuadrícula. esto servirá para refinar el modelo base sobre el que se irá aplicando las diferentes técnicas. al ser la búsqueda en cuadrícula muy pesada computacionalmente, se aplicará exclusivamente al modelo base en vez de también a cada modelo con sus técnicas.

Los hiperparámetros que vamos a variar son los siguientes: 
- Número de capas de convolución: 2 o 3.
- Número de filtros de la primera capa de convolución: 32 o 64.
- Número de capas densas: 1 o 2.
- Número de nodos de la primera capa densa: 256 o 512.

Por ejemplo, con los hiperparámetros de 
- 3 capas convolucionales.
- 64 filtros de la primera capa de convolución.
- 1 capas densas.
- 512 nodos en la primera capa densa.
resultaría la siguiente red neuronal red neuronal, como se ve en la @fig:modelo_base:
- Capa convolucional de 64 filtros.
- Capa convolucional de 128 filtros.
- Capa convolucional de 256 filtros.
- Capa densa de 512 neuronas.
- Capa densa de 256 neuronas.
- Capa densa de salida.

#figure(
  image("/figures/modelo_base.png", width: 80%),
  caption: "Esquema de un modelo que determinan ciertos hiperparámetros de la búsqueda en cuadrícula."
)<fig:modelo_base>

El número de filtros de las siguientes capas convolucionales tras la primera se irá doblando, y los nodos de la segunda capa densa será la mitad que la de la primera, si la hay.
Se dará un ejemplo concreto en la @sec_seleccion_hiperparametros.

Según las métricas que devuelva el modelo entrenado con cada una de las combinaciones de hiperparámetros usados, se seleccionará con el que tenga mejores resultados.

== Pasos del proyecto

En esta sección se describirán cada uno de los pasos llevados para la implementación a alto nivel.

=== Carga de datos

Primero de todo se preparan los datos. Se lee el CSV con todos los nombres de las películas (aunque no se usen en el entrenamiento),
los enlaces a las portadas y una serie de valores binarios que representan si la película es o no del género en cuestión. Se definen
también ciertas constantes como el tamaño de las imágenes, el tamaño del lote, el número máximo de épocas, y una semilla para asegurar
reproducibilidad. Por último se dividen los datos en un conjunto de entrenamiento y otro de validación.

=== Definición del modelo

Lo siguiente es definir el modelo. Para ello se implementa una función que facilita la creación del modelo, y que crea uno con las siguientes partes:

- Capa de entrada.
- Capas convolucionales. Tienen función de activación _ReLU_. Cada capa convolucional tiene el doble de filtros de la anterior, y entre cada una hay una capa de _MaxPooling_.
- Capa con GAP (_Global Average Pooling_). Esto sirve para reducir la dimensionalidad.
- Capas densas. Tienen función de activación _ReLU_. Cada capa densa tiene la mitad de filtros de la anterior.
- Capa de salida con función de activación sigmoide.

Por último se compila el modelo con el optimizador _Adam_ (@sec:adam), pérdida de entropía cruzada binaria, y siguiendo la métrica de precisión (_accuracy_).

=== Entrenamiento del modelo

A la hora de entrenar el modelo se implementa _early stopping_ mediante un _callback_ de TensorFlow.
Se define una función que realiza el entrenamiento del modelo ajustando automáticamente todo lo necesario,
además de mostrando información relevante como las épocas entrenadas y el valor final de la pérdida. 

=== Representación del modelo

En esta parte de la implementación se define una función que permite observar una gráfica que muestra la diferencia de la precisión entre el conjunto de entrenamiento y el de validación, y una segunda gráfica que muestra la diferencia de la pérdida entre esos mismos conjuntos. 

=== Métricas de evaluación

Para evaluar la efectividad de un modelo no son suficientes la precisión y la pérdida. Para ello se implementa una función que, dado un modelo, imprime las métricas de validación definidas en la @sec:metricasvalidacion.

=== Búsqueda en cuadrícula o rejilla
<sec:busquedacuadricula2>
Para maximizar la efectividad del modelo base sobre el que partiremos para aplicar las distintas técnicas, se ha hecho una búsqueda en cuadrícula.
Esta sigue lo definido en la @sec:busquedacuadricula. La funcionalidad de la búsqueda en cuadrícula se ha implementado manualmente para poderla entender
y controlar de mejor manera (es decir, no se ha usado una función existente de una librería). Esto ha permitido guardar los resultados (las métricas
de validación) de cada uno de los modelos probados con diferentes combinaciones de hiperparámetros en ficheros de texto.


