= Implementación

Los datos para el entrenamiento se obtienen de _The Movie Database_, una base de datos pública de películas que incluye
sus pósters y géneros.

Se deben describir las tecnologías, el diseño y los módulos principales. *Debe quedar clara la parte original y qué
librerías se han usado (ej. OpenCV)*.

== Selección de hiperparámetros 

La manera en la que vamos a seleccionar los diferentes hiperparámetros será usando grid search. Como vamos a entrenar diferentes modelos, cada uno necesitará unos hiperparámetros distintos.

Los hiperparámetros que vamos a variar son los siguientes: 
-Número de capas de convolución. Usaremos 2, 3 y 4.
-Número de filtros de la primera capa de convolución. Usaremos 32 y 64.
-Número de capas densas. Usaremos 1 y 2.
-Número de nodos de la primera capa densa. Usaremos 256 y 512.

El número de filtros de las siguientes capas tras la primera se irá doblando, y los nodos de la segunda capa densa será la mitad que la de la primera.

Según las métricas que devuelva el modelo entrenado con cada una de las combinaciones de hiperparámetros usados, nos quedaremos con el mejor.


