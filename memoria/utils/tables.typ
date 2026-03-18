#let style-tables(doc) = {
  show table.cell.where(y: 0): set text(weight: "semibold")

  let frame(stroke) = (x, y) => (
    left: if x > 0 { 0.6pt + rgb("aaaaaa") } else { stroke },
    right: stroke,
    top: if y < 2 { stroke } else { 0pt },
    bottom: stroke,
  )

  set table(
    fill: (_, y) => if calc.odd(y) { rgb("eeeeee") },
    stroke: frame(1pt + rgb("21222C")),
  )

  doc
}
