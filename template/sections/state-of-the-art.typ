= State of the art

Viewers: 3D Slicer, OHIF, Dragonfly3D, Avizo


State of the art from "Scientific writing-tips and tricks_Deadlines.pdf":
#linebreak()
In the state of the art, you indicate what has been studied, why it has been studied, and, in general terms, how it has been studied. 
#linebreak()
This section contains:
- ✓ The background of the study (= context);
- ✓ Research that has been done in the frame of your thesis topic;
- ✓ Information that is needed for the reader to understand your topic and the remaining scientific issues/problems.
#linebreak()
➔ Make a fluent story of it, and not just a sum up of different papers or references.
#linebreak()
➔ The context (per paragraph or section) usually ends with a conclusion or problem statement that sets the scene for your specific research questions and project aim + objectives.

// briefly SOTA 3D histology for drug screening, the need for 3D histo is clear for companies developping drugs, I focus on antiangionetic drugs on tumor -> refer to Lisa thesis (effect of pazopanib)

#pagebreak()

With the goal of reconstructing tumor vascularization for the analysis of the antiangionetic drug Pazopanib in the context of cancer treatment, we begin by exploring the use of histology for drug sreening, followed by imaging methods, more specifically contrast-enhanced Micro CT, and finish with an exploration of the methods of structure extraction from images.


== Histology for drug screening 

In order to bring new drugs to market, a set of steps must be followed that are established by organisations such as the European Medical Association in the European Union, or the Food and Drug Administration in the U.S [1.1]. One of the key steps is collecting data on the effectiveness of the drug, done through clinical trials. These trials, before taking place in humans, are done on animals in a controlled lab environment, where collected data is analyzed for the outcomes and side effects of the drug. In the analysis process for Pazopanib, tumors are sampled and analysed ex-vivo, the histology of these tumors is critical in identifying the impact of treatment when compared to a control. 

The conclusions taken from each step in the clinical trial decide if the trial moves on, meaning that a more accurate prediction with tighter confidence intervals enables a better discriminative power and reduces the amount of effective drugs discarded due to uncertainty from process limitations. 


=== Histology in industry

Histology is in use in industry for clinical trials amongst other tasks, and the field is growing [2.1]. Histology is used due to its large amounts of qualitative data and high discriminative power, and is interpreted by experts during the process of drug research. It is used in clinical trials of structure altering drugs, or where the effect of interest is expected to be visible, and is generally done by specialized histopathologists [2.1]. Clinical trials vary widely in their design, as well as have a large variety of possible targets, in oncology specifically, 2D histology remains the most widely used technique [2.3], [2.27, 2.60] for the histology of human biopsies. For the analysis of Pazopanib, 2D histology is the reference method used to evaluate tumors. 


==== 2D histology

The field of histology is born from 2D histology of tissue under microscope magnification. 2D microscope slice histology, known as "classical histology", takes the form of tissue sample collection, often embedding of the tissue, followed by staining with various agents, applied to increase contrast or highlight certain structures, and ending in investigation using optical or electron microscopy [3.1]. This technique is used due to its delivery of a large amount of relevant quanlitative data imediately interpretable by experts, and high discriminative power, although it is time consuming and is costly as a result [3.2]. As a technique it has evolved in multiple directions, from the utilization of advanced staining agents [3.2] allowing the staining of a broad range of classes (DNA, proteins, lipids, or carbohydrates), to different lighting wavelenghts, ranging from ultraviolet [3.3] to infrared [3.4]. 

#linebreak()
2D histology is limited by its requirement to slice the target tissue before analysis, resulting in destructive modification of the sample. This slicing has the potential of deforming the tissue, with various techniques developped to conteract this [3.5] such as embedding in a wide variety of mediums. Slicing is also not orientation agnostic, and a large number of slices might be required for a sufficient spatial analysis of the sample, especially in situations where the observation target does not follow a particular axis, as with vascularization.

#linebreak()
The limitations of pure 2D histology are now resulting in quantitative histology moving in the direction of 3D analysis, especially when 3D structure of the tissue is relevant. 

