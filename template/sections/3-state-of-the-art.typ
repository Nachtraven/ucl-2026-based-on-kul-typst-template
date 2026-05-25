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

// #linebreak()
// Open source software matters in scientific research: being free removes a significant barrier to entry, and open-source is by nature extensible: prior work can be built upon by accessing, modifying and learning from its source code and development. Open-source licenses are diverse, from permissive such as MIT or BSD as used by 3D Slicer with modifications to protect from clinical use, and copyleft (GPLv3, used e.g. by Orthanc @orthanc_paper_jodogne), with implications for how downstream work must be redistributed.

//ImageJ/FIJI has a long history in biological image analysis and a rich plugin ecosystem, including use for vessel extraction @imagej_frangi, but native support for vascular network extraction in 3D is limited, and the plugin development model is less suited to the integrated segmentation workflows this thesis requires.



//TODO:
// Maybe add: https://pdf.sciencedirectassets.com/273258/1-s2.0-S1742706120X00043/1-s2.0-S1742706120300532/main.pdf
// Exploring polyoxometalates as non-destructive staining agents for contrast-enhanced microfocus computed tomography of biological tissues


#import "@preview/colorful-boxes:1.4.3": *
#import "appendices/bipartite/illustrate_bipartite.typ" : matching-illustration
#import "appendices/DICE_overlap.typ": dice_diagram
#import "./appendices/gradient_graph.typ": chart

= State of the art

// == Software and Software licenses in Research
== Software for 3D analysis <sota_sw_for_3d>

// Software licensing is a deciding factor for a research plugin: tools may be free to use but restrict the redistribution of extensions, foreclosing the open-source release of derivative work. This is the case for Dragonfly3D's FreED license #footnote["\[The user\] shall not distribute or transfer the Software or Improvements \[...\], without prior written permission \[from Dragonfly3D\]" @DragonflyFreeDLicense].

// Software licenses are closely linked with the monetary and scientific costs of use: they don't only govern the terms of software use but also of modification, influencing the ability to build upon existing work. They broadly fall into two categories: proprietary (closed source) and open source. Proprietary software restricts access to its source code and is generally distributed under a paid license, with certain exceptions such as with Dragonfly3D's FreED license. Open source software makes its source code publicly available and is as a result free of charge. In a research context, the distinction matters beyond cost: open-source code is by nature extensible, with prior work directly inspectable and modifiable, while proprietary licenses can enable the owner of the original software to control the distribution and use of extensions: Dragonfly3D does not explicitly allow sharing extensions #footnote["\[The user\] shall not distribute or transfer the Software or Improvements \[...\], without prior written permission \[from Dragonfly3D\]" @DragonflyFreeDLicense]. 3D Slicer's license, by contrast, permits modification and redistribution #footnote[#link("https://slicer.readthedocs.io/en/latest/user_guide/about.html#license")[3D Slicer license page]]. Open-source licenses themselves vary in how they govern downstream use, from permissive (MIT, BSD) to copyleft (GPLv3), with implications for how derivative work must be redistributed.


// === Software for 3D analysis <sota_sw_for_3d>

// Researchers at the UCLouvain faculty IMMC (Institute of Mechanics, Materials, and Civil Engineering) use a variety of software to process 3D Micro-CT data: closed source in the form of Avizo and CTan, "free-for-academics" with Dragonfly3D, and previously certain open-source tools (ImageJ/FIJI). Many other alternatives exist, with those considered placed into a full list visible in @3d_software. Standalone approaches for analysis also exist: software that is more specific and intended for a use case such as for vessels with DeepVesselNet @tetteh2020deepvesselnet and SPROUT @sprout_segmentation_volumetric.

// #linebreak()
// A host software platform suitable for distribution of a microvascular extraction pipeline should *(1)* import 3D scans from standard slice formats, *(2)* export to non-proprietary formats for downstream analysis, and *(3)* support coded extensions that can be redistributed and modified. Some practical considerations were also taken into account: availability of dedicated support and documentation, active development, prior use within the lab and the broader research community, and ease of installation for non-technical users.

// Tools were compared for the practicality of implementing a plugin within its extension framework: Avizo and Dragonfly3D met the hard requirements but limit plugin redistribution as laid out previously. 3D Slicer @3Dslicer_paper emerged as the most suitable platform. It is open-source under a permissive BSD-style license, widely adopted in the medical imaging field, and supports 3D segmentation workflows with established plugins relevant to vascular analysis such as the Vascular Modeling Toolkit (VMTK) @vmtk and R-Vessel-X @affane2025rvesselx. Its Extension Manager allows non-technical users to install plugins through a one-click interface without compiling code or managing dependencies, and standard import/export formats including DICOM and NIfTI ensure interoperability with downstream analysis tools.



