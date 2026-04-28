// Add papers: 

// Three-dimensional multi-scale line filter for segmentation and visualization of curvilinear structures in medical images https://www.sciencedirect.com/science/article/abs/pii/S1361841598800091
// skeletonization algorithm in scikit-image: Building Skeleton Models via 3-D Medial Surface Axis Thinning Algorithms https://www.sciencedirect.com/science/article/abs/pii/S104996528471042X

// Image Segmentation Using Deep Learning: A Survey https://arxiv.org/pdf/2001.05566


// TODO: add from https://forum.image.sc/t/comparison-of-some-tools-for-3d-dense-ground-truth-annotations/38918/39
// https://project-monai.github.io/
// https://home.webknossos.org/


#import "@preview/colorful-boxes:1.4.3": *
= State of the art

== Software in Research

=== Software Licenses 

Software licenses are closely linked with the monetary and scientific costs of use: they govern the terms of software use, modification, and redistribution and broadly fall into two categories: proprietary (closed source) and open source. Proprietary software restricts access to its source code and is generally distributed under a paid license, with certain exceptions such as with Dragonfly3D's FreED license. Open source software makes its source code publicly available and is as a result free of charge. Licenses enable the owner of the original software to control the distribution and use of extensions and modifications: Dragonfly3D does not explicitly allow sharing extensions #footnote["\[The user\] shall not distribute or transfer the Software or Improvements \[...\], without prior written permission \[from Dragonfly3D\]" @DragonflyFreeDLicense], unlike #link("https://slicer.readthedocs.io/en/latest/user_guide/about.html#license")[3DSlicer]

#linebreak()
Open source software matters in scientific research: being free removes a significant barrier to entry, and open-source is by nature extensible: prior work can be built upon by accessing, modifying and learning from its source code and development. Open-source licenses are diverse, from permissive such as MIT or BSD as used by 3D Slicer with modifications to protect from clinical use, and copyleft (GPLv3, used e.g. by Orthanc @orthanc_paper_jodogne), with implications for how downstream work must be redistributed.

=== Software for 3D analysis <sota_sw_for_3d>

To work on 3D CT scans researchers at the UCLouvain faculty IMMC (Institute of Mechanics, Materials, and Civil Engineering) use a variety of software to process the slice-by-slice data received from the imaging machines: closed source in the form of Avizo and CTan, "free-for-academics" with Dragonfly3D, and previously used open-source in the form of ImageJ. A full list of available solutions is visible in @3d_software. Standalone approaches exist, such as DeepVesselNet @tetteh2020deepvesselnet and SPROUT @sprout_segmentation_volumetric but do not come packaged as a software with user interface.

#linebreak()
For the purposes of this thesis, software was required to meet the following requirements: *(1)* Import a 3D scan from individual 2D slices in standard formats, *(2)* Export data to non-proprietary formats, and *(3)* Allow coded plugins/code extensions.

#linebreak()
With the goal of developing software for practical real world use, the following aspects were also weighed:
1. Availability of dedicated support forums & tutorial videos
2. Active development
3. Prior use by the lab researchers, and by researchers of the field more broadly.
4. Ease of installation and barrier to entry

The software in use at the laboratory for blood vessel segmentation (Avizo, Dragonfly3D) were tested and compared to open source alternatives 3D Slicer and ImageJ/FIJI. ImageJ and its distribution FIJI have a rich history in biological image analysis, having also been used in the past in the lab and on CT data. An extensive plugin ecosystem relevant for this work is available, such as the Frangi vesselness @imagej_frangi algorithm, but native support for vascular network extraction in 3D is limited. 3D Slicer @3Dslicer_paper emerged as the most suitable tool, due to its wide adoption in the medical field, existing plugin ecosystem with vascular specific tools such as The Vascular Modeling Toolkit @vmtk and R-Vessel-X @affane2025rvesselx. 

Beyond satisfying the core technical criteria of importing 3D scans as stacks of 2D slices, as well as import and export of open formats such as DICOM, 3D slicer also has extensive instructions and prior work in manual and semi-automatic segmentation. The Extension Manager is particularly relevant to this work, enabling non technical users to install the plugin without needing to code and free of charge, as opposed to the paid extensions for vascular extraction available for tools like Avizo and Dragonfly3D.

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
  In an extensive and diverse software landscape, our software must fit into an existing well documented segmentation tool: 3DSlicer, be easy to use: click only installation and offer compelling performance.
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

