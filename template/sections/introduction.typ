= Introduction (2-6pp) (does this overlap with state-of-the-art and should I remove the intro?)

The analysis of soft tissue is foundational to modern medecine, it is used everywhere from clinical environments to laboratories, where samples are collected and imaged in order to obtain an understanding of the tissue, called histology or histopathology in the case of diseased tissue. We use the term histology to refer to either interchangeably. Classically, this sampling and subsequent analysis has been done in 2D, with the microscope being the catalyst for the development of the field, and being the gold standard for this process. However, this form of histology presents multiple limitations that stem from its 2D nature: the loss of 3D understanding and structure, as well as very limited quantification capabilities. [0.1] [More detail to be added]

#linebreak()
Histology is relevant in both clinical and laboratory environments. Clinically, the goal of a biopsy and subsequent analysis under the microscope is generally to identify a qualitative parameter in order to enable diagnosis and treatment: identifying the presence of a kind of cell, the phenotyping of a cell, or the estimation of a parameter, for example in cancerology the presence or absence of blood vessels in a tumor. [0.2]

#linebreak()
Such biopsies done in 2D present the distinct disadvantage of being unable to obtain information at the same granularity in all three axis: microscope slides in 2D may be stacked to construct a 3D understanding, but these stacked planes are separated by a dead space where no information is acquired [0.3]. This loss of accuracy is catastrophic for the reconstruction and quantification of structures that are small and where their structure is relevant to their function, such as blood vessels, on top of the deformation caused by the cutting process.

#linebreak()
Blood vessel understanding and reconstruction has emerged over the past years as a critical element in understanding and pushing the boundaries in new drug research: angiogenesis, or the creation of new blood vessels, is a key step in the growth and spread of cancerous tumors. Classical methods, relevant for qualitative understanding and estimation, fall short in terms of accuracy for quantitative analysis for clinical trials [0.4]. The 2D reconstruction: its variability and lack of resolution being a limiting factor, the field is progressing towards the use of high resolution 3D data for these quantitative analysis tasks.

#linebreak()
We will begin by diving into the current state of the art in histology for drug sreening, followed by the MicroCT methods used, and finish with an exploration of the methods of image understanding more broadly, 

#linebreak()

*Should this be extended with the aetiology of cancer and angiogenesis?*


- 0.1 Appears interesting: Limitations of clinical and biological histology https://doi.org/10.1054/mehy.1999.0894"
#linebreak()
- 0.2 They speak of "presence of vascular or stromal invasion": Histology: The gold standard for diagnosis? https://pubmed.ncbi.nlm.nih.gov/37008634/
#linebreak()
- 0.3 a. 3D reconstruction from 2D slices "Extending two-dimensional histology into the third dimension through conventional micro computed tomography" https://doi.org/10.1016/j.neuroimage.2016.06.005
#linebreak()
- 0.3 b. Other source for 3D reconstruction from 2D slices "A Survey of Methods for 3D Histology Reconstruction" https://doi.org/10.1016/j.media.2018.02.004
#linebreak()
- 0.4 Sources on angiogenesis in tumors from Wlodarski





// #hide[

// * avoid giving information outside of expertise and is redundant *
// ~
// * start SOTA with biopsies -> clinical biopsies vs drug development biopsies *
// "classical way" is classical 2D histo, explain reason why 3D is much better
// 3D is better because vasculature
// tumors result in biopsies result in needing to analyze vasculature results in histo result in 2d or 3d result in better or worse vascularization reconstruction results in ml, thresholding, classical methods. For segmentation, review article of Isabelle! You can learn from clinical cases for DL
// ~
// the motivation for segmentation is different in clinical vs in industrial. Different evaluation criteria, different reasons
// ~

// == Goal: SMART (Specific, Measurable, Achievable, Relevant, Time-bound)

// Develop a re-usable, robust vascular reconstruction pipeline for MicroCT that:
// + Handles vessels across 10-10 000µm scales - to be fixed
// + - Express in size relative to the image: diameter of 5 and 15/20 voxels
// + Represents vascularization in a method that allows extraction of clinically relevant metrics - papers on vasc
// + - Tortuosity
// + - Branching angles
// + - Branching ratio 
// + - amount of branches
// + - connectivity -> interconnected vs not (ie has endpoints, more endpoints in organs, more interconnected in tumors (?) and necrosis in center of tumor due to lack of vasc)
// + - flow
// + - thickness distribution "thickness map" - fitting sphere midpoints -> we want to see a distribution
// + Integrates with existing tools: Dragonfly, Avizo, Orthanc

// #v(12pt)

// + amount of branches per side, size of the branches/length of the branches, count nodes 

// #v(12pt)

// Evaluate for tumor, from the tree, to ensure transferrability to other domains
// If I improve segmentation -> impact on final outcome -> sensitivity analysis
// Translation of segmentation into the tree -> sensitivity analysis
// Focus on process of evaluating the segmentation

// #v(12pt)

// TODO additions:
// - having re-usability enables future federated machine learning
// - better research and citate on the interpretable machine learning -> goal of transferrability and re-use
// - better explanation of semantic and semantic segmentation, and its up/downsides
// - Graph-based reconstruction
// - Explore why existing methods fail
// - active phrasing for titles & subtitles
// - Link sections explicitly (e.g., "Having established the need for vascular reconstruction, we now compare imaging modalities...").
// - Focus on extracting problems in the intro

// #v(24pt)

// == Vascularization

// * --> atlas of anatomy third edition and anatomy course page on moodle *

