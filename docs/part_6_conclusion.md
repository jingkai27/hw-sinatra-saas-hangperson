------------

This assignment has served as a microcosm or miniature tour of the entire course: during the rest of the course we will investigate each of these in much more detail, and we will also add new techniques---

* *Test-driven development (TDD)* will let you write much more detailed tests for your code and determine its **coverage**, that is, how thoroughly your tests exercise your code.  We will use **RSpec** to do test-first development, in which we write tests before we write the code, watch the test fail ("red"), quickly write just enough code to make the test pass ("green"), clean up (refactor) the code, and go on to the next test.  We will use the `autotest` tool to help us get into a rhythm of red--green--refactor. In this assignment we provided the specs for you; when designing your own app, you'll write them yourself.

* *Code metrics* will give us insight into the quality of our code: is it concise?  Is it factored in a way that minimizes the cost of making changes and enhancements?  Does a particular class try to do too much (or too little)?  We will use **CodeClimate** (among other tools) to help us understand the answers.  We can check both quantitative metrics, such as test coverage and complexity of a single method, and qualitative ones, such as adherence to the *SOLID Principles* of object-oriented design.

* *Refactoring* means modifying the structure of your code to improve its quality (maintainability, readability, modifiability) while preserving its behavior.  We will learn to identify *antipatterns* -- warning signs of deteriorating quality in your code -- and opportunities to fix them, sometimes by applying *design patterns* that have emerged as "templates" capturing an effective solution to a class of similar problems. 

One last thing before you end the assignment is to delete your Google Cloud resources. This will ensure that you do not exceed the credits given to you. Follow the steps below.
* Go to "IAM & Admin" -> "Manage Resources".
* Click the project name to select which project to delete
* Click the DELETE button on the top right of the page
![](https://www.dropbox.com/s/3ijcl7zil6bsv92/Delete_resources.png?raw=1)
