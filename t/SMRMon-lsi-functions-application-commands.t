use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 11;

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
ok $pSMRMONCOMMAND.parse('apply to the matrix entries idf'),
        'apply to the matrix entries idf';

# 4
ok $pSMRMONCOMMAND.parse('apply to item term matrix entries the functions cosine'),
        'apply to item term matrix entries the functions cosine';

# 5
ok $pSMRMONCOMMAND.parse('apply to the matrix entries lsi functions frequency'),
        'apply to the matrix entries lsi functions frequency';

# 6
ok $pSMRMONCOMMAND.parse('apply to matrix entries idf, cosine and binary'),
        'apply to matrix entries idf, cosine and binary';

# 7
ok $pSMRMONCOMMAND.parse('apply to the matrix entries idf, binary and cosine normalization'),
        'apply to the matrix entries idf, binary and cosine normalization';

# 8
ok $pSMRMONCOMMAND.parse('apply lsi functions idf, none, cosine'),
        'apply lsi functions idf, none, cosine';

# 9
nok $pSMRMONCOMMAND.parse('use the lsi functions idf none cosine'),
        'use the lsi functions idf none cosine';

# 10
ok $pSMRMONCOMMAND
        .parse('apply lsi functions global weight function idf, local term weight function none, normalizer function cosine'),
        'apply lsi functions global weight function idf, local term weight function none, normalizer function cosine';

# 11
ok $pSMRMONCOMMAND.parse('apply the lsi normalization function cosine'),
        'apply the lsi normalization function cosine';

done-testing;