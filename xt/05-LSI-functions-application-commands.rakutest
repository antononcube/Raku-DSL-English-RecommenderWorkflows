use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 4;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# LSI command tests
#-----------------------------------------------------------

# 1
ok $pSMRMONCOMMAND.parse('apply to the matrix entries idf'),
        'apply to the matrix entries idf';

# 2
ok $pSMRMONCOMMAND.parse('apply to the matrix entries lsi functions frequency'),
        'apply to the matrix entries lsi functions frequency';

# 3
ok $pSMRMONCOMMAND.parse('apply to matrix entries idf, cosine and binary'),
        'apply to matrix entries idf, cosine and binary';

# 4
ok $pSMRMONCOMMAND.parse('apply to the matrix entries idf, binary and cosine normalization'),
        'apply to the matrix entries idf, binary and cosine normalization';

# 5
nok $pSMRMONCOMMAND.parse('use the lsi functions idf none cosine'),
        'use the lsi functions idf none cosine';

done-testing;