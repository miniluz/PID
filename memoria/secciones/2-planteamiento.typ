= Planteamiento teórico

== Redes neuronales artificiales

Una red neuronal artificial es un modelo computacional inspirado en el funcionamiento del sistema nervioso biológico.
Está formada por unidades de cómputo básicas denominadas neuronas o nodos, organizadas en capas y conectadas entre sí
mediante pesos aprendibles.

La pre-activación de un nodo es el producto escalar de sus entradas $x_1, x_2, dots, x_n$ con sus pesos
$w_1, w_2, dots, w_n$ más un sesgo $b$, y su activación (su salida) es el resultado de aplicar una función de activación
$sigma$ a la pre-activación: $sigma\(z\)$. Los pesos $w_i$ y el sesgo $b$ son los parámetros del nodo, y son lo que se
afina durante el entrenamiento.

$
  a = sigma\(w dot x + b\)
$

Una red neuronal básica se denomina un perceptrón multi-capa. Esta se compone de capas, donde cada capa está compuesta
de nodos que reciben de entrada la capa anterior. La primera capa es la entrada, y es parte de los datos de
entrenamiento, y la última capa es la salida. Las centrales se denominan capas ocultas. Cada salida de cada capa depende
de los valores de todas las salidas de la capa anterior, por lo que se también se denominan capas densas, ya que todos
los nodos de una capa están conectados a todos los de la siguiente.

Los valores de la red que se modifican durante el entrenamiento, como los pesos y sesgos, se denominan parámetros, y los
que no se modifican, como la cantidad de capas, la cantidad de neuronas por capa y las funciones de activación, se
denominan hiperparámetros. Generalmente, los hiperparámetros se determinan en base a trabajos previos, a la literatura,
a una aproximación de la complejidad del problema, y con experimentación.

Cada caso de entrenamiento tiene la entrada y la salida esperada. Para cada caso de entrenamiento:
+ Se realiza un _forward pass_ en el que cada capa se calcula en base a la anterior hasta llegar a la salida que da la
  red para la entrada.
+ Se calcula el error $cal(L)$ con la salida esperada (la función de error es un hiperparámetro).
+ Se calcula el gradiente (la derivada N-dimensional) del error respecto a los parámetros.
+ Se ajustan todos los pesos de todos los nodos en la dirección que minimiza el error según el gradiente, escalado por
  una tasa de aprendizaje $eta$ @rumelhart1986backprop. Esto se denomina retropropagación.

La actualización de un parámetro $theta$ es:
$
  theta <- theta - eta nabla_theta cal(L)
$

Otra alternativa es acumular el gradiente del error para una cierta cantidad de casos de entrenamiento (ej. $100$) antes
de actualizar los pesos. Ya que los pesos se actualizan con menos frecuencia, hay menos pausas para transferirlos a la
GPU, lo que resulta en más velocidad. Esto se denomina entrenamiento por mini-lotes.

El entrenamiento no tiene una longitud definida, aunque generalmente el error deja de disminuir después de cierto
tiempo. Una vez la red ha sido entrenada, se pueden guardar sus pesos para volver a usarla sabiendo su estructura,
aunque hay formatos de archivos que codifican la estructura como metadatos y son más simples de cargar.
/* TODO: ¿Cuales? PROPUESTA AGE:|Estos archivos pueden ser .h5, .onnx, o existe el modelo guardado de TensorFlow, que es una carpeta|*/ La red se usa de pasando la entrada para la que se quiere predecir una salida y leyendo la salida
después del _forward pass_. Esto se denomina inferencia.


La salida de una red neuronal (es decir su tamaño y función de activación) y la función de error $cal(L)$ se eligen de
acuerdo al tipo de problema que se busca solucionar. Algunos tipos de tareas y sus capas finales se pueden ver en la
@tabla_configuracion_capa_salida.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    [*Tarea*], [*Función de activación de salida*], [*Función de pérdida*],
    [Regresión], [Lineal], [Error cuadrático medio (MSE)],
    [Clasificación binaria], [Sigmoide], [Entropía cruzada binaria],
    [Clasificación multi-clase], [Softmax], [Entropía cruzada categórica],
    [Clasificación multi-etiqueta], [Sigmoide], [Entropía cruzada binaria por etiqueta],
  ),
  caption: [Configuración de la capa de salida según la tarea.],
)
<tabla_configuracion_capa_salida>

