#import "@preview/cetz:0.5.2": canvas, draw

// Single 2D heatmap of vessel length (x) vs volume (y) for one method/variant.
// Place multiple calls in a grid() to compare methods side by side.

#let vessel-heatmap(
  csv-path,
  // --- Filter ---
  method:         "pipeline",
  variant:        "default",      // "" or none matches rows with empty variant
  title:          none,           // optional panel title
  // --- Columns ---
  x-col:          "length_mm",
  y-col:          "volume_voxels",
  method-col:     "method",
  variant-col:    "variant",
  // --- Axes ---
  x-min:          none,           // auto if none
  x-max:          none,
  y-min:          none,
  y-max:          none,
  x-log:          true,
  y-log:          true,
  x-label:        "Vessel length (log mm)",
  y-label:        "Vessel volume (log voxels)",
  // --- Bins ---
  x-bins:         25,
  y-bins:         25,
  // --- Colour scale ---
  colour-min:     0,              // density value mapped to lightest colour
  colour-max:     none,           // density value mapped to darkest; auto if none
  colour-low:     rgb("#f0f4f8"), // lightest (empty / low density)
  colour-high:    rgb("#003f5c"), // darkest  (peak density)
  // --- Layout ---
  cell-size:      8pt,            // size of each heatmap cell
  axis-colour:    rgb("#555"),
  tick-size:      7pt,
  n-x-ticks:      5,
  n-y-ticks:      5,
) = {
  let data = csv(csv-path)
  let hdrs = data.at(0)
  let rows = data.slice(1)

  let xi  = hdrs.position(h => h == x-col)
  let yi  = hdrs.position(h => h == y-col)
  let mi  = hdrs.position(h => h == method-col)
  let vi  = hdrs.position(h => h == variant-col)

  // Filter rows to the requested method/variant
  let filtered = rows.filter(r => {
    let m = r.at(mi)
    let v = r.at(vi)
    let v-match = if variant == "" or variant == none {
      v == "" or v == none
    } else { v == variant }
    m == method and v-match
  })

  if filtered.len() == 0 {
    return text(fill: red)[No data for #method / #variant]
  }

  let xs = filtered.map(r => float(r.at(xi))).filter(v => v > 0)
  let ys = filtered.map(r => float(r.at(yi))).filter(v => v > 0)

  let safe-min(vals, fallback) = {
    let pos = vals.filter(v => v > 0)
    if pos.len() == 0 { fallback } else { calc.min(..pos) }
  }

  let ax-xmin = if x-min != none { x-min } else { safe-min(xs, 0.001) }
  let ax-xmax = if x-max != none { x-max } else { calc.max(..xs) * 1.1 }
  let ax-ymin = if y-min != none { y-min } else { safe-min(ys, 1.0) }
  let ax-ymax = if y-max != none { y-max } else { calc.max(..ys) * 1.1 }

  // Bin index helpers (linear or log)
  let bin-idx(val, vmin, vmax, n, use-log) = {
    if use-log {
      let lmin = calc.log(calc.max(vmin, 1e-9))
      let lmax = calc.log(calc.max(vmax, 1e-9))
      calc.min(n - 1, calc.max(0,
        int((calc.log(calc.max(val, 1e-9)) - lmin) / (lmax - lmin) * n)))
    } else {
      calc.min(n - 1, calc.max(0,
        int((val - vmin) / (ax-xmax - ax-xmin) * n)))
    }
  }

  // Build 2D count grid (flat array, row-major: y then x)
  let counts = range(x-bins * y-bins).map(_ => 0)
  for r in filtered {
    let xv = float(r.at(xi))
    let yv = float(r.at(yi))
    if xv <= 0 or yv <= 0 { continue }
    if xv < ax-xmin or xv > ax-xmax { continue }
    if yv < ax-ymin or yv > ax-ymax { continue }
    let bx = bin-idx(xv, ax-xmin, ax-xmax, x-bins, x-log)
    let by = bin-idx(yv, ax-ymin, ax-ymax, y-bins, y-log)
    let idx = by * x-bins + bx
    counts.at(idx) = counts.at(idx) + 1
  }

  let c-max = if colour-max != none { colour-max } else {
    calc.max(1, calc.max(..counts))
  }

  // Lerp between two rgb colours by t in [0,1]
  let lerp-colour(ca, cb, t) = {
  let t  = calc.min(1.0, calc.max(0.0, t))
  let ca = ca.components()
  let cb = cb.components()
  rgb(
    ca.at(0) * (1 - t) + cb.at(0) * t,
    ca.at(1) * (1 - t) + cb.at(1) * t,
    ca.at(2) * (1 - t) + cb.at(2) * t,
  )
}

  // Axis geometry
  let plot-w = cell-size * x-bins
  let plot-h = cell-size * y-bins
  let pad-left   = 40pt
  let pad-bottom = 30pt
  let pad-top    = if title != none { 18pt } else { 6pt }

  // Tick positions along an axis
  let axis-ticks(vmin, vmax, n, use-log) = {
    range(n + 1).map(i => {
      let t = i / n
      let val = if use-log {
        let lmin = calc.log(calc.max(vmin, 1e-9))
        let lmax = calc.log(calc.max(vmax, 1e-9))
        calc.pow(10.0, lmin + t * (lmax - lmin))
      } else {
        vmin + t * (vmax - vmin)
      }
      (t: t, val: val)
    })
  }

  let fmt-tick(v) = {
    if v >= 100  { str(int(calc.round(v, digits: 0))) }
    else if v >= 1   { str(calc.round(v, digits: 1)) }
    else if v >= 0.1 { str(calc.round(v, digits: 2)) }
    else             { str(calc.round(v, digits: 3)) }
  }

  block(
    width:  pad-left + plot-w + 6pt,
    height: pad-top  + plot-h + pad-bottom,
    clip:   false,
  )[
    #set align(left)

    // Title
    #if title != none {
      place(left + top,
        dx: pad-left + plot-w / 2 - 40pt, dy: 0pt,
        box(width: 80pt, align(center,
          text(size: 9pt, weight: "bold", fill: axis-colour)[#title]
        ))
      )
    }

    // Heatmap cells
    #for by in range(y-bins) {
      for bx in range(x-bins) {
        let cnt = counts.at(by * x-bins + bx)
        let t   = if c-max > colour-min {
          (cnt - colour-min) / (c-max - colour-min)
        } else { 0.0 }
        let col = lerp-colour(colour-low, colour-high, t)
        place(left + top,
          dx: pad-left + bx * cell-size,
          // y-axis: by=0 is bottom, flip so low values are at bottom
          dy: pad-top + (y-bins - 1 - by) * cell-size,
          rect(width: cell-size, height: cell-size, fill: col, stroke: none)
        )
      }
    }

    // X-axis ticks and labels
    #for tick in axis-ticks(ax-xmin, ax-xmax, n-x-ticks, x-log) {
      let px = pad-left + tick.t * plot-w
      place(left + top, dx: px, dy: pad-top + plot-h,
        line(start: (0pt, 0pt), end: (0pt, 3pt), stroke: 0.6pt + axis-colour)
      )
      place(left + top, dx: px - 10pt, dy: pad-top + plot-h + 4pt,
        box(width: 20pt, align(center,
          text(size: tick-size, fill: axis-colour)[#fmt-tick(tick.val)]
        ))
      )
    }

    // Y-axis ticks and labels
    #for tick in axis-ticks(ax-ymin, ax-ymax, n-y-ticks, y-log) {
      let py = pad-top + plot-h - tick.t * plot-h
      place(left + top, dx: pad-left - 0pt, dy: py - 0pt,
        line(start: (0pt, 0pt), end: (-3pt, 0pt), stroke: 0.6pt + axis-colour)
      )
      place(left + top, dx: 0pt, dy: py - 3pt,
        box(width: pad-left - 5pt, align(right,
          text(size: tick-size, fill: axis-colour)[#fmt-tick(tick.val)]
        ))
      )
    }

    // Axis lines
    #place(left + top, dx: pad-left, dy: pad-top,
      line(start: (0pt, 0pt), end: (0pt, plot-h), stroke: 0.8pt + axis-colour)
    )
    #place(left + top, dx: pad-left, dy: pad-top + plot-h,
      line(length: plot-w, stroke: 0.8pt + axis-colour)
    )

    // X-axis label
    #place(left + top,
      dx: pad-left + plot-w / 2 - 30pt,
      dy: pad-top + plot-h + 18pt,
      text(size: 8pt, fill: axis-colour)[#x-label]
    )

    // Y-axis label (rotated)
    #place(left + top,
      dx: -30pt,
      dy: pad-top + plot-h / 2 - 6pt,
      rotate(-90deg, text(size: 8pt, fill: axis-colour)[#y-label])
    )
  ]
}