
// These three analysis methods were favored by different users: those having been in the team a long time had adapted to the team standard of Avizo, Dragonfly3D was used by team members with previous experience or wanting to use software on their own devices, and the "bare metal" approach was taken by students wishing to avoid the substantial learning curve and friction involved with the use of the aforementioned software.


// In order to maintain interoperability the 3D Slicer plugin needed to export data in one of two ways: *(i)* a fashion that transparently fits into the existing pipeline, namely that of exporting raw binary segmentations that could then be re-imported elsewhere *(ii)* an export format that better enforces scientific rigor and enables easier data sharing, in the form of DICOM. This second option will offer the team growth perspectives in opening the door for easier collaboration with computer scientists as well as other researchers downstream.

// #import "appendices/precision_recall_old.typ": pr-curve


#import "./appendices/graph_results.typ": results-chart
#import "appendices/precision_recall.typ" : xy-curve


// OLD: This chapter documents the development of the 3D Slicer plugin, from the implementation and user interaction, through the method for combining algorithms and the different algorithms explored, and ending in an ablation study to simplify the pipeline and enable usable runtimes and memory use.


// In order to understand the challenge at hand, it is important to begin by looking at how thresholding performs. In @fig:pr_methodo we run a sweep across all possible thresholding values, and measure against a manually annotated ground truth on an illustrative subvolume that contains small disconnected vessles, a light gradient, and some noisy elements. A precision-recall curve is used as it ignores true negatives and avoids giving them an outsized weight, but still allows us to understand the problem at hand: thresholding, no matter how high, will include false positives (_all high valued pixels are not necessarily voxels, the strucutral gap (1)_) and at low values needed to capture faint vessels, the false positives are very high (_low vessel contrast results in challenging extraction (2)_).





// Simplified pipeline (describe it) --> Ablation study (justify the design decisions that led to it) --> Findings table (updated with Dice/clDice)

// This is the standard CS paper structure: present the system, then justify its design through empirical evidence. The reader understands what you built before learning why you built it that way. Currently the order is reversed — you describe things that aren't in the final system before describing what is, which is confusing



= Methodology

// TODO: Add mention of DICOM data conversion and IJK measurements
// https://www.slicer.org/wiki/Coordinate_systems
== Tooling: 3D Slicer plugin

The research team providing the data actively used three tools: the proprietary Avizo, the free-for-academics Dragonfly3D, and a bare metal approach using python code. For plugin development, Avizo and Dragonfly3D were considered, however documentation was challenging and licensing meant it would not satisfy the goal of an open source tool offering extendability and re-usability. As a result, 3D Slicer was selected.

#linebreak()
The 3D Slicer ecosystem is diverse with many existing tools, available plugins with similar goals (vascular extraction) and similar data formats (high resolution CT). These were tested in order to obtain an understanding of potential pitfalls in implementation:

- 3D Slicer hangs when executing algorithms, and this execution happens without communication. The OS will ask the user if they wish to stop the program.
- UI development is restrictive: UI must be in the left corner, and few context menus are available
- Execution in Python is inefficient, and plugins that aimed to use multiple cores called external libraries
- Machine learning extensions did not come pre-packaged with the model weights and often required a GPU and installation of external software
- Errors during installation were not user-friendly enough for a non computer scientist to be able to debug an installation problem
- The 3D Slicer forums contained ample amounts of users having issues with different plugins

Additionally many available plugins were either unmaintained, throwing errors during installation/use or did not successfully produce outputs; this is despite 3D Slicer having two classes of plugins: "official" via the extension manager @SlicerDocsExtensions (further broken down by maintenance type) and user installable or "non official". To mitigate this potential issue, the plugin is packaged with a known good version of 3DSlicer. 

#linebreak()
With these issues in mind, development of the plugin began: 3D Slicer is multi platform and built around plugins to carry out tasks, communicating using the Medical Reality Markup Language (MRML) @MRML_diagram, where modules read and write to MRML nodes to enable interoperability. These plugins can be implemented in one of three forms: as command line interface (CLI) tools where they may be called as an encapsulated piece of code, the most abstracted way of working with external code or a C++/Scripted (Python) loadable module @SlicerTutorialPerkins. The Scripted loadable approach was selected for its use of Python, lowering the barrier to entry, ability to use the UI features of 3D Slicer, and having access to the full slicer API. Work was carried out in Visual Studio Code under Ubuntu 24.04.

#v(0.4cm)
#figure(
  image("../../resources/software/Scripted_Module_Implementation.png", width: 65%),
  caption: [Structure for module implementation from @SlicerTutorialPerkins. The module being implemented must create a widget and a piece of logic that communicate via an MRML node. This motivates our separation of the code into two: a main plugin and a library of implemented logic],
) <MRML_diagram>
#v(0.4cm)

