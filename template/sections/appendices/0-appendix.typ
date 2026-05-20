
#import "./heatmaps.typ":vessel-heatmap

= Appendices

== List of software for working with 3D data
#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, center),
    stroke: 0.5pt,
    table.header(
      [*Software*], [*License model*], [*Scriptable*],
    ),
    // Commercial
    table.cell(colspan: 3, fill: luma(230))[*Commercial / closed source*],
    [Amira],          [Proprietary, paid],            [Yes],
    [Analyze],        [Proprietary, paid],            [Limited],
    [Aphelion],       [Proprietary, paid],            [Yes],
    [Avizo],          [Proprietary, paid],            [Yes],
    [CTAn / CTVol],   [Proprietary, paid (Bruker)],   [Limited],
    [Dragonfly3D],    [Proprietary; FreED (free, non-commercial)],[Yes (Python)],
    [Image-Pro],      [Proprietary, paid],            [Yes],
    [Imaris],         [Proprietary, paid],            [Yes],
    [MeVisLab],       [Proprietary; free academic],   [Yes],
    [Mimics],         [Proprietary, paid],            [Yes],
    [Octopus],        [Proprietary, paid],            [Limited],
    [ScanIP],         [Proprietary, paid],            [Yes],
    [VG Studio],      [Proprietary, paid],            [Yes],
    [Zeiss Inspect],  [Proprietary, paid],            [Limited],
  ),
) <3d_software>

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, center),
    stroke: 0.5pt,
    table.header(
      [*Software*], [*License model*], [*Scriptable*],
    ),
    // OSS/Freeware
    table.cell(colspan: 3, fill: luma(230))[*Open source / freeware*],
    [3D Slicer],      [BSD (modified)],               [Yes (Python, C++)],
    [Blender],        [GPLv3],                        [Yes (Python)],
    [Chimera / ChimeraX], [Free academic],            [Yes (Python)],
    [Dream3D],        [BSD],                          [Yes],
    [FIJI / ImageJ],  [GPLv2 / Public domain],        [Yes (Java, macros)],
    [IMOD],           [GPLv2],                        [Yes],
    [MeshLab],        [GPLv3],                        [Yes],
    [OsiriX (Lite)],  [LGPL (Lite); proprietary (MD)],[Limited],
    [ParaView],       [BSD],                          [Yes (Python)],
    [SimVascular],    [BSD],                          [Yes],
    [VesselKnife],    [Open source (research)],       [Yes],
    [VisIt],          [BSD],                          [Yes (Python)],

  ),
  caption: [
    Landscape of 3D imaging analysis software relevant to micro-CT vascular work,
    grouped by licensing model. _Scriptable_ indicates if an extension interface exists.
  ],
) <3d_software_oss>


// == CECT dataset performance challenges (TODO: revisit, this was excised from the main text) <performance_and_memory>

// // TODO: Compress/review this
// Data management for Micro-CT scans is a challenge for users: after a scan is completed, they receive data from the CT machine in the form of a collection of 16 bit TIFF files: heavy, with a single 2000x2300 slice at 16bits per pixel weighing *9.2MB*, or as is often the case the data is saved as 3 channels, resulting in 27.6MB, and a whole 2400 slice scan weighing at least *22.1GB*. Scans are then windowed to 8 bit, occasionally with some form of compression, and the empty slices are removed: this generally halves or more the total data amount. This windowing process was documented as being unprincipled: the window was chosen based on the researchers best judgment, and the original uncompressed data discarded.

// #linebreak()
// Furthermore, certain researchers would then carry out a lossy compression of the data in the form of JPEG image slices, as was the case with the data used in this thesis: the total scan weights provided ranged from *0.103* to *13.2GB* (597x698x854 to 3000x3000x2653) and the original lossless data was not preserved, in both cases the windowing and the compression were motivated by data storage cost concerns.

// Finally, the provided data was generally given with little or no context: the data was provided in the form of a folder containing images as well as experiments that were run, with no associated dates and without grounding context such as the scan voxel size or parameters of the scanning machine. These issues of dataset size and compression resulted in challenges unforseen during the literature review which required particular attention.

