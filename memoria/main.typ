#set page(
  paper: "a4",
  margin: (top: 3cm, bottom: 2cm, left: 3cm, right: 3cm),
)

#set text(lang: "es", size: 11pt)
#set par(justify: true)
#set heading(numbering: "1.1")
#set math.equation(numbering: "1.")

#let abstract(body) = {
  set text(size: 0.9em)
  pad(x: 1cm, [
    #align(center)[*Resumen*]
    #body
  ])
}

#align(center)[
  #block(text(weight: "bold", size: 1.5em)[
    Juzgando por la portada: predicción de géneros de una película con su póster
  ])
  #v(1em)
  #text(size: 1.2em)[J. Milá de la Roca, Á. Sánchez, C. Martinez]
]

#abstract[
  En este trabajo se investiga cómo de efectiva puede ser una red neuronal convolucional (o CNN) a la hora de predecir
  los géneros de una película a partir de su portada. Esto se denomina un problema de clasificación multi etiqueta, ya
  que una pelíucla puede tener varios géneros simultáneamente. Para ello, se han entrenado distintos modelos aplicando
  diferentes técnicas para mejorar su eficacia. Para el entrenamiento de los modelo se ha usado una base de datos con
  más de 400.000 entradas. Todo esto se ha hecho apoyandose en una base teórica que se desarrolla en esta misma memoria.
  Al final de la memoria se encuentra unas conclusiones y análisis de los resultados. Por último, también se ha
  desarrollado una interfaz con la que probar de forma sencilla los modelos finales.

  #v(1em)
  *Palabras clave:* Redes neuronales convolucionales (CNN), clasificación multi-etiqueta, aprendizaje profundo, pósters
  de películas, TensorFlow, normalización por lotes, dropout, aumentación de datos, decaimiento de pesos, búsqueda de
  cuadrícula, pooling, capa densa, parada temprana, entrenamiento, validación, métricas.
]

#include "secciones/1-introducción.typ"
#include "secciones/2-planteamiento.typ"
#include "secciones/3-implementación.typ"
#include "secciones/4-experimentación.typ"
#include "secciones/5-conclusiones.typ"
#include "secciones/6-anexo.typ"
//#include "secciones/ejemplos_bórrame.typ"

#bibliography("bibliografía.bib", style: "ieee")
