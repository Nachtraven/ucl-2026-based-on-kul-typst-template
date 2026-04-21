// Chapter 1: Plugin development and vasculature extraction MVP
//    Software for 3D Data analysis
//      Plugin development
//    Segmentation of tumor vascularization
//      Enforcing a principled approach
//      Implementation
//        Threhsolding
//        Algorithmic extraction
//    Results

// Chapter 2: Ablation study and performance review
//    Motivations for ablation
//    Performance concerns
//      Data formats for performance
//      Data loading for performance
//    Conclusion

// Chapter 3: Micro vasculature extraction
//    Final algorithm implementation
//    Evaluation method
//      Annotation
//      Calculating loss
//    Results on all data

// After -> results


= Plugin development and vasculature extraction prototype <data_intro>

// This chapter focuses on the work carried out going from the raw data, problem statement, and prior knowledge of the team members to the final delivered solution. 
// The selected software for implementation is discussed, followed by the  

As discussed in the introduction, a variety of different pieces of software exist intended for use in analyzing 3D data. The prior experience of the team centered around three major poles: Avizo: a proprietary and paid software, Dragonfly3D: with either a "FreeD" free-for-academics or paid commercial licenses, and a "bare metal" code only approach. These three analysis methods were favored by different profiles of users: those having been in the team a long time had adapted to the team standard of Avizo, which was also the recommended starting point for new joiners; Dragonfly3D was used by team members that had previously worked on data elsewhere and used software on their own devices, and the "bare metal" approach was taken by students who wished to avoid the substantial learning curve and friction involved with using one of the two aforementioned softwares to carry out basic analysis.

Avizo and Dragonfly3D were explored as potential candidates for the creation of a vessel extraction tool, however following a comparison with open source alternatives that would offer better extendability and re-usability by other researchers, it was decided to move forward with 3D Slicer due to its wide availability of example software, instructions for plugin creation and existing vascularization extraction tools @vmtk. 

In order to maintain interoperability with the pipeline in use within the lab, any plugin made for 3D Slicer must be able to export data in two ways: *(i)* a fashion that transparently fits into the existing pipeline, namely that of exporting raw binary segmentations that could then be re-imported into another program such as Avizo or Drangofly, and *(ii)* that of exporting data in a format that better enforces scientific rigor and enables easier data sharing, in the form of DICOM. This second option will offer the team growth perspectives in opening the door for easier collaboration with computer scientists as well as other researchers downstream.


== Plugin development

As the 3D Slicer ecosystem is diverse with many existing tools, research was done on the available plugins with similar goals (vascular extraction) and similar data formats (high resolution CT). These were tested, before the methodology for developping a plugin was researched. During this exploratory phase, it was noted that many available plugins were either unmaintained, throwing errors during installation or use or did not successfully produce outputs. This is despite 3D Slicer having two classes of plugins: "official" via the extension manager @SlicerDocsExtensions and user installable or "non official". 

After testing various plugins, the following common limitations came to surface:
- 3D Slicer hangs when executing algorithms, and this execution happens without communication. The OS will ask the user if they wish to stop the program.
- UI development is restrictive: UI must be in the left corner, and few context menus are available
- Execution in Python is inefficient, and plugins that aimed to use multiple cores called external libraries
- Machine learning extensions did not come pre-packaged with the model weights
- Errors during installation were not user-friendly enough for a non computer scientist to be able to debug an installation problem
- The 3D Slicer forums contained ample amounts of users having issues with different plugins

// https://www.slicer.org/wiki/Documentation/Nightly/Training#Tutorials_for_software_developers
#linebreak()
The 3D Slicer plugin was developped following the indications in @SlicerTutorialPerkins. 3D Slicer is based on MRML (Medical Reality Markup Language), where modules communicate through reading/writing MRML nodes. 

#figure(
  image("../../resources/software/Scripted_Module_Implementation.png", width: 80%),
  caption: [Structure for module implementation from @SlicerTutorialPerkins],
)

The three module types (C++ loadable, Scripted loadable and CLI) were compared, and the Scripted loadable approach selected due to it being in Python lowering the barrier to entry and having access to the full slicer API




#pagebreak()
== Segmentation of tumor vascularization

// With groundwork laid, an initial experimental plugin was developped that took in the data from the slices and, using a configurable threshold, output a segmented 3D volume. This threshold based segmentation was evaluated to validate the basic functionality of buttons, learn how 3D Slicer plugins are constructed. Following this learning step, implementation began. // and served as the basis for the subsequent features: // augmented iteratively to add the features required, which were extracted from the meetings with supervisors and lab members. These problems and the chosen solutions are broken down from the initial problem statement in @prob_statement:

=== Principled hyper parameter selection

During user interviews it was noted that software users often made decisions without a principled, replicable and data driven decision method. Windowing and grey value were selected based on expertise, problematic for multiple reasons:

1. As the selected values are not data driven, decisions and pipelines cannot easily be replicated, and are more fragile
2. As the user acts as the evaluator to the actions done, they induce bias in the subsequent steps
3. Any user without knowledge of the downstream steps or what to look out for will not be able to make a fully informed decision for the hyperparameters to select, requiring iteration and potentially falling into local optima.

