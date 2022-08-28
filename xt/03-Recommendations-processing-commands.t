use v6.d;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 3;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

#-----------------------------------------------------------
# Explanations commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('explain the recommendation id.122 using the profile of id.999'),
        'explain the recommendation id.122 using the profile of id.999';

#-----------------------------------------------------------
# Extend recommendations
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('join recommendations with the dataset ds1 via the column "passenger"'),
        'join recommendations with the dataset ds1 via the column "passenger"';

#-----------------------------------------------------------
# Filter recommendations
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('filter recommendations with tag1 and tag2'),
        'filter recommendations with tag1 and tag2';

done-testing;
