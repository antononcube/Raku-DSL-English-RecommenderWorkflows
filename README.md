# Recommenders Workflows 

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken commands that specify Recommenders workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

The generated pipelines are for the software monads
[`SMRMon-R`](https://github.com/antononcube/R-packages/tree/master/SMRMon-R) 
and
[`SMRMon-WL`](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m),
\[AA1, AA2\].

("SMR" stands for "Sparse Matrix Recommender".) 

## Installation

**1.** Install Raku (Perl 6) : https://raku.org/downloads . 

**2.** Make sure you have Zef Module Installer. 
 
   - Type in `zef` in the command line.
   - You can install the Zef Module Installer from : https://github.com/ugexe/zef .

**3.** Open a command line program. (E.g. Terminal on Mac OS X.)

**4.** Run the commands:

```
zef install https://github.com/antononcube/Raku-DSL-Shared.git
zef install https://github.com/antononcube/Raku-DSL-English-RecommenderWorkflows.git
```

## Examples

Open a Raku IDE or type `raku` in the command line program. Try this Raku code:

```raku
use DSL::English::RecommenderWorkflows;

say ToRecommenderWorkflowCode("recommend by profile action->10, drama->7", "R-SMRMon");
# SMRMonRecommendByProfile( profile = c( "action"=10, "drama"=7))
``` 
    
Here is a more complicated pipeline specification:

```raku
say ToRecommenderWorkflowCode(
    "create from dfTitanic; 
     apply the LSI functions inverse document frequency, term frequency, and cosine;
     recommend by profile female->3, 30->0.1; 
     extend recommendations with dfTitanic; 
     show pipeline value", "R-SMRMon" )
```

The command above should print out R code for the R package `SMRMon-R`, \[AA1\]:

```r
SMRMonCreate( data = dfTitanic) %>%
SMRMonApplyTermWeightFunctions(globalWeightFunction = "IDF", localWeightFunction = "TermFrequency", normalizerFunction = "Cosine") %>%
SMRMonRecommendByProfile( profile = c( "female"=3, "30"=0.1)) %>%
SMRMonJoinAcross( data = dfTitanic) %>%
SMRMonEchoValue()
```    

## Versions

The original version of this Raku package was developed/hosted at 
\[ [AA3](https://github.com/antononcube/ConversationalAgents/tree/master/Packages/Perl6/RecommenderWorkflows) \].

A dedicated GitHub repository was made in order to make the installation with Raku's `zef` more direct. 
(As shown above.)

## References

\[AA1\] Anton Antonov,
[Sparse Matrix Recommender Monad in R](https://github.com/antononcube/R-packages/tree/master/SMRMon-R),
(2019),
[R-packages at GitHub](https://github.com/antononcube/R-packages).

\[AA2\] Anton Antonov,
[Monadic Sparse Matrix Recommender Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicSparseMatrixRecommender.m),
(2018),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

\[AA3\] Anton Antonov, 
[Recommender Workflows Raku Package](https://github.com/antononcube/ConversationalAgents/tree/master/Packages/Perl6/RecommenderWorkflows), 
(2019),
[ConversationalAgents at GitHub](https://github.com/antononcube/ConversationalAgents).