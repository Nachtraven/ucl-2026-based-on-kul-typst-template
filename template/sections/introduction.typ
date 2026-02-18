= Introduction

The analysis of soft tissue is foundational to modern medecine, due to the link between tissue microstructure and its function, being used everywhere from clinical environments to laboratories. Tissue samples are collected and imaged in order to gain an understanding of their structure and composition, called histology or histopathology in the case of diseased tissue. We use the term histology to refer to either interchangeably. Classically, this sampling and subsequent analysis has been done _ex-vivo_ in 2D using a microscope, setting the gold standard for histology @2d_histo_sota_balcaen2023revealing. 

#linebreak()
Histology is relevant in both clinical and laboratory environments. Clinically, histopathological analysis of tissue samples is extensively used such as for cancer detection and grading @histology_used_for_cancers_he2012histology where a sample is analysed manually or with computer assistance. In laboratories for tasks such as clinical trials, histopathologists carry out manual microscopic evaluation @pathology_in_clinical_trials_provenzano2015standardization. Classical 2D histology presents the distinct disadvantage of being unable to obtain information at the same granularity in all three axis: slices may be stacked to obtain a 3D result, but resolution in the third axis is limited to section thickness, with the stacked planes separated by a dead space where no information is acquired @methods_for_3d_histo_pichat2018survey, and the cutting process induces changes in tissue structure @extending2d_histo_to_3d. 

#linebreak()
For the purpose of evaluating the antiangiogenic drug Pazopanib, a cancer treatment drug of the antiangiogenic drug group, which block the creation of new blood vessels essential to tumor development, accurate 3d reconstruction of blood vessel vascularization is required, beyond simple volume estimate [source?]. This motivates the need for using µCT. (refer to sources from pdf Contrast-enhanced micro-CT for 3D X-ray based histology to assess the influence of antiangiogenic drugs on tumor vascularization and necrosis)

#linebreak()
Here speak of 3d methods for histology and why they're relevant, especially µCT for panzopanib and blood vessel reconstruction. Talk about the time it takes to segment blood vessels, and the variability in between annotators (refer to pdf A literature review on segmentation methods for ex vivo contrast-enhanced microfocus computed tomography data).

#linebreak()
end with what we will work on, which is tools to aid in the laboratory/clinical trial process of analyzing vascularizaton of small tumors, with a particular focus on usability across multiple pieces of software: avizo, dragonfly3D and opensource DICOM viewers (ideas on which?)




Native methods of 3D imaging have been developped to paliate the issues of 2D histology: microscopy methods such as confocal microscopy, 3D ultrasound imaging, magnetic resonnance and x-ray imaging. High resolution variants of the latter two exist in the form of micro-Magnetic Resonance Imaging (micro-MRI) and microfocus X-ray Computed Tomography (microCT), able to .


In order to evaluate the efficacy of the drug Pazopanib, a cancer treatment drug of the antiangiogenic drug group, which block the creation of new blood vessels essential to tumor development

accurate analysis of blood vessel characteristics beyond simple volume measurements are required  


#linebreak()
Blood vessel understanding and reconstruction has emerged over the past years as a critical element in understanding and pushing the boundaries in new drug research: angiogenesis, or the creation of new blood vessels, is a key step in the growth and spread of cancerous tumors. Classical methods, relevant for qualitative understanding and estimation, fall short in terms of accuracy for quantitative analysis for clinical trials [0.4]. 2D reconstruction suffers due to its inherent variability resulting from the slicing process and lack of resolution, with the field is progressing towards the use of high resolution 3D data for these quantitative analysis tasks.

#linebreak()
We will begin by diving into the current state of the art in histology for drug sreening, followed by the MicroCT methods used, and finish with an exploration of the methods of image understanding more broadly, 

#linebreak()

you should come with CECT being a new tool for
3d biology but limitations = reconstruction of the
vasculature network in 3d -> here is where the SOTA
will continue on + thesis topic will work on


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