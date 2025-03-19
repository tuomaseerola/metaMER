// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}

//#assert(sys.version.at(1) >= 11 or sys.version.at(0) > 0, message: "This template requires Typst Version 0.11.0 or higher. The version of Quarto you are using uses Typst version is " + str(sys.version.at(0)) + "." + str(sys.version.at(1)) + "." + str(sys.version.at(2)) + ". You will need to upgrade to Quarto 1.5 or higher to use apaquarto-typst.")

// counts how many appendixes there are
#let appendixcounter = counter("appendix")
// make latex logo
// https://github.com/typst/typst/discussions/1732#discussioncomment-6566999
#let TeX = style(styles => {
  set text(font: ("New Computer Modern", "Times", "Times New Roman"))
  let e = measure("E", styles)
  let T = "T"
  let E = text(1em, baseline: e.height * 0.31, "E")
  let X = "X"
  box(T + h(-0.15em) + E + h(-0.125em) + X)
})
#let LaTeX = style(styles => {
  set text(font: ("New Computer Modern", "Times", "Times New Roman"))
  let a-size = 0.66em
  let l = measure("L", styles)
  let a = measure(text(a-size, "A"), styles)
  let L = "L"
  let A = box(scale(x: 105%, text(a-size, baseline: a.height - l.height, "A")))
  box(L + h(-a.width * 0.67) + A + h(-a.width * 0.25) + TeX)
})

#let firstlineindent=0.5in

// documentmode: man
#let man(
  title: none,
  runninghead: none,
  margin: (x: 1in, y: 1in),
  paper: "us-letter",
  font: ("Times", "Times New Roman"),
  fontsize: 12pt,
  leading: 18pt,
  spacing: 18pt,
  firstlineindent: 0.5in,
  toc: false,
  lang: "en",
  cols: 1,
  doc,
) = {

  set page(
    margin: margin,
    paper: paper,
    header-ascent: 50%,
    header: grid(
      columns: (9fr, 1fr),
      align(left)[#upper[#runninghead]],
      align(right)[#counter(page).display()]
    )
  )


 
if sys.version.at(1) >= 11 or sys.version.at(0) > 0 {
  set table(    
    stroke: (x, y) => (
        top: if y <= 1 { 0.5pt } else { 0pt },
        bottom: .5pt,
      )
  )
}
  set par(
    justify: false, 
    leading: leading,
    first-line-indent: firstlineindent
  )

  // Also "leading" space between paragraphs
  set block(spacing: spacing, above: spacing, below: spacing)

  set text(
    font: font,
    size: fontsize,
    lang: lang
  )

  show link: set text(blue)

  show quote: set pad(x: 0.5in)
  show quote: set par(leading: leading)
  show quote: set block(spacing: spacing, above: spacing, below: spacing)
  // show LaTeX
  show "TeX": TeX
  show "LaTeX": LaTeX

  // format figure captions
  show figure.where(kind: "quarto-float-fig"): it => [
    #if int(appendixcounter.display().at(0)) > 0 [
      #heading(level: 2, outlined: false)[#it.supplement #appendixcounter.display("A")#it.counter.display()]
    ] else [
      #heading(level: 2, outlined: false)[#it.supplement #it.counter.display()]
    ]
    #par[#emph[#it.caption.body]]
    #align(center)[#it.body]
  ]
  
  // format table captions
  show figure.where(kind: "quarto-float-tbl"): it => [
    #if int(appendixcounter.display().at(0)) > 0 [
      #heading(level: 2, outlined: false)[#it.supplement #appendixcounter.display("A")#it.counter.display()]
    ] else [
      #heading(level: 2, outlined: false)[#it.supplement #it.counter.display()]
    ]
    #par[#emph[#it.caption.body]]
    #block[#it.body]
  ]

 // Redefine headings up to level 5 
  show heading.where(
    level: 1
  ): it => block(width: 100%, below: leading, above: leading)[
    #set align(center)
    #set text(size: fontsize)
    #it.body
  ]
  
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: leading, above: leading)[
    #set align(left)
    #set text(size: fontsize)
    #it.body
  ]
  
  show heading.where(
    level: 3
  ): it => block(width: 100%, below: leading, above: leading)[
    #set align(left)
    #set text(size: fontsize, style: "italic")
    #it.body
  ]

  show heading.where(
    level: 4
  ): it => text(
    size: 1em,
    weight: "bold",
    it.body
  )

  show heading.where(
    level: 5
  ): it => text(
    size: 1em,
    weight: "bold",
    style: "italic",
    it.body
  )

  if cols == 1 {
    doc
  } else {
    columns(cols, gutter: 4%, doc)
  }


}


#show: document => man(
  runninghead: "META-ANALYSIS OF MUSIC EMOTION RECOGNITION",
  lang: "en",
  document,
)

\
\
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
A Meta-Analysis of Music Emotion Recognition Studies
]
)
]
#set align(center)
#block[
\
Tuomas Eerola#super[1] and Cameron J. Anderson#super[2]

#super[1];Department of Music, Durham University

#super[2];Department of Psychology, Neuroscience & Behaviour, McMaster University

]
#set align(left)
\
\
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
Author Note
]
)
]
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
Tuomas Eerola #box(image("_extensions/wjschne/apaquarto/ORCID-iD_icon-vector.svg", width: 4.23mm)) https:\/\/orcid.org/0000-0002-2896-929X

