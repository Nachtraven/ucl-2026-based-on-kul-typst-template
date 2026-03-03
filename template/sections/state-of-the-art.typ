= State of the art

// TODO: Add SimVascular, InVesalius (https://invesalius.github.io/), ITKTubeTK, 

// Add papers: 

// Three-dimensional multi-scale line filter for segmentation and visualization of curvilinear structures in medical images https://www.sciencedirect.com/science/article/abs/pii/S1361841598800091
// Beyond Frangi: an improved multiscale vesselness filter https://www.researchgate.net/publication/283558933_Beyond_Frangi_An_improved_multiscale_vesselness_filter
// skeletonization algorithm in scikit-image: Building Skeleton Models via 3-D Medial Surface Axis Thinning Algorithms https://www.sciencedirect.com/science/article/abs/pii/S104996528471042X
// Angiogenesis, µCT: Novel multimodal MRI and MicroCT imaging approach to quantify angiogenesis and 3D vascular architecture of biomaterials https://www.nature.com/articles/s41598-019-55411-4
// Volumetric ML V-Net: Fully Convolutional Neural Networks for Volumetric Medical Image Segmentation https://ieeexplore.ieee.org/document/7785132
// Image Segmentation Using Deep Learning: A Survey https://arxiv.org/pdf/2001.05566
// Tubular Structure Segmentation Based on Minimal Path Method and Anisotropic Enhancement https://www.ceremade.dauphine.fr/~cohen/mypapers/FethIJCV10.pdf
// Relevant: SimVascular, InVesalius (https://invesalius.github.io/), ITKTubeTK,

== Software in Research

The kinds of software used in a research setting vary enormously by location, as well as in scope, purpose, availability, expense and licensing. At the UCLouvain faculty IMMC (Institute of Mechanics, Materials, and Civil Engineering), research is carried out on biological tissue samples using computed tomography techniques. During this research, a variety of software is used: both as explicit steps in the pipeline for tasks such as segmenting samples in 3D, using Avizo or Dragonfly3D, or implicitly as elements of the pipeline that lay before the steps done by researchers (software running on CT machines) or in the infrastructure, such as the OS used on computing devices.  

#linebreak()
The guiding principles of research dictate that Open, reproducible, and replicable practices are a fundamental part of science, it is common however that scientific research be carried out in part or fully using closed source or proprietary software, with licenses for certain pieces of software reaching into the multiple thousands, such as is the case for Avizo by Thermo Fisher Scientific. Other pieces of paid software are part of the infrastructure such as the operating system Windows used throughout the lab, acting as an implicit cost to replication. These software are occasionally available under a "free for research" liencese, such as FreeD offered by Dragonfly3D @dragonfly_freed_license, another piece of software used in the lab, discussed later. For most published research in biology, the relevant software to the research runs on top of a abstracted computational stack, and as a result we will focus on this "high level" software. 

=== Software Licenses 

Software licenses govern the terms under which a piece of software may be used, modified, and redistributed. They broadly fall into two categories: proprietary (closed source) and open source. Proprietary software restricts access to its source code and is generally distributed under a paid license, although exceptions exist in the form of freeware: proprietary software made available at no cost, such as Dragonfly3D's FreED license. Open source software makes its source code publicly available and is in the vast majority of cases also free of charge, though commercial open source models exist such as red hat linux. Within open source licenses, meaningful distinctions exist between permissive licenses (such as MIT or BSD), which place few restrictions on reuse, and copyleft licenses (such as the GPL family), which require that derivative works remain open source.

#linebreak()
Open source software plays a particularly important role in scientific research for two reasons: First, being free removes a significant barrier to entry: any researcher, regardless of institutional resources, can access, run, and reproduce a pipeline built on open source tools. This is a prerequisite for replicability, one of the foundational principles of science. Secondly open source software is extensible: prior work can be built upon by accessing, studying and modifying its source code. This capacity for incremental improvement mirrors the broader scientific process itself, where each work builds upon prior results. An example of this is Orthanc @orthanc_paper_jodogne, a medical image viewer whose architecture deliberately relies on pre-existing open components such as the Lua scripting language and standard networking protocols, enabling the community to extend its functionality without duplicating prior effort.

#linebreak()
The standard for open and free software at the OS level is Linux, a kernel, on top of which various distributions are built such as Ubuntu as used in this thesis, or one of a variety of over one thousand others @wikipedia_linux_distributions. On the OS is run the software that is used during the various stages of scientific work. Of these stages, relevant to this thesis are the software required to process the outputs of a MicroCT machine: software able to reconstruct the 3D representation of the imaged target from the collection of 2D slices provided by the CT machine.

=== Software for 3D analysis

The outputs, after reconstruction, of a CT scan are in the form of slice-by-slice files. These 2D slice outputs are then combined into a 3D representation by dedicated software, of which many exist. Drawing from Dragonfly3D's own comparative software list and a search for available tools, those relevant to this thesis can be divided along the same axis introduced in the previous section: commercial and open source or freeware. On the commercial side, the main options include (Bold indicating those actively used in the UCLouvain IMMC) #text(weight: "bold")[Dragonfly3D, Avizo, CTAn], Amira, Analyze and CTVol (by Bruker), Image Pro, Imaris, MeVisLab, Mimics, ScanIP, Octopus, VG Studio, Zeiss Inspect. On the open source and freeware side, the principal options are 3D Slicer, Chimera, Blender, Dream3D, Drishti, ImageJ, FIJI, IMOD, MeshLab, OsiriX, ParaView, SimVascular, VesselKnife and VisIt. 

#linebreak()
Additionally, more specialised and focused tools, made in a research context exist such as SPROUT and nnU-Net, the latter being a deep learning framework for medical image segmentation.
For the purposes of this thesis, candidate software was evaluated against a set of technical criteria, ordered by importance:
1. Import a 3D scan from individual 2D slices in standard formats such as TIFF, PNG, JPEG, BMP, or DICOM. 
2. Export data to non-proprietary formats to ensure data portability
3. Allow the development and implementation of plugins
4. Ability to (manually or automatically) segment parts of a scan, especially of blood vessels and availability of external tools specifically designed for vascular segmentation.

Due to the goal of developing software for practical real world use, the following aspects were also weighed:
1. Availability of dedicated support forums & tutorial videos
2. Active development
3. Prior use by the lab researchers, and by researchers of the field more broadly.
4. Ease of installation and barrier to entry

