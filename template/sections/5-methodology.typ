
// These three analysis methods were favored by different users: those having been in the team a long time had adapted to the team standard of Avizo, Dragonfly3D was used by team members with previous experience or wanting to use software on their own devices, and the "bare metal" approach was taken by students wishing to avoid the substantial learning curve and friction involved with the use of the aforementioned software.


// In order to maintain interoperability the 3D Slicer plugin needed to export data in one of two ways: *(i)* a fashion that transparently fits into the existing pipeline, namely that of exporting raw binary segmentations that could then be re-imported elsewhere *(ii)* an export format that better enforces scientific rigor and enables easier data sharing, in the form of DICOM. This second option will offer the team growth perspectives in opening the door for easier collaboration with computer scientists as well as other researchers downstream.

// #import "appendices/precision_recall_old.typ": pr-curve


#import "./appendices/graph_results.typ": results-chart
#import "appendices/precision_recall.typ" : xy-curve


= Methodology
// OLD: This chapter documents the development of the 3D Slicer plugin, from the implementation and user interaction, through the method for combining algorithms and the different algorithms explored, and ending in an ablation study to simplify the pipeline and enable usable runtimes and memory use.


// In order to understand the challenge at hand, it is important to begin by looking at how thresholding performs. In @fig:pr_methodo we run a sweep across all possible thresholding values, and measure against a manually annotated ground truth on an illustrative subvolume that contains small disconnected vessles, a light gradient, and some noisy elements. A precision-recall curve is used as it ignores true negatives and avoids giving them an outsized weight, but still allows us to understand the problem at hand: thresholding, no matter how high, will include false positives (_all high valued pixels are not necessarily voxels, the strucutral gap (1)_) and at low values needed to capture faint vessels, the false positives are very high (_low vessel contrast results in challenging extraction (2)_).


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
With these issues in mind, development of the plugin began: 3D Slicer is multi platform and bulilt around plugins to carry out tasks, communicating using the Medical Reality Markup Language (MRML) @MRML_diagram, where modules read and write to MRML nodes to enable interoperability. These plugins can be implemented in one of three forms: as command line interface (CLI) tools where they may be called as an encapsulated piece of code, the most abstracted way of working with external code or a C++/Scripted (Python) loadable module @SlicerTutorialPerkins. The Scripted loadable approach was selected for its use of Python, lowering the barrier to entry, ability to use the UI features of 3D Slicer, and having access to the full slicer API. Work was carried out in Visual Studio Code under Ubuntu 24.04.

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


== Combining algorithms through probability maps

During the research phase, multiple relevant algorithms for vascular extraction and segmentation were identified. In order to combine the information provided by e.g. thresholding with that of frangi and explicit the process of evidence accumulation, a method called here *probability maps* was implemented where each algorithm or method saves point wise probabilities. These probability maps are the same size as the volume being analuzed, and contain a floating point value for each point [0.0-1.0]. This enabled flexibly weighing and stacking different methods to directly view the segmentation results across different steps in the pipeline. It also enables, by utilizing per method probability maps, for rapidly iterating the weights used to obtain the final segmentation. 

#v(0.4cm)
#figure(
  image("../../resources/software/frangi_probability_map.png", width: 100%),
  caption: [Visualization of the vesselness probability map as defined by the Frangi feature. Intensity corresponds to vesselness probability. Also visible, user placed points used to guide the algorithms.],
)
#v(0.4cm)






== Pipeline components

To obtain a segmentation on the challenging data provided, no clear single method appeared sufficient. As a result, using techniques that have diverse trade-offs is relevant.

//When annotated by the user, vessels are identified on a local scale using the grey value difference between the vessel with contrast enhancing agent and the background. Grey value alone is, as laid out above, not _sufficient_, but it contributes some proof towards the presence of a blood vessel, given the presence of a grey value difference and a vessel-like shape. As a result, to obtain vessels from the user placed starting points, a series of different steps were assembled to form a _pipeline_.


=== Thresholding (with shell removal)

