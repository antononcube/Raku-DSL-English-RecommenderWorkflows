=begin comment
#==============================================================================
#
#   Recommender workflows grammar in Raku Perl 6
#   Copyright (C) 2019  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   ʇǝu˙oǝʇsod@ǝqnɔuouoʇuɐ
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku Perl6 see https://raku.org/ (https://perl6.org/) .
#
#==============================================================================
#
#  The grammar design in this file follows very closely the EBNF grammar
#  for Mathematica in the GitHub file:
#    https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/Mathematica/RecommenderWorkflowsGrammar.m
#
#==============================================================================
=end comment

use v6.d;

role DSL::English::RecommenderWorkflows::Grammarish {

    # TOP
    rule TOP { <workflow-command> }

    # Workflow commands list
    rule workflow-commands-list { [ [ <.ws>? <workflow-command> <.ws>? ]+ % <.list-of-commands-separator> ] <.list-of-commands-separator>? }

    # Workflow command
    rule workflow-command {
        <pipeline-command> |
        <recommender-algebra-command> |
        <data-load-command> |
        <create-command> |
        <data-transformation-command> |
        <lsi-apply-command> |
        <data-statistics-command> |
        <recommend-by-profile-command> |
        <recommend-by-history-command> |
        <retrieve-by-query-elements-command> |
        <make-profile-command> |
        <extend-recommendations-command> |
        <prove-recommendations-command> |
        <classify-command> |
        <smr-query-command> |
        <find-anomalies-command> |
        <make-metadata-recommender-command> }

    # Load data
    rule data-load-command { <use-recommender> | <load-data> }
    rule data-location-spec { <dataset-name> }
    rule load-data { <.load-data-directive> <data-location-spec> }
    rule use-recommender { [<.use-verb> | <.using-preposition>] <.the-determiner>? <.recommender-object-phrase>? <variable-name> }

    # Create command
    rule create-command { <create-by-matrices> | <create-by-dataset> | <create-simple> }
    rule create-preamble-phrase { <generate-directive> [ <.a-determiner> | <.the-determiner> ]? <recommender-object-phrase> }
    rule create-simple { <create-preamble-phrase> <simple-way-phrase>? | <simple> <recommender-object-phrase> [ <creation-noun> | <making-noun> ] }
    rule create-by-dataset { [ <create-preamble-phrase> | <generate-directive> ] [ <.with-preposition> | <.from-preposition> ] <.the-determiner>? <dataset-noun>? <dataset-name> [ <.using-dataset-column-phrase>? <colid=.mixed-quoted-variable-name>]? }
    rule create-by-matrices { [ <create-preamble-phrase> | <generate-directive> ] [ <.with-preposition> | <.from-preposition> ] <.the-determiner>? <matrices-noun> <creation-matrices-spec> }
    rule creation-matrices-spec { <key-pairs-list> | <mixed-quoted-variable-names-list> | <wl-expr> }

    # Data transformation command
    rule data-transformation-command { <cross-tabulate-command> }
    rule cross-tabulate-command { <cross-tabulate-phrase> <.data>? }

    # Data statistics command
    rule data-statistics-command { <show-data-summary> | <summarize-data> | <items-per-tag> | <tags-per-item> }
    rule show-data-summary { <display-directive> <data>? <summary> }
    rule summarize-data { <summarize-directive> <.the-determiner>? <data> | <display-directive> <data>? [ <summary> | <summaries> ] }
    rule items-per-tag { <number-of> <items-noun> <per-preposition> <tag-noun> }
    rule tags-per-item { <number-of> <tags> <per-preposition> <item-noun> }

    # (Scored) items lists
    token score-association-symbol { '=' | '->' | '→' | ':' }
    token score-association-separator { \h* <score-association-symbol> \h* }
    token item-id { <mixed-quoted-keyword-variable-name> | <mixed-quoted-variable-name> }
    rule item-ids-list { <item-id>+ % <list-separator> }
    token scored-item-id { <item-id> <.score-association-separator> <number-value> }
    rule scored-item-ids-list { <scored-item-id>+ % <list-separator> }

    # (Scored) tags lists
    regex tag-id { <mixed-quoted-keyword-variable-name> | <mixed-quoted-variable-name> }
    rule tag-ids-list { <tag-id>+ % <list-separator> }
    regex scored-tag-id { <tag-id> <.score-association-separator> <number-value> }
    rule scored-tag-ids-list { <scored-tag-id>+ % <list-separator> }
    token tag-type-id { <mixed-quoted-keyword-variable-name> | <mixed-quoted-variable-name> }
    rule tag-type-ids-list { <tag-type-id>+ % <list-separator> }

    # History spec
    rule history-spec { <scored-item-ids-list> | <item-ids-list> }

    # Profile spec
    rule profile-spec { <scored-tag-ids-list> | <tag-ids-list>  }

    # Recommend by history
    rule recommend-by-history-command { <recommend-by-history> | <top-recommendations-by-history> | <top-recommendations> | <simple-recommend> }
    rule recommend-by-history { <.recommend-directive>
                              [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                              <history-spec> }
    rule top-recommendations { [ <compute-directive> | <what-are-phrase> | <get-directive> ]? <.the-determiner>? <.most-relevant-phrase>? <integer-value>? <.most-relevant-phrase>? [ <.recommendations-noun> | <.recommendation-noun> ] }
    rule top-recommendations-by-history { <top-recommendations>
                                        [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                                        <history-spec> }
    rule most-relevant-phrase { <most-relevant> | <top-adjective> <most-relevant>? }
    rule simple-recommend { <recommend-directive> | <compute-directive> <recommendations-noun> }

    # Recommend by profile
    rule recommend-by-profile-command { <recommend-by-profile> | <top-profile-recommendations> | <top-recommendations-by-profile> }
    rule recommend-by-profile { <.recommend-directive>
                              [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.profile-noun>
                              <.for-preposition>? <profile-spec> }
    rule top-profile-recommendations { [ <compute-directive> | <what-are-phrase> ]? <.the-determiner>? <.most-relevant-phrase>? <integer-value>? <.most-relevant-phrase>? <.profile-noun> <.recommendation-noun> }
    rule top-recommendations-by-profile { <top-recommendations>
                                        [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.profile-noun>
                                        <profile-spec> }

    # Retrieve by query elements
    rule retrieve-by-query-elements-command { <.retrieve-by-query-elements-phrase> <.with-preposition> [ <retrieval-query-element-list> ] }
    rule retrieval-query-element-list { <retrieval-query-element>+ % [ \h* | <.list-separator> ] }
    rule retrieval-query-element { <retrieval-query-element-phrase> '(' <profile-spec> ')' }
    rule retrieval-query-element-phrase { <should-have-phrase> | <must-have-phrase> | <must-not-have-phrase> }

    ## Retrieval by query elements
    rule should-have-phrase { <should-verb> <have-verb>? }
    rule must-have-phrase { <must-verb> <have-verb>? }
    rule must-not-have-phrase { <must-not-verb> <have-verb>? }
    rule retrieve-by-query-elements-phrase { <retrieve-verb> }

    # Make profile
    rule make-profile-command {  <.make-profile-command-opening> <.the-determiner>? [ <.history-phrase> <.list-noun>? | <.items-noun> ] <history-spec> }
    rule make-profile-command-opening { <compute-directive> [ <a-determiner> | <the-determiner> ]? <profile-noun>
                                      [ <using-preposition> | <by-preposition> | <for-preposition> ] }

    # Recommendations processing command
    rule extend-recommendations-command { <extend-recommendations-simple-command> }
    rule extend-recommendations-simple-command { <.extend-recommendations-phrase> <.with-preposition> <.the-determiner>? <.data>? <dataset-name> [ [ <.by-preposition> | <.on-preposition> ] <extension-data-id-column-spec> ]?  }
    rule extension-data-id-column-spec { <.the-determiner>? [ <.identifier-noun> | <.id-noun> ]? <.column-noun>? <mixed-quoted-variable-name-or-wl-expr> }

    # Prove command
    rule prove-recommendations-command { <prove-by-history> | <prove-by-metadata> }
    rule proof-item-spec { <item-id> | <item-ids-list> }
    rule recommendation-items-phrase { [ <recommendations-noun>  | <recommendation-noun> | <recommended-adjective> ] [ <item-noun> | <items-noun> ]? }
    rule prove-by-metadata {
        <prove-directive> <.the-determiner>? <recommendation-items-phrase> [ <proof-item-spec>? <.by-preposition> [ <metadata-noun> | <.the-determiner>? <profile-noun> ] <profile-spec>? ]? |
        <prove-directive> <.by-preposition> [ <metadata-noun> | <profile-noun> ] <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>
  }
    rule prove-by-history {
        <prove-directive> <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>? [ <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.consumption-history-phrase> <history-spec>? |
        <prove-directive> <.by-preposition> <.consumption-history-phrase> <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>
  }

    # Classifications command
    rule classify-command { <classify-by-profile> | <classify-by-profile-rev> }
    rule ntop-nns { <.top-noun>? <integer-value> <.top-noun>? <.nearest-neighbors> }
    rule classify-by-profile { <.classify-verb> [ <.by-preposition> | <.the-determiner> ]? <.profile-noun>? <profile-spec>
                             <.to-preposition> <.tag-type-phrase>? <tag-type-id>
                             [ <.using-preposition> <ntop-nns> ]? }
    rule classify-by-profile-rev { <.classify-verb> [ <.for-preposition> | <.to-preposition>] <.the-determiner>? <.tag-type-phrase>? <tag-type-id>
                                 [ <.by-preposition> | <.for-preposition> | <.using-preposition> ]? <.the-determiner>? <.profile-noun>?
                                 <profile-spec>
                                 [ <.and-conjunction>? <.using-preposition>? <ntop-nns> ]? }

    # Plot command
    rule plot-command { <plot-recommendation-scores> }
    rule plot-recommendation-scores { <plot-directive> <.the-determiner>? <recommendation-results> }

    # SMR query command
    rule smr-query-command { <smr-recommender-matrix-query>  | <smr-recommender-query> | <smr-filter-matrix> }
    rule smr-recommender-matrix-query { <display-directive> <.the-determiner>? <.smr-matrix-property-spec-openning> <smr-matrix-property-spec> }
    rule smr-recommender-query { <display-directive> <.the-determiner>? <.recommender-noun>? <smr-property-spec> }
    rule smr-property-spec { <smr-context-property-spec> | <smr-matrix-property-spec> | <smr-sub-matrix-property-spec> }

    token smr-property-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' || $0 eq 'pipeline' }> }

    rule smr-context-property-spec { <smr-tag-types> | <smr-item-column-name> | <smr-sub-matrices> | <smr-recommendation-matrix> | <properties-noun> }
    rule smr-tag-types { <tag-types-phrase> }
    rule smr-item-column-name { <item-noun> <column-noun> <name-noun> | 'itemColumnName' }
    rule smr-sub-matrices { <sparse-adjective>? <contingency-noun>? <sub-matrices-phrase> }
    rule smr-recommendation-matrix { <recommendation-matrix> }

    rule smr-matrix-property-spec-openning { <recommendation-matrix> | <sparse-matrix> | <matrix-noun> }
    rule smr-matrix-property-spec { <.smr-matrix-property-spec-openning>? <smr-matrix-property> }

    rule smr-sub-matrix-property-spec-openning { 'sub-matrix' | <sub-prefix> <matrix-noun> | <tag-type-phrase> }
    rule smr-sub-matrix-property-spec { <.smr-sub-matrix-property-spec-openning>? <tag-type-id> <smr-matrix-property> }

    rule smr-matrix-property { <columns-noun> | <rows-noun> | <dimensions-noun> | <density-noun> | <number-of-columns> | <number-of-rows> | <smr-property-id> | <properties-noun> }
    rule number-of-columns { <number-of> <columns-noun> }
    rule number-of-rows { <number-of> <rows-noun> }

    rule smr-filter-matrix { [ <filter-verb> | <reduce-verb> ] <.the-determiner>? <.smr-matrix-property-spec-openning>
                           [ <.using-preposition> | <.with-preposition> | <.by-preposition> ] <.the-determiner>? <profile-noun>?
                           <profile-spec> }

    # Find anomalies command
    rule find-anomalies-command { <find-proximity-anomalies> | <find-proximity-anomalies-simple> }
    rule find-proximity-anomalies-simple { <find-proximity-anomalies-preamble> }
    rule find-proximity-anomalies-preamble { <compute-directive> [ <.anomalies-noun> [ <.by-preposition> <.proximity-noun> ]? | <.proximity-noun> <.anomalies-noun> ] }
    rule find-proximity-anomalies { <find-proximity-anomalies-preamble> <.using-preposition> <proximity-anomalies-spec-list> }
    rule proximity-anomalies-spec-list { <proximity-anomalies-spec>* % <.list-separator> }
    rule proximity-anomalies-spec { <proximity-anomalies-nns-spec> | <proximity-anomalies-outlier-identifier-spec> | <proximity-anomalies-aggr-func-spec> | <proximity-anomalies-property-spec> }
    rule proximity-anomalies-nns-spec { <integer-value> <nearest-neighbors> }
    rule proximity-anomalies-aggr-func-spec {
        <.the-determiner>? <.aggregation-noun> <.function-noun> <variable-name> |
        <.aggregate-verb> [ <.by-preposition> | <.using-preposition> ] <.the-determiner>? <.function-noun> <variable-name> }
    rule proximity-anomalies-outlier-identifier-spec { <.the-determiner>? [ <.outlier-noun> [ <.identifier-noun> | <.identifier-adjective> ] <variable-name> | <variable-name> <.outlier-noun> [ <.identifier-noun> | <.identifier-adjective> ] ]}
    rule proximity-anomalies-property-spec { <.the-determiner>? <.property-noun> <variable-name> }

    # Metadata recommender making command
    rule make-metadata-recommender-command { <make-metadata-recommender-full> | <make-metadata-recommender-simple> }
    rule make-metadata-recommender-preamble { <create-directive> <a-determiner>? [ <metadata-noun> | <tag-type-phrase> ] <recommender-noun> }
    rule make-metadata-recommender-simple { <.make-metadata-recommender-preamble> <.for-preposition> <.the-determiner>? <.tag-type-phrase>? <tag-type-id> }
    rule make-metadata-recommender-full {
        <.make-metadata-recommender-preamble> <.for-preposition> <.the-determiner>? <.tag-type-phrase>? <tag-type-id> <.over-preposition> <.the-determiner>? <.tag-types-phrase>? <tag-type-ids-list> }

    # Recommender algebra command
    rule recommender-algebra-command { <annex-matrix-command> | <join-recommenders-command> | <remove-tag-types-commands> }
    rule annex-matrix-command { <.annex-directive> <.the-determiner>? [ <.sub-matrix-phrase> | <.matrix-noun> ] <mat=.variable-name-or-wl-expr> [ [ <.with-preposition> <.tag-type-phrase> | <.as-preposition> ] <tagtype=.mixed-quoted-variable-name-or-wl-expr> ]? }
    rule join-recommenders-openning-phrase {
        <.join-directive> <.the-determiner>? <.recommender-object-phrase> <.with-preposition> <.the-determiner>? <.recommender-object-phrase>? |
        <.join-directive> <.the-determiner>? <.recommender-object-phrase>? <.with-preposition> <.the-determiner>? <.recommender-object-phrase> }
    rule join-recommenders-command { <.join-recommenders-openning-phrase> <smr=.variable-name-or-wl-expr> [ <.using-preposition> <.join-type-phrase> <jointype=.mixed-quoted-variable-name-or-wl-expr> ]? }
    rule remove-tag-types-commands { <.delete-directive> <.the-determiner>? <.tag-types-phrase> [ <tag-type-ids-list> | <wl-expr> ] }
}