#linebreak()
Due to these criteria, especially the practical aspects, standalone software such as DeepVesselNet @tetteh2020deepvesselnet and SPROUT @sprout_segmentation_volumetric were discarded as candidates and focus was set to comparing the commercial tools actively in use in the laboratory for blood vessel segmentation (Avizo, Dragonfly3D) to open source alternatives 3D Slicer and ImageJ/FIJI. ImageJ and its distribution FIJI have a rich history in biological image analysis with an extensive plugin ecosystem relevant for this work, such as the Frangi vesselness @imagej_frangi algorithm, but their handling of large 3D volumes and native support for vascular network extraction is limited. 3D Slicer emerged as the most suitable tool for this thesis, due to its pre-existing plugin intended specifically for advanced vessel segmentation: The Vascular Modeling Toolkit @vmtk Beyond satisfying the core technical criteria of importing 3D scans as stacks of 2D slices, as well as import and export of open formats such as DICOM, 3D slicer also has extensive instructions and prior work in manual and semi-automatic segmentation. The Extension Manager is particularly relevant to this work: the proprietary pieces of software studied also had available plugins/extensions, however these are usually expensive. For 3D Slicer, the VMTK (the Vascular Modelling Toolkit) mentioned above, with its open code enabling modification, enables working on an existing proven basis. The recent project R-Vessel-X @affane2025rvesselx: especially developed for the segmentation of blood vessel trees from medical images, was also retained as relevant. 

#linebreak()
The combination of a stable, widely adopted platform with active community support and specialised vascular tooling makes 3D Slicer the most appropriate choice for extracting and analysing the vasculature from CECT µCT data in a reproducible and extensible manner.

#linebreak()
_*Problem 1.* In an extensive and diverse software landscape, users stick to what is familiar and easy to use, regardless of the impact on scientific rigor. Our software must thus be based on an open platform: 3DSlicer, be easy to use: click only installation and use, and have ample, clear documentation._


// -----------------------------------------

// TO ADD: EXCEPTIONALLY RELEVANT: https://pdf.sciencedirectassets.com/273258/1-s2.0-S1742706120X00043/1-s2.0-S1742706120300532/main.pdf
// Exploring polyoxometalates as non-destructive staining agents for contrast-enhanced microfocus computed tomography of biological tissues
#pagebreak()
== Tissue imaging

Tissue imaging is a critical step in both clinical and research contexts, where it is used to acquire a better understanding of the organism being examined than is possible with indirect measurements. Tissue imaging methods can be characterized by multiple factors, of relevance in this document: dimensionality (1D, 2D, 3D, 4D) and invasiveness (ex-vivo / in-vivo). Ex-vivo imaging requires the removal (and generally destruction or alteration) of the tissue to be imaged, whereas in-vivo can be done in a live organism, offering the distinct advantage of being able to measure the same tissue at multiple points in time.

#linebreak()
Tissue imaging enables the extraction of parameters that are qualitative  and/or quantitative: in clinical and research settings, it is common to extract simple qualitative measurements, such as a difference in size, due to it both being easier and quantification not being required. However, for tasks such as comparing the impact of a drug on a structure, quantification becomes relevant: Understanding the three-dimensional structure of biological tissue is a prerequisite for the analysis of structure-altering drugs such as Pazopanib, where changes in tumor vascularization are inherently spatial and quantifiable across multiple parameters. Classical 2D histology remains the gold standard for analysis of biological tissues, valued for its high discriminative power, the wide range of available stains, and its compatibility with immunohistochemistry @litt_review_greet_debournonville2019contrast. Despite this, it suffers from fundamental limitations when the target of analysis is a spatially complex 3D structure. Physical sectioning of the sample is destructive, is not orientation-agnostic, and introduces deformation artifacts that are difficult to compensate even with embedding techniques @3dnondestructive_softtissue_µtomo (Here could use a greet source?). Samples undergo structural changes over time during preparation: they dry out, and certain elements oxydize, although techniques exist to mitigate this @litt_review_greet_debournonville2019contrast.


#linebreak()
To achieve 3D imaging from 2D histology, 2D slices are stacked across a virtual axis @extending2d_histo_to_3d. The resolution achievable when stacking 2D slices to reconstruct a virtual third dimension is limited by slice thickness and inter-slice registration errors. Certain optical techniques making use of slices allow partial recovery of 3D information from 2D acquisitions, such as confocal microscopy, light sheet microscopy, and optical coherence tomography @cryoct_maes2022cryogenic (is it good to reference a secondary source like this?), they are limited in sample penetration depth and volume. When the target structure to be imaged and understood does not follow a single preferred axis, as is fundamentally the case for vascular networks and especially those of tumors, the limitations of slice-based histology make proper reliable quantification of blood vessel parameters impossible.


=== 3D imaging techniques for histology

Non-destructive 3D volumetric imaging methods overcome many of the limitations of 2D slice based histology by collecting data uniformly across dimensions, enabling virtual slicing across any plane without requiring physically sectioning the sample. Techniques for 3D imaging range from the aformentioned microscopy techniques using visible or near infrared light, to techniques utilizing magnetic fields such as magnetic resonnance imaging (MRI) or X-Ray imaging in the form of X-ray microfocus computed tomography (CT). These digital techniques allows qualitative and quantitative 3D microstructural analysis of tissues and of their constituents: analysis is not restricted to a single orientation and does nott require sample destruction. They also have associated high resolution variants more commonly used for research, allowing micrometer level imaging: µMRI and µCT, with µCT reaching higher resolutions (smaller voxel sizes). These techniques are the most relevant for ex-vivo tissue histology at the scale of small animal models. µMRI provides fully resolved 3D images non-invasively and non-destructively, and has an inherently high-contrast for soft tissues, though resolution is limited to the range of tens of micrometers. MicroCT reaches higher resolutions, but suffers from low contrast when imaging soft tissue, when extra technques are not used. *(Source this part on Greet work)*

=== Contrast-enhanced µCT

