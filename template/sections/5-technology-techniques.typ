= Materials and Methods

This chapter focuses on the work carried out going from the raw data, problem statement, and prior knowledge of the team members to the final delivered solution. 
The selected software for implementation is discussed, followed by the  

== Software for 3D Data analysis

=== Introduction

As discussed in the introduction, a variety of different pieces of software exist intended for use in analyzing 3D data. The prior experience of the team centered around three major poles: Avizo: a proprietary and paid software, Dragonfly3D: a free for academics "license" software, and a "bare metal" approach. These three analysis methods were favored by different profiles of users: those having been in the team a long time had adapted to the team standard of Avizo, which was also the recommended starting point for new joiners; Dragonfly3D was used by team members that had previously worked on data elsewhere and used software on their own devices, and the "bare metal" approach was taken by students who wished to avoid the substantial learning curve and friction involved with using one of the two aforementioned softwares. 

#linebreak()
These software are used in the context of analysis of CT data: users receive data from the CT machine in the form of a collection of 16 bit TIFF files: heavy, with a single 2000x2300 slice weighing *9.2MB*, and a whole 2400 slice scan weighing in at *22.1GB*, they are then windowed to 8 bit, often BMP images, and the empty slices are removed: this results in approximately a halving in total data amount. This windowing process was documented as being unprincipled: the window was chosen based on the researchers best judgment, and the original data discarded.

Furthermore, certain researchers would then compress the data in the form of JPEG image slices, as was the case with the data used in this thesis: the scans provided ranged from *0.103* to *13.2GB* (597x698x854 to 3000x3000x2653) and the original lossless data was not preserved, in both cases the windowing and the compression were motivated by data storage cost concerns.

Finally, the provided data was generally given with little or no context: the data was provided in the form of a folder containing images as well as experiments that were run, with no associated dates and without grounding context such as the scan voxel size or parameters of the scanning machine.

// TODO: Insert image of the provided folder/data? 

=== Software selection

Initially, the approach proposed was that of creating a plugin for Avizo and/or Dragonfly3D, in order to minimize the change to the pipeline the researchers have experience in. Following a week of experiments to create a plugin, this was dropped in favor of 3D Slicer: the wide availability of example software and instructions, increased scientific rigor and ability to run without a license were devisive.

In order to maintain interoperability with the pipeline in use within the lab, the decision was made to ensure that any plugin made for 3D Slicer would be able to export data in two ways: *(i)* a fashion that transparently fits into the existing pipeline, namely that of exporting raw binary segmentations that could then be re-imported into another program such as Avizo or Drangofly, and *(ii)* that of exporting data in a format that better enforces scientific rigor and enables easier data sharing, in the form of DICOM. This second option will offer the team growth perspectives in opening the door for easier collaboration with computer scientists as well as other researchers downstream.


=== Plugin development

As the 3D Slicer ecosystem is diverse with many existing tools, the approach to making a custom plugin was carried out in a similar fashion to that of this thesis: initially, research was done on the available plugins with similar goals (vascular extraction) and similar data formats (high resolution CT). These were tested, before the methodology for developping a plugin was researched.

==== Plugins tested

// TODO: refer to the SOTA
As discussed in section XX, the list of available plugins with similar use-cases was wide. However these plugins often had issues in practice when being ran: there was issues with plugins not being up-to-date, or plugins simply not able to run on the provided data, providing outputs that showed issues in the code logic. This is despite 3D Slicer having two classes of plugins: "official" via the extension manager @SlicerDocsExtensions and user installable or "non official". 
// TODO: refer to the photo of the non working plugin 

As a result, after testing various plugins the following common limitations came to surface:
- Memory usage was generally high
- 3D Slicer hangs when executing algorithms, and this execution happens without communication. The OS will ask the user if they wish to stop the program.
- UI development was restrictive, with the main UI elements being forced to be in the left corner
- Execution in python was inefficient. Calling external libraries was interesting from a performance perspective
- Machine learning extensions did not come pre-packaged with the model weights
- Errors during installation were not user-friendly enough for a non computer scientist to be able to debug an installation problem
- The 3D Slicer forums contained ample amounts of users having issues with different plugins


==== Developping a 3D Slicer plugin

