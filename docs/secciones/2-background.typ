= Antecedentes

En esta sección se revisan los fundamentos teóricos necesarios para comprender las redes neuronales convolucionales.
Se parte de los conceptos más generales de las redes neuronales artificiales y se profundiza en las particularidades
de las CNN: la estructura de tensores, las operaciones de cada tipo de capa y las funciones que las dotan de
capacidad de aprendizaje.

== Redes neuronales artificiales

Una red neuronal artificial es un modelo computacional inspirado en
el funcionamiento del sistema nervioso biológico. Está formada por unidades de cómputo básicas denominadas
neuronas o nodos, organizadas en capas y conectadas entre sí mediante pesos aprendibles.

=== Nodo o neurona

Un nodo es la unidad fundamental de procesamiento de una red neuronal. Recibe un conjunto de entradas
$x_1, x_2, dots, x_n$, las pondera con sus pesos $w_1, w_2, dots, w_n$, suma un sesgo $b$, y aplica una función de
activación $sigma$ para producir su salida:

$
a = sigma\(sum_(i=1)^n w_i x_i + b\)
$

Los pesos $w_i$ y el sesgo $b$ son los parámetros del nodo y se ajustan durante el entrenamiento.

=== Capas de una red neuronal

Una red neuronal se organiza en tres tipos de capas:

- *Capa de entrada (_input layer_)*: recibe los datos en crudo (por ejemplo, imágenes). No realiza ningún cálculo; simplemente introduce los valores al grafo computacional.
- *Capas ocultas (_hidden layers_)*: realizan transformaciones sucesivas de la representación. Cuanto más profunda es
  la red, más abstractas son las características aprendidas.
- *Capa de salida (_output layer_)*: produce la predicción final. Su función de activación y su dimensión dependen de
  la tarea (regresión, clasificación binaria, clasificación multiclase, etc.).

=== Función de activación

La función de activación introduce no linealidad en la red. Sin ella, la composición de capas lineales sería
equivalente a una única transformación lineal, limitando la capacidad expresiva del modelo.
Las funciones más utilizadas son:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    [*Nombre*], [*Expresión*], [*Uso habitual*],
    [Sigmoide],      [$sigma(z) = 1 \/ (1 + e^(-z))$],           [Salidas binarias],
    [Tanh],          [$tanh(z) = (e^z - e^(-z)) \/ (e^z + e^(-z))$], [Capas ocultas clásicas],
    [ReLU],          [$"ReLU"(z) = max(0, z)$],                   [Capas ocultas en CNN],
    [Leaky ReLU],    [$max(alpha z, z),  alpha << 1$],             [Alternativa a ReLU],
    [Softmax],       [$p_i = e^(z_i) \/ sum_j e^(z_j)$],          [Clasificación multiclase],
  ),
  caption: [Funciones de activación más comunes.]
)

=== Entrenamiento: propagación hacia atrás

El aprendizaje se realiza minimizando una función de pérdida $cal(L)$ mediante descenso de gradiente. El algoritmo
de backpropagation calcula el gradiente de $cal(L)$ respecto a cada parámetro aplicando la regla de la cadena #cite(<rumelhart1986backprop>).
La actualización de un parámetro $theta$ sigue la regla:

$
theta <- theta - eta nabla_theta cal(L)
$

donde $eta$ es la *tasa de aprendizaje* (_learning rate_).


== Tensores

Un tensor es una generalización algebraica de escalares, vectores y matrices a cualquier número de dimensiones:

- *Escalar* (rango 0): un único número, ej. $3.7$.
- *Vector* (rango 1): una secuencia de números, ej. $bold(x) in RR^n$.
- *Matriz* (rango 2): una tabla bidimensional, ej. $bold(W) in RR^(m times n)$.
- *Tensor de rango 3*: un bloque tridimensional, ej. $bold(T) in RR^(H times W times C)$. Es la representación
  habitual de una imagen con $H$ filas, $W$ columnas y $C$ canales de color.
- *Tensor de rango 4*: un lote (_batch_) de imágenes, ej. $bold(B) in RR^(N times H times W times C)$.

Los tensores son la estructura de datos central en los _frameworks_ de aprendizaje profundo (PyTorch, TensorFlow).
Todas las operaciones de la red (multiplicaciones matriciales, convoluciones, sumas) se expresan como operaciones
sobre tensores, lo que permite aprovechar el paralelismo masivo de las GPU.


== Redes neuronales convolucionales

Una red neuronal convolucional (CNN) es un tipo de red neuronal especialmente eficiente para datos con estructura espacial,
como imágenes o señales. Su característica definitoria es el uso de la operación de convolución en lugar de (o
además de) capas densas, lo que le permite:

- Detectar patrones locales independientemente de su posición en la imagen.
- Reducir drásticamente el número de parámetros mediante la compartición de pesos.
- Aprender representaciones jerárquicas: bordes → texturas → partes → objetos.

=== Capa convolucional

La capa convolucional aplica un banco de $K$ filtros (kernels) de tamaño $K_h times K_w times C$ a la entrada
$bold(X) in RR^(H times W times C)$. La activación de la salida para el filtro $k$ en la posición $(i,j)$ es:

$
y_(i,j,k) = sigma\(b_k + sum_(u=0)^(K_h - 1) sum_(v=0)^(K_w - 1) sum_(c=0)^(C-1) w_(u,v,c,k) dot x_(i+u, j+v, c)\)
$