#linebreak()
Unmentioned above: 
- samples dry out in classical histo, 
- the resolution is limited when stacking
- there are methods for extracting some 3D info from the 2D slices ex:"confocal microscopy light sheet microscopy or optical coherence tomography" https://doi.org/10.1038/s41467-022-34048-4


==== 3D histology

3D histology is an evolution of 2D histology, increasing the amount of information available for analysis, and as a result improving discriminative power when compared to 2D classical histology. In its most basic form as an evolution of classical 2D histology, it involves taking multiple 2D slices and aligning then stacking them to create a virtual third axis [4.1]. 3D histology is relevant for tumor analysis [4.2], allowing for structural understanding of a tissue, such as in [4.2] enabling "the spread and infiltration of invasive carcinoma to be understood". This form of histology is often still done in the same methods as with 2D, where a human carries out interpretation, requiring common standards and communication, such as in [4.3]

#linebreak()
Other well known methods for 3D histology that do not require slicing and thus avoid sample damage and destruction are magnetic resonance imaging (MRI) and computed tomography (CT), each having a higher resolution variant, micro-MRI and microCT respectively. These techniques enable virtual slicing, allowing observation across any plane, and have resolutions of tens microns for micro-MRI down to sub-micrometer scale for MicroCT.
MRI is interesting for tissue observation due to its high contrast on soft tissue, as opposed to CT that performs best on calcified tissue. Both methods however are able to make use of contrast-enhancing staining agents (CESAs) [4.4,4.5] resulting in the ability for microCT to be readily used for imaging soft tissue, and is termed contrast-enhanced microCT (CECT) and reviewed for ex-vivo data acquisition in [4.6]. CECT is of particular interest for ex-vivo 3D histology due to the wide variety of staining agents available, and has proven its use in canine heart analysis [4.7] and for vasculature exploration of small animals [4.8].

_Not certain about if or how to place the quote, as it is specifically for cancer._


===== CECT Imaging

Full section on the state of the art of CECT - TODO


== Structure reconstruction (or: Vascularization reconstruction, Interpretation methods of 3D imaging?)

This section is leaning towards segmentation, as in survey [5.1]

#linebreak()

With the goal of reconstructing vascularization in imaged tissue, we aim to take in data from an imaging modality, process it through a software pipeline, and obtain at output a data structure with higher information density than the input. This process of reducing the amount of raw data, but increasing the utility or information content of the data, is explored widely in the field of computer science. It underlies concepts such model fitting to noisy data [5.2] or as more commonly carried out in a biological context and industry, image segmentation, where the goal is to separate regions of a 2D image into multiple segments and objects [5.3].


=== Segmentation

Image segmentation plays a central role in medical image analysis by enabling quantitative analysis of different kinds: by classifying pixels with semantic labels (semantic segmentation), partitioning of objects (instance segmentation) or a combination of both across the entire image space (panoptic segmentation) [5.1]. The task can be as simple and as old as separating objects from a background, a problem that has been explored in computer science for multiple decades [5.4], or more complex as in panoptic segmentation, only being posed in 2018 [5.5].


==== Methods of Segmentation

Segmentation methods have evolved over time: from classical computer vision to machine learning and later deep learning methods 

TODO: Extend history to highlight the progression in complexity and the higher and higher levels of information extraction achieved

#figure(
  image("../../resources/images/timeline_from_PanopticSegmentationAReview.png", width: 100%),
  caption: [
    From (6.1) Timeline evolution of image segmentation (better version to be found or created)
  ],
)


==== Imaging and Segmentation of vasculature


Vasculature reconstruction and segmentation of 3D images often requires human segmentation [6.2]. Alternative automated methods are less precice 



Sources to be investigated and read:

+ 2013 Application of Micro-Computed Tomography With Iodine Staining to Cardiac Imaging, Segmentation, and Computational Model Development
+ 2010 Micro computed tomography for vascular exploration 
+ 2025 Micro-computed tomography to visualize preserved vascular architecture in decellularized human vaginal tissue: explorative study
+ 2004 Micro-computed tomography of the vasculature in parenchymal organs and lung alveoli

Non tomo:
+ 2021 Robust segmentation of vascular network using deeply cascaded AReN-UNet
+ 2023 Vessel Delineation Using U-Net: A Sparse Labeled Deep Learning Approach for Semantic Segmentation of Histological Images
+ 2015 Quantification of Microvascular Tortuosity during Tumor Evolution Using Acoustic Angiography