// https://www.slicer.org/wiki/Documentation/Nightly/Training#Tutorials_for_software_developers
The 3D Slicer plugin was developped following the indications in @SlicerTutorialPerkins. 3D Slicer is based on MRML (Medical Reality Markup Language), where modules communicate through reading/writing MRML nodes. 

#figure(
  image("../../resources/software/Scripted_Module_Implementation.png", width: 80%),
  caption: [Structure for module implementation from @SlicerTutorialPerkins],
)

The three module types (C++ loadable, Scripted loadable and CLI) were compared, and the Scripted loadable approach selected due to it being in Python, with access to the full slicer API and being noted as the "simplest way to extend/customize Slicer". 








#pagebreak()
== Segmentation of tumor vascularization
// TODO: add overview of steps?
Once the groundwork laid for a 3D Slicer plugin, an initial experimental plugin was developped that took in the data from the slices and, using a configurable threshold, output a segmented 3D volume. This threshold based segmentation was evaluated to validate the basic functionality of buttons and to learn how 3D Slicer plugins are constructed. Following this learning step, implementation began. // and served as the basis for the subsequent features: // augmented iteratively to add the features required, which were extracted from the meetings with supervisors and lab members. These problems and the chosen solutions are broken down from the initial problem statement in @prob_statement:

=== Enforcing a principled approach
 
During user interviews it was noted that software users often made decisions without a principled, data driven decision method as mentioned in the problem statement @prob_statement; thresholds such as for windowing and grey value were selected based on expertise. This approach is naturally problematic for multiple reasons:

1. As the selected values are not data driven, decisions and pipelines cannot easily be replicated, and are more fragile
2. As the user acts as the evaluator to the actions done, they induce bias in the subsequent steps
3. Any user without knowledge of the downstream steps or what to look out for will not be able to make a fully informed decision for the hyperparameters to select, requiring iteration and potentially falling into local optima.

Due to this, it was early on decided that a more principled approach was required: in order to select thresholds and evaluate the performance of the algorithm "in the loop", as well as offer the user immediate feedback, a system of anchor points was implemented. These anchors are the first step in the process, and are obtained by having the user click "add" followed by placing the point in any of the 2D windows. They can be saved and exported, as well as imported. Following the learning that users often do not take the time to properly name files and folders, the name when exporting is automatically constructed from the current data series name and description, as well as the full current date and time.

A second key element implemented to guide downstream steps was the expected vessel size and deviation in voxels. This parameter is easy to measure by the user by moving the mouse to count voxels, and is critical for certain steps such as the subsequent seed annotation analysis.

// TODO: revise this, ideally 3 images
#figure(
  grid(
    columns: 2,
    rows: 2,
    gutter: 3pt,
    image("../../resources/software/overview_seed_vessel_param.png"),
    image("../../resources/software/Annotation_tooltip.png"),
    image("../../resources/software/annotation_tool_pane.png"),
    image("../../resources/software/feedback_pane_after_seed_analysis.png", width: 70%),
  ),
  caption: [Clockwise: 1. View of the seed annotation and vessel size definition 2. up close of the placement tooltip, 3. with the resulting seed analsis output visualization in the feedback pane],
)

One the annotation and point parameter visualization was completed, the steps of vessel extraction were ready to be implemented.


=== Implementation of segmentation

As noted in @imaging_and_seg, the simplest method of segmentation is threhsolding, given the nature of CECT it is the goal that the tissues of interest are those with high values, with all other having low grey value. This however does not work in practice:


During the implementation phase, 



// In order to place the end user is placed in the segmentation loop and offers feedback to the algorithms
//   1. The selected approach for this was the placement of so called "anchor" points, points the user has identified as being either *(i)* vessel, *(ii)* background/non vessel and *(iii)* outside of volume
// 1. A method that makes use of existing, extendable software 3DSlicer @3Dslicer_paper
//   1. The plugin is impleted in 3D Slicer and uses the standard interface
// 2. A method that integrates voxel level metrics such as DICE @og_dice_loss and vasculature relevant metrics such as @clDice_loss_func and @CFLoss_loss_func
// 3. A method that is well documented, and enables reproducibility
// 4. A method that outputs a portable format of segmentation, namely voxel level segmentation, as individual slices or a DICOM imaging format 



===

