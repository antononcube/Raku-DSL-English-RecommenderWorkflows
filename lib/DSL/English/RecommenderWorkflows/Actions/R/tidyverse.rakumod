=begin comment
#==============================================================================
#
#   R-tidyverse actions in Raku Perl 6
#   Copyright (C) 2022  Anton Antonov
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
#   and the software monad SMRMon-R:
#
#     https://github.com/antononcube/R-packages/tree/master/SMRMon-R
#
#==============================================================================
=end comment

use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use DSL::Shared::Actions::English::R::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::R::tidyverse
        is DSL::Shared::Actions::English::R::PipelineCommand {

  # Separator
  method separator() { " %>%\n" }

  # Top
  method TOP($/) { make $/.values[0].made; }

  # workflow-command-list
  method workflow-commands-list($/) { make $/.values>>.made.join( self.separator() ); }

  # workflow-command
  method workflow-command($/) { make $/.values[0].made; }

  # General
  method variable-names-list($/) { make 'c(' ~ $<variable-name>>>.made.join(', ') ~ ')'; }

  # (Scored) item lists
  method item-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method item-ids-list($/) { make 'c(' ~ $<item-id>>>.made.join(', ') ~ ')'; }
  method scored-item-id($/) { make $<item-id>.made ~ '=' ~ $<number-value>.made; }
  method scored-item-ids-list($/) { make 'dplyr::tribble( ~Item, ~Rating, ' ~ $<scored-item-id>>>.made.map({ $_.subst('=', ', ') }).join(', ') ~ ')'; }

  # (Scored) tag lists
  method tag-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-ids-list($/) { make 'c(' ~ $<tag-id>>>.made.join(', ') ~ ')'; }
  method scored-tag-id($/) { make $<tag-id>.made ~ '=' ~ $<number-value>.made; }
  method scored-tag-ids-list($/) { make 'dplyr::tribble( ~Tag, ~Score, ' ~ $<scored-tag-id>>>.made.map({ $_.subst('=', ', ') }).join(', ') ~ ')'; }
  method tag-type-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-type-ids-list($/) { make 'dplyr::tribble( ~TagType, ~Score, ' ~ $<tag-type-id>>>.made.map({ $_.subst('=', ', ') }).join(', ') ~ ')'; }

  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'SMRMonSetData( data = ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'SMRMonCreate()'; }
  method create-by-dataset($/) { make 'SMRMonCreate( data = ' ~ $<dataset-name>.made ~ ')'; }
  method create-by-matrices($/) { make 'SMRMonCreateFromMatrices( matrices = ' ~ $<creation-matrices-spec>.made ~ ')'; }
  method creation-matrices-spec($/) { make $/.values[0].made; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'SMRMonEchoDataSummary()'; }
  method summarize-data($/) { make 'SMRMonEchoDataSummary()'; }
  method items-per-tag($/) { make 'SMRMonItemsPerTagDistribution()'; }
  method tags-per-items($/) { make 'SMRMonTagsPerItemDistribution()'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'SMRMonApplyTermWeightFunctions(' ~ $/.values[0].made ~ ')'; }
  method lsi-apply-verb($/) { make $/.Str; }
  method lsi-funcs-simple-list($/) { make $<lsi-global-func>.made ~ ', ' ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>.made ; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make 'globalWeightFunction = ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make 'localWeightFunction = ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"TermFrequency"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make 'normalizerFunction = ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) {

    my $prof = self.make-profile-expr( $<history-spec>.made );

    my $recs = 'dfRecs <-' ~ "\n" ~
            'dfItemMatrix' ~ self.separator() ~
            'dplyr::inner_join( dfProf, by = c("TagType", "Tag") )' ~ self.separator() ~
            'dplyr::group_by( Item )' ~ self.separator() ~
            'dplyr::summarise( Score = sum(Weight), .groups = "drop_last")' ~ self.separator() ~
            'dplyr::arrange(desc(Score))' ~ self.separator() ~
            'dplyr::slice( 1:nrecs )' ~ self.separator() ~
            'dplyr::inner_join( dfTitanic, by = c("Item" = itemColumnName) )';

    make $prof ~ "\n" ~ $recs;
  }

  method top-recommendations($/) {
    if $<integer-value> {
      make 'SMRMonGetTopRecommendations( spec = NULL, nrecs = ' ~ $<integer-value>.made ~ ')';
    } else {
      make 'SMRMonGetTopRecommendations( spec = NULL )';
    }
  }
  method top-recommendations-by-history($/) {
    if $<top-recommendations><integer-value> {
      make 'SMRMonRecommend( history = ' ~ $<history-spec>.made ~ ', nrecs = ' ~ $<top-recommendations><integer-value>.made ~ ')';
    } else {
      make 'SMRMonRecommend( history = ' ~ $<history-spec>.made ~ ')';
    }
  }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }

  multi method recommend-by-profile-expr($prof, $nrecs=10) {

    return 'dfRecs <-' ~ "\n" ~
            'dfItemMatrix ' ~ self.separator() ~
            'dplyr::inner_join(' ~ $prof ~ ', by = c("TagType", "Tag")) ' ~ self.separator() ~
            'dplyr::group_by(Item) ' ~ self.separator() ~
            'dplyr::summarize(Score = sum(Weight), .groups = "drop_last") ' ~ self.separator() ~
            'dplyr::arrange(desc(Score)) ' ~ self.separator() ~
            'head(' ~ $nrecs ~ ')';
  }

  method recommend-by-profile($/) { make self.recommend-by-profile-expr($<profile-spec>.made); }
  method top-profile-recommendations($/) { make self.recommend-by-profile-expr('dfProf'); }

  method top-recommendations-by-profile($/) {
    if $<top-recommendations><integer-value> {
      make self.recommend-by-profile-expr($<profile-spec>.made, $<top-recommendations><integer-value>.made);
    } else {
      make self.recommend-by-profile-expr($<profile-spec>.made);
    }
  }
  method profile-spec($/) { make $/.values[0].made; }

  # Make profile
  method make-profile-command($/) { make self.make-profile-expr( $<history-spec>.made ); }
  method make-profile-expr($history) {
    return 'dfProf <-' ~ "\n" ~
            'dfItemMatrix ' ~ self.separator() ~
            'dplyr::inner_join(' ~ $history ~ ', by = "Item" ) ' ~ self.separator() ~
            'dplyr::group_by( TagType, Tag ) ' ~ self.separator() ~
            'dplyr::summarise( Score = sum(Weight), .groups = "drop_last") '
  }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make 'SMRMonJoinAcross( data = ' ~ $<dataset-name>.made ~ ', by = ' ~ $<extension-data-id-column-spec>.made ~ ' )';
    } else {
      make 'SMRMonJoinAcross( data = ' ~ $<dataset-name>.made ~ ' )';
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Prove recommendations command
  method prove-recommendations-command($/) { make $/.values[0].made; }

  method proof-item-spec($/) { make $/.values[0].made; }

  method prove-by-metadata($/) {
    if ( $<profile-spec> && $<proof-item-spec> ) {
      make 'SMRMonProveByMetadata( profile = ' ~ $<profile-spec>.made ~ ', items = ' ~ $<proof-item-spec>.made ~ ')';
    } elsif ( $<profile-spec> ) {
      make 'SMRMonProveByMetadata( profile = ' ~ $<profile-spec>.made ~ ', items = NULL )';
    } elsif ( $<proof-item-spec> ) {
      make 'SMRMonProveByMetadata( profile = NULL, items = ' ~ $<proof-item-spec>.made ~ ')';
    } else {
      make 'SMRMonProveByMetadata( profile = NULL, items = NULL )';
    }
  }

  method prove-by-history($/) {
    if ( $<history-spec> && $<proof-item-spec> ) {
      make 'SMRMonProveByHistory( history = ' ~ $<history-spec>.made ~ ', items = ' ~ $<proof-item-spec>.made ~ ')';
    } elsif ( $<profile-spec> ) {
      make 'SMRMonProveByHistory( history = ' ~ $<history-spec>.made ~ ', items = NULL )';
    } elsif ( $<proof-item-spec> ) {
      make 'SMRMonProveByHistory( history = NULL, items = ' ~ $<proof-item-spec>.made ~ ')';
    } else {
      make 'SMRMonProveByHistory( history = NULL, items = NULL )';
    }
  }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ', nTopNNs = ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ', nTopNNs = ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'classify'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'SMRPlotScores()'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-recommender-matrix-query($/) { make $<smr-matrix-property-spec>.made; }

  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'SMRMonGetProperty(' ~ $/.values[0].made ~ ') ' ~ self.separator().trim ~ ' SMRMonEchoValue()'; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make 'SMRMonGetMatrixProperty(' ~ $<smr-matrix-property>.made ~ ', tagType = NULL ) ' ~ self.separator().trim ~ ' SMRMonEchoValue()'; }
  method smr-sub-matrix-property-spec($/) { make 'SMRMonGetMatrixProperty(' ~ $<smr-matrix-property>.made ~ ', tagType = ' ~ $<tag-type-id>.made ~ ' ) ' ~ self.separator().trim ~ ' SMRMonEchoValue()'; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"numberOfColumns"'; }
  method number-of-rows($/) { make '"numberOfRows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make 'SMRMonFilterMatrix( profile = ' ~ $<profile-spec>.made ~ ')';  }

  # Find anomalies command

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make 'SMRMonMakeTagTypeRecommender( tagTypeTo = ' ~ $<tag-type-id>.made ~ ' )'; }
  method make-metadata-recommender-full($/) { make 'SMRMonMakeTagTypeRecommender( tagTypeTo = ' ~ $<tag-type-id>.made ~ ', tagTypes = ' ~ $<tag-type-ids-list>.made ~ ' )'; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make 'SMRMonAnnexSubMatrix( newSubMat = ' ~ $<mat>.made ~ ', newTagType = ' ~ $<tagtype>.made ~ ' )';
    } else {
      make 'SMRMonAnnexSubMatrix( newSubMat = ' ~ $<mat>.made ~ ', newTagType = "NewType" )';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make 'SMRJoin( smr2 = ' ~ $<smr>.made ~ ', joinType = '  ~ $<jointype>.made ~ ' )';
    } else {
      make 'SMRJoin( smr2 = ' ~ $<smr>.made ~ ' )';
    }
  }
  method remove-tag-types-commands($/) { make 'SMRRemoveTagTypes( removeTagTypes = ' ~ $/.values[0].made ~ ' )'; }

  # Pipeline command overwrites
  ## Object
  method assign-pipeline-object-to($/) { make '(function(x) { assign( x = "' ~ $/.values[0].made ~ '", value = x, envir = .GlobalEnv ); x })'; }

  ## Value
  method assign-pipeline-value-to($/) { make '(function(x) { assign( x = "' ~ $/.values[0].made ~ '", value = SMRMonTakeValue(x), envir = .GlobalEnv ); x })'; }
  method take-pipeline-value($/) { make 'SMRMonTakeValue()'; }
  method echo-pipeline-value($/) { make 'SMRMonEchoValue()'; }
  method echo-pipeline-funciton-value($/) { make 'SMRMonEchoFunctionValue( ' ~ $<pipeline-function-spec>.made ~ ' )'; }

  ## Context
  method take-pipeline-context($/) { make 'SMRMonTakeContext()'; }
  method echo-pipeline-context($/) { make 'SMRMonEchoContext()'; }
  method echo-pipeline-function-context($/) { make 'SMRMonEchoFunctionContext( ' ~ $<pipeline-function-spec>.made ~ ' )'; }

  ## Echo messages
  method echo-command($/) { make 'SMRMonEcho( ' ~ $<echo-message-spec>.made ~ ' )'; }

  ## Setup code
  method setup-code-command($/) {
    make 'SETUPCODE' => q:to/SETUPEND/
      #install.packages("tidyverse")
      library(magrittr)
      library(tidyverse)
      SETUPEND
  }
}