To implement a plugin, the extension wizard #footnote[https://slicer.readthedocs.io/en/latest/user_guide/modules/extensionwizard.html#extension-wizard] was used to generate the required extension boilerplate, and the ScriptedLoadableModule was used as a starting point for the implementation code. 3D Slicer implements a user interface development module in QT, enabling near drag and drop creation of UI elements, making it the natural method of developing a seamless UI experience. Although basic, this radically simplifies the process of creating a cross platform UI.

#figure(
  image("../../resources/misc/QT_ui_designer.png", width: 85%),
  caption: [The QT user interface designer, as seen during the development of the plugin. Key elements of this UI development method are the drag and drop nature as well as limited styling options.],
) <QT_ui> 
#v(0.4cm)

=== Unifying data representations

// The provided data was in JPEG form, an image format that contains no information about pixel spacing between slices, and is lossy. All data was converted to DICOM format with appropriate pixel spacing and formatting: the co-ordinate systems were unified into the standard for 3D Slicer #footnote[https://www.slicer.org/wiki/Coordinate_systems] where voxel indices (IJK) are used in the code. Physical-world coordinates, as commonly used in medical imaging in millimetres (RAS — right/anterior/superior) were used  to offer scale and are saved in the DICOM files. RAS is used by all geometry-aware primitives such as markup points and segmentation transforms. In our usecase, the volumes are isotropic (voxels are squares) meaning that conversion is simple, but care must be taken if the plugin is used for non isotropic data. Seed points placed by the user are stored in RAS and converted to IJK at the point of pipeline use, ensuring annotations survive resampling or coordinate-space changes

The provided data was stored as JPEG slices, a lossy format that carries no information about physical pixel spacing between slices. All volumes were converted to DICOM with explicit isotropic spacing of 6 µm per voxel, matching the original acquisition.

Co-ordinate systems were also unified: 3D Slicer uses two coexisting coordinate systems #footnote[https://www.slicer.org/wiki/Coordinate_systems], one for code called IJK that corresponds to voxel indices and physical-world coordinates in millimetres (RAS — right, anterior, superior), used by all geometry-aware primitives such as markup points and segmentation transforms. User-placed seeds are stored in RAS and converted to IJK at the point of pipeline use, so annotations survive any intermediate resampling or coordinate-space transform. This also enables subsampling of volumes without loosing volume location in the original sample.

It is important to note that in the present work all volumes are isotropic: anisotropic data would require axis-dependent scaling at every IJK <> RAS conversion, and some modifications to the code flow to handle this difference.




== User interaction model

Having the user in the loop is essential to software development, and during the thesis multiple consultations were done. During the user interview concerning the current pipeline of data processing, it was noted that decisions such as hyperparameter selection, windowing and grey value were often made without a principled, replicable and data driven decision method. This is problematic for multiple reasons:

1. As the selected values are not data driven, decisions and pipelines cannot easily be replicated, and are more fragile
2. As the user acts as the evaluator to the actions done, they induce bias in the subsequent steps
3. Any user without knowledge of the downstream steps or what to look out for will not be able to make a fully informed decision for the hyperparameters to select, requiring iteration and potentially falling into local optima.

#linebreak()
A principled approach was required: in order to select thresholds and evaluate the performance of the algorithm "in the loop", as well as offer the user immediate feedback, a system of anchor points was implemented. These anchors are the first step in the process, and are obtained by having the user click "add" for any of the three categories, followed by placing the point in any of the 2D windows. These "Vessel", "Background" and "outside" co-ordinates can be saved and exported, as well as imported in a universal CSV format. Following the receival of the data, and from the aforementioned interviews, it was also noted that users often do not take the time to properly name files and folders. Consequently, naming when exporting is automatically constructed from the current data series name and description, as well as the full current date and time. The second key user feedback element implemented to guide downstream steps was the expected vessel size and deviation in voxels. This parameter is easy to measure and provides critical context for automated hyperparameter selection.

#v(0.4cm)
#figure(
  image("../../resources/software/overview_seed_vessel_param.png"),
  caption: [View of the seed annotation and vessel size definition panes. The user may press _add_ and click on the locations in any of the right hand panes to place one or more points. Annotations can be imported or exported.],
)
#v(0.4cm)



#pagebreak()
== Annotation methodology and limitations

Obtaining a ground truth is key for evaluating algorithmic performance and guiding optimisation. Two complementary forms of ground truth are used by the plugin and are relevant for different stages of the work: user placed annotation points in two or three classes, as is done in regular plugin use, and pixel wise binary ground truth.

