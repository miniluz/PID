= Conclusiones
<sec:cinco>
Incluyen análisis de los resultados obtenidos y desviaciones en la planificación inicial.

== Análisis de resultados

El objetivo de este proyecto era verificar si aplicando diferentes técnicas a una red neuronal convolucional (creada
para sacar los géneros de películas según sus portadas) se podrían mejorar sus resultados. Según las métricas que han
sido definidas, *no*.

Con ninguna de las 4 técnicas probadas se han obtenido resultados generalmente mejores que con el modelo base. La
efectividad de estos modelos ha sido peor que la del modelo base, en todas las métricas empeoran los resultados a
excepción de la _exactitud binaria_ y, en el caso del dropout, la _precisión micro_ mejora un poco. Observando la
exactitud binaria de otros modelos entrenados en la búsqueda de cuadrícula podemos ver que algunos también superan al
modelo base en esta métrica. No consideramos que esta diferencia sea la suficiente como para deducir que ha sido una
mejora, es decir, pensamos que estas diferencias en los resultados de la métrica de la exactitud binaria son
consecuencia del puro azar del entrenamiento de los modelos.

=== Posibles causas

En esta sección se investigan y analizan posibles motivos por el que ninguna de las técnicas aplicadas ha mejorado los
resultados con respecto al modelo base. Se analizará cada una de ellas por separado. También se compara el resultado de
las métricas _f1_macro_ y _f1_micro_ con el modelo base ya que consideramos que es buena a la hora de reflejar la
efectividad de nuestros modelos.

Una red con mejor _macro_ funciona mejor para películas con cualquier etiqueta, una red con mejor _micro_ funciona mejor
con una película con etiquetas más comunes (las que más abunden en los datos de entrenamiento).

==== Dropout
Este modelo ha conseguido una puntuación *f1 macro* de 0.1033, que representa un empeoramiento del 36% en relación al
modelo base que consiguió una puntuación de 0.1606. Ha conseguido también una puntuación *f1 micro* de 0.2351, que
representa un empeoramiento del 24% en relación al modelo base que consiguió una puntuación de 0.3088.


Tomando en cuenta que los modelos pequeños han dado peores resultados como hemos visto en la búsqueda de rejilla, es
posible que al desactivar neuronas con el dropout el modelo carezca de la capacidad y o complejidad suficiente como para
aprender a clasificar correctamente las portadas de películas. Concretamente, como el dropout también afecta a la capa
densa, que es muy relevante a la hora de clasificar, puede que cause peor rendimiento general del modelo.

==== Aumentación de datos
Este modelo ha conseguido una puntuación *f1 macro* de 0.1315, que representa un empeoramiento del 18% en relación al
modelo base que consiguió una puntuación de 0.1606. Ha conseguido también una puntuación *f1 micro* de 0.2756, que
representa un empeoramiento del 11% en relación al modelo base que consiguió una puntuación de 0.3088.


Como se ha explicado anteriormente, la aumentación de datos consiste en aplicar transformaciones a los datos de entrada,
es decir, a las imágenes de los posters. Puede que al aplicar cambios de brillo y simetría especular se pierdan algunos
rasgos de estas imágenes que son importantes a la hora de predecir sus géneros.

Pongamos por ejemplo una película que sea de terror, es probable que tenga una portada con colores oscuros
mayoritariamente. Al hacer que el brillo de la portada sea superior, la red neuronal no va a detectar los caraterísticos
tonos oscuros en la portada y entonces es menos probable que deduzca que es de terror. Fuera de este ejemplo de película
de terror tanto el brillo como la simetría especular pueden afectar de formas distintas empeorando así los resultados.

==== Normalización de lotes
Este modelo ha conseguido una puntuación *f1 macro* de 0.0507, que representa un empeoramiento del 68% en relación al
modelo base que consiguió una puntuación de 0.1606. Ha conseguido también una puntuación *f1 micro* de 0.1272, que
representa un empeoramiento del 59% en relación al modelo base que consiguió una puntuación de 0.3088.

Tras investigar, no se ha podido llegar a una teoría sólida de por qué la normalización por lotes ha afectado
negativamente al modelo base. Es posible que esta técnica desincentive un comportamiento que en general es indeseable
pero que el modelo base usa para obtener mejores resultados, en este caso tener una variación muy grande de valores de
salida en una capa entre lotes. Sin embargo, puede que sea también la aleatoriedad del entrenamiento.