The choice of host platform shapes the extraction pipeline and who can use it. A host software platform suitable for distribution of a microvascular extraction pipeline should therefore *(1)* import 3D scans from open and standard slice formats, *(2)* export to non-proprietary formats for downstream analysis, and *(3)* support coded extensions that can be redistributed and modified. Platforms were evaluated against these criteria, with additionally the practical considerations of documentation, active development and ease of installation.

Candidate platforms used in the high resolution 3D analysis community are summarized in @3d_software, with UCLouvain's IMMC specifically using closed-source commercial tools: Avizo, Dragonfly3D and CTan. These offer limited extension development and redistribution, as well as requiring commercial paid licenses in the case of Avizo and CTan. Dragonfly3D presents the distinct advantage of currently having a "free-for-academics" _FreED_ license enabling widespread use in research, but brings with it a licensing challenge: despite being free to use, _FreED_ restricts the redistribution of extensions, preventing the open-source release of derivative work. #footnote["\[The user\] shall not distribute or transfer the Software or Improvements \[...\], without prior written permission \[from Dragonfly3D\]" @DragonflyFreeDLicense].

The lab has prior experience with the extensible and open-source ImageJ/FIJI, but it lacks the established 3D segmentation infrastructure for medical imaging. Standalone vessel-specific tools DeepVesselNet @tetteh2020deepvesselnet and SPROUT @sprout_segmentation_volumetric are not host platforms intended for extension but instead use case specific implementations. 3D Slicer @3Dslicer_paper emerged as the most suitable platform, meeting all three requirements: It can import and export a variety of formats, is open-source under a permissive BSD-style license, widely adopted in the medical imaging field, and supports 3D segmentation workflows with established plugins relevant to vascular analysis such as the Vascular Modeling Toolkit (VMTK) @vmtk and R-Vessel-X @affane2025rvesselx. Its Extension Manager allows non-technical users to install plugins through a one-click interface without compiling code or managing dependencies, and standard import/export formats including DICOM and binary segmentation ensure interoperability with downstream analysis tools.


// 3D Slicer was selected. It is open-source under a permissive BSD-style license, widely adopted in medical imaging, and offers an Extension Manager that lets non-technical users install plugins in one click without managing dependencies. Existing vascular analysis plugins (VMTK, R-Vessel-X) and standard format support (DICOM, NIfTI) ensure interoperability with downstream analysis tools.


#pagebreak()
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
)[Existing tools for 3D analysis are split between proprietary paid software, often restricting plugin redistribution, and open-source platforms, neither having bespoke microvascular support. The vasculature extraction pipeline must therefore build on an open-source host software for 3D analysis enabling redistribution: 3D Slicer.]



// Tissue samples are collected and imaged in order to gain an understanding of their structure and composition, called histology or histopathology in the case of diseased tissue. Classically this is done ex-vivo in 2D, with sections analyzed manually under a microscope by a human, the gold standard for tissue analysis @2d_histo_sota_balcaen2023revealing. However the technique has a fundamental limitation: information is not captured at the same granularity along all three axes. Methods exist to stack slices and reconstruct a 3D volume @methods_for_3d_histo_pichat2018survey, but axial resolution is limited by section thickness, and dead space between slices leaves regions where no information is acquired @litt_review_greet_debournonville2019contrast and the cutting process itself induces changes in tissue structure @extending2d_histo_to_3d.



// #linebreak() Old tissue imaging:
// When faced with complex data the paths for researchers are twofold: either _manual analysis_ of the data, or _utilization of algorithms_ to aid in the separation of their structures of interest. Manual annotation suffers from high subjectivity, strong variance between annotators @variability_in_annotations_xray_lin2023pluribus and requires time and expert annotators, meaning both direct use and use in machine learning present challenges. Additionally, annotation natively in 3D is challenging: it is difficult to properly consider all three axes simultaneously, hindering work on small 3D structures like vasculature. 

// When using algorithms for extraction, users are pulled towards user friendly and simple methods: (1) generalist methods such as thresholding, easily understandable and widely available, but performing poorly on data that cannot be separated by intensity alone, and (2) a wide spectrum of techniques that carry a richer prior or set of priors about the target structure, ranging from purpose developed algorithms to data driven ones as in deep learning. For vessel analysis, simple methods are easy to apply but result in discontinuities in blood vessels, artefacts, and don't generalize across samples, as well as require the selection of a fixed threshold per sample, a step not performed in a repeatable principled fashion, as learned from user interviews. 