The vessel, background, and optional outside-of-volume points guide hyperparameter selection (vessel size and standard deviation) and provide direct in-the-loop feedback by reporting how many vessel points are correctly classified after the pipeline runs. This method is fast and accessible but is limited when used in the development process: evaluation is pointwise rather than spatial, connectivity is ignored entirely, vessel size is not captured, and the inherent 2D nature of point placement makes coverage of small vessels uneven.

=== Voxel ground truth

In order to obtain a second more granular ground truth do so four scans were selected then subdivided into a 6x6x6 grid of regions from which, for each scan, three were selected with one at each distance step from the center as visualized in @Annotation_grid. This subdivision was chosen as it enables annotation in a reasonable amount of time with enough context for evaluating vessels and a diversity of samples inside the volume, outside and at boundaries, with both small and large vessels and more or less noisy tumors.

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


=== Limitations of ground truth


Annotations were produced by a non-domain expert using 3D Slicer's built-in 2D brush tool, with two known sources of bias:

- *Visibility*: Vessels that are not clearly visible in a slice or by moving between slices are not annotated, meaning that gaps are not filled. This results in a performance hit for algorithms performing principled extrapolation across gaps.
- *Boundary uncertainty*: The brush has a fixed size and is moved bu the user, meaning vessels do not necessarily always stop at the same intensity gradient. Vessel edges in the annotation therefore have some noise, which affects Dice-based metrics.

Annotation took approximately 60 hours across two rounds, a first blind annotation round and a second after reviewing the outputs of thresholding and the application of a Gaussian smoothing kernel to reduce visual noise.


// TODO: Mention I am the annotator?

// The annotations were created by a non domain expert using the built in 3D Slicer tools in 2D and 3D. As a result they are biased towards what is visible in the image (i.e. context is not always able to be fully taken into account), the painting tool (vessel annotation does not always stop at the same gradient value) and disconnections when not visible were not guessed. This means that any algorithm carrying out extrapolation will automatically receive a certain negative performance hit. The total annotation time was approximately 60 hours including two rounds of annotation: a blind annotation and a re-annotation after looking at the results from a round of thresholding and the application of a gaussian blur to smooth out the image.

//30 regions were manually  annotated from the 5 smallest scans of Run 1 and Run 2 respectively: amongst the 16 data samples (of which 4/16 were considered "reliable") of Run 1, 5 were selected, with 3 being "unreliable", a representative sample, and 5 of the 16 of Run 2 (all considered reliable). These scans were subdivided into 6x6x6 regions from which, for each scan, three subregions were selected with one at each distance step from the center as visualized in @Annotation_grid. This method was chosen as it enables annotation in a reasonable amount of time with enough context for evaluating vessels.









== Creating a Pipeline
// [seed points] [vessel size]
//        ↓           ↓
// [raw] → [bg-removed] → [Frangi] → [intensity] → [probMap]
//                                                     ↓
//                               [final mask] ← [reconnect] ← [reconstruct]
=== Design overview

Due to the challenges of the data, no single classical method offered satisfactory performance. The final algorithm is a sequential pipeline that combines complementary signals across steps, relying on the underlying assumption that vessels offer a higher signal than surrounding tissue. Shape (tubularity) based on intensity is used, and connectivity is increased over pure intensity signals by using the prior of vessels ending and local intensity. Each step iterates and contributes to a probability map; a technique used to paliate memory constraints. 3D Slicer has no method of chunking large data, meaning that scans and all intermediary work must fit into working memory.

The pipeline produces both a final binary mask with associated segmentation in the 3D Slicer viewer and a soft probability map intended for development and post-hoc analysis
// #figure(
//   // TODO: pipeline data-flow diagram showing the stages and what each consumes
//   caption: [Pipeline data flow illustrating each stage. Modularity and extendability is central to the design process, allowing future modifications to the work],
// ) <pipeline_flow>

=== Background removal and ROI extraction

When looking at a full volume, the sampled tumor is generally surrounded by air or empty space. To prevent the surrounding region from interfering and to reduce computation, if outside points are provided by the user, an initial background filter is applied and the midpoint between the highest outside intensity and the lowest background-seed intensity is used as an intensity cutoff. The voxels below the cutoff are zeroed providing a mask of the data aligned to the sample rather than the bounding box of the scan. 

This removal introduces a high-gradient artificial boundary between zeroed and preserved voxels, which is suppressed using region growing and a mask to avoid Frangi, the gradient sensitive method, from detecting the edge as a tube.  


=== Frangi vesselness
// in obtaining the eigenvalues of the local Hessian matrix. A tube manifests as one small and two large negative eigenvalues (curvature is small along the vessel axis and large perpendicular to it).

