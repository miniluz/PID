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
- *OpenCV*: es una librería open source de visión artificial (_Computer Vision_) que proporciona diferentes herramientas para el procesamiento de imágenes. Es la librería principal que se usa en la asignatura de Procesamiento de Imágenes Digitales. 
- *Numpy*: es una librería de Python para el cálculo numérico. Se usa para manejo de arrays y otras operanciones variadas.
- *Matplotlib*: es una librería de Python para la creación de gráficos y visualizaciones. Concretamente, su módulo pyplot es muy útil y sencillo para implementar visualización de gráficos, y esa es la funcionalidad que se le da en el proyecto.
- *Jupyter*: es un entorno de desarrollo interactivo que permite crear y compartir documentos con código, ecuaciones, visualizaciones y texto. Permite un desarrollo muy cómodo ya que funciona por medio de celdas de código. Es muy útil a la hora del aprendizaje y también para algunos proyectos en particular, como es el caso de este proyecto. 
- *IpyKernel*: es un kernel de Jupyter que permite ejecutar código Python en el entorno de Jupyter.

== Selección de hiperparámetros 

La manera en la que vamos a seleccionar los diferentes hiperparámetros será usando grid search. Esto servirá para refinar el modelo base sobre el que iremos aplicando las diferentes técnicas. Al ser la búsqueda de rejilla muy computacionalmente pesado, la aplicaremos exclusivamente al modelo base en vez de también a cada modelo con sus técnicas.

Los hiperparámetros que vamos a variar son los siguientes: 
- Número de capas de convolución. Usaremos 2 y 3.
- Número de filtros de la primera capa de convolución. Usaremos 32 y 64.
- Número de capas densas. Usaremos 1 y 2.
- Número de nodos de la primera capa densa. Usaremos 256 y 512.

El número de filtros de las siguientes capas tras la primera se irá doblando, y los nodos de la segunda capa densa será la mitad que la de la primera.

Según las métricas que devuelva el modelo entrenado con cada una de las combinaciones de hiperparámetros usados, nos quedaremos con el que tenga mejores resultados.


