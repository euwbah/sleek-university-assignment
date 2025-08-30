#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1" as plot
#import "@preview/diverential:0.2.0": *
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/fontawesome:0.5.0": *
// Don't import question, it interferes with the docs of the assignment question method below
#import "@euwbah/gentle-clues:1.2.0": abstract, clue, code, conclusion, danger, error, example, experiment, goal, idea, info, memo, notify, quotation, success, task, tip, warning, gentle-clues
#import "@preview/grayness:0.3.0": *
#import "@euwbah/intextual:0.1.1": *
#import "@preview/lemmify:0.1.8": default-theorems, new-theorems
#import "@preview/mannot:0.3.0": *
#import "@preview/matset:0.1.0": *
#import "@euwbah/physica:0.9.5": *
#import "@preview/pinit:0.2.2": *
#import "@preview/plotsy-3d:0.1.0" as plotsy
#import "@preview/showybox:2.0.4": *
#import "@preview/xarrow:0.3.1": *

#let euwbah-thm-ref-style(
  thm-type,
  thm-numbering,
  ref
) = link(ref.target, box[#{
  assert(
    ref.element.numbering != none,
    message: "cannot reference theorem without numbering"
  )

  let supplement = if ref.citation.supplement != none {
    let use-supplement = ref.citation.supplement
    // Use @label[s] to automatically turn into plural/singular
    if ref.element.caption != none and ref.element.caption.body != none {
      use-supplement = if use-supplement == [s] {
        ref.element.caption.body + "s"
      } else if use-supplement == [es] {
        ref.element.caption.body + "es"
      } else if ref.element.caption.body.at("text", default: none) != none {
        let original = ref.element.caption.body.text
        // context-based plurals/singulars
        if use-supplement == [i] {
          // cactus -> cacti, modulus -> moduli
          original.replace(regex("[uU][sS]$"), "i")
        } else if use-supplement == [us] {
          // inverse of above
          original.replace(regex("[yYiI]$", "us"))
        } else if use-supplement == [ies] {
          // city -> cities, puppy -> puppies
          original.slice(0, -1) + "ies"
        } else if use-supplement == [a] {
          // bacterium -> bacteria, criterion -> criteria
          original.slice(0,-2) + "a"
        } else if use-supplement == [um] or use-supplement == [on] {
          // inverse of above
          original.slice(0, -1) + use-supplement
        } else if use-supplement == [ves] {
          original.replace(regex("[fF][eE]?$", "ves"))
        }
        else {
          use-supplement
        }
      } else {
        use-supplement
      }
    }
    use-supplement
  } else if ref.element.caption != none and ref.element.caption.body != none {
    ref.element.caption.body
  } else {
    thm-type
  }

  supplement

  if supplement != [] {
    " "
  }

  "(" + thm-numbering(ref.element) + ")"
}])

#let (
  theorem, proposition, lemma, corollary, definition, example, proof, remark, rules: thm-rules
) = default-theorems(
  "thm-group",
  lang: "en",
  ref-styling: euwbah-thm-ref-style
)

#let (
  algorithm, rules: custom-thm-rules
) = new-theorems(
  "thm-group",
  ("algorithm": [Algorithm]),
  ref-styling: euwbah-thm-ref-style
)

