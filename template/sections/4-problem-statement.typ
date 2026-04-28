// Problem statement: 2 pages, contains general goal, objectives
// summarize points mentioned in SOTA
// Highligts important remaining research questions, main goal and sub objectives

// - ✓ Formulate again relevant, simple, measurable, and feasible research questions that are still remaining (should be clear after reading the SOTA)
// - ✓ State the research aim or hypothesis of the project, and formulate concrete objectives

// Recap 2/3 sentences, restate the situation that the SOTA established.
// Gap/aim: Name the unfilled niche, and state your aim as a positive proposition.
// Objectives: Concrete, scoped sub-goals that together meet the aim.

= Problem statement

Three princopal constraints define the territory of this thesis: *(i)* The data: Contrast-enhanced micro-CT scans of tumor tissue acquired with diffusion-based staining agents, which produce intensity gradients across the sample and leave disconnections. The vessels of interest span 6 to 100 μm, occupying only a few voxels at the resolutions used. *(ii)* The algorithms: Two paradigms of vascular segmentation are identified with complementary weaknesses: data-driven methods achieve strong in-distribution performance but require annotated training data that is difficult to generate and high-variance for CECT, while classical methods encode vessel priors explicitly, need no training, but reason only on a local scale resulting in fragmented segmentations at bifurcations, vessel endpoints, and in low-contrast regions. *(iii)* The tooling: Existing vascular extraction software is intended for large vessels with few disconnections: arteries, airways and organs. Microvasculature extraction methods are sparse, locked behind closed-source and lack proper development or integration into freely available tools.


// Suggestion to continue from Claude/Piccolo:

// == Aim

// [One paragraph stating the aim of this thesis as a positive proposition. Something like: "This thesis aims to deliver a practical software pipeline for the segmentation of microvasculature from CECT micro-CT data, designed to be usable by domain scientists without programming expertise, robust to the contrast variability characteristic of diffusion-CECT, and integrated into the open-source 3D Slicer ecosystem."]

// [A short paragraph on stakeholder tensions: end users (usability, robustness), the open-source scientific community (extensibility, reproducibility), and CS researchers (algorithmic novelty, performance). Acknowledging that these goals are partially in tension is a strength, not a weakness.]


// == Research question

// [ONE focused research question. Suggested form:]

// How can the algorithmic strengths of classical vesselness filtering be combined with user-driven parameter selection to produce a 3D Slicer plugin that segments microvasculature from CECT data without requiring training data or dataset-specific tuning?

// == Objectives

// To meet this aim, the work pursues four objectives:

// O1. *Software integration.* Deliver the pipeline as an installable 3D Slicer extension with click-only installation, addressing the integration constraints identified in the SOTA [Problems 1, 5].

// O2. *Algorithmic robustness.* Build the segmentation core on classical methods that encode vessel-specific geometric priors, avoiding the data requirements of supervised deep learning and the brittleness of intensity-only thresholding [Problems 2, 3].

// O3. *User-guided parameter selection.* Use sparse user input (landmark or anchor placement) to drive parameter selection on a per-dataset basis, accepting the tradeoff of expert interaction in exchange for cross-dataset generalization [Problems 2, 3].

// O4. *Reproducibility.* Output segmentations in portable, non-proprietary formats and release the plugin under an open license [Problem 1].

// [If you keep Problem 3.1 / evaluation: add an O5 on evaluation methodology. If you drop Problem 4 / 3.1, no fifth objective.]

// == Scope and limitations

// [One paragraph naming what is *out* of scope: full quantitative analysis of vascular topology (left to downstream tools like SKAN), comparison with deep-learning baselines (data not available), evaluation on additional tissue types, etc. Acknowledging scope limits up front is more credible than discovering them at the end.]























// // This is the (bad) draft
// The task at hand requires analyzing existing collected CECT data that presents challenges in the form of gradients, disconnected vessels and low contrast, by means of a user friendly piece of software. This software must be re-usable and fit into the wider ecosystem of open source tools for working on 3D data being implemented as an extension of 3D Slicer


// The task at hand covers a multistep pipeline with three key stakeholders: 
// - future end users of the tool on different data
// - the wider scientific community for whom replicability and extensibility matter, and 
// - computer science researchers, for whom algorithm development and performance is the goal.

// #linebreak()
// From this, the following problem statement is obtained:

// #linebreak()
// *TODO revisit*: How may a software pipeline for the segmentation and extraction of blood vessel networks from CECT images be designed, such that it is accessible and usable by domain scientists such as biologists, for whom software is not a primary tool (*Problem 1*), where the software is robust to the challenges of CECT: intensity gradients and variable contrast levels, without requiring dataset-specific hyper parameter tuning (*Problem 2, 4.2, 4.3*), capable of producing outputs in portable binary masks for use downstream (*Problem 3.1*), that is evaluated in a robust replicable fashion (*Problem 3.2*, *Problem 4.1*)?

// == Problem resolution approach <prob_statement>

// The following is proposed to approach the problem:
// 1. Use 3DSlicer @3Dslicer_paper, an open source, extendable software as a basis for a plugin
// 2. Placing the user in the segmentation loop and enforcing data driven hyperparameter selection through the placement of anchors @minimal_path_tubular
// 3. The use of generalist, robust algorithms
// 4. Output in a portable binary segmentation format as individual slices or DICOM 
// 5. The inclusion of user feedback during the development of the plugin

// // #linebreak()
// // Deprecated: A 3DSlicer plugin is developped to offer user friendliness for data loading, saving and manipulation of the extraction pipeline.he segmentation will begin with a simple window thresholding segmentation done by the user or automatically based on the anchor points selected. The algorithm will then attempt to reconnect and grow the segmentation based on its loss functions, region growing and other lower order techniques, with the integration of the priors of vascularization by means of the loss functions used. The user will then be able to export the segmentations into a portable format.

// #figure(
//   image("../../resources/images/msc_thesis_try1_09-03-26.png", width: 100%),
//   caption: [Preliminary synthesized diagram for the annotation of vascularization and sharing of results],
// ) <use_flow>

// // Is a diagram relevant? Does not seem to add much to the article.