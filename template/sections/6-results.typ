// Re-write:
// CECT aims to make structures visible with CE agent that increases brightness. alternatives to CECT exist that use different "wavelengths" and different CE agents.
// Most basic Segmentation uses this prior: intensity based, but this is not sufficient because it is global
// After that, local gradients don't work because they don't integrate tubularity. You also get blobs, noise and artefacts
// -> derived from gradients you get shape based methods: frangi
// this enables detection of vessels with contrast wrt bakground 
// But this does not solve the gaps issue
// -> derived from shape based methods, you get reconnecting methods that use the previous steps
// Shape based fill the "intensity" gap, and disconnection based fill the "disconnection" gap
// 



#import "./appendices/graph_results.typ": results-chart
// #import "appendices/precision_recall_old.typ": pr-curve
#import "appendices/precision_recall.typ" : xy-curve

= Results

The plugin is measured both against thresholding, the method previously used, and against a manually annotated baseline. 

As mentioned, the user is expected to place vessel, background and outside-of-volume points. These act as points used to to guide and define hyperparameters of the algorithms and also as a performance metric: when the pipeline is run, feedback is given with how many vessel points are correctly classified. However this method of performance evaluation has shotcomings: data is evaluated pointwise, ignoring connectivity and vessel size, and it is inherently done in 2D.  //As users also place points generally towards the center of the vessels, there is little measurement of the width of vessels beyond if a background point ends up being caught in the vessel prediction.

#linebreak()
As a result, manual annotations were created. To achieve this, 4 samples were selected. These scans were subdivided into 6x6x6 regions from which, for each scan, three subregions were selected with one at each distance step from the center as visualized in @Annotation_grid. This method was chosen as it enables annotation in a reasonable amount of time with enough context for evaluating vessels.

However an important caveat is to be kept in mind for the following section: as annotations were created by a non domain expert using 3D Slicer 2D views, they carry a strong bias towards what is visible in the image (i.e. context is not always fully taken into account) and the disconnections, when not visible, were not guessed. This means that any algorithm carrying out extrapolation will automatically have a negative performance hit. 

//30 regions were manually  annotated from the 5 smallest scans of Run 1 and Run 2 respectively: amongst the 16 data samples (of which 4/16 were considered "reliable") of Run 1, 5 were selected, with 3 being "unreliable", a representative sample, and 5 of the 16 of Run 2 (all considered reliable). These scans were subdivided into 6x6x6 regions from which, for each scan, three subregions were selected with one at each distance step from the center as visualized in @Annotation_grid. This method was chosen as it enables annotation in a reasonable amount of time with enough context for evaluating vessels.

#let image-with-grid(path, colour, label, gridsize, annotations: ()) = block(width: auto, height: auto)[
#set align(center)
  #layout(size => {
    let img-width = size.width
    let img-height = size.width
    let cell-w = img-width / gridsize
    let cell-h = img-height / gridsize

    box(width: img-width, height: img-height, clip: false)[
      #image(path, width: 100%, height: 100%, fit: "cover")

      // Horizontal lines
      #for i in range(1, gridsize + 1) {
        place(left + top,
          dy: i * cell-h - 0.4pt,
          line(length: img-width, stroke: 0.6pt + colour)
        )
      }

      // Vertical lines
      #for i in range(1, gridsize + 1) {
        place(left + top,
          dx: i * cell-w - 0.4pt,
          line(length: img-height, angle: 90deg, stroke: 0.6pt + colour)
        )
      }

      // Per-cell annotations: (col, row, content) — 0-indexed from top-left
      #for (col, row, content) in annotations {
        place(left + top,
          dx: col * cell-w + cell-w / 2,
          dy: row * cell-h + cell-h / 2,
          box(
            fill: rgb(0, 0, 0, 140),
            inset: (x: 0.3em, y: 0.15em),
            radius: 2pt,
            align(center + horizon,
              text(fill: white, size: 10pt, weight: "bold")[#content]
            )
          )
        )
      }

      // Corner label
      #place(bottom + right,
        dx: -0.4em, dy: -0.4em,
        box(
          fill: rgb(0, 0, 0, 160),
          inset: (x: 0.4em, y: 0.2em),
          radius: 2pt,
          text(fill: white, size: 10pt, weight: "bold")[#label],
        ),
      )
    ]
  })
]