#pagebreak()
== Tissue imaging

The process of imaging is a critical step in obtaining an understanding of a tissue in both clinical and research contexts. 2D histology is considered the gold standard having a long history @2d_histo_sota_balcaen2023revealing and producing high resolution images down to 5 μm for light based methods. The diversity in imaging techniques for 2D histology has rapidly increased in resolution, with electron microscopy able to reach in the order of sub nanometer scale @histology_used_for_cancers_he2012histology. The dimensionality of imaging has also evolved with computation enabling rapid progress in 3D methods using techniques like tomography, where multiple images are taken non-destructively of a target from different angles and assembled, being used in-vivo and ex-vivo with methods such as computed tomography (CT) and magnetic resonance (MRI).

#linebreak()
For the analysis of inherently 3D structures such as vascular networks, 2D histology is insufficient: Physical sectioning of the sample is destructive, is not orientation-agnostic, and introduces deformation artifacts that are difficult to compensate for even with embedding techniques @3dnondestructive_softtissue_µtomo, additionally samples may undergo structural changes over time during preparation: they dry out, and certain elements oxidize, although techniques exist to mitigate these disadvantages as explored in @litt_review_greet_debournonville2019contrast.

#linebreak()
To achieve 3D imaging from 2D histology, 2D slices are stacked across a virtual axis @extending2d_histo_to_3d. The resolution achievable when stacking 2D slices to reconstruct a virtual third dimension is limited by slice thickness and inter-slice registration errors. Certain optical techniques making use of slices allow partial recovery of 3D information from 2D acquisitions, such as confocal microscopy, light sheet microscopy, and optical coherence tomography @cryoct_maes2022cryogenic, they are limited in sample penetration depth and volume. When the target structure to be imaged and understood does not follow a single preferred axis, as is fundamentally the case for vascular networks and especially those of tumors, the limitations of slice-based histology make proper reliable quantification of blood vessel parameters impossible, and the relevance of 3D methods like MRI and CT clear. 


=== 3D imaging techniques for histology

Non-destructive 3D volumetric imaging methods overcome many of the limitations of 2D slice based histology by collecting data uniformly across dimensions, enabling virtual slicing across any plane without requiring physically sectioning the sample. Methods for 3D imaging range from the aforementioned microscopy using visible or near infrared light, to those like MRI that utilize magnetic fields or X-Ray imaging in the form of X-ray microfocus computed tomography (CT). These techniques allow the collection of qualitative and quantitative 3D microstructural data of tissues and their constituents: analysis is not restricted to a single orientation and does not require sample destruction. They also have associated high resolution variants allowing micrometer level imaging: Micro-MRI has an inherently high-contrast for soft-tissue and is able to reach 20 μm @Chen2018; Micro-CT is commonly used at 6µm, as in the data used in this document, and resolutions down to 1µm are possible as seen in @2d_histo_sota_balcaen2023revealing. Although Micro-CT suffers from low soft tissue contrast it still stands out as most relevant for ex-vivo tissue histology due to the high resolutions achievable, relevant at the scale of small animal models, and relatively short capture times when compared to MRI.


=== Contrast-enhanced micro-CT <CECT_technique>

To improve the contrast between soft-tissue in Micro-CT, two common approaches exist: changes to imaging methodology, and modifications to the sample. Imaging techniques such as phase-contrast Micro-CT (PC-CT) utilize the refractive properties of the X-rays rather than its absorption alone, enhancing soft tissue edge detection at the cost of higher complexity and long acquisition times. Tissue modifying techniques that aim to increase contrast include the use of various Contrast Enhancing agents (CESAs): Casting contrast agents (CCA) are perfused into vasculature but pressure must be controlled carefully @exvivo_cardioct, not applicable to our microvasculature due to the size of vessels to be observed. In CECT, contrast-enhancing agents diffuse through the tissue to reach the structures of interest, and bind to it. For the tumor vascularization studied in this thesis, ex-vivo tissue binding CESAs are used, namely Hafnium Wells-Dawson Polyoxometalates (Hf-WD POM) due to their nondestructive nature and low tissue shrinkage during incubation after excision. Techniques exist that can be used in combination with CESAs: contrast can be increased using freezing in Cryogenic contrast-enhanced micro-CT (cryo-CECT) which preserves tissue microstructure with reduced deformation @cryoct_maes2022cryogenic.

