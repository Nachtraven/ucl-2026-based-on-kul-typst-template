// Sébastien notes: No metrics in SOTA
// Vue hélicoptère: you want citable bibliographic references, your technical chapter goes into some specific algos
// SOTA: mettre le doigt sur les trous, et ce sur quoi on va travailler

// supposer le communément acquis: e.g. perceptron
// SOTA: ce que vous allez faire, et ce qui a déjà été fait par le passé 
// 30 references

// Intro 5 pp
// SOTA 10pp
// Technologie/technque 10pp
// Methodologie 10pp
// Resultats 10pp
// Conclusion 3-5 pages (discussion et repossitionner le travail)


// Add papers: 

// Three-dimensional multi-scale line filter for segmentation and visualization of curvilinear structures in medical images https://www.sciencedirect.com/science/article/abs/pii/S1361841598800091
// skeletonization algorithm in scikit-image: Building Skeleton Models via 3-D Medial Surface Axis Thinning Algorithms https://www.sciencedirect.com/science/article/abs/pii/S104996528471042X

// Image Segmentation Using Deep Learning: A Survey https://arxiv.org/pdf/2001.05566


// TODO: add from https://forum.image.sc/t/comparison-of-some-tools-for-3d-dense-ground-truth-annotations/38918/39
// https://project-monai.github.io/
// https://home.webknossos.org/


// TODO: add Precision-Recall discussion: Precision-Recall is a useful measure of success of prediction when the classes are very imbalanced. Our dataset is imbalanced, and our prediction algorithm is supposed to have a lot of FP because the GT is sparsely annotated. So our recall MUST be high with only "relevant" false positives.

#import "@preview/colorful-boxes:1.4.3": *

= State of the art

== Software and Software licenses in Research

Software licenses are closely linked with the monetary and scientific costs of use: they don't only govern the terms of software use but also of modification, influencing the ability to build upon existing work. They broadly fall into two categories: proprietary (closed source) and open source. Proprietary software restricts access to its source code and is generally distributed under a paid license, with certain exceptions such as with Dragonfly3D's FreED license. Open source software makes its source code publicly available and is as a result free of charge. In a research context, the distinction matters beyond cost: open-source code is by nature extensible, with prior work directly inspectable and modifiable, while proprietary licenses can enable the owner of the original software to control the distribution and use of extensions: Dragonfly3D does not explicitly allow sharing extensions #footnote["\[The user\] shall not distribute or transfer the Software or Improvements \[...\], without prior written permission \[from Dragonfly3D\]" @DragonflyFreeDLicense]. 3D Slicer's license, by contrast, permits modification and redistribution: see #link("https://slicer.readthedocs.io/en/latest/user_guide/about.html#license")[3D Slicer's license page]. Open-source licenses themselves vary in how they govern downstream use, from permissive (MIT, BSD) to copyleft (GPLv3), with implications for how derivative work must be redistributed.

// #linebreak()
// Open source software matters in scientific research: being free removes a significant barrier to entry, and open-source is by nature extensible: prior work can be built upon by accessing, modifying and learning from its source code and development. Open-source licenses are diverse, from permissive such as MIT or BSD as used by 3D Slicer with modifications to protect from clinical use, and copyleft (GPLv3, used e.g. by Orthanc @orthanc_paper_jodogne), with implications for how downstream work must be redistributed.





=== Software for 3D analysis <sota_sw_for_3d>

Researchers at the UCLouvain faculty IMMC (Institute of Mechanics, Materials, and Civil Engineering) use a variety of software to process 3D Micro-CT data: closed source in the form of Avizo and CTan, "free-for-academics" with Dragonfly3D, and previously used open-source in the form of ImageJ/FIJI. A full list of available solutions is visible in @3d_software. Standalone approaches exist, such as DeepVesselNet @tetteh2020deepvesselnet and SPROUT @sprout_segmentation_volumetric but do not come packaged as a software with user interface.

#linebreak()
For this thesis, software was required to meet the following three hard requirements: *(1)* Import a 3D scan from individual 2D slices in standard formats, *(2)* Export data to non-proprietary formats, and *(3)* Allow coded plugins/code extensions. Some practical considerations were also taken into account: availability of dedicated support and documentation, active development, prior use within the lab and the broader research community, and ease of installation for non-technical users.

Each candidate platform was tested for the practicality of implementing a plugin within its extension framework. Avizo and Dragonfly3D met the hard requirements but limit plugin redistribution as laid out previously. ImageJ/FIJI has a long history in biological image analysis and a rich plugin ecosystem, including use for vessel extraction @imagej_frangi, but native support for vascular network extraction in 3D is limited, and the plugin development model is less suited to the integrated segmentation workflows this thesis requires.