A principled approach was required: in order to select thresholds and evaluate the performance of the algorithm "in the loop", as well as offer the user immediate feedback, a system of anchor points was implemented. These anchors are the first step in the process, and are obtained by having the user click "add" followed by placing the point in any of the 2D windows. They can be saved and exported, as well as imported. Following the learning that users often do not take the time to properly name files and folders, the name when exporting is automatically constructed from the current data series name and description, as well as the full current date and time.

A second key element implemented to guide downstream steps was the expected vessel size and deviation in voxels. This parameter is easy to measure and is critical for certain steps such as the subsequent seed annotation analysis.

#figure(
  image("../../resources/software/overview_seed_vessel_param.png"),
  caption: [View of the seed annotation and vessel size definition panes. The user may press add, click on the locations in any of the right hand panes, as well as import previous annotations or export the current points.],
)

// #figure(
//   image("../../resources/software/feedback_pane_after_seed_analysis.png", width: 70%),
//   caption: [Seed analsis output visualization in the feedback pane],
// )
    
// One the annotation and point parameter visualization was completed, the steps of vessel extraction were ready to be implemented.


=== Thresholding segmentation

As noted in @imaging_and_seg, the simplest method of segmentation is thresholding. Given the nature of CECT intends to give the structures of interest high grey values, this is an intuitive method with a strong prior. It however does not work in practice for a few reasons: *(i)* the shell effect in CECT, where the contrast enhancing agent has higher concentrations on the outside or surface of the tumor, results in values that would be segmented as "vessel" even though they are not. *(ii)* grey value gradients appear between the outside and center of the samples and *(iii)* incomplete staining resulting in discontinuous vessels.

#figure(
  image("../../resources/software/threshold_131_255_example.png", width: 80%),
  caption: [Illustration of the shortcoming of threshold based segmentation, with the "shell" being included],
)

The shell effect can be tackled by fitting a shape to the outside of the sample, however following a user interview demonstrating the feature a critical issue was raised: in tumors, it is common for the outside to contain large and plentiful vascularization. Removal would both bias results as well as reduce the overall performance by preventing these outside vessels from being segmented.

// TODO: add wlodarsky
Secondly, a threshold does not hold up to the gradients in images that are present, which in prior work carried out on this data, resulted in rejection of samples with a gradient considered too large. Finally, standard thresholding does not do anything to combat the incomplete staining resulting in discontinuous vessels. As a result, manual thresholding as well as automated thresholding such as Otsu were rejected. 



// TODO: from here requires revision

=== Traditional algorithms

// Source the SimpleITK https://simpleitk.org/doxygen/v2_4/html/classitk_1_1simple_1_1ObjectnessMeasureImageFilter.html
To go beyond the limitations of threshold based segmentation, methods that make use of the blood vessel prior (algorithms designed with blood vessel or tubular structure extraction in mind) were tested: Frangi (or its generalization in SimpleITK) is a tubular prior algorithm widely available and high performance, being available as a C++ implementation. The algorithm is generally applied at multiple scales (different expected vessel sizes) with the outputs collected together into one segmentation. Frangi is known for having multiple hyperparameters that require fine tuning, in order to offer the user a simple solution, the parameters for the minimum and maximum vessel scale are pre-defined, and the vessel parameters hard coded.

In order to combine the information provided by thresholding with that of Frangi, a novel approach was utilized: the use of a *probability map*.

#figure(
  image("../../resources/software/Vesselness_probability_bottom.png", width: 80%),
  caption: [Visualization of the vesselness probability map, as defined by the Frangi feature. Higher valued pixels are assigned a higher vesselness probability.],
)

This approach was selected as it allows the accumulation of evidence across steps in the pipeline, and if multiple probability maps are saved (one for each step or method) they can be given weights when being combined to create the final segmentation. // This method was somewhat undermined by the memory usage limitations laid out in @performance_and_memory - and the final implementation was simplified to use a single probability map that is iteratively updated.

=== Machine learning

bla bla about the random forests

#linebreak()
bla

#linebreak()
bla


== Results

After the first round of development, a multi stage pipeline was obtained: from the user placed points, a shell removal step was done, and subsequently the user "vessel" points were grown using region growing to follow the ridges defined by the high grey value points. These points grown from the user annotations were then treated as a baseline for creating a simple classifier based on random forests: the vessel points, and points within a small region around them, were used. The probability maps generated from this step, alognside the tubular frangi, were then combined and thresholded based on the values of the user annotated points. This complex method led to promising results:

#figure(
  image("../../resources/software/long_pipeline_promising.png", width: 80%),
  caption: [Visualization of the segmentation following the multi stage pipeline during development],
)

The outputs from this stage presented interesting characteristics: continuous vessels and few noisy sections. Performance was measured using the user annotated points, with 26/27 vessels and 16/16 background points correctly classified.
// , it was decided to carry out a miniature ablation study: as it was noted by the author during the research phase, it is common for software approaches comprising multiple steps to not correctly quantify the contribution of each individual step to the overall algorithm, resulting in a rube goldberg-esque algorithm. //This is a known issue in computer science and especially in machine learning
