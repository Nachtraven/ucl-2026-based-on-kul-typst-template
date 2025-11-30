== Notes:
- Vascularization is unique due to being multiscale (within humans)
- Metastatis is unique due to being multiscale
- Vascularization is common amongst many lifeforms
- Vascularization is different in its requirements for understanding and evaluation due to being a supporting system. You must be able to have a structural understanding (think: tortuosity)
~
~
- Analysis is challenging due to being multiscale
- Analysis is challenging due to imaging technologies
- Analysis is challenging due to requirement for structural reconstruction, which is a higher order of extraction of information than simple structural classification
~
- Reconstruction is challenging due to imaging specificities
- Reconstruction is challenging due to spatial relations

== First try:

Soft tissue analysis presents multiple challenges relating to the required techniques to obtain structural information. One such technique is MicroCT, an Ex-vivo method of 3D reconstruction. However, this process, as with all imaging processes, does not produce semantic information in and of itself. The step of semantic extraction generally makes use of expert knowledge, computer algorithms, or more recently machine and deep learning. In this document, we aim to develop an adaptable and re-usable method for the semantic extraction of blood vessels from MicroCT scans, characterized by one practical application: that of extracting vascularization of tumors, in order to compare tumors treated with a vasculature modifying treatment with control tumors.

=== Second try:

The analysis and quantification of Vascularization in tissues is a generally   


#pagebreak()

=== Third(rough) try:

Vascularization is everywhere in humans, but also in a lot of non human -> more widely, its a feature of large multicellular life.
Analysis of Vascularization is challenging due to it being multiscale, and it is underdevelopped due to being a supporting system.
Most imaging techniques have the limitation that they don't extract structure, which is essential to analyzing vasculature's function, *due to the Vascularization system being a system that exists to support structure.*  
One promising imaging method is (micro) CT, due to its ability to reconstruct in 3D without physical deformation, however this technique, like all techniques, does not allow direct extraction of structure.
Here we propose a technique that takes into account the multiscale nature of vascularization to extract structure and enable analysis of vasculature changes as a component of treatment of tumors.

=== Short pitch/explanation:
I am working on reconstructing the vascularization network of tumors imaged using microct, a method of ct or xray scanning that is of particularly high resolution. The raw images are generally not directly usable as the vascularization is discontinuous, and the way it appears in images varies based on the size of the vasculature, due to more contrast agent being present in larger vessels, and smaller vessels not getting any agent, but contrast in this case being due to the red blood cells.