#linebreak()
3D Slicer @3Dslicer_paper emerged as the most suitable platform. It is open-source under a permissive BSD-style license, widely adopted in the medical imaging field, and supports 3D segmentation workflows with established plugins relevant to vascular analysis such as the Vascular Modeling Toolkit (VMTK) @vmtk and R-Vessel-X @affane2025rvesselx. Its Extension Manager allows non-technical users to install plugins through a one-click interface without compiling code or managing dependencies, and standard import/export formats including DICOM and NIfTI ensure interoperability with downstream analysis tools.


#v(0.5cm)
#colorbox(
  title: "Problem 1.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#00bfff"),
    title: rgb("#002366")
  ),
  radius: 4pt,
  width: auto
)[
  Existing tools for 3D analysis are split between proprietary paid software and open-source platforms, neither having bespoke microvascular support. The pipeline must therefore integrate into an open-source software for 3D analysis: 3D Slicer.
]






// Maybe add: https://pdf.sciencedirectassets.com/273258/1-s2.0-S1742706120X00043/1-s2.0-S1742706120300532/main.pdf
// Exploring polyoxometalates as non-destructive staining agents for contrast-enhanced microfocus computed tomography of biological tissues

#pagebreak()
== Tissue imaging

The process of imaging is a critical step in obtaining an understanding of a tissue in both clinical and research contexts. 2D histology is considered the gold standard having a long history @2d_histo_sota_balcaen2023revealing and producing high resolution images down to 5 μm for light based methods. The diversity in imaging techniques for 2D histology has rapidly increased the resolution, with electron microscopy able to reach in the order of sub nanometer scale @histology_used_for_cancers_he2012histology. Progress has also increased the dimensionality of imaging, with computation enabling rapid progress in 3D methods using techniques like tomography, where multiple images are taken non-destructively of a target from different angles and assembled, used in-vivo and ex-vivo methods such as computed tomography (CT) and magnetic resonance (MRI).

#linebreak()
For tasks such as measuring the impact of a drug on vascularization, quantification is particularly relevant: Understanding the three-dimensional structure of biological tissue is a prerequisite for the analysis of structure-altering drugs such as Pazopanib, where changes in tumor vascularization are inherently spatial and quantifiable across multiple parameters. For such tasks, 2D histology is insufficient: Physical sectioning of the sample is destructive, is not orientation-agnostic, and introduces deformation artifacts that are difficult to compensate for even with embedding techniques @3dnondestructive_softtissue_µtomo, additionally samples may undergo structural changes over time during preparation: they dry out, and certain elements oxidize, although techniques exist to mitigate this @litt_review_greet_debournonville2019contrast.

#linebreak()
To achieve 3D imaging from 2D histology, 2D slices are stacked across a virtual axis @extending2d_histo_to_3d. The resolution achievable when stacking 2D slices to reconstruct a virtual third dimension is limited by slice thickness and inter-slice registration errors. Certain optical techniques making use of slices allow partial recovery of 3D information from 2D acquisitions, such as confocal microscopy, light sheet microscopy, and optical coherence tomography @cryoct_maes2022cryogenic, they are limited in sample penetration depth and volume. When the target structure to be imaged and understood does not follow a single preferred axis, as is fundamentally the case for vascular networks and especially those of tumors, the limitations of slice-based histology make proper reliable quantification of blood vessel parameters impossible, and the relevance of 3D methods like MRI and CT clear. 


=== 3D imaging techniques for histology

Non-destructive 3D volumetric imaging methods overcome many of the limitations of 2D slice based histology by collecting data uniformly across dimensions, enabling virtual slicing across any plane without requiring physically sectioning the sample. Techniques for 3D imaging range from the aforementioned microscopy techniques using visible or near infrared light, to techniques like MRI that utilize magnetic fields or X-Ray imaging in the form of X-ray microfocus computed tomography (CT). These techniques allow the collection of qualitative and quantitative 3D microstructural data of tissues and their constituents: analysis is not restricted to a single orientation and does not require sample destruction. They also have associated high resolution variants allowing micrometer level imaging: Micro-MRI has an inherently high-contrast for soft-tissue and is able to reach 20 μm @Chen2018; Micro-CT is commonly used at 6µm, as in the data used in this document and resolutions down to 1µm are possible, but the technique suffers from low contrast when imaging soft tissue, when extra technques are not used @2d_histo_sota_balcaen2023revealing. These techniques are the most relevant for ex-vivo tissue histology at the scale of small animal models, due to their small maximum capture volume.



=== Contrast-enhanced micro-CT <CECT_technique>

