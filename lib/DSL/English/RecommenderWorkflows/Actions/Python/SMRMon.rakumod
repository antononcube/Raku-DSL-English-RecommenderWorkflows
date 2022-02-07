=begin comment
#==============================================================================
#
#   Py-SMRMon actions in Raku Perl 6
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
#   and a possible software monad SMRMon-Py.
#
#==============================================================================
#
#   The code below is derived from the code for SMRMon-Py by simple
#   unfolding of the monadic pipeline into assignment.
#
#==============================================================================
=end comment

use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use DSL::Shared::Actions::English::Python::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::Python::SMRMon
        is DSL::Shared::Actions::English::Python::PipelineCommand {

  # Separator
  method separator() { "\n" }

  # Top
  method TOP($/) { make $/.values[0].made; }

  # workflow-command-list
  method workflow-commands-list($/) { make $/.values>>.made.join( self.separator() ); }

  # workflow-command
  method workflow-command($/) { make $/.values[0].made; }

  # General
  method variable-names-list($/) { make '[' ~ $<variable-name>>>.made.join(', ') ~ ']'; }

  # (Scored) item lists
  method item-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method item-ids-list($/) { make '[' ~ $<item-id>>>.made.join(', ') ~ ']'; }
  method scored-item-id($/) { make $<item-id>.made ~ '=' ~ $<number-value>.made ; }
  method scored-item-ids-list($/) { make '{' ~ $<scored-item-id>>>.made.join(', ') ~ '}'; }

  # (Scored) tag lists
  method tag-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-ids-list($/) { make '[' ~ $<tag-id>>>.made.join(', ') ~ ']'; }
  method scored-tag-id($/) { make $<tag-id>.made ~ '=' ~ $<number-value>.made ; }
  method scored-tag-ids-list($/) { make '{' ~ $<scored-tag-id>>>.made.join(', ') ~ '}'; }
  method tag-type-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-type-ids-list($/) { make '[' ~ $<tag-type-id>>>.made.join(', ') ~ ']'; }

  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'obj = SMRMonSetData( smrObj = obj, data = ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make 'obj = ' ~ $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'obj = SMRMonCreate( smrObj = obj )'; }
  method create-by-dataset($/) { make 'obj = SMRMonCreate( smrObj = obj, data = ' ~ $<dataset-name>.made ~ ')'; }
  method create-by-matrices($/) { make 'obj = SMRMonCreateFromMatrices( smrObj = obj, matrices = ' ~ $<variable-names-list>.made ~ ')'; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'obj = SMRMonEchoDataSummary( smrObj = obj )'; }
  method summarize-data($/) { make 'obj = SMRMonEchoDataSummary( smrObj = obj )'; }
  method items-per-tag($/) { make 'obj = SMRMonItemsPerTagDistribution( smrObj = obj )'; }
  method tags-per-items($/) { make 'obj = SMRMonTagsPerItemDistribution( smrObj = obj )'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'obj = SMRMonApplyTermWeightFunctions( smrObj = obj,' ~ $/.values[0].made ~ ')'; }
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
  method recommend-by-history($/) { make 'obj = SMRMonRecommend( smrObj = obj, history = ' ~ $<history-spec>.made ~ ')'; }
  method top-recommendations($/) { make 'obj = SMRMonGetTopRecommendations( smrObj = obj, spec = NULL, nrecs = ' ~ $<integer-value>.made ~ ')'; }
  method top-recommendations-by-history($/) { make 'obj = SMRMonRecommend( smrObj = obj, history = ' ~ $<history-spec>.made ~ ', nrecs = ' ~ $<top-recommendations><integer-value>.made ~ ')'; }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make 'obj = SMRMonRecommendByProfile( smrObj = obj, profile = ' ~ $<profile-spec>.made ~ ')'; }
  method top-profile-recommendations($/) { make 'obj = SMRMonGetTopRecommendations( smrObj = obj, spec = NULL, nrecs = ' ~ $<integer-value>.made ~ ')'; }
  method top-recommendations-by-profile($/) { make 'obj = SMRMonRecommendByProfile( smrObj = obj, profile = ' ~ $<profile-spec>.made ~ ', nrecs = ' ~ $<top-recommendations><integer-value>.made ~ ')'; }
  method profile-spec($/) { make $/.values[0].made; }

  # Make profile
  method make-profile-command($/) { make 'obj = SMRMonProfile( smrObj = obj, history = ' ~ $<history-spec>.made ~ ')'; }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make 'obj = SMRMonJoinAcross( smrObj = obj, data = ' ~ $<dataset-name>.made ~ ', by = ' ~ $<extension-data-id-column-spec>.made ~ ' )';
    } else {
      make 'obj = SMRMonJoinAcross( smrObj = obj, data = ' ~ $<dataset-name>.made ~ ' )';
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'obj = SMRMonClassifyByProfile( smrObj = obj, tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ', nTopNNs = ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make 'obj = SMRMonClassifyByProfile( smrObj = obj, tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'obj = SMRMonClassifyByProfile( smrObj = obj, tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ', nTopNNs = ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make 'obj = SMRMonClassifyByProfile( smrObj = obj, tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'classify'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'obj = SMRPlotScores( smrObj = obj )'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'obj = SMRMonGetProperty( smrObj = ob, ' ~ $/.values[0].made ~ '); print( SMRMonEchoValue( smrObj = obj ) )'; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make 'obj = SMRMonGetMatrixProperty( smrObj = obj, ' ~ $<smr-matrix-property>.made ~ ', tagType = NULL ); print( SMRMonEchoValue( smrObj = obj ) )'; }
  method smr-sub-matrix-property-spec($/) { make 'obj = SMRMonGetMatrixProperty( smrObj = obj, ' ~ $<smr-matrix-property>.made ~ ', tagType = ' ~ $<tag-type-id>.made ~ ' ); print( SMRMonEchoValue( smrObj = obj ) )'; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"numberOfColumns"'; }
  method number-of-rows($/) { make '"numberOfRows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make 'obj = SMRMonFilterMatrix( smrObj = obj, profile = ' ~ $<profile-spec>.made ~ ')';  }

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make 'obj = SMRMonMakeTagTypeRecommender( obj, tagTypeTo = ' ~ $<tag-type-id>.made ~ ' )'; }
  method make-metadata-recommender-full($/) { make 'obj = SMRMonMakeTagTypeRecommender( obj, tagTypeTo = ' ~ $<tag-type-id>.made ~ ', tagTypes = ' ~ $<tag-type-ids-list>.made ~ ' )'; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make 'obj = SMRMonAnnexSubMatrix( newSubMat = ' ~ $<mat>.made ~ ', newTagType = ' ~ $<tagtype>.made ~ ' )';
    } else {
      make 'obj = SMRMonAnnexSubMatrix( newSubMat = ' ~ $<mat>.made ~ ', newTagType = "NewType" )';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make 'obj = SMRJoin( smr2 = ' ~ $<smr>.made ~ ', joinType = '  ~ $<jointype>.made ~ ' )';
    } else {
      make 'obj = SMRJoin( smr2 = ' ~ $<smr>.made ~ ' )';
    }
  }
  method remove-tag-types-commands($/) { make 'obj = SMRRemoveTagTypes( removeTagTypes = ' ~ $/.values[0].made ~ ' )'; }

  # Pipeline command overwrites
  ## Value
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
    make 'SETUPCODE' => "print(\"Not implemented\")\n";
  }
}
