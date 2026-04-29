#set page(
  paper: "a4",
  margin: (top: 3cm, bottom: 2cm, left: 3cm, right: 3cm),
)
// Using standard serif text for an academic look
#set text(lang: "es", size: 11pt)
#set heading(numbering: "1.1")
#set math.equation(numbering: "1.")

// --- Abstract Function ---
#let abstract(body) = {
  set text(size: 0.9em)
  pad(x: 1cm, [
    #align(center)[*Resumen*]
    #body
  ])
}

// --- Title Section ---
#align(center)[
  #block(text(weight: "bold", size: 1.5em)[
    Introducción a las Redes Neuronales Convolucionales (CNN) con salida multilabel
  ])
  #v(1em)
  #text(size: 1.2em)[U. Autora, O. Autor ]
]

#abstract[
  Este documento presenta una introducción a las Redes Neuronales Convolucionales (CNN) con un enfoque en tareas de clasificación multilabel. Se describen los fundamentos matemáticos de las convoluciones, los hiperparámetros clave que afectan el rendimiento del modelo, y las funciones de activación comúnmente utilizadas. Además, se discuten las técnicas de pooling para la reducción de dimensionalidad y la mejora de la invariancia a traslaciones. Finalmente, se aborda el bloque final de clasificación en CNNs y su aplicación en problemas multilabel.

  #v(1em)
  *Palabras clave:* Procesamiento de Imágenes, Redes Neuronales, Aprendizaje Automático.
]

#include "secciones/1-introduccion.typ"
#include "secciones/2-background.typ"
#include "secciones/3-redes_multilabel.typ"

#bibliography("bibliografia.bib", style: "ieee")
