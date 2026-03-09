= Problem statement

// 3. After SOTA 2pp: problem statement, general goal, objectives
//     1. Based on the levels above, summarize points mentioned in SOTA
//         1. Important remaining research questions are etc etc etc, main goal is this, objectives are a b c

// From (Scientific writing-tips and tricks_Deadlines.pdf):
// - ✓ Formulate again relevant, simple, measurable, and feasible research questions that are still remaining (should be clear after reading the SOTA)
// - ✓ State the research aim or hypothesis of the project, and formulate concrete objectives

As discussed in the 7 problem points laid out previously, 

_*Problem 1.* Users for whom software is not the central aspect of their work, are inclined towards familiarity and simplicity. As a result, we will use a free and well documented base: 3DSlicer_

#linebreak()
_*Problem 2.* The the wide diversity of available methods for 3D imaging and their specificities present a challege in creating a method that is re-usable. Any method used for the segmentation of small blood vessels should be robust to the gradients caused by diffusion CECT, and able to handle variable contrast levels._

#linebreak()
_*Problem 3.1.* Methods for extracting blood vessels can do so at different levels of abstraction. It is important to be able to select the level of abstraction desired in the software, and for any method used to export to have adjustable parameters for this purpose._

#linebreak()
_*Problem 3.2.* The selected evaluation method should encode the structure of blood vessels as a prior in some form, in order to ensure that quantified prediction performance matches with qualified performance as experienced by the user._

#linebreak()
_*Problem 4.1.* Current methods for segmentation often ignore the structural priors that underly the data generation process. An effective, robust and transferrable method for blood vessel segmentation must thus encode the relevant structural priors, namely connectedness, shape, and branching structure._

#linebreak()
_*Problem 4.2.* Deep learning suffers for CECT imaging due to the domain shift between datasets. Any algorithm must contain user adjustable hyper parameters to enable fitting to the parameters of their data, as well as avoid the need for training data beyond a single test example._

#linebreak()
_*Problem 4.3.* Existing vascular segmentation pipelines are typically designed and validated for a single imaging modality, contrast strategy, or tissue type. A robust pipeline must expose interpretable parameters that allow adapation to the users specific imaging context, without requiring retraining as with common deep learning methods, or re-annotation._


== Problem resolution approach

In order to fulfill the points laid out in our problem statements above, we will focus on three axes for blood vessel segmentation:
1. Ease of use
2. Pipeline replicability
3. 