Vasc references:
+ 1976 The Vascularization of Tumors 
+ 2013 Springer Nature, "Vascularization"
+ 1982 Vascularization of Tumors: A Review


// == Interpretation methods of 3D imaging
// === Methods of 3D imaging
// === MicroCT imaging
// == Structural Extraction
// === Semantic segmentation
// === Structural reconstruction

#pagebreak()

Sources, will be re-done once finalized:

1.1 https://www.ema.europa.eu/en/human-regulatory-overview/research-development


2.1 https://doi.org/10.1111/his.14099
#linebreak()
2.2 Not great, behind paywall "Challenges Faced by Cross-sectional Imaging and Histological Endpoints in Clinical Trials" https://doi.org/10.1093/ecco-jcc/jjw161
#linebreak()
2.3 not the best source "The dream and reality of histology agnostic cancer clinical trials" https://doi.org/10.1016/j.molonc.2014.06.002
#linebreak()
2.27 Wlodarski 27: https://pubmed.ncbi.nlm.nih.gov/32445458/
#linebreak()
2.60 Wlodarski 60: https://pubmed.ncbi.nlm.nih.gov/37008634/


3.0 Section partially inspired from https://doi.org/10.1155/2019/8617406
#linebreak()
3.1 Source from [0], Mescher, L. A. Junqueira's basic histology. Text and atlas 14th ed. (McGraw-Hill, 2016).
#linebreak()
3.2 https://www.ncbi.nlm.nih.gov/books/NBK557663/
#linebreak()
3.3 https://pmc.ncbi.nlm.nih.gov/articles/PMC6223324/
#linebreak()
3.4 https://pmc.ncbi.nlm.nih.gov/articles/PMC10408309/
#linebreak()
3.5 Source from [3.0]: https://doi.org/10.1155/2019/8617406


4.1 https://doi.org/10.1016/j.ajpath.2012.01.033
#linebreak()
4.2 https://doi.org/10.1136/jcp.2004.024794
#linebreak()
4.3 Veterenary based? Not strongest article: Tseng LJ, Matsuyama A, MacDonald-Dickinson V. Histology: The gold standard for diagnosis? Can Vet J. 2023 Apr;64(4):389-391. PMID: 37008634; PMCID: PMC10031787
#linebreak()
4.4 Single Ho 3+-doped upconversion nanoparticles for high-performance T2-weighted brain tumor diagnosis and MR/UCL/CT multimodal imaging: https://doi.org/10.1002/adfm.201401609
#linebreak()
4.5 Three-dimensional non-destructive soft-tissue visualization with X-ray staining micro-tomography: https://doi.org/10.1038/srep14088
#linebreak()
4.6 Review Greet: Contrast-Enhanced MicroCT for Virtual 3D Anatomical Pathology of Biological Tissues: A Literature Review https://doi.org/10.1155/2019/8617406
#linebreak()
4.7 Application of Micro-Computed Tomography With Iodine Staining to Cardiac Imaging, Segmentation, and Computational Model Development https://doi.org/10.1109/tmi.2012.2209183
#linebreak()
4.8  Micro computed tomography for vascular exploration  https://doi.org/10.1186/2040-2384-2-7


5.1 IEEE Image Segmentation Using Deep Learning: A Survey https://doi.org/10.1109/TPAMI.2021.3059968
#linebreak()
5.2 RANSAC https://doi.org/10.1145/358669.358692
#linebreak()
5.3 FIRST EDITION! Computer Vision: Algorithms and Applications. Berlin, Germany
#linebreak()
5.4 OTSU https://doi.org/10.1109/TSMC.1979.4310076
#linebreak()
5.5 Panoptic https://doi.org/10.48550/arXiv.1801.00868
#linebreak()
5.6 U-Net https://doi.org/10.48550/arXiv.1505.04597


6.1 Panoptic Segmentation: A Review https://doi.org/10.48550/arXiv.2111.10250
6.2 µCT visualize preserved vascular architecture in decellularized human vaginal tissue: explorative study https://doi.org/10.1038/s41598-025-14452-8
#linebreak()


#pagebreak()

== Problem statement, aim and objectives 
From (Scientific writing-tips and tricks_Deadlines.pdf):
- ✓ Formulate again relevant, simple, measurable, and feasible research questions that are still remaining (should be clear after reading the SOTA)
- ✓ State the research aim or hypothesis of the project, and formulate concrete objectives

=== Connected papers

#figure(
  image("../../resources/images/Cryogenic contrast-enhanced microCT enables nondestructive 3D quantitative histopathology of soft biological tissues.png", width: 90%),
  caption: [
    Connected papers of Cryogenic contrast-enhanced microCT enables nondestructive 3D quantitative histopathology of soft biological tissues
  ],
)


// #hide[

// == Imaging

// #image("/assets/image.png", width:250pt)

// Visualize imaging across  axes: frequency, resolution and dimensionality. TBD how to make this visually interesting and easy to read.
// Also across imaging mediums?

// #v(12pt)

// Goal here - separate the imaging modalities by what they interact with:
// - Low frequency mechanical imaging (10^5 - 10^8 Hz): pressure waves, accoustic properties of organs to be imaged
// - Molecular and electronic scale interactions (10^6 - 10^15 Hz): electromagnetic waves probing bulk dielectric properties, molecular bonds, or electronic states of the tissues and organs imaged (also: surface profile)
// - High-frequency electromagnetic (10^16 - 10^21 Hz): X-rays interact with atomic electrons and gamma rays can interact with nuclei, probing material elemental composition

// #v(12pt)

// Potentially: how 3D images are made from 2D images
// *TODO*: Clarify terminology reconstruction vs segmentation vs skeletonization/nodes

// #v(24pt)

// === Medical imaging

// State how imaging is used in medicine
// - classical 2D histo and how it started the field of imaging
// - shortly mention 1D methods
// - discuss 3D methods
// - in depth on CT

// Of these, each type has notable advantages and disadvantages. If we focus on MicroCT, the imaging medium used in this document, we note the main disadvantage of the high radiation dose during imaging, requiring this method to be done ex-vivo. MicroCT also suffers from very variable contrast, and the term covers a wide breadth of different techniques and machine settings, due to the wide range of X-rays possible, methods for generating them and methods for reconstructing images.

// #v(24pt)

// === Imaging uses

// Of all the imaging techniques used in medicine, it is rare for the imaging technique alone to be sufficient in diagnosing a problem. Imaging methods can result in images ranging from Echocardiograms, requiring specialized training to interpret, to classical X-rays, such as those that initiated the world of (in body or through body imaging? name for this?) by Röntghen with the famous radiogram of (his?) hand.

// The images from imaging techniques require interpretation in part because they contain limited semantic information: the difference between different structures in the image, and the link to real body parts, is generally heavily context dependent, relying on interpretation skills built up over years of education by experts such as those in radiology.

// #v(24pt)


// ==== Focus on MicroCT and CECT

// Explore existing methods more than in the intro
// Touch on methods for segmentation, vasculature extraction, the CE process


// === Pre-processing/filtering/area of interest

// === classical techniques (thresholding)
// limitations

// === Machine learning techniques

// === Tools used in the real world (Avizo, Dragonfly)



// #v(24pt)

// == Existing approaches to semantic extraction

// === traditional image processing (thresholding, filtering, morphological ops).

// - Show it working for CECT
// - Show it failing for some examples, motivate need for going deeper

// === model-based and graph-based reconstruction

// - Discuss what it is
// - Discuss its downsides (tuning, expert knowledge, fragile to context changes)

// === machine learning / deep learning methods.

// - Discuss its use for semantic extraction
// - Discuss its downsides
// -- need for lots of data
// -- poor generalization
// -- poor re-usability by other researchers
// -- poor failure characterization: can fail in unexpected ways, or silently
// -- poor wider scientific community understanding of how to validate and pipeline ML


// == Portable machine learning / Opensource / Freely available software

// Discuss limitations of current softwares wrt portability

// === Opensource
// SOTA of Opensource methods

// === Closed source / Paid
// SOTA of closed source methods


// == Vascularization reconstruction

// Vascularization in different body parts and tissues -> explain it varies and if anyone has done a review

// ]