= Problem statement

// 3. After SOTA 2pp: problem statement, general goal, objectives
//     1. Based on the levels above, summarize points mentioned in SOTA
//         1. Important remaining research questions are etc etc etc, main goal is this, objectives are a b c

// From (Scientific writing-tips and tricks_Deadlines.pdf):
// - ✓ Formulate again relevant, simple, measurable, and feasible research questions that are still remaining (should be clear after reading the SOTA)
// - ✓ State the research aim or hypothesis of the project, and formulate concrete objectives

As discussed in the 7 problem points laid out previously, our principal challenge lays in delivering a work that satisfies three distinct actors:
1. Any users of the program, for whom computing is a tool that existing amongst others used during their work, and where tool ease of use and polyvalence is essential;
2. Scientists the program for research, to whom performance, speed of attaining results, repeatability and adjustability to their exact modalities and needs are essential
3. The scientific community, for whom replicability, re-usability and ease of use are essential in being able to extend any paper they may want to build upon;

#linebreak()
Requirements amongst these groups overlap, and from these user profiles, as well as the 7 problem points, we obtain the following problem statement:

#v(0.5cm)

// Problem statement:
#linebreak()
How may a software pipeline for the segmentation and extraction of blood vessel networks from CECT images be designed, such that it is accessible and usable by domain scientists such as biologists, for whom software is not a primary tool (*Problem 1*), where the software is robust to intensity gradients and variable contrast levels of CECT images, without requiring dataset-specific retraining or re-annotation (*Problem 2, 4.2, 4.3*), capable of producing outputs in easily portable binary masks with interpretable, adjustable parameters (*Problem 3.1*), that extracts and is evaluated using metrics that encode the priors of vascular networks as opposed to only voxel level metrics (*Problem 3.2*, *Problem 4.1*)?

// #linebreak()
// _*Problem 1.* Users for whom software is not the central aspect of their work, are inclined towards familiarity and simplicity. As a result, we will use a free and well documented base: 3DSlicer_

// #linebreak()
// _*Problem 2.* The the wide diversity of available methods for 3D imaging and their specificities present a challege in creating a method that is re-usable. Any method used for the segmentation of small blood vessels should be robust to the gradients caused by diffusion CECT, and able to handle variable contrast levels._

// #linebreak()
// _*Problem 3.1.* Methods for extracting blood vessels can do so at different levels of abstraction. It is important to be able to select the level of abstraction desired in the software, and for any method used to export to have adjustable parameters for this purpose._

// #linebreak()
// _*Problem 3.2.* The selected evaluation method should encode the structure of blood vessels as a prior in some form, in order to ensure that quantified prediction performance matches with qualified performance as experienced by the user._

// #linebreak()
// _*Problem 4.1.* Current methods for segmentation often ignore the structural priors that underly the data generation process. An effective, robust and transferrable method for blood vessel segmentation must thus encode the relevant structural priors, namely connectedness, shape, and branching structure._

// #linebreak()
// _*Problem 4.2.* Deep learning suffers for CECT imaging due to the domain shift between datasets. Any algorithm must contain user adjustable hyper parameters to enable fitting to the parameters of their data, as well as avoid the need for training data beyond a single test example._

// #linebreak()
// _*Problem 4.3.* Existing vascular segmentation pipelines are typically designed and validated for a single imaging modality, contrast strategy, or tissue type. A robust pipeline must expose interpretable parameters that allow adapation to the users specific imaging context, without requiring retraining as with common deep learning methods, or re-annotation._


== Problem resolution approach <prob_statement>

The proposed approach to solving the problem laid out above is as follows:
1. A user centric approach, where the end user is placed in the segmentation loop and offers feedback to the algorithm, through placement of anchors @minimal_path_tubular
2. A method that makes use of existing, extendable software 3DSlicer @3Dslicer_paper
3. A method that integrates voxel level metrics such as DICE @og_dice_loss and vasculature relevant metrics such as @clDice_loss_func and @CFLoss_loss_func
4. A method that is well documented, and enables reproducibility
5. A method that outputs a portable format of segmentation, namely voxel level segmentation, as individual slices or a DICOM imaging format 

#v(0.5cm)

#linebreak()
The approach will make use of the ability of 3DSlicer to visualize the outputs of a plugin immediately, and include the user by means of allowing adjustment of the segmentation through anchor points and hyperparameters for the segmentation reconnection process. The segmentation will begin with a simple window thresholding segmentation done by the user or automatically based on the anchor points selected. The algorithm will then attempt to reconnect and grow the segmentation based on its loss functions, region growing and other lower order techniques, with the integration of the priors of vascularization by means of the loss functions used. The user will then be able to export the segmentations into a portable format.

#figure(
  image("../../resources/images/msc_thesis_try1_09-03-26.png", width: 100%),
  caption: [Preliminary synthesized diagram for the annotation of vascularization and sharing of results],
)