#v(0.1cm)
#figure(
  grid(
    columns: 2,
    // column-gutter: 0.6em,
    image-with-grid("../../resources/images/vessels_results/Run 2 ca-ru-r_0779.jpg", red, "CA-RU-R", 6,
      annotations: ((4.8, -0.2, "1"),(3.8, 3.8, "2"),(2.8, 1.8, "3"))),
    // image-with-grid("../../resources/images/vessels_results/run 1 415 424 1938 ca-ll-r_2558.jpg", red, "CA-LL-R", 6,
    //   annotations: ((-0.2, 4.8, "1"),(0.8, 0.8, "2"),(2.8, 2.8, "3"))),
    image-with-grid("../../resources/images/vessels_results/Run 2 ca-ll-r_0465.jpg", red, "CA-LL-R", 6,
      annotations: ((-0.2, 4.8, "1"),(0.8, 0.8, "2"),(2.8, 2.8, "3"))),
    image-with-grid("../../resources/images/vessels_results/run 2 ca-nm-l_1457.jpg", red, "CA-NM-L", 6,
      annotations: ((4.8, -0.2, "1"),(3.8, 3.8, "2"),(1.8, 1.8, "3"))),
    image-with-grid("../../resources/images/vessels_results/Run 1 ca-ll-l1_0888.jpg", red, "CA-LL-L1", 6,
      annotations: ((-0.2, -0.2, "1"),(0.8, 0.8, "2"),(2.8, 2.8, "3"))),
  ),
  caption: [6x6x6 Grid subsample of tumors used for annotation and performance evaluation, showing the locations of the three subregions selected for annotation at three distances from the center. Full greyscale range visualized.],
) <Annotation_grid>
#v(0.1cm)



// https://www.learnui.design/tools/data-color-picker.html
// Colour scale:
// #00876c
// #9bb290
// #e4e2df
// #d89e78
// #d43d51

// Palette:
// #003f5c
// #78529b
// #ef537d
// #ffa600

// Palette 5:
// #003f5c
// #575092
// #bb4e99
// #ff5f68
// #ffa600

#pagebreak()
== Performance results

Performance is analyzed both _quantitatively_ and _qualitatively_: quantative numbers as they are evaluated here can fail to properly weigh the negative impact of vessels with variable sizes, or disconnections, and the ground truths as mentioned above are imperfect and conservative which impacts the performance of an algorithm designed to extrapolate. 


=== Quantitative analysis 

#v(0.5cm)
#figure(
  results-chart((
    (col: "pred_gt_vol", colour: rgb("#003f5c"), label: "Pred Ratio"),
    (col: "thr_gt_vol",  colour: rgb("#ffa600"), label: "Thr Ratio"),
  ), 24.0, "Ratio"),
  caption: [Ratio of segmentation to ground truth volume, offering a quantification for extrapolation (higher = more extrapolation/false positives).],
)
#v(0.5cm)


As shown, the algorithm produces in 2 of 6 cases an extreme extrapolation. In 4 of 6 cases, extrapolation is a lot more closely aligned with thresholding.Next, classical DICE and connection weighted clDICE scores are interesing to obseve, although they suffer from the extrapolation, for the four closely matched cases. Here it can be seen that in those 4 cases, the DICE and clDICE scores are close.
#v(0.5cm)
// #figure(
//   results-chart((
//     (col: "pred_gt_dice", colour: rgb("#003f5c"), label: "Tool Dice"),
//     (col: "thr_gt_dice",  colour: rgb("#78529b"), label: "Thr Dice"),
//     (col: "pred_gt_cldice", colour: rgb("#ef537d"), label: "Tool clDice"),
//     (col: "thr_gt_cldice",  colour: rgb("#ffa600"), label: "Thr clDice"),
//   ), 1.0, "DICE"),
//   caption: [DICE and clDICE results],
// )
// DICE + seed agreement on the same chart:
#figure(
  results-chart(
    (
      (col: "pred_gt_dice", colour: rgb("#003f5c"), label: "Tool Dice"),
      (col: "thr_gt_dice",  colour: rgb("#78529b"), label: "Thr Dice"),
      (col: "pred_gt_cldice", colour: rgb("#ef537d"), label: "Tool clDice"),
      (col: "thr_gt_cldice",  colour: rgb("#ffa600"), label: "Thr clDice"),
    ),
    1.0,
    "Score",
    derived-series: (
      // (num: "vessel_seeds_correct", den: "vessel_seeds_total", colour: rgb("#ef537d"), label: "Pipeline Vessel seeds"),
      // (num: "bg_seeds_correct",     den: "bg_seeds_total",     colour: rgb("#ffa600"), label: "Pipeline BG seeds"),
      // (num: "thr_vessel_seeds_correct", den: "thr_vessel_seeds_total", colour: rgb("#ef537d"), label: "Threshold Vessel seeds"),
      // (num: "thr_bg_seeds_correct",     den: "thr_bg_seeds_total",     colour: rgb("#ffa600"), label: "Threshold BG seeds"),
    )
  ),
  caption: [DICE vs seed agreement],
)
#v(0.5cm)

This shows what appears to be substantially better performance than our tool, however when evaluating the length of predicted vessels within the ground truth:


#v(0.5cm)
#figure(
  results-chart(
    (
      // (col: "pred_gt_dice", colour: rgb("#003f5c"), label: "Tool Dice"),
      // (col: "thr_gt_dice",  colour: rgb("#78529b"), label: "Thr Dice"),
      // (col: "pred_gt_cldice", colour: rgb("#ef537d"), label: "Tool clDice"),
      // (col: "thr_gt_cldice",  colour: rgb("#ffa600"), label: "Thr clDice"),
    ),
    1.0,
    "Score",
    derived-series: (
      (num: "vessel_seeds_correct", den: "vessel_seeds_total", colour: rgb("#003f5c"), label: "Pipeline Vessel seeds"),
      (num: "bg_seeds_correct",     den: "bg_seeds_total",     colour: rgb("#78529b"), label: "Pipeline BG seeds"),
      (num: "thr_vessel_seeds_correct", den: "thr_vessel_seeds_total", colour: rgb("#ef537d"), label: "Threshold Vessel seeds"),
      (num: "thr_bg_seeds_correct",     den: "thr_bg_seeds_total",     colour: rgb("#ffa600"), label: "Threshold BG seeds"),
    )
  ),
  caption: [seed agreement],
)
#v(0.5cm)





#v(0.5cm)
#figure(
results-chart((
  (col: "cl_len_pred_mm", colour: rgb("#003f5c"), label: "Tool"),
  (col: "cl_len_thr_mm",  colour: rgb("#78529b"), label: "Threshold"),
  (col: "gt_len",  colour: rgb("#ef537d"), label: "Ground truth"),
), 60.0, "mm"),
  caption: [Continuous length estimates of predicted vessels],
)
#v(0.5cm)


Precision / recall allow us to disentangle the issue of false positives and oversegmentation:

#v(0.5cm)
#figure(
  results-chart((
    (col: "pred_gt_precision", colour: rgb("#003f5c"), label: "Tool precision"),
    (col: "thr_gt_precision",  colour: rgb("#78529b"), label: "Thresh precision"),
    (col: "pred_gt_recall",  colour: rgb("#ef537d"), label: "Tool recall"),
    (col: "thr_gt_recall",  colour: rgb("#ffa600"), label: "Thresh recall"),
  ), 1.0, "mm"),
  caption: [Precision/recall analysis],
)
#v(0.5cm)

From this graph we can see that the precision is consistently lower than thresholding, however recall is higher. 


=== Qualitative analysis


// Crop for CA-RU-R 666
// 1537 528
// 3237 528
// 1537 1905
// 3237 1905




// #v(0.5cm)
// #figure(
//   // pr-curve((
//   //   ("../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv", "Thresholding", rgb("#e63946")),
//   //   ("../../../resources/images/sweep_experiment/SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv", "CollaboratiVessel", rgb("#457b9d")),
//   //   ("../../../resources/images/sweep_experiment/frangi_sweep_005/FRANGI_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv", "Frangi", rgb("#ff1a1a")),
//   //   ("../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv", "Frangi Wider", rgb("#1afbff")),
//   // )),

//   pr-curve((
//   (
//     csv:    "../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
//     label:  "Thresholding",
//     colour: rgb("#e63946"),
//     x: (num: "bg_seeds_correct",     den: "bg_seeds_total"),
//     y: (num: "vessel_seeds_correct",  den: "vessel_seeds_total"),
//   ),
//   (
//     csv:    "../../../resources/images/sweep_experiment/SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
//     label:  "CollaboratiVessel",
//     colour: rgb("#457b9d"),
//     x: (num: "bg_seeds_correct",     den: "bg_seeds_total"),
//     y: (num: "vessel_seeds_correct",  den: "vessel_seeds_total"),
//   ),
//   (
//     csv:    "../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
//     label:  "Frangi",
//     colour: rgb("#b4d94d"),
//     x: (num: "bg_seeds_correct",     den: "bg_seeds_total"),
//     y: (num: "vessel_seeds_correct",  den: "vessel_seeds_total"),
//   ),
//   )),
//   caption: [CA-RU-R 222 
  
//   Precision recall curve comparing thresholding with our algorithm, highlighting the regime differences. Precision of 100% is never reached because certain high valued pixels do not belong to vessels, and invesely ],
// )
// #v(0.5cm)
// Peak precision 0.6342 at threshold_193 w recall 0.2058
// 





// PR curve 
#figure(
    xy-curve(
    (
      (csv: "../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
        label: "Thresholding",      colour: rgb("#e63946")),
      (csv: "../../../resources/images/sweep_experiment/SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
        label: "CollaboratiVessel", colour: rgb("#457b9d")),
      (csv: "../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
        label: "Frangi", colour: rgb("#459d6b")),
    ),
    x-label: "Recall",
    y-label: "Precision",
  )
)

