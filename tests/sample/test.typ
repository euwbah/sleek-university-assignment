#import "../../src/lib.typ": assignment

#show: assignment.with(
  title: "Assignment 1",
  course: "CSXXXX: Cryptography",
  authors: (
    (
      name: "John Doe",
      email: "john.doe@example.com",
      student-no: "XX/123",
    ),
  ),

  university-logo: image("./book.svg"),
)

#lorem(1000)
