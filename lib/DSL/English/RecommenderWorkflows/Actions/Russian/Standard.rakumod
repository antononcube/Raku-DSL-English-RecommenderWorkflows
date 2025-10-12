use v6;

use DSL::Shared::Actions::English::PipelineCommand;
use DSL::Shared::Actions::Russian::Standard::PipelineCommand;

class DSL::English::RecommenderWorkflows::Actions::Russian::Standard
        does DSL::Shared::Actions::Russian::Standard::PipelineCommand
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
  method load-data($/) { make 'назначить таблицу данных: ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'создать с ' ~  $<dataset-name>.made; }
  method create-by-dataset($/) {
    with $<colid> {
      make 'создать с таблицу: ' ~ $<dataset-name>.made ~ ' и колонку: ' ~ $<colid>.made;
    } else {
      make 'создать с таблицу: ' ~ $<dataset-name>.made;
    }
  }
  method create-by-matrices($/) { make 'создать с матрицами: ' ~ $<variable-names-list>.made; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'показать сводку данных'; }
  method summarize-data($/) { make 'показать сводку данных'; }
  method items-per-tag($/) { make 'дистрибуция етикеток'; }
  method tags-per-items($/) { make 'дистрибуция вещей'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'применять весовые функции: ' ~ $/.values[0].made}
  method lsi-apply-verb($/) { make $/.Str; }
  method lsi-funcs-simple-list($/) { make $<lsi-global-func>.made ~ ', ' ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>.made ; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make 'глобальная весовая функция: ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make 'локальная весовая функция: ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"TermFrequency"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make 'нормализующая функция: ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) { make 'рекомендуй с историей потребления: ' ~ $<history-spec>.made ~ ')'; }
  method top-recommendations($/) { make 'дать лучшие ' ~ $<integer-value>.made ~ ' рекомендации'; }
  method top-recommendations-by-history($/) { make 'найти ' ~ $<top-recommendations><integer-value>.made ~ ' рекомендации с истории: ' ~ $<history-spec>.made; }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make 'рекомендуй с профилю: ' ~ $<profile-spec>.made  }
  method top-profile-recommendations($/) { make 'дать лучшие ' ~ $<integer-value>.made ~ ' рекомендации'; }
  method top-recommendations-by-profile($/) { make 'найти ' ~ $<top-recommendations><integer-value>.made ~ ' рекомендации с профиля: ' ~ $<profile-spec>.made; }
  method profile-spec($/) { make $/.values[0].made; }

  # Retrieve by query elements
  method retrieve-by-query-elements-command($/) { make $/.values[0].made; }
  method retrieval-query-element-list($/) {
    make 'найти по элементам запроса: ' ~  $/.values>>.made.join(', ');
  }
  method retrieval-query-element($/) {
    make $<retrieval-query-element-phrase>.made ~ ' ' ~ $<profile-spec>.made;
  }
  method retrieval-query-element-phrase($/) { make $/.values[0].made; }
  method should-have-phrase($/) { make 'желательно иметь'; }
  method must-have-phrase($/) { make 'должно иметь'; }
  method must-not-have-phrase($/) { make 'должно не иметь'; }

  # Make profile
  method make-profile-command($/) { make 'найти профиль истории: ' ~ $<history-spec>.made }

  # Process recommendations command
  method extend-recommendations-command($/) { make $/.values[0].made; }
  method extend-recommendations-simple-command($/) {
    if $<extension-data-id-column-spec> {
      make 'перекрестное соединение с таблицу: ' ~ $<dataset-name>.made ~ ', по колонке: ' ~ $<extension-data-id-column-spec>.made;
    } elsif $<dataset-name> {
      make 'перекрестное соединение с таблицу: ' ~ $<dataset-name>.made;
    } else {
      make 'перекрестное соединение с монодическую таблицу';
    }
  }
  method extension-data-id-column-spec($/) { make $/.values[0].made; }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'классифицировать по типу: ' ~ $<tag-type-id>.made ~ ', с профиле: ' ~ $<profile-spec>.made ~ ', использованием ' ~ $<ntop-nns>.made ~ ' ближайших соседей';
    } else {
      make 'классифицировать по типу: ' ~ $<tag-type-id>.made ~ ', с профиле: ' ~ $<profile-spec>.made;
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'класифицирай към типа: ' ~ $<tag-type-id>.made ~ ', с профила: ' ~ $<profile-spec>.made ~ ', использованием ' ~ $<ntop-nns>.made ~ ' ближайших соседей';
    } else {
      make 'класифицирай към типа: ' ~ $<tag-type-id>.made ~ ', с профила: ' ~ $<profile-spec>.made;
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'классифицировать'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'нарисуйте рекомендуционные значения'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'дать значение: ' ~ $/.values[0].made; }
  method smr-recommendation-matrix($/) { make '"sparseMatrix"'; }
  method smr-tag-types($/) { make '"tagTypes"'; }
  method smr-item-column-name($/) { make '"itemColumnName"'; }
  method smr-sub-matrices($/) { make '"subMatrices"'; }
  method smr-matrix-property-spec($/) { make 'дать свойство матрицы: ' ~ $<smr-matrix-property>.made; }
  method smr-sub-matrix-property-spec($/) { make 'дать свойство матрицы: ' ~ $<smr-matrix-property>.made ~ ' для типа: ' ~ $<tag-type-id>.made; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '"' ~ $/.Str ~ '"'; }
  method number-of-columns($/) { make '"number_of_columns"'; }
  method number-of-rows($/) { make '"number_of_rows"'; }
  method rows($/) { make '"rows"'; }
  method columns($/) { make '"columns"'; }
  method dimensions($/) { make '"dimensions"'; }
  method density($/) { make '"density"'; }
  method properties($/) { make '"properties"';}

  method smr-filter-matrix($/) { make 'отфильтровать рекомендуемую матрицу с профилем: ' ~ $<profile-spec>.made;  }

  # Make metadata recommender command
  method make-metadata-recommender-command($/) { make $/.values[0].made; }
  method make-metadata-recommender-simple($/) { make 'сделать метаданных рекомендационный объект для типа: ' ~ $<tag-type-id>.made ~ ' )'; }
  method make-metadata-recommender-full($/) { make 'сделать метаданных рекомендационный объект для типа: ' ~ $<tag-type-id>.made ~ ', используя типы: ' ~ $<tag-type-ids-list>.made; }

  # Recommender algebra command
  method recommender-algebra-command($/) { make $/.values[0].made; }
  method annex-matrix-command($/) {
    if $<tagtype> {
      make 'расширить с подматрицы: ' ~ $<mat>.made ~ ', соответствующей типу: ' ~ $<tagtype>.made;
    } else {
      make 'расширить с подматрицы: ' ~ $<mat>.made ~ ', соответствующей типу "NewType"';
    }
  }
  method join-recommenders-command($/) {
    if $<jointype> {
      make 'соединить с: ' ~ $<smr>.made ~ ', с соединением типа: '  ~ $<jointype>.made;
    } else {
      make 'соединить с: ' ~ $<smr>.made;
    }
  }
  method remove-tag-types-commands($/) { make 'удалить типы: ' ~ $/.values[0].made}

  ## Setup code
  method setup-code-command($/) {
    make 'SETUPCODE' => '';
  }
}
