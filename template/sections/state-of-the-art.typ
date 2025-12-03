= State of the art

== Imaging

#image("/assets/image.png", width:250pt)

Visualize imaging across  axes: frequency, resolution and dimensionality. TBD how to make this visually interesting and easy to read.
Also across imaging mediums?

#v(12pt)

Goal here - separate the imaging modalities by what they interact with:
- Low frequency mechanical imaging (10^5 - 10^8 Hz): pressure waves, accoustic properties of organs to be imaged
- Molecular and electronic scale interactions (10^6 - 10^15 Hz): electromagnetic waves probing bulk dielectric properties, molecular bonds, or electronic states of the tissues and organs imaged (also: surface profile)
- High-frequency electromagnetic (10^16 - 10^21 Hz): X-rays interact with atomic electrons and gamma rays can interact with nuclei, probing material elemental composition

#v(12pt)

Potentially: how 3D images are made from 2D images
*TODO*: Clarify terminology reconstruction vs segmentation vs skeletonization/nodes

#v(24pt)

=== Medical imaging

State how imaging is used in medicine
- classical 2D histo and how it started the field of imaging
- shortly mention 1D methods
- discuss 3D methods
- in depth on CT

Of these, each type has notable advantages and disadvantages. If we focus on MicroCT, the imaging medium used in this document, we note the main disadvantage of the high radiation dose during imaging, requiring this method to be done ex-vivo. MicroCT also suffers from very variable contrast, and the term covers a wide breadth of different techniques and machine settings, due to the wide range of X-rays possible, methods for generating them and methods for reconstructing images.

#v(24pt)

=== Imaging uses

Of all the imaging techniques used in medicine, it is rare for the imaging technique alone to be sufficient in diagnosing a problem. Imaging methods can result in images ranging from Echocardiograms, requiring specialized training to interpret, to classical X-rays, such as those that initiated the world of (in body or through body imaging? name for this?) by Röntghen with the famous radiogram of (his?) hand.

The images from imaging techniques require interpretation in part because they contain limited semantic information: the difference between different structures in the image, and the link to real body parts, is generally heavily context dependent, relying on interpretation skills built up over years of education by experts such as those in radiology.

#v(24pt)


==== Focus on MicroCT and CECT

Explore existing methods more than in the intro
Touch on methods for segmentation, vasculature extraction, the CE process


=== Pre-processing/filtering/area of interest

=== classical techniques (thresholding)
limitations

=== Machine learning techniques

=== Tools used in the real world (Avizo, Dragonfly)



#v(24pt)

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


== Portable machine learning / Opensource / Freely available software

Discuss limitations of current softwares wrt portability

=== Opensource
SOTA of Opensource methods

=== Closed source / Paid
SOTA of closed source methods


== Vascularization reconstruction

Vascularization in different body parts and tissues -> explain it varies and if anyone has done a review