#figure(
  xy-curve(
    (
      (
        csv: "../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
          label: "Thresholding", colour: rgb("#e63946"),
        x: (num: "bg_seeds_correct",     den: "bg_seeds_total"),
        y: (num: "vessel_seeds_correct", den: "vessel_seeds_total"),
      ),
      (
        csv: "../../../resources/images/sweep_experiment/SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
          label: "CollaboratiVessel", colour: rgb("#457b9d"),
        x: (num: "bg_seeds_correct",     den: "bg_seeds_total"),
        y: (num: "vessel_seeds_correct", den: "vessel_seeds_total"),
      ),
      (
        csv: "../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
          label: "Frangi", colour: rgb("#459d6b"),
        x: (num: "bg_seeds_correct",     den: "bg_seeds_total"),
        y: (num: "vessel_seeds_correct", den: "vessel_seeds_total"),
      ),
    ),
    x-label: "BG seed accuracy",
    y-label: "Vessel seed accuracy",
  )
)


// #v(0.5cm)
// #figure(
//   pr-curve((
//     ("../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv", "Thresholding", rgb("#e63946")),
//     ("../../../resources/images/sweep_experiment/SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv", "CollaboratiVessel", rgb("#457b9d")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_005/FRANGI_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv", "Frangi", rgb("#ff1a1a")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv", "Frangi Wider", rgb("#1afbff")),
//   )),
//   caption: [CA-RU-R 666],
// )
// #v(0.5cm)



// #v(0.5cm)
// #figure(
//   pr-curve((
//     ("../../../resources/images/sweep_experiment/THRESH_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv", "Thresholding", rgb("#e63946")),
//     ("../../../resources/images/sweep_experiment/SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv", "CollaboratiVessel", rgb("#457b9d")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_005/FRANGI_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv", "Frangi", rgb("#ff1a1a")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv", "Frangi Wider", rgb("#1afbff")),
//   )),
//   caption: [CA-LL-R 427],
// )
// #v(0.5cm)


// 319
// #v(0.5cm)
// #figure(
//   pr-curve((
//     ("../../../resources/images/sweep_experiment/THRESH_SLICES_CA-NM-L_x+1800_y+1800_z+319_experiment.csv", "Thresholding", rgb("#e63946")),
//     ("../../../resources/images/sweep_experiment/SLICES_CA-NM-L_x+1800_y+1800_z+319_experiment.csv", "CollaboratiVessel", rgb("#457b9d")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_005/FRANGI_SLICES_CA-NM-L_x+1800_y+1800_z+319_experiment.csv", "Frangi", rgb("#ff1a1a")),
//     // ("../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-NM-L_x+1800_y+1800_z+319_experiment.csv", "Frangi Wider", rgb("#1afbff")),
//   )),
//   caption: [CA-NM-L 319],
// )
// #v(0.5cm)


// 957
// #v(0.5cm)
// #figure(
//   pr-curve((
//     ("../../../resources/images/sweep_experiment/THRESH_SLICES_CA-NM-L_x+900_y+900_z+957_experiment.csv", "Thresholding", rgb("#e63946")),
//     ("../../../resources/images/sweep_experiment/SLICES_CA-NM-L_x+900_y+900_z+957_experiment.csv", "CollaboratiVessel", rgb("#457b9d")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_005/FRANGI_SLICES_CA-NM-L_x+900_y+900_z+957_experiment.csv", "Frangi", rgb("#ff1a1a")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-NM-L_x+900_y+900_z+957_experiment.csv", "Frangi Wider", rgb("#1afbff")),
//   )),
//   caption: [CA-NM-L 957],
// )
// #v(0.5cm)

// 498
// #v(0.5cm)
// #figure(
//   pr-curve((
//     ("../../../resources/images/sweep_experiment/THRESH_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv", "Thresholding", rgb("#e63946")),
//     ("../../../resources/images/sweep_experiment/SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv", "CollaboratiVessel", rgb("#457b9d")),
//     ("../../../resources/images/sweep_experiment/frangi_sweep_005/FRANGI_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv", "Frangi", rgb("#ff1a1a")),
//     // ("../../../resources/images/sweep_experiment/frangi_sweep_0025_and_vessel_diversity/FRANGI_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv", "Frangi Wider", rgb("#1afbff")),
//   )),
//   caption: [CA-LL-L1 498],
// )
// #v(0.5cm)












// === CA-RU-R
// The CA-RU-R tumor comes from Run 2 and is considered reliable. Point 1 was dropped as it is outside of the volume of interest
// //17 Vessel, 6 Background and 8 Outside points were placed, with vessel size estimate of 3 +/-3 voxels measured using the data probe tool, and the denoise kernel set to 8 voxels. All other settings were left to default.
// // The pipeline ran for 166 seconds, with a reported mean vessel value was 178 with a standard deviation of 37. This mean was used for a thresholding segmentation, in order to compare the two methods as well as compare them with the manually annotated ground truth.