Por ejemplo, para hacer regresión lineal, se toman los valores de salida con la función de activación de identidad (es
decir, no se modifican), y se compara el error cuadrático medio con el valor esperado. Para hacer clasificación binaria,
se tiene un único nodo de salida con la función de activación sigmoide, que comprime el rango $(-inf,+inf)$ al rango
$(0,1)$. La cercanía a $0$ o $1$ determina la clase.

Nuestro problema es de clasificación multi-etiqueta. Esto significa que la salida es una lista de características
predeterminadas que la entrada puede tener o no tener, en este caso el género de la película. Si únicamente pudiese
tener una, sería un problema de clasificación multi-clase, pero como puede tener más de una, se considera
multi-etiqueta.

En este, se usa un nodo de salida por etiqueta posible, en este caso por género posible. Cada salida usa la función
sigmoide, igual que en la clasificación binaria, para tener un rango de $0$ a $1$. La proximidad a $0$ indica que la
entrada no posee esa etiqueta, y la proximidad a $1$ que sí. Como función de pérdida se usa la media de las entropías
cruzadas individuales @zhang2014multilabel:

$
  cal(L) = - 1 / C sum_(c=1)^C [y_c log hat(y)_c + (1 - y_c) log(1 - hat(y)_c)]
$


== Redes neuronales convolucionales

Una red neuronal convolucional (CNN) es un tipo de red neuronal especialmente eficiente para datos con estructura
espacial, como imágenes o señales. Se definen por usar convoluciones para calcular las activaciones de los nodos en
capas denominadas capas convolucionales, en lugar de o además del producto vectorial que usan las capas normales,
densas.

Técnicamente, nada impide usar una imagen como entrada en la red neuronal ya descrita. Se podría representar la
luminosidad de cada pixel de cada canal (cada color) como un valor de entrada. El problema es computacional: una imagen
a color relativamente pequeña (p. ej. $500 times 500$) tiene $750000$ valores de luminosidad distintos, por lo que la
segunda capa tendría esa cantidad de pesos y sesgos. Las capas convolucionales transforman la imagen en otra serie de
imágenes donde el valor de cada pixel únicamente se ve influenciado por su entorno, no todos (es decir, no son densas).
También reciben los $750000$ valores de entrada y generalmente una cantidad de valores de salida de tamaño similar, pero
_tiene muchos menos parámetros que aprender_ y calcular la salida es mucho más económico computacionalmente.

Las capas convolucionales están inspiradas en cómo los organismos biológicos ven. La idea es lograr reducir la imagen de
una cantidad enorme de píxeles a una serie de características representativas. Para conseguirlo, realizan convoluciones
con núcleos (_kernels_). Las convoluciones han sido usadas en el procesamiento de imágenes para identificar
características desde antes de las redes convolucionales, por ejemplo para la detección de bordes con el filtro de
Sóbel. La diferencia es que los pesos del núcleo, y por lo tanto las características que detectan, son aprendidos por la
red durante el entrenamiento. Las capas convolucionales van transformando una imagen de alta resolución en muchas
imágenes de menor y menor resolución, que con el entrenamiento pasan a codificar las características de la imagen
relevantes para conseguir la salida esperada.

Generalmente, la última capa convolucional se aplana (es decir, transforma de un tensor $H times W times C$ a un tensor
de una dimensión de longitud $H dot W dot C$) y se pasa a una serie de capas densas antes de llevar a la salida.

=== Capa convolucional

La capa convolucional recibe un tensor de imágenes de $H times W$ en $C$ canales, $bold(X) in RR^(H times W times C)$
(por ejemplo, $C = 3$ para una entrada de color). Aplica un banco de filtros $|bold(K)|$ con los núcleos $k$, cada uno
de tamaño $k_h times k_w times C$, a la entrada $bold(X)$. La activación de la salida para el filtro $k$ en la posición
$(i,j)$ es:
$y_(i,j,k) = sigma\(b_k + chevron.l bold(w)_k, bold(x)_(i,j) chevron.r\)$
Donde $chevron.l chevron.r$ es el operador de convolución.