Cameron J. Anderson #box(image("_extensions/wjschne/apaquarto/ORCID-iD_icon-vector.svg", width: 4.23mm)) https:\/\/orcid.org/0000-0002-4334-5696

Author roles were classified using the Contributor Role Taxonomy (CRediT; https:\/\/credit.niso.org/) as follows: #emph[Tuomas Eerola];#strong[: ];conceptualization, methodology, formal analysis, and writing – original draft. #emph[Cameron J. Anderson];#strong[: ];data curation, formal analysis, and writing – original draft

Correspondence concerning this article should be addressed to Tuomas Eerola, Department of Music, Durham University, Palace Green, Durham, Durham DH1 3DA, United Kingdom, Email: tuomas.eerola\@durham.ac.uk

#pagebreak()

#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
Abstract
]
)
]
#block[
This meta-analysis examines music emotion recognition (MER) models published between 2014 and 2024, focusing on predictions of valence, arousal, and categorical emotions. A total of 553 studies were identified, of which 96 full-text articles were assessed, resulting in a final review of 34 studies. These studies reported 204 models, including 86 for emotion classification and 204 for regression. Using the best-performing model from each study, we found that valence and arousal were predicted with reasonable accuracy (r = 0.67 and r = 0.81, respectively), while classification models achieved an accuracy of 0.87 as measured with Matthews correlation coefficient. Across modeling approaches, linear and tree-based methods generally outperformed neural networks in regression tasks, whereas neural networks and support vector machines (SVMs) showed highest performance in classification tasks. We highlight key recommendations for future MER research, emphasizing the need for greater transparency, feature validation, and standardized reporting to improve comparability across studies.

]
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
#emph[Keywords];: music, emotion, recognition, computational, model, meta-analysis

#pagebreak()

#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
A Meta-Analysis of Music Emotion Recognition Studies
]
)
]
= Introduction
<introduction>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
Emotional engagement is a key reason why people engage with music in their every day activities, and it is also why music is increasingly being used in various health applications (#link(<ref-agres2021music>)[Agres et al., 2021];; #link(<ref-juslin2022emotions>)[Juslin et al., 2022];).

= Methods
<methods>
#figure([
#box(image("figure1.svg", width: 4.1666666666667in))
], caption: figure.caption(
position: bottom, 
[
Flowchart of the study inclusions/eliminations.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


= Results
<results>
#block[
#table(
stroke: none,
table.hline(start: 0),
  columns: (15.49%, 39.44%, 36.62%, 8.45%),
  align: (left,left,left,left,),
  table.header([Info], [Regression], [Classification], [Total],),
  table.hline(start: 0),
  [Study N], [22], [12], [34],
  [Model N], [204], [86], [290],
  [Techniques], [Neural Nets: 64], [21], [85],
  [Techniques], [Support Vector Machines: 62], [26], [88],
  [Techniques], [Linear Methods: 62], [19], [81],
  [Techniques], [Tree-based Methods: 14], [16], [30],
  [Techniques], [KS, Add. & KNN: 2], [4], [6],
  [Feature N], [Min=3, Md=653, Max=14460], [Min=6, Md=98, Max=8904], [NA],
  [Stimulus N], [Min=20, Md=324, Max=2486], [Min=124, Md=300, Max=5192], [NA],
table.hline(start: 0),
)
]
#figure([
#box(image("manuscript-apaquarto_files/figure-typst/fig2-1.svg"))
], caption: figure.caption(
position: bottom, 
[
Forest plot of the best valence models from all MER studies.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#figure([
#box(image("manuscript-apaquarto_files/figure-typst/fig3-1.svg"))
], caption: figure.caption(
position: bottom, 
[
Forest plot of the best arousal models from all MER studies.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#figure([
#box(image("manuscript-apaquarto_files/figure-typst/fig4-1.svg"))
], caption: figure.caption(
position: bottom, 
[
Forest plot of the best classification models from all MER studies.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


= Discussion and conclusions
<discussion-and-conclusions>
=== Funding statement
<funding-statement>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
CA was funded by Mitacs Globalink Research Award (Mitacs & British High Commission - Ottawa, Canada).

=== Competing interests statement
<competing-interests-statement>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
There were no competing interests.

=== Open practices statement
<open-practices-statement>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
Study preregistration, data, analysis scripts and supporting information is available at GitHub, #link("https://tuomaseerola.github.io/metaMER");.

= References
<references>
#set par(first-line-indent: 0in, hanging-indent: 0.5in)
#block[
#block[
Agres, K. R., Schaefer, R. S., Volk, A., Van Hooren, S., Holzapfel, A., Dalla Bella, S., Müller, M., De Witte, M., Herremans, D., Ramirez Melendez, R., et al. (2021). Music, computing, and health: A roadmap for the current and future roles of music technology for health care and well-being. #emph[Music & Science];, #emph[4];, 2059204321997709.

] <ref-agres2021music>
#block[
Juslin, P. N., Sakka, L. S., Barradas, G. T., & Lartillot, O. (2022). Emotions, mechanisms, and individual differences in music listening: A stratified random sampling approach. #emph[Music Perception: An Interdisciplinary Journal];, #emph[40];(1), 55–86.

] <ref-juslin2022emotions>
] <refs>
#set par(first-line-indent: 0.5in, hanging-indent: 0in)


 
  
#set bibliography(style: "_extensions/wjschne/apaquarto/apa.csl") 


