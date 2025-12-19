= State of the art

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

In order to bring new drugs to market, a set of steps must be followed that are established by organisations such as the European Medical Association in the European Union, or the Food and Drug Administration in the U.S. One of the key steps is collecting data on the effectiveness of the drug, done through clinical trials. These trials, before taking place in humans, are done on animals in a controlled lab environment, where collected data is analyzed for the outcomes and side effects of the drug. In the analysis process for Pazopanib, the histology of the tumors is critical in identifying the impact of treatment when compared to a control, in the quantitative measurement of 

The conclusions taken from each step in the analysis decide if the clinical trial moves on, meaning that a more accurate prediction, with tighter confidence intervals, enables a better discriminative power and avoid discarding effective drugs due to uncertainty from process limitations. 

#v(1cm)

- https://doi.org/10.1053/j.gastro.2021.02.035

- Liver Histology and Clinical Trials for Nonalcoholic Steatohepatitis-Perspectives From 2 Pathologists, Kleiner, David E.Bedossa, Pierre et al. Gastroenterology, Volume 149, Issue 6, 1305 - 1308
- weak: https://doi.org/10.1055/s-0040-1709491

- Here I found some sources from EMA/FDA and other supranational organizations, another potential one is https://doi.org/10.1016/j.molonc.2014.06.002
- However it doesn't really discuss, to be read into further

=== Histology in industry

Histology has been used in industry for data acquisition for decades, due to its deliverance of large amounts of qualitative data that are interpreted by experts during the process of drug research. It is used in clinical trials of structure altering drugs, or where the effect of interest is expected to be visible, and is generally done by specialized histopathologists [1]. Clinical trials vary widely in their design, as well as have a large variety of possible targets, in oncology specifically 2D histology remains the most widely used technique [3] and [27, 60] for the histology of biopsies for humans. The principal method used is 2D microscope slice histology [2], known as "classical histology", where tissue is collected, followed usually by one or more forms of staining, ending in image acquisition and interpretation. In our industrial usecase, 2D histology is the reference method used to evaluate tumors.

#v(1cm)

- https://doi.org/10.1111/his.14099
- Need a better source here, Methods in clinical trials: https://doi.org/10.1093/ecco-jcc/jjw161
- not a good source, get better https://doi.org/10.1016/j.molonc.2014.06.002
- Wlodarski 27: https://pubmed.ncbi.nlm.nih.gov/32445458/
- Wlodarski 60: https://pubmed.ncbi.nlm.nih.gov/37008634/

==== 2D histology

The field of histology is born from 2D histology of thin slices of tissue, potentially with various staining agents applied to increase contrast or highlight certain structures, done under the microscope using light. This technique is used due to its delivery of a large amount of relevant data and high discriminative power, although it is time consuming and costly. As a technique it has evolved in multiple directions, from the utilization of advanced staining agents [1] allowing the staining of a broad range of classes (DNA, proteins, lipids, or carbohydrates), to different lighting wavelenghts, ranging from ultraviolet [2] to infrared [3]. 

#linebreak()
2D histology is limited by its requirement to slice the target tissue before analysis, resulting in destructive modification of the sample. It also requires specialized labour, is time consuming, and costly [5] This slicing also has the potential of deforming the tissue, with various techniques developped to conteract this [4] such as embedding in a medium. Slicing is also not orientation agnostic, and a large number of slices might be
required for a sufficient spatial analysis of the sample, especially in situations where the observation target do not follow a particular axis. 

#linebreak()
The limitations of pure 2D histology are now resulting in quantitative histology moving in the direction of 3D analysis, especially when 3D structure of the tissue is relevant. 

#v(1cm)

- [0] Partially inspired from https://doi.org/10.1155/2019/8617406

- https://www.ncbi.nlm.nih.gov/books/NBK557663/
- https://pmc.ncbi.nlm.nih.gov/articles/PMC6223324/
- https://pmc.ncbi.nlm.nih.gov/articles/PMC10408309/
- Mescher, L. A. Junqueira's basic histology. Text and atlas 14th ed. (McGraw-Hill, 2016).
- Source from [0]: https://doi.org/10.1155/2019/8617406


==== 3D histology

3D histology is a method for increasing the amount of information available for analysis when compared to 2D classical histology. In its most basic form, it involves taking multiple 2D slices and aligning then stacking them to create a virtual third axis [1] and is also relevant for tumor analysis [2], allowing for structural understanding of a tissue, such as in [2] enabling "the spread and infiltration of invasive carcinoma to be understood".

#linebreak()
Other methods for 3D histology 

Microfocus X-ray computed tomography (microCT) offers a valuable solution for X-ray based 3D histology of biological tissues, complementary to classical 2D histology

#v(1cm)

- https://doi.org/10.1016/j.ajpath.2012.01.033
- https://doi.org/10.1136/jcp.2004.024794

Not very sure about how to put the quote in, but felt important to have it as it explains, specifically for cancer and for stacking of classical 2d histo, that 3D is already relevant.

=== Vascularization reconstruction


== 3D imaging

=== Methods of 3D imaging

=== MicroCT imaging


== Structural Extraction

=== Semantic segmentation

=== Structural reconstruction


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