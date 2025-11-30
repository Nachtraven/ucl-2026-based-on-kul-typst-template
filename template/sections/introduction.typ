= Introduction (2-6pp)

Goal: make it SMART (Specific, Measurable, Achievable, Relevant, Time-bound)
Develop a re-usable, robust vascular reconstruction pipeline for MicroCT that:
- 1. Handles vessels across 10-1000µm (*TO BE DEFINED SCALES THAT MATTER*) scales
- 2. Represents vascularization in a method that allows extraction of clinically relevant metrics
-- 2.0 Temporal evolution/change
-- 2.1 Tortuosity
-- 2.2 Branching angles
-- 2.3 Branching ratio 
- 3. Integrates with existing tools: Dragonfly, Avizo, Orthanc


Key additions:
- federated machine learning, better citations on the interpretable machine learning
- better explanation of semantic and semantic segmentation, and its up and downsides
- active phrasing for titles & subtitles
- Link sections explicitly (e.g., "Having established the need for vascular reconstruction, we now compare imaging modalities...").
- Focus on extracting problems in the intro


The accurate reconstruction of vasculature for both qualitative and quantitative analysis is critical in evaluating new drug outcomes, planning surgery, and expanding scientific understanding. A qualitative improvement would allow surgeons a better view on the existing vasculature in patients, or researchers the opportunity to better evaluate the health outcomes and treatments for conditions such as troke. A quantitative improvement would enable more accurate comparison studies, expand our understanding of the evolution of vasculature through time and space, as well as enable downstream analysis such as evaluating flow rates.

The human body contains (?? how many km or cm³ or other figure?) of blood vessels. The vascular system is the most omnipresent human "organ", present from the brain to the toes, from the fingertips to the center of the kidney. It plays many roles, and as a result is a crucial element in many diagnoses, a primary or collateral victim of many diseases and, in the form of heart failure (??), the leading worldwide cause of death.

Many methods exist to quantify and qualify the vasculature system for doctors and researchers: from so called "Vascular Studies" that test the blood flow in arteries and veins, to various imaging techniques at various levels of complexity, price and invasiveness: Stethoscopes for simple audio interpretation, MRIs, CT scans, Echocardiograms and many more that can be carried out on live patients, histology and anatomical studies done after death, and our subject of interest: microCT, carried out ex vivo in labs.


Of the techniques looking to reconstruct 3D images, there are three main categories that can be separated by the wavelengths used for imaging:
(?? source? how do I separate these?)
- Low frequency, physical waves in the 1-10 000HZ range: pressure waves that travel through the medium to be imaged
- Medium frequency, electromagnetic waves (in the ??? range): electromagnetic waves that interact with the mollecules of the medium to be imaged
- High frequency, electromagnetic waves (in the ?? range): electromagnetic waves that interact with the nucleus of the atoms of the mollecules making up the medium to be imaged

Of these, each type has notable advantages and disadvantages. If we focus on MicroCT, the imaging medium used in this document, we note the main disadvantage of the high radiation dose during imaging, requiring this method to be done ex-vivo. MicroCT also suffers from very variable contrast, and the term covers a wide breadth of different techniques and machine settings, due to the wide range of X-rays possible, methods for generating them and methods for reconstructing images.


Of all the imaging techniques used in medicine, it is rare for the imaging technique alone to be sufficient in diagnosing a problem. Imaging methods can result in images ranging from Echocardiograms, requiring specialized training to interpret, to classical X-rays, such as those that initiated the world of (in body or through body imaging? name for this?) by Röntghen with the famous radiogram of (his?) hand.

The images from imaging techniques require interpretation in part because they contain limited semantic information: the difference between different structures in the image, and the link to real body parts, is generally heavily context dependent, relying on interpretation skills built up over years of education by experts such as those in radiology.

The fundamental progress that has occured over the past century in imaging has been one of hand-in-hand progression of imaging techniques with interpretation techniques, from 2D images to 3D reconstructions such as those seen in MRI. (from here not sure?) We will argue that, in order to be able to make sense of MicroCT imaging, the same way MRI required tomographic reconstruction (not really, here the idea is to focus on the different techniques to increase contrast or highlight differences?), a step almost no human could do themselves, it is required to develop new techniques, that go further than imaging or simply classifying points in space as one or the other category, as seen in segmentation. It is argued that reconstruction: the process of extracting a higher order of information from our imaging data, is necessary to be able to make sense of systems as complex as those of vascularization.


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