La operación equivale a deslizar cada núcleo sobre la imagen y calcular el producto escalar en cada posición. Cada $k$
resulta en una imagen propia, por lo que aplicar el banco de filtros $bold(K)$ resulta en otro tensor de imágenes con
$|bold(K)|$ canales, $RR^(H' times W' times |bold(K)|$.

// TODO! Añadir imagen

Los hiperparámetros de la capa son:
- La cantidad de núcleos $|bold(K)|$
- El tamaño de los núcleos $k_h times k_w$
- El paso $S$, la cantidad de píxeles que se desplaza el núcleo. Un $S$ de $2$ equivale a un diezmado de la imagen con
  factor $2$ realizado sobre la imagen resultante.
- El relleno (_padding_) $P$ usado y su tipo. Para preservar la dimensión de la imagen, se han de añadir pixeles al
  borde para que el núcleo pueda operar en las esquinas.

=== Capa de pooling

Una capa de _pooling_ agrupa la información espacial en regiones locales, reduciendo la dimensión (es decir, la
resolución) de la capa. Se insertan en la red convolucional con el objetivo de ir reduciendo el tamaño de la imagen.

Una de las más comunes es la del promedio. Los hiperparámetros son el paso $S$ y el tamaño de la ventana $T$, aunque
generalmente coinciden. Cada $S$ pixeles, toma el promedio de la ventana de $T times T$ pixeles alrededor del
seleccionado y calculan el promedio/*PROPUESTA AGE: Toma el promedio y calculan el promedio? no sé si está bien redactado eso o es intencional*/, añadiendo un pixel a la salida. Otra muy común es la de máximo, que funciona de la
misma forma pero con el máximo de la ventana en lugar del promedio. Hacer pooling por máximo o promedio con $S = T = 2$
reduce a la mitad la resolución de la imagen.

Otro tipo es el _global average pooling_ o GAP. Este toma el promedio de todos los valores de la imagen por cada canal,
reduciendo un tensor de $H times W times C$ a un vector unidimensional de tamaño $C$. Elimina completamente la dimensión
espacial. Generalmente se usa como alternativa a aplanar la última capa. @aiman2021amended

// TODO! Cita PROPUESTA AGE: la he puesto ahi, es lo de aiman2021amended

=== Técnicas de regularización y normalización

==== Capa de normalización por lotes (_batch normalization_)

La normalización por lotes busca reducir la variabilidad de la pre-activación de los kernels. Reducir la variabilidad
acelera la convergencia y reduce la sensibilidad a la iniciación de pesos. Para hacerlo, se calculan la media
$mu_cal(B)$ y la varianza $sigma_cal(B)^2$ de la salida del kernel, y se usa para transformar la pre-activación antes de
aplicar la función de activación. Primero, aplican una transformación afín a los valores de forma que la media acabe en
0 y la varianza en 1. Posteriormente, para evitar las restricciones que tiene que la imagen siempre esté normalizada a
ese rango, aplica otra transformación afín simple con los parámetros aprendibles $gamma$ y $beta$. Este valor se pasa a
la función de activación.

$
  hat(z) = (z - mu_cal(B)) / sqrt(sigma_cal(B)^2 + epsilon)
  #h(2em)
  y = gamma hat(z) + beta
$

// TODO! Cita

==== Dropout

Consiste en que durante el entrenamiento, en cada caso de entrenamiento o mini-lote, se desactiva aleatoriamente una
fracción $p$ de nodos de una capa convolucional. Esto fuerza a la red a aprender representaciones redundantes y
robustas.

Ya que únicamente quedan $(1 - p)$ nodos en el entrenamiento, sus activaciones tienden a crecer por un factor de
$1 / (1-p)$. Para compensar esto, hay dos opciones:
- Se puede multiplicar la activación por $(1 - p)$ a posteriori en la inferencia, o
- Se puede multiplicar por $1 / (1 - p)$ a priori durante el entrenamiento.

El razonamiento de la segunda opción, denominada dropout invertido, es que al proveer ese escalado manualmente la red
aprende directamente los pesos apropiados para la inferencia. Esto significa que no hay que hacer un ajuste en la
inferencia y facilita realizar entrenamiento con otros parámetros, como por ejemplo cambiar el $p$.

El dropout también se puede aplicar a las capas convolucionales, desactivando canales enteros (o lo que es lo mismo,
algunos $k$ del banco de filtros $K$). Esto se denomina dropout espacial. La compensación se realiza de la misma manera.

// TODO! Cita


==== Decaimiento de pesos

Consiste en añadir la suma de los cuadrados de los pesos ($lambda sum_i w_i^2$) a la pérdida para desincentivar los
pesos grandes, tanto en las capas convolucionales como en las densas.

==== Aumentación de los datos

Consiste en aplicar transformaciones aleatorias (rotación, recorte, espejo, cambio de brillo, cambio de saturación,
etc.) a las imágenes durante el entrenamiento, aumentando artificialmente la diversidad del conjunto de datos y haciendo
a la red resistente a estas transformaciones.

/*
* No vale la pena mencionar esto si no lo usamos.

==== Arquitecturas CNN representativas

La evolución de las CNN ha estado marcada por arquitecturas que proponen soluciones a distintos problemas de
entrenamiento y capacidad:

- LeNet-5 #cite(<lecun1998gradient>): primera CNN exitosa para reconocimiento de dígitos escritos a mano. Introdujo los
  bloques convolución–pooling.
- AlexNet #cite(<krizhevsky2012imagenet>): ganadora de ImageNet 2012. Impulsó el uso de GPU, ReLU y dropout.
- VGG: demostró que apilar kernels $3 times 3$ pequeños es más eficiente que usar kernels grandes. // TODO! cita
- ResNet: introdujo las conexiones residuales (_skip connections_) que permiten entrenar redes de cientos de capas sin
  degradación del gradiente, gracias a la identidad de acceso directo: $bold(y) = cal(F)(bold(x)) + bold(x)$.
  // TODO! cita

*/

== Flujo de la red

// TODO: Sería bueno añadir una imagen

En resumen, el flujo de una red neuronal convolucional para tareas multi-etiqueta es:

+ Se toma de entrada la imagen, representada como un tensor $bold(X) in RR^(H times W times C)$.
+ Se extraen las características con el bloque de convolución, con el pooling haciendo que sean cada vez más abstractas.
+ Se transforma la salida convolucional en un vector compacto que codifica las características mediante flatten o global
  average pooling.
+ Se aplican capas ocultas densas.
+ Se aplica una capa densa de $|L|$ nodos de salida (número de etiquetas), donde cada nodo representa una etiqueta
  posible en el rango $(-inf, +inf)$.
+ Se aplica la función de activación sigmoide para reducir al rango $(0,1)$ (p. ej. $(0.01, 0.87, 0.2)$).

Luego, en el entrenamiento
+ Se calcula el error (media de entropías cruzadas individuales) de la salida obtenida con la salida esperada (p. ej.
  $(0, 1, 0)$).
+ Se realiza la retropropagación.

En la inferencia, se aplica un umbral $tau$ (ej. $tau = 0.5$), y se considera que la red tiene la etiqueta si la salida
del nodo correspondiente lo supera.

== Validación

El entrenamiento únicamente intenta reducir el error con los datos de entrenamiento. Pero una red con bajo error para
los datos de entrenamiento no tiene por qué ser efectiva en general. Por ejemplo, si la red es demasiado grande para la
cantidad de datos de entrenamiento, es posible que se sobreajuste a los datos de entrenamiento y su salida no sea
generalizable a entradas fuera de éstos. Por esto se suele reservar parte de los datos para la validación de la red,
datos que nunca se muestran en el entrenamiento. Para evaluar la efectividad de la red, se calculan métricas con estos
datos a la red en modo de inferencia, sin realizar retropropagación y aplicando el umbral $tau$, para medir su
efectividad. // TODO: falta cita

Las métricas que se usarán en este proyecto son:
- Exactitud binaria (binary accuracy): fracción de las etiquetas clasificadas correctamente, sobre todas las muestras y
  etiquetas (las que tiene y las que no).
- Coincidencia exacta (exact match ratio): fracción de muestras cuyas etiquetas han sido clasificadas correctamente en
  su totalidad.
- Precisión (precision): de todas las etiquetas que la red predijo como positivas, fracción que realmente lo eran.
- Exhaustividad (recall): de todas las etiquetas que realmente eran positivas, fracción que la red identificó
  correctamente.
- Puntuación F1 (F1 score): media armónica entre la precisión y exhaustividad.

La precisión, exhaustividad y puntuación F1 se pueden calcular en macro, que da el mismo peso a todas las etiquetas sin
importar su frecuencia, y micro, que las pondera según su frecuencia:
$
  P_"macro" = 1 / C sum_(c=1)^C "TP"_c / ("TP"_c + "FP"_c)
  #h(2em)
  R_"macro" = 1 / C sum_(c=1)^C "TP"_c / ("TP"_c + "FN"_c)
$

$
  P_"micro" = (sum_c "TP"_c) / (sum_c "TP"_c + sum_c "FP"_c)
  #h(2em)
  R_"micro" = (sum_c "TP"_c) / (sum_c "TP"_c + sum_c "FN"_c)
$

En ambos casos, la puntuación F1 es la media armónica:
$ F 1 = (2 dot P dot R) / (P + R) $

Se reportan tanto la micro como la macro ya que no es deseable que el modelo sea impreciso con etiquetas minoritarias
(p. ej. documental en comparación a acción).
