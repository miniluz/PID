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
    Juzgando por la porta: predicción de géneros de una película con su póster
  ])
  #v(1em)
  #text(size: 1.2em)[J. Milá de la Roca, Á. Sánchez, C. Martinez]
]

#abstract[
  El resumen debe tener como máximo 250 palabras y ser un único párrafo. Debe describir lo más fielmente posible el
  trabajo realizado.

  #v(1em)
  *Palabras clave:* PID, instrucciones, trabajo en grupo, imagen digital, CNN.
]

#include "secciones/1-introducción.typ"
#include "secciones/2-planteamiento.typ"
#include "secciones/3-implementación.typ"
#include "secciones/4-experimentación.typ"
#include "secciones/5-conclusiones.typ"
// #include "secciones/ejemplos_bórrame.typ"

#bibliography("bibliografía.bib", style: "ieee")