As mentionned, standard Micro-CT suffers from low contrast between soft-tissue making the visualization of blood vessels difficult. To improve contrast two common approaches exist: changes to imaging methodology, and modifications to the sample. Imaging techniques such as phase-contrast Micro-CT (PC-CT) utilize the refractive properties of the X-rays rather than its absorption alone, enhance soft tissue edge detection at the cost of higher complexity and long acquisition times. Tissue modifying techniques that aim to increase contrast include the use of various Contrast Enhancing agents (CESAs): Casting contrast agents (CCA) are perfused into vasculature but pressure must be controlled carefully @exvivo_cardioct and is not applicable to our usecase due to the size of vessels to be observed. Diffusion contrast-enhacing agents reach the structure of interest and bind to it based on diffusion through the structure to be imaged, termed CECT. For the tumor vascularization studied in this thesis, ex-vivo tissue binding CESAs are used, namely Hafnium Wells-Dawson Polyoxometalates (Hf-WD POM) due to its nondestructive nature and low tissue shrinkage during incubation after excision. Techniques exist that can be used in combination with CESAs: contrast can be increased using freezing to increase contrast Cryogenic contrast-enhanced microCT (cryo-CECT) which preserves tissue microstructure with reduced deformation @cryoct_maes2022cryogenic.

Tumors also present a particularity in that they are frequently partially or entirely devoid of residual hemoglobin, preventing or reducing the action of CESAs and thereby reducing contrast and introducing discontinuities. Diffusion based contrast-enhacing agents also bring an additional disadvantage as seen in the data provided for this thesis, visible in @reliability_of_scans: the diffusion of CE agents throughout the tissue happens from the outside in, resulting in a gradient of the amount of agent and as a result a gradient in contrast, as opposed to perfusion CESAs that follow the blood vessels. 


#v(0.2cm)
#import "./appendices/gradient_graph.typ": chart

#let image-with-line(path, colour, label) = block(width: 100%, height: auto)[
  #set align(center + horizon)
  #image(path, width: 100%)
  #place(center + horizon, line(length: 100%, stroke: 0.8pt + colour))
  #place(
    bottom + right,
    dx: -0.4em, dy: -0.4em,
    box(
      fill: rgb(0, 0, 0, 160),
      inset: (x: 0.4em, y: 0.2em),
      radius: 2pt,
      text(fill: white, size: 9pt, weight: "bold")[#label],
    ),
  )
]

#figure(
  stack(
    spacing: 0.6em,
    chart,
    grid(
      columns: (1fr, 1fr),
      column-gutter: 0.6em,
      image-with-line("../../resources/images/ca-ru-r_0864.jpg", red, "CA-RU-R - Reliable"),
      image-with-line("../../resources/images/ca-rl-l_1489.jpg", blue, "CA-RL-L - Unreliable"),
    ),
  ),
  caption: [*Top:* Illustrative grey values of a reliable scan (Red) and unreliable scan (Blue). An ideal scan would be approximately flat within the tumor.
  
  *Bottom Left:* CA-RU-R, considered reliable. *Bottom Right:* CA-RL-L, considered previously unreliable.],
) <reliability_of_scans>
#v(0.2cm)

#colorbox(
  title: "Problem 2.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#00bfff"),
    title: rgb("#002366")
  ),
  radius: 4pt,
  width: auto
)[  
  Our Micro-CT CECT data presents non-uniform contrast gradients across samples in addition to intra-dataset variability. The pipeline must therefore be robust to varying contrast and work on all dataset samples.
]







#pagebreak()
== Vascular Segmentation <imaging_and_seg>

The purpose of imaging a tissue is to generate an image containing sufficient data to enable useful information to be extracted. This goal can be seen in the progress of imaging techniques: the improvements in the _acquisition process_ laid out in the previous section, to make the data of interest more salient (using agents to enhance the contrast) or to make the data more granular (increasing resolution). The _information extraction_ process has also seen improvements over time, with analysis evolving from human to computerized through different paradigms: classical thresholding and region growing, geometrically motivated filters and path-based methods to data-driven learning approaches.

#linebreak()
Vasculature extraction from 3D tomographic data is a longstanding challenge in computer science, predating deep learning as reviewed in @LESAGE2009819. The 3D data of this thesis carries a unique set of challenges specific to modern high resolution CT: the vessel diversity ranges in the supplied data from singular voxels (~6µm) to tens of voxels (100+µm) across, corroborated in @microct_tumor_angio. The vasculature is diverse in shape and branching structure, with variable grey levels and most critically disconnections of variable size, presenting however a distinctive and consistent set of geometric priors.

The priors of vessels, namely that they are tubular, connected, branching structures and contain blood, provides a distinct imaging profile against surrounding tissue when combined with a CESA. They are what subsequent segmentation methods either exploit explicitly through hand crafted classical filters or learn implicitly in data-driven methods.

=== Classical segmentation

// Intensity-based (Otsu, thresholding)
// Region-based (region growing, watershed)
// Problem: none encode vascular priors → fragmented, context-blind output.