The Frangi vesselness filter @frangi_og_paper identifies tubular structures on a local scale using the intensity and its change. The implementation of SimpleITK written in C++ is used for efficiency. Frangi is memory hungry due to its multiscale nature, with each scale requiring a full-volume Hessian, resulting in the need for multiples of the original volume to be kept in memory. To address this, the volume is optionally cut into subregions and processed in halo-padded tiles whose halo equals four times the largest vessel standard deviation, ensuring no information is lost at tile edges. The tile outputs are reassembled into a single volume before the final p99 normalisation, which scales the response into [0, 1] to make thresholds comparable across scans.

#figure(
  image("../../resources/software/frangi_probability_map.png", width: 100%),
  caption: [Frangi vesselness map. Intensity corresponds to vesselness probability; user-placed seeds are also visible.],
) <frangi_map>


=== Localised intensity probability

Frangi captures shapes but abstracts away the intensity signal and is sensitive to noise. To re-introduce intensity evidence, a local z-score is computed: for each voxel, the value is compared to the local mean and standard deviation over a window ten times the vessel diameter. Voxels with a value above their local neighbourhood are flagged as vessel candidates.

The score is calibrated against vessel-seed intensities so that the user's annotations score approximately 0.8 in the local-probability map. This makes the output directly comparable to Frangi: both maps are normalised to [0, 1] and represent independent evidence that a voxel is part of a vessel.

A known limitation of this localized signal approach is that window regions with high signal vessels can hide legitimate signal from smaller nearby vessels or weaker branches due to the mean being raised. This is one of the reasons the later reconstruction stage needs to be robust to broken or fragmented input, and for the use of both frangi and vesselness combined.


=== Combined evidence map

The Frangi map and the local intensity probability are multiplied elementwise to produce the combined evidence map: ```probMap = frangi ×
P_intensity```

The product is high where both signals agree, providing evidence for tubularity *and* a local intensity difference. It suppresses voxels supported by only one signal. This filters out two common false-positive sources: (i) noise that happens to look tubular to Frangi but has no intensity support, and (ii) bright artefacts that have no tubular structure, or that are disconnected by the aforementioned high local signal from large vessels. This ```probMap``` is used as the input to the structural reconstruction stage.


=== Reconstruction by ridge extraction

```probMap``` provides evidence to the existence of vessels but does not follow them to fill small gaps. To convert the evidence into connected vessel structures, TubeTK's ridge extraction @ITKTubeTK_paper_github is used to follow ridges in the input volume starting from a seed point. This fits a tube model with a smoothly varying radius along the centerline, producing more consistently shaped vessels.

Initial ridge extraction starts from the user-placed vessel seeds. To capture vessels not directly seeded by the user, an iterative re-seeding loop proposes new seeds at high-probability voxels not yet visited, then re-runs ridge extraction from them. This is done iteratively for a configurable number of rounds. //The output is both a binary mask of the final reconstructed vasculature and a soft mask weighted by how many rounds each voxel survived — the soft mask is later useful for threshold-based operating point selection and visualisation.

=== Connectivity restoration
// reconstruction stage produces a substantially correct but fragmented mask: many vessels are split into several disconnected
// components due to weak local signal, partial-volume effects, or intermittent staining.

To improve connectivity between the vessel candidates produced by the previous steps, two complementary post-processing steps are used:

1. *Morphological closing* (dilation followed by erosion) merges fragments separated by gaps smaller than twice the structuring element radius, without inflating vessel diameters. This handles the cheap, geometry-only case where two fragments are physically adjacent.

2. *Skeleton based bridging* identifies disconnected vessel tips via skeletonisation, finds pairs within a maximum gap distance, and routes a minimum-cost path through ```1 - probMap```. A bridge is accepted only if its cost is below a threshold, enforcing a meaningful probability to support connection. This handles larger gaps where closing alone would over-connect, by requiring evidence from the underlying signal.

Morphological closing is fast and and reduces the number of endpoints the costly bridging step has to evaluate.


=== Final segmentation

The reconstructed and reconnected mask is thresholded at a fixed value of the soft mask (default 0.12 found through hyperparameter sweeping) to produce the final binary segmentation. The binary mask is displayed in the 3D viewer alongside the soft mask for visual inspection. User feedback is provided in the form of the amount of correctly classified elements, and user points vessel intensity mean and standard deviation. 
// The threshold is exposed as a parameter for users who wish to trade off recall against precision interactively. 

Additionally for evaluation purposes there is the possibility of loading a manually segmented DICOM mask for detailed evaluation based on multiple metrics such as DICE, clDICE, vessel length, precision, recall and volume fraction.

