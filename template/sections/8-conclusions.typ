// 1. Deliver a user-friendly 3D Slicer extension.
// 2. Leverage a user-in-the-loop approach for point placement & basic vessel-size context to drive automated parameter selection, replacing manual error-prone hyperparameter tuning.
// 3. Build the segmentation core on multiple algorithms, combined through an evidence accumulating framework that enables per component tuning.
// 4. Identify through ablation the most relevant components to control runtime and avoid overly complex algorithms
// 5. Export useful segmentations for downstream analysis

= Conclusion and future perspectives

The work laid out in this thesis set out to bring a user friendly segmentation tool for the extraction of low contrast blood vessels from 3D CECT data. The final software is usable without needing to code in a widely available free software and able to extract vessels effectively that are robust to small disconnections, enabling downstream analysis of the parameters. 


The initial goal, being very wide in scope and problem definition, is naturally satisfied within certain constraints: the memory limitations as well as the implementation of 3D Slicer restricts analysis to smaller volumes, with steps taken to mitigate this, the output 2D Slices still require downstream analysis by an expert and specialized software to enable extraction of more detailed clinical results, and the user adjustable hyperparameters still require the user to interact and iteratively act as a member of the pipeline, injecting some subjectivity and bias. Prospective users were involved and interviewed during development, but it is challenging to change an established protocol.

== Future steps

The principal improvements for future work lay in three main points:
1. Evaluation: including in the evaluation step a form of extraction of the clinically relevant parameters interesting to researchers of the lab
2. Efficiency: it could be relevant to develop and streamline the software to be ran outside of 3D Slicer and be able to infer on entire volumes in one step, as opposed to requiring slicing into subregions
3. Performance: thanks to the extraction process improvements, it could be relevant to use the tool to extract sufficient volumes of data to train a segmentation model, which could act as a form of "normalization" by integrating more diversity into the model than what is able to be captured by these fixed hyperparameters.

Talk about the scissors analogy


It bears to mention that the data used during this thesis is both challenging due to real limitations of CECT as well as due to limitations at the time of collection: having been obtained in 2016, techniques and knowledge has advanced, potentially paliating the shortcomings of some of the data issues faced here. 


Running inference on GPU
Training machine learning