As mentionned, standard X-ray microfocus computed tomography (microCT) suffers from low contrast between soft tissues making the visualization of blood vessels difficult. To improve contrast, imaging techniques exist such as phase-contrast microCT (PC-CT), which encodes contrast through differences in the phase shift of the X-ray beam rather than its absorption alone, enhancing soft tissue edge detection at the cost of requiring a complex imaging machine *Source*. Alternatives to imaging technique changes are techniques that modify the target tissue to increase contrast, such as the use of various Contrast Enhancing agents termed CECT, having some distinct disadvantages *List the disadvantages of CE*. Contrast can also be increased using the novel Cryogenic contrast-enhanced microCT (cryo-CECT) which preserves tissue microstructure with reduced deformation @cryoct_maes2022cryogenic. 

=== Contrast-enhanced µCT (CECT) for vascular imaging

The most practical method enabling the collection of multiple scans of different tissues, in our case tumors, is the use of contrast-enhancing staining agents (CESAs). Contrast-enhanced computed tomography (CECT) is particularly favored for its ability to simultaneously visualize soft and mineralized tissue types through the use of contrast agents, making it suitable for laboratory-based microCT devices. CECT is of particular relevance for imaging vascular networks because of the ability to inject the CE agent into the vasculature. In tumors, the microvasculature present a challenge though: small blood vessels are frequently partially or entirely devoid of residual hemoglobin, preventing or reducing the action of CESAs and thereby reducing contrast. 

#linebreak()
Diffusion based contrast-enhacing agents add an extra dimension of complexity when used for imaging: the diffusion of CE agents throughout the tissue happens from the outside in, resulting in a gradient of the amount of CESA and as a result a gradient in contrast, as opposed to perfusion CESAs that follow the blood vessels. CESA via perfusion is an option for vasculature that is larger in scale and more resistant to the pressure change of perfusion, but due to the nature of the microscopic vessels in the tumors being imaged, such methods are innappropriate. @exvivo_cardioct

// "Too-high pressures can lead to tissue damage, whereas too-low pressures might result in incomplete filling of the desired vessels. Viscosity is also an important factor to consider for reaching the smaller capillaries and for keeping the perfusion pressure low" from @exvivo_cardioct

#linebreak()
_*Problem 2.* The the wide diversity of available modalities for 3D imaging: µMRI and µCT, with their subtypes: cryo-CECT, phase-contrast CT, Contrast-Enhanced CT, the different machines and their acquisition parameters, variability in samples and their preparation: fixation methods, staining agents and methods, staining duration, tissue types, means that the challege of creating a method that is re-usable, even across different tissues within the same lab, is huge. Any method used for the segmentation of small blood vessels should be robust to the gradients caused by diffusion CECT, and able to handle variable contrast levels._


// -----------------------------------------

// With the goal of reconstructing vascularization in imaged tissue, we aim to take in data from an imaging modality, process it through a software pipeline, and obtain at output a data structure with higher information density than the input. This process of reducing the amount of raw data, but increasing the utility or information content of the data, is explored widely in the field of computer science. It underlies concepts such model fitting to noisy data [5.2] or as more commonly carried out in a biological context and industry, image segmentation, where the goal is to separate regions of a 2D image into multiple segments and objects [5.3].

// Image segmentation plays a central role in accelerating, standardizing medical image analysis by enabling quantitative analysis of different kinds: by classifying pixels with semantic labels (semantic segmentation), partitioning of objects (instance segmentation) or a combination of both across the entire image space (panoptic segmentation) [5.1]. The task can be as simple and as old as separating objects from a background, a problem that has been explored in computer science for multiple decades @OTSU_segmentation, or more complex as in panoptic segmentation, only being posed in 2018 @panoptic_seg_og. In the context of volumetric biological imaging, segmentation extends naturally into three dimensions, where voxel-wise labeling must account for spatial continuity across image slices and the complex, branching topology of structures such as blood vessel networks.

// 5.1 Image Segmentation Using Deep Learning: A Survey
// 5.2 RANSAC https://doi.org/10.1145/358669.358692
// 5.3 FIRST EDITION! Computer Vision: Algorithms and Applications. Berlin, Germany



// Here I want to talk about priors: we used to want to encode the human expertise with expert models and a lot of parameters to tune, then we started to have FCNs which were difficult to train, we moved on the CNNs which worked with the tech we had due to being more data efficient by having the locality prior of the convolution, then we moved to transformers that removed that prior, enabled longer range dependencies and modeled the compression decompression process more explicitly, however requiring lots of data.

#pagebreak()
== Information extraction from images

The purpose of imaging a tissue is to generate a fixed, deterministic representation at a given point in time. After imaging, information is obtained from the data using one of a variety of processing methods. Classically, this information extraction was carried out by trained professonals: for medical image analysis, an expert in cancerous tissues is capable of identifying and evaluating qualitative and quantitative metrics for a given sample. This process of information extraction can be seen as a form of data compression: only the relevant conclusions from the image are kept and represented in multiple fashions: a simple aggregated conclusion of the form "cancer" or "no cancer", a classification of areas in the image into a certain class or type, or at a higher level, the reconstruction of a structured output, such as a network or skeleton, as is seen in machine learning based pose estimation from camera images (Source this). Computers lend themselves well to information extraction and processing, especially compression. Different techniques or algorithms exist to extract information of interest from an image, ranging from simple classical methods such as the OTSU method for edge detection @OTSU_segmentation to more computationally expensive, complex and inscrutable deep learning. Deep learning algorithms are known to act as a form of information compression algorithm @ml_is_compression, starting from a data source with many individual data points, such as an image, and ending with as little as a single output @alexnet_og_deeplearning.


=== Methods of Segmentation

Image segmentation methods span a wide spectrum of complexity, from classical signal processing approaches to modern deep learning architectures, and vary in output format from pixel wise annotation and single class prediction to higher-order structural extraction methods that reason about the topology of extracted objects, such as skeletonization.

#linebreak()
At the simplest end, intensity-based thresholding methods such as Otsu's method @OTSU_segmentation operate by iteratively finding an optimal intensity threshold that separates foreground from background by minimizing intra-class variance. Such methods are computationally inexpensive and interpretable, but are sensitive to noise, imaging artifacts, and intensity inhomogeneities. This is particularly problematic in the context of µCT imaging, where algorithms that reason globally over an entire image can fail due to gradients across the image from phenomena such as beam hardening, or as mentioned previously when contrast enhancing agents are used, the diffusion gradient. Region-growing and watershed algorithms extend this idea by incorporating spatial connectivity, iteratively expanding labeled regions from seed points according to local intensity gradients, making them more robust to global intensity variation, however remaining susceptible to over- or under-segmentation in complex structures and discontinuities due to not integrating the connectivity prior of a blood vessel.

