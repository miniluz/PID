#set table(fill: (_, y) => if y == 0 { yellow })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    // Anchura de cada columna. Se puede dar simplemente un número de columnas
    columns: (4cm, auto, auto, auto, auto, auto, auto, auto, auto),
    // Alineamiento del texto. El alineamiento puede ser horizontal u hor+ver
    align: (center, left, left, left, left, left, left, left, left),
    [Modelo], [C.E.], [P. mic.], [E. mic.], [F1 mic.], [P. mac.], [E. mac.], [F1 mac.], [E. B.],
    [Modelo base], [0.1694], [0.6224], [0.2054], [0.3088], [0.6372], [0.1106], [0.1606],[0.9157],
    [Normalización por lotes], [0.0557], [0.5684], [0.0716], [0.1272], [0.2770], [0.0309], [0.0507],[0.9163],
    [Aumentación de datos], [0.1428], [0.6139], [0.1777], [0.2756], [0.5025], [0.0881], [0.1315],[0.9205],
    [Dropout], [0.1228], [0.6314], [0.1444], [0.2351], [0.5006], [0.0686], [0.1033],[0.9200],
    [Decaimiento de pesos], [0.1494], [0.6130], [0.1788], [0.2769], [0.5149], [0.0886], [0.1314],[0.9205], 
  ),
  caption: "Resultados de los modelos entrenados aplicando distintas técnicas",
)<table:resultados_metricas_finales>



   
   
   
   
   
   
    
   