==== Intensity-based methods

In its simplest form, intensity-based thresholding methods such as Otsu @OTSU_segmentation select an optimal global intensity threshold by maximizing inter-class variance across the image histogram. Such methods are computationally inexpensive and interpretable, but are sensitive to noise, imaging artifacts, and intensity inhomogeneities, as they optimize for a numerical goal. Gradient-based and global-threshold methods are a natural first approach to CECT data, since contrast agents are intended precisely to increase the salience of the structures of interest. However, methods that reason globally over the image can fail in practice due to diffusion gradients @CECT_technique and acquisition noise as mentioned previously. 

Region-growing methods @region_growing extend thresholding by incorporating spatial connectivity: starting from one or more seed points, labeled regions are iteratively expanded according to local intensity criteria, such as in flood-fill, and generalized further by methods such as watershed @watershed_Soille_1991, which treats the image as a topographic surface. Incorporating this spatial connectivity prior makes them more robust to global intensity variation, but remain susceptible to over- or under-segmentation in complex structures: they fail to encode the more specific vascular priors, producing fragmented segmentations in the low-CESA, weak-signal regions characteristic of diffusion-CECT data.

==== Geometrically motivated methods

// Hessian/vesselness filters (Frangi, beyond-Frangi) — local geometric priors
// Minimal path / centerline tracking — global topological priors, expert-in-the-loop
// Skeletonization-first vs. segmentation-first pipelines
// Problem: hyperparameter-heavy, degrade at junctions, scale poorly to dense vasculature.

Beyond intensity-based methods, algorithms integrating local geometric priors exist such as Gabor filters or Hessian-based filters @SATO1998143 where the local second-order structure is analyzed to detect tubular shapes, characterized for vessel detection by Frangi's multiscale vessel enhancement filter @frangi_og_paper, with extensions such as @beyond_frangi and many other methods being created since. Although many improvements to frangi exist, with a selection of 6 methods compared in @9833530, Frangi remains highly competitive, being shown to continuously offer the highest true positive to false positive rates. 

// Frangi detects ridges (peaks of curvature), not edges (peaks of gradient)!

#linebreak()
These second-order methods utilize the eigenvalues of the Hessian matrix of local image intensities (capturing how rapidly intensity changes are themselves changing - the local curvature of the intensity surface) at multiple Gaussian scales (corresponding to multiple candidate "tube" sizes) to produce a vesselness score for each voxel, modeling the prior of blood vessels by responding to tubular structures while suppressing blob- and plate-like ones. Frangi and related methods offer greater robustness than simple thresholding but depend on the user fine tuning algorithm hyperparameters to optimize performance for a given domain or usecase when working with a tool as in @imagej_frangi. Additionally the filter's response degrades at vessel bifurcations, at the endpoints of vessels, and in regions of low contrast. In @beyond_frangi extensions to the vesselness formulation are proposed that improve responses at junctions and at low-contrast boundaries to increase robustness of the filter.

#v(0.5cm)
#include "./appendices/frangi_graph.typ"
#v(0.5cm)

Although offering high performance, second-order methods are inherently local, failing to incorporate the overarching goal of vasculature extraction. A different class of methods reformulate extraction as a global optimization rather than a local filter response, such as minimal path methods which formulate vessel centerline extraction as an optimization problem. The path of least cost is taken between user-defined endpoints, with cost derived from vesselness or image intensity. In @minimal_path_tubular the geometry of vessels is incorporated, adding radius as an additional dimension of the path space. This class of methods is particularly well-suited to expert-in-the-loop approaches where small amounts of data need to be annotated: a user can place seed points that guide the extraction of a complete vascular tree, requiring no training data, and enabling iterative improvement. This method can be seen used for large arteries and airways available in tools such as the Vascular Modeling Toolkit (VMTK) @vmtk. This strength is also a weakness: the low scalability means that for a densely vascularized tissue, or a tissue with non-uniform characteristics, many seed points can be required which is impractical. Automatic seed point placement is a potential solution although introducing its own tradeoff, moving the optimization and work into the point placement. 


=== Data driven learning methods

// CNN era (U-Net, V-Net, 3D U-Net, nnU-Net)
// Vessel-specific architectures (DeepVesselNet, multi-task with centerline/bifurcation heads)
// Hybrid approaches do not exist (Frangi + U-Net, vesselness as input channel or auxiliary loss)
// Transformers and foundation models (SAM-style prompting)
// Problem: annotation cost; domain shift; architecture choice secondary to data availability.


