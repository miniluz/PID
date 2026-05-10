= Anexo
<sec:anexo>

== Manual de uso de la demo

=== Detalles técnicos

Hay un front-end implementado como un único archivo HTML, usando Preact, Tailwind y DaisyUI para la interfaz. Permite
ejecutar los modelos localmente, usando la biblioteca onnx-runtime para ejecutarlos en el navegador. El archivo
`src/demo_template.html` es la plantilla del sitio web, y tiene comentarios como
`/* conv3_filters64_dense1_neurons512.onnx */` que la utilidad `scripts/fill_demo_template.py` con los modelos y la base
de datos de películas, guardándolo en `docs/demo.html`. Ambos son comprimidos para minimizar la cantidad de espacio que
ocupa la página, de más de 200 megabytes a tan solo 30. Para convertir los modelos del formato Keras al ONNX, se usa
`scripts/exportar_keras_a_onnx.py`. Los scripts se pueden ejecutar con `python scripts/archivo.py` dentro del `venv` del
proyecto.

=== Uso

La demo se puede ejecutar sencillamente abriendo el archivo `docs/demo.html` en el navegador. También se despliega
mediante GitHub Pages para que sea accesible desde el público, en la página #link(
  "https://blog.miniluz.dev/PID/demo.html",
). La interfaz de la demo se puede ver en la @fig:demo.

#figure(
  image("/figures/demo.png", width: 80%),
  caption: "La interfaz de la demo mostrando las predicciones de los modelos para Cars 3",
)<fig:demo>

Se puede usar el buscador para buscar el título de una película (en inglés), que le saldrá si se encuentra en la base de
datos usada para el entrenamiento y la evaluación. También puede subir cualquier imagen de cualquier resolución en
formatos comunes (JPEG, PNG, etc.). Una vez seleccionada la película e imagen, se ejecutará el modelo base en su
ordenador y cada modelo con una mejora sobre la imagen, y se mostrarán los resultados en una tabla. Si seleccionó una
película, podrá ver también los géneros que la base de datos considera que tiene la película. Se muestran los géneros
con la puntuación promedio que dan los modelos en orden descendiente, agrupando primero los que la base de datos
considera que tiene la película. Poniendo el cursor sobre los nombres de los modelos, podrá ver una breve descripción de
la técnica usada.

Cabe destacar que algunas de las funcionalidades que utiliza la demo únicamente está disponible en navegadores modernos.
Se recomienda usar una versión actualizada de Chrome o Firefox para maximizar la funcionalidad.

== GitHub

El enlace al repositorio de GitHub del proyecto es #link("https://github.com/miniluz/PID"). 

== Autoevaluación

*Ángel Sánchez Ruiz:*

#figure(
  table(
    columns: (auto, auto),
    align: (right, center),
    [Comprensión y dominio],                [0.65],
    [Exposición didáctica],                 [0.65],
    [Integración del equipo],               [1],
    [Objetivos],                            [0.65],
    [Aspectos didácticos],                  [1],
    [Experimentación y conclusiones],       [1],
    [Contenidos],                           [1],
    [Divulgación de los contenidos],        [0.65],
    [Bibliografía y recursos científicos],  [1],
  ),
  caption: "Autoevaluación Ángel",
)<table:autoevaluacion_angel>


*Javier Ignacio Milá de la Roca Dos Santos:*

#figure(
  table(
    columns: (auto, auto),
    align: (right, center),
    [Comprensión y dominio],                [],
    [Exposición didáctica],                 [],
    [Integración del equipo],               [],
    [Objetivos],                            [],
    [Aspectos didácticos],                  [],
    [Experimentación y conclusiones],       [],
    [Contenidos],                           [],
    [Divulgación de los contenidos],        [],
    [Bibliografía y recursos científicos],  [],
  ),
  caption: "Autoevaluación Javier",
)<table:autoevaluacion_javier>

*César Martínez Van Der Looven:*

#figure(
  table(
    columns: (auto, auto),
    align: (right, center),
    [Comprensión y dominio],                [0.65],
    [Exposición didáctica],                 [1],
    [Integración del equipo],               [1],
    [Objetivos],                            [1],
    [Aspectos didácticos],                  [1],
    [Experimentación y conclusiones],       [1],
    [Contenidos],                           [1],
    [Divulgación de los contenidos],        [0.65],
    [Bibliografía y recursos científicos],  [1],
  ),
  caption: "Autoevaluación César",
)<table:autoevaluacion_cesar>