#figure(
  image("../../resources/images/zoomed_output_region.png", width:90%),
  caption: [View of the feedback box with segmentation performance measurement based on the provided subregion for evaluation.],
) <evaluation_window>



// == Creating a Pipeline

// To obtain a segmentation on the challenging data provided, no clear single method appeared sufficient. There is a need to both segment based on intensity, shape context, as well as be able to extrapolate vessel connections, with each step having separate hyperparameters. The final algorithm is called a _pipeline_ due to its nature of applying steps sequentially to the input data, with the final segmentation resulting from each steps' sequential action. This sequential nature is a requirement due to the size of the scans preventing running multiple algorithms on the data in parallel and each holding its own output map.

// // ==== Gaussian denoising 
// // The first step of the pipeline involves using Gaussian denoising to reduce scan and jpeg compression noise, as applied in @wlodarski. The size of the kernel for this step must be carefully chosen as a large denoising will remove small blood vessels.

// ==== Frangi vesselness
// The Frangi vesselness filter is applied across multiple scales, to identify tubular structures. As it is a memory hungry process, tiling is optionally used to run Frangi on smaller subregions and then recombine the results, reducing peak memory use.

// #v(0.4cm)
// #figure(
//   image("../../resources/software/frangi_probability_map.png", width: 100%),
//   caption: [Visualization of the vesselness probability as defined by the Frangi feature. Intensity corresponds to vesselness probability. Also visible, user placed points used to guide the algorithms.],
// )
// #v(0.2cm)
// // To go beyond the limitations of threshold based segmentation, the generalized C++ implementation of Frangi in SimpleITK was used. The algorithm was applied at multiple scales (different expected vessel sizes) with the outputs collected together into a probability map. Frangi is known for having multiple hyperparameters that require fine tuning: in order to offer the user a simple solution, the parameters for the minimum and maximum vessel scale are pre-defined, and the vessel parameters fixed. 

// ==== Localized intensity probability

// TODO: re-write this with updated text. This is stageLocalIntensityProb
// Each pixel calculates a vesselness probability based on the intensity characteristics of the user provided points. From this step and the Frangi vesselness, a combined _likelihood map_ is created of the vesselness to directly rule out most potential points (a point with a grey value outside of the intensity range of user annotated points and not having a tubular structure is unlikely to be a point providing direct evidence of a vessel).

// NOTE: this step, because of its locality, means that a strong signal will drown out surrounding ones. One of the reasons behind needing to rebuild the network


// ==== Combining intensity with Frangi
// Combine frangi with intensity map probMap = (frangi x p_intensity).astype(np.float32, copy=False)
// Here talk about how we use the combination of both to remove some of the noise and re-introduce the greyvalue weight since frangi abstracts it

// ==== Ridge extraction & iteration

// TODO: rewirte this based on stageGrowFromPMap. It does stageRidgeExtract, then stageAutoSeed over n_rounds, 
// As the user has already provided vessel points, it is reasonable to assume that high valued points attached to the annotation are vessel. As a result, it makes sense to leverage these points with this prior in mind: ridge following is implemented, using TubeTK ridge extraction. Ridge following involves expanding outward by following high _likelihood_ ridges. This step runs in multiple loops to iteratively extend the vessels.

// ==== Blob removal
// TODO: maybe remove because this is now purely done in the stageGrowFromPMap. OLD: Large circular or blob shaped detections are removed by filtering based on a defined probability threshold, exploiting the fact that blobs contain multiple tubes connected with low likelihood to eachother.


// === User feedback
// After the pipeline is run, a binary segmentation mask is produced and visualized in the 3D Viewer for the user. There is then the possibility of loading a manually segmented DICOM subregion for evaluation based on the DICE and connectivity aware clDice metrics.

// #figure(
//   image("../../resources/images/zoomed_output_region.png", width:90%),
//   caption: [View of the feedback box with segmentation performance measurement based on the provided subregion for evaluation.],
// ) <evaluation_window>


// TODO: add pipeline-data-flow diagram



#pagebreak()
== Hyperparameter sensitivity analysis

// TODO: expand! 

// What parameters were swept with explicit ranges (you mention vessel_size, vessel_std, structure_strength but not the values tested — currently a reader has to look at your code).
// How many points in the sweep (10 variants × 50 thresholds × 6 scans = 3000 evaluations? Make this concrete).
// What "best parameters" means operationally — best mean Dice across all 6 scans? Best worst-case scan? Best per scan separately? The current text says "combination of precision-recall, DICE/clDICE and qualitative visual evaluation" which is honest but vague.
// A table of final parameters with brief justification for each. This is what reproducers will copy.
// Either a heatmap or per-parameter line plot showing how performance varies along one axis. The current PR curve only shows pipeline vs thresholding for one scan — not a sensitivity analysis. Add a small-multiples chart (one panel per parameter, x-axis = parameter value, y-axis = Dice) using your sweep data.