An additional issue arises in tumours in that they are frequently partially or entirely devoid of residual hemoglobin, preventing or reducing the action of CESAs and thereby reducing contrast and introducing discontinuities. Diffusion based contrast-enhancing agents also bring additional disadvantages as seen in the data provided for this thesis, visible in @fig:reliability_of_scans: the diffusion of CE agents throughout the tissue happens from the outside in, resulting in a gradient of the amount of agent and consequently a gradient in contrast, as opposed to perfusion CESAs that follow the blood vessels. Additionally, non-vessel-like structures such as hemorrhage or handling artifacts also generate high signal areas outside of vessels.


#v(0.2cm)
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
) <fig:reliability_of_scans>
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
)[The Micro-CT CECT data in this thesis presents a variety of challenges in the form of non-uniform contrast gradients, varying vessel contrast levels, disconnections and non vessel-like structures. The pipeline must therefore be robust to these elements and work on all dataset samples.]






// OLD: the purpose of imaging a tissue is to generate an image containing sufficient data to enable useful information to be extracted. This goal can be seen in the progress of imaging techniques: the improvements in the _acquisition process_ laid out in the previous section, to make the data of interest more salient (using agents to enhance the contrast) or to make the data more granular (increasing resolution). The _information extraction_ process has also seen improvements over time, with analysis evolving from human to computerized through different paradigms: classical thresholding and region growing; geometrically motivated filters and path-based methods; and data-driven learning approaches.

#pagebreak()
== Vascular Segmentation <imaging_and_seg>

The challenges introduced by micro-CT CECT shape what each paradigm of segmentation method can achieve. _Image acquisition_ and _information extraction_ have evolved together: contrast agents make structures more salient and increased resolution makes them more granular. Inforation extraction methods have progressed from manual inspection through the three paradigms of classical methods: thresholding and other histogram based methods, to hand crafted geometrically motivated filters and path-based methods, and finally data-driven learning approaches.

#linebreak()
Vasculature extraction from 3D tomographic data is a longstanding challenge in computer science, predating deep learning as reviewed in @LESAGE2009819. The 3D data of this thesis carries a unique set of challenges specific to modern high resolution CT: the vessel diversity ranges in the supplied data from singular voxels (~6µm) to tens of voxels (100+µm) across, corroborated in @microct_tumor_angio. The vasculature is diverse in shape and branching structure, with variable grey levels and most critically disconnections of variable size. Despite this, vessels share a distinctive and consistent set of geometric priors: they are tubular, connected, branching structures and contain blood, providing a distinct imaging profile against surrounding tissue when combined with a CESA. This geometry is what subsequent segmentation methods either _exploit explicitly_ through hand crafted classical filters or _learn implicitly_ in data-driven methods.


#v(0.5cm)
// Graph describing the different methods on an xy plane of data (x) and topological awareness (y):
// 0.4, 0.4, "Otsu", 
// 1.0, 1.5, "Region-growing", 
// 1.0, 4.95, "Frangi"
// 1.8, 6.0, "Minimal-path", 
// 8.0, 2.2, "U-Net / V-Net", 
// 6.0, 5.15, "Hybrid Frangi + U-Net", 
// 2.5, 7.8, "This work: Bootstrapped hybrid"
#include "./appendices/taxonomy_of_methods_graph.typ"
// caption: [*Vascular segmentation methods positioned by data need (x) and topological awareness (y)*. Orange arcs indicate the required level of user expertise: methods within the innermost arc require minimal expertise in either discipline (simple threshold selection), those within the middle arc require moderate familiarity (vessel specific parameter tuning), and those in the outer arc require significant expertise (combined vessel and annotation knowledge, and model training for the deep learning approaches). Classical methods cluster on the left with low data needs; data-driven methods cluster on the right. Our hybrid approach combines vesselness-based    topological awareness with limited user input while still requiring the ability to identify vessels, sitting in the low-data, high-topology quadrant, and with a reliatively higher vesselness expertise needed than classical techniques alone.],
#v(0.5cm)



=== Classical segmentation

// Intensity-based (Otsu, thresholding)
// Region-based (region growing, watershed)
// Problem: none encode vascular priors → fragmented, context-blind output.

==== Intensity-based methods