Data-driven methods approach extraction from a different direction: rather than hand-engineering features and priors, parameters are learned from labeled examples. Supervised learning algorithms map labeled inputs to outputs with simple methods like k-nearest-neighbours use neighbour voting and more complex gradient-boosted trees combining weak learners @xgboost. With the paradigm deep learning exploding in popularity with @alexnet_og_deeplearning, higher dimensionality inputs became analyzable without hand crafted features, and led to fully convolutional encoder-decoder architectures being used in the medical domain such as with U-Net @unet_og_paper, a leap in performance for image segmentation. 

U-Net specifically constituted a breakthrough in medical imaging due to its ability to segment large images with high compute and data efficiency, and across multiple scales by introducing skip connections between encoder and decoder pathways. These allow the network to combine low-level spatial detail with high-level semantic context, enabling the segmentation of thin structures that require context such as cells and vasculature. The structure of U-Net can be extended into 3D with different approaches such as @3d_unet. Recently, transformer-based architectures have superseded convolutional networks as a more generalist approach to machine learning, being applied to object detection @detr_paper and being extended to segmentation @kirillov2023segment_SAM, offering higher performance thanks to a more general computation model. Expert crafted feature extraction is removed, such as in the locality prior of convolutions, enabling the capture of more diverse features and long-range spatial dependencies, at the cost of an increase in required training data, an issue for Micro-CT.

#linebreak()
As algorithm complexity and data dimensionality increase, so must the amount of training or example data increase, an issue for convolutional networks and even more so for transformers. This limits the application of deep learning to Micro-CT data, where annotated data is expensive and where inter dataset variance is large, even though attempts exist to palliate the high data requirements by offering self-configuring training frameworks with model weights @nnunet_paper or by crafting more data-efficient models. Examples also exist of trying to make use of so called foundation models, based on a large transformer and able to be "prompted" to customize the segmentation to the usecase at hand @SEMERARO2025102218. 

Deep learning has been applied to vascular segmentation for blood vessel extraction directly with notable success: DeepVesselNet @tetteh2020deepvesselnet introduced a family of architectures designed for vessel segmentation, centerline prediction, and bifurcation detection in 3D angiographic data by making explicit use of the structural priors inherent to blood vessels as secondary learning targets. 

#linebreak()
Finally, hybrid approaches offer the interesting property of combining classical extraction methods with deep learning by leveraging input filters on the image to obtain richer features, such as applying vesselness maps to the image before processing, to integrate the priors of the vesselness filtering explicitly into the algorithm and reduce data needs @vesselness_maps_in_unets. This decouples the structural prior, encoded by the filter, from the learning, allowing the learning element to act as a correction or enhancement stage for the shortcomings of classical methods. This use of classical priors as a feature stage with a form of learning as a correction sets the direction of the present work, with the novel addition of sparse user input as a method for achieving training data acquisition.

#v(0.5cm)
#include "./appendices/taxonomy_of_methods_graph.typ"
#v(0.5cm)

#v(0.5cm)
#colorbox(
  title: "Problem 3.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#00bfff"),
    title: rgb("#002366")
  ),
  radius: 4pt,
  width: auto
)[
  Segmentation has evolved from classical methods encoding geometric priors toward data-driven methods, requiring annotated training data that is scarce and high variance for CECT micro-CT. Our work should need no training data when used but instead leverage simple user placed points, and automatically adjust the hyperparameters to enable portability across diverse data.
]


=== Unreliability of ground truth

// Inter-annotator variability and its bound on supervised performance
// Annotator bias propagation (the skeletonization-first workaround you mention)
// Sparse/point annotations vs. dense voxel annotations as a trade-off
// Implications for evaluation: if labels are noisy, voxel-overlap metrics overstate disagreement on uncertain boundaries
// Problem: the upper bound on any supervised method is set here, not by the architecture.

// Extra sources suggested by Claude 28-04-2026
// Joskowicz et al. 2019 (European Radiology, "Inter-observer variability of manual contour delineation of structures in CT") — directly relevant, classic reference.
// Heller et al. 2021 on the KiTS19 challenge — discusses annotation disagreement explicitly.
// Vincent et al. 2021 or similar work on noisy-label learning in medical segmentation — provides a methodological framing.

Manual annotation of vascular networks in micro-CT images is time intensive and requires expert knowledge. When annotation is carried out, the resulting annotations are known to exhibit significant inter-annotator variability @variability_in_annotations_xray_lin2023pluribus. This variability represents an irreducible uncertainty in the ground truth that places an upper bound on the performance achievable by any supervised method, especially those training on voxel-level data. Work-arounds exist: structural extraction (e.g., skeletonization) may be used on the data first, with the resulting structures used to guide subsequent voxel-level re-annotation, reducing inter-annotator noise. However this means the biases of the skeletonization algorithm are now inherited by the annotations and introduced into models trained on them. 

An alternative to real annotated data is the use of simulated and automatically annotated data, using either geometrically driven techniques such as L-Systems, to generate branching tree structures grounded in the physiological laws of arterial branching, reviewed in @l-systems-review, or neural-network driven systems such as generative adversarial networks (GANs) @GANs_medical. 