In order to explore the region space of possible hyperparameters and develop the pipeline, a grid search of possible settings was done and evaluated based on precision and recall metrics for a collection of annotated data containing both small vessels, large vessels, high and low noise as well as outside regions with shell effect. It is noted during the exploration that large vessels were the main obstacle - they are effectively removed when the range of vessel size and standard deviation is set low (this is intentional and meant to remove areas of noise). Bellow is an illustrative demonstration of the results of the sweep: 

#figure(
    xy-curve(
    (
      (csv: "../../../resources/images/results/new_pipeline_may_15/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
        label: "Thresholding",      colour: rgb("#e63946")),
      (csv: "../../../resources/images/results/new_pipeline_may_15/PIPE_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
        label: "CollaboratiVessel", colour: rgb("#457b9d")),
      // (csv: "../../../resources/images/results/new_pipeline_may_15/FRANGI_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      //   label: "Frangi", colour: rgb("#459d6b")),
    ),
    x-label: "Recall",
    y-label: "Precision",
  ),
  caption: [Parameter sweep results on CA-RU-R]
)

Optimal parameters were selected based on a combination of the precision-recall tradeoff as well as DICE/clDICE and qualitative visual evaluation of the 3D results. The final parameters are an average vessel size of 4 voxels, a standard deviation of 3, and a _Frangi strength_ (the required gradient to detect a vessel) of 3. Notably this frangi value is lower than the 5 default found in many common implementations of Frangi, highlighting the fact that our gradients are weaker than usual. 




// A method of combining the evidence provided by the different steps thresholding with other steps is required.
// The final pipeline contains the following steps applied sequentially, with relevant hyperparameters exposed to the user and auto-configured where possible based on the vessel size and standard deviation provided:

//When annotated by the user, vessels are identified on a local scale using the grey value difference between the vessel with contrast enhancing agent and the background. Grey value alone is, as laid out above, not _sufficient_, but it contributes some proof towards the presence of a blood vessel, given the presence of a grey value difference and a vessel-like shape. As a result, to obtain vessels from the user placed starting points, a series of different steps were assembled to form a _pipeline_.

// === Combining algorithms through probability maps

// In order to be able to combine the evidence provided by the localized grey value with the shape aware method frangi, and be able to  

// During the research phase, multiple relevant algorithms for vascular extraction and segmentation were identified. In order to combine the information provided by e.g. thresholding with that of frangi and explicit the process of evidence accumulation, a method called here *probability maps* was implemented where each algorithm or method saves point wise probabilities. These probability maps are the same size as the volume being analuzed, and contain a floating point value for each point [0.0-1.0]. This enabled flexibly weighing and stacking different methods to directly view the segmentation results across different steps in the pipeline. It also enables, by utilizing per method probability maps, for rapidly iterating the weights used to obtain the final segmentation. 

// #v(0.4cm)
// #figure(
//   image("../../resources/software/frangi_probability_map.png", width: 100%),
//   caption: [Visualization of the vesselness probability map as defined by the Frangi feature. Intensity corresponds to vesselness probability. Also visible, user placed points used to guide the algorithms.],
// )
// #v(0.4cm)






// TODO: add a note that DICE is high variance
// missing 1px of a small vessel is the same as missing a whole large vessel



// #v(0.2cm)
// After this, a binary segmentation mask is produced and visualized in the 3D Viewer for the user. There is then the possibility of loading a manually segmented DICOM subregion for evaluation based on the DICE and connectivity aware clDice metrics.

// #figure(
//   image("../../resources/images/zoomed_output_region.png", width:90%),
//   caption: [View of the feedback box with segmentation performance measurement based on the provided subregion for evaluation.],
// ) <evaluation_window>








// === Thresholding (with shell removal)

// As noted in @imaging_and_seg, the simplest method of segmentation is thresholding. Given the nature of CECT intends to give the structures of interest high grey values, this is an intuitive method with a strong prior. It is however not sufficient alone for three reasons: *(i)* the shell effect in CECT, where the contrast enhancing agent has higher concentrations on the outside or surface of the tumor, results in values that would be segmented as "vessel" even though they are not. *(ii)* grey value gradients appear between the outside and center of the samples and *(iii)* incomplete staining resulting in discontinuous vessels.

// #v(0.5cm)
// #figure(
//   image("../../resources/software/threshold_131_255_example.png", width: 75%),
//   caption: [The shortcoming of threshold based segmentation visualized, with a "shell" of high valued outside being included whe the threshold accepts the vessel segment.],
// ) <thresholding_with_shell>
// #v(0.5cm)

