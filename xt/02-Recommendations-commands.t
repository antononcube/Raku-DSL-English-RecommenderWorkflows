use v6.d;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 1;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# Recommendations by history commands
#-----------------------------------------------------------

#-----------------------------------------------------------
# Recommendations by profile commands
#-----------------------------------------------------------

#-----------------------------------------------------------
# Recommendations universal commands
#-----------------------------------------------------------

# 12
ok $pSMRMONCOMMAND.parse('find the top 15 profile recommendations'),
        'find the top 15 profile recommendations';


done-testing;