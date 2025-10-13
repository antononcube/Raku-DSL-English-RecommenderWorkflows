# Recommenders Workflows 

## In brief

This Raku (Perl 6) package has grammar classes and action classes for the parsing and
interpretation of natural Domain Specific Language (DSL) commands that specify recommendations workflows.

The interpreters (actions) target different programming languages: R, Mathematica, Python, Raku.
Also, different natural languages.

The generated pipelines are for the software monads
["SMRMon-R"](https://github.com/antononcube/R-packages/tree/master/SMRMon-R) and
["SMRMon-WL"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m)
implemented in R and WL respectively, [AAp2, AAp3], and the object-oriented 
[Python](https://pypi.org/project/SparseMatrixRecommender/) 
and 
[Raku](https://raku.land/zef:antononcube/ML::SparseMatrixRecommender) 
implementations [AAp4, AAp5, AAp6].

**Remark:** "SMR" stands for "Sparse Matrix Recommender". "SBR" stands for "Streams Blending Recommender".

**Remark:** "WL" stands for "Wolfram Language". "Mathematica" and "WL" are used as synonyms.

Alternatives of this package are the Raku packages 
["ML::NLPTemplateEngine"](https://raku.land/zef:antononcube/ML::NLPTemplateEngine), [AAp7], and
["DSL::Examples"](https://raku.land/zef:antononcube/DSL::Examples), [AAp8].
Both use LLMs. The former fills-in static code templates. The latter can be used to translate to code 
individual natural language commands. (Like this package.)

------------

## Installation

Zef ecosystem:

```
zef install DSL::English::RecommenderWorkflows
```

GitHub:

```
zef install https://github.com/antononcube/Raku-DSL-English-RecommenderWorkflows.git
```

------------

## Examples

### Programming languages

Here is a simple invocation:

```perl6
use DSL::English::RecommenderWorkflows;

ToRecommenderWorkflowCode('recommend by profile action->10, drama->7', 'R::SMRMon');
``` 

Here is a more complicated pipeline specification used to generate the code
for recommender systems implemented in different languages:

```perl6
my $command = q:to/END/;
create from dfTitanic; 
apply the LSI functions inverse document frequency, term frequency, and cosine;
recommend by profile female->3, 30->0.1; 
extend recommendations with dfTitanic; 
show pipeline value
END

say $_.key, "\n", $_.value, "\n"  for ($_ => ToRecommenderWorkflowCode($command, $_ ) for <R::SMRMon WL::SMRMon Python::SMRMon Raku>);
```

### Natural languages

```perl6
say $_.key, "\n", $_.value, "\n"  for ($_ => ToRecommenderWorkflowCode($command, $_ ) for <Bulgarian English Russian>);
```

------------

## CLI

The package provides a Command Line Interface (CLI) script. Here is its usage message:

```shell
ToRecommenderWorkflowCode --help
```

Here a Raku pipeline is generated:

```shell
ToRecommenderWorkflowCode Raku 'create with dfTitanic; apply the LSI functions IDF, None, Cosine; recommend by profile 1st and male; join across' 
```

------------

## Versions

The original version of this Raku package was developed/hosted at 
[ [AAp3](https://github.com/antononcube/ConversationalAgents/tree/master/Packages/Perl6/RecommenderWorkflows) ].

A dedicated GitHub repository was made in order to make the installation with Raku's `zef` more direct. 
(As shown above.)

------------

## References

[AAp1] Anton Antonov,
[Recommender Workflows Raku Package](https://github.com/antononcube/ConversationalAgents/tree/master/Packages/Perl6/RecommenderWorkflows),
(2019),
[ConversationalAgents at GitHub](https://github.com/antononcube/ConversationalAgents).

[AAp2] Anton Antonov,
[SMRMon-R (Sparse Matrix Recommender Monad in R)](https://github.com/antononcube/R-packages/tree/master/SMRMon-R),
(2019),
[R-packages at GitHub](https://github.com/antononcube/R-packages).

[AAp3] Anton Antonov,
[MonadicSparseMatrixRecommender, WL paclet](https://resources.wolframcloud.com/PacletRepository/resources/AntonAntonov/MonadicSparseMatrixRecommender/),
(2018-2024),
[Wolfram Language Paclet Repository](https://resources.wolframcloud.com/PacletRepository/).

[AAp4] Anton Antonov,
[SparseMatrixRecommender, Python package](https://github.com/antononcube/Python-packages/tree/main/SparseMatrixRecommender),
(2021),
[Python-packages at GitHub](https://github.com/antononcube/Python-packages).

[AAp5] Anton Antonov,
[ML::StreamsBlendingRecommender, Raku package](https://github.com/antononcube/Raku-ML-StreamsBlendingRecommender)
(2021),
[GitHub/antononcube](https://github.com/antononcube).

[AAp6] Anton Antonov,
[ML::SparseMatrixRecommender, Raku package](https://github.com/antononcube/Raku-ML-SparseMatrixRecommender)
(2025),
[GitHub/antononcube](https://github.com/antononcube).

[AAp7] Anton Antonov,
[ML::NLPTemplateEngine, Raku package](https://github.com/antononcube/Raku-ML-NLPTemplateEngine),
(2023-2025),
[GitHub/antononcube](https://github.com/antononcube).
([At raku.land](https://raku.land/zef:antononcube/ML::NLPTemplateEngine)).

[AAp8] Anton Antonov,
[DSL::Examples, Raku package](https://github.com/antononcube/Raku-DSL-Examples),
(2024-2025),
[GitHub/antononcube](https://github.com/antononcube).
([At raku.land](https://raku.land/zef:antononcube/DSL::Examples)).
