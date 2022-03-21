use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 16;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# Recommendations by history commands
#-----------------------------------------------------------

# 1
ok $pSMRMONCOMMAND.parse('recommend with history id.2:3 and id.13:4'),
        'recommend with history id.2:3 and id.13:4';

# 2
ok $pSMRMONCOMMAND.parse('recommend with history id.12:3 and id.13:4'),
        'recommend with history id.12:3 and id.13:4';

# 3
ok $pSMRMONCOMMAND.parse('recommend by history hr:3, rr:4, ra:1'),
        'recommend by history hr:3, rr:4, ra:1';

# 4
ok $pSMRMONCOMMAND.parse('find recommendations for history hr:3, rr:4, ra:1'),
        'find recommendations for history hr:3, rr:4, ra:1';

# 5
ok $pSMRMONCOMMAND.parse('find the top 12 recommendations for history hr:3, rr:4, ra:1'),
        'find the top 12 recommendations for history hr:3, rr:4, ra:1';

# 6
ok $pSMRMONCOMMAND.parse('compute 12 recommendations for the history hr:3, rr:4, ra:1'),
        'compute 12 recommendations for the history hr:3, rr:4, ra:1';


#-----------------------------------------------------------
# Recommendations by profile commands
#-----------------------------------------------------------

# 7
ok $pSMRMONCOMMAND.parse('recommend by profile hr.12->3 & rr.12->4'),
        'recommend by profile hr.12->3 & rr.12->4';

# 8
ok $pSMRMONCOMMAND.parse('recommend with profile hr.12 -> 3 and rr.12 -> 4'),
        'recommend with profile hr.12 -> 3 and rr.12 -> 4';

# 9
ok $pSMRMONCOMMAND.parse('recommend by profile hr.12 -> 3 and rr.12 -> 4'),
        'recommend by profile hr.12 -> 3 and rr.12 -> 4';

# 10
ok $pSMRMONCOMMAND.parse('recommend by profile hr=3, rr=4, ra=1'),
        'recommend by profile hr=3, rr=4, ra=1';


#-----------------------------------------------------------
# Recommendations universal commands
#-----------------------------------------------------------

# 11
ok $pSMRMONCOMMAND.parse('find the top 5 recommendations'),
        'find the top 5 recommendations';

# 12
ok $pSMRMONCOMMAND.parse('find the top 15 profile recommendations'),
        'find the top 15 profile recommendations';

# 13
ok $pSMRMONCOMMAND.parse('find the top 15 recommendations for the profile hr=2, jj=2'),
        'find the top 15 recommendations for the profile hr=2, jj=2';

# 14
ok $pSMRMONCOMMAND.parse('what are the top 7 recommendations'),
        'what are the top 7 recommendations';

# 15
ok $pSMRMONCOMMAND.parse('what are the most relevant recommendations'),
        'what are the most relevant recommendations';

# 16
ok $pSMRMONCOMMAND.parse('compute the 12 most relevant recommendations'),
        'compute the 12 most relevant recommendations';

done-testing;