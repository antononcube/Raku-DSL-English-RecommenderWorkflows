use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 6;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# LSI command tests
#-----------------------------------------------------------

# 1
ok $pSMRMONCOMMAND.parse('apply to the entries idf'),
        'apply to the entries idf';

# 2
ok $pSMRMONCOMMAND.parse('apply to the matrix idf'),
        'apply to the matrix idf';

# 3
ok $pSMRMONCOMMAND.parse('apply to item term matrix entries the functions cosine'),
        'apply to item term matrix entries the functions cosine';

# 4
ok $pSMRMONCOMMAND.parse('apply lsi functions idf, none, cosine'),
        'apply lsi functions idf, none, cosine';

# 5
ok $pSMRMONCOMMAND
        .parse('apply lsi functions global weight function idf, local term weight function none, normalizer function cosine'),
        'apply lsi functions global weight function idf, local term weight function none, normalizer function cosine';

# 6
ok $pSMRMONCOMMAND.parse('apply the lsi normalization function cosine'),
        'apply the lsi normalization function cosine';

done-testing;