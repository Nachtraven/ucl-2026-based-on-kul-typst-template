= Introduction (2-6pp)

== Goal: SMART (Specific, Measurable, Achievable, Relevant, Time-bound)

Develop a re-usable, robust vascular reconstruction pipeline for MicroCT that:
+ Handles vessels across 10-1000µm scales - to be fixed
+ Represents vascularization in a method that allows extraction of clinically relevant metrics - papers on vasc
+ - Tortuosity
+ - Branching angles
+ - Branching ratio 
+ Integrates with existing tools: Dragonfly, Avizo, Orthanc

#v(12pt)

TODO additions:
- having re-usability enables future federated machine learning
- better research and citate on the interpretable machine learning -> goal of transferrability and re-use
- better explanation of semantic and semantic segmentation, and its up/downsides
- Graph-based reconstruction
- Explore why existing methods fail
- active phrasing for titles & subtitles
- Link sections explicitly (e.g., "Having established the need for vascular reconstruction, we now compare imaging modalities...").
- Focus on extracting problems in the intro

#v(24pt)

== Vascularization


- Define tumor vascularization (blood vessel networks in tumors induced by the tumor to continue growing -> see wlodarski).
- Role of vascularization: nutrient/oxygen supply to tumor, metastasis/spreading but can also allow treatment delivery
- Why reconstruction of vascularization matters -> allows us to estimate state of tumor, better evaluate treatments that act on vasc.

#v(12pt)

- The whole human body is vascularized, every organ
- - Mention key figures 
- It plays a key role in many diseases
- - Diseases of the vascular system: leading cause of death (heart failure)
- - Other diseases: uses the system to move around & human body uses it to move white blood cells around
- - Other diseases: uses the system to feed itself (cancer/tumors) & human body too

#v(12pt)

- It is multiscale - explore vasculature papers
- It is a common structure amongst living organisms - as with abstract: clarify if it evolved independently multiple times, and that its commonality is structure and not the "liquid"
- It is it is critical to multicellularity

#v(12pt)

- It can be analysed qualitatively -> cite some forms of vasculature studies that indirectly measure or evaluate it
- - using vascular studies
- - using tools (Stethoscopes)
- It can be analysed quantitatively -> cite some forms of vasc. studies that directly measure it and cite papers that use it for anti-angio drugs
- - using post mortem dissection
- - using imaging techniques

#v(24pt)

== MicroCT

What is MicroCT <> CT (resolution, ex-vivo nature, sample preparation).
- Why are CEST agents used
- Explain contrast mechanisms for soft tissue and vessels (contrast agent vs native contrast like RBCs).
- Explain issue with dynamic nature of the images: big vessels vs small vessels

Conclude with why we're using MicroCT for this situation and more generally why MicroCT can be attractive for vascularization (3D, high resolution) and why it is challenging (noise, artifacts, variation with vessel size).

#v(24pt)

=== Imaging interpretation

The fundamental progress that has occured over the past century in imaging has been one of hand-in-hand progression of imaging techniques with interpretation techniques, from 2D images to 3D reconstructions such as those seen in MRI. (from here not sure?) We will argue that, in order to be able to make sense of MicroCT imaging, the same way MRI required tomographic reconstruction (not really, here the idea is to focus on the different techniques to increase contrast or highlight differences?), a step almost no human could do themselves, it is required to develop new techniques, that go further than imaging or simply classifying points in space as one or the other category, as seen in segmentation. It is argued that reconstruction: the process of extracting a higher order of information from our imaging data, is necessary to be able to make sense of systems as complex as those of vascularization.

#v(24pt)

=== Analysis for Vascularization characterization

- Pros and cons for each wrt to vascular analysis (resolution, invasiveness/ex or in vivo, 3D vs 2D, contrast/colour) 

#v(24pt)

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