#set table(fill: (_, y) => if y == 0 { yellow })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    // Anchura de cada columna. Se puede dar simplemente un número de columnas
    columns: (4cm, auto, auto, auto, auto, auto, auto, auto, auto),
    // Alineamiento del texto. El alineamiento puede ser horizontal u hor+ver
    align: (center, left, left, left, left, left, left, left, left),
    [Modelo], [Coincidencia exacta], [Precisión micro], [Exhaustividad micro], [F1 micro], [Precisión macro], [Exhaustividad macro], [F1 macro], [Exactitud binaria],
    [Modelo base], [0.1694], [0.6224], [0.2054], [0.3088], [0.6372], [0.1106], [0.1606],[0.9157],
    [Normalización de lotes], [0.1186], [0.5756], [0.1556], [0.2450], [0.4949], [0.0717], [0.1004],[0.9184],
    [Aumentación de datos], [0.1452], [0.6165], [0.1795], [0.2780], [0.5483], [0.0853], [0.1258],[0.9207],
    [Dropout], [0.1265], [0.6200], [0.1464], [0.2369], [0.4761], [0.0682], [0.1008],[0.9197],
    [Decaimiento de pesos], [0.1539], [0.6142], [0.1869], [0.2866], [0.5187], [0.0953], [0.1411],[0.9208],
  ),
  caption: "Resultados de los modelos entrenados aplicando distintas técnicas",
)<table:resultados_metricas_finales>
