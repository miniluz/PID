#set table(fill: (_, y) => if y == 0 { yellow })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    // Anchura de cada columna. Se puede dar simplemente un número de columnas
    columns: (4cm, auto, auto, auto, auto, auto, auto, auto, auto),
    // Alineamiento del texto. El alineamiento puede ser horizontal u hor+ver
    align: (center, left, left, left, left, left, left, left, left),
    [Modelo], [Coincidencia exacta], [Precisión micro], [Exhaustividad micro], [F1 micro], [Precisión macro], [Exhaustividad macro], [F1 macro], [Exactitud binaria],
    [conv2 filters32 dense1 neurons256], [0.0235], [0.6010], [0.0300], [0.0571], [0.2364], [0.0144], [0.0260], [0.9157],
    [conv2 filters32 dense1 neurons512], [0.0838], [0.5897], [0.1014], [0.1730], [0.3670], [0.0415], [0.0659], [0.9179],
    [conv2 filters32 dense2 neurons256], [0.0912], [0.5871], [0.1174], [0.1957], [0.4400], [0.0540], [0.0815], [0.9181],
    [conv2 filters32 dense2 neurons512], [0.0937], [0.5864], [0.1117], [0.1877], [0.4969], [0.0551], [0.0838], [0.9180],
    [conv2 filters64 dense1 neurons256], [0.0759], [0.6016], [0.0847], [0.1484], [0.3727], [0.0369], [0.0610], [0.9175],
    [conv2 filters64 dense1 neurons512], [0.0928], [0.5917], [0.1071], [0.1814], [0.4676], [0.0471], [0.0729], [0.9179],
    [conv2 filters64 dense2 neurons256], [0.0955], [0.5878], [0.1202], [0.1995], [0.5438], [0.0486], [0.0760], [0.9182],
    [conv2 filters64 dense2 neurons512], [0.1277], [0.5969], [0.1566], [0.2482], [0.5161], [0.0767], [0.1136], [0.9197],
    [conv3 filters32 dense1 neurons256], [0.1496], [0.6004], [0.1915], [0.2903], [0.5188], [0.0911], [0.1327], [0.9126],
    [conv3 filters32 dense1 neurons512], [0.1436], [0.6155], [0.1837], [0.2829], [0.5140], [0.0953], [0.1392], [0.9142],
    [conv3 filters32 dense2 neurons256], [0.1228], [0.6249], [0.1466], [0.2375], [0.5209], [0.0751], [0.1150], [0.9129],
    [conv3 filters32 dense2 neurons512], [0.1506], [0.6307], [0.1789], [0.2788], [0.5389], [0.0922], [0.1368], [0.9102],
    [conv3 filters64 dense1 neurons256], [0.1407], [0.6008], [0.1760], [0.2723], [0.4818], [0.0903], [0.1304], [0.9117],
    [conv3 filters64 dense1 neurons512], [0.1694], [0.6224], [0.2054], [0.3088], [0.6372], [0.1106], [0.1606], [0.9157],
    [conv3 filters64 dense2 neurons512], [0.1494], [0.6162], [0.1824], [0.2815], [0.4889], [0.0893], [0.1328], [0.9141],
    [conv4 filters64 dense2 neurons512], [0.1304], [0.6364], [0.1504], [0.2434], [0.5682], [0.0775], [0.1158], [-],
  ),
  caption: "Resultados de los modelos entrenados en la búsqueda de cuadrícula",
)<table:resultados_metricas_cuadricula>