In its simplest form, intensity-based thresholding methods such as Otsu @OTSU_segmentation select an optimal global intensity threshold by maximizing inter-class variance across the image histogram. Such methods are computationally inexpensive and interpretable, but are sensitive to noise, imaging artifacts, and intensity inhomogeneities, as they optimize for a numerical goal. Gradient-based and global-threshold methods are a natural first approach to CECT data, since contrast agents are intended precisely to increase the salience of the structures of interest. However, methods that reason globally over the image can fail in practice due to diffusion gradients @CECT_technique and acquisition noise. 

Region-growing methods @region_growing extend thresholding by incorporating spatial connectivity: starting from one or more seed points, labeled regions are iteratively expanded according to local intensity criteria, such as in flood-fill, and generalized further by methods such as watershed @watershed_Soille_1991, which treats the image as a topographic surface. Incorporating this spatial connectivity prior makes them more robust to global intensity variation, but remain susceptible to over- or under-segmentation in complex structures: they fail to encode the more specific vascular priors, producing fragmented segmentations in the low-CESA, weak-signal regions characteristic of diffusion-CECT data.


==== Geometrically motivated methods

// Hessian/vesselness filters (Frangi, beyond-Frangi) — local geometric priors
// Minimal path / centerline tracking — global topological priors, expert-in-the-loop
// Skeletonization-first vs. segmentation-first pipelines
// Problem: hyperparameter-heavy, degrade at junctions, scale poorly to dense vasculature.
// Frangi detects ridges (peaks of curvature), not edges (peaks of gradient)!

Beyond intensity-based methods, algorithms integrating local geometric priors exist such as Gabor filters or Hessian-based filters @SATO1998143 where the local second-order structure is analyzed to detect tubular shapes, characterized for vessel detection by Frangi's multiscale vessel enhancement filter @frangi_og_paper, with extensions such as @beyond_frangi and many other methods being created since. Although many improvements to frangi exist, with a selection of 6 methods compared in @9833530, of those Frangi remains highly competitive, being shown to consistently offer the highest true positive to false positive rates. 

#linebreak()
These second-order methods utilize the eigenvalues of the Hessian matrix of local image intensities (capturing how rapidly intensity changes are themselves changing - the local curvature of the intensity surface) at multiple Gaussian scales (corresponding to multiple candidate "tube" sizes) to produce a vesselness score for each voxel, modeling the prior of blood vessels by responding to tubular structures while suppressing blob- and plate-like ones. Frangi and related methods offer greater robustness than simple thresholding but depend on the user fine tuning algorithm hyperparameters to optimize performance for a given domain or usecase when working with a tool as in @imagej_frangi. Additionally the filter's response degrades at vessel bifurcations, at the endpoints of vessels, and in regions of low contrast. In @beyond_frangi extensions to the vesselness formulation are proposed that improve responses at junctions and at low-contrast boundaries to increase robustness of the filter.

#v(0.5cm)
#include "./appendices/frangi_graph.typ"
#v(0.5cm)

Although offering high performance, second-order methods are limited to working on local image structure at multiple scales without accountig for global vessel topology, failing to incorporate the overarching goal of vasculature extraction. A different class of methods reformulate extraction as a global optimization rather than a local filter response, such as minimal path methods which formulate vessel centerline extraction as an optimization problem. The path of least cost is taken between user-defined endpoints, with cost derived from vesselness or image intensity. In @minimal_path_tubular the geometry of vessels is incorporated, adding radius as an additional dimension of the path space. This class of methods is particularly well-suited to expert-in-the-loop approaches where small amounts of data need to be annotated: a user can place seed points that guide the extraction of a complete vascular tree, requiring no training data, and enabling iterative improvement. This method can be seen used for large arteries and airways available in tools such as the Vascular Modeling Toolkit (VMTK) @vmtk. This strength is also a weakness: the low scalability means that for a densely vascularized tissue, or a tissue with non-uniform characteristics, many seed points can be required which is impractical. Automatic seed point placement is a potential solution although introducing its own tradeoff, moving the optimization and work into the point placement. 



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

An alternative to real annotated data is the use of simulated and automatically annotated data, using either geometrically driven techniques such as L-Systems, to generate branching tree structures grounded in the physiological laws of arterial branching, reviewed in @l-systems-review, or neural-network driven systems such as generative adversarial networks (GANs) as reviewed for medical applications in @GANs_medical. 

#linebreak()
When data is available it may be used directly, although models trained on one imaging protocol, contrast agent, sample batch, or tissue type exhibit degraded performance when applied to data from a different distribution: this is termed domain shift, and is particularly acute in imaging methods containing many adjustable parameters and machine hardware specificities like micro-CT imaging. This can require the use of techniques like transfer learning, where a model is first trained on a similar task with large data availability then fine-tuned on a small amount of in-domain data as detailed being used for vessels in @tetteh2020deepvesselnet. Annotated data can also be _augmented_ to artifically increase the available amount and diversity by applying random degradations, elastic deformations and intensity perturbation while preserving the original annotations. 

