use v6.d;

# Taken from LatentSemanticAnalysisWorkflows::Grammar .

# This grammar role does rely on the role CommonParts --
# it is expected to be included in the "large" LSAMon or SMRMon grammars.
# The primary motivation is to reuse the LSA grammars, but also have SMR
# grammars to be self-sufficient.
# See DSL::English::LatentSemanticAnalysisWorkflows::Grammar::LSIApplyCommand.

# LSI functions application commands.
role DSL::English::RecommenderWorkflows::Grammar::LSIApplyCommand {

    regex lsi-apply-command {
        :my Int $*GLOBAL = 0;
        :my Int $*LOCAL = 0;
        :my Int $*NORMAL = 0;
        <.lsi-apply-phrase> [ <lsi-funcs-list> | <lsi-funcs-simple-list> ]
    }

    rule lsi-funcs-simple-list { <lsi-global-func> <lsi-local-func> <lsi-normalizer-func> }

    rule lsi-apply-verb { <apply-verb> <to-preposition>? | <transform-verb> | <use-verb> }
    rule lsi-apply-phrase { <lsi-apply-verb> <the-determiner>? [ <matrix-noun> | <matrix-entries> ]? <the-determiner>? <lsi-phrase>? <functions>? }

    rule lsi-funcs-list { <lsi-func>+ % <list-separator> }

    rule lsi-func { <lsi-global-func> | <lsi-local-func> | <lsi-normalizer-func> }

    rule lsi-func-none { 'None' | 'none' }

    rule lsi-global-func {
        <?{$*GLOBAL == 0}> <.global-function-phrase>? [ <lsi-global-func-idf> | <lsi-global-func-entropy> | <lsi-global-func-sum> | <lsi-func-none> ]
        {$*GLOBAL = 1}
    }
    rule lsi-global-func-idf { 'IDF' | 'idf' | <inverse-adjective> <document-noun> <frequency-noun> }
    rule lsi-global-func-entropy { 'Entropy' | 'entropy' }
    rule lsi-global-func-sum {  'sum' | 'Sum' }

    rule lsi-local-func {
        <?{$*LOCAL == 0}> <.local-function-phrase>? [ <lsi-local-func-frequency> | <lsi-local-func-binary> | <lsi-local-func-log> | <lsi-func-none> ]
        {$*LOCAL = 1}
    }
    rule lsi-local-func-frequency {  <term-noun>? <frequency-noun> | 'TermFreq' | 'TermFrequency' }
    rule lsi-local-func-binary { 'binary' <frequency-noun>? | 'Binary' }
    rule lsi-local-func-log { 'log' | 'logarithmic' | 'Log' }

    rule lsi-normalizer-func {
        <?{$*NORMAL == 0}> <.normalizer-function-phrase>? [ <lsi-normalizer-func-sum> | <lsi-normalizer-func-max> | <lsi-normalizer-func-cosine> | <lsi-func-none> ] <.normalization-noun>?
        {$*NORMAL = 1}
    }
    rule lsi-normalizer-func-sum {'sum' | 'Sum' }
    rule lsi-normalizer-func-max {'max' | 'maximum' | 'Max' }
    rule lsi-normalizer-func-cosine {'cosine' | 'Cosine' }
}