// ==== 222:

// 3 5 8 
// Intensity: μ_v=175.2±32.9
// Evaluation against ground-truth chunks
// (metrics on GT>0 bbox + 5-voxel margin)
//   • VSA_Eval_1: Dice=0.327, clDice=0.382, IoU=0.196, P=0.288, R=0.378, vol(pred/gt)=1.31
//      GT=109,490 vox, pred=143,797 vox, shape=(222, 216, 229), src IJK=[0:229, 0:216, 0:222]
//      Centerlines: pred=16.2mm (35 br, avg 0.5mm), gt=27.0mm (131 br, avg 0.2mm)
//      Threshold (175) vs GT: Dice=0.413, clDice=0.354, IoU=0.261, P=0.526, R=0.341, vol(thr/gt)=0.65, thr=70,899 vox
//      Pred vs Threshold: Dice=0.376, clDice=0.472, IoU=0.231, vol(pred/thr)=2.03
//      Threshold centerline: thr=11.1mm (217 br, avg 0.1mm)

// Mean — Pred vs GT: Dice=0.327, clDice=0.382, IoU=0.196, P=0.288, R=0.378, vol=1.31
// Mean centerline length: pred=16.2mm, gt=27.0mm
// Threshold diag: threshold=175; total thresh voxels in volume: 71,323; source value range: [0.0, 255.0]
// Mean — Threshold vs GT: Dice=0.413, clDice=0.354, IoU=0.261, P=0.526, R=0.341, vol=0.65
// Mean — Pred vs Threshold: Dice=0.376, clDice=0.472, IoU=0.231
// Mean threshold centerline: thr=11.1mm


// chunk,vessel_size,vessel_std,denoise_kernel,frangi_tiles_per_axis,intensity_likelihood,vessel_prior,ridge_threshold,ridge_iterations,auto_seed,auto_seed_rounds,auto_seed_max,auto_seed_intensity_sigma,component_min_prob,median_intensity,std_intensity,pred_gt_dice,pred_gt_cldice,pred_gt_iou,pred_gt_precision,pred_gt_recall,pred_gt_vol,thr_gt_dice,thr_gt_cldice,thr_gt_iou,thr_gt_precision,thr_gt_recall,thr_gt_vol,pred_thr_dice,pred_thr_cldice,pred_thr_iou,pred_thr_precision,pred_thr_recall,pred_thr_vol,cl_len_pred_mm,cl_match_pred_mm,cl_len_thr_mm,cl_match_thr_mm
// CA-RU-R_x+916_y+901_z+222,3,5,8,2,True,0.1,0.01,5,True,8,200,1.2,0.05,163.00,30.05,0.3271,0.3815,0.1956,0.2881,0.3784,1.313,0.4135,0.3539,0.2606,0.5260,0.3406,0.648,0.3759,0.4719,0.2315,0.2806,0.5691,2.028,16.21,7.25,11.05,5.50




// ==== 666:

// 3 4 8 Intensity: μ_v=145.9±8.8, 8/9 vessels correct

// Evaluation against ground-truth chunks
// (metrics on GT>0 bbox + 5-voxel margin)
//   • VSA_Eval_1: Dice=0.087, clDice=0.198, IoU=0.046, P=0.046, R=0.833, vol(pred/gt)=18.11
//      GT=15,954 vox, pred=288,856 vox, shape=(215, 225, 229), src IJK=[0:229, 0:225, 0:215]
//      Centerlines: pred=36.0mm (43 br, avg 0.8mm), gt=5.3mm (34 br, avg 0.2mm)
//      Threshold (146) vs GT: Dice=0.271, clDice=0.410, IoU=0.157, P=0.651, R=0.171, vol(thr/gt)=0.26, thr=4,196 vox
//      Pred vs Threshold: Dice=0.026, clDice=0.122, IoU=0.013, vol(pred/thr)=68.84
//      Threshold centerline: thr=2.1mm (110 br, avg 0.0mm)

// Mean — Pred vs GT: Dice=0.087, clDice=0.198, IoU=0.046, P=0.046, R=0.833, vol=18.11
// Mean centerline length: pred=36.0mm, gt=5.3mm
// Threshold diag: threshold=146; total thresh voxels in volume: 4,216; source value range: [49.0, 197.0]
// Mean — Threshold vs GT: Dice=0.271, clDice=0.410, IoU=0.157, P=0.651, R=0.171, vol=0.26
// Mean — Pred vs Threshold: Dice=0.026, clDice=0.122, IoU=0.013
// Mean threshold centerline: thr=2.1mm