#linebreak()
When data is available it may be used directly, although models trained on one imaging protocol, contrast agent, sample batch, or tissue type exhibit degraded performance when applied to data from a different distribution: this is termed domain shift, and is particularly acute in imaging methods containing many adjustable parameters and machine hardware specificities like micro-CT imaging. This can require the use of techniques like transfer learning, where a model is first trained on a similar task with large data availability then fine-tuned on a small amount of in-domain data @tetteh2020deepvesselnet. Annotated data can also be _augmented_ to artifically increase the available amount and diversity by applying random degradations, elastic deformations and intensity perturbation while preserving the original annotations. 

#colorbox(
  title: "Problem 4.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#53d1fb"),
    title: rgb("#00369a")
  ),
  radius: 4pt,
  width: auto
)[
  Data from different datasets is not necessarily directly usable as a proxy without careful consideration. In domain data manually annotated for performance measurement, especially by a non domain expert, cannot be considered an absolute ground truth. For the purpose of evaluating this work, data will be annotated in distribution, and errors calculated should take into account the potential variability from annotations.
]



=== Error calculation

// Voxel-wise losses and metrics (cross-entropy, Dice) and the imbalance problem
// Topology-aware losses (clDice, CFLoss)
// Add graph matching: Topology-aware evaluation: graph matching between predicted and reference vascular trees, branch-level F1, connectivity metrics
// Point-wise evaluation against expert-placed landmarks (your chosen approach)
// Problem: loss ≠ downstream utility; pick metrics that reflect the analysis the vasculature feeds into.

// Vessel level metrics suggested by Claude 28-04-2026
// Drees et al. 2021 (Medical Image Analysis, "Scalable robust graph and feature extraction for arbitrary vessel networks in large volumetric datasets") — vessel-graph extraction and comparison.
// Stucki et al. 2023 or similar work on Betti-number errors and persistent-homology-based evaluation.
// VesselGraph (Paetzold et al. 2021, NeurIPS) — provides graph-level metrics for vessel segmentation evaluation.

When training a model, or evaluating a method, it is important to be able to measure performance in a repeatable and objective way independent of human feedback. Error can be point wise, as is needed for backpropagation in machine learning, or on an aggregate level, as is needed for evaluating system performance, with complexity increasing as dimensionality increases. //In binary classification, the error rate can be as simple as the proportion of correctly classified examples, however as dimensionality of outputs increases, so does the complexity of evaluation methods.

#linebreak()
Loss functions such as cross-entropy used for binary classification calculate the loss on a point-by-point basis, based on the predicted distribution. It can be used for segmentation @unet_og_paper, however vessel segmentation has a severe class-imbalance with vessels being a small minority of voxels. The choice of loss function matters as a result: Pixel-independent losses like cross-entropy treat each prediction as independent, meaning for our biased distribution there is a prior of predicting background and producing fragmented or incomplete vessel predictions. V-Net @vnet_paper extended U-Net into 3D and improved performance by using DICE (also known as F1 score), a method better suited for class-imbalanced settings.

#v(0.25cm)
#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: top,
    [
      $ "Dice" = (2 "TP") / (2 "TP" + "FP" + "FN") $
    ],
    [
      $ "Dice"(A, B) = (2 |A inter B|) / (|A| + |B|) $
    ],
  ),
  caption: [DICE can be used for comparing segmentations A and B, or on binary data. As is shown in the second equation, DICE is agnostic to true negatives (TN) avoiding their outsized weight in heavily imbalanced settings.]
)
#v(0.25cm)

DICE has some specific known downsides for 3D medical image segmentation @Taha2015 relevant here are the equal treatment of FP and FN, and unawareness of spatial differences, and the detection gap, where small totally undetected areas are treated the same as small mismatches in large coverage areas.

#import "appendices/DICE_overlap.typ": dice_diagram

#v(0.25cm)
#figure(
  dice_diagram(),
  caption: [A major DICE challenge in the context of vessel segmentation, where many small vessels (orange) are present but detections (green) in one case totally fail to pick up on certain vessels. These situations would have a similar DICE score, showing the bias towards large overlapping regions, as discussed in @Taha2015.]
) <fig:dice-detection>
#v(0.35cm)

// Other more simple measures such as precision 
// TODO: Should the precision recall curve be mentioned here since it is in the problem statement?

For vasculature specifically, breaks in segmentation can be difficult to reconnect downstream, motivating the creation of custom loss function in @clDice_loss_func called clDice, that integrate the prior of connectedness, and build it into the loss function for predictions. In @CFLoss_loss_func clinically relevant vascular features are encoded into the loss function. A collection of topology-aware loss functions is available in @topolosses. Beyond loss functions, the evaluation itself can integrate vessel structure: graph-matching compares predicted and reference vascular trees at the level of branches and bifurcations rather than voxels, enabling metrics on the branch-level @VesselGraph. 