// - Define tumor vascularization (blood vessel networks in tumors induced by the tumor to continue growing -> see wlodarski).
// - Role of vascularization: nutrient/oxygen supply to tumor, metastasis/spreading but can also allow treatment delivery
// - Why reconstruction of vascularization matters -> allows us to estimate state of tumor, better evaluate treatments that act on vasc.

// #v(12pt)

// - The whole human body is vascularized, every organ
// - - Mention key figures 
// - It plays a key role in many diseases
// - - Diseases of the vascular system: leading cause of death (heart failure)
// - - Other diseases: uses the system to move around & human body uses it to move white blood cells around
// - - Other diseases: uses the system to feed itself (cancer/tumors) & human body too

// #v(12pt)

// - It is multiscale - explore vasculature papers
// - It is a common structure amongst living organisms - as with abstract: clarify if it evolved independently multiple times, and that its commonality is structure and not the "liquid"
// - It is it is critical to multicellularity

// #v(12pt)

// - It can be analysed qualitatively -> cite some forms of vasculature studies that indirectly measure or evaluate it
// - - using vascular studies
// - - using tools (Stethoscopes)
// - It can be analysed quantitatively -> cite some forms of vasc. studies that directly measure it and cite papers that use it for anti-angio drugs
// - - using post mortem dissection
// - - using imaging techniques

// #v(24pt)

// == MicroCT

// * scheme of going from simple to complex, funnel towards ex vivo imaging, biomedical imaging *
// * make clearer the steps going towards *
// * focus on invivo and ex vivo and imaging, organ to cell scale *
// ~
// * Focus on structural imaging and CT/MRI*
// ~
// * SOTA really focus on histology -> be careful to avoid in vivo, histology in 3D *
// ~
// * SOTA: reason for research, explain why you're doing things *
// ~
// "In case of cancer diagnosis, a biopsy is taken, in industry biopsy of animals to assess drugs, crucial to understand diseases and find treatment. Classical method is histology (assessement of biological tissues at a micro scale) classical 2d histo is the usual way of doing it, but there are limitations in this for vasculature due to its 3d structure, discuss new methods for 3d histo (and one is CECT) and you're limited in µCT analysis of data is difficult"
// * main problem statement * : cect problem in segmentation of vasculature
// We need to do more advanced segmentation, we can refer to in-vivo, and we can learn and get inspiration from it 

// What is MicroCT <> CT (resolution, ex-vivo nature, sample preparation).
// - Why are CEST agents used
// - Explain contrast mechanisms for soft tissue and vessels (contrast agent vs native contrast like RBCs).
// - Explain issue with ynamic nature of the images: big vessels vs small vessels

// Conclude with why we're using MicroCT for this situation and more generally why MicroCT can be attractive for vascularization (3D, high resolution) and why it is challenging (noise, artifacts, variation with vessel size).

// #v(24pt)

// === Imaging interpretation

// * state of the art of quantitative *
// ~
// Clinics are already happy about 3d visualization, radiologist is happy seeing things in 3D. reduce bias of radiology interpretation. Their goal is not to be super accurate, but it is to evaluate qualitatively "is the tumor in the liver vascularized"
// ~
// In histo, eg for pharma companies and drug treatment, you need solid numbers, you need quantitative measures.
// * ex vivo "clients" are different! they want quantitative, its a different population *
// ~
// The fundamental progress that has occured over the past century in imaging has been one of hand-in-hand progression of imaging techniques with interpretation techniques, from 2D images to 3D reconstructions such as those seen in MRI. (from here not sure?) We will argue that, in order to be able to make sense of MicroCT imaging, the same way MRI required tomographic reconstruction (not really, here the idea is to focus on the different techniques to increase contrast or highlight differences?), a step almost no human could do themselves, it is required to develop new techniques, that go further than imaging or simply classifying points in space as one or the other category, as seen in segmentation. It is argued that reconstruction: the process of extracting a higher order of information from our imaging data, is necessary to be able to make sense of systems as complex as those of vascularization.

// #v(24pt)

// === Analysis for Vascularization characterization

// - Pros and cons for each wrt to vascular analysis (resolution, invasiveness/ex or in vivo, 3D vs 2D, contrast/colour) 

// #v(24pt)

// == Exploring the reconstruction problem

// Most current imaging techniques produce non semantic data
// - Example of imaging that does extract (near) semantic data: xray of bones
// - Widen to most other imaging and other xray based techniques: most don't differentiate so well

// Return to CECT:
// - It outputs data that needs processing, explain why, discuss voxel sizes, discuss the use of staining agents

// Present semantic extraction / segmentation / reconstruction of structures.
// - Situations and examples where it is good
// - Contrast with specific issues in your setting:
// -- Dynamic nature of the target based on size
// -- 3D problematic

// #v(24pt)

// We lack the priors of the radiologist
// We're extracting a model that exists in peoples heads, qualitatively evaluates, and we're bringing 
// ~
// -> even if we make a 3D render, the radiologist doesn't care about small things missing, they care about the anatomy
// -> difference in goals vs qualitative evaluation: the model is scrutable/interpretable/real, from which you can get quantitative figures
// -> segmentation needs to be neat, accurate, robust to small changes and noise
// ~
// * final presentation: make good visualization showing the differece with some ablation. Explain difference between typical evaluation with dice, and the real structural evaluation. Show that DICE being really high or low doesn't necessarily reflect the actual final output. Benefit from the area under the curve difference wrt classical methods *
// ~
// * use the tumor case as one case study to explain what I'm doing: briefly SOTA 3D histology for drug screening, the need for 3D histo is clear for companies developping drugs, I focus on antiangionetic drugs on tumor -> refer to Lisa thesis (effect of pazopanib) *

// ]