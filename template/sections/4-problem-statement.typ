= Problem statement

// 3. After SOTA 2pp: problem statement, general goal, objectives
//     1. Based on the levels above, summarize points mentioned in SOTA
//         1. Important remaining research questions are etc etc etc, main goal is this, objectives are a b c

// From (Scientific writing-tips and tricks_Deadlines.pdf):
// - ✓ Formulate again relevant, simple, measurable, and feasible research questions that are still remaining (should be clear after reading the SOTA)
// - ✓ State the research aim or hypothesis of the project, and formulate concrete objectives

// As discussed in the 7 problem points, the challenge lays in delivering a work that satisfies three distinct actors:
// 1. Non computer science users wishing to extract vasculature from Micro-CT scans, for whom computing is one tool amongst many used during their work;
// 2. Scientists the program for research, to whom performance, speed of attaining results, repeatability and adjustability to their exact modalities and needs are essential
// 3. The scientific community, for whom replicability, re-usability and ease of use are essential in being able to extend any paper they may want to build upon;

The task at hand requires analyzing existing collected CECT data that presents challenges in the form of gradients, disconnected vessels and low contrast, by means of a user friendly piece of software. This software must be re-usable and fit into the wider ecosystem of open source tools for working on 3D data being implemented as an extension of 3D Slicer


The task at hand covers a multistep pipeline with three key stakeholders: 
- future end users of the tool on different data
- the wider scientific community for whom replicability and extensibility matter, and 
- computer science researchers, for whom algorithm development and performance is the goal.

#linebreak()
From this, the following problem statement is obtained:

// Problem statement:
#linebreak()
*TODO revisit*: How may a software pipeline for the segmentation and extraction of blood vessel networks from CECT images be designed, such that it is accessible and usable by domain scientists such as biologists, for whom software is not a primary tool (*Problem 1*), where the software is robust to the challenges of CECT: intensity gradients and variable contrast levels, without requiring dataset-specific hyper parameter tuning (*Problem 2, 4.2, 4.3*), capable of producing outputs in portable binary masks for use downstream (*Problem 3.1*), that is evaluated in a robust replicable fashion (*Problem 3.2*, *Problem 4.1*)?

== Problem resolution approach <prob_statement>

// 3. A method that integrates voxel level metrics such as DICE @og_dice_loss and vasculature relevant metrics such as @clDice_loss_func and @CFLoss_loss_func

The following is proposed to approach the problem:
1. Use 3DSlicer @3Dslicer_paper, an open source, extendable software as a basis for a plugin
2. Placing the user in the segmentation loop and enforcing data driven hyperparameter selection through the placement of anchors @minimal_path_tubular
3. The use of generalist, robust algorithms
4. Output in a portable binary segmentation format as individual slices or DICOM 
5. The inclusion of user feedback during the development of the plugin

// #v(0.5cm)

// #linebreak()
// A 3DSlicer plugin is developped to offer user friendliness for data loading, saving and manipulation of the extraction pipeline.he segmentation will begin with a simple window thresholding segmentation done by the user or automatically based on the anchor points selected. The algorithm will then attempt to reconnect and grow the segmentation based on its loss functions, region growing and other lower order techniques, with the integration of the priors of vascularization by means of the loss functions used. The user will then be able to export the segmentations into a portable format.

#figure(
  image("../../resources/images/msc_thesis_try1_09-03-26.png", width: 100%),
  caption: [Preliminary synthesized diagram for the annotation of vascularization and sharing of results],
) <use_flow>