#linebreak()
Classical machine learning approaches introduced feature engineering as an intermediate step: handcrafted descriptors such as Gabor filters, Hessian-based vesselness filters or particularly relevant: Frangi's multiscale vessel enhancement filter @frangi_og_paper. Frangi's vesselness measure is _derived from the eigenvalues of the Hessian matrix of image intensities at multiple scales_, has been particularly influential in vessel segmentation tasks, as it explicitly models the prior of tubular geometry inherent in blood vessels. These methods offer greater robustness than simple thresholding but depend heavily on the quality of the engineered features, requiring much intervention to achieve good performance, and as a result of this feature engineering, fail to generalize across imaging conditions. (*Source for lots of work to get frangi good*)


=== Machine learning in biology

==== Forms of Machine Learning
#linebreak()
Deep learning methods, and in particular the paradigm of fully convolutional encoder-decoder architectures such as U-Net @unet_og_paper, represented a major revolution in image segmentation and dominated benchmarks, with as many as (REFIND THE SOURCE SPEAKING OF 8/10 LEADERS BEING UNET). U-Net presneted a breakthrough in imaging due to its ability to do segmentation on large images, with high compute and data efficiency, and across multiple scales by introducing skip connections between encoder and decoder pathways, allowing the network to combine low-level spatial detail with high-level semantic context. This enabled the segmentation of thin structures that require context, such as cells and as relevant here, capillaries. However as mentioned previously, 2D imaging and by extension 2D segmentation present limitations for blood vessels; variants of U-Net extending into the third dimension exist to palliate this, such as 3D U-Net @3d_unet. 

#linebreak()
Transformer-based architectures have come to the forefront of predictive performance by their more general computation model: they remove the locality prior of convolutions, and thereby have the ability to model long-range spatial dependencies. Transformers function as learned compression functions where the encoder progressively distills the input volume into a compact latent representation encoding the most task-relevant features, which the decoder then maps back into a dense prediction @ml_is_compression. Due to their more general structure lacking the prior of locality, they require more data to train than convolutional networks: complicating their use in medical imaging due to the associated costs and barriers to data collection.


==== Classification techniques

The two most well known forms of machine learning applied to medical images are classification and segmentation. Classification is the process of outputing a single unified class given an input piece of data, such as classifying an x-ray of a bone as "broken" or "not broken". Its simplicity and ease of collecting training data means classification models formed the first widely used machine learning models (*Source this*). Segmentation plays a central role in accelerating and standardizing medical image analysis by enabling quantitative analysis of different kinds: by classifying pixels with semantic labels (semantic segmentation), partitioning of objects (instance segmentation) or a combination of both across the entire image space (panoptic segmentation) @panoptic_seg_og. In the context of volumetric biological imaging, segmentation extends naturally into three dimensions, with the paradigm of convolutional neural networks naturally extending into the third dimension by making use of 3D convolutions in the place of 2D.

#linebreak()
Beyond classification and pixel or voxel-wise labeling, methods exist that aim to extract higher-order structural constructs. For tree and network-like structures such as vascular networks, skeletonization algorithms abstract a binary segmentation mask to a centerline representation that preserves the branching topology of the original structure (*Source: structural skelentonization/thinning*). In order to have centerline extraction be an output of a deep learning model, it can be formulated directly as an optimization problem. Optimizing using minimal path methods or tubular graph-tracing approaches that track vessel centerlines through the image volume without requiring a complete prior segmentation (*Source: path vessel tracing*). At the highest level of abstraction, graph-based representations encode the vascular network as a set of nodes (bifurcation points and endpoints) connected by edges (vessel segments), each annotated with attributes such as radius, length, and tortuosity. Abstract representations offer the highest quality downstream quantitative analysisincluding branching order, fractal dimension, or inter-vessel spacing, impossible to derive from a raw segmentation mask alone (*Source: vessel graphs*), as well as enable simulations with tools such as (*Source: vasculature simulator*), 


===== Structural extraction

Moving between levels of representation modifies the balance between information fidelity, robustness to segmentation errors, and the specificity of the downstream analysis task. Segmentation masks carry spatial information in the image frame while being difficult to analyze quantitatively, limiting to the use of lower order metrics such as volume. Graphs on the other hand are the richest representations quantitiatively, enabling the extraction of volume as well as self reflexive parameters such as tortuosity. Generally pipelines chain these representations sequentially due to simplicity and scrutability: it is easier to collect and annotate data in image space than in graph space, and graph space data does not necessarily translate perfectly back to image space. A segmentation model outputs a binary mask (e.g. vessel/background) followed by a skeletonization algorithm that extracts a centerline, and a graph construction step annotates the resulting topology. (* Source here on navigating the abstraction levels *)

#linebreak()
Sequential pipelines have the weakness that errors can propagate and compound across each stage, and can result in more fragile pipelines, sensitive to noise or changes in domain. Disconnections in the segmentation mask can produce disconnected graphs if the algorithm does not account for this possibility, and if proper care has not been given to provide hyperparameters that enable tuning, or the ability to modify the code used at the different steps, the pipeline becomes unusable. This motivates approaches that integrate structural priors directly into the segmentation model, or that formulate centerline extraction as a joint optimization rather than a post-processing step (*Problem 3.1*).
(* Source here on the shortcomings of skeletonization and their brittleness / lack of robustness*)

=== Imaging and Segmentation of vasculature

// SOTA vasculature seg:
// 2010 Tubular Structure Segmentation Based on Minimal Path Method and Anisotropic Enhancement
// 2020 Cardiac multi-scale investigation of the right and left ventricle ex vivo: a review
// 2018 A Survey of Methods for 3D Histology Reconstruction

// Vasc & µCT
// Optimization of MicroCT Imaging and Blood Vessel Diameter Quantitation of Preclinical Specimen Vasculature with Radiopaque Polymer Injection Medium

// ML
// 2018 ML DeepVesselNet: Vessel Segmentation, Centerline Prediction, and Bifurcation Detection in 3-D Angiographic Volumes

