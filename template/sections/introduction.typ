= Introduction

Blurb:
what is vascularization and why is it important
What is MicroCT, what other imaging modalities exist, and what are the variants of CT
what is the process of reconstruction, what are methods, why is it important, what does it allow


== Context - biology

- Define tumor vascularization (blood vessel networks in tumors induced by the tumor to continue growing -> see wlodarski).
- Role of vascularization: nutrient/oxygen supply to tumor, metastasis/spreading but can also allow treatment delivery
- Why reconstruction of vascularization matters -> allows us to estimate state of tumor, better evaluate treatments


== Imaging general overview

- Main imaging modalities: 2D histology, MRI, conventional CT, ultrasound
- Pros and cons for each wrt to vascular analysis (resolution, invasiveness/ex or in vivo, 3D vs 2D, contrast/colour) 


== Focus on MicroCT and CECT

What is MicroCT <> CT (resolution, ex-vivo nature, sample preparation).
- Why are CEST agents used
- Explain contrast mechanisms for soft tissue and vessels (contrast agent vs native contrast like RBCs).
- Explain issue with dynamic nature of the images: big vessels vs small vessels

Conclude with why we're using MicroCT for this situation and more generally why MicroCT can be attractive for vascularization (3D, high resolution) and why it is challenging (noise, artifacts, variation with vessel size).


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


== Problem statement and objective

HMW (HOW MIGHT WE) reconstruct vasculature from MicroCT robustly across variable vessel size scales, starting with tumors then widening to other vascularized tissue, while ensuring extraction of research relevant metrics, compatibility with methods used by existing researchers, and portability to other data