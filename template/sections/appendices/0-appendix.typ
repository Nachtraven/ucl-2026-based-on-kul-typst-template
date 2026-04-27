= Appendices

== Environmental and CO2 impact of the thesis

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

== Instructions for scientific rigor in data handling

// Talk about naming conventions, data versionning methods and saving

== Use of LLMs and AIs <llm_and_ai>

// Discuss claude code and closing the loop of coding, how it can be used to achieve more in a shorter time but still requiring compsci to guide and structure things

The main two AI assistants used in this thesis were Piccolo, offered by UCLouvain and used for writing feedback, and ClaudeCode, by Anthropic, for the expansion and creation of the plugin.



== Structuring a Masters thesis

// Link the video and writing techniques
During the preparation, reading and writing phases of the masters thesis, it was particularly challenging to both understand what is expected as well as the techniques needed for writing scientifically. This process of learning to write a scientific article has been challenging as well as rewarding, but required extensive effort to document and learn beyond what was offered by the official UCLouvain Masters thesis page.

// https://writingcenter.fas.harvard.edu/thesis
// https://www.youtube.com/watch?v=pM6orL-bGDc
The writer strongly recommends the _Harvard College Writing Center_'s recommendations for thesis writing, as well as the talk _How to write your PhD thesis (without going insane)_ by James Hayton.



== Masters thesis writing across group and field boundaries

As is all too common, it is easy when experience is lacking to over estimate ones capabilities, as well as the ease of solving (or even working on) a particular problem. The concept of a thesis across field boundaries was initiated by the writer motivated by the wish to grow a skillset beyond what is usually developped when carrying out a thesis within ones field, as well as by a desire for real world impact through applying computer science skills to a problem where the limitations are mainly technical.

This theis was particularly challenging as a result, not due to educational or technical reasons, but mainly due to the practical issues one faces when attempting to solve a real problem: unclear or varying goals and measurements for success, a misunderstanding by the engineer of the field in which the software is to be used, as well as the friction induced by having many stakeholders. These three points will be unpacked one by one:

=== Setting clear goals



=== Field knowledge and problem encapsulation



=== Stakeholders 

// Talk about working with two sets of goals under two people with different requirements, the importance of going towards code fast, the reasoning why biologists do thorough research first vs computer science (the cost for compsci is 0 so better have a broader experience, and compsci methods suffer from poor replicability over time)



// The baseline is providing simple instructions, or nothing at all, and requiring an output, relying on the priors of the student.
// Level above is providing examples of various difficulty and letting the student extract from it the structure they build upon, as well as what is and isn't relevant or important
// Above that is providing the relevant structures, their specificties, and showing how particular examples depart from the structure for more advanced topics or situations, and what this reveals

// In the age of AI, when we only provide lower order, the student falls back to AI to provide these higher order structures, which suffer from bias or priors that don't align with the proprities of the 


= Extra figures

// #figure(
//   image("../../../resources/misc/uncompressed_image_folder_sizes.png"),
//   caption: [Visualization of the raw dataset sizes, obtained by multiplying width, height and depth by 8 bits per pixel],
// ) <uncompressed_dataset_size>