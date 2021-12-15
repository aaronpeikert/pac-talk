Overarching claim/ Conclusion: Traditional Preregistrations add too little value to empirical research for the required investment.

# Problem 1 --- Reading a Preregistration

## Arguments

```
Claim 1: Preregistrations are difficult to consume.
  Reason 1.1: Because preregistrations vary in their detail/vagueness.
    Reason 1.1.2: Because even the most detailed preregistration is multiinterpretable
      Evidence 1.1.2.1: Wilcox Test vs t.test on ranks
    Evidence 1.2: Todo: survey preregistrations for their length.
  Reason 1.2: Their success is difficult to judge.
    Evidence 1.2.1: Todo: Criteria for Badges vary
    Reason/Cause 1.2.1: Because Preregistrations are difficult to compare with the final manuscript.
      Evidence 1.2.1.1: Anecdotal: How many people actually read a preregistration and to compare it to the manuscript?
      Limitation 1.2.1.1: There is to date no comprehensive empirical data on how difficult researcher find it
      Evidence 1.2.1.2: 
      Todo: Find representative example of preregistration vs manuscript.
```

## Solution

Solution 1: Use code instead of natural language and track it with version control.

### Is the solution feasible?

Researchers write code to analyze their data anyway.

### Does the solution costs less than the problem?

The credibility of psychological research is under attack, yet the remedie "preregistration" falls short of its promises. It is difficult to extract value from traditional preregistrations but they require a lot of effort.

### Will the solution create a problem?

It could diminish the value of preregistration and punish trivial deviations.

## Limitations

Limitation 1.1: Researcher should still summarize what they changed for their reader.
Limitation 1.2: The solution is not new and has not been widely adopted.
  Acknowledgement 1.2.1: True, but see extension.
  Rebuke 1.2.2: Open Science is a quickly evolving field.
Alternative 1.3: Integrate the comparison of preregistration and manuscript into the review process.
  Rebuke 1.3.1: Reviewer already donate much of their time to assure correctness.
  Rebuke 1.3.2: Authors are in no position to decide if their deviations are meaningfull.
Limitation 1.4: Much code that never is actually used.

# Problem 2 --- Writing a Preregistration

## Arguments

```
Claim 2: Preregistrations are difficult to produce.
  Reason 2.1: Researcher require training in doing preregistrations.
    Evidence 2.1.1: Todo: Find prereg tutorials.
  Reason 2.2. There are many standards for preregistrations to accommodate different needs and research questions.
    Evidence 2.2.1: Todo: Create comprehensive list of preregistration standards.
  Evidence 2.3: Todo: find survey on how much effort a preregistration is.
```

## Solution

Solution 2: Write dynamic document with code that produces all results based on simulated data.

### Is the solution feasible?

Dynamic document generation is in widespread use for reporting statistical results.
Evidence: Todo: CDC report genereated with jupiter or RMarkdown (or similar)

### Does the solution costs less than the problem?


### Will the solution create a problem?


## Limitations

```
Limitation 2.1: Simulating code is difficult/requires much effort.
  Acknowledgement 2.1.1: Shuffle dependent variables instead.
  Acknowledgement 2.1.2: But can be put to great use: e.g. power analysis
Limitation  2.2: Requires reproducible/reusable workflow
```

Random thought (Andreas): Language -> Code -> Language