// // TODO: this is moved from elsewhere, to be reviewed
// #linebreak()
// The total data required for an uncompressed scan can reach into the tens or hundreds of GB. During the initial software evaluation, 3D Slicer was successful in loading all datasets on the development machine - however it was not verified at the time how much memory was being used. The testing of the pipeline on other datasets revealed the performance limitations of the implemented approach: with initial end to end runtime being about an hour and requiring 24GB of system memory, larger datasets saw an increase in inference time to un-manageable levels, as well as limitations of system memory. 

// These performance issues have multiple sources: when implementing a 3D Slicer plugin in python, a single thread is available, and this thread locks all other 3D Slicer activity (this fact extends to other 3D Slicer functions such as loading and saving). When running on a large scan, combined with the generation of probability maps and the sequential algorithms, memory usage exceeded ram, reached into swap, and could run seemingly indefinitely (success was only observed on smaller scans). This is a known issue with 3D Slicer #footnote[Performance limitations as #link("https://discourse.slicer.org/t/title-slow-and-unstable-performance/4988")[discussed on here the forums]].


// TODO: Increasing SWAP size as a mitigation



// #import "@preview/lilaq:0.6.0" as lq
// #let xs = range(9)
// #let ys = (12, 51, 23, 36, 38, 15, 10, 22, 86)

// #lq.diagram(
//   width: 9cm,
//   xaxis: (subticks: none),

//   lq.bar(
//     xs, ys
//   ),

//   ..xs.zip(ys).map(((x, y)) => {
//     let align = if y > 12 { top } else { bottom }
//     lq.place(x, y, pad(0.2em)[#y], align: align)
//   })
// )


// TODO: Re-add these??
// #v(0.5cm)
// #figure(
//   image("../../../resources/misc/uncompressed_image_folder_sizes.png", width:90%),
//   caption: [TODO: This is a placeholder, Add horizontal lines for the RAM of computers. 
  
//   Visualization of the raw dataset sizes, obtained by multiplying width, height and depth by 8 bits per pixel],
// ) <uncompressed_dataset_size>
// #v(0.5cm)

// RAM use: originally discussed in the methodology

// #v(0.5cm)
// #figure(
//   grid(
//     rows: 2,
//     // columns: 2,
//     gutter: 3pt,
//     image("../../../resources/misc/RAM_cpu_use_during_a_run_cropped_ram_only.png", width: 90%),
//     image("../../../resources/misc/RAM-cb-luru-r.png", width: 90%),
//   ),
//   caption: [*Top:* CA-LL-L2 RAM utilization during segmentation: baseline after loading dataset, below 24GB utilization, during processing 100% RAM and swap are used, *Bottom:* CB-LURU-R showing full RAM and SWAP utilization when loaded (no inference)],
// ) <system_performance>
// #v(0.5cm)


// Other 3D Slicer threads about large file loading:
// https://discourse.slicer.org/t/loading-volume-of-several-hundred-gb/35615



#pagebreak()
== Environmental and CO2 impact of the thesis (TODO: revisit)

The main sources of CO2 impact of this thesis are the use of computational resources and the human factor.

1. During the thesis, the laptop of the writer was used: A legion 7i slim with 48GB DDR5, i7-13700H, 8GB RTX4070.
  1. *Production CO2*: The compliance document provided by Lenovo details an estimated carbon footprint of 429g +/- 86g CO2e. For a lifetime of 8 years, and an estimated thesis length of 3 months equivalent full time, this equates to *13.41Kg* CO2e.
  2. *Usage CO2*: The total estimated time dedicated to the coding and writing of the thesis is estimated based on the credits and approximate time investment per credit: 25 credits at 30 hours per credit equates to 750 hours. The laptop was measured over one 2h coding + writing session as using 40.89Wh, equating to a continuous use of 20.45w. This works out to 15.34 kWh, with an estimated Belgian CO2/kWh by the AIB (Association of Issuing Bodies) in 2024 of 131.73 g/kWh, resulting in total emissions of *2.02Kg* CO2.
  3. *AI Utilization*: The impact of LLMs from large providers such as OpenAI is an ongiong research topic and difficult to measure, on top of which are layered issues like the use of Piccolo, UCLouvains aggregation service. A total of TODO credits were used on Piccolo, with an unknown impact. Claude Code was also used, with a total of 3 separate conversations containing TODO 41 cumulative prompts. The impact of AI use is thus left out of the estimation, with a guesstimate bellow.