// chunk,vessel_size,vessel_std,denoise_kernel,frangi_tiles_per_axis,intensity_likelihood,vessel_prior,ridge_threshold,ridge_iterations,auto_seed,auto_seed_rounds,auto_seed_max,auto_seed_intensity_sigma,component_min_prob,median_intensity,std_intensity,pred_gt_dice,pred_gt_cldice,pred_gt_iou,pred_gt_precision,pred_gt_recall,pred_gt_vol,thr_gt_dice,thr_gt_cldice,thr_gt_iou,thr_gt_precision,thr_gt_recall,thr_gt_vol,pred_thr_dice,pred_thr_cldice,pred_thr_iou,pred_thr_precision,pred_thr_recall,pred_thr_vol,cl_len_pred_mm,cl_match_pred_mm,cl_len_thr_mm,cl_match_thr_mm
// SLICES CA-RU-R_x+687_y+451_z+666,3,4,8,2,True,0.1,0.01,5,True,8,200,1.2,0.05,138.00,9.16,0.0872,0.1984,0.0456,0.0460,0.8333,18.106,0.2711,0.4098,0.1568,0.6509,0.1712,0.263,0.0261,0.1218,0.0132,0.0132,0.9104,68.841,35.96,4.04,2.09,1.34



// // ==== 1110
// // Outside of volume




// === CA-LL-R
// Run 2, settings 2 2 4, small vessels, low contrast and low resolution hence the small smoothing

// // ==== 711 
// // Outside of volume 
// // ==== 569 
// // Outside of volume

// ==== 427:

// Intensity: μ_v=119.2±4.1, 7/7 vessels 2/3 background

// Evaluation against ground-truth chunks
// (metrics on GT>0 bbox + 5-voxel margin)
//   • VSA_Eval_1: Dice=0.079, clDice=0.223, IoU=0.041, P=0.041, R=0.953, vol(pred/gt)=23.08
//      GT=2,643 vox, pred=61,003 vox, shape=(91, 95, 99), src IJK=[0:99, 0:95, 51:142]
//      Centerlines: pred=9.4mm (4 br, avg 2.4mm), gt=1.4mm (15 br, avg 0.1mm)
//      Threshold (119) vs GT: Dice=0.543, clDice=0.628, IoU=0.373, P=0.421, R=0.767, vol(thr/gt)=1.82, thr=4,821 vox
//      Pred vs Threshold: Dice=0.135, clDice=0.338, IoU=0.072, vol(pred/thr)=12.65
//      Threshold centerline: thr=2.0mm (75 br, avg 0.0mm)

// Mean — Pred vs GT: Dice=0.079, clDice=0.223, IoU=0.041, P=0.041, R=0.953, vol=23.08
// Mean centerline length: pred=9.4mm, gt=1.4mm
// Threshold diag: threshold=119; total thresh voxels in volume: 5,959; source value range: [89.0, 156.0]
// Mean — Threshold vs GT: Dice=0.543, clDice=0.628, IoU=0.373, P=0.421, R=0.767, vol=1.82
// Mean — Pred vs Threshold: Dice=0.135, clDice=0.338, IoU=0.072
// Mean threshold centerline: thr=2.0mm


// chunk,vessel_size,vessel_std,denoise_kernel,frangi_tiles_per_axis,intensity_likelihood,vessel_prior,ridge_threshold,ridge_iterations,auto_seed,auto_seed_rounds,auto_seed_max,auto_seed_intensity_sigma,component_min_prob,median_intensity,std_intensity,pred_gt_dice,pred_gt_cldice,pred_gt_iou,pred_gt_precision,pred_gt_recall,pred_gt_vol,thr_gt_dice,thr_gt_cldice,thr_gt_iou,thr_gt_precision,thr_gt_recall,thr_gt_vol,pred_thr_dice,pred_thr_cldice,pred_thr_iou,pred_thr_precision,pred_thr_recall,pred_thr_vol,cl_len_pred_mm,cl_match_pred_mm,cl_len_thr_mm,cl_match_thr_mm

// SLICES CA-LL-R_x+298_y+233_z+427,3,4,8,2,True,0.1,0.01,5,True,8,200,1.2,0.05,125.00,7.82,0.0792,0.2233,0.0412,0.0413,0.9531,23.081,0.5434,0.6275,0.3731,0.4207,0.7673,1.824,0.1350,0.3382,0.0724,0.0728,0.9214,12.654,9.41,1.19,1.97,0.97



// === CA-NM-L
// Run 2

// // ==== 0
// // Outside of volume

// ==== 319
// Barely in volume, Gradient


// Intensity: μ_v=177.2±18.1, 3 4 8 7/7 vessels correct, 10/10 background correct

