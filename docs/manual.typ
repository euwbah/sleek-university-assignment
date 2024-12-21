#import "@preview/mantys:0.1.4": *

#show: mantys.with(
  name: "university-assignment",
  title: "University Assignment Package",
  subtitle: [Effortlessly write unviersity assignments.],
  authors: "Utkarsh Verma",
  url: "https://github.com/UtkarshVerma/typst-university-assignment",
  license: "MIT",
  version: "0.1.0",
  date: datetime.today(),
  abstract: [
    A clean and simple Typst template for writing university assignments.
  ],
)

= Usage

== Using this package

Just import it inside your `typ` file:

#codesnippet[```typst
  #import "@preview/university-assignment:0.1.0": *
  ```]

== Initialising the template

After importing, initialise the template by applying a `show` rule with the
#cmd[assignment] command and passing the appropriate arguments using `with`:

#codesnippet[```typ
  #show: assignment.with(
    ...
  )
  ```]

#cmd-[assignment] takes in the following arguments:

#command(
  "assignment",

  ..args(
    title: none,
    authors: (),
    university-logo: none,
    course: none,
    [body],
  ),
)[
  #argument(
    "title",
    types: ("content", "str", none),
    default: none,
  )[The assignment title.]
  #argument(
    "course",
    types: ("content", "str", none),
    default: none,
  )[The course name.]
  #argument(
    "authors",
    types: "array",
    default: (),
  )[
    Authors of the assignment. Each author must be specified as a
    #dtype("dictionary") with the following keys:
    - `name`: #dtype("content") | #dtype("str")
    - `email`: #dtype("str"),
    - `student-no`: #dtype("content") | #dtype("str"),
  ]
  #argument(
    "university-logo",
    types: ("content", none),
    default: none,
  )[
    The university logo passed as an image using `#image()`. If provided, it
    will be rendered on the first page.
  ]
]