#linebreak()
When evaluating a segmentation method, consideration of the downstream analysis of its use to extract relevant features, such as tortuosity and branching ratio, is important to consider. As a result, and driven by the expert-in-the-loop approach, outputs will be evaluated based on point-wise loss of user annotated points, as well as on a manually annotated pixel level baseline relevant for connectivity analysis, an area difficult to capture in the loss.

//In light of these considerations, and following the analytical needs of the laboratory researchers
// Graphs metrics are particularly relevant when the goal is biological interpretation rather than pixel-perfect overlap --> evaluate my method on this if time allows

#v(0.5cm)
#colorbox(
  title: "Problem 5.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#00bfff"),
    title: rgb("#002366")
  ),
  radius: 4pt,
  width: auto
)[
  Evaluation of a segmentation performance requires integrating the structure of the problem. Our evaluation methodology should make use of prior aware losses when calculating error rates.
]

// Our method of evaluation must be based on data that is feasible for non-expert annotators to generate using existing 3D Slicer tooling, namely landmark placement, and be calculable in 3D Slicer. To enable downstream performance analysis, segmentations should exportable into a shared format, as well as being evaluated on relevant challenging scenarios.

// Standard segmentation metrics often misalign with the downstream analytical tasks the segmentation feeds into. Our evaluation should therefore use metrics tied to the features researchers extract (branch counts, connectivity, tortuosity), and should report performance separately on the regions where downstream analysis is most sensitive (low-CESA areas, bifurcations).

=== Existing pipelines and tools 

// ITKTubeTK, VMTK, VesselKnife, SKAN, SimVascular, InVesalius. Frame as a landscape map: 
// classical-and-tunable vs. deep-and-rigid, integrated-into-research-tools vs. standalone

Several software tools and pipelines have been developed to support vascular segmentation and analysis workflows. Segmentation-focused tools operate on the image itself: the Vascular Modeling Toolkit (VMTK) @vmtk integrates in 3D Slicer and provides a comprehensive, user-friendly suite for vascular segmentation, centerline extraction, and surface reconstruction, but its methods are oriented toward low resolution, large vessels: arteries, aortas, and major branches. It also relies on seed-based interaction that does not scale to the dense, branching geometry of microvasculature. 

ITKTubeTK @ITKTubeTK_paper_github offers a library of algorithms for tubular-structure segmentation and graph extraction built on the ITK framework, but is packaged as a programming library meaning it requires implementation into a tool or use in code, challenging for non-technical researchers. VesselKnife @vesselknife provides an integrated pipeline specifically targeting vessel segmentation, skeletonization, and graph extraction from Micro-CT data but is a standalone application, requiring researchers to leave their existing analysis environment, and is not intended for small vasculature. Tools like SimVascular @simvascular openrate on the outputs of segmentation and extend vascular extraction into simulation, supporting downstream modeling of blood flow.

// Analysis-focused tools operate on segmentations as produced by  rather than images and are complementary to segmentation pipelines rather than competing with them. SKAN @skan provides a documented Python library for the quantitative analysis of skeleton graphs extracted from binary segmentation masks, enabling computation of branch-length distributions, tortuosity, and network connectivity. SimVascular @simvascular extends vascular extraction into simulation, supporting downstream modeling of blood flow within reconstructed geometries.

#linebreak()
The landscape of vascular segmentation tools reflects a tension in bio-informatics, medical informatics and bioimagery: general-purpose deep learning segmentation frameworks offer good performance on the datasets they are trained on, but require large annotated datasets and offer limited interpretability or controllability as well as are not baked into tools used by researchers. Classical model-based methods such as Frangi filtering are more transparent and adjustable, built into existing tools and easy to use, but require manual parameter tuning and struggle with complex vascular geometries. Neither pole serves the specific need addressed by this thesis: microvasculature-scale extraction, integrated into a widely-used segmentation environment, with parameters set by principled means rather than expert tuning. This combination is the niche the present work occupies.


#v(0.5cm)
#colorbox(
  title: "Problem 6.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#00bfff"),
    title: rgb("#002366")
  ),
  radius: 4pt,
  width: auto
)[
  Existing pipelines focus on large vascularization. This work should fill the niche of small vessel segmentation, where tools are not readily available or tailored to the unique challenges of micro vasculature, and must export in a standard binary segmentation format.
]




// #pagebreak()
// === Segmenting large datasets (removable)

// I had previously here a SOTA on managing large datasets, as this was a challenge that turned up later and blocked me for a while. Would it be interesting to add?

// #v(0.4cm)