La operación equivale a deslizar cada kernel sobre la imagen y calcular el producto escalar en cada
posición. El resultado es un mapa de características por cada filtro.

==== Hiperparámetros de la capa convolucional

- Tamaño del kernel ($K_h times K_w$): define el área de recepción local. Los más habituales son $3 times 3$ y
  $5 times 5$.
- Stride ($S$): desplazamiento del kernel en cada paso. Un stride mayor produce mapas de características más
  pequeños.
- Padding ($P$): píxeles añadidos al borde de la entrada para controlar el tamaño de salida. Con _same padding_ la
  salida tiene la misma resolución espacial que la entrada.
- Número de filtros ($K$): determina la profundidad del tensor de salida.

La dimensión espacial de salida se calcula como:

$
H_"out" = floor((H + 2P_h - K_h) / S_h) + 1, quad
W_"out" = floor((W + 2P_w - K_w) / S_w) + 1
$

=== Capa de normalización por lotes (_Batch Normalization_)

La normalización por lotes estandariza la activación de cada canal dentro de un _mini-batch_, acelerando la
convergencia y reduciendo la sensibilidad a la inicialización de pesos. Para una activación $z$:

$
hat(z) = (z - mu_cal(B)) / sqrt(sigma_cal(B)^2 + epsilon), quad y = gamma hat(z) + beta
$

donde $mu_cal(B)$ y $sigma_cal(B)^2$ son la media y varianza del _batch_, y $gamma$, $beta$ son parámetros
aprendibles.

=== Capas de pooling

Las capas de pooling agregan información espacial en regiones locales, reduciendo la dimensión y aportando
cierta invariancia a pequeñas traslaciones o deformaciones.

- Max pooling: selecciona el valor máximo de cada ventana. Conserva las características más prominentes.
- Average pooling: calcula la media de cada ventana. Produce una representación más suavizada.
- Global Average Pooling (GAP): colapsa todo el mapa de características a un único valor por canal,
  eliminando la dimensión espacial antes de la capa de clasificación.

Una operación de max pooling de $2 times 2$ con stride 2 reduce a la mitad la resolución espacial.

=== Capa densa o completamente conectada (_Fully Connected_)

Tras las capas convolucionales y de pooling, la representación se aplana (_flatten_) o se reduce con GAP y
se pasa a una o más capas densas. Cada nodo de una capa densa está conectado a todas las salidas de la capa
anterior y aprende combinaciones globales de las características extraídas. Estas capas son las encargadas de realizar la clasificación final o la regresión, dependiendo de la tarea.

=== Capa de salida y función de pérdida

La capa de salida adapta su dimensión y función de activación a la tarea:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    [*Tarea*], [*Activación de salida*], [*Función de pérdida*],
    [Clasificación binaria],    [Sigmoide],   [Entropía cruzada binaria],
    [Clasificación multiclase], [Softmax],    [Entropía cruzada categórica],
    [Clasificación multilabel], [Sigmoide],   [Entropía cruzada binaria por etiqueta],
    [Regresión],                [Lineal],     [Error cuadrático medio (MSE)],
  ),
  caption: [Configuración de la capa de salida según la tarea.]
)

Para clasificación multilabel, la red produce un vector de probabilidades independientes. La predicción de la
clase $c$ para la muestra $bold(x)$ es $hat(y)_c = sigma(z_c)$, y la pérdida total es la media de las entropías
cruzadas individuales, en línea con el marco general de aprendizaje multilabel #cite(<zhang2014multilabel>):

$
cal(L) = - 1/C sum_(c=1)^C [y_c log hat(y)_c + (1 - y_c) log(1 - hat(y)_c)]
$


=== Regularización

Para mejorar la generalización y evitar el sobreajuste se aplican diversas técnicas:

- Dropout: durante el entrenamiento, desactiva aleatoriamente una fracción $p$ de nodos de una capa. Fuerza a la
  red a aprender representaciones redundantes y robustas.
- Penalización $L_2$ (_weight decay_): añade $lambda sum_i w_i^2$ a la pérdida, desincentivando pesos de gran
  magnitud.
- Data augmentation: aplica transformaciones aleatorias (rotación, recorte, volteo, cambio de brillo, etc.) a las
  imágenes durante el entrenamiento, aumentando artificialmente la diversidad del conjunto de datos.

=== Arquitecturas CNN representativas

La evolución de las CNN ha estado marcada por arquitecturas que proponen soluciones a distintos problemas de
entrenamiento y capacidad:

- LeNet-5 #cite(<lecun1998gradient>): primera CNN exitosa para reconocimiento de dígitos escritos a mano.
  Introdujo los bloques convolución–pooling.
- AlexNet #cite(<krizhevsky2012imagenet>): ganadora de ImageNet 2012. Impulsó el uso de GPU, ReLU y dropout.
- VGG: demostró que apilar kernels $3 times 3$ pequeños es más eficiente que usar
  kernels grandes.
- ResNet: introdujo las conexiones residuales (_skip connections_) que permiten entrenar
  redes de cientos de capas sin degradación del gradiente, gracias a la identidad de acceso directo:
  $bold(y) = cal(F)(bold(x)) + bold(x)$.
