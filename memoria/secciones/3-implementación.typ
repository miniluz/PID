= Implementación

Los datos para el entrenamiento se obtienen de _The Movie Database_, una base de datos pública de películas que incluye
sus pósters y géneros.

Se deben describir las tecnologías, el diseño y los módulos principales. *Debe quedar clara la parte original y qué
librerías se han usado (ej. OpenCV)*.


== Librerías y herramientas usadas

Estas son las principales librerías y herramientas que se han usado en la implementación de este proyecto:

- *TensorFlow*: esta es una librería open source creada por Google. Sirve para el _deep learning_ el _machine learning_, y permite entrenar, construir y desplegar redes neuronales. Nosotros la usamos concretamente para construir y entrenar la CNN.
- *Keras*: es una librería open sourceescrita en Python que se ejecuta sobre TensorFlow. Permite experimentar de manera eficiente y sencilla con redes de _deep learning_.
- *CUDA*: es una plataforma de computación paralela desarrollada por NVIDIA que permite acelerar el entrenamiento de modelos de deep learning. CUDA permite aprovechar las GPU para hacer que el entrenamiento sea mucho más eficiente. 
- *Scikit learn*: es una librería de Python que proporciona herramientas para el análisis de datos y el aprendizaje automático. En el proyecto se ha usado principalmente para calcular las métricas que permiten evaluar los modelos.
- *Pandas*: es una librería de Python que permite la manipulación de datos. En el proyecto se usa para procesar los datos de entrada que recibirán las redes neuronales en forma de _DataFrame_.
// TODO: borrar opencv si no lo usamos
- *OpenCV*: es una librería open source de visión artificial (_Computer Vision_) que proporciona diferentes herramientas para el procesamiento de imágenes. Es la librería principal que se usa en la asignatura de Procesamiento de Imágenes Digitales. 
- *Numpy*: es una librería de Python para el cálculo numérico. Se usa para manejo de arrays y otras operanciones variadas.
- *Matplotlib*: es una librería de Python para la creación de gráficos y visualizaciones. Concretamente, su módulo pyplot es muy útil y sencillo para implementar visualización de gráficos, y esa es la funcionalidad que se le da en el proyecto.
- *Jupyter*: es un entorno de desarrollo interactivo que permite crear y compartir documentos con código, ecuaciones, visualizaciones y texto. Permite un desarrollo muy cómodo ya que funciona por medio de celdas de código. Es muy útil a la hora del aprendizaje y también para algunos proyectos en particular, como es el caso de este proyecto. 
- *IpyKernel*: es un kernel de Jupyter que permite ejecutar código Python en el entorno de Jupyter.

== Selección de hiperparámetros 
<sec:busquedacuadricula>
La manera en la que se va a seleccionar los diferentes hiperparámetros será usando grid search. Esto servirá para refinar el modelo base sobre el que se irá aplicando las diferentes técnicas. Al ser la búsqueda en cuadrícula muy computacionalmente pesada, se aplicará exclusivamente al modelo base en vez de también a cada modelo con sus técnicas.

Los hiperparámetros que vamos a variar son los siguientes: 
- Número de capas de convolución. Usaremos 2 y 3.
- Número de filtros de la primera capa de convolución. Usaremos 32 y 64.
- Número de capas densas. Usaremos 1 y 2.
- Número de nodos de la primera capa densa. Usaremos 256 y 512.

El número de filtros de las siguientes capas tras la primera se irá doblando, y los nodos de la segunda capa densa será la mitad que la de la primera.

Según las métricas que devuelva el modelo entrenado con cada una de las combinaciones de hiperparámetros usados, nos quedaremos con el que tenga mejores resultados.

== Pasos del proyecto

En esta sección se describirán cada uno de los pasos llevados para la implementación a alto nivel.

=== Carga de datos

Primero de todo se preparan los datos. Se lee el CSV con todos los nombres de las películas (que no se usarán a la hora del entrenamiento, pero se ha decidido mantenerlos por conveniencia y comodidad), los enlaces a las portadas y una serie de valores binarios que representan si la película es o no del género en cuestión. Se definen también ciertos parámetros como el tamaño de las imágenes, el _batch size_, el número máximo de épocas, y una semilla para asegurar reproducibilidad. Por último se dividen los datos en un conjunto de entrenamiento y otro de validación.

=== Definición del modelo

Lo siguiente es definir el modelo. Para ello se implementa una función que facilita la creación del modelo, y que crea uno con las siguientes partes:

- Capa de entrada
- Capas convolucionales. Tienen función de activación _ReLU_. Cada capa convolucional tiene el doble de filtros de la anterior, y entre cada una hay una capa de _MaxPooling_.
- Capa con GAP (_Global Average Pooling_). Esto sirve para reducir la dimensionalidad.
- Capas densas. Tienen función de activación _ReLU_. Cada capa densa tiene la mitad de filtros de la anterior.
- Capa de salida. Al final se incluye una capa de salida con función de activación sigmoide.

Por último se compila el modelo con el optimizador _Adam_ (@sec:adam), pérdida de entropía cruzada binaria, y siguiendo la métrica de precisión (_accuracy_).

=== Entrenamiento del modelo

A la hora de entrenar el modelo se ha definido un _callback_, que es el _Early Stopping_ (@sec:earlystopping). Se implementa una función que facilita el entrenamiento del modelo ajustando automáticamente todo lo necesario, además de mostrando información relevante como las épocas entrenadas y el valor final de la pérdida. 

=== Representación del modelo

En esta parte de la implementación se define una función que permite observar una gráfica que muestra la diferencia de la precisión entre el conjunto de entrenamiento y el de validación, y una segunda gráfica que muestra la diferencia de la pérdida entre esos mismos conjuntos. 

=== Métricas de evaluación

Para ver cómo se efectivo podemos considerar un modelo, necesitamos más información que la precisión y la pérdida. Para ello se implementa una función que, dado un modelo, imprime las métricas de validación definidas en la @sec:metricasvalidacion.

=== Búsqueda en cuadrícula o rejilla

Para maximizar la efectividad del modelo base sobre el que partiremos para aplicar las distintas técnicas, se ha hecho una búsqueda en cuadrícula. Esta sigue lo definido en la @sec:busquedacuadricula. La funcionalidad de la búsqueda en cuadrícula se ha implementado manualmente para poderla entender y controlar de mejor manera. Esto nos ha permitido guardar los resultados (las métricas de validación) de cada uno de los modelos probados con diferentes combinaciones de hiperparámetros en ficheros de texto.