// #linebreak()
// Data management for Micro-CT scans is a challenge for users: after a scan is completed, they receive data from the CT machine in the form of a collection of 16 bit TIFF files: heavy, with a single 2000x2300 slice at 16bits per pixel weighing *9.2MB*, or as is often the case the data is saved as 3 channels, resulting in 27.6MB, and a whole 2400 slice scan weighing at least *22.1GB*. Scans are then windowed to 8 bit, occasionally with some form of compression, and the empty slices are removed: this generally halves or more the total data amount. This windowing process was documented as being unprincipled: the window was chosen based on the researchers best judgment, and the original uncompressed data discarded.


// Furthermore, certain researchers would then carry out a lossy compression of the data in the form of JPEG image slices, as was the case with the data used in this thesis: the total scan weights provided ranged from *0.103* to *13.2GB* (597x698x854 to 3000x3000x2653) and the original lossless data was not preserved, in both cases the windowing and the compression were motivated by data storage cost concerns.


// Finally, the provided data was generally given with little or no context: the data was provided in the form of a folder containing images as well as experiments that were run, with no associated dates and without grounding context such as the scan voxel size or parameters of the scanning machine. These issues of dataset size and compression resulted in challenges unforseen during the literature review which required particular attention.


// #linebreak()
// Methods exist to handle large datasets: the most basic approach is cutting down of full scans into smaller chunks, or subsampling the scans with some form of interpolation. Cutting scans down has the disadvantage of requiring stitching after running algorithms, and if done using 3D slicers' built in slicing, requires the ability to load the full dataset. Subsampling requires the the target structures to be large enough to allow it: subsampling to 1/4 resolution means that any vessel 4 voxels across would be reduced to approximately a single voxel.

// //An experiment was run, where a target scan was cut into 4 smaller sections using Python; this proved to be unwieldy for annotation and running the pipeline. 

// Handling large datasets can also be done at the format and loading level: HDF5 is intended to _store_ such large multidimensional arrays and efficiently enable loading subsections, however this data storage format is totally incompatible with most medical imaging software, and is not the standard used by CT machines. Standards such as DICOM did not provision for the possibility that data such as those generated by micro-CT may exist in the future in the medical domain, and do not deal well with dynamically loading large datasets from memory. To _operate on_ large multidimensional arrays in Python, there exist libraries such as #link("https://www.dask.org/")[Dask] that enable "chunking" of the data to process smaller areas: this could enable improved scaling to larger scans.

// #linebreak()
// These performance concerns highlight a continuous issue encountered during the writing of this thesis: the complexity of methods able to be tested was limited by the choice of software, volume of data and the hardware available. Lab computers available to students have 32GB of ram, less than the computer used for the testing and writing of code, and it was noted by previous students working on MicroCT imaging that they had struggled to run algorithms across the whole image. In the end, much effort was invested in the research, testing and optimization of the algorithms, and runtime concerns pushed development towards the use of methods implemented in C++ available with Python bindings, such as the SimpleITK Frangi filter used. 















// #v(0.5cm)
// #figure(
//   image("../../resources/misc/uncompressed_image_folder_sizes.png", width:90%),
//   caption: [TODO: This is a placeholder. TODO: Add horizontal lines for the RAM of computers. 
  
//   Visualization of the raw dataset sizes, obtained by multiplying width, height and depth by 8 bits per pixel],
// ) <uncompressed_dataset_size>
// #v(0.5cm)

// #v(0.5cm)
// #colorbox(
//   title: "Problem 6.",
//   color: (
//     fill: rgb("#f0f8ff"),
//     stroke: rgb("#00bfff"),
//     title: rgb("#002366")
//   ),
//   radius: 4pt,
//   width: auto
// )[
//   todo.
// ]






// Other suggested sources by Claude 28-04-2026
// Domain shift in medical imaging: Guan & Liu 2021 (IEEE TMI, "Domain adaptation for medical image analysis: A survey"), or Glocker et al. 2019 on cross-scanner / cross-protocol shift.
// Transfer learning in medical imaging: Raghu et al. 2019 (NeurIPS, "Transfusion: Understanding transfer learning for medical imaging") is the canonical critical reference; ImageNet pretraining for medical tasks is more nuanced than commonly assumed.
// Data augmentation: Shorten & Khoshgoftaar 2019 (Journal of Big Data, survey of image data augmentation) for the general framing; Isensee et al. (the nnU-Net paper, already cited) for the specific augmentations used in 3D medical segmentation.
// Synthetic vasculature beyond GANs: Schneider et al. 2012 (Medical Image Analysis, "Tissue metabolism driven arterial tree generation") and the VascuSynth tool (Hamarneh & Jassi 2010) are vascular-specific synthetic data references that would strengthen the L-systems sentence.