#colorbox(
  title: "Problem 3.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#53d1fb"),
    title: rgb("#00369a")
  ),
  radius: 4pt,
  width: auto
)[Data from different datasets is not necessarily directly usable as a proxy without careful consideration. In domain data manually annotated for performance measurement, especially by a non domain expert, cannot be considered an absolute ground truth. For the purpose of evaluating this work, data will be annotated in distribution, and errors calculated should take into account the potential variability from annotations.]



=== Data driven learning methods

// CNN era (U-Net, V-Net, 3D U-Net, nnU-Net)
// Vessel-specific architectures (DeepVesselNet, multi-task with centerline/bifurcation heads)
// Hybrid approaches (Frangi + U-Net, vesselness as input channel or auxiliary loss)
// Transformers and foundation models (SAM-style prompting)
// Problem: annotation cost; domain shift; architecture choice secondary to data availability.

//  @xgboost used to be cited for gradient-boosted trees
Data-driven methods approach extraction from a different direction: rather than hand-engineering features and priors, parameters are learned from labeled examples. Supervised learning algorithms map labeled inputs to outputs with classical machine-learning approaches such as kNN and gradient-boosted trees being used for voxel classification, but these do not scale to our data. With the paradigm deep learning exploding in popularity since being introduced in @alexnet_og_deeplearning, higher dimensionality inputs became analyzable without hand crafted features, and led to fully convolutional encoder-decoder architectures being used in the medical domain such as with U-Net @unet_og_paper, a leap in performance for image segmentation. 

U-Net specifically constituted a breakthrough in medical imaging due to its ability to segment large images with high compute and data efficiency, and across multiple scales by introducing skip connections between encoder and decoder pathways. These allow the network to combine low-level spatial detail with high-level semantic context, enabling the segmentation of thin structures that require context such as cells and vasculature. The structure of U-Net can be extended into 3D with different approaches such as @3d_unet. Recently, transformer-based architectures have superseded convolutional networks as a more generalist approach to machine learning, being applied to object detection @detr_paper and being extended to segmentation @kirillov2023segment_SAM, offering higher performance thanks to a more general computation model. Expert crafted feature extraction is removed, such as in the locality prior of convolutions, enabling the capture of more diverse features and long-range spatial dependencies, at the cost of an increase in required training data, an issue for Micro-CT.

#linebreak()
As algorithm complexity and data dimensionality increase, so must the amount of training or example data increase, an issue for convolutional networks and even more so for transformers. This limits the application of deep learning to Micro-CT data, where annotated data is expensive and where inter dataset variance is large, even though attempts exist to palliate the high data requirements by offering self-configuring training frameworks with model weights @nnunet_paper or by crafting more data-efficient models. Examples also exist of trying to make use of so called foundation models, based on a large transformer and able to be "prompted" to customize the segmentation to the usecase at hand @SEMERARO2025102218. 

Deep learning has been applied to vascular segmentation for blood vessel extraction directly with notable success: DeepVesselNet @tetteh2020deepvesselnet introduced a family of architectures designed for vessel segmentation, centerline prediction, and bifurcation detection in 3D angiographic data by integrating the structural priors inherent to blood vessels as secondary learning targets. 

#linebreak()
Finally, hybrid approaches offer the interesting property of combining classical extraction methods with deep learning by leveraging input filters on the image to obtain richer features, such as applying vesselness maps to the image before processing, to integrate the priors of the vesselness filtering explicitly into the algorithm and reduce data needs @vesselness_maps_in_unets. This decouples the structural prior, encoded by the filter, from the learning, allowing the learning element to act as a correction or enhancement stage for the shortcomings of classical methods. This use of classical priors as a feature stage with a form of learning as a correction sets the direction of the present work, with the novel addition of sparse user input as a method for achieving training data acquisition.

#v(0.5cm)
#colorbox(
  title: "Problem 4.",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#00bfff"),
    title: rgb("#002366")
  ),
  radius: 4pt,
  width: auto
)[Segmentation has branched from classical methods encoding geometric priors toward data-driven methods, requiring annotated training data that is difficult to acquire and high variance for CECT micro-CT. The work should need no training data while leveraging the user to provide simple annotations, and present minimal relevant and pre-tuned hyperparameters to enable portability across diverse data.]





