// 1. Deliver a user-friendly 3D Slicer extension.
// 2. Leverage a user-in-the-loop approach for point placement & basic vessel-size context to drive automated parameter selection, replacing manual error-prone hyperparameter tuning.
// 3. Build the segmentation core on multiple algorithms, combined through an evidence accumulating framework that enables per component tuning.
// 4. Identify through ablation the most relevant components to control runtime and avoid overly complex algorithms
// 5. Export useful segmentations for downstream analysis

= Conclusion and future perspectives

Restate the problem and aim


The work laid out in this thesis set out to bring a user friendly segmentation tool for the extraction of low contrast blood vessels from 3D CECT data. The final software is usable in 3D Slicer, a free open source software without needing to know how to code to able to extract vessels effectively. The algorithm implemented is robust to small disconnections, and reconstructs plausible networks across different challenging scenarios without requiring extensive user modification of the segmentation.

The initial goal, being very wide in scope and problem definition, is naturally satisfied within certain constraints: the memory limitations as well as the implementation of 3D Slicer restricts analysis to smaller volumes, with the step of tiling taken to mitigate this. The output 2D Slices still require downstream analysis by an expert and specialized software to enable extraction of more detailed clinical results, and the user adjustable hyperparameters still require the user to interact and iteratively act as a member of the pipeline, injecting some subjectivity and bias. 

The final software is modular and easily extensible, and the current work opens the door towards future collaboration between departments on challenging analysis tasks.



== Summary of contributions

Summarise what was achieved -> the plugin, the annotation, the testing



== Limitations

-> discuss what is an issue, mainly the inference size and the memory use/cpu time
-> also discuss limitation on annotation and resulting evaluation



== Future work

The principal improvements for future work lay in three main directions:

1. Evaluation: improving the outputs of the pipeline to offer a fully open source analysis pipeline of the clinically relevant parameters interesting to researchers of the lab for comparing tumor vasculatures
2. Efficiency: streamlining of the software to enable running on entire volumes by either improving 3DSlicer itself or running outside of 3D Slicer. Inference times could also be shortened by using C++ implementations or GPU programming.
3. Performance: thanks to the extraction process improvements, it could be relevant to use the tool to extract sufficient volumes of data to train a segmentation model, which could act as a form of "normalization" by integrating more diversity into the model than what is able to be captured by these fixed hyperparameters. Performance improvements could also be explored by changing or updating the model steps.

//Talk about the scissors analogy

=== Evaluation and clinical utility

Multi-user annotation and inter-annotator agreement

=== Scalability and performance

=== Towards learning-based extensions




// Prospective users were involved and interviewed during development, but it is challenging to change an established protocol.



// It bears to mention that the data used during this thesis is both challenging due to real limitations of CECT as well as due to limitations at the time of collection: having been obtained in 2016, techniques and knowledge has advanced, potentially paliating the shortcomings of some of the data issues faced here. 


// Running inference on GPU
// Training machine learning