As noted in @imaging_and_seg, the simplest method of segmentation is thresholding. Given the nature of CECT intends to give the structures of interest high grey values, this is an intuitive method with a strong prior. It is however not sufficient alone for three reasons: *(i)* the shell effect in CECT, where the contrast enhancing agent has higher concentrations on the outside or surface of the tumor, results in values that would be segmented as "vessel" even though they are not. *(ii)* grey value gradients appear between the outside and center of the samples and *(iii)* incomplete staining resulting in discontinuous vessels.

#v(0.5cm)
#figure(
  image("../../resources/software/threshold_131_255_example.png", width: 75%),
  caption: [The shortcoming of threshold based segmentation visualized, with a "shell" of high valued outside being included whe the threshold accepts the vessel segment.],
) <thresholding_with_shell>
#v(0.5cm)

The shell effect was tackled by fitting a shape to the outside of the sample, however following a user interview demonstrating the feature a critical issue was raised: in tumors, it is common for the outside to contain large and plentiful vascularization. Removal would both bias results as well as reduce the overall performance by preventing these outside vessels from being segmented. Secondly, a threshold does not hold up to the gradients in images that are present which, in prior work carried out on this data, resulted in rejection of samples with a gradient considered too large. Finally, standard thresholding does not do anything to combat the incomplete staining resulting in discontinuous vessels. As a result, thresholding was utilized in the probability map stacking after shell removal, but given a low contribution.


=== Frangi vesselness  

To go beyond the limitations of threshold based segmentation, the generalized C++ implementation of Frangi in SimpleITK was used. The algorithm was applied at multiple scales (different expected vessel sizes) with the outputs collected together into a probability map. Frangi is known for having multiple hyperparameters that require fine tuning: in order to offer the user a simple solution, the parameters for the minimum and maximum vessel scale are pre-defined, and the vessel parameters fixed. 


=== Gap bridging

As other steps had the tendency to result in disconnected regions, as well as given the knowledge that the staining method itself resulted in disconnected regions, a gap bridging step that attempted to link nearby disconnected island was identified as relevant to test. Three different methods were added: _opening/closing_, a classical method in connecting disconnected areas, _island reconnection_ aiming to connect areas identified as islands by attempting to connect them using a minimal-cost path based on grey values, with a defined upper bound on path length to limit computation, and a _structurally aware reconnection_ method that used skeletonization to first identify the ends of vessels, and then for each pair of disconnected vessel ends within a defined radius, attempts to reconnect them using a minimal cost path across the probability map.

#v(0.5cm)
#figure(
  image("../../resources/software/bridging_working_cropped.png", width: 50%),
  caption: [Structurally aware reconnection: *Red:* vessels as identified by other steps. *Yellow:* Bridges between tubular endpoints. #footnote[3DSlicer smooths visualizations in 3D without combining different classes. The final segmentaton here is unifrom and continuous.]],
) <gap_bridging>
#v(0.5cm)


=== Leveraging user placed points

//TODO: validate that marching cubes is intensity driven?
As the user has already provided high confidence starting points in the form of annotations, it is reasonable to assume that high valued points attached to the annotation are vessel. As a result, it makes sense to leverage these points with this prior in mind: to do so, ridge following is implemented, using TubeTK ridge extraction. Ridge following involves expanding an area based on the contrast gradient 

//As a result, two methods were used to "expand" user points: the marching cubes algorithm as mentioned in Lesage _et al_ @LESAGE2009819, and a tube prior algorithm proposed by ITKTubeTK: itktubeTubeExtractor that extracts tubular structures associated with the points. These areas attached to high confidence annotations were then extracted and used to train a small machine learning model: a random forest classifier, with the goal of recovering vessel regions outside the user's annotation neighborhood.

#linebreak()
TODO: add final ML method


#v(1.5cm)
#figure(
  image("../../resources/software/long_pipeline_promising_cropped.png", width: 80%),
  caption: [Visualization of the segmentation following the multi stage pipeline during development. Successful continuous vessel segmentation and few small noisy sections. Performance, as measured using user annotated points, of 26/27 vessels and 16/16 background points correctly classified. Also visible: Blob-like artifacts from flood fill weight not being suppressed by Frangi, alongside disconnections in due to larger low signal areas.],
)
#v(0.5cm)






