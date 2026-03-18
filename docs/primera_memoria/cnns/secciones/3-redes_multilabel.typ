= Funcionamiento de una CNN con salida multilabel

En una CNN multilabel, una misma imagen puede pertenecer a varias clases al mismo tiempo. Por ejemplo, en una
escena pueden aparecer simultáneamente cielo, árbol y carretera. A diferencia de la clasificación multiclase,
las etiquetas no son excluyentes.

El flujo de procesamiento puede resumirse en las siguientes etapas:

1. Entrada: la imagen se representa como un tensor $bold(X) in RR^(H times W times C)$.
2. Extracción de características: bloques convolución + activación (normalmente ReLU) + pooling producen mapas de
  características cada vez más abstractos.
3. Agregación: mediante flatten o global average pooling se transforma la salida convolucional en un vector
  compacto de características.
4. Proyección final: una capa densa de tamaño $C$ (número de etiquetas) produce logits $bold(z) = (z_1, dots, z_C)$.
5. Activación sigmoide por etiqueta: cada logit se convierte en probabilidad independiente:
  $hat(y)_c = sigma(z_c)$.
6. Decisión por umbral: se asigna la etiqueta $c$ si $hat(y)_c >= tau$ (por ejemplo, $tau = 0.5$).

La diferencia clave respecto a *softmax* es que, con sigmoide, cada salida se interpreta de forma independiente.
En consecuencia, varias etiquetas pueden activarse de forma simultánea para una misma muestra.

== Qué aprende cada parte de la red

- Capas convolucionales iniciales: detectan patrones simples (bordes, texturas, orientación).
- Capas intermedias: combinan patrones locales en partes de objetos o estructuras más complejas.
- Capas profundas: capturan información semántica de alto nivel (presencia de conceptos visuales).
- Capa de salida multilabel: estima la probabilidad de presencia de cada etiqueta.

== Entrenamiento en multilabel

Para cada imagen se utiliza un vector objetivo binario $bold(y) in {0,1}^C$, donde $y_c = 1$ indica presencia de la
etiqueta $c$ y $y_c = 0$ su ausencia. El entrenamiento minimiza una pérdida de entropía cruzada binaria por etiqueta,
promediada sobre las $C$ salidas:

$
cal(L) = - 1/C sum_(c=1)^C [y_c log hat(y)_c + (1 - y_c) log(1 - hat(y)_c)]
$

Durante backpropagation, el gradiente de esta pérdida ajusta todos los pesos de la red para aumentar las
probabilidades de las etiquetas correctas y reducir las incorrectas.

== Inferencia y métricas habituales

En inferencia, la red devuelve probabilidades y después se aplica un umbral para obtener predicciones binarias.
Dado que cada etiqueta es independiente, se evalúa el modelo con métricas multilabel, por ejemplo:

- Binary accuracy: porcentaje de etiquetas individuales bien clasificadas.
- Exact match ratio: porcentaje de muestras con todas sus etiquetas correctas.
- Precision/Recall/F1 micro: métricas globales agregadas sobre todas las etiquetas.

Estas métricas son complementarias: una red puede tener buena binary accuracy y, sin embargo, bajo *exact match*
si falla en alguna etiqueta de muchas muestras.