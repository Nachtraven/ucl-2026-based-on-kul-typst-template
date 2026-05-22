#import "./appendices/graph_results.typ": results-chart
#import "appendices/precision_recall.typ" : xy-curve

// Problem statement: 2 pages, contains general goal, objectives
// summarize points mentioned in SOTA
// Highligts important remaining research questions, main goal and sub objectives

// - ✓ Formulate again relevant, simple, measurable, and feasible research questions that are still remaining (should be clear after reading the SOTA)
// - ✓ State the research aim or hypothesis of the project, and formulate concrete objectives

// Recap 2/3 sentences, restate the situation that the SOTA established.
// Gap/aim: Name the unfilled niche, and state your aim as a positive proposition.
// Objectives: Concrete, scoped sub-goals that together meet the aim.

= Problem statement

// Comment: Microvasculature in CECT Micro-CT data is characterized by small and low contrast vessels with discontinuities and diffusion-induced intensity gradients. Existing extraction methods divide between data-driven approaches that require annotated training data unavailable for this regime, and classical methods that require careful hyperparameter tuning. Existing software pipelines generally target large vasculature or are unintegrated into software tools.

In a diverse software landscape for analysis of 3D data, this work aims to answer the question _"How can an open-source microvasculature extraction pipeline be developed, able to be used by non computer scientists, leveraging classical segmentation methods and sparse user-driven input to obtain useful segmentations on CECT data across a diverse dataset?"_ and is defined by three principal constraints:

#linebreak()
*(i)* Data: Contrast-enhanced micro-CT of tumor microvasculature with compression artifacts, intensity gradients and discontinuities, and a highly imbalanced data distribution with small target structures only a few voxels across. 

#linebreak()
*(ii)* Segmentation and its two paradigms: _data-driven_ methods (machine learning) with potentially high performance but transfering poorly across datasets and requires annotated training data that is difficult to generate for CECT, and _classical_ methods that encode vessel priors explicitly but require hyperparameter tuning, and reason locally with poor extrapolation resulting in fragmented segmentations and weaker peformance in low-contrast regions.

#linebreak()
*(iii)* Tooling: existing software is focused on low resolution, on human arteries and organs with large vessels and few disconnections. Microvasculature extraction methods are sparse, rarely bespoke or integrated into available tooling


#linebreak()
Baseline will be grey value based thresholding, as it constitutes the simplest, most accessible method that has previously been used to tackle this issue. The shortcomings are expressed in @fig:pr_methodo: a sweep is run across all possible thresholding values, and measure against a manually annotated ground truth on an illustrative subvolume that contains small disconnected vessels, a light gradient, and some noisy elements. The precision-recall curve ignores true negatives and avoids giving them an outsized weight, but still allows us to understand the problem at hand: thresholding, no matter how high, will include false positives (_all high valued voxels are not necessarily vessels, the structural gap (1)_) such as in the shell region in @fig:thresholding_with_shell and at low values needed to capture faint vessels, the false positives are very high (_vessel intensities overlap with background, a challenging extraction situation, making thresholding a compromise (2)_).

// TODO: better explain the trade-off. Would an ROC curve be better than precision/recall?
// PR curve 
// Precision  = True Positives / (True Positives + False Positives)
// Recall     = True Positives / (True Positives + False Negatives)
#v(0.15cm)
#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: top,
    image("../../resources/images/methodology_pr_curve_data.png", width: 90%),
    
    
    box[
      #xy-curve(
        (
          (csv: "../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
          label: "Thresholding",
          colour: rgb("#e63946")),
        ),
        x-label: "Recall",
        y-label: "Precision",
        chart-width:180pt,
        chart-height:180pt,
        pad-left: 12pt,
        pad-bottom: 22pt,
        legend-width: 100pt,
        // show-legend: false
      )

      // Arrow 1 — points up-left
      #place(left + top,
        dx: 30pt, dy: 45pt,
        line(
          start: (0pt, 20pt),
          end: (0pt, -40pt),
          stroke: 1pt + black,
          // marker-end: "stealth",
        )
      )
      #place(left + top,
        dx: 35pt, dy: 25pt,
        text(size: 8pt)[_(1) structural gap_]
      )

      // Arrow 2 — points down-right
      #place(left + top,
        dx: 110pt, dy: 130pt,
        line(
          start: (0pt, 0pt),
          end: (40pt, 30pt),
          stroke: 1pt + black,
          // marker-end: "stealth",
        )
      )
      #place(left + top,
        dx: 130pt, dy: 130pt,
        text(size: 8pt)[_(2) challenging extraction_]
      )
    ]
  ),
  caption: [*(Left)* Run 2 CA-RU-R *(Right)* Thresholding precision-recall curve showing _(1) structural gap_: precision never reaches 1.0 because there are false positives in high valued areas and _(2) challenging extraction_: precision falls off sharply as recall increases due to the rapid increase in false positives; high recall cannot be achieved without sacrificing precision]
) <fig:pr_methodo>


== Goal

This thesis aims to develop a 3D Slicer extension that produces connected microvasculature segmentations on CECT through a hybrid pipeline combining classical algorithms with sparse user input, achieving higher vessel retrieval rates than thresholding while  also improving connectivity, measured using a bipartite matching and clDICE, operating across both reliable and unreliable subsets of the dataset.

To do so, the following steps will be carried out:
1. Deliver a user-friendly 3D Slicer extension able to export in formats useful for downstream analysis.
2. Leverage a user-in-the-loop approach for point placement & basic vessel-size context to drive automated parameter selection, replacing manual error-prone hyperparameter tuning.
3. Build the segmentation core on multiple algorithms, combined through a framework that enables per component tuning, evaluation and allows for future extension. 

== Scope

This work delivers the segmentation pipeline in the form of a plugin with downstream quantitative research analysis left to existing tools by exporting binary masks. Deep learning in its most common form is not utilized due to a lack of available reference data, training data and usability concerns. The plugin is intended for use in a research setting and tested on the set of data provided with its known shortcomings.

//Not compared with deep-learning baselines as annotated training data sufficient for fair comparison is not available. 
// The plugin is a research tool, not a clinical one.




// #v(0.2cm)
// #figure(
//   grid(
//     columns: (1fr, 1fr),
//     column-gutter: 1em,
//     align: top,
//     image("../../resources/images/methodology_pr_curve_data.png", width: 90%),
    
    
//     box[
//       #xy-curve(
//         (
//           (csv: "../../../resources/images/sweep_experiment/THRESH_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
//           label: "Thresholding",
//           colour: rgb("#e63946")),
//         ),
//         x-label: "Recall",
//         y-label: "Precision",
//         chart-width:180pt,
//         chart-height:180pt,
//         pad-left: 12pt,
//         pad-bottom: 22pt,
//         legend-width: 100pt,
//         show-legend: false
//       )

//       // Arrow 1 — points up-left
//       #place(left + top,
//         dx: 30pt, dy: 45pt,
//         line(
//           start: (0pt, 20pt),
//           end: (0pt, -40pt),
//           stroke: 1pt + black,
//           // marker-end: "stealth",
//         )
//       )
//       #place(left + top,
//         dx: 35pt, dy: 25pt,
//         text(size: 8pt)[_(1) structural gap_]
//       )

//       // Arrow 2 — points down-right
//       #place(left + top,
//         dx: 110pt, dy: 130pt,
//         line(
//           start: (0pt, 0pt),
//           end: (40pt, 30pt),
//           stroke: 1pt + black,
//           // marker-end: "stealth",
//         )
//       )
//       #place(left + top,
//         dx: 130pt, dy: 130pt,
//         text(size: 8pt)[_(2) challenging extraction_]
//       )
//     ]
//   ),
//   caption: [*(Left)* Run 2 CA-RU-R subsample *(Right)* Thresholding precision-recall curve showing _(1) structural gap_: precision never reaches 1.0, and _(2) challenging extraction_: precision falls off sharply as recall increases, high recall cannot be achieved without sacrificing precision]
// ) <fig:pr_methodo>












// == Aim and positioning

// [ONE OR TWO PARAGRAPHS. The substance:

// This is where the "computer scientist visiting biology" framing 
// earns its place. The aim is not just to build a tool; the aim is 
// to build a tool that serves a specific community working with 
// specific data, where the methodology is iteratively shaped by 
// their feedback and the constraints their data imposes.

// Suggested content beats:
// - One sentence: the aim of this thesis.
// - One sentence: the positioning ("this work approaches the 
//   problem from computer science, applied to a biological domain, 
//   with explicit acknowledgment that domain users are the 
//   primary stakeholders").
// - One paragraph: the three-stakeholder tension. End users who 
//   need usability and robustness, the open-source scientific 
//   community that needs reproducibility and extensibility, and 
//   computer-science researchers for whom algorithmic novelty 
//   is the goal. These goals are partially in tension: a maximally 
//   novel algorithm may not be the most usable; the most usable 
//   tool may not be the most extensible. This thesis's response 
//   to the tension is to weight usability and reproducibility 
//   highly, and to treat algorithmic choice as a means rather 
//   than an end.
// - (Optional) One sentence acknowledging that the methodology 
//   was iteratively shaped — that the ablation study is a 
//   consequence of taking dataset constraints seriously, not 
//   a methodological add-on.]


// == Research question

// [ONE focused research question. Suggested form:

// How can a 3D Slicer plugin be designed to extract tumor 
// microvasculature from CECT micro-CT data, such that it remains 
// usable by domain scientists, robust to the heterogeneity of 
// data encountered in practice, and scalable to the dataset sizes 
// generated by modern micro-CT acquisitions, without requiring 
// annotated training data or per-dataset retraining?

// (Adjust based on whether you want to emphasize usability, 
// robustness, or scalability as the primary axis. The question 
// above weights all three roughly equally.)]


// == Objectives

// To meet this aim, the work pursues four objectives:

// *O1. Tooling.* Deliver the pipeline as an installable 3D Slicer 
// extension with click-only installation, integrated into the 
// ecosystem already in use by the lab and broader microvasculature 
// research community.

// *O2. Methodology shaped by user feedback.* Place the user in the 
// loop through anchor-based interaction, using sparse expert input 
// to drive parameter selection and to anchor downstream pipeline 
// stages. The choice of components is informed by interviews with 
// prospective users and iterated based on observed working practices.

// *O3. Robustness through classical methods.* Build the segmentation 
// core on classical algorithms that encode vessel-specific geometric 
// priors, avoiding the data requirements of supervised deep learning. 
// Combine multiple algorithms through a probability-map framework 
// that accumulates evidence and tolerates the failure of any single 
// component.

// *O4. Scalability across the lab's actual data.* Ensure the pipeline 
// runs on the full range of dataset sizes encountered in practice, 
// on hardware available to lab users, in tractable time. Where the 
// initial pipeline fails this objective, identify and remove the 
// components responsible — an ablation that is itself a methodological 
// contribution.

// [OPTIONAL: If you keep evaluation as a separate concern rather 
// than folding into O3/O4, add an O5:

// *O5. Evaluation.* Use lightweight, expert-feasible annotation 
// methods (anchor-point ground truth, manual pixel-level baselines 
// on selected regions) and report performance separately on the 
// challenging conditions identified in the SOTA: low-CESA regions, 
// bifurcations, small vessels.]


// == Scope and limitations

// [ONE PARAGRAPH naming what is *out* of scope. Suggested content:

// This thesis delivers the segmentation pipeline; downstream 
// quantitative analysis (vessel length distributions, branching 
// ratios, tortuosity computation) is left to existing tools 
// such as SKAN that operate on the binary masks the plugin 
// exports. Comparison with deep-learning baselines is not 
// performed because annotated training data sufficient for 
// fair comparison is not available. Evaluation focuses on the 
// laboratory's own data; cross-laboratory generalization is 
// identified as future work. The plugin is not a clinical tool 
// and is not intended for clinical use.]





















// // This is the (bad) draft
// The task at hand requires analyzing existing collected CECT data that presents challenges in the form of gradients, disconnected vessels and low contrast, by means of a user friendly piece of software. This software must be re-usable and fit into the wider ecosystem of open source tools for working on 3D data being implemented as an extension of 3D Slicer


// The task at hand covers a multistep pipeline with three key stakeholders: 
// - future end users of the tool on different data
// - the wider scientific community for whom replicability and extensibility matter, and 
// - computer science researchers, for whom algorithm development and performance is the goal.

// #linebreak()
// From this, the following problem statement is obtained:

// #linebreak()
// *TODO revisit*: How may a software pipeline for the segmentation and extraction of blood vessel networks from CECT images be designed, such that it is accessible and usable by domain scientists such as biologists, for whom software is not a primary tool (*Problem 1*), where the software is robust to the challenges of CECT: intensity gradients and variable contrast levels, without requiring dataset-specific hyper parameter tuning (*Problem 2, 4.2, 4.3*), capable of producing outputs in portable binary masks for use downstream (*Problem 3.1*), that is evaluated in a robust replicable fashion (*Problem 3.2*, *Problem 4.1*)?

// == Problem resolution approach <prob_statement>

// The following is proposed to approach the problem:
// 1. Use 3DSlicer @3Dslicer_paper, an open source, extendable software as a basis for a plugin
// 2. Placing the user in the segmentation loop and enforcing data driven hyperparameter selection through the placement of anchors @minimal_path_tubular
// 3. The use of generalist, robust algorithms
// 4. Output in a portable binary segmentation format as individual slices or DICOM 
// 5. The inclusion of user feedback during the development of the plugin

// // #linebreak()
// // Deprecated: A 3DSlicer plugin is developed to offer user friendliness for data loading, saving and manipulation of the extraction pipeline.he segmentation will begin with a simple window thresholding segmentation done by the user or automatically based on the anchor points selected. The algorithm will then attempt to reconnect and grow the segmentation based on its loss functions, region growing and other lower order techniques, with the integration of the priors of vascularization by means of the loss functions used. The user will then be able to export the segmentations into a portable format.

// #figure(
//   image("../../resources/images/msc_thesis_try1_09-03-26.png", width: 100%),
//   caption: [Preliminary synthesized diagram for the annotation of vascularization and sharing of results],
// ) <use_flow>

// // Is a diagram relevant? Does not seem to add much to the article.