#linebreak()
Tumors also present a particularity in that they are frequently partially or entirely devoid of residual hemoglobin, preventing or reducing the action of CESAs and thereby reducing contrast and introducing discontinuities. Diffusion based contrast-enhacing agents also bring an additional disadvantage as seen in the data provided for this thesis: the diffusion of CE agents throughout the tissue happens from the outside in, resulting in a gradient of the amount of agent and as a result a gradient in contrast, as opposed to perfusion CESAs that follow the blood vessels. 

#v(0.5cm)
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
  The wide diversity of available modalities for 3D imaging and with their subtypes, the different machines and their acquisition parameters, variability in samples and their preparation, staining agents and methods, as well as large diversity of tissue types come together to present a challenge in creating a method that is re-usable, even within the same lab. Any method used for the segmentation of small blood vessels should be robust to the gradients caused by diffusion CECT, and able to handle variable contrast levels.
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

Beyond intensity-based methods, algorithms integrating local geometric priors exist such as Gabor filters or Hessian-based filters @SATO1998143 where the local second-order structure is analyzed to detect tubular shapes, characterized for vessel detection by Frangi's multiscale vessel enhancement filter @frangi_og_paper, improved in @beyond_frangi. These second-order methods utilize the eigenvalues of the Hessian matrix of local image intensities at multiple Gaussian scales to produce a vesselness score for each voxel, responding to tubular structures while suppressing circular and planar structures. The Frangi vesselness algorithm has been particularly influential in vessel segmentation tasks, as it explicitly models the prior of tubular geometry inherent in blood vessels. These methods offer greater robustness than simple thresholding but depend on the user fine tuning algorithm hyperparameters to optimize performance for a given domain or usecase when working with a tool as in @imagej_frangi. 

Additionally the filter's response degrades at vessel bifurcations, at the endpoints of vessels, and in regions of low contrast. In @beyond_frangi extensions to the vesselness formulation are proposed that improve responses at junctions and at low-contrast boundaries to increase robustness of the filter.

The aforementioned local methods fail to incorporate the overarching goal of vasculature extraction. A different class of methods reformulate extraction as a global optimization rather than a local filter response, such as minimal path methods which formulate vessel centerline extraction as an optimization problem. The path of least cost is taken between user-defined endpoints, with cost derived from vesselness or image intensity. In @minimal_path_tubular the geometry of vessels is incorporated, adding radius as an additional dimension of the path space. This class of methods is particularly well-suited to expert-in-the-loop approaches where small amounts of data need to be annotated: a user can place seed points that guide the extraction of a complete vascular tree, requiring no training data, and enabling iterative improvement. This method can be seen used for large arteries and airways available in tools such as the Vascular Modeling Toolkit (VMTK) @vmtk. This strength is also a weakness: the low scalability means that for a densely vascularized tissue, or a tissue with non-uniform characteristics, many seed points can be required which is impractical. Automatic seed point placement is a potential solution although introducing its own tradeoff, moving the optimization and work into the point placement. 


=== Data driven learning methods

// CNN era (U-Net, V-Net, 3D U-Net, nnU-Net)
// Vessel-specific architectures (DeepVesselNet, multi-task with centerline/bifurcation heads)
// Hybrid approaches do not exist (Frangi + U-Net, vesselness as input channel or auxiliary loss)
// Transformers and foundation models (SAM-style prompting)
// Problem: annotation cost; domain shift; architecture choice secondary to data availability.


Data-driven methods approach extraction from a different direction: rather than hand-engineering features and priors, parameters are learned from labeled examples. Supervised learning algorithms map labeled inputs to outputs with simple methods like k-nearest-neighbours use neighbour voting and more complex gradient-boosted trees combining weak learners @xgboost. With the paradigm deep learning exploding in popularity with @alexnet_og_deeplearning, higher dimensionality inputs became analyzable without hand crafted features, and led to fully convolutional encoder-decoder architectures being used in the medical domain such as with U-Net @unet_og_paper, a leap in performance for image segmentation. 

U-Net specifically constituted a breakthrough in medical imaging due to its ability to segment large images with high compute and data efficiency, and across multiple scales by introducing skip connections between encoder and decoder pathways. These allow the network to combine low-level spatial detail with high-level semantic context, enabling the segmentation of thin structures that require context such as cells and vasculature. The structure of U-Net can be extended into 3D with different approaches such as @3d_unet. Recently, transformer-based architectures have superseded convolutional networks as a more generalist approach to machine learning, being applied to object detection @detr_paper and being extended to segmentation @kirillov2023segment_SAM, offering higher performance thanks to a more general computation model. Expert crafted feature extraction is removed, such as in the locality prior of convolutions, enabling the capture of more diverse features and long-range spatial dependencies, at the cost of an increase in required training data.

#linebreak()
As algorithm complexity and data dimensionality increase, so must the amount of training or example data increase, an issue for convolutional networks and even more so for transformers. This limits the application of deep learning to Micro-CT data where annotated data is expensive and where inter dataset variance is large, even though attempts exist to palliate the high data requirements by offering self-configuring training frameworks with model weights @nnunet_paper or by crafting more data-efficient models. Examples also exist of trying to make use of so called foundation models, based on a large transformer and able to be "prompted" to customize the segmentation to the usecase at hand @SEMERARO2025102218. 

Deep learning has been applied to vascular segmentation for blood vessel extraction directly with notable success: DeepVesselNet @tetteh2020deepvesselnet introduced a family of architectures designed for vessel segmentation, centerline prediction, and bifurcation detection in 3D angiographic data by making explicit use of the structural priors inherent to blood vessels as secondary learning targets. 

Finally, hybrid approaches offer the interesting property of combining classical extraction methods with deep learning by leveraging input filters on the image to obtain richer features, such as applying vesselness maps to the image before processing, to integrate the priors of the vesselness filtering explicitly into the algorithm and reduce data needs @vesselness_maps_in_unets. This decouples the structural prior, encoded by the filter, from the learning, allowing the learning element to act as a correction or enhancement stage for the shortcomings of classical methods.


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
  Segmentation has evolved from classical methods encoding geometric priors explicitly toward data-driven methods that learn them implicitly, requiring annotated training data that is scarce and high variance for CECT micro-CT. Our pipeline should lean on classical methods that need no training data and expose their parameters to the user for adjustment.
]



==== Unreliability of ground truth

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
  title: "Problem 3.1",
  color: (
    fill: rgb("#f0f8ff"),
    stroke: rgb("#53d1fb"),
    title: rgb("#00369a")
  ),
  radius: 4pt,
  width: auto
)[
  Data from different datasets is not necessarily directly usable as a proxy without careful consideration. In domain data manually annotated for performance measurement, especially by a non domain expert, cannot be considered an absolute ground truth, and as a result errors calculated from these annotations should take into account this potential variability.
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

When training a model, or evaluating a method, it is important to be able to measure performance in a repeatable and objective way independent of human feedback. In binary classification, the error rate can be as simple as the proportion of correctly classified examples, however as dimensionality of outputs increases, so does the complexity of evaluation methods.

#linebreak()
Loss functions such as cross-entropy used for binary classification calculate the loss on a point-by-point basis, based on the predicted distribution. It can be used for segmentation @unet_og_paper, however vessel segmentation has a severe class-imbalance with vessels being a small minority of voxels. The choice of loss function matters as a result: Pixel-independent losses like cross-entropy treat each prediction as independent, meaning for our biased distribution there is a prior of predicting background and producing fragmented or incomplete vessel predictions. V-Net @vnet_paper extended U-Net into 3D and improved performance by using Dice loss, a method better suited for class-imbalanced settings.

For vasculature specifically, breaks in segmentation can be difficult to reconnect downstream, motivating the creation of custom loss function in @clDice_loss_func called clDice, that integrate the prior of connectedness, and build it into the loss function for predictions. In @CFLoss_loss_func clinically relevant vascular features are encoded into the loss function. Beyond loss functions, the evaluation itself can integrate vessel structure: graph-matching compares predicted and reference vascular trees at the level of branches and bifurcations rather than voxels, enabling metrics on the branch-level @VesselGraph. 

#linebreak()
When evaluating a segmentation method, consideration of the downstream analysis of its use to extract relevant features, such as tortuosity and branching ratio, is important to consider. As a result, and driven by the expert-in-the-loop approach, outputs will be evaluated based on point-wise loss of user annotated points, as well as on a manually annotated pixel level baseline. The challenging parameter of connectivity, difficult to capture in the loss, will be manually measured by selecting target areas and reported separately.

//In light of these considerations, and following the analytical needs of the laboratory researchers
// Graphs metrics are particularly relevant when the goal is biological interpretation rather than pixel-perfect overlap --> evaluate my method on this if time allows

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
)[
  Evaluation of a segmentation performance is a challenging topic, especially for vessels. Our method of evaluation must be based on data that is feasible for non-expert annotators to generate using existing 3D Slicer tooling, namely landmark placement, and be calculable in 3D Slicer. To enable downstream performance analysis, segmentations should exportable into a shared format, as well as being evaluated on relevant challenging scenarios.
]


=== Existing pipelines and tools 

// ITKTubeTK, VMTK, VesselKnife, SKAN, SimVascular, InVesalius. Frame as a landscape map: 
// classical-and-tunable vs. deep-and-rigid, integrated-into-research-tools vs. standalone

Several software tools and pipelines have been developed to support vascular segmentation and analysis workflows. ITKTubeTK @ITKTubeTK_paper_github offers a library of algorithms for tubular structure segmentation and graph extraction built on the ITK framework. The Vascular Modeling Toolkit (VMTK) @vmtk integrates in 3DSlicer and provides a user friendly comprehensive suite of tools for vascular segmentation and vascular extraction: centerline extraction and surface reconstruction. VesselKnife @vesselknife provides an integrated pipeline targeting vessel segmentation, skeletonization, and graph extraction from micro-CT data. For analysis, SKAN @skan provides a well documented Python library for the quantitative analysis of skeleton graphs extracted from binary segmentation masks, enabling computation of branch length distributions, tortuosity, and network connectivity. SimVascular @simvascular extends vascular extraction into simulation, enabling downstream modeling of blood flow within reconstructed vascular geometries.

#linebreak()
The landscape of vascular segmentation tools reflects a broader conflict throughout bio-informatics, medical informatics and bioimagery: general-purpose deep learning segmentation frameworks offer good performance on the datasets they are trained on, but require large annotated datasets and offer limited interpretability or controllability as well as are not baked into tools used by researchers. Classical model-based methods such as Frangi filtering are more transparent and adjustable, built into existing tools and easy to use, but require manual parameter tuning and struggle with complex vascular geometries. 


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
  Existing pipelines focus on large vascularization. Our software should fit into the niche of small vessel segmentation, where tools are not readily available or tailored to the unique challenges of micro vasculature.
]


// Other suggested sources by Claude 28-04-2026
// Domain shift in medical imaging: Guan & Liu 2021 (IEEE TMI, "Domain adaptation for medical image analysis: A survey"), or Glocker et al. 2019 on cross-scanner / cross-protocol shift.
// Transfer learning in medical imaging: Raghu et al. 2019 (NeurIPS, "Transfusion: Understanding transfer learning for medical imaging") is the canonical critical reference; ImageNet pretraining for medical tasks is more nuanced than commonly assumed.
// Data augmentation: Shorten & Khoshgoftaar 2019 (Journal of Big Data, survey of image data augmentation) for the general framing; Isensee et al. (the nnU-Net paper, already cited) for the specific augmentations used in 3D medical segmentation.
// Synthetic vasculature beyond GANs: Schneider et al. 2012 (Medical Image Analysis, "Tissue metabolism driven arterial tree generation") and the VascuSynth tool (Hamarneh & Jassi 2010) are vascular-specific synthetic data references that would strengthen the L-systems sentence.






// _*Problem 4.2.* Deep learning based segmentation methods that rely on a large corpus of images fit to the distribution on which they are trained, that suffer when the domain shifts due to changes in imaging methodology or sample variance, are not robust enough, nor transferrable enough to enable replicable work across multiple datasets. Any algorithm to extract blood vessels from tumors must contain user adjustable hyper parameters to enable fitting to the parameters of their data, as well as avoid the need for training data beyond a single test example._


// _*Problem 4.3.* Existing vascular segmentation pipelines are typically designed and validated for a single imaging modality, contrast strategy, or tissue type. The fragmentative nature of research means there exist few user friendly modular pipelines with adjustable parameters that can be adapted to the specific imaging characteristics of small tumor micro-CT (non uniform contrast agent diffusion, limited sample size, low contrast and tumor vessel specificities). Robust, reproducible vascular reconstruction usable for quantifying the vasculature network with an accuracy sufficient for clinical and research applications is thus out of reach for most lab work . A robust pipeline must expose interpretable parameters that allow adapation to the users specific imaging context, without requiring retraining as with common deep learning methods, or re-annotation._