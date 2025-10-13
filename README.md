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
# my $obj = ML::SparseMatrixRecommender.new.create-from-wide-form(dfTitanic).apply-term-weight-functions(global-weight-func => "IDF", local-weight-func => "TermFrequency", normalizer-func => "Cosine").recommend-by-profile({"female" => 3, "30" => 0.1}).join-across(dfTitanic ).echo-value()
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

## CLI

The package provides a Command Line Interface (CLI) script. Here is its usage message:

```shell
ToRecommenderWorkflowCode --help
```
```
# Translates natural language commands into recommender workflow programming code.
# Usage:
#   ToRecommenderWorkflowCode <command> [--target=<Str>] [--language=<Str>] [--format=<Str>] [-c|--clipboard-command=<Str>] -- Translates natural language commands into (machine learning) recommender workflow programming code.
#   ToRecommenderWorkflowCode <target> <command> [--language=<Str>] [--format=<Str>] [-c|--clipboard-command=<Str>] -- Both target and command as arguments.
#   ToRecommenderWorkflowCode [<words> ...] [-t|--target=<Str>] [-l|--language=<Str>] [-f|--format=<Str>] [-c|--clipboard-command=<Str>] -- Command given as a sequence of words.
#   
#     <command>                       A string with one or many commands (separated by ';').
#     --target=<Str>                  Target (programming language with optional library spec.) [default: 'WL::SMRMon']
#     --language=<Str>                The natural language to translate from. [default: 'English']
#     --format=<Str>                  The format of the output, one of 'automatic', 'code', 'hash', or 'raku'. [default: 'automatic']
#     -c|--clipboard-command=<Str>    Clipboard command to use. [default: 'Whatever']
#     <target>                        Programming language.
#     [<words> ...]                   Words of a data query.
#     -t|--target=<Str>               Target (programming language with optional library spec.) [default: 'WL::SMRMon']
#     -l|--language=<Str>             The natural language to translate from. [default: 'English']
#     -f|--format=<Str>               The format of the output, one of 'automatic', 'code', 'hash', or 'raku'. [default: 'automatic']
# Details:
#     If --clipboard-command is the empty string then no copying to the clipboard is done.
#     If --clipboard-command is 'Whatever' then:
#         1. It is attempted to use the environment variable CLIPBOARD_COPY_COMMAND.
#             If CLIPBOARD_COPY_COMMAND is defined and it is the empty string then no copying to the clipboard is done.
#         2. If the variable CLIPBOARD_COPY_COMMAND is not defined then:
#             - 'pbcopy' is used on macOS
#             - 'clip.exe' on Windows
#             - 'xclip -sel clip' on Linux.
```

Here a Raku pipeline is generated:

```shell
ToRecommenderWorkflowCode Raku 'create with dfTitanic; apply the LSI functions IDF, None, Cosine; recommend by profile 1st and male; join across' 
```
```
# my $obj = ML::SparseMatrixRecommender.new
# .create-from-wide-form(dfTitanic)
# .apply-term-weight-functions(global-weight-func => "IDF", local-weight-func => "None", normalizer-func => "Cosine")
# .recommend-by-profile(["1st", "male"])
# .join-across()
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