#pagebreak()
== Ablation study: measuring component contribution

It is common for software approaches comprising multiple steps to not correctly quantify the contribution of each individual step to the overall algorithm performance, as well as its impact on resource utilization and computation time. Initial plugin development used the CA-LL-R dataset, the smallest uncompressed dataset @uncompressed_dataset_size, to enable rapid prototyping and evaluation of the performance. Total memory usage was high, approaching the limits of the device used for testing and development, and inference time reaching into the hours. 

#v(0.5cm)
#figure(
  image("../../resources/misc/RAM_cpu_use_during_a_run_cropped_ram_only.png", width: 90%),
  caption: [RAM utilization before & during segmentation: baseline after loading dataset, below 24GB utilization. During processing 100% of the RAM and swap are used, meaning that this dataset already represented the approxumate upper bound to dataset size able to be processed at this point.],
) <RAM_use>
#v(0.5cm)

#linebreak()
As a result, to properly understand the performance/cost tradeoff of the steps, and enable the expansion of the testing to the larger datasets, it was decided to perform an ablation study. In order to ablate the algorithm, the weights of the probability map of each step was set to 0 except the one under test, which was done for all the parameters of the pipeline. For performance measurements, RAM and CPU utilization were monitored alongside runtime with unused steps disabled. This showed that the Frangi vesselness step was the most important to obtaining high vessel extraction performance, offering the same 26/27 correctly classified vessel points as the full pipeline. Additionally the performance evaluation method was highlighted as lacking: false positives and discontinuities in the blood vessels were not properly penalized, and small vessels were not being correctly segmented; all things that point wise annotations fail to capture.


// #linebreak()
// Methods exist to handle such large datasets: the most basic approach is cutting down of full scans into smaller chunks, or subsampling the scans with some form of interpolation. Cutting scans down has the disadvantage of requiring stitching after running algorithms, and if done using 3D slicer's built in slicing, requires the ability to load the full dataset. An experiment was run, where a target scan was cut into 4 smaller sections using Python; this proved to be unwieldy for annotation and running the pipeline. Subsampling requires the the target structures to be large enough to allow it: subsampling to 1/4 resolution means that any vessel 4 voxels across would be reduced to approximately a single voxel.

// Handling large datasets can also be done at the format and loading level: HDF5 is intended to _store_ such large multidimensional arrays and efficiently enable loading subsections, however this data storage format is totally incompatible with most medical imaging software, and is not the standard used by CT machines. Standards such as DICOM did not provision for the possibility that data such as those generated by micro-CT may exist in the future in the medical domain, and do not deal well with dynamically loading large datasets from memory. To _operate on_ large multidimensional arrays in Python, there exist libraries such as #link("https://www.dask.org/")[Dask] that enable "chunking" of the data to process smaller areas: this could enable improved scaling to larger scans.

// #linebreak()
// These performance concerns highlight a continuous issue encountered during the writing of this thesis: the complexity of methods able to be tested was limited by the choice of software, volume of data and the hardware available. Lab computers available to students have 32GB of ram, less than the computer used for the testing and writing of code, and it was noted by previous students working on MicroCT imaging that they had struggled to run algorithms across the whole image. In the end, much effort was invested in the research, testing and optimization of the algorithms, and runtime concerns pushed development towards the use of methods implemented in C++ available with Python bindings, such as the SimpleITK Frangi filter used. 

// === Ablation methodology



#import "@preview/tblr:0.5.0": *
#import "@preview/plotst:0.2.0": *

#let data = from-csv(delimiter: "|", "
Baseline                            | 1  | 9    | NA  | NA      | 0
Loaded dataset & point annotation   | 1  | 13   | NA  | NA      | 0
Pre-processing (shell, thresholding)| 1  | 13.4 | 19  | 24 of 27| 108
Vesselness                          | 20 | 22.5 | 38.4| 26 of 27| 179
Gap bridging                        | 1  | 28   | 28  | Minor   | 225
Tree training and inference         | 1  | 16   | 36.2| Minor   | 5973
")

