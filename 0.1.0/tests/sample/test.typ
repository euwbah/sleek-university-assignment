#import "../../src/lib.typ": assignment

#show: assignment.with(
  title: "Assignment 1",
  course: "CSXXXX: Programming",
  authors: (
    (
      name: "John Doe",
      email: "john.doe@example.com",
      student-no: "XX/123",
    ),
  ),

  university-logo: image("./book.svg"),
)

== Question

Find the factorial $n!$, of a positive integer $n$.\
The factorial $n!$ is defined as: $ n! eq.def product_"i=1"^n i = 1 times 2 times
... times n $

== Solution

This is a fairly simple problem which can be trivially solved using loops.

```py
fact = 1
for i in range(1, n+1):
	fact *= i

print(fact)
```

We can approach the same thing using recursion also, by exploiting the fact
that $n! = n times (n-1)!$.

```py
def fact(n):
	if n > 1:
		return n*fact(n-1)
	return 1

print(fact(n))
```

Now coming to the main part, we can get our one-liner using the recursive
approach.

```py
def fact(n): return n*fact(n-1) if n > 1 else 1

print(fact(n))
```

#pagebreak()

#lorem(500)
