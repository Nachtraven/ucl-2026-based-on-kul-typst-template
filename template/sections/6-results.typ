
= Results
== Data annotation for evaluation

As mentioned, the user is expected to place vessel, background and outside-of-volume points. These act as points used to define hyperparameters of the algorithms, but also as a performance metric: when the pipeline is run, feedback is given with how many vessel points are correctly classified. However this method of performance evaluation has shotcomings: it evaluates the data in a pointwise fashion, ignoring critical elements for downstream tasks such as connectivity, and relies on the human evaluating a 2D plane, ignoring parameters such as gap filling. As users also place points generally towards the center of the vessels, there is little measurement of the width of vessels beyond if a background point ends up being caught in the vessel prediction.

#linebreak()
As a result, it was decided to provide more dense annotations in the form of fully annotated regions taken from different scans: a script was written to subsample large scans into 8x8x8 regions, from which, for each scan, three subregions were selected, one at each distance step from the center. This method was chosen as it guarantees uniform scaling, easily loadable and feasibly annotatable scans, and offers a good perspective on algorithm performance.


#let image-with-grid(path, colour, label) = block(width: 35%, height: auto)[
  #set align(center)// + horizon)
  #layout(size => {
    let img-width = size.width
    let img-height = size.width// * (2 / 3)

    box(width: img-width, height: img-height, clip: true)[
      #image(path, width: 100%, height: 100%, fit: "cover")

      // Horizontal lines
      #for i in range(1, 9) {
        place(left + top,
          dy: i * img-height / 8 - 0.4pt,
          line(length: img-width, stroke: 0.6pt + colour)
        )
      }

      // Vertical lines
      #for i in range(1, 9) {
        place(left + top,
          dx: i * img-width / 8 - 0.4pt,
          line(length: img-height, angle: 90deg, stroke: 0.6pt + colour)
        )
      }

      #place(bottom + right,
        dx: -0.4em, dy: -0.4em,
        box(
          fill: rgb(0, 0, 0, 160),
          inset: (x: 0.4em, y: 0.2em),
          radius: 2pt,
          text(fill: white, size: 9pt, weight: "bold")[#label],
        ),
      )
    ]
  })
]

#v(0.4cm)
#figure(
  stack(
    spacing: 0.6em,
    image-with-grid("../../resources/images/ca-ru-r_0864.jpg", red, "CA-RU-R"),
    // grid(
    //   columns: (1fr, 1fr),
    //   column-gutter: 0.6em,
    //   image-with-grid("../../resources/images/ca-ru-r_0864.jpg", red, "CA-RU-R"),
    // ),
  ),
  caption: [Grid subsample of a tumor for annotation. TODO: make this clearer and detail data distribution],
) <Annotation_grid>
#v(0.5cm)



== Performance results

Using the loss functions from 3D Slicer:

Using our own script on the 3D Slicer exported data: discuss the performance using DICE, clDICE, and skeletonization



// = Ablation and simplification

// == Motivation: performance limits at scale <performance_and_memory>
//    [the data management + performance content, compressed]

// == Ablation methodology
//    [how you set probability-map weights to zero, what you measured]

// == Findings
//    [the table, with the key insight: Frangi alone delivers 
//     nearly the same point-wise accuracy as the full pipeline,
//     at a fraction of the runtime and memory cost]

// == Implications
//    [what gets kept (Frangi), what gets cut (random forest, 
//     marching squares for vessel growth, complex probability stacking),
//     and what new problems remain (false positives, small-vessel 
    // handling, evaluation methodology) — preview of Chapter 3


