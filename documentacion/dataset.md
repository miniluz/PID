# Dataset

## Introducción

Este proyecto consiste generalmente en crear una red neuronal que se entrene con posters de películas y sus respectivos géneros. Para entrenar una red neuronal de forma efectiva, es bien sabido que se necesitan muchos datos, por lo que en este documento describiré el proceso para abordar esta parte fundamental de proyecto.

## **Cómo obtener los datos**

Al incio habíamos planteado obtener todos los datos haciendo scraping de la página web de IMdb, que tiene muchísimos datos que nos interesan para el proyecto. Sin embargo, no mucho después de valorar esta opción se pensó que podríamos ahorrarnos el esfuerzo de hacer scraping si tan solo encontramos una API o un dataset que incluya la información que necesitamos.

Buscamos varias APIs diferentes, y hay algunas que iban bien y ofrecían lo que necesitábamos, pero tendrñiamos que sacar una key para usarla. Además de la key, otra desventaja que implicaba el uso de las APIs es que dependíamos de internet y de velocidad de carga, además de consultar constantemente la API para obtener los datos que necesitábamos. No creíamos que fuese la mejor opción.

Sin abandonar la idea de la API del todo, estuvimos buscando también datasets. Acabamos topándonos con que IMdb ofrecía datasets gratuitos para uso no profesional, sin embargo ningun de los datasets que ofrecían proporcionaban la información que ibamos a necesitar.

Chequeamos otros datasets por la web de Kaggle, principalmente datasets de OMdb y de TMdb (otras páginas web que recopilan películas), y acabamos encontrando uno que proporcionaba toda la información que necesitabamos, sin embargo era pequeño, teniendo sólo 5000 entradas. Consideramos que ese no era suficiente y segiumos buscando. Luego enontramos otro dataset que contenía más de 700.000 entradas y había salido de recopilar películas de TMdb. Era una buena cantidad, y nos estuvimos asegurando de que los datos que tenía eran los que necesitabamos. FInalmente nos quedamos con ese dataset.

## El dataset elegido

El dataset que consideramos que era correcto acabó siendo este: https://www.kaggle.com/datasets/akshaypawar7/millions-of-movies

Este dataset cuenta con un total de 20 columnas con diferentes datos, entre ellos el nombre, los géneros, y el poster. 

* Los nombres son simples cadenas de texto con el nombre en inglés.
* Los géneros están separados con un '-' para poder ser parseados.
* Los póster son terminaciones de urls que llevan a la imagen. Por ejemplo, en el dataset encontramos /gPbM0MK8CP8A174rmUwGsADNYKD.jpg, pero el enlace completo es **https://image.tmdb.org/t/p/w300_and_h450_face**/gPbM0MK8CP8A174rmUwGsADNYKD.jpg.

Este datast presenta dos pequeños problemas:

1. Es muy grande, teniendo un total de 722.317 entradas y 20 columnas, lo cual puede hacer que algunos tiempos de carga sean lentos. Pesa 350.65 MB, que es bastante.
2. Hay muchas entradas que no tienen la información que necesitamos. Un 29% de la columna de géneros tiene un valor nulo y un 26% de la columna de posters tiene un valor nulo.

Para abordar estos problemas hemos eliminado las columnas innecesarias haciendo que el archivo csv pese mucho menos y también vamos a excluir en el código las entrdas que tengan alguno de los dos valores nulos, asumiendo que con tantos datos seguirá siendo suficiente como para entrenar la red.
