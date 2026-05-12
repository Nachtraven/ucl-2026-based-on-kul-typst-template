// --- Configuration ---
#let csv-data = csv("./results.csv")
#let headers = csv-data.at(0)
#let rows = csv-data.slice(1)

// Choose columns to plot and their display colours
#let series = (
  (col: "pred_gt_dice",   colour: rgb("#e63946"), label: "Pred/GT Dice"),
  (col: "thr_gt_dice",    colour: rgb("#457b9d"), label: "Thr/GT Dice"),
  (col: "pred_thr_dice",  colour: rgb("#2a9d8f"), label: "Pred/Thr Dice"),
)

#let x-col = "chunk"

// --- Helpers ---
#let col-index(name) = headers.position(h => h == name)

#let cell-val(row, name) = {
  let i = col-index(name)
  float(row.at(i))
}

// --- Layout constants ---
#let chart-width  = 420pt
#let chart-height = 180pt
#let bar-group-gap = 18pt
#let bar-gap       = 2pt
#let y-max         = 1.0
#let y-ticks       = (0.0, 0.25, 0.5, 0.75, 1.0)
#let axis-colour   = rgb("#555")
#let label-size    = 7pt
#let tick-size     = 7pt

#let n-groups = rows.len()
#let n-bars   = series.len()

#let group-width = (chart-width - bar-group-gap * (n-groups + 1)) / n-groups
#let bar-width   = (group-width - bar-gap * (n-bars - 1)) / n-bars

// --- Chart ---
#block(width: chart-width + 40pt, height: chart-height + 60pt)[
  #set align(left)

  // Y-axis ticks and grid
  #for tick in y-ticks {
    let y-pos = chart-height * (1 - tick / y-max)
    place(left + top,
      dx: 30pt,
      dy: y-pos,
      line(length: chart-width, stroke: 0.4pt + rgb("#ddd"))
    )
    place(left + top,
      dx: 0pt,
      dy: y-pos - 5pt,
      text(size: tick-size, fill: axis-colour)[#str(tick)]
    )
  }

  // Bars and x-axis labels
  #for (gi, row) in rows.enumerate() {
    let group-x = 30pt + bar-group-gap + gi * (group-width + bar-group-gap)
    let x-label = row.at(col-index(x-col))

    // X label
    place(left + top,
      dx: group-x + group-width / 2 - 20pt,
      dy: chart-height + 6pt,
      box(width: 40pt, align(center,
        text(size: label-size, fill: axis-colour)[#x-label]
      ))
    )

    // Bars
    for (bi, s) in series.enumerate() {
      let val     = cell-val(row, s.col)
      let bar-h   = chart-height * (val / y-max)
      let bar-x   = group-x + bi * (bar-width + bar-gap)
      let bar-y   = chart-height - bar-h

      place(left + top,
        dx: bar-x,
        dy: bar-y,
        rect(width: bar-width, height: bar-h, fill: s.colour, stroke: none)
      )
    }
  }

  // Axes
  #place(left + top,
    dx: 30pt, dy: 0pt,
    line(start: (0pt, 0pt), end: (0pt, chart-height), stroke: 0.8pt + axis-colour)
  )
  #place(left + top,
    dx: 30pt, dy: chart-height,
    line(length: chart-width, stroke: 0.8pt + axis-colour)
  )
]

// Legend
#stack(dir: ltr, spacing: 1em,
  ..series.map(s =>
    stack(dir: ltr, spacing: 0.4em,
      rect(width: 10pt, height: 10pt, fill: s.colour, stroke: none),
      text(size: 8pt)[#s.label]
    )
  )
)

#let chart_results1 = (
  (col: "pred_gt_recall",  colour: rgb("#e63946"), label: "Pred/GT Recall"),
  (col: "thr_gt_recall",   colour: rgb("#457b9d"), label: "Thr/GT Recall"),
)