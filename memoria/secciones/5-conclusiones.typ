= Conclusiones
<sec:cinco>
Incluyen análisis de los resultados obtenidos y desviaciones en la planificación inicial.

== Resultados obtenidos

Para facilitar la lectura de estos datos, hago referencia a la @sec:metricasvalidacion en la que se explican las distintas métricas usadas para la validación y evaluación de los modelos.

También me remito a la @sec:busquedacuadricula para explicar los nombres de los modelos. Sus nombres definen la estructura de este. 

La siguiente tabla recopila los resultados de todos los modelos obtenidos en la búsqueda de cuadrícula realizada para hallar los hiperparámetros del modelo base.

#include "../tables/tabla_resultados_metricas_cuadricula.typ"

La siguiente tabla recopila las métricas obtenidas de todos los modelos finales obtenidos a lo largo del proyecto (sin contar con los entrenados en la búsqueda en cuadrícula).

#include "../tables/tabla_resultados_metricas_finales.typ"

== Análisis de resultados

El objetivo de este proyecto era verificar si aplicando diferentes técnicas a una red neuronal convolucional (creada para sacar los géneros de películas según sus portadas) se podrían mejorar sus resultados. Según las métricas que han sido definidas, *no*.

Con ninguna de las 4 técnicas probadas se han obtenido mejores resultados que con el modelo base. La efectividad de estos modelos ha sido 
peor generalmente que la del modelo base, en todas las métricas empeoran los resultados a excepción de la _exactitud binaria_.
Observando la exactitud binaria de otros modelos entrenados en la búsqueda de cuadrícula podemos ver que algunos también superan al modelo 
base en esta métrica. No consideramos que esta diferencia sea la suficiente como para deducir que ha sido una mejora, es decir, pensamos 
que estas diferencias en los resultados de la métrica de la exactitud binaria son consecuencia del puro azar del entrenamiento de los
 modelos.

=== Posibles causas

//TODO
Aún está por hacer, pero aquí investigar, intentar comprender lo que está pasando y por qué no ha mejorado el resultado (haciendo referencias bibliográficas preferiblemente).


== Desviaciones de lo planificado

A diferencia de lo planeado, se han acabado entrenando menos modelos de lo que se planeaba originalmente.

Esto a sido por dos motivos principales:
- El tamaño de la búsqueda de cuadrícula tuvo que ser recortado porque el entrenamiento tardaba más de lo previsto
- Se planeaba entrenar un modelo final aplicando todas las técnicas que diesen buenos resultados, pero como ninguna de las técnicas aplicadas ha mejorado ninguna métrica con respecto al modelo base, este último modelo ha sido omitido.