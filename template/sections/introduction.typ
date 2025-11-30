= Introduction (2-6pp)

== Goal: SMART (Specific, Measurable, Achievable, Relevant, Time-bound)

Develop a re-usable, robust vascular reconstruction pipeline for MicroCT that:
+ Handles vessels across 10-1000µm (*TO BE DEFINED SCALES THAT MATTER*) scales
+ Represents vascularization in a method that allows extraction of clinically relevant metrics
+ - Tortuosity
+ - Branching angles
+ - Branching ratio 
+ Integrates with existing tools: Dragonfly, Avizo, Orthanc
~
TODO Key additions:
- federated machine learning, better citations on the interpretable machine learning
- better explanation of semantic and semantic segmentation, and its up and downsides
- active phrasing for titles & subtitles
- Link sections explicitly (e.g., "Having established the need for vascular reconstruction, we now compare imaging modalities...").
- Focus on extracting problems in the intro

== Vascularization


- Define tumor vascularization (blood vessel networks in tumors induced by the tumor to continue growing -> see wlodarski).
- Role of vascularization: nutrient/oxygen supply to tumor, metastasis/spreading but can also allow treatment delivery
- Why reconstruction of vascularization matters -> allows us to estimate state of tumor, better evaluate treatments
~

- The whole human body is vascularized, every organ
- - Mention key figures 
- It plays a key role in many diseases
- - Diseases of the vascular system: leading cause of death (heart failure)
- - Other diseases: uses the system to move around
- - Other diseases: uses the system to feed itself (cancer/tumors)
- It is multiscale
- It is a common structure amongst living organisms
- It is it is critical to multicellularity
~
- It can be analysed qualitatively 
- - using vascular studies
- - using tools (Stethoscopes)
- It can be analysed quantitatively
- - using post mortem dissection
- - using imaging techniques

== Imaging

Firstly, imaging methodologies can be split into three main categories characterized by the wavelengths used for imaging:

- Low frequency, physical waves in the 1-10 000HZ range: pressure waves that travel through the medium to be imaged
- Medium frequency, electromagnetic waves (in the ??? range): electromagnetic waves that interact with the mollecules of the medium to be imaged
- High frequency, electromagnetic waves (in the ?? range): electromagnetic waves that interact with the nucleus of the atoms of the mollecules making up the medium to be imaged
~
Secondly, imaging goals can generally be separated into groups by the dimensionality they seek to reproduce, here we focus on three:
+ 1D reconstruction
+ 2D reconstruction
+ 3D reconstruction
~
State types of imaging:
- 1D methods and how they construct towards 2D
- state the other types of 2D
- 3D methods and how they relate to (and evolve from) 2D
- 4D methods and how they evolve from 3D
~
Higher dimension reconstruction is not discussed here, but is of relevance for e.g. analys of the evolution of strain in a material as a function of the applied torque.

=== Medical imaging

State how imaging is used in medicine
- classical 2D histo and how it started the field of imaging
- shortly discuss 1D methods
- discuss 3D methods
- in depth on CT

Of these, each type has notable advantages and disadvantages. If we focus on MicroCT, the imaging medium used in this document, we note the main disadvantage of the high radiation dose during imaging, requiring this method to be done ex-vivo. MicroCT also suffers from very variable contrast, and the term covers a wide breadth of different techniques and machine settings, due to the wide range of X-rays possible, methods for generating them and methods for reconstructing images.

=== Imaging uses

Of all the imaging techniques used in medicine, it is rare for the imaging technique alone to be sufficient in diagnosing a problem. Imaging methods can result in images ranging from Echocardiograms, requiring specialized training to interpret, to classical X-rays, such as those that initiated the world of (in body or through body imaging? name for this?) by Röntghen with the famous radiogram of (his?) hand.

The images from imaging techniques require interpretation in part because they contain limited semantic information: the difference between different structures in the image, and the link to real body parts, is generally heavily context dependent, relying on interpretation skills built up over years of education by experts such as those in radiology.

==== Focus on MicroCT and CECT

What is MicroCT <> CT (resolution, ex-vivo nature, sample preparation).
- Why are CEST agents used
- Explain contrast mechanisms for soft tissue and vessels (contrast agent vs native contrast like RBCs).
- Explain issue with dynamic nature of the images: big vessels vs small vessels

Conclude with why we're using MicroCT for this situation and more generally why MicroCT can be attractive for vascularization (3D, high resolution) and why it is challenging (noise, artifacts, variation with vessel size).

=== Imaging interpretation

The fundamental progress that has occured over the past century in imaging has been one of hand-in-hand progression of imaging techniques with interpretation techniques, from 2D images to 3D reconstructions such as those seen in MRI. (from here not sure?) We will argue that, in order to be able to make sense of MicroCT imaging, the same way MRI required tomographic reconstruction (not really, here the idea is to focus on the different techniques to increase contrast or highlight differences?), a step almost no human could do themselves, it is required to develop new techniques, that go further than imaging or simply classifying points in space as one or the other category, as seen in segmentation. It is argued that reconstruction: the process of extracting a higher order of information from our imaging data, is necessary to be able to make sense of systems as complex as those of vascularization.

=== Analysis for Vascularization characterization

- Pros and cons for each wrt to vascular analysis (resolution, invasiveness/ex or in vivo, 3D vs 2D, contrast/colour) 

== Exploring the reconstruction problem

Most current imaging techniques produce non semantic data
- Example of imaging that does extract (near) semantic data: xray of bones
- Widen to most other imaging and other xray based techniques: most don't differentiate so well

Return to CECT:
- It outputs data that needs processing, explain why, discuss voxel sizes, discuss the use of staining agents

Present semantic extraction / segmentation / reconstruction of structures.
- Situations and examples where it is good
- Contrast with specific issues in your setting:
-- Dynamic nature of the target based on size
-- 3D problematic


== Existing approaches to semantic extraction

=== traditional image processing (thresholding, filtering, morphological ops).

- Show it working for CECT
- Show it failing for some examples, motivate need for going deeper

=== model-based and graph-based reconstruction

- Discuss what it is
- Discuss its downsides (tuning, expert knowledge, fragile to context changes)

=== machine learning / deep learning methods.

- Discuss its use for semantic extraction
- Discuss its downsides
-- need for lots of data
-- poor generalization
-- poor re-usability by other researchers
-- poor failure characterization: can fail in unexpected ways, or silently
-- poor wider scientific community understanding of how to validate and pipeline ML