// Evaluation against ground-truth chunks
// (metrics on GT>0 bbox + 5-voxel margin)
//   • VSA_Eval_1: Dice=0.293, clDice=0.547, IoU=0.171, P=0.180, R=0.786, vol(pred/gt)=4.37
//      GT=11,115 vox, pred=48,587 vox, shape=(197, 124, 124), src IJK=[0:124, 0:124, 122:319]
//      Centerlines: pred=3.9mm (19 br, avg 0.2mm), gt=2.5mm (17 br, avg 0.1mm)
//      Threshold (177) vs GT: Dice=0.233, clDice=0.089, IoU=0.132, P=0.142, R=0.662, vol(thr/gt)=4.67, thr=51,883 vox
//      Pred vs Threshold: Dice=0.349, clDice=0.307, IoU=0.212, vol(pred/thr)=0.94
//      Threshold centerline: thr=56.1mm (612 br, avg 0.1mm)

// Mean — Pred vs GT: Dice=0.293, clDice=0.547, IoU=0.171, P=0.180, R=0.786, vol=4.37
// Mean centerline length: pred=3.9mm, gt=2.5mm
// Threshold diag: threshold=177; total thresh voxels in volume: 187,297; source value range: [0.0, 255.0]
// Mean — Threshold vs GT: Dice=0.233, clDice=0.089, IoU=0.132, P=0.142, R=0.662, vol=4.67
// Mean — Pred vs Threshold: Dice=0.349, clDice=0.307, IoU=0.212
// Mean threshold centerline: thr=56.1mm

// chunk,vessel_size,vessel_std,denoise_kernel,frangi_tiles_per_axis,intensity_likelihood,vessel_prior,ridge_threshold,ridge_iterations,auto_seed,auto_seed_rounds,auto_seed_max,auto_seed_intensity_sigma,component_min_prob,median_intensity,std_intensity,pred_gt_dice,pred_gt_cldice,pred_gt_iou,pred_gt_precision,pred_gt_recall,pred_gt_vol,thr_gt_dice,thr_gt_cldice,thr_gt_iou,thr_gt_precision,thr_gt_recall,thr_gt_vol,pred_thr_dice,pred_thr_cldice,pred_thr_iou,pred_thr_precision,pred_thr_recall,pred_thr_vol,cl_len_pred_mm,cl_match_pred_mm,cl_len_thr_mm,
// SLICES CA-NM-L_x+1800_y+1800_z+319,3,4,8,2,True,0.1,0.01,5,True,8,200,1.2,0.05,191.00,33.73,0.2927,0.5468,0.1714,0.1798,0.7860,4.371,0.2335,0.0894,0.1322,0.1417,0.6616,4.668,0.3492,0.3075,0.2116,0.3611,0.3381,0.936,3.93,1.64,56.15,2.65


// ==== 957

// SLICES CA-NM-L_x+900_y+900_z+957
// Large vessels with high difference wrt background.
// 4 6 8 Intensity: μ_v=198.0±38.0,

// Evaluation against ground-truth chunks
// (metrics on GT>0 bbox + 5-voxel margin)
//   • VSA_Eval_1: Dice=0.566, clDice=0.685, IoU=0.395, P=0.479, R=0.691, vol(pred/gt)=1.44
//      GT=109,713 vox, pred=158,263 vox, shape=(301, 409, 450), src IJK=[0:450, 41:450, 0:301]
//      Centerlines: pred=13.5mm (10 br, avg 1.3mm), gt=8.1mm (15 br, avg 0.5mm)
//      Threshold (198) vs GT: Dice=0.744, clDice=0.795, IoU=0.592, P=0.981, R=0.599, vol(thr/gt)=0.61, thr=67,068 vox
//      Pred vs Threshold: Dice=0.521, clDice=0.571, IoU=0.352, vol(pred/thr)=2.36
//      Threshold centerline: thr=6.6mm (20 br, avg 0.3mm)

// Mean — Pred vs GT: Dice=0.566, clDice=0.685, IoU=0.395, P=0.479, R=0.691, vol=1.44
// Mean centerline length: pred=13.5mm, gt=8.1mm
// Threshold diag: threshold=198; total thresh voxels in volume: 67,070; source value range: [43.0, 255.0]
// Mean — Threshold vs GT: Dice=0.744, clDice=0.795, IoU=0.592, P=0.981, R=0.599, vol=0.61
// Mean — Pred vs Threshold: Dice=0.521, clDice=0.571, IoU=0.352
// Mean threshold centerline: thr=6.6mm