// The shell effect was tackled by fitting a shape to the outside of the sample, however following a user interview demonstrating the feature a critical issue was raised: in tumors, it is common for the outside to contain large and plentiful vascularization. Removal would both bias results as well as reduce the overall performance by preventing these outside vessels from being segmented. Secondly, a threshold does not hold up to the gradients in images that are present which, in prior work carried out on this data, resulted in rejection of samples with a gradient considered too large. Finally, standard thresholding does not do anything to combat the incomplete staining resulting in discontinuous vessels. As a result, thresholding was utilized in the probability map stacking after shell removal, but given a low contribution.




// === Gap bridging

// As other steps had the tendency to result in disconnected regions, as well as given the knowledge that the staining method itself resulted in disconnected regions, a gap bridging step that attempted to link nearby disconnected island was identified as relevant to test. Three different methods were added: _opening/closing_, a classical method in connecting disconnected areas, _island reconnection_ aiming to connect areas identified as islands by attempting to connect them using a minimal-cost path based on grey values, with a defined upper bound on path length to limit computation, and a _structurally aware reconnection_ method that used skeletonization to first identify the ends of vessels, and then for each pair of disconnected vessel ends within a defined radius, attempts to reconnect them using a minimal cost path across the probability map.

// #v(0.5cm)
// #figure(
//   image("../../resources/software/bridging_working_cropped.png", width: 50%),
//   caption: [Structurally aware reconnection: *Red:* vessels as identified by other steps. *Yellow:* Bridges between tubular endpoints. #footnote[3DSlicer smooths visualizations in 3D without combining different classes. The final segmentaton here is unifrom and continuous.]],
// ) <fig:gap_bridging>
// #v(0.5cm)


// === Leveraging user placed points

// //TODO: validate that marching cubes is intensity driven?
// As the user has already provided high confidence starting points in the form of annotations, it is reasonable to assume that high valued points attached to the annotation are vessel. As a result, it makes sense to leverage these points with this prior in mind: to do so, ridge following is implemented, using TubeTK ridge extraction. Ridge following involves expanding an area based on the contrast gradient 


//As a result, two methods were used to "expand" user points: the marching cubes algorithm as mentioned in Lesage _et al_ @LESAGE2009819, and a tube prior algorithm proposed by ITKTubeTK: itktubeTubeExtractor that extracts tubular structures associated with the points. These areas attached to high confidence annotations were then extracted and used to train a small machine learning model: a random forest classifier, with the goal of recovering vessel regions outside the user's annotation neighborhood.

// #linebreak()
// TODO: add final ML method


// intermediary image - not relevant
// #v(1.5cm)
// #figure(
//   image("../../resources/software/long_pipeline_promising_cropped.png", width: 80%),
//   caption: [Visualization of the segmentation following the multi stage pipeline during development. Successful continuous vessel segmentation and few small noisy sections. Performance, as measured using user annotated points, of 26/27 vessels and 16/16 background points correctly classified. Also visible: Blob-like artifacts from flood fill weight not being suppressed by Frangi, alongside disconnections in due to larger low signal areas.],
// )
// #v(0.5cm)






// #pagebreak()
// == Ablation study: measuring component contribution

// It is common for software approaches comprising multiple steps to not correctly quantify the contribution of each individual step to the overall algorithm performance, as well as its impact on resource utilization and computation time. Initial plugin development used the CA-LL-R dataset, the smallest uncompressed dataset @uncompressed_dataset_size, to enable rapid prototyping and evaluation of the performance. Total memory usage was high, approaching the limits of the device used for testing and development, and inference time reaching into the hours. 

// // #v(0.5cm)
// // #figure(
// //   image("../../resources/misc/RAM_cpu_use_during_a_run_cropped_ram_only.png", width: 90%),
// //   caption: [TODO - REMOVE: RAM utilization before & during segmentation: baseline after loading dataset, below 24GB utilization. During processing 100% of the RAM and swap are used, meaning that this dataset already represented the approxumate upper bound to dataset size able to be processed at this point.],
// // ) <RAM_use>
// // #v(0.5cm)

// #linebreak()
// As a result, to properly understand the performance/cost tradeoff of the steps, and enable the expansion of the testing to the larger datasets, it was decided to perform an ablation study. In order to ablate the algorithm, the weights of the probability map of each step was set to 0 except the one under test, which was done for all the parameters of the pipeline. For performance measurements, RAM and CPU utilization were monitored alongside runtime with unused steps disabled. This showed that the Frangi vesselness step was the most important to obtaining high vessel extraction performance, offering the same 26/27 correctly classified vessel points as the full pipeline. Additionally the performance evaluation method was highlighted as lacking: false positives and discontinuities in the blood vessels were not properly penalized, and small vessels were not being correctly segmented; all things that point wise annotations fail to capture.