// Voxel-wise losses and metrics (cross-entropy, Dice) and the imbalance problem
// Topology-aware losses (clDice, CFLoss)
// Graph matching: Topology-aware evaluation: graph matching between predicted and reference vascular trees, branch-level F1, connectivity metrics
// Point-wise evaluation against expert-placed landmarks (your chosen approach)
// Problem: loss ≠ downstream utility; pick metrics that reflect the analysis the vasculature feeds into.

// Vessel level metrics suggested by Claude 28-04-2026
// Drees et al. 2021 (Medical Image Analysis, "Scalable robust graph and feature extraction for arbitrary vessel networks in large volumetric datasets") — vessel-graph extraction and comparison.
// Stucki et al. 2023 or similar work on Betti-number errors and persistent-homology-based evaluation.
// VesselGraph (Paetzold et al. 2021, NeurIPS) — provides graph-level metrics for vessel segmentation evaluation.

=== Error calculation

Evaluating vascular segmentation is challenging because the metrics that are easy to compute and commonly used for segmentation do not reflect the failures that matter for downstream analysis. Three families of metrics are surveyed: voxel-level losses, topology-aware losses, and object-level matching, with each addressing a limitation of the previous.

Voxel-level metrics are commonly used for segmentation as in UNet @unet_og_paper. Vessel segmentation has a severe class-imbalance with vessels being a small minority of voxels, and as a result the choice of loss function matters: voxel-level losses like cross-entropy treat each prediction as independent, meaning there is a bias toward predicting background and producing fragmented or incomplete vessel predictions. V-Net @vnet_paper extended U-Net into 3D and improved performance by using DICE, a method better suited for class-imbalanced settings.

#v(0.25cm)
#figure(
  dice_diagram(),
  caption: [A major DICE challenge in the context of vessel segmentation, where many small vessels (orange) are present but detections (green) in one case totally fail to pick up on certain vessels. These situations would have a similar DICE score, showing the bias towards large overlapping regions, as discussed in @Taha2015.]
) <fig:dice-detection>
#v(0.35cm)

DICE has some specific known downsides for 3D medical image segmentation explored in @Taha2015 relevant here: the equal treatment of FP and FN, the unawareness of spatial differences with voxel differences being treated as equal between large an small vessels, and the detection gap where small completely undetected areas are treated the same as small mismatches in large coverage areas.

#linebreak()
To integrate some of these issues into the loss, in Yukun Zhou _et al._ @CFLoss_loss_func clinically relevant vascular features are encoded into the loss function. A collection of topology-aware loss functions is available in @topolosses, able to place emphasis on different topological features. For vasculature specifically, breaks in segmentation can be difficult to reconnect downstream and differences in size less important than the matching of the vessel itself, motivating the creation of a purpose built loss function in @clDice_loss_func called _centerlineDice_ (clDice). This metric places more phasis on vessel shape by skeletonizing the segmentations and computing overlap on the resulting centerlines, and can cleanly substitude Dice.


// Tprec(SP , VL) = |SP ∩ VL| / |SP |
// Tsens(SL, VP ) = |SL ∩ VP | / |SL|
#v(0.25cm)
#figure(
  grid(
    columns: (1fr, 1fr),
    rows: 2,
    column-gutter: 1em,
    row-gutter: 1.5em,
    align: horizon,
    [
      $ "Dice" = (2 "TP") / (2 "TP" + "FP" + "FN") $
    ],
    [
      $ "Dice"(A, B) = (2 |A inter B|) / (|A| + |B|) $
    ],
    [
      $ "Tprec"(S_P, V_L) = (|S_P inter V_L|) / (|S_P|) \
        "Tsens"(S_L, V_P) = (|S_L inter V_P|) / (|S_L|) $
    ],
    [
      $ "clDice" = 2 dot ("Tprec" dot "Tsens") / ("Tprec" + "Tsens") $
    ],
  ),
  caption: [*Top:* Dice for segmentation $A$ and $B$, in confusion-matrix form (left) and as set intersection (right). Dice is agnostic to true negatives (TN), avoiding their outsized weight in imbalanced settings. *Bottom:* clDice is computed in two steps: Topology precision ($"Tprec"$) and topology sensitivity ($"Tsens"$) to measure how much of the predicted skeleton $S_P$ lies inside the ground-truth mask $V_L$, and how much of the ground-truth skeleton $S_L$ lies inside the predicted mask $V_P$. clDice is their harmonic mean, similar to how standard Dice is the harmonic mean of precision and recall, enabling a simple drop in replacement.]
)
#v(0.25cm)