// chunk,vessel_size,vessel_std,denoise_kernel,frangi_tiles_per_axis,intensity_likelihood,vessel_prior,ridge_threshold,ridge_iterations,auto_seed,auto_seed_rounds,auto_seed_max,auto_seed_intensity_sigma,component_min_prob,median_intensity,std_intensity,pred_gt_dice,pred_gt_cldice,pred_gt_iou,pred_gt_precision,pred_gt_recall,pred_gt_vol,thr_gt_dice,thr_gt_cldice,thr_gt_iou,thr_gt_precision,thr_gt_recall,thr_gt_vol,pred_thr_dice,pred_thr_cldice,pred_thr_iou,pred_thr_precision,pred_thr_recall,pred_thr_vol,cl_len_pred_mm,cl_match_pred_mm,cl_len_thr_mm,cl_match_thr_mm
// SLICES CA-NM-L_x+900_y+900_z+957,4,6,8,2,True,0.1,0.01,5,True,8,200,1.2,0.05,213.00,39.27,0.5660,0.6850,0.3947,0.4792,0.6912,1.443,0.7441,0.7953,0.5924,0.9806,0.5995,0.611,0.5207,0.5713,0.3520,0.3707,0.8746,2.360,13.48,7.43,6.56,6.46




// === CA-LL-L1
// Run 1, unreliable, very noisy

// // ==== 0
// // Outside of volume

// // ==== 249
// // 2 3 12
// // noisy, very few vessels, mostly air, dropped

// ==== 498

// 5/9 vessels
// 3 4 8 Intensity: μ_v=172.3±20.5, 
// SLICES CA-LL-L1_x+559_y+604_z+498

// Evaluation against ground-truth chunks
// (metrics on GT>0 bbox + 5-voxel margin)
//   • VSA_Eval_1: Dice=0.202, clDice=0.322, IoU=0.112, P=0.126, R=0.513, vol(pred/gt)=4.08
//      GT=27,722 vox, pred=113,162 vox, shape=(249, 201, 186), src IJK=[0:186, 0:201, 0:249]
//      Centerlines: pred=13.3mm (17 br, avg 0.8mm), gt=4.6mm (28 br, avg 0.2mm)
//      Threshold (172) vs GT: Dice=0.258, clDice=0.180, IoU=0.148, P=0.160, R=0.666, vol(thr/gt)=4.16, thr=115,442 vox
//      Pred vs Threshold: Dice=0.390, clDice=0.379, IoU=0.242, vol(pred/thr)=0.98
//      Threshold centerline: thr=37.2mm (755 br, avg 0.0mm)

// Mean — Pred vs GT: Dice=0.202, clDice=0.322, IoU=0.112, P=0.126, R=0.513, vol=4.08
// Mean centerline length: pred=13.3mm, gt=4.6mm
// Threshold diag: threshold=172; total thresh voxels in volume: 115,442; source value range: [104.0, 255.0]
// Mean — Threshold vs GT: Dice=0.258, clDice=0.180, IoU=0.148, P=0.160, R=0.666, vol=4.16
// Mean — Pred vs Threshold: Dice=0.390, clDice=0.379, IoU=0.242
// Mean threshold centerline: thr=37.2mm

// chunk,vessel_size,vessel_std,denoise_kernel,frangi_tiles_per_axis,intensity_likelihood,vessel_prior,ridge_threshold,ridge_iterations,auto_seed,auto_seed_rounds,auto_seed_max,auto_seed_intensity_sigma,component_min_prob,median_intensity,std_intensity,pred_gt_dice,pred_gt_cldice,pred_gt_iou,pred_gt_precision,pred_gt_recall,pred_gt_vol,thr_gt_dice,thr_gt_cldice,thr_gt_iou,thr_gt_precision,thr_gt_recall,thr_gt_vol,pred_thr_dice,pred_thr_cldice,pred_thr_iou,pred_thr_precision,pred_thr_recall,pred_thr_vol,cl_len_pred_mm,cl_match_pred_mm,cl_len_thr_mm,cl_match_thr_mm
// SLICES CA-LL-L1_x+559_y+604_z+498,3,4,8,2,True,0.1,0.01,5,True,8,200,1.2,0.05,182.00,25.71,0.2020,0.3221,0.1123,0.1257,0.5132,4.082,0.2580,0.1804,0.1481,0.1600,0.6662,4.164,0.3902,0.3788,0.2424,0.3941,0.3863,0.980,13.33,2.96,37.19,3.88


// === Visualizations

// smallest_run,smallest_run_slices,reliable, number of slices done
// Run 2,Slices CA-LL-R,true, 3 -> did the small ones :(
//CA-LL-R 415 424 1938

// Run 2,Slices CA-RU-R,true, 3

// Run 2,Slices CB-RURL-R,true
// Run 2,Slices CB-LURU-L, true
// Run 2,Slices CA-LL-L,true

// Run 2,Slices CA-NM-L,true, 3 -> NW 900 works well on just regular thresholding -> I DID RUN 2 IN NW


// Run 1,Slices CA-NM-L,true, 0 
// Run 1,Slices CA-LL-L1,false, 2  

// Run 1,Slices CA-LL-L2,false
// Run 1,Slices CA-RU-R,true
// Run 1,Slices CB-LLRL-L,false








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