#let assignment(
  title: none,
  authors: (),
  university-logo: none,
  course: none,
  helpsheet-mode: false,
  body,
) = {
  set page(
    paper: "a4",
    margin: if helpsheet-mode {
      (top: 0.3in, right: 0.3in, bottom: 0.3in, left: 0.3in)
    } else {
      (top: 0.5in, right: 1in, bottom: 0.5in, left: 1in)
    },
    header: context {
      if counter(page).get().first() > 1 and not helpsheet-mode [
        #title
        #h(1fr)
        #counter(page).display()
      ]
    },
    footer: context {
      if counter(page).get().first() > 1 {
        align(right, course)
      }
    },
  )
  let fontsize = if helpsheet-mode {
    9pt
  } else {
    11pt
  }
  set text(fontsize, font: "Libertinus Serif")
  set list(indent: 4pt)
  set enum(numbering: "1.a.i.")
  set raw(syntaxes: "./syntax/console.sublime-syntax")
  set heading(numbering: "1.1.")
  set figure(numbering: "1")
  show heading: body => {
    set block(below: 1em)
    body
  }
  show raw: set text(font: "Fira Code", ligatures: true)

  grid(
    columns: (auto, 1fr),
    {
      if helpsheet-mode {
        emph(course)
        h(1fr)
        strong(text(1em, title))
        linebreak()

        for author in authors [
          #text(1.1em, upper(author.name), font: "Fira Sans"), #link("mailto:" + author.email), #author.student-no \
        ]
      } else {
        emph(course)
        v(-0.4em)
        strong(text(2em, title))
        linebreak()
        v(0.5em)

        for author in authors [
          #text(1.1em, upper(author.name), font: "Fira Sans"), #link("mailto:" + author.email), #author.student-no \
        ]
        if authors != () {
          v(0.5em)
        }
      }
    },
    align(
      right,
      if university-logo != none {
        box(height: 3em, university-logo)
      },
    ),
  )

  set par(justify: true)
  show figure: align.with(center)
  // show figure: set text(8pt)
  show figure.caption: pad.with(x: 10%)

  show: thm-rules

  show: custom-thm-rules

  show: euwbah-formatting

  let math-eqn-block-params = if helpsheet-mode {
    (above: 1em, below: 1em, breakable: true)
  } else {
    (breakable: true)
  }

  show math.equation: set block(..math-eqn-block-params)

  show: intertext-rule

  // In lists/enums, math equations only take up the maximum width of the box's contents (i.e.,
  // widest list/enum item), instead of the full width of the parent container. This fixes that.
  //
  // NOTE: There is no longer any need for the show rule below, since the intertext-rule does the
  // same thing.
  /*
  show math.equation.where(block: true): eq => {
    block(width: 100%, height: 0em, above: 0em, below: 0em)
    eq
  }
  */

  show: gentle-clues.with(
    title-font: "Lucida Sans",
    breakable: true,
  )

  body
}

/// Create a question box.
///
/// Uses kind: "question" figures, these can be referenced with a label.
///
/// E.g., if you want to reset the counter use `update-qn-counter`
///
/// - title (str | content): Custom Question title (defaults to "Question #N")
/// - body (content): Content of question
/// -> figure
#let question(title: none, ..body) = figure(
  {
    if title == none {
      showybox(title: context[Question #counter(figure.where(kind: "question")).display("1")], above: 2.5em, ..body)
    } else {
      showybox(title: title, above: 2.5em, ..body)
    }
  },
  kind: "question",
  supplement: "Question",
  numbering: "1"
)

/// Update question counter
///
/// - to (number | function): input: current question counter, output: updated question counter
/// ->
#let update-qn-counter(to) = {
  counter(figure.where(kind: "question")).update(to)
}

#let questionparts(numbering: "(a)", spacing: 1.5em, ..body) = {
  enum(numbering: numbering, spacing: spacing, ..body)
}
#let subparts(..body) = {
  questionparts(numbering: "(i)", ..body)
}

/// Helper function to emphasise a definition/point in helpsheet mode.
#let defn(body) = {
  text(1em, strong(body), font: "Fira Sans")
}

/// Cancel out content with an arrow pointing to the value it cancels to
///
/// Similar to LaTeX's \cancelto form the cancel package.
///
/// - body (content): Content to cancel out
/// - to (content): Content to cancel to
/// - cancel-stroke (stroke): Stroke for cancellation line
/// - arrow-stroke (stroke): Stroke for arrowhead mark. If `auto`, set same as `cancel-stroke`.
/// -> content
#let cancelto(body, to, cancel-stroke: 0.8pt, arrow-stroke: auto) = {
  $mark(body, tag: #<cancel-body>)$

  // NOTE: default 1 unit in CeTZ is 1cm.
  annot-cetz(
    <cancel-body>,
    cetz,
    {
      import cetz.draw: *
      if arrow-stroke == auto {
        arrow-stroke = cancel-stroke
      }
      set-style(mark: (end: "straight", stroke: arrow-stroke, scale: 0.8))
      line((rel: (0,-0.05), to: "cancel-body.south-west"), (rel: (0,0.05), to: "cancel-body.north-east"), name: "cancel-line", stroke: cancel-stroke)
      content((rel: (0.1,0), to: "cancel-line.end"), to, anchor: "south-west")
    }
  )
}