#linebreak()
Beyond loss functions, the evaluation itself can integrate vessel structure: graph-matching compares predicted and reference vascular trees at the level of branches and bifurcations rather than voxels, enabling metrics on the branch-level as explored for vessel level predictions in @VesselGraph. In panoptic segmentation @panoptic_seg_og, where the goal is to not only segment a structure but also individually identify it, graph inspired methods are used to calculate a score based on the matching between the ground truth and predictions on a per object basis, combatting the issue highlighted in @fig:dice-detection where missed vessels are not weighed appropriately. This comes at the cost of needing predictions to be individual objects, a problem for vessels that are _by nature_ continuous. To combat this, when comparing matching, our metrics will also account for size and allow one to many or many to one matches. Finally, on top of comparing predicted segmentations to a reference, the user placed seed points are also considered informative: if marked a voxel as vessel, the final segmentation should preserve that classification and provide feedback on these points.

==== Evaluation criteria
// OLD: When evaluating a segmentation method, consideration of the downstream analysis of its use to extract relevant features such as tortuosity and branching ratio, is important to consider. As a result, 
// Given that evaluation should reflect the downstream analyses the segmentation 

Following the analysis above, outputs will be evaluated based on three complementary criteria: *(1)* simple user placed annotation points during the _vessel_ and _background_ point placement step, *(2)* on a voxel level with connectivity aware clDice, measured on a manually annotated binary ground truth and *(3)* on a prediction to ground truth unitary matching between individual vessels to combat the biases of voxel based methods.

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
)[Evaluation of a segmentation performance requires integrating the structure of the problem. Our evaluation methodology should make use of topology-aware losses in the form of clDice when calculating voxel error rates, and per-vessel object-level matching to avoid voxel level bias.]


=== Existing pipelines and tools 

// ITKTubeTK, VMTK, VesselKnife, SKAN, SimVascular, InVesalius. Frame as a landscape map: 
// classical-and-tunable vs. deep-and-rigid, integrated-into-research-tools vs. standalone

Several existing tools target vascular segmentation, but few focus on microvasculature at high resolution within an integrated environment.Segmentation-focused tools operate on the image itself: the Vascular Modeling Toolkit (VMTK) @vmtk integrates in 3D Slicer and provides a comprehensive, user-friendly suite for vascular segmentation, centerline extraction, and surface reconstruction, but its methods are oriented toward low resolution, large vessels: arteries, aortas, and major branches. It also relies on seed-based interaction that does not scale to the dense, branching geometry of microvasculature. 

ITKTubeTK @ITKTubeTK_paper_github offers a library of algorithms for tubular-structure segmentation and graph extraction built on the ITK framework, but is packaged as a programming library meaning it requires implementation into a tool or use in code, challenging for non-technical researchers. VesselKnife @vesselknife provides an integrated pipeline specifically targeting vessel segmentation, skeletonization, and graph extraction from Micro-CT data but is a standalone application, requiring researchers to leave their existing analysis environment, and is not intended for small vasculature. Tools like SimVascular @simvascular operate on the outputs of segmentation and extend vascular extraction into simulation, supporting downstream modeling of blood flow, outside the scope of this work.

#linebreak()
The landscape of vascular segmentation tools reflects a tension in biomedical imaging: general-purpose deep learning segmentation frameworks offer good performance on the datasets they are trained on, but require large annotated datasets and offer limited interpretability or controllability as well as are not integrated into tools used by researchers. Classical model-based methods such as Frangi filtering are more transparent and adjustable, built into existing tools and easy to use, but require manual parameter tuning and struggle with complex vascular geometries. Neither pole serves the specific need addressed by this thesis: microvasculature-scale extraction, integrated into a widely-used segmentation environment, with parameters set by principled means rather than expert tuning. This combination is the niche the present work occupies.


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
)[Existing pipelines for vasculature extraction either target large vessels (VMTK) or require programming expertise to deploy (ITKTubeTK). Our solution should be tailored to the unique challenges of micro vasculature and integrated into 3D Slicer.] 



// Analysis-focused tools operate on segmentations as produced by  rather than images and are complementary to segmentation pipelines rather than competing with them. SKAN @skan provides a documented Python library for the quantitative analysis of skeleton graphs extracted from binary segmentation masks, enabling computation of branch-length distributions, tortuosity, and network connectivity. SimVascular @simvascular extends vascular extraction into simulation, supporting downstream modeling of blood flow within reconstructed geometries.




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