#let sensitivity-xy-curve(
  curves,
  // --- Column selection (PR curve defaults) ---
  x-col:  "pred_gt_recall",
  y-col:  "pred_gt_precision",
  // --- Axis labels ---
  x-label: "Recall",
  y-label: "Precision",
  // --- Axis range (none = auto from data) ---
  x-min: none,
  x-max: none,
  y-min: none,
  y-max: none,
  // --- Sorting ---
  sort-by-x: true,        // set false if x is not monotone (e.g. threshold value)
  // --- Layout ---
  chart-width:  320pt,
  chart-height: 180pt,
  pad-left:     36pt,
  pad-bottom:   30pt,
  legend-width: 140pt,
  axis-colour:  rgb("#353535"),
  tick-size:    7pt,
  n-ticks:      10,
) = {
  let col-index(headers, name) = headers.position(h => h == name)

  let load-curve(path) = {
    let data    = csv(path)
    let headers = data.at(0)
    let rows    = data.slice(1)
    let xi = col-index(headers, x-col)
    let yi = col-index(headers, y-col)
    let pts = rows.map(r => {
      let xv = float(r.at(xi))
      let yv = float(r.at(yi))
      (xv, yv)
    })
    if sort-by-x { pts.sorted(key: pt => pt.at(0)) }
    else { pts }
  }

  let datasets = curves.map(c => (
    label:  c.label,
    colour: c.colour,
    points: load-curve(c.csv),
  ))

  // Compute axis bounds from data if not specified
  let all-x = datasets.map(d => d.points.map(p => p.at(0))).flatten()
  let all-y = datasets.map(d => d.points.map(p => p.at(1))).flatten()

  let ax-xmin = if x-min != none { x-min } else { calc.min(..all-x) }
  let ax-xmax = if x-max != none { x-max } else { calc.max(..all-x) }
  let ax-ymin = if y-min != none { y-min } else { calc.min(..all-y) }
  let ax-ymax = if y-max != none { y-max } else { calc.max(..all-y) }

  // Map data values to canvas coordinates
  let to-x(v) = pad-left + (v - ax-xmin) / (ax-xmax - ax-xmin) * chart-width
  let to-y(v) = chart-height * (1 - (v - ax-ymin) / (ax-ymax - ax-ymin))

  block(width: chart-width + pad-left + 10pt,
        height: chart-height + pad-bottom + 5pt)[
    #set align(left)

    // Grid and ticks
    #for i in range(n-ticks + 1) {
      let tx = ax-xmin + i * (ax-xmax - ax-xmin) / n-ticks
      let ty = ax-ymin + i * (ax-ymax - ax-ymin) / n-ticks

      // Vertical gridline + x tick
      place(left + top, dx: to-x(tx), dy: 0pt,
        line(start: (0pt, 0pt), end: (0pt, chart-height),
             stroke: 0.4pt + rgb("#ddd")))
      place(left + top, dx: to-x(tx) - 10pt, dy: chart-height + 4pt,
        box(width: 20pt, align(center,
          text(size: tick-size, fill: axis-colour)[
            #str(calc.round(tx, digits: if (ax-xmax - ax-xmin) > 10 { 0 } else { 1 }))
          ])))

      // Horizontal gridline + y tick
      place(left + top, dx: pad-left, dy: to-y(ty),
        line(length: chart-width, stroke: 0.4pt + rgb("#ddd")))
      place(left + top, dx: 0pt, dy: to-y(ty) - 5pt,
        text(size: tick-size, fill: axis-colour)[
          #str(calc.round(ty, digits: 2))
        ])
    }

    // Curves
    #for ds in datasets {
      let pts = ds.points
      for i in range(pts.len() - 1) {
        let (x0, y0) = pts.at(i)
        let (x1, y1) = pts.at(i + 1)
        place(left + top,
          dx: to-x(x0), dy: to-y(y0),
          line(
            start: (0pt, 0pt),
            end:   (to-x(x1) - to-x(x0), to-y(y1) - to-y(y0)),
            stroke: 1.2pt + ds.colour
          ))
      }
    }

    // Axes
    #place(left + top, dx: pad-left, dy: 0pt,
      line(start: (0pt, 0pt), end: (0pt, chart-height),
           stroke: 0.8pt + axis-colour))
    #place(left + top, dx: pad-left, dy: chart-height,
      line(length: chart-width, stroke: 0.8pt + axis-colour))

    // Axis labels
    #place(left + top,
      dx: pad-left + chart-width / 2 - 15pt,
      dy: chart-height + pad-bottom - 8pt,
      text(size: 8pt, fill: axis-colour)[#x-label])
    #place(left + top,
      dx: -18pt, dy: chart-height / 2 - 6pt,
      rotate(-90deg, text(size: 8pt, fill: axis-colour)[#y-label]))

    // Legend
    #place(left + top,
      dx: pad-left + chart-width - legend-width - 8pt,
      dy: 8pt,
      box(
        width: legend-width,
        fill: rgb(255, 255, 255, 200),
        inset: (x: 0.4em, y: 0.3em),
        radius: 2pt,
        stroke: 0.4pt + rgb("#ccc"),
        stack(dir: ttb, spacing: 0.4em,
          ..datasets.map(ds =>
            stack(dir: ltr, spacing: 0.4em,
              line(length: 12pt, stroke: 1.5pt + ds.colour),
              text(size: 8pt)[#ds.label]
            )
          )
        )
      )
    )
  ]
}