= Implementación

Los datos para el entrenamiento se obtienen de _The Movie Database_, una base de datos pública de películas que incluye
sus pósters y géneros.

Se deben describir las tecnologías, el diseño y los módulos principales. *Debe quedar clara la parte original y qué
librerías se han usado (ej. OpenCV)*.

== Selección de hiperparámetros 

La manera en la que vamos a seleccionar los diferentes hiperparámetros será usando grid search. Como vamos a entrenar diferentes modelos, cada uno necesitará unos hiperparámetros distintos.

Para ello, primero, sobre la red neuronal base sin técnicas aplicadas, haremos un grid search con valores que distan mucho de forma que podamos aproximar de forma general qué hiperparámetros funcionan. Estos valores "generales" de los hiperparámetros los guardaremos y los tendremos en cuenta para un segundo grid search. Este grid search se hará con valores cercanos a los hiperparámetros generales obtenidos anteriormente, y se aplicará a cada una de las redes neuronales que van a implementarse. A través de esto, podremos obtener unos hiperparámetros con precisión suficiente y ajustados a cada uno de los modelos.

