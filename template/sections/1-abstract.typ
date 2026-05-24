// Notes moved to "1-abstract-backup-29-04.typ"


// As tissue imaging techniques have evolved from 2D to 3D and progressively increased in resolution, with current datasets weighing over 100GB, associated tooling for analysis has evolved in lockstep with specific usecases in mind. Due to the diversity 

// The process of data analysis, its associated tools and methods, has become central to the scientific process.

// Advanced imaging methods such as contrast-enhanced micro tomography aim to separate tissue by use of contrast enhacing agents, but noise in imaging and the multiscale, dispersed nature of vascularization result in the need for more powerful software methods to enable the comparison of samples across various treatment profiles, and achieve the levels of accuracy required for drug research. In this document the clinical pipeline is examined from end to end, a more powerful extraction method for vascular structures in challenging use cases is developed, and the groundwork laid for principled, scientifically rigorous work to be carried out.


Tissue imaging has evolved from 2D microscopy to 3D modalities of ever-increasing resolution, with current singular contrast-enhanced Micro-CT scans reaching approaching 100GB. The laboratory tooling needed to extract useful structure from these volumes has lagged behind: existing solutions are either proprietary, restricted in complexity and predictive power, or require deep learning expertise and associated data that is neither available nor straightforward to obtain. This tooling gap appears in our dataset of tumor microvasculature, having resisted previous attempts at analysis: vessels span only a few voxels, are disconnected, contrast staining is non-uniform, and noise exists in the structures. // Such data has, in practice, resisted analysis with available open-source tools.

#linebreak()
In this thesis an open-source 3D Slicer plugin called CollaboratiVessel is proposed for microvasculature extraction from contrast-enhanced Micro-CT data, motivated by a dataset of murine tumors collected for the study of the antiangiogenic drug Pazopanib. Rather than requiring annotated data or computer science expertise, the end user is placed in the algorithmic loop by providing sparse input to an extraction pipeline founded on simple algorithmic steps. The implementation combines structurally aware vesselness extraction with vessel reconnection, ingesting and emitting standard DICOM medical imaging formats to integrate with downstream analysis software. The pipeline is evaluated on Micro-CT scans with manually annotated ground truths, and is shown to recover vascular structure with a higher quality than intensity-based thresholding methods. All code, the source of this document, and working notes are released under permissive open licenses to support reuse and further development.

 //making it principled, adaptable to new datasets without retraining, and usable by researchers without a computer science background. 



#linebreak()
problem -> gap (generally) -> contribution (mine) -> result/significance (the impact)