==== Decaimiento de pesos

Este modelo ha conseguido una puntuación *f1 macro* de 0.1314, que representa un empeoramiento del 18% en relación al
modelo base que consiguió una puntuación de 0.1606. Ha conseguido también una puntuación *f1 micro* de 0.2769, que
representa un empeoramiento del 10% en relación al modelo base que consiguió una puntuación de 0.3088.

Tras investigar, no se ha podido llegar a una teoría sólida de por qué el decaimiento de pesos ha afectado negativamente
al modelo base. Es posible que esta técnica desincentive un comportamiento que en general es indeseable pero que el
modelo base usa para obtener mejores resultados, en este caso tener pesos grandes. Sin embargo, puede que sea también la
aleatoriedad del entrenamiento.

== Desviaciones de lo planificado

A diferencia de lo planeado, se han acabado entrenando menos modelos de lo que se planeaba originalmente.

Esto a sido por dos motivos principales:
- El tamaño de la búsqueda de cuadrícula tuvo que ser recortado porque el entrenamiento tardaba más de lo previsto.
Se pretendía probar con 2, 3, y 4 capas convolucionales, pero sólo se ha hecho con 2 y 3.
- Se planeaba entrenar un modelo final aplicando todas las técnicas que diesen buenos resultados, pero como ninguna de
  las técnicas aplicadas ha mejorado ninguna métrica con respecto al modelo base, este último modelo ha sido omitido.

== Propuestas de mejora y extensión

Como no se ha logrado ningún modelo claramente mejor con ninguna de las técnicas, se podrían probar más técnicas. Esto
sería cuestión de investigar otras técnicas que encajen con lo que se pretende hacer en el proyecto y entrenar modelos
con esa técnica, viendo si mejora o no. Una vez se obtengan varios modelos que sí que mejoran, entonces hacer el modelo
combinado con las mejores técnicas que se pretendía crear al principio y analizar sus resultados.

Otro punto por donde se podría expandir el proyecto sería en el tamaño de la red. Los modelos entrenados han tardado
generalmente unas 2 horas, así que consideramos que el tamaño era apropiado. No obstante, con mejores recursos sería
posible entrenar redes más grandes y probar búsquedas de cuadrícula con más combinaciones de hiperparámetros de forma
que exploremos muchos más modelos, potencialmente encontrando un modelo con resultados aún mejores.

Por último, hay muchos dramas y muchos documentales en los datos de entrenamiento por lo que los modelos tienen a
predecir la mayoría de cosas como dramas y documentales. Se podría haber entrenado haciedo más probable que aparezcan
los géneros más raros para que no haya esta preferencia por los géneros comunes.

== Lecciones aprendidas

En este proyecto hemos podido ver la definición matemática de técnicas que sólo conocíamos a nivel general, y entender
cómo su comportamiento a grandes rasgos es el resultado de sus fórmulas. En particular, tener que comunicarlo de manera
didáctica y asequible nos ha ayudado a entenderlo en profundidad. Leer las fuentes nos ha ayudado a entender el tono
formal de estos documentos.

Otra lección es la importancia de tener un "plan B". En nuestro caso cometimos el error de contar con que al menos dos
de las técnicas aplicadas a los modelos iban a dar resultados claramente positivos para hacer el modelo definitivo, y al
no ser así no se pudo hacer. En particular, el error fue asumir que se darían ciertos resultados al planificar el
proyecto.

Conseguir un equilibrio entre distribuir las tareas para que cada uno tenga un área en la que es especialista y puede
trabajar más rápido y que todos tengan el contexto total del proyecto para dar un resultado cohesivo ha sido difícil,
aún siendo un grupo de sólo tres personas. Las sesiones de puesta en común, donde nos explicábamos lo que habíamos hecho
y pedíamos _feedback_ a los otros, ayudaban a que todos pensásemos críticamente sobre todo el proyecto.

Crear una demo fácil de usar para el público nos ha permitido compartir el proyecto con nuestros más gente, y permitir
subir cualquier imagen ayudó a difundirlo, dado el valor cómico de, por ejemplo, ver los géneros el modelo piensa que
representa una foto de un conocido. En general, la difusión científica es más fácil si tiene un gancho de interés
general al público.