#let bar(x) = {
  rect(width: int(x) / 9000 * 2in, fill: blue, text(fill: black, x))
  }

#figure(
  tblr(columns: 6,
    stroke: none,
    align: center+horizon,
    // formatting directives
    rows(within: "header", auto, fill: aqua.lighten(60%), hooks: strong),
    cols(within: "body", 0, align: left, fill: gray.lighten(70%), hooks: strong),
    cols(within: "body", -1, align: left, hooks: bar),
    // content
    table.header([Method],[CPU\ Threads],[RAM\ GB],[RAM\ Peak GB],[Performance\ Contribution], [Inference\ Time (s)]),
    ..data,
    caption: [Ablation study measurements of principal steps on CA-LL-R with development machine @pc_specs. Performance measured in correctly classified vesssel points. 
    
    _TODO: revisit this with more detail and update figures._],
  )
)

=== Findings

The removal of _shell removal_ resulted in improved performance for extraction of vessels in the outer shell, as noted previously being a crucial point. _Gap bridging_ was not identified as being a substantial performance consumer, and did not influence performance metrics but, as it operates on areas that are lacking annotations, it was not possible to know if its contribution was relevant using user annotated points. _Random forest_ removal resulted in a large performance gain: vessel extraction went from taking multiple hours to under 20 minutes. It also successfully reduced RAM and swap usage, enabling effective running of the algorithm on larger samples. Additionally, the _probability map_ itself was investigated: when every step generates a 3D new volume to hold the probabilities, RAM use naturally increases. The removal of steps thus directly reduces RAM use, and subsequently it was decided to unify the probability accumulation into a single, shared map for all steps. 

#linebreak()
As a result of this ablation study, the shell removal was removed, the probability map was condensed, and machine learning was moved to an exteral optional step, with focus for the final algorithm on use of a simple, scientifically grounded extraction based on frangi with a step for combatting the disconnections in vessels, and an improvement in the performance measurement method in the form of manually annotated data.





// TODO: add a note that DICE is high variance
// missing 1px of a small vessel is the same as missing a whole large vessel
#pagebreak()
== A simplified, scalable pipeline

The final pipeline contains the following steps applied sequentially, with relevant hyperparameters exposed to the user and auto-configured where possible based on the vessel size and standard deviation provided:


==== Gaussian denoising 
Gaussian denoising is used to  remove scan and jpeg compression noise, as also applied in @wlodarski
==== Frangi vesselness
Frangi is applied across multiple scales, to identify tubular structures.
Additionally, tiling is optionally applied to avoid this step being a memory bottleneck. This tiling involves calculating on subregions and then assembling into the full volume. This however remains a memory hungry step
==== Intensity likelyhood
Each pixel calculates a vesselness probability based on the intensity characteristics of the user provided points. From this step and the Frangi vesselness, a combined likelyhood map is created of the vesselness to directly rule out most potential points.
==== Ridge extraction
For each user placed point, ridge extraction is carried out to grow the vessel regions outwward by followinghigh likelyhood ridges. This step makes heavy use of the size priors provided by the user and runs in multiple loops.
==== Seed discovery
New potential vessels are discovered using the vessel intensities extracted from user points and vesselness likelyhood from the combined map. 
==== Large blob removal
Large circular or blob shaped detections are removed by filtering based on a defined probability threshold, exploiting the fact that blobs contain multiple tubes connected with low likelyhood to eachother.

#v(0.2cm)
After this, a binary segmentation mask is produced and visualized in the 3D Viewer for the user. There is then the possibility of loading a manually segmented DICOM subregion for evaluation based on the DICE and connectivity aware clDice metrics.

#figure(
  image("../../resources/images/zoomed_output_region.png", width:90%),
  caption: [View of the feedback box with segmentation performance measurement based on the provided subregion for evaluation.],
) <evaluation_window>
