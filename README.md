# Recommenders Workflows 

## In brief

This Raku (Perl 6) package has grammar classes and action classes for the parsing and
interpretation of natural Domain Specific Language (DSL) commands that specify recommendations workflows.

The interpreters (actions) target different programming languages: R, Mathematica, Python, Raku.
Also, different natural languages.

The generated pipelines are for the software monads
["SMRMon-R"](https://github.com/antononcube/R-packages/tree/master/SMRMon-R) and
["SMRMon-WL"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m)
implemented in R and WL respectively, [AAp2, AAp3], and the object oriented Python and Raku implementations [AAp4, AAp5].

**Remark:** "SMR" stands for "Sparse Matrix Recommender". "SBR" stands for "Streams Blending Recommender".

**Remark:** "WL" stands for "Wolfram Language". "Mathematica" and "WL" are used as synonyms.

------------

## Installation

Zef ecosystem:

```shell
zef install DSL::English::RecommenderWorkflows
```

GitHub:

```shell
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
```
# SMRMonRecommendByProfile( profile = c("action"=10, "drama"=7))
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
```
# R::SMRMon
# SMRMonCreate(data = dfTitanic) %>%
# SMRMonApplyTermWeightFunctions(globalWeightFunction = "IDF", localWeightFunction = "TermFrequency", normalizerFunction = "Cosine") %>%
# SMRMonRecommendByProfile( profile = c("female"=3, "30"=0.1)) %>%
# SMRMonJoinAcross( data = dfTitanic ) %>%
# SMRMonEchoValue()
# 
# WL::SMRMon
# SMRMonUnit[] \[DoubleLongRightArrow] SMRMonCreate[dfTitanic] \[DoubleLongRightArrow]
# SMRMonApplyTermWeightFunctions["GlobalWeightFunction" -> "IDF", "LocalWeightFunction" -> "TermFrequency", "NormalizerFunction" -> "Cosine"] \[DoubleLongRightArrow]
# SMRMonRecommendByProfile[<|"female"->3, "30"->0.1|>] \[DoubleLongRightArrow]
# SMRMonJoinAcross[dfTitanic] \[DoubleLongRightArrow]
# SMRMonEchoValue[]
# 
# Python::SMRMon
# obj = SparseMatrixRecommender().create_from_wide_form(data = dfTitanic).apply_term_weight_functions(global_weight_func = "IDF", local_weight_func = "TermFrequency", normalizer_func = "Cosine").recommend_by_profile( profile = {"female":3, "30":0.1}).join_across( data = dfTitanic ).echo_value()
# 
# Raku
# my $sbrObj = ML::StreamsBlendingRecommender::CoreSBR.new;
# $sbrObj.makeTagInverseIndexesFromWideForm( dfTitanic);
# $sbrObj.applyTermWeightFunctions(globalWeightFunction => "IDF", localWeightFunction = "TermFrequency", normalizerFunction => "Cosine");
# $sbrObj.recommendByProfile( profile => %("female"=>3, "30"=>0.1));
# $sbrObj.joinAcross( dfTitanic );
# say $sbrObj.takeValue
```

### Natural languages

```perl6
say $_.key, "\n", $_.value, "\n"  for ($_ => ToRecommenderWorkflowCode($command, $_ ) for <Bulgarian English Russian>);
```
```
# Bulgarian
# създай с таблицата: dfTitanic
# приложи тегловите функции: глобално-теглова функция: "IDF", локално-теглова функция: "TermFrequency", нормализираща функция: "Cosine"
# препоръчай с профила: {"female":3, "30":0.1}
# напречно съединение с таблицата: dfTitanic
# покажи лентовата стойност
# 
# English
# create with data table: dfTitanic
# apply the term weight functions: global weight function: "IDF", local weight function: "TermFrequency", normalizing function: "Cosine"
# recommend with the profile: {"female":3, "30":0.1}
# join across with the data table: dfTitanic
# show the pipeline value
# 
# Russian
# создать с таблицу: dfTitanic
# применять весовые функции: глобальная весовая функция: "IDF", локальная весовая функция: "TermFrequency", нормализующая функция: "Cosine"
# рекомендуй с профилю: {"female":3, "30":0.1}
# перекрестное соединение с таблицу: dfTitanic
# показать текущее значение конвейера
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
[Sparse Matrix Recommender Monad in R](https://github.com/antononcube/R-packages/tree/master/SMRMon-R),
(2019),
[R-packages at GitHub](https://github.com/antononcube/R-packages).

[AAp3] Anton Antonov,
[Monadic Sparse Matrix Recommender Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicSparseMatrixRecommender.m),
(2018),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp4] Anton Antonov,
[SparseMatrixRecommender Python package](https://github.com/antononcube/Python-packages/tree/main/SparseMatrixRecommender),
(2021),
[Python-packages at GitHub](https://github.com/antononcube/Python-packages).

[AAp5] Anton Antonov,
[ML::StreamsBlendingRecommender Raku package](https://github.com/antononcube/Raku-ML-StreamsBlendingRecommender)
(2021),
[GitHub/antononcube](https://github.com/antononcube).

