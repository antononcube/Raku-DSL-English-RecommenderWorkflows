use v6;

use  DSL::Shared::Actions::Bulgarian::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::Bulgarian::Standard
        is DSL::Shared::Actions::Bulgarian::PipelineCommand {

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
  method load-data($/) { make 'присвои таблицата: ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'създай с ' ~  $<dataset-name>.made; }
  method create-by-dataset($/) { make 'създай с таблицата: ' ~ $<dataset-name>.made; }
  method create-by-matrices($/) { make 'създай с матриците: ' ~ $<variable-names-list>.made; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'покажи обобщение на данните'; }
  method summarize-data($/) { make 'покажи обобщение на данните'; }
  method items-per-tag($/) { make 'дистрибуция по етикетите'; }
  method tags-per-items($/) { make 'дистрибуция на нещата'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'приложи тегловите функции: ' ~ $/.values[0].made}
  method lsi-apply-verb($/) { make $/.Str; }
  method lsi-funcs-simple-list($/) { make $<lsi-global-func>.made ~ ', ' ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>.made ; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make 'глобално-теглова функция: ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make 'локално-теглова функция: ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"TermFrequency"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make 'нормализираща функция: ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) { make 'препоръчай с историята: ' ~ $<history-spec>.made ~ ')'; }
  method top-recommendations($/) { make 'дай най-горните ' ~ $<integer-value>.made ~ ' препоръки'; }
  method top-recommendations-by-history($/) { make 'намери ' ~ $<top-recommendations><integer-value>.made ~ ' препоръки с историята: ' ~ $<history-spec>.made; }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make 'препоръчай с профила: ' ~ $<profile-spec>.made  }
  method top-profile-recommendations($/) { make 'дай най-горните ' ~ $<integer-value>.made ~ ' препоръки'; }
  method top-recommendations-by-profile($/) { make 'намери ' ~ $<top-recommendations><integer-value>.made ~ ' препоръки с профила: ' ~ $<profile-spec>.made; }
  method profile-spec($/) { make $/.values[0].made; }

  # Make profile
  method make-profile-command($/) { make 'намери профила на историята: ' ~ $<history-spec>.made }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make 'напречно съединение с таблицата: ' ~ $<dataset-name>.made ~ ', по колоната: ' ~ $<extension-data-id-column-spec>.made;
    } else {
      make 'напречно съединение с таблицата: ' ~ $<dataset-name>.made;
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'класифицирай към типа: ' ~ $<tag-type-id>.made ~ ', с профила: ' ~ $<profile-spec>.made ~ ', използвайки ' ~ $<ntop-nns>.made ~ ' най-близки съседи';
    } else {
      make 'класифицирай към типа: ' ~ $<tag-type-id>.made ~ ', с профила: ' ~ $<profile-spec>.made;
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'класифицирай към типа: ' ~ $<tag-type-id>.made ~ ', с профила: ' ~ $<profile-spec>.made ~ ', използвайки ' ~ $<ntop-nns>.made ~ ' най-близки съседи';
    } else {
      make 'класифицирай към типа: ' ~ $<tag-type-id>.made ~ ', с профила: ' ~ $<profile-spec>.made;
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'класифицирай'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'начертай препоръчителните стойности'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'дай стойноста: ' ~ $/.values[0].made; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make 'дай матричното свойство: ' ~ $<smr-matrix-property>.made; }
  method smr-sub-matrix-property-spec($/) { make 'дай матричното свойство: ' ~ $<smr-matrix-property>.made ~ ' за типа: ' ~ $<tag-type-id>.made; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"number_of_columns"'; }
  method number-of-rows($/) { make '"number_of_rows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make 'филтрирай препоръчителната матрицата с профила: ' ~ $<profile-spec>.made;  }

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make 'направи мета-даннов препоръчителен обект за типа: ' ~ $<tag-type-id>.made ~ ' )'; }
  method make-metadata-recommender-full($/) { make 'направи мета-даннов препоръчителен обект за типа: ' ~ $<tag-type-id>.made ~ ', ползвайки типовете: ' ~ $<tag-type-ids-list>.made; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make 'разшири с под-матрицата: ' ~ $<mat>.made ~ ', съответваща на типа: ' ~ $<tagtype>.made;
    } else {
      make 'разшири с под-матрицата: ' ~ $<mat>.made ~ ', съответваща на типа "NewType"';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make 'съедини с: ' ~ $<smr>.made ~ ', с тип на съединението: '  ~ $<jointype>.made;
    } else {
      make 'съедини с: ' ~ $<smr>.made;
    }
  }
  method remove-tag-types-commands($/) { make 'премахни типовете: ' ~ $/.values[0].made}

  # Pipeline command overwrites
  ## Value
  method take-pipeline-value($/) { make 'вземи текущата лентова стойност'; }
  method echo-pipeline-value($/) { make 'покажи текущата лентова стойност'; }
  method echo-pipeline-funciton-value($/) { make 'покажи текущата лентова стойност преобразувана с: ' ~ $<pipeline-function-spec>.made; }

  ## Context
  method take-pipeline-context($/) { make 'вземи контекста'; }
  method echo-pipeline-context($/) { make 'покажи контекста'; }
  method echo-pipeline-function-context($/) { make 'покажи контекста преобразуван с: ' ~ $<pipeline-function-spec>.made; }

  ## Echo messages
  method echo-command($/) { make 'покажи: ' ~ $<echo-message-spec>.made; }

  ## Setup code
  method setup-code-command($/) {
    make 'SETUPCODE' => '';
  }
}
