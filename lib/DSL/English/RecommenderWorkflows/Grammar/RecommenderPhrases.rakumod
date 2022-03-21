use v6;

use DSL::Shared::Utilities::FuzzyMatching;
use DSL::Shared::Roles::English::PipelineCommand;

# Recommender specific phrases
role DSL::English::RecommenderWorkflows::Grammar::RecommenderPhrases
        does DSL::Shared::Roles::English::PipelineCommand {


  proto token word-spec {*}
  token word-spec:sym<English> { :i  \w+  }

  # Regular tokens / rules

  proto token aggregate-verb {*}
  token aggregate-verb:sym<English> { :i 'aggregate' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'aggregate', 2) }> }

  proto token aggregation-noun {*}
  token aggregation-noun:sym<English> { :i 'aggregation' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'aggregation', 2) }> }

  proto token anomalies-noun {*}
  token anomalies-noun:sym<English> { :i 'anomalies' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'anomalies', 2) }> }

  proto token anomaly-noun {*}
  token anomaly-noun:sym<English> { :i 'anomaly' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'anomaly', 2) }> }

  proto token colnames-noun {*}
  token colnames-noun:sym<English> { :i 'colnames' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'colnames', 2) }> }

  proto token column-noun {*}
  token column-noun:sym<English> { :i 'column' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'column', 2) }> }

  proto token columns-noun {*}
  token columns-noun:sym<English> { :i 'columns' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'columns', 2) }> }

  proto token consumption-noun {*}
  token consumption-noun:sym<English> { :i 'consumption' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'consumption', 2) }> }

  proto token density-noun {*}
  token density-noun:sym<English> { :i 'density' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'density', 2) }> }

  proto token dimensions-noun {*}
  token dimensions-noun:sym<English> { :i 'dimensions' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'dimensions', 2) }> }

  proto token explain-verb {*}
  token explain-verb:sym<English> { :i 'explain' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'explain', 2) }> }

  proto token explanations-noun {*}
  token explanations-noun:sym<English> { :i 'explanation' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'explanation', 2) }> | 'explanations' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'explanations', 2) }> }

  proto token function-noun {*}
  token function-noun:sym<English> { :i 'function' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'function', 2) }> }

  proto token history-noun {*}
  token history-noun:sym<English> { :i 'history' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'history', 2) }> }

  proto token item-noun {*}
  token item-noun:sym<English> { :i 'item' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'item', 2) }> }

  proto token items-noun {*}
  token items-noun:sym<English> { :i 'items' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'items', 2) }> }

  proto token matrices-noun {*}
  token matrices-noun:sym<English> { :i 'matrices' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'matrices', 2) }> }

  proto token matrix-noun {*}
  token matrix-noun:sym<English> { :i 'matrix' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'matrix', 2) }> }

  proto token matrixes-noun {*}
  token matrixes-noun:sym<English> { :i 'matrixes' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'matrixes', 2) }> }

  proto token metadata-noun {*}
  token metadata-noun:sym<English> { :i 'metadata' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'metadata', 2) }> }

  proto token most-determiner {*}
  token most-determiner:sym<English> { :i 'most' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'most', 2) }> }

  proto token nearest-adjective {*}
  token nearest-adjective:sym<English> { :i 'nearest' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'nearest', 2) }> }

  proto token neighbors-noun {*}
  token neighbors-noun:sym<English> { :i 'neighbors' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'neighbors', 2) }> }

  proto token outlier-noun {*}
  token outlier-noun:sym<English> { :i 'outlier' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'outlier', 2) }> }

  proto token outliers-noun {*}
  token outliers-noun:sym<English> { :i 'outliers' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'outliers', 2) }> | 'outlier' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'outlier', 2) }> }

  proto token profile-noun {*}
  token profile-noun:sym<English> { :i 'profile' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'profile', 2) }> }

  proto token proofs-noun {*}
  token proofs-noun:sym<English> { :i 'proof' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'proof', 2) }> | 'proofs' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'proofs', 2) }> }

  proto token properties-noun {*}
  token properties-noun:sym<English> { :i 'properties' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'properties', 2) }> }

  proto token property-noun {*}
  token property-noun:sym<English> { :i 'property' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'property', 2) }> }

  proto token prove-verb {*}
  token prove-verb:sym<English> { :i 'prove' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'prove', 2) }> }

  proto token proximity-noun {*}
  token proximity-noun:sym<English> { :i 'proximity' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'proximity', 2) }> }

  proto token recommend-directive {*}
  token recommend-directive:sym<English> { :i  <recommend-verb>  }

  proto token recommend-verb {*}
  token recommend-verb:sym<English> { :i 'recommend' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'recommend', 2) }> | 'suggest' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'suggest', 2) }> }

  proto token recommendation-noun {*}
  token recommendation-noun:sym<English> { :i 'recommendation' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'recommendation', 2) }> }

  proto token recommendations-noun {*}
  token recommendations-noun:sym<English> { :i 'recommendations' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'recommendations', 2) }> }

  proto token recommended-adjective {*}
  token recommended-adjective:sym<English> { :i 'recommended' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'recommended', 2) }> }

  proto token recommender-noun {*}
  token recommender-noun:sym<English> { :i 'recommender' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'recommender', 2) }> }

  proto token relevant-adjective {*}
  token relevant-adjective:sym<English> { :i 'relevant' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'relevant', 2) }> }

  proto token row-noun {*}
  token row-noun:sym<English> { :i 'row' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'row', 1) }> }

  proto token rownames-noun {*}
  token rownames-noun:sym<English> { :i 'rownames' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'rownames', 2) }> }

  proto token rows-noun {*}
  token rows-noun:sym<English> { :i 'rows' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'rows', 2) }> }

  proto token tag-adjective {*}
  token tag-adjective:sym<English> { :i  <tag-noun>  }

  proto token tag-noun {*}
  token tag-noun:sym<English> { :i 'tag' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'tag', 1) }> }

  proto token threshold-noun {*}
  token threshold-noun:sym<English> { :i 'threshold' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'threshold', 2) }> }

  proto token type-noun {*}
  token type-noun:sym<English> { :i 'type' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'type', 2) }> }

  proto token types-noun {*}
  token types-noun:sym<English> { :i 'types' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'types', 2) }> }

  proto token sub-matrix-noun {*}
  token sub-matrix-noun:sym<English> { :i  'sub' \h+ '-' \h+ <matrix-noun>  }

  proto token sub-matrices-noun {*}
  token sub-matrices-noun:sym<English> { :i  'sub' \h+ '-' \h+ <matrices-noun>  }


  proto rule prove-directive {*}
  rule prove-directive:sym<English> {  <prove-verb> | <explain-verb>  }

  proto rule consumption-history {*}
  rule consumption-history:sym<English> {  <consumption-slot>? <history-noun>  }

  proto rule consumption-profile {*}
  rule consumption-profile:sym<English> {  <consumption-slot>? <profile-noun>  }

  proto rule cross-tabulate-phrase {*}
  rule cross-tabulate-phrase:sym<English> {  'cross' [ 'tabulate' | 'tabulation' ]  }

  proto rule extend-recommendations-phrase {*}
  rule extend-recommendations-phrase:sym<English> {  [ <extend-verb> | <join-verb> 'across'? ] <recommendations-noun>?  }

  proto rule history-phrase {*}
  rule history-phrase:sym<English> {  [ <item-noun> ]? <history-noun>  }

  proto rule most-relevant {*}
  rule most-relevant:sym<English> {  <most-determiner> <relevant-adjective>  }

  proto rule nearest-neighbors {*}
  rule nearest-neighbors:sym<English> {  <nearest-adjective> <neighbors-noun> | 'nns'  }

  proto rule recommendation-matrices {*}
  rule recommendation-matrices:sym<English> {  [ <recommendation-noun> | <recommender-noun> ]? <matrices-noun>  }

  proto rule recommendation-matrix {*}
  rule recommendation-matrix:sym<English> {  [ <recommendation-noun> | <recommender-noun> ]? <matrix-noun>  }

  proto rule recommendation-results {*}
  rule recommendation-results:sym<English> {  [ <recommendation-noun> | <recommendations-noun> | 'recommendation\'s' ] <results>  }

  proto rule recommended-items {*}
  rule recommended-items:sym<English> {  <recommended-adjective> <items-slot> | [ <recommendations-noun> | <recommendation-noun> ]  <.results>?   }

  proto rule recommender-object-phrase {*}
  rule recommender-object-phrase:sym<English> {  <recommender-noun> [ <object-noun> | <system-noun> ]? | 'smr'  }

  proto rule sparse-matrix {*}
  rule sparse-matrix:sym<English> {  <sparse-adjective> <matrix-noun>  }

  proto rule sub-matrices-phrase {*}
  rule sub-matrices-phrase:sym<English> {  <sub-matrices-noun> | <sub-prefix> <matrices-noun> | <sub-prefix> <matrixes-noun>  }

  proto rule sub-matrix-phrase {*}
  rule sub-matrix-phrase:sym<English> {  <sub-matrix-noun> | <sub-prefix> <matrix-noun>  }

  proto rule tag-type-phrase {*}
  rule tag-type-phrase:sym<English> {  [ <tag-noun> | <tag-adjective> ] <type-noun>  }

  proto rule tag-types-phrase {*}
  rule tag-types-phrase:sym<English> {  [ <tag-noun> | <tag-adjective> ] <types-noun>  }

  proto rule what-are-phrase {*}
  rule what-are-phrase:sym<English> {  <what-pronoun> [ <are-verb> | <is-verb> ]  }


  # LSA specific

  proto token analysis-noun {*}
  token analysis-noun:sym<English> { :i 'analysis' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'analysis', 2) }> }

  proto token document-noun {*}
  token document-noun:sym<English> { :i 'document' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'document', 2) }> }

  proto token entries-noun {*}
  token entries-noun:sym<English> { :i 'entries' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'entries', 2) }> }

  proto token indexing-noun {*}
  token indexing-noun:sym<English> { :i 'indexing' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'indexing', 2) }> }

  proto token ingest-verb {*}
  token ingest-verb:sym<English> { :i 'ingest' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'ingest', 2) }> | 'load' | 'use' | 'get' }

  proto token latent-adjective {*}
  token latent-adjective:sym<English> { :i 'latent' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'latent', 2) }> }

  proto token semantic-adjective {*}
  token semantic-adjective:sym<English> { :i 'semantic' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'semantic', 2) }> }

  proto token term-noun {*}
  token term-noun:sym<English> { :i 'term' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'term', 2) }> }

  proto token weight-noun {*}
  token weight-noun:sym<English> { :i 'weight' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'weight', 2) }> }

  proto token word-noun {*}
  token word-noun:sym<English> { :i 'word' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'word', 2) }> }


  proto rule doc-term-mat {*}
  rule doc-term-mat:sym<English> {  [ <document-noun> | <item-noun> ] [ <term-noun> | <word-noun> ] <matrix-noun>  }

  proto rule lsa-object {*}
  rule lsa-object:sym<English> {  <lsa-phrase>? <object-noun>  }

  proto rule lsa-phrase {*}
  rule lsa-phrase:sym<English> {  <latent-adjective> <semantic-adjective> <analysis-noun> | 'lsa' | 'LSA'  }

  proto rule lsi-phrase {*}
  rule lsi-phrase:sym<English> {  <latent-adjective> <semantic-adjective> <indexing-noun> | 'lsi' | 'LSI'  }

  proto rule matrix-entries {*}
  rule matrix-entries:sym<English> {  [ <doc-term-mat> | <matrix-noun> ]? <entries-noun>  }

  proto rule the-outliers {*}
  rule the-outliers:sym<English> {  <the-determiner> <outliers>  }

  # LSI specific

  proto token frequency-noun {*}
  token frequency-noun:sym<English> { :i 'frequency' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'frequency', 2) }> }

  proto token functions-noun {*}
  token functions-noun:sym<English> { :i 'function' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'function', 2) }> | 'functions' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'functions', 2) }> }

  proto token global-adjective {*}
  token global-adjective:sym<English> { :i 'global' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'global', 2) }> }

  proto token inverse-adjective {*}
  token inverse-adjective:sym<English> { :i 'inverse' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'inverse', 2) }> }

  proto token local-adjective {*}
  token local-adjective:sym<English> { :i 'local' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'local', 2) }> }

  proto token normalization-noun {*}
  token normalization-noun:sym<English> { :i 'normalization' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'normalization', 2) }> }

  proto token normalizer-noun {*}
  token normalizer-noun:sym<English> { :i 'normalizer' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'normalizer', 2) }> }

  proto token normalizing-noun {*}
  token normalizing-noun:sym<English> { :i 'normalizing' | ([\w]+) <?{ is-fuzzy-match($0.Str, 'normalizing', 2) }> }


  proto rule global-function-phrase {*}
  rule global-function-phrase:sym<English> {  <global-adjective> <term-noun> ?<weight-noun>? <function-noun>  }

  proto rule join-type-phrase {*}
  rule join-type-phrase:sym<English> {  <join-verb>? <type-noun>  }

  proto rule local-function-phrase {*}
  rule local-function-phrase:sym<English> {  <local-adjective> <term-noun>? <weight-noun>? <function-noun>  }

  proto rule normalizer-function-phrase {*}
  rule normalizer-function-phrase:sym<English> {  [ <normalizer-noun> | <normalizing-noun> | <normalization-noun> ] <term-noun>? <weight-noun>? <function-noun>?  }

}
