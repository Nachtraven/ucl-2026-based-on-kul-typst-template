#import "@preview/modern-se-kul-thesis:0.1.0": template
#show: template.with(
  title: "3D Tumor vascularization reconstruction from MicroCT imaging",
  // subtitle: "With a subtitle",
  academic-year: datetime.today().year(),
  authors: ("Nachtrab Sean"),
  promotors: ("Prof. Greet Kerckhofs","Prof. Sébastien Jodogne",),
  assessors: (
    "Assessor nr 1",
  ),
  supervisors: (
    "A supervisor",
  ),

  // Customize with your own faculty and degree (should be in dutch if you are doing the dutch master)
  degree: (
    elective: "Software engineering",
    master: "SINF - Computer science",
    color: (0, 0, 1, 0),
  ),
  language: "en",
  english-master: true,
  font-size: 11pt,
  // set to true to remove extra title-page and have non-changing margins
  electronic-version: true,
  // Hayagriva bibliography is the default one, if you want to use a
  // BibTeX file, pass a .bib file instead (e.g. "works.bib")
  bibliography: bibliography("references.bib"),
  preface: include "sections/preface.typ",
  abstract: include "sections/main-text/abstract.typ",
  // dutch-summary: include "sections/main-text/dutch-abstract.typ",
  list-of-figures: true,
  list-of-listings: false,
  // abbreviations: include "sections/main-text/list-of-abbreviations-and-symbols.typ",
  symbols: none,
  // appendices: include "sections/appendix/appendix.typ",
  // Make sure that this is the correct logo for the correct master (en/nl)!
  logo: [#image("../resources/1024px-UCLouvain_logo.png")],//[#text(size: 3em, fill: gradient.linear(..color.map.turbo))[Fix logo]],
)

#include "sections/introduction.typ"
#include "sections/state-of-the-art.typ"
