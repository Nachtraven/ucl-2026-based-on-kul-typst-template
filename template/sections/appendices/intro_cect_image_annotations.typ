// Image annotation helper

// ------------------------------------------------------------
// image-with-circles
//
// Draws one or more circles on top of an image. Each circle is
// specified as a dictionary:
//   (x: 50%, y: 50%, r: 8%, colour: red, thickness: 1.5pt)
//
//   x, y     — centre of the circle in % of image width/height
//              (0% = left/top edge, 100% = right/bottom edge)
//   r        — radius in % of image width
//   colour   — stroke colour (default: red)
//   thickness — stroke thickness (default: 1.5pt)
// ------------------------------------------------------------

#let image-with-circles(path, circles, label: none, label-colour: red) = block(
  width: 100%,
  breakable: false,
)[
  #set align(center + horizon)
  #image(path, width: 100%)
  #for c in circles {
    let cx = c.at("x")
    let cy = c.at("y")
    let cr = c.at("r")
    let col = c.at("colour", default: red)
    let th = c.at("thickness", default: 1.5pt)
    place(
      top + left,
      dx: cx,
      dy: cy,
      // The circle is drawn centred on (cx, cy), so we offset
      // by -r in both directions to centre it on the anchor.
      box(
        width: 0pt,
        height: 0pt,
        place(
          center + horizon,
          circle(
            radius: cr,
            stroke: col + th,
            fill: none,
          ),
        ),
      ),
    )
  }
  #if label != none {
    place(
      bottom + right,
      dx: -0.4em, dy: -0.4em,
      box(
        fill: rgb(0, 0, 0, 160),
        inset: (x: 0.4em, y: 0.2em),
        radius: 2pt,
        text(fill: white, size: 9pt, weight: "bold")[#label],
      ),
    )
  }
]


// Data showcase figure: representative CECT slices illustrating
// the principal challenges of micro-CT vasculature data.

#let img-path = "../../../resources/images/vessel_intro_examples/"

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    rows: 2,
    column-gutter: 0.4em,
    row-gutter: 0.6em,

    // (a) Large vessel — ~14 voxels across
    figure(
      image-with-circles(
        img-path + "ca-ll-l1_1084.jpg",
        (
          (x: 20%, y: 45%, r: 9mm, colour: red, thickness: 0.8pt),
        ),
      ),
      caption: [(a) Large vessel],
      supplement: none,
      numbering: none,
    ),
  

    // (b) Staining artifact — large high-valued region
    figure(
      image(img-path + "ca-ll-l1_0655.jpg", width: 100%),
      caption: [(b) Staining artefact],
      supplement: none,
      numbering: none,
    ),



    // (c) Many small vessels in cross-section, 2-8 voxels across
    figure(
      image(img-path + "ca-ll-r_2297_crop.jpg", width: 100%),
      caption: [(c) Small vessels in cross-section],
      supplement: none,
      numbering: none,
    ),

    // (d) Shell effect — high-valued boundary shell
    figure(
      image(img-path + "ca-lu-r_1458_crop.jpg", width: 100%),
      caption: [(d) Shell effect],
      supplement: none,
      numbering: none,
    ),


    // (e) and (f) — paired slices showing 3D continuity
    figure(
      image(img-path + "ca-lu-r_1651_crop.jpg", width: 100%),
      caption: [(e) Slice $z$],
      supplement: none,
      numbering: none,
    ),
    figure(
      image(img-path + "ca-lu-r_1656_crop.jpg", width: 100%),
      caption: [(f) Slice $z + 5$],
      supplement: none,
      numbering: none,
    ),
  ),
  caption: [
    Slices illustrating the principal challenges: *(a)* A large high contrast vessel of approximately 14 voxels. *(b)* A large high-intensity region not corresponding to vasculature, illustrating staining artefacts. *(c)* Upper, left: many small vessels in cross-section, ranging from 2 to 8 voxels in diameter, where the partial-volume effect is present, as well as compression artifacts. *(d)* Right hand side: the "shell effect", a high-intensity boundary surrounding the tumor caused by the diffusion of the contrast agent. *(e, f)* Two slices from the same volume, separated by 5 voxels along the z-axis. The vessel indicated appears discontinuous in (e) but continuous in (f), highlighting the relevance of 3D methods.
  ],
) <cect-data-examples>