// #linebreak()
// Methods exist to handle such large datasets: the most basic approach is cutting down of full scans into smaller chunks, or subsampling the scans with some form of interpolation. Cutting scans down has the disadvantage of requiring stitching after running algorithms, and if done using 3D slicer's built in slicing, requires the ability to load the full dataset. An experiment was run, where a target scan was cut into 4 smaller sections using Python; this proved to be unwieldy for annotation and running the pipeline. Subsampling requires the the target structures to be large enough to allow it: subsampling to 1/4 resolution means that any vessel 4 voxels across would be reduced to approximately a single voxel.

// Handling large datasets can also be done at the format and loading level: HDF5 is intended to _store_ such large multidimensional arrays and efficiently enable loading subsections, however this data storage format is totally incompatible with most medical imaging software, and is not the standard used by CT machines. Standards such as DICOM did not provision for the possibility that data such as those generated by micro-CT may exist in the future in the medical domain, and do not deal well with dynamically loading large datasets from memory. To _operate on_ large multidimensional arrays in Python, there exist libraries such as #link("https://www.dask.org/")[Dask] that enable "chunking" of the data to process smaller areas: this could enable improved scaling to larger scans.

// #linebreak()
// These performance concerns highlight a continuous issue encountered during the writing of this thesis: the complexity of methods able to be tested was limited by the choice of software, volume of data and the hardware available. Lab computers available to students have 32GB of ram, less than the computer used for the testing and writing of code, and it was noted by previous students working on MicroCT imaging that they had struggled to run algorithms across the whole image. In the end, much effort was invested in the research, testing and optimization of the algorithms, and runtime concerns pushed development towards the use of methods implemented in C++ available with Python bindings, such as the SimpleITK Frangi filter used. 

// === Ablation methodology



// #import "@preview/tblr:0.5.0": *
// #import "@preview/plotst:0.2.0": *

// #let data = from-csv(delimiter: "|", "
// Baseline                            | 1  | 9    | NA  | NA      | 0
// Loaded dataset & point annotation   | 1  | 13   | NA  | NA      | 0
// Pre-processing (shell, thresholding)| 1  | 13.4 | 19  | 24 of 27| 108
// Vesselness                          | 20 | 22.5 | 38.4| 26 of 27| 179
// Gap bridging                        | 1  | 28   | 28  | Minor   | 225
// Tree training and inference         | 1  | 16   | 36.2| Minor   | 5973
// ")

// #let bar(x) = {
//   rect(width: int(x) / 9000 * 2in, fill: blue, text(fill: black, x))
//   }

// #figure(
//   tblr(columns: 6,
//     stroke: none,
//     align: center+horizon,
//     // formatting directives
//     rows(within: "header", auto, fill: aqua.lighten(60%), hooks: strong),
//     cols(within: "body", 0, align: left, fill: gray.lighten(70%), hooks: strong),
//     cols(within: "body", -1, align: left, hooks: bar),
//     // content
//     table.header([Method],[CPU\ Threads],[RAM\ GB],[RAM\ Peak GB],[Performance\ Contribution], [Inference\ Time (s)]),
//     ..data,
//     caption: [Ablation study measurements of principal steps on CA-LL-R with development machine @pc_specs. Performance measured in correctly classified vesssel points. 
    
//     _TODO: revisit this with more detail and update figures._],
//   )
// )

// === Findings

// The removal of _shell removal_ resulted in improved performance for extraction of vessels in the outer shell, as noted previously being a crucial point. _Gap bridging_ was not identified as being a substantial performance consumer, and did not influence performance metrics but, as it operates on areas that are lacking annotations, it was not possible to know if its contribution was relevant using user annotated points. _Random forest_ removal resulted in a large performance gain: vessel extraction went from taking multiple hours to under 20 minutes. It also successfully reduced RAM and swap usage, enabling effective running of the algorithm on larger samples. Additionally, the _probability map_ itself was investigated: when every step generates a 3D new volume to hold the probabilities, RAM use naturally increases. The removal of steps thus directly reduces RAM use, and subsequently it was decided to unify the probability accumulation into a single, shared map for all steps. 

// #linebreak()
// As a result of this ablation study, the shell removal was removed, the probability map was condensed, and machine learning was moved to an exteral optional step, with focus for the final algorithm on use of a simple, scientifically grounded extraction based on frangi with a step for combatting the disconnections in vessels, and an improvement in the performance measurement method in the form of manually annotated data.



