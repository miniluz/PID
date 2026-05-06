= Introducción

¿Cuántas veces se ha dicho que no hay que juzgar un libro por su portada? La sabiduría popular advierte contra juzgar
por las apariencias. ¿Es siempre así?

El póster de una película indica en gran medida su contenido. Ha sido diseñado para ser la carta de presentación de la
película, para generar expectativas y dar una idea generalizada a su posible audiencia. Además de informar del título,
el director y los actores, aporta pistas sobre su atmósfera, tono y género.

Sin embargo, esta tarea no es trivial: un mismo póster puede evocar varios géneros simultáneamente, los estilos visuales
varían entre culturas y épocas, y la frontera entre géneros a menudo es difusa, a veces intencionalmente.
En ocasiones, hasta los humanos tenemos problemas con esta tarea. ¿Se podría entrenar un modelo computacional que lo
consiga?

La respuesta puede encontrarse en el aprendizaje automático. Las redes neuronales han demostrado ser útiles en muchos
dominios, y el uso de convoluciones ha permitido que revolucionen la visión artificial. En este trabajo se propone
entrenar una red neuronal convolucional (CNN) para realizar tal tarea de clasificación multi-etiqueta: identificar los
géneros de una película a partir de su póster.

A continuación, se introducen los objetivos del proyecto. Luego, se presentan en la @sec:dos las bases teóricas del
modelo propuesto, desde los perceptrones multicapa hasta las técnicas de regularización propias de las CNN.
Posteriormente, la @sec:tres aborda la implementación, las tecnologías que se usan y paso por paso cómo se ha implementado.
En la @sec:cuatro se especifican diferentes cosas relacionadas con el desarrollo del proyecto y se muestran los resultados concretos en tablas 
además de mostrar la definición con TensorFlow de los distintos modelos.
Finalmente la @sec:cinco cierra con las conlusiones del trabajo analizando los resultados y haciendo una restrospectiva de cambios en el 
desarrollo del trabajo.

== Objetivos

Los objetivos del proyecto son, en orden de prioridad descendiente:

+ Implementar un modelo base para la clasificación multi-etiqueta de los pósters mediante una red neuronal convolucional
  (CNN) que siga los diseños tempranos, en base a #cite(<book_deep_learning_goodfellow>).
+ Explicar las bases teóricas de las redes neuronales convolucionales y las técnicas usadas de forma accesible para un
  público técnico que únicamente conoce los perceptrones multicapa.
+ Entrenar la red neuronal con datos de entrenamiento obtenidos de _The Movie Database_, una base de datos pública de
  películas; en concreto, las que incluyen información tanto del póster como de los géneros (415.967 películas).
+ Evaluar experimentalmente las técnicas adicionales elegidas para ver si tienen un impacto positivo o negativo sobre las
  métricas elegidas. En concreto:
  - Capa de normalización por lotes (_batch normalization_)
  - _Dropout_
  - Decaimiento de pesos
  - Aumentación de datos
+ Diseñar y entrenar una red que combine las técnicas que han tenido un impacto positivo, y compararla con la original.
+ Crear una interfaz de usuario interactiva para el uso de los modelos.

