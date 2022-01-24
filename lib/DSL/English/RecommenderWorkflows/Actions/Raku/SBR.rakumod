=begin comment
#==============================================================================
#
#   Raku Streams Blending Recommender (SBR) actions in Raku
#   Copyright (C) 2021  Anton Antonov
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
#   antononcube <at> posteo <dot> net
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku see https://raku.org/ .
#
#==============================================================================
#
#   The actions are implemented for the grammar:
#
#     DSL::English::RecommenderWorkflows::Grammar
#
#   and the Raku package :
#
#     https://github.com/antononcube/Raku-ML-StreamsBlendingRecommender
#
#==============================================================================
=end comment

use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use DSL::Shared::Actions::English::Python::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::Raku::SBR
        is DSL::Shared::Actions::English::Python::PipelineCommand {

  # Separator
  method separator() { ";\n" }

  # Top
  method TOP($/) { make $/.values[0].made; }

  # workflow-command-list
  method workflow-commands-list($/) { make $/.values>>.made.join( self.separator() ); }

  # workflow-command
  method workflow-command($/) { make $/.values[0].made; }

  # General
  method variable-names-list($/) { make '(' ~ $<variable-name>>>.made.join(', ') ~ ')'; }

  # (Scored) item lists
  method item-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method item-ids-list($/) { make '(' ~ $<item-id>>>.made.join(', ') ~ ')'; }
  method scored-item-id($/) { make $<item-id>.made ~ '=>' ~ $<number-value>.made; }
  method scored-item-ids-list($/) { make '%(' ~ $<scored-item-id>>>.made.join(', ') ~ ')'; }

  # (Scored) tag lists
  method tag-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-ids-list($/) { make '(' ~ $<tag-id>>>.made.join(', ') ~ ')'; }
  method scored-tag-id($/) { make $<tag-id>.made ~ '=>' ~ $<number-value>.made; }
  method scored-tag-ids-list($/) { make '%(' ~ $<scored-tag-id>>>.made.join(', ') ~ ')'; }
  method tag-type-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-type-ids-list($/) { make '(' ~ $<tag-type-id>>>.made.join(', ') ~ ')'; }

  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make '$sbrObj.setData( ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'my $sbrObj = ML::StreamsBlendingRecommender::CoreSBR.new'; }
  method create-by-dataset($/) { make self.create-simple($/) ~ ";\n" ~ '$sbrObj.makeTagInverseIndexesFromWideForm( ' ~ $<dataset-name>.made ~ ')'; }
  method create-by-matrices($/) { make '$sbrObj.ingestMatrices( ' ~ $<creation-matrices-spec>.made ~ ')'; }
  method creation-matrices-spec($/) { make $/.values[0].made; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make '$sbrObj.getDataSummary()'; }
  method summarize-data($/) { make '$sbrObj.getDataSummary()'; }
  method items-per-tag($/) { make '$sbrObj.getItemsPerTagDistribution()'; }
  method tags-per-items($/) { make '$sbrObj.getTagsPerItemDistribution()'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make '$sbrObj.applyTermWeightFunctions(' ~ $/.values[0].made ~ ')'; }
  method lsi-apply-verb($/) { make $/.Str; }
  method lsi-funcs-simple-list($/) { make $<lsi-global-func>.made ~ ', ' ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>.made ; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make 'globalWeightFunction => ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make 'localWeightFunction = ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"TermFrequency"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make 'normalizerFunction => ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) { make '$sbrObj.recommend( ' ~ $<history-spec>.made ~ ')'; }
  method top-recommendations($/) {
    if $<integer-value> {
      make '$sbrObj.getTopRecommendations( spec => NULL, nrecs => ' ~ $<integer-value>.made ~ ')';
    } else {
      make '$sbrObj.getTopRecommendations( spec => NULL )';
    }
  }
  method top-recommendations-by-history($/) {
    if $<top-recommendations><integer-value> {
      make '$sbrObj.recommend( ' ~ $<history-spec>.made ~ ', ' ~ $<top-recommendations><integer-value>.made ~ ')';
    } else {
      make '$sbrObj.recommend( ' ~ $<history-spec>.made ~ ')';
    }
  }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make '$sbrObj.recommendByProfile( profile => ' ~ $<profile-spec>.made ~ ')'; }
  method top-profile-recommendations($/) {
    if $<integer-value> {
      make '$sbrObj.getTopRecommendations( spec => NULL, nrecs => ' ~ $<integer-value>.made ~ ')';
    } else {
      make '$sbrObj.getTopRecommendations( spec => NULL )';
    }
  }
  method top-recommendations-by-profile($/) {
    if $<top-recommendations><integer-value> {
      make '$sbrObj.recommendByProfile( ' ~ $<profile-spec>.made ~ ', ' ~ $<top-recommendations><integer-value>.made ~ ')';
    } else {
      make '$sbrObj.recommendByProfile( ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method profile-spec($/) { make $/.values[0].made; }

  # Make profile
  method make-profile-command($/) { make '$sbrObj.profile( ' ~ $<history-spec>.made ~ ')'; }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make '$sbrObj.joinAcross( ' ~ $<dataset-name>.made ~ ', ' ~ $<extension-data-id-column-spec>.made ~ ' )';
    } else {
      make '$sbrObj.joinAcross( ' ~ $<dataset-name>.made ~ ' )';
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Prove recommendations command
  method prove-recommendations-command($/) { make $/.values[0].made; }

  method proof-item-spec($/) { make $/.values[0].made; }

  method prove-by-metadata($/) {
    if ( $<profile-spec> && $<proof-item-spec> ) {
      make '$sbrObj.proveByMetadata( profile => ' ~ $<profile-spec>.made ~ ', items => ' ~ $<proof-item-spec>.made ~ ')';
    } elsif ( $<profile-spec> ) {
      make '$sbrObj.proveByMetadata( profile => ' ~ $<profile-spec>.made ~ ', items => NULL )';
    } elsif ( $<proof-item-spec> ) {
      make '$sbrObj.proveByMetadata( profile => NULL, items => ' ~ $<proof-item-spec>.made ~ ')';
    } else {
      make '$sbrObj.proveByMetadata( profile => NULL, items => NULL )';
    }
  }

  method prove-by-history($/) {
    if ( $<history-spec> && $<proof-item-spec> ) {
      make '$sbrObj.proveByHistory( history => ' ~ $<history-spec>.made ~ ', items => ' ~ $<proof-item-spec>.made ~ ')';
    } elsif ( $<profile-spec> ) {
      make '$sbrObj.proveByHistory( history => ' ~ $<history-spec>.made ~ ', items => NULL )';
    } elsif ( $<proof-item-spec> ) {
      make '$sbrObj.proveByHistory( history => NULL, items => ' ~ $<proof-item-spec>.made ~ ')';
    } else {
      make '$sbrObj.proveByHistory( history => NULL, items => NULL )';
    }
  }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make '$sbrObj.classifyByProfile( tagType => ' ~ $<tag-type-id>.made ~ ', profile => ' ~ $<profile-spec>.made ~ ', nTopNNs => ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make '$sbrObj.classifyByProfile( tagType => ' ~ $<tag-type-id>.made ~ ', profile => ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make '$sbrObj.classifyByProfile( tagType => ' ~ $<tag-type-id>.made ~ ', profile => ' ~ $<profile-spec>.made ~ ', nTopNNs => ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make '$sbrObj.classifyByProfile( tagType => ' ~ $<tag-type-id>.made ~ ', profile => ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'classify'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make '$sbrObj.plotScores()'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-recommender-matrix-query($/) { make $<smr-matrix-property-spec>.made; }

  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make '$smrObj.getProperty(' ~ $/.values[0].made ~ ')'; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make '$sbrObj.getMatrixProperty(' ~ $<smr-matrix-property>.made ~ ', tagType => NULL )'; }
  method smr-sub-matrix-property-spec($/) { make '$sbrObj.getMatrixProperty(' ~ $<smr-matrix-property>.made ~ ', tagType => ' ~ $<tag-type-id>.made ~ ' )'; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"numberOfColumns"'; }
  method number-of-rows($/) { make '"numberOfRows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make '$sbrObj.filterMatrix( ' ~ $<profile-spec>.made ~ ' )';  }

  # Find anomalies command

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make '$sbrObj.makeTagTypeRecommender( tagTypeTo => ' ~ $<tag-type-id>.made ~ ' )'; }
  method make-metadata-recommender-full($/) { make '$sbrObj.makeTagTypeRecommender( tagTypeTo => ' ~ $<tag-type-id>.made ~ ', tagTypes => ' ~ $<tag-type-ids-list>.made ~ ' )'; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make '$sbrObj.annexSubMatrix( ' ~ $<mat>.made ~ ', ' ~ $<tagtype>.made ~ ' )';
    } else {
      make '$sbrObj.annexSubMatrix( ' ~ $<mat>.made ~ ', "NewType" )';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make '$sbrObj.join( ' ~ $<smr>.made ~ ', '  ~ $<jointype>.made ~ ' )';
    } else {
      make '$sbrObj.join( ' ~ $<smr>.made ~ ' )';
    }
  }
  method remove-tag-types-commands($/) { make '$sbrObj.removeTagTypes( ' ~ $/.values[0].made ~ ' )'; }

  # Pipeline command overwrites
  ## Object
  method assign-pipeline-object-to($/) { make $/.values[0].made ~ ' = $sbrObj'; }

  ## Value
  method assign-pipeline-value-to($/) { make $/.values[0].made ~ ' = $sbrObj.takeValue';  }
  method take-pipeline-value($/) { make '$sbrObj.takeValue'; }
  method echo-pipeline-value($/) { make 'say $sbrObj.takeValue'; }
  method echo-pipeline-funciton-value($/) { make 'say ' ~ $<pipeline-function-spec>.made ~ '( $sbrObj.takeValue )'; }

  ## Context
  method take-pipeline-context($/) { make '$sbrObj'; }
  method echo-pipeline-context($/) { make '$sbrObj'; }
  method echo-pipeline-function-context($/) { make '$sbrObj.applyFunctionToContext( ' ~ $<pipeline-function-spec>.made ~ ' )'; }

  ## Echo messages
  method echo-command($/) { make 'say ' ~ $<echo-message-spec>.made; }

  ## Setup code
  method setup-code-command($/) {
    make 'SETUPCODE' => q:to/SETUPEND/
    use ML::StreamsBlendingRecommender;
    use ML::StreamsBlendingRecommender::CoreSBR;
    use ML::StreamsBlendingRecommender::LSAEndowedSBR;
    SETUPEND
  }
}
