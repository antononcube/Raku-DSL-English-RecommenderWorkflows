use v6;

use  DSL::Shared::Actions::English::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::English::Standard
        is DSL::Shared::Actions::English::PipelineCommand {

  # Separator
  method separator() { '' }

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
  method scored-item-id($/) { make $<item-id>.made ~ ':' ~ $<number-value>.made ; }
  method scored-item-ids-list($/) { make '{' ~ $<scored-item-id>>>.made.join(', ') ~ '}'; }

  # (Scored) tag lists
  method tag-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-ids-list($/) { make '[' ~ $<tag-id>>>.made.join(', ') ~ ']'; }
  method scored-tag-id($/) { make $<tag-id>.made ~ ':' ~ $<number-value>.made ; }
  method scored-tag-ids-list($/) { make '{' ~ $<scored-tag-id>>>.made.join(', ') ~ '}'; }
  method tag-type-id($/) { make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"'; }
  method tag-type-ids-list($/) { make '[' ~ $<tag-type-id>>>.made.join(', ') ~ ']'; }

  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'set the data table: ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'create with data table: ' ~  $<dataset-name>.made; }
  method create-by-dataset($/) { make 'create with data table: ' ~ $<dataset-name>.made; }
  method create-by-matrices($/) { make 'create with the matrices: ' ~ $<variable-names-list>.made; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'show data summary'; }
  method summarize-data($/) { make 'summarize data'; }
  method items-per-tag($/) { make 'find distributions of items per tag'; }
  method tags-per-items($/) { make 'find distribitions of tags per item'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'apply the term weight functions: ' ~ $/.values[0].made}
  method lsi-apply-verb($/) { make $/.Str; }
  method lsi-funcs-simple-list($/) { make $<lsi-global-func>.made ~ ', ' ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>.made ; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make 'global weight function: ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make 'local weight function: ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"TermFrequency"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make 'normalizing function: ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) { make 'recommend by history with: ' ~ $<history-spec>.made ~ ')'; }
  method top-recommendations($/) { make 'give top ' ~ $<integer-value>.made ~ ' recommendations'; }
  method top-recommendations-by-history($/) { make 'give top ' ~ $<top-recommendations><integer-value>.made ~ ' recommendations with the history ' ~ $<history-spec>.made; }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make 'recommend with the profile: ' ~ $<profile-spec>.made  }
  method top-profile-recommendations($/) { make 'give top ' ~ $<integer-value>.made ~ ' recommendations'; }
  method top-recommendations-by-profile($/) { make 'give top ' ~ $<top-recommendations><integer-value>.made ~ ' recommendations with the profile: ' ~ $<profile-spec>.made; }
  method profile-spec($/) { make $/.values[0].made; }

  # Make profile
  method make-profile-command($/) { make 'find profile of the history: ' ~ $<history-spec>.made }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make 'join across with the data table: ' ~ $<dataset-name>.made ~ ', using the column: ' ~ $<extension-data-id-column-spec>.made;
    } else {
      make 'join across with the data table: ' ~ $<dataset-name>.made;
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'classify to the tag type: ' ~ $<tag-type-id>.made ~ ', with the profile: ' ~ $<profile-spec>.made ~ ', using ' ~ $<ntop-nns>.made ~ ' nearest neighbors';
    } else {
      make 'classify to the tag type: ' ~ $<tag-type-id>.made ~ ', with the profile: ' ~ $<profile-spec>.made;
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'classify to the tag type: ' ~ $<tag-type-id>.made ~ ', with the profile: ' ~ $<profile-spec>.made ~ ', using ' ~ $<ntop-nns>.made ~ ' nearest neighbors';
    } else {
      make 'classify to the tag type: ' ~ $<tag-type-id>.made ~ ', with the profile: ' ~ $<profile-spec>.made;
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'classify'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'plot recommendation scores'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'get the value: ' ~ $/.values[0].made; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make 'get the matrix property: ' ~ $<smr-matrix-property>.made; }
  method smr-sub-matrix-property-spec($/) { make 'get the matrix property: ' ~ $<smr-matrix-property>.made ~ ' for the tag type: ' ~ $<tag-type-id>.made; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"number_of_columns"'; }
  method number-of-rows($/) { make '"number_of_rows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make 'filter the recommender matrix with the profile: ' ~ $<profile-spec>.made;  }

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make 'make metadata recommender for the tag type: ' ~ $<tag-type-id>.made ~ ' )'; }
  method make-metadata-recommender-full($/) { make 'make metadata recommender for the tag type: ' ~ $<tag-type-id>.made ~ ', using the tag types: ' ~ $<tag-type-ids-list>.made; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make 'extend with sub-matrix: ' ~ $<mat>.made ~ ', corresponding to the tag type: ' ~ $<tagtype>.made;
    } else {
      make 'extend with sub-matrix: ' ~ $<mat>.made ~ ', corresponding to the tag type "NewType"';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make 'join with: ' ~ $<smr>.made ~ ', with the joining type: '  ~ $<jointype>.made;
    } else {
      make 'join with: ' ~ $<smr>.made;
    }
  }
  method remove-tag-types-commands($/) { make 'remove the tag type: ' ~ $/.values[0].made}

  # Pipeline command overwrites
  ## Object
  method assign-pipeline-object-to($/) { make 'assign the pipeline object to: ' ~ $/.values[0].made; }

  ## Value
  method take-pipeline-value($/) { make 'take the pipeline value'; }
  method echo-pipeline-value($/) { make 'echo the pipeline value'; }
  method echo-pipeline-funciton-value($/) { make 'echo the pipeline value transformed with: ' ~ $<pipeline-function-spec>.made; }

  ## Context
  method take-pipeline-context($/) { make 'take the context'; }
  method echo-pipeline-context($/) { make 'echo the context'; }
  method echo-pipeline-function-context($/) { make 'echo the context tranformed with: ' ~ $<pipeline-function-spec>.made; }

  ## Echo messages
  method echo-command($/) { make 'echo the message: ' ~ $<echo-message-spec>.made; }

  ## Setup code
  method setup-code-command($/) {
    make 'SETUPCODE' => '';
  }
}