2. The thesis required meetings, for which the main source of CO2 emissions is the travel to/from Louvain-La-Neuve. This travel was done primarily by train, and the amount of travel directly attributable to the thesis was of 21 round trips, with a distance per trip of 93.2Km at an estimated 16.6g CO2e/Km, equating to *32.49Kg* CO2e.

There was minimal extra data storage required to complete this thesis, however it is important to note that the large files handled do incur emissions if duplicated and stored across devices outside othe users own computer.

The prior calculations equate to a total approximate impact of *47.92 Kg CO2e*.

As for AI - a rough impact is estimated using the computer of the writer as a basis: three of the prompts sent to Piccolo and Claude were sent to the largest local qwen instance fitting in the 8GB GPU, and the time to answer as well as power use while answering estimated: for the three prompts, a total of TODO minutes to answer was required, with a power use of TODO

// TODO: source the above with https://business.engie.be/fr/faq/contrat/emissions-co2/
// https://www.belgiantrain.be/fr/about-sncb/corporate/2026/sncb-carbon-footprint
// https://www.lenovo.com/be/fr/compliance/eco-declaration/

// == Instructions for scientific rigor in data handling

// Talk about naming conventions, data versionning methods and saving


#pagebreak()
== Use of LLMs and AIs <llm_and_ai>

// Discuss claude code and closing the loop of coding, how it can be used to achieve more in a shorter time but still requiring compsci to guide and structure things

The main two AI assistants used in this thesis were Piccolo, offered by UCLouvain and used for writing feedback, and ClaudeCode, by Anthropic, for the expansion and creation of the plugin.

#linebreak()
When using Claude Code, multiple events of note occured:
1. The use of claude code for code audits in performance increases generally resulted in many more code changes and solution adjacent changes. For example, when auditing the code to improve performance on subsampled sections, ClaudeCode carried out over hundreds of minor modifications on top of the proscribed main changes
2. The use of coding assistants (Piccolo and Claude) for scripts to help in data management (subsampling and transformations) often resulted in minor discrepancies in outputs that required manual revision
3. The process of requesting Claude Code to add comments also resulted in a re-organization of the code. Readability improved from the perspective of the writer, but the question of originality remains.
4. AI assistants were exceptionally relevant and helpful for the creation of diverse data visualizations and graphing, as well as the creation of validation loops and tools.

TODO: talk about the branching effect - using models allows exploring more ideas but requires stronger motivation for the pruning of them & selection process   

== Development computer specifications <pc_specs>

*Development computer:*
#linebreak()
Lenovo legion 7i slim, 48GB DDR5, i7-13700H, 8GB RTX4070
#linebreak()
*Laboratory computer provided to students:*
#linebreak()
i7-13700, 32GB, T1000 8GB


// == Data storage and pixel convertion

// During the work, data was provided as JPEGs. This proved to be a repeated issue because of multiple implicit assumptions:
// 1. The data is compressed but only across 2 of the 3 axes
// 2. The data was saved in RGB but is greyscale. Meaning every pixel is the same value three times
// // 3. WRONG this is actually fine: Converting a JPEG from RGB to true greyscale, *if you do not explicitly state that the original was already greyscale*, carries out a luminance weighted average greyscale conversion - another step that modifies the structure of the data. 
// 4. [Minor] 3D Slicer automatically carries out window/level normalization - Visualizations will change based on the pixel values of the loaded data


// == Structuring a Masters thesis

// // Link the video and writing techniques
// During the preparation, reading and writing phases of the masters thesis, it was particularly challenging to both understand what is expected as well as the techniques needed for writing scientifically. This process of learning to write a scientific article has been challenging as well as rewarding, but required extensive effort to document and learn beyond what was offered by the official UCLouvain Masters thesis page.

