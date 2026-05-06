= Conclusiones
<sec:cinco>
Incluyen análisis de los resultados obtenidos y desviaciones en la planificación inicial.

== Análisis de resultados

El objetivo de este proyecto era verificar si aplicando diferentes técnicas a una red neuronal convolucional (creada para sacar los 
géneros de películas según sus portadas) se podrían mejorar sus resultados. Según las métricas que han sido definidas, *no*.

Con ninguna de las 4 técnicas probadas se han obtenido mejores resultados que con el modelo base. La efectividad de estos modelos ha sido 
peor generalmente que la del modelo base, en todas las métricas empeoran los resultados a excepción de la _exactitud binaria_.
Observando la exactitud binaria de otros modelos entrenados en la búsqueda de cuadrícula podemos ver que algunos también superan al modelo 
base en esta métrica. No consideramos que esta diferencia sea la suficiente como para deducir que ha sido una mejora, es decir, pensamos 
que estas diferencias en los resultados de la métrica de la exactitud binaria son consecuencia del puro azar del entrenamiento de los
 modelos.

=== Posibles causas

En esta sección se investigan y analizan posibles motivos por el que ninguna de las técnicas aplicadas ha mejorado los resultados con respecto 
al modelo base. Se analizará cada una de ellas por separado. También se compara el resultado de la métrica _f1_macro_ con el modelo base ya que consideramos que 
es buena a la hora de reflejar la efectividad de nuestros modelos.

==== Dropout

*f1_macro: (base) 0.1606 -> 0.1008*

Tomando en cuenta que los modelos pequeños han dado peores resultados como hemos visto en la búsqueda de rejilla, es posible que
al desactiavr neuronas con el dropout el modelo carezca de la capacidad y o complejidad suficiente como para aprender a clasificar 
correctamente las portadas de películas. Concretamente, como el dropout también afecta a la capa densa, que es muy relevante a la hora de 
clasificar, puede que cause peor rendimiento general del modelo.

==== Aumentación de datos

*f1_macro: (base) 0.1606 -> 0.1258*

Como se ha explicado anteriormente, la aumentación de datos consiste en aplicar transformaciones a los datos de entrada, es decir, a las
imágenes de los posters. Puede que al aplicar cambios de brillo y simetría especular se pierdan algunos rasgos de estas imágenes que son
 importantes a la hora de predecir sus géneros.

Pongamos por ejemplo una película que sea de terror, es probable que tenga una portada con colores oscuros mayoritariamente. Al hacer que 
el brillo de la portada sea superior, la red neuronal no va a detectar los caraterísticos tonos oscuros en la portada y entonces es menos 
probable que deduzca que es de terror. Fuera de este ejemplo de película de terror tanto el brillo como la simetría especular pueden 
afectar de formas distintas empeorando así los resultados.

==== Normalización de lotes

*f1_macro: (base) 0.1606 -> 0.1004*

Tras investigar, no se ha podido llegar a una teoría sólida de por qué la normalización por lotes ha afectado negativamente al modelo base.
Sin embargo, opciones que se han barajado han sido que la normalización de lotes afecte a cómo se captan los detalles de las imágenes y que 
el mal resultado del modelo es fruto de la aleatoriedad del entrenamiento.

==== Decaimiento de pesos

*f1_macro: (base) 0.1606 -> 0.1411*

El decaimiento de pesos, como su nombre indica, consiste en reducir pesos que son grandes. Esto se hace para evitar sobreajuste a los 
datos de entrenamiento, pero puede ser que al hacerlo el modelo ignore o no valore lo suficiente algunos patrones en particular que puede 
que sean muy relevantes.



== Desviaciones de lo planificado

A diferencia de lo planeado, se han acabado entrenando menos modelos de lo que se planeaba originalmente.

Esto a sido por dos motivos principales:
- El tamaño de la búsqueda de cuadrícula tuvo que ser recortado porque el entrenamiento tardaba más de lo previsto. Se pretendía probar con 2, 3, y 4 capas convolucionales, pero sólo se ha hecho con 2 y 3.
- Se planeaba entrenar un modelo final aplicando todas las técnicas que diesen buenos resultados, pero como ninguna de las técnicas aplicadas ha mejorado ninguna métrica con respecto al modelo base, este último modelo ha sido omitido.