// Tools
// The Vascular Modeling Toolkit
// SKAN skeleton-analysis
// ImageJ/builtin tools for it: https://imagej.net/plugins/frangi
// Vesselknife - very relevant especially for the pipeline construction https://gitlab.com/vesselknife/vesselknife


// For cancers/tumors/small vasc
// 2003 Three-Dimensional Reconstruction of Extravascular Matrix Patterns and Blood Vessels in Human Uveal Melanoma Tissue: Techniques and Preliminary Findings
// 2023 on the variability of annot: E pluribus unum: prospective acceptability benchmarking from the Contouring Collaborative for Consensus in Radiation Oncology crowdsourced initiative for multiobserver segmentation

The segmentation and reconstruction of vascular networks from 3D data is a long-standing and active problem in medical image analysis across multiple tissue types, organisms and even taxa (*Here trying to say it's animals, plants etc*), with applications ranging from brain imaging @murine_brain_cect to oncology, as discussed here. Blood vessels present a distinctive and consistent set of geometric priors despite their diversity: they are tubular, connected, branching structures and contain blood which can provide a different imaging profile to surrounding tissue. The challenge of their size, spatial spread and contrast is compounded in the context of tumor microvasculature due to the small size of the murine tumors collected, and blood vessel sizes reaching the lower limits of µCT resolution (*Source on blood vessel sizes from Wlodarski*). Vessels are also poorly contrasted as a result of this sizing.

/*@beam_hardening_uct.*/

#linebreak()
The first line of approaches to separating vesssels from surrounding tissue in the context of CECT imaging is that of threshold segmentation: due to the presence of a contrast agent, the vasculature network of interest is able to be mostly segmented using only a process involving defining all voxels within a certain intensity range as vessels. This is a form of extraction in the imaging space, providing no structural information, although in situations with high contrast and well connected networks, can approximate a higher order extraction. (*Source this?*).

#linebreak()
The dominant classical algorithms developped for vessel extraction are based around the prior of tubeness, and expanded upon by the Frangi vesselness filter @frangi_og_paper, and more recently improved in @beyond_frangi. By analyzing the eigenvalues of the Hessian matrix of local image intensities at multiple Gaussian scales, a vesselness score is produced for each voxel that responds to tubular structures while suppressing circular and planar structures. The Frangi filter is popular enough to have earned an implementation in ImageJ @imagej_frangi. However, the filter's response degrades at vessel bifurcations, at the endpoints of vessels, and in regions of low contrast, and it has many hyper parameters that require manual tuning. @beyond_frangi proposed extensions to the vesselness formulation that improve responses at junctions and at low contrast boundaries to improve robustness of the filter.

#linebreak()
Beyond filter-based mathematically driven approaches that work on small image localities lay methods relying on optimization: minimal path methods formulate vessel centerline extraction as an optimization problem. The path of least cost is taken between user-defined endpoints, with cost derived from vesselness or image intensity. @minimal_path_tubular incorporate the geometry of vessels adding radius as an additional dimension of the path space. This class of methods is particularly well-suited to expert-in-the-loop approaches where small amounts of data need to be annotated: a user can place seed points that guide the extraction of a complete vascular tree, requiring no training data, and enabling iterative improvement. This strength is also a weakness: the low scalability means that for a densely vascularized tumor, or a tumor with non uniform characteristics, many seed points can be required wich is impractical. Automatic seed point placement remains an open problem.

// ^ Human in the loop

#linebreak()
_*Problem 3.1.* Current methods for segmentation often ignore the structural priors that underly the data generation process. An effective, robust and transferrable method for blood vessel segmentation must thus encode the relevant structural priors, namely connectedness, shape, and branching structure_

#linebreak()
_*Problem 3.2.* Deep learning based segmentation methods that rely on a large corpus of images fit to the distribution on which they are trained, that suffer when the domain shifts due to changes in imaging methodology or sample variance, are not robust enough, nor transferrable enough to enable replicable work across multiple datasets. Any algorithm to extract blood vessels from tumors must contain user adjustable hyper parameters to enable fitting to the parameters of their data, as well as avoid the need for training data beyond a single test example._




// In the state of the art, you indicate what has been studied, why it has been studied, and, in general terms, how it has been studied. This section contains:
// ✓ The background of the study (= context);
// ✓ Research that has been done in the frame of your thesis topic;
// ✓ Information that is needed for the reader to understand your topic and the remaining scientific issues/problems.
// ➔ Make a fluent story of it, and not just a sum up of different papers or references.

// ➔ The context (per paragraph or section) usually ends with a conclusion or problem statement that sets the scene for your specific research questions and project aim + objectives




// -----------------------------------------------------------

// The contrast agents of relevance for this paper are inteded for use ex-vivo, specifically binding to  

// Two broad classes of contrast agents are used in this context. Casting contrast agents (CCAs) - such as Microfil or barium sulfate suspensions - are perfused through the vasculature prior to excision, physically filling the vessel lumen with a radio-opaque material that polymerizes in place. These contrast agents are pigmented or radiopaque casting materials injected throughout the animal for vascular visualization in situ, often through transcardiac perfusion procedures. While effective, the use of these vascular casting contrast agents results in terminal studies. Additionally, due to the higher viscosity and non-miscible nature of compounds such as Microfil, higher pressures are required to achieve uniform vascular filling, resulting in vessel bulging or even rupture. Tissue-binding CESAs, by contrast, are applied ex-vivo by incubation after excision, enriching the X-ray attenuating atom content in specific tissue compartments through chemical interactions rather than physical filling. Care must be taken that both the CA staining protocol and the image acquisition setup do not hamper the non-destructive character of the methodology, and compatibility with subsequent biochemical assays should be considered.

// A key and widely discussed challenge with both classes of contrast agents is the uniformity of their distribution throughout the sample. For diffusible contrast agents, higher standard deviation values in image intensity within a tumor can be due to defective perfusion of tumor tissues - well-perfused tumors will be uniformly enhanced, resulting in smaller variance, while poorly vascularized regions may show heterogeneous or absent contrast uptake. In the context of tumor vasculature specifically, this is compounded by the intrinsically abnormal architecture of tumor-associated vessels: rapid angiogenesis within a tumor leads to the development of immature, poorly organized, leaky vasculature, which affects both the perfusion of casting agents and the diffusion kinetics of tissue-binding CESAs. For ex-vivo samples where vascular perfusion is no longer active, passive diffusion of the CE agent from the sample surface is the primary mechanism of uptake, and diffusion gradients across large or dense tissue samples can result in under-staining of central regions and over-staining near the surface [Silva et al., 2015; Kerckhofs et al., 2022].

// published results are rarely directly comparable. The choice of imaging method, contrast agent, and processing workflow profoundly shapes what structures are visible and measurable in the resulting volume, making 3D histological imaging an inherently context-specific endeavour that demands careful justification of each step in the pipeline.

// - Silva et al. (2015), *Scientific Reports* - X-ray staining micro-tomography and diffusion challenges @3dnondestructive_softtissue_µtomo
// - Leyssens, Pestiaux & Kerckhofs (2021), *Int J Mol Sci* - cardiovascular microCT review  
                // A Review of Ex Vivo X-ray Microfocus Computed Tomography-Based Characterization of the Cardiovascular System 
// - Schaad et al. (2017), *Scientific Reports* - vascular casting agent comparison
// - Badea & Johnson (2015), *Frontiers in Pharmacology* - nanoparticle contrast agents for micro-CT
// - Moldovan et al. (2015), *PLOS ONE* - iodine-based contrast for mouse brain µCT


// // ---- Initial

// `== Tissue imaging`

// Understanding the three-dimensional structure of biological tissue is a prerequisite for the analysis of structure-altering drugs such as Pazopanib, where the effect of interest - changes in tumor vascularization - is inherently spatial. Classical 2D histology, while remaining the reference method for human biopsy analysis in oncology, is fundamentally limited in this regard. The technique requires physical slicing of the sample, which is destructive, potentially deforming, and critically, not orientation-agnostic. A large number of slices may be needed to capture structures that do not follow a particular axis, as is the case with vascular networks. Furthermore, classical histology samples dry out during preparation, and the resolution achievable when reconstructing a third dimension by stacking 2D slices is limited. While some techniques such as confocal microscopy, light sheet microscopy, and optical coherence tomography allow partial extraction of 3D information from 2D acquisitions, they remain constrained in the depth and scale of tissue they can characterize.

// Non-destructive volumetric imaging methods overcome many of these limitations. Magnetic resonance imaging (MRI) and computed tomography (CT) - and their higher-resolution variants, micro-MRI and microCT - enable virtual slicing across any plane without physically sectioning the sample. Micro-MRI offers strong contrast on soft tissue, while microCT excels on calcified structures but achieves sub-micrometer resolution. Crucially, both modalities can be used in conjunction with contrast-enhancing staining agents (CESAs), which extend their applicability to soft tissue. In the case of microCT, this gives rise to contrast-enhanced microCT (CECT), which has been reviewed for ex-vivo data acquisition and has demonstrated its utility in contexts such as canine cardiac analysis and vascular exploration in small animal models.


// -----------------------------------------------------------



// In order to process the 2D slices into 3D, various software are available. Bellow is a grid containing the pieces of software considered in the context of this thesis for the analysis of the micro-ct slices, separated by license type. For the sake of our analysis, any software not available free of charge without pre-requisites is considered commercial:

// Based on Dragonfly3D's own list, in resources/software/dragonfly3Dsoftwarelist.jpg

// Commercial software
// Amira Or Avizo
// Analyze by AnalyzeDirect
// CTAn and CTVol by Bruker
// Image Pro by Media Cybernetics
// Imaris by Oxford Instruments Bitplane
// MeVisLab 
// Mimics by Materialise
// ScanIP by Simperware
// Octopus by inCT
// uCT
// VG Studio
// Zeiss Inspect
// Dragonfly3D

// Opensource or Freeware
// 3D Slicer
// Chimera
// Blender
// Dream3D
// Drishti
// ImageJ
// FIJI
// IMOD
// Meshab
// OsiriX
// ParaView
// Visit

// Other software includes:
// SPROUT 
// nnU-Net


// When comparing these pieces of software for potential use in this thesis, the following technical criteria were considered, from most to least important:
// - Ability to import 3D scan from individual 2D slices of JPEG/PNG/TIFF/BMP/DICOM format
// - Ability to segment blood vessels
// - Ability to export data to non proprietary formats: JPEG/PNG/TIFF/BMP/DICOM or other
// - Ability to add software plugins to extend capabilities
// - Availability of external software intended for blood vessel segmentation
// - Ability to manually segment areas of the 3D scan

// User friendliness was also considered:
// - Availability of instructions online in the form of dedicated support forums
// - Availability of youtube videos
// - Prior use of the software by people with a background in biology for other tasks
// - Ease of installation

// By default, three proprietary pieces of software were retained for the following comparison, due to their prior use in the research team carrying out the work: Dragonfly3D, CTAnn and Avizo. From the parameters laid out above, 3DSlicer, SPROUT and ImageJ/Fiji were retained for deeper comparison.

// Compare them, 3DSlicer comes out above due to having VMTK and R-Vessel-X.


// ----------------------- Commented 26-02-26



// Greet:
// 1. Broad → it's a funnel
// 2. Broad: blood vessels in tissues, important to charact, many imaging, ours is CECT, problems eixist
//     1. How do people do seg, not robust, not bla bla
//     2. Other alternatives
//         1. 3DSlicer available, discuss how it is used
//             1. Every section focuses more and more, describe main problems, the more you go down, the more you have well defined research questions. Very brief mentions of research questions
// 3. After SOTA 2pp: problem statement, general goal, objectives
//     1. Based on the levels above, summarize points mentioned in SOTA
//         1. Important remaining research questions are etc etc etc, main goal is this, objectives are a b c

// Sébastien:
// 2. SOTA (bio oriented, explain the pipeline, explain variability), (10pp)
  
// There is a review article that was incomplete, lots of the literature focused on ex-vivo
// Focus on ex-vivo but get some algos from in-vivo. Data ex-vivo is much more complex.
// Missing connections helps on the medical field → it’s the reconnection aspect that matters. ex-vivo it’s both the segmentation and the reconnection.

// Talk about the fact that clinical CT grey value does a good job, micro ct ex-vivo is a lot more difficult that’s why we focus on ex-vivo. There is transferability from ex to in vivo but the other way isn’t necessarily the case.

// // Comparing shortcomings of CECT with 2D histo
// // Another reason for the absence of these very small vessels on CECT is that CA
// // binds to blood cells such as red blood cells, so if there is no blood, there will be
// // no staining. On the other hand, CD31 binds to a transmembrane glycoprotein
// // expressed by endothelial cells and platelets [68]. It is therefore possible that CD31
// // could detect very small blood vessels even in the absence of blood, whereas CA
// // cannot.

// // briefly SOTA 3D histology for drug screening, the need for 3D histo is clear for companies developping drugs, I focus on antiangionetic drugs on tumor -> refer to Lisa thesis (effect of pazopanib)

// #pagebreak()

// With the goal of reconstructing tumor vascularization for the analysis of the antiangionetic drug Pazopanib in the context of cancer treatment, we begin by exploring the use of histology for drug sreening, followed by imaging methods, more specifically contrast-enhanced Micro CT, and finish with an exploration of the methods of structure extraction from images.


// == Histology for drug screening 

// In order to bring new drugs to market, a set of steps must be followed that are established by organisations such as the European Medical Association in the European Union, or the Food and Drug Administration in the U.S [1.1]. One of the key steps is collecting data on the effectiveness of the drug, done through clinical trials. These trials, before taking place in humans, are done on animals in a controlled lab environment, where collected data is analyzed for the outcomes and side effects of the drug. In the analysis process for Pazopanib, tumors are sampled and analysed ex-vivo, the histology of these tumors is critical in identifying the impact of treatment when compared to a control. 

// The conclusions taken from each step in the clinical trial decide if the trial moves on, meaning that a more accurate prediction with tighter confidence intervals enables a better discriminative power and reduces the amount of effective drugs discarded due to uncertainty from process limitations. 


// === Histology in industry

// Histology is in use in industry for clinical trials amongst other tasks, and the field is growing [2.1]. Histology is used due to its large amounts of qualitative data and high discriminative power, and is interpreted by experts during the process of drug research. It is used in clinical trials of structure altering drugs, or where the effect of interest is expected to be visible, and is generally done by specialized histopathologists [2.1]. Clinical trials vary widely in their design, as well as have a large variety of possible targets, in oncology specifically, 2D histology remains the most widely used technique [2.3], [2.27, 2.60] for the histology of human biopsies. For the analysis of Pazopanib, 2D histology is the reference method used to evaluate tumors. 


// ==== 2D histology

// The field of histology is born from 2D histology of tissue under microscope magnification. 2D microscope slice histology, known as "classical histology", takes the form of tissue sample collection, often embedding of the tissue, followed by staining with various agents, applied to increase contrast or highlight certain structures, and ending in investigation using optical or electron microscopy [3.1]. This technique is used due to its delivery of a large amount of relevant quanlitative data imediately interpretable by experts, and high discriminative power, although it is time consuming and is costly as a result [3.2]. As a technique it has evolved in multiple directions, from the utilization of advanced staining agents [3.2] allowing the staining of a broad range of classes (DNA, proteins, lipids, or carbohydrates), to different lighting wavelenghts, ranging from ultraviolet [3.3] to infrared [3.4]. 

// #linebreak()
// 2D histology is limited by its requirement to slice the target tissue before analysis, resulting in destructive modification of the sample. This slicing has the potential of deforming the tissue, with various techniques developped to conteract this [3.5] such as embedding in a wide variety of mediums. Slicing is also not orientation agnostic, and a large number of slices might be required for a sufficient spatial analysis of the sample, especially in situations where the observation target does not follow a particular axis, as with vascularization.

// #linebreak()
// The limitations of pure 2D histology are now resulting in quantitative histology moving in the direction of 3D analysis, especially when 3D structure of the tissue is relevant. 

// #linebreak()
// Unmentioned above: 
// - samples dry out in classical histo, 
// - the resolution is limited when stacking
// - there are methods for extracting some 3D info from the 2D slices ex:"confocal microscopy light sheet microscopy or optical coherence tomography" https://doi.org/10.1038/s41467-022-34048-4


// ==== 3D histology

// 3D histology is an evolution of 2D histology, increasing the amount of information available for analysis, and as a result improving discriminative power when compared to 2D classical histology. In its most basic form as an evolution of classical 2D histology, it involves taking multiple 2D slices and aligning then stacking them to create a virtual third axis [4.1]. 3D histology is relevant for tumor analysis [4.2], allowing for structural understanding of a tissue, such as in [4.2] enabling "the spread and infiltration of invasive carcinoma to be understood". This form of histology is often still done in the same methods as with 2D, where a human carries out interpretation, requiring common standards and communication, such as in [4.3]

// #linebreak()
// Other well known methods for 3D histology that do not require slicing and thus avoid sample damage and destruction are magnetic resonance imaging (MRI) and computed tomography (CT), each having a higher resolution variant, micro-MRI and microCT respectively. These techniques enable virtual slicing, allowing observation across any plane, and have resolutions of tens microns for micro-MRI down to sub-micrometer scale for MicroCT.
// MRI is interesting for tissue observation due to its high contrast on soft tissue, as opposed to CT that performs best on calcified tissue. Both methods however are able to make use of contrast-enhancing staining agents (CESAs) [4.4,4.5] resulting in the ability for microCT to be readily used for imaging soft tissue, and is termed contrast-enhanced microCT (CECT) and reviewed for ex-vivo data acquisition in [4.6]. CECT is of particular interest for ex-vivo 3D histology due to the wide variety of staining agents available, and has proven its use in canine heart analysis [4.7] and for vasculature exploration of small animals [4.8].

// _Not certain about if or how to place the quote, as it is specifically for cancer._


// ===== CECT Imaging

// Full section on the state of the art of CECT - TODO


// == Structure reconstruction (or: Vascularization reconstruction, Interpretation methods of 3D imaging?)

// This section is leaning towards segmentation, as in survey [5.1]

// #linebreak()

// With the goal of reconstructing vascularization in imaged tissue, we aim to take in data from an imaging modality, process it through a software pipeline, and obtain at output a data structure with higher information density than the input. This process of reducing the amount of raw data, but increasing the utility or information content of the data, is explored widely in the field of computer science. It underlies concepts such model fitting to noisy data [5.2] or as more commonly carried out in a biological context and industry, image segmentation, where the goal is to separate regions of a 2D image into multiple segments and objects [5.3].


// === Segmentation

// Image segmentation plays a central role in medical image analysis by enabling quantitative analysis of different kinds: by classifying pixels with semantic labels (semantic segmentation), partitioning of objects (instance segmentation) or a combination of both across the entire image space (panoptic segmentation) [5.1]. The task can be as simple and as old as separating objects from a background, a problem that has been explored in computer science for multiple decades [5.4], or more complex as in panoptic segmentation, only being posed in 2018 [5.5].


// ==== Methods of Segmentation

// Segmentation methods have evolved over time: from classical computer vision to machine learning and later deep learning methods 

// TODO: Extend history to highlight the progression in complexity and the higher and higher levels of information extraction achieved

// #figure(
//   image("../../resources/images/timeline_from_PanopticSegmentationAReview.png", width: 100%),
//   caption: [
//     From (6.1) Timeline evolution of image segmentation (better version to be found or created)
//   ],
// )


// ==== Imaging and Segmentation of vasculature


// Vasculature reconstruction and segmentation of 3D images often requires human segmentation [6.2]. Alternative automated methods are less precice 



// Sources to be investigated and read:

// + 2013 Application of Micro-Computed Tomography With Iodine Staining to Cardiac Imaging, Segmentation, and Computational Model Development
// + 2010 Micro computed tomography for vascular exploration 
// + 2025 Micro-computed tomography to visualize preserved vascular architecture in decellularized human vaginal tissue: explorative study
// + 2004 Micro-computed tomography of the vasculature in parenchymal organs and lung alveoli

// Non tomo:
// + 2021 Robust segmentation of vascular network using deeply cascaded AReN-UNet
// + 2023 Vessel Delineation Using U-Net: A Sparse Labeled Deep Learning Approach for Semantic Segmentation of Histological Images
// + 2015 Quantification of Microvascular Tortuosity during Tumor Evolution Using Acoustic Angiography

// Vasc references:
// + 1976 The Vascularization of Tumors 
// + 2013 Springer Nature, "Vascularization"
// + 1982 Vascularization of Tumors: A Review


// #pagebreak()

// Sources, will be re-done once finalized:

// 1.1 https://www.ema.europa.eu/en/human-regulatory-overview/research-development


// 2.1 https://doi.org/10.1111/his.14099
// #linebreak()
// 2.2 Not great, behind paywall "Challenges Faced by Cross-sectional Imaging and Histological Endpoints in Clinical Trials" https://doi.org/10.1093/ecco-jcc/jjw161
// #linebreak()
// 2.3 not the best source "The dream and reality of histology agnostic cancer clinical trials" https://doi.org/10.1016/j.molonc.2014.06.002
// #linebreak()
// 2.27 Wlodarski 27: https://pubmed.ncbi.nlm.nih.gov/32445458/
// #linebreak()
// 2.60 Wlodarski 60: https://pubmed.ncbi.nlm.nih.gov/37008634/


// 3.0 Section partially inspired from https://doi.org/10.1155/2019/8617406
// #linebreak()
// 3.1 Source from [0], Mescher, L. A. Junqueira's basic histology. Text and atlas 14th ed. (McGraw-Hill, 2016).
// #linebreak()
// 3.2 https://www.ncbi.nlm.nih.gov/books/NBK557663/
// #linebreak()
// 3.3 https://pmc.ncbi.nlm.nih.gov/articles/PMC6223324/
// #linebreak()
// 3.4 https://pmc.ncbi.nlm.nih.gov/articles/PMC10408309/
// #linebreak()
// 3.5 Source from [3.0]: https://doi.org/10.1155/2019/8617406


// 4.1 https://doi.org/10.1016/j.ajpath.2012.01.033
// #linebreak()
// 4.2 https://doi.org/10.1136/jcp.2004.024794
// #linebreak()
// 4.3 Veterenary based? Not strongest article: Tseng LJ, Matsuyama A, MacDonald-Dickinson V. Histology: The gold standard for diagnosis? Can Vet J. 2023 Apr;64(4):389-391. PMID: 37008634; PMCID: PMC10031787
// #linebreak()
// 4.4 Single Ho 3+-doped upconversion nanoparticles for high-performance T2-weighted brain tumor diagnosis and MR/UCL/CT multimodal imaging: https://doi.org/10.1002/adfm.201401609
// #linebreak()
// 4.5 Three-dimensional non-destructive soft-tissue visualization with X-ray staining micro-tomography: https://doi.org/10.1038/srep14088
// #linebreak()
// 4.6 Review Greet: Contrast-Enhanced MicroCT for Virtual 3D Anatomical Pathology of Biological Tissues: A Literature Review https://doi.org/10.1155/2019/8617406
// #linebreak()
// 4.7 Application of Micro-Computed Tomography With Iodine Staining to Cardiac Imaging, Segmentation, and Computational Model Development https://doi.org/10.1109/tmi.2012.2209183
// #linebreak()
// 4.8  Micro computed tomography for vascular exploration  https://doi.org/10.1186/2040-2384-2-7


// 5.1 IEEE Image Segmentation Using Deep Learning: A Survey https://doi.org/10.1109/TPAMI.2021.3059968
// #linebreak()
// 5.2 RANSAC https://doi.org/10.1145/358669.358692
// #linebreak()
// 5.3 FIRST EDITION! Computer Vision: Algorithms and Applications. Berlin, Germany
// #linebreak()
// 5.4 OTSU https://doi.org/10.1109/TSMC.1979.4310076
// #linebreak()
// 5.5 Panoptic https://doi.org/10.48550/arXiv.1801.00868
// #linebreak()
// 5.6 U-Net https://doi.org/10.48550/arXiv.1505.04597


// 6.1 Panoptic Segmentation: A Review https://doi.org/10.48550/arXiv.2111.10250
// 6.2 µCT visualize preserved vascular architecture in decellularized human vaginal tissue: explorative study https://doi.org/10.1038/s41598-025-14452-8
// #linebreak()


// #pagebreak()



// ----------------------- Commented 26-02-26



// === Connected papers

// #figure(
//   image("../../resources/images/Cryogenic contrast-enhanced microCT enables nondestructive 3D quantitative histopathology of soft biological tissues.png", width: 90%),
//   caption: [
//     Connected papers of Cryogenic contrast-enhanced microCT enables nondestructive 3D quantitative histopathology of soft biological tissues
//   ],
// )


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