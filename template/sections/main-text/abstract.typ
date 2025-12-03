== Section should be 1pp max.
=== Notes:
- Vascularization is unique due to being multiscale (ie the same structure when zoomed in/out)
- Metastatis is unique due to being a form of disease that is angiogenic 
- Metastatis is unique due to being multiscale (somewhat - it does have differentiation)
- Vascularization is common amongst many lifeforms (here research what ties this together?)
- Vascularization is key to evolution/multicellular life (here - proper understanding: develop independently multiple times)
- Vascularization is different in its requirements for understanding and evaluation due to being a supporting system. You must be able to have a structural understanding (think: tortuosity)
~
~
- Analysis of vasc. is challenging due to being multiscale
- Analysis of vasc. is challenging due to imaging technologies
- Analysis of vasc. is challenging due to requirement for structural reconstruction, which is a higher order of extraction of information than classification
~
- Reconstruction is challenging due to imaging specificities (discontinuities - paper here on CE agent use)
- Reconstruction is challenging due to spatial relations (paper on the types of vessels and their shapes)

=== Short pitch:

I am working on reconstructing the vascularization network using microct, a method of ct or xray scanning that is of particularly high resolution. The raw images are generally not directly usable as the vascularization is discontinuous, and the way it appears in images varies is based on the size of the vasculature: for example more contrast agent can be present in larger vessels, and smaller vessels may not get much or any agent, but contrast in this case being due to the red blood cells. I use tumors as a target for analysis, with the goal of achieving cross organ (cross structure?) reconstruction and quantification. 


== First try:

Soft tissue analysis presents multiple challenges relating to the required techniques to obtain structural information. One such technique is MicroCT, an Ex-vivo method of 3D reconstruction. However, this process, as with all imaging processes, does not produce semantic information in and of itself. The step of semantic extraction generally makes use of expert knowledge, computer algorithms, or more recently machine and deep learning. In this document, we aim to develop an adaptable and re-usable method for the semantic extraction of blood vessels from MicroCT scans, characterized by one practical application: that of extracting vascularization of tumors, in order to compare tumors treated with a vasculature modifying treatment with control tumors.

=== Second try:

The analysis and quantification of Vascularization in tissues is a challenging task due to diversity and its multiscale nature: the vascular system is present in every organ of the human body, and varies from micrometers to millimeters or even centimeters in size. An imaging technique capable of this level of dynamic range is Micro-CT imaging, sometimes used with contrast agents to aid in differentiation and contrast. In this document, we explore the process of extracting higher level structures from MicroCT images of tumors, in order to enable efficacy analysis of antiangionetic treatments.


=== Third(rough) try:

Vascularization is everywhere in humans, but also in a lot of non human -> more widely, its a feature of large multicellular life.
Analysis of Vascularization is challenging due to it being multiscale, and it is underdevelopped due to being a supporting system.
Most imaging techniques have the limitation that they don't extract structure, which is essential to analyzing vasculature's function, *due to the Vascularization system being a system that exists to support structure.*  
One promising imaging method is (micro) CT, due to its ability to reconstruct in 3D without physical deformation, however this technique, like all techniques, does not allow direct extraction of structure.
Here we propose a technique that takes into account the multiscale nature of vascularization to extract structure and enable analysis of vasculature changes as a component of treatment of tumors.

