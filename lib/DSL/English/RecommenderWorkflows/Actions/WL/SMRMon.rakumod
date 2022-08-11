=begin comment
#==============================================================================
#
#   WL-SMRMon actions in Raku Perl 6
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
#   For more details about Raku Perl6 see https://perl6.org/ .
#
#==============================================================================
#
#   The actions are implemented for the grammar:
#
#     DSL::English::RecommenderWorkflows::Grammar
#
#   and the software monad SMRMon-WL:
#
#     https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicSparseMatrixRecommender.m
#
#==============================================================================
=end comment

use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use DSL::Shared::Actions::English::WL::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::WL::SMRMon
        is DSL::Shared::Actions::English::WL::PipelineCommand {

  # Separator
  method separator() { " \\[DoubleLongRightArrow]\n" }

  # Top
  method TOP($/) { make $/.values[0].made; }

  # workflow-command-list
  method workflow-commands-list($/) { make $/.values>>.made.join( self.separator() ); }

  # workflow-command
  method workflow-command($/) { make $/.values[0].made; }

  # General
  method variable-names-list($/) { make '{' ~ $<variable-name>>>.made.join(', ') ~ '}'; }

  # (Scored) item lists
  method item-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method item-ids-list($/) { make '{' ~ $<item-id>>>.made.join(', ') ~ '}'; }
  method scored-item-id($/) { make $<item-id>.made ~ '->' ~ $<number-value>.made ; }
  method scored-item-ids-list($/) { make '<|' ~ $<scored-item-id>>>.made.join(', ') ~ '|>'; }

  # (Scored) tag lists
  method tag-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-ids-list($/) { make '{' ~ $<tag-id>>>.made.join(', ') ~ '}'; }
  method scored-tag-id($/) { make $<tag-id>.made ~ '->' ~ $<number-value>.made ; }
  method scored-tag-ids-list($/) { make '<|' ~ $<scored-tag-id>>>.made.join(', ') ~ '|>'; }
  method tag-type-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"' }
  method tag-type-ids-list($/) { make '{' ~ $<tag-type-id>>>.made.join(', ') ~ '}'; }

  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'SMRMonSetData[ ' ~ $<data-location-spec>.made ~ ']'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'SMRMonCreate[]'; }
  method create-by-dataset($/) { make 'SMRMonUnit[] \[DoubleLongRightArrow] SMRMonCreate[' ~ $<dataset-name>.made ~ ']'; }
  method create-by-matrices($/) { make 'SMRMonUnit[] \[DoubleLongRightArrow] SMRMonCreate[' ~ $<creation-matrices-spec>.made ~ ']'; }
  method creation-matrices-spec($/) { make $/.values[0].made; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'SMRMonEchoDataSummary[]'; }
  method summarize-data($/) { make 'SMRMonEchoDataSummary[]'; }
  method items-per-tag($/) { make 'SMRMonItemsPerTagDistribution[]'; }
  method tags-per-items($/) { make 'SMRMonTagsPerItemDistribution[]'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'SMRMonApplyTermWeightFunctions[' ~ $/.values[0].made ~ ']'; }
  method lsi-apply-verb($/) { make $/.Str; }
  method lsi-funcs-simple-list($/) { make $<lsi-global-func>.made ~ ', ' ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>.made ; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make '"GlobalWeightFunction" -> ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make '"LocalWeightFunction" -> ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"TermFrequency"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make '"NormalizerFunction" -> ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) { make 'SMRMonRecommend[' ~ $<history-spec>.made ~ ']'; }
  method top-recommendations($/) {
    if $<integer-value> {
      make 'SMRMonGetTopRecommendations[ "Specification" -> None, "NumberOfRecommendations" -> ' ~ $<integer-value>.made ~ ']';
    } else {
      make 'SMRMonGetTopRecommendations[ "Specification" -> None ]';
    }
  }
  method top-recommendations-by-history($/) {
    if $<top-recommendations><integer-value> {
      make 'SMRMonRecommend[' ~ $<history-spec>.made ~ ', ' ~ $<top-recommendations><integer-value>.made ~ ']';
    } else {
      make 'SMRMonRecommend[' ~ $<history-spec>.made ~ ']';
    }
  }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make 'SMRMonRecommendByProfile[' ~ $<profile-spec>.made ~ ']'; }
  method top-profile-recommendations($/) {
    if $<integer-value> {
      make 'SMRMonGetTopRecommendations[ "Specification" -> None, "NumberOfRecommendations" -> ' ~ $<integer-value>.made ~ ']';
    } else {
      make 'SMRMonGetTopRecommendations[ "Specification" -> None ]';
    }
  }
  method top-recommendations-by-profile($/) {
    if $<top-recommendations><integer-value> {
      make 'SMRMonRecommendByProfile[' ~ $<profile-spec>.made ~ ',  ' ~ $<top-recommendations><integer-value>.made ~ ']';
    } else {
      make 'SMRMonRecommendByProfile[' ~ $<profile-spec>.made ~ ']';
    }
  }
  method profile-spec($/) { make $/.values[0].made; }

  # Retrieve by query elements
  method retrieve-by-query-elements-command($/) { make $/.values[0].made; }
  method retrieval-query-element-list($/) {
    make 'SMRMonRetrieveByQueryElements[' ~  $/.values>>.made.join(', ') ~ ']';
  }
  method retrieval-query-element($/) {
    make $<retrieval-query-element-phrase>.made ~ '->' ~ $<profile-spec>.made;
  }
  method retrieval-query-element-phrase($/) { make $/.values[0].made; }
  method should-have-phrase($/) { make '"Should"'; }
  method must-have-phrase($/) { make '"Must"'; }
  method must-not-have-phrase($/) { make '"MustNot"'; }

  # Make profile
  method make-profile-command($/) { make 'SMRMonProfile[' ~ $<history-spec>.made ~ ']'; }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make 'SMRMonJoinAcross[' ~ $<dataset-name>.made ~ ', ' ~ $<extension-data-id-column-spec>.made ~ ' ]';
    } else {
      make 'SMRMonJoinAcross[' ~ $<dataset-name>.made ~ ']';
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Prove recommendations command
  method prove-recommendations-command($/) { make $/.values[0].made; }

  method proof-item-spec($/) { make $/.values[0].made; }

  method prove-by-metadata($/) {
    if ( $<profile-spec> && $<proof-item-spec> ) {
      make 'SMRMonProveByMetadata[ "Profile" -> ' ~ $<profile-spec>.made ~ ', "Items" -> ' ~ $<proof-item-spec>.made ~ ']';
    } elsif ( $<profile-spec> ) {
      make 'SMRMonProveByMetadata[ "Profile" -> ' ~ $<profile-spec>.made ~ ', "Items" -> Automatic ]';
    } elsif ( $<proof-item-spec> ) {
      make 'SMRMonProveByMetadata[ "Profile" -> Automatic, "Items" -> ' ~ $<proof-item-spec>.made ~ ']';
    } else {
      make 'SMRMonProveByMetadata[ "Profile" -> Automatic, "Items" -> Automatic ]';
    }
  }

  method prove-by-history($/) {
    if ( $<history-spec> && $<proof-item-spec> ) {
      make 'SMRMonProveByHistory[ "History" -> ' ~ $<history-spec>.made ~ ', "Items" -> ' ~ $<proof-item-spec>.made ~ ']';
    } elsif ( $<profile-spec> ) {
      make 'SMRMonProveByHistory[ "History" -> ' ~ $<history-spec>.made ~ ', "Items" -> Automatic ]';
    } elsif ( $<proof-item-spec> ) {
      make 'SMRMonProveByHistory[ "History" -> Automatic, "Items" -> ' ~ $<proof-item-spec>.made ~ ']';
    } else {
      make 'SMRMonProveByHistory[ "History" -> Automatic, "Items" -> Automatic ]';
    }
  }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'SMRMonClassifyByProfile[ "TagType" -> ' ~ $<tag-type-id>.made ~ ', "Profile" -> ' ~ $<profile-spec>.made ~ ', "NumberOfNearestNeighbors" -> ' ~ $<ntop-nns>.made ~ ']';
    } else {
      make 'SMRMonClassifyByProfile[ "TagType" -> ' ~ $<tag-type-id>.made ~ ', "Profile" -> ' ~ $<profile-spec>.made ~ ']';
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'SMRMonClassify[ "TagType" -> ' ~ $<tag-type-id>.made ~ ', "Profile" -> ' ~ $<profile-spec>.made ~ ', "NumberOfNearestNeighbors" = ' ~ $<ntop-nns>.made ~ ']';
    } else {
      make 'SMRMonClassify[ "TagType" -> ' ~ $<tag-type-id>.made ~ ', "Profile" -> ' ~ $<profile-spec>.made ~ ']';
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'classify'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'SMRPlotScores[]'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }
  method smr-recommender-matrix-query($/) { make $<smr-matrix-property-spec>.made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'SMRMonGetProperty[' ~ $/.values[0].made ~ '] ' ~ self.separator().trim ~ ' SMRMonEchoValue[]'; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make 'SMRMonGetMatrixProperty[' ~ $<smr-matrix-property>.made ~ ', tagType = NULL ] ' ~ self.separator().trim ~ ' SMRMonEchoValue[]'; }
  method smr-sub-matrix-property-spec($/) { make 'SMRMonGetMatrixProperty[' ~ $<smr-matrix-property>.made ~ ', tagType = ' ~ $<tag-type-id>.made ~ ' ] ' ~ self.separator().trim ~ ' SMRMonEchoValue[]'; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"numberOfColumns"'; }
  method number-of-rows($/) { make '"numberOfRows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make 'SMRMonFilterMatrix[' ~ $<profile-spec>.made ~ ']';  }

  # Find anomalies command
  method find-anomalies-command($/) { make $/.values[0].made; }
  method find-proximity-anomalies-simple($/) { make 'SMRMonFindAnomalies[ "NumberOfNearestNeighbors" -> 12, "AggregationFunction" -> Mean, "OutlierIdentifier" -> "HampelIdentifierParameters" ]'; }
  method find-proximity-anomalies($/) { make 'SMRMonFindAnomalies[' ~ $<proximity-anomalies-spec-list>.made ~ ']'; }
  method proximity-anomalies-spec-list($/) { make $<proximity-anomalies-spec>>>.made.join(', '); }
  method proximity-anomalies-spec($/) { make $/.values[0].made; }
  method proximity-anomalies-nns-spec($/) { make '"NumberOfNearestNeighbors" ->' ~ $<integer-value>.made; }
  method proximity-anomalies-aggr-func-spec($/) { make '"AggregationFunction" ->' ~ $<variable-name>.made;}
  method proximity-anomalies-outlier-identifier-spec($/) { make '"OutlierIdentifier" -> ' ~ $<variable-name>.made;}
  method proximity-anomalies-property-spec($/) { make '"Property" -> "' ~ $<variable-name>.made ~ '"';}

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make 'SMRMonMakeTagTypeRecommender[ "TagTypeTo" -> ' ~ $<tag-type-id>.made ~ ' ]'; }
  method make-metadata-recommender-full($/) { make 'SMRMonMakeTagTypeRecommender[ "TagTypeTo" -> ' ~ $<tag-type-id>.made ~ ', "TagTypes" -> ' ~ $<tag-type-ids-list>.made ~ ' ]'; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make 'SMRMonAnnexSubMatrix[ <|' ~ $<tagtype>.made ~ ' -> ' ~ $<mat>.made ~ '|> ]';
    } else {
      make 'SMRMonAnnexSubMatrices[ <| "NewType" -> ' ~ $<mat>.made ~ ' |> ]';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make 'SMRMonJoin[ ' ~ $<smr>.made ~ ', '  ~ $<jointype>.made ~ ' ]';
    } else {
      make 'SMRMonJoin[ ' ~ $<smr>.made ~ ' ]';
    }
  }
  method remove-tag-types-commands($/) { make 'SMRMonRemoveTagTypes[ ' ~ $/.values[0].made ~ ' ]'; }

  # Pipeline command overwrites
  ## Object
  method assign-pipeline-object-to($/) { make 'SMRMonAssignTo[ ' ~ $/.values[0].made ~ ' ]'; }

  ## Value
  method assign-pipeline-value-to($/) { make 'SMRMonAssignValueTo[ ' ~ $/.values[0].made ~ ' ]'; }
  method take-pipeline-value($/) { make 'SMRMonTakeValue[]'; }
  method echo-pipeline-value($/) { make 'SMRMonEchoValue[]'; }
  method echo-pipeline-funciton-value($/) { make 'SMRMonEchoFunctionValue[ ' ~ $<pipeline-function-spec>.made ~ ' ]'; }

  ## Context
  method take-pipeline-context($/) { make 'SMRMonTakeContext[]'; }
  method echo-pipeline-context($/) { make 'SMRMonEchoContext[]'; }
  method echo-pipeline-function-context($/) { make 'SMRMonEchoFunctionContext[ ' ~ $<pipeline-function-spec>.made ~ ' ]'; }

  ## Echo messages
  method echo-command($/) { make 'SMRMonEcho[ ' ~ $<echo-message-spec>.made ~ ' ]'; }

  ## Setup code
  method setup-code-command($/) {
    make 'SETUPCODE' => q:to/SETUPEND/
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MonadicProgramming/MonadicSparseMatrixRecommender.m"];
    SETUPEND
  }
}