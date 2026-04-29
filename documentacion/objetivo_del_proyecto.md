# Objetivo del proyecto

## Introducción

¿Cuántas veces nos han dicho que no hay que juzgar un libro por su portada? Que si no has consumido un libro, una peli, una serie, esa primera impresión que tienes no dice nada.

Bien, pues nosotros no creemos en esta tontería. La portada, o en este caso, poster de una película, es un gran indicador del contenido de esta. Un poster es una carta de presentación cuyo objetivo es darte una idea generalizada o proporcionarte unas expectativas sobre la película a la que pertenece. Esa es exactamente su función, de otra manera, el poster simplemente sería una imagene estandarizada que contendría el título de la película.

¿No nos crees? No pasa nada, en nuestro proyecto *Juzgando por la portada* precisamente vamos a demostrar esto mismo.

## ¿En qué consiste nuestro proyecto?

Para demostrar lo dicho anteriormente, vamos a entrenar una red neuronal convolucional con datos que permita indicar qué subgéneros y temáticas tiene la película exclusivamente a partir de su poster.

Una red neuronal convolucional (o CNN) es una arquitectura de deeplearning que sirve para procesar datos con información espacial como imágenes. Esto lo logra identificando patrones mediante capas de convolución, activación, y agrupación o pooling.

A lo largo de la CNN, un póster se va a ir descomponiendo, aplicando convoluciones (o filtrados) y pooling, de forma que la imagen va "destilandose" y manteniendo la información más valiosa. Esta información destilada de la imagen es la que se va a pasar a las neuronas que se encargarán de clasificar el póster.

A grandes rasgos, todo el proceso de divide en las siguientes fases:

1. Selección de imagen inicial
2. Preprocesamiento
3. Extracción de características de la imagen
4. Clasificación

Nosotros vamos a usar una CNN para resolver un problema llamado multi label classification. Como el nombre indica, vamos a clasificar una imagen pero no para identificar algo en particular de la imagen, sino para ponerle unas etiquetas en particular. Estas etiquetas tednrán cada una una neurona de salida que indicará la probabilidad de que la imagen tenga las características de esa etiqueta.

## Referencias

En el paper "A CNN–RNN architecture for multi-label weather recognition" (Bin Zhao, Xuelong Li, Xiaoqiang Lu & Zhigang Wang), se propone un modelo de CNN que, a través de una imagen, puede reconocer el tiempo climatológico que hace. Por ejemplo, si llueve, si hace sol... Sin embargo lo interesante es que el tiempo tiene más características, no tiene por qué hacer una u otra. Normalmente llueve Y está nublado, o puede hacer sol pero también haber nubes.

En otros proyectos similares se trataba el tiempo climatológico como un problema multi class. Esto es un error, ya que multi class implica que, de una selección de opciones, sólo va a tener una. Es cierto que esas opciones pueden ser lluvia y niebla (combinaciones de varios), pero no es la mejor manera de aproximar este problema.

La CNN usada extrae diferentes características de la imagen y, usando un módulo específico para ello, se decide qué partes de la imagen son importantes para cada una de las condiciones climatológicas. Además, usa un método un poco más complicado que se encarga de relacionar diferentes condiciones. Por ejemplo, es muy probable que si hay niebla no haya sol, entonces relaciona esas dos etiquetas y dificulta que en un resultado salgan juntas. Y viceversa, cuando llueve es muy probable que esté nublado, así que la probabilidad de una etiqueta afecta a la otra.

A diferencia que nosotros, los autores del paper no disponen de un dataset que les sirva, por lo que tuvieron que adaptar y expandir uno.

Por último, concluyen que los resultados obtenidos, mezclando una CNN, el módulo de atención, y la relación entre etiquetas (RNN)  devuelve muy buenos resultados en comparación a otros proyectos similares.

A pesar de que nuestro proyecto no va tan lejos, sí que se relaciona claramente, al resolver un problema igual, de multi label. Vamos a usar conceptos muy similares aplicados a posters de películas para obtener la información que deseamos.

## Objetivos

En el desarrollo del proyecto vamos a tener presentes unos objetivos finales que puedan medirse y sean realistas:

* Crear y entrenar una CNN funcional que pueda clasificar posters de películas según sus géneros.
* Maximizar sus resultados y documentar qué medidas hemos tomado para mejorarlos.
* Documentar todo el proceso de forma que quede claro todo lo que hemos hecho.
* Acompañar el proyecto con explicaciones que ayuden a darle una base teórica relacionada con la asignatura.
