use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 6;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# Profile finding commands
#-----------------------------------------------------------

## 1
ok $pSMRMONCOMMAND.parse('compute the profile for the history hr=3, rr=4, ra=1'),
        'compute the profile for the history hr=3, rr=4, ra=1';

## 2
ok $pSMRMONCOMMAND.parse('compute profile for history gog'),
        'compute profile for history gog';

## 3
ok $pSMRMONCOMMAND.parse('compute recommendations'),
        'compute recommendations';

## 4
ok $pSMRMONCOMMAND.parse('compute the recommendations'),
        'compute the recommendations';

## 5
ok $pSMRMONCOMMAND.parse('find profile for the history K-2108=3, K-2179=2, M-2292=1'),
        'find profile for the history K-2108=3, K-2179=2, M-2292=1';

## 6
ok $pSMRMONCOMMAND.parse('compute the profile for the history K-2108=3, K-2179=2, M-2292=1'),
        'compute the profile for the history K-2108=3, K-2179=2, M-2292=1';

done-testing;