// // https://writingcenter.fas.harvard.edu/thesis
// // https://www.youtube.com/watch?v=pM6orL-bGDc
// The writer strongly recommends the _Harvard College Writing Center_'s recommendations for thesis writing, as well as the talk _How to write your PhD thesis (without going insane)_ by James Hayton.



// == Masters thesis writing across group and field boundaries

// As is all too common, it is easy when experience is lacking to over estimate ones capabilities, as well as the ease of solving (or even working on) a particular problem. The concept of a thesis across field boundaries was initiated by the writer motivated by the wish to grow a skillset beyond what is usually developed when carrying out a thesis within ones field, as well as by a desire for real world impact through applying computer science skills to a problem where the limitations are mainly technical.

// #linebreak()
// This theis was particularly challenging as a result, not due to educational or technical reasons, but mainly due to the practical issues one faces when attempting to solve a real problem: unclear or varying goals and measurements for success, a misunderstanding by the engineer of the field in which the software is to be used, as well as the friction induced by having many stakeholders. These three points will be unpacked one by one:


// === Setting clear goals



// === Field knowledge and problem encapsulation



// === Stakeholders 

// Talk about working with two sets of goals under two people with different requirements, the importance of going towards code fast, the reasoning why biologists do thorough research first vs computer science (the cost for compsci is 0 so better have a broader experience, and compsci methods suffer from poor replicability over time)



// The baseline is providing simple instructions, or nothing at all, and requiring an output, relying on the priors of the student.
// Level above is providing examples of various difficulty and letting the student extract from it the structure they build upon, as well as what is and isn't relevant or important
// Above that is providing the relevant structures, their specificties, and showing how particular examples depart from the structure for more advanced topics or situations, and what this reveals

// In the age of AI, when we only provide lower order, the student falls back to AI to provide these higher order structures, which suffer from bias or priors that don't align with the proprities of the 


= Extra figures (TODO: revisit)



#v(0.2cm)
#figure(
  grid(
    columns: (auto, auto),
    rows:(auto, auto),
    column-gutter: 2.8em,

    vessel-heatmap(
      csv-paths: (
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      ),

      method: "ground_truth", variant: "",
      title: "Ground Truth",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,           // fix scale so all panels are comparable
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-paths: (
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      ),
      method: "threshold", variant: "best_dice",
      title: "Thresholding",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-paths: (
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv",
        "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      ),
      method: "pipeline", variant: "default",
      title: "Pipeline",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),
  ),
  // TODO: add an image here of the overall stats?
  caption: [Heatmaps of vessel volume/vessel length. A tubular vessel lays on the diagonal, as can be seen in the ground truth and pipeline. Thresholding shows a high density of low volume thin predictions, and a generally smaller distribution of vessel sizes.]
)<fig:appendix_individual_heatmaps>


Individual heatmaps:

#figure(
  grid(
    columns: (auto, auto),
    rows:(auto, auto),
    column-gutter: 2.8em,

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
      method: "ground_truth", variant: "",
      title: "Ground Truth",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,           // fix scale so all panels are comparable
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
      method: "threshold", variant: "best_dice",
      title: "Thresholding",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-L1_x+559_y+604_z+498_experiment.csv",
      method: "pipeline", variant: "default",
      title: "Pipeline",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),
  ),
  caption: [CA-LL-L1 heatmap]
) <fig:heatmaps_ca-ll-l1>


#figure(
  grid(
    columns: (auto, auto),
    rows:(auto, auto),
    column-gutter: 2.8em,

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv",
      method: "ground_truth", variant: "",
      title: "Ground Truth",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,           // fix scale so all panels are comparable
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv",
      method: "threshold", variant: "best_dice",
      title: "Thresholding",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-LL-R_x+298_y+233_z+427_experiment.csv",
      method: "pipeline", variant: "default",
      title: "Pipeline",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),
  ),
  caption: [CA-LL-L1 heatmap]
) <fig:heatmap_ca-ll-r>


#figure(
  grid(
    columns: (auto, auto),
    rows:(auto, auto),
    column-gutter: 2.8em,

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv",
      method: "ground_truth", variant: "",
      title: "Ground Truth",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,           // fix scale so all panels are comparable
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv",
      method: "threshold", variant: "best_dice",
      title: "Thresholding",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_687_y_451_z_666_experiment.csv",
      method: "pipeline", variant: "default",
      title: "Pipeline",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),
  ),
  caption: [CA-LL-L1 heatmap]
) <fig:heatmap_ca-ru-r-666>


#figure(
  grid(
    columns: (auto, auto),
    rows:(auto, auto),
    column-gutter: 2.8em,

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      method: "ground_truth", variant: "",
      title: "Ground Truth",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,           // fix scale so all panels are comparable
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      method: "threshold", variant: "best_dice",
      title: "Thresholding",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),

    vessel-heatmap(
      csv-path: "../../../resources/images/results/vessel_exps_15_may/VESSELS_SLICES_CA-RU-R_x_916_y_901_z_222_experiment.csv",
      method: "pipeline", variant: "default",
      title: "Pipeline",
      x-min: 0.001, x-max: 2.0,
      y-min: 1,     y-max: 5000,
      colour-max: 30,
      x-log: true, y-log: true,
    ),
  ),
  caption: [CA-LL-L1 heatmap]
) <fig:heatmap_ca-ru-r-222>



#figure(
  image("./bipartite/bipartite_ca_ll_l1.svg", width: 90%),
  caption: [CA-LL-L1 Vessel correspondence between pipeline (left), ground truth (center), and thresholding (right). Node size encodes vessel volume, unmatched nodes in grey. Lines show which predicted vessels overlap which GT vessels: 28/35 vessels are matched by the pipeline for 20/35 on the ground truth: the pipeline has better vessel sensitivity. Also visible: the ground truth contains many vessels that are detected as individual smaller vessels by the pipeline or thresholding: predictions are still fragmented.]
)<fig:bipartite_ca-ll-l1>

#figure(
  image("./bipartite/bipartite_ca-ll-r.svg", width: 90%),
  caption: [CA-LL-R ]
)<fig:bipartite_ca-ll-r>

#figure(
  image("./bipartite/bipartite_ca-ru-r_222.svg", width: 90%),
  caption: [CA-RU-R 222]
)<fig:bipartite_ca-ru-r-222>

#figure(
  image("./bipartite/bipartite_ca-ru-r_666.svg", width: 90%),
  caption: [CA-RU-R 666]
)<fig:bipartite_ca-ru-r-666>

















#pagebreak()
#figure(
  image("../../../resources/software/threshold_131_255_example.png", width: 65%),
  caption: [The shortcoming of threshold based segmentation visualized, with a "shell" of high valued outside being included whe the threshold accepts the vessel segment.],
) <fig:thresholding_with_shell>


#figure(
  image("../../../resources/software/bridging_working_cropped.png", width: 65%),
  caption: [Structurally aware gap bridging to reconnect predicted vessels: *Red:* vessels as identified by other steps. *Yellow:* Bridges between tubular endpoints. #footnote[3DSlicer smooths visualizations in 3D without combining different classes. The final segmentaton here is unifrom and continuous.]],
) <fig:gap_bridging>

#v(2.5cm)

#figure(
  image("../../../resources/software/Error_in_external_plugin_VTK_2026-03-30 11-11-14.png", width:90%),
  caption: [Demonstration of one of the failing plugins and the lack of user feedback on what went wrong],
) <error_in_external_plugins>


// #figure(
//   image("../../../resources/software/error_looks_like_vessels_because_of_holes.png"),
//   caption: [Areas of CA-LL-R where vessels are detected because of the black holes around it],
// ) <holes_causing_errors>


// #figure(
//   image("../../../resources/software/imprted_seeds_message.png"),
//   caption: [Import process],
// ) <importing>

// #figure(
//   image("../../../resources/misc/RAM_cpu_use_during_a_run.png"),
//   caption: [RAM and CPU use during a run of the initial pipeline on CA-LL-R showing the efficiency issues that Python and 3D Slicer cause],
// ) <inefficient>

#figure(
  image("../../../resources/misc/RAM_use_large_dataset.png", width:90%),
  caption: [RAM use when loading a large dataset, showcasing the issue with 3D Slicers method of loading data into memory: the entire volume must be kept alive, meaning that other operations are not possible.],
) <large_dataset>