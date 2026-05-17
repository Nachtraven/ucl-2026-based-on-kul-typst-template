#import "@preview/cetz:0.3.2": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot

#let scatterpanel-chart(
  csv-path,
  x-col: "volume_voxels",
  y-col: "length_mm",
  group-col: "method",
  x-label: "X",
  y-label: "Y",
) = {
  let data = csv(csv-path)
  let hdrs = data.at(0)
  let rows = data.slice(1)

  let xi = hdrs.position(h => h == x-col)
  let yi = hdrs.position(h => h == y-col)
  let gi = hdrs.position(h => h == group-col)

  // Group rows by method
  let groups = (:)
  for row in rows {
    let g = row.at(gi)
    let pt = (float(row.at(xi)), float(row.at(yi)))
    if g in groups {
      groups.at(g).push(pt)
    } else {
      groups.insert(g, (pt,))
    }
  }

  // Shared axis limits across all panels
  let all-x = rows.map(r => float(r.at(xi)))
  let all-y = rows.map(r => float(r.at(yi)))
  let x-max = calc.max(..all-x) * 1.2
  let y-max = calc.max(..all-y) * 1.1

  let palette = (
    "ground_truth": rgb(0, 63, 92, 60),
    "threshold":    rgb(239, 83, 125, 60),
    "pipeline":     rgb(42, 157, 143, 60),
  )

  // Render one panel per group, side by side
  let group-names = groups.keys()
  let panel-width = 4.5

  grid(
    columns: group-names.len(),
    column-gutter: 0.6em,
    ..group-names.map(name => align(center)[
      #text(size: 9pt, weight: "bold")[#name (#groups.at(name).len())]
      #canvas({
        import draw: *
        plot.plot(
          size: (panel-width, 4.5),
          x-label: x-label,
          y-label: y-label,
          x-mode: "log",
          x-min: 1,
          x-max: x-max,
          y-mode: "log",
          y-min: 0.0035,
          y-max: y-max,
          {
            plot.add(
              groups.at(name),
              style: (stroke: none),
              mark: "o",
              mark-size: 0.08,
              mark-style: (
                fill: palette.at(name, default: rgb(120, 82, 155, 60)),
                stroke: none,
              ),
            )
          }
        )
      })
    ])
  )
}

#figure(
  scatterpanel-chart(
    "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
    x-label: "Vessel volume (voxels)",
    y-label: "Vessel length (mm)",
  ),
  caption: [Vessel volume vs length density by method for CA-LL-L1_498. The pipeline detects more vessels overall; the distribution shape shows whether they cover the same regions.]
)