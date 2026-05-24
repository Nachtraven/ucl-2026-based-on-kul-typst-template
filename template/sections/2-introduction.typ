// Notes moved to "2-introduction-backup-29-04.typ"
// 2D histology → limitations → 3D imaging → micro-CT → contrast-enhanced micro-CT → the vasculature segmentation problem → the tooling/usability gap → the contribution
// Tighten the introduction's first paragraph to three sentences and introduce the Pazopanib dataset as the test bed
// (1) tissue structure matters for function, vasculature especially; (2) 3D imaging is now the way to capture it, but the data is hard to process; (3) here's the specific problem this thesis addresses.

//  across different wavelenghts, ranging from sound and infrared to magnetic resonance and x-ray imaging.

// The test I'd apply to any sentence in the intro: is this introducing the reader to the problem, or is it surveying prior work? If the latter, it belongs in the SOTA. The test for the SOTA: am I telling the reader something they need in order to evaluate the gap, or am I re-motivating the thesis? If the latter, it belongs in the intro (or nowhere).

// Introduction = why this work exists. It motivates the problem in the reader's terms (biology, drug evaluation, dataset specificity), names the gap, and announces the contribution. Claims here are allowed to be uncited or lightly cited because they're framing, not survey.
// State of the art = what has been tried and why it's insufficient. It surveys the landscape with citations, compares options, and ends each subsection with a "Problem N" box (which you're already doing — good pattern). Claims here must be defended.

= Introduction

Biological tissue function depends strongly on spatial organization and composition. This is especially true for vascular networks, spread inside all other tissues for which the geometry of branching, vessel diameters and connectivity define functionality. To obtain an understanding of such tissues 2D histology stands as the gold standard, but the limitations it presents in capturing three dimensional structures like those of vasculature have driven the adoption of high resolution 3D imaging techniques. Micro-computed tomography (Micro-CT) stands as a method able to achieve resolutions enabling the extraction of vessels ranging down into the micrometer range, and has multiple contrast-enhanced variants aiming to improve tissue separation. These methods generate orders of magnitude more data than traditional microscopy and pose new challenges in information extraction and processing.

In the context of research on angiogenesis - the process of vascular growth exploited by tumors that antiangiogenic drugs aim to disrupt - quantifying changes in vascular structure is essential to evaluating treatment efficacy. The dataset motivating this work consists of contrast-enhanced Micro-CT scans of murine tumors collected to assess the antiangiogenic drug Pazopanib, whose mechanism of action is expected to manifest as measurable changes in vasculature. 

#linebreak()
However, existing tools tools for analyzing Micro-CT data are dominated by proprietary paid software and the available open-source alternatives lack robust solutions to extract small-scale vasculature with its challenging specificities: low contrast, non vessel-like structures, diffusion gradients, and vessels only a few voxels across. As a result, the vasculature in the provided datasets has resisted prior analysis attempts.

To address this, a pipeline called CollaboratiVessel for microvasculature extraction from Micro-CT data is developed in the form of a 3D Slicer plugin, an open-source tool widely used in medical imaging. Hyperparameter tuning is minimized by leveraging user input and tuning to fit the domain while keeping parameters exposed, making the pipeline adaptable to new datasets with the end user in the loop. Usability is prioritized to bridge the divide between computer vision research and biological use.


== Biological motivation

Tissue samples are collected and imaged in order to gain an understanding of their structure and composition, called histology or histopathology in the case of diseased tissue. Classically this is done ex-vivo in 2D, with sections analyzed manually under a microscope by a human, the gold standard for tissue analysis @2d_histo_sota_balcaen2023revealing. However the technique has a fundamental limitation: information is not captured at the same granularity along all three axes. Methods exist to stack slices and reconstruct a 3D volume @methods_for_3d_histo_pichat2018survey, but axial resolution is limited by section thickness, and dead space between slices leaves regions where no information is acquired @litt_review_greet_debournonville2019contrast and the cutting process itself induces changes in tissue structure @extending2d_histo_to_3d.


Evaluating Pazopanib, a tyrosine kinase inhibitor influencing the formation of new blood vessels, requires extraction and quantification of the tumor vasculature. Vascular networks are inherently 3D and span entire tissues, having abstract parameters relevant to understanding drug administration response. This 3D nature, combined with the limitations of slice-based methods, motivates high-resolution 3D imaging: for the dataset used in this work, contrast-enhanced Micro-CT scans were acquired using an agent that increases the attenuation of the small blood vessels.

#v(0.25cm)
#include("./appendices/intro_cect_image_annotations.typ") // Some example images of the data
#v(0.1cm) 


== Obtaining information from imaging

Analyzing tissue requires imaging it at a sufficient resolution to extract the structure of interest, and 3D imaging modalities leveraging tomography such as Micro-CT and Micro-MRI now make this possible at micrometer resolution. However moving from 2D to 3D imaging carries with it challenges: a single high-resolution Micro-CT scan produces thousands of slices and orders of magnitude more data than a comparable 2D acquisition, meaning that manual analysis as with 2D microscopy at this scale is impractical. Micro-CT data itself is also highly variable: scans differ on the same machine due changes in imaged tissue, contrast agents and protocols used to make structures of interest visible, and further variation arises across machines and due to researchers' choices of acquisition parameters. 

#linebreak()
When faced with complex data the paths for researchers are twofold: either _manual analysis_ of the data, or _utilization of algorithms_ to aid in the separation of their structures of interest. Manual annotation suffers from high subjectivity, strong variance between annotators @variability_in_annotations_xray_lin2023pluribus and requires time and expert annotators, meaning both direct use and use in machine learning present challenges. Additionally, annotation natively in 3D is challenging: it is difficult to properly consider all three axes simultaneously, hindering work on small 3D structures like vasculature. 

When using algorithms for extraction, users are pulled towards user friendly and simple methods: (1) generalist methods such as thresholding, easily understandable and widely available, but performing poorly on data that cannot be separated by intensity alone, and (2) a wide spectrum of techniques that carry a richer prior or set of priors about the target structure, ranging from purpose developed algorithms to data driven ones as in deep learning. For vessel analysis, simple methods are easy to apply but result in discontinuities in blood vessels, artefacts, and don't generalize across samples, as well as require the selection of a fixed threshold per sample, a step not performed in a repeatable principled fashion, as learned from user interviews. 

#linebreak()
The uptake and adoption of advanced techniques like deep learning remains limited outside of the walls of computer science labs due to the barrier to entry associated with using a new tool or method being too high: proprietary paid tools are used, research software is often unmaintained or poorly documented and algorithms are challenging to run on different machines. Modern deep learning based algorithms add even more barriers: dedicated GPUs are typically required @unet_og_paper, input data must be converted to specific formats, and out-of-distribution data often demands retraining, requiring data and computer science knowledge. 

#v(0.2cm)

==== Contribution and scope

Work will be carried out to create an open-source and data driven small blood vessel extraction method for obtaining segmented blood vessels, with the goal of enabling downstream extraction of clinically relevant vasculature characteristics. This goal is defined by the use case of a dataset of Contrast-Enhanced Micro-CT data acquired to examine the use of Pazopanib. The pipeline is created as an easily installable plugin for 3D Slicer, an open-source and free base software, that ingests and outputs data in portable data formats familiar to researchers, to ensure re-usability and compatibility with existing downstream software. The plugin implements proven algorithms with sparse user input leveraged to set principled hyperparameters enabling easy re-use without requiring expertise in computer science. Implemented methods are tested for robustness by examining performance on data previously considered non segmentable due to non uniform contrast agent staining.

#linebreak()
All code written in the implementation of this thesis, the source code of this document, and the user feedback, are made open-source under the MIT license (for code) and labeled under the creative commons as CC0 - No Rights Reserved (for creative works - the writing).




//This combination of data volume percludes human analysis, and data heterogeneity challenges algorithmic analysis.


// #linebreak()
// There is also the issue of data diversity stemming from the increase in dimensionality and available imaging methods: even for one given imaging type such as Micro-CT, there is high scan to scan variance between different tissues, a wide array of machines and machine settings, and different contrast or staining agents that can be used at different concentrations and with different methodologies for getting them into the tissue of interest. This huge diversity natually drives a huge diversity in data with as consequence a fragmented and diverse data processing landscape. 

// // #linebreak()
// Our imaging method of choice for analyzing blood vessels, Micro-CT, presents low contrast between soft tissue: techniques exist to increase contrast and improve visibility such as cryo-CT @cryoct_maes2022cryogenic or the utilization of contrast enhacing staining agents (CESAs) in Contrast-Enhanced CT called CECT, as used for the data in this thesis. Although essential to increase the contrast between tissue types, these techniques still do not enable sufficient differentiation for small vascular networks such as those found in the murine tumors collected for the evaluation of Pazopanib to allow threshold based classification as is commonly used for bone or for samples with high contrast agent presence @litt_review_greet_debournonville2019contrast, this was shown during the analysis phase of @wlodarski, the source of the data used here, where threshold based segmentation was used and resulted in poor performance.


// == Computer science as a tool

// This annotation variance, combined with the time required to manually segment, means that the small vascular networks in the provided data have yet to be manually segmented. 

// The inter annotator variance can be explained in mutliple fashions: expertise difference, tool type and experience, available time, subjectivity and more. Additionally, annotation natively in 3D is challenging, meaning it is difficult to annotate while properly considering all three axis simultaneously, hindering the annotation of small 3D structures like vasculature. This annotation variance, combined with the time required to manually segment, means that the small vascular networks in the provided data have yet to be manually segmented. 



// HERE IMPORTANT TO MENTION AUTOMATIC ML NN-UNET
// Situation: computer science is not used outside of computer science labs and papers
