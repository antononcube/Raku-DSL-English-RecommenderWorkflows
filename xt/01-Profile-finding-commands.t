use v6.d;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 2;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# Profile finding commands
#-----------------------------------------------------------

## 1
ok $pSMRMONCOMMAND.parse('compute profile for the item gog'),
        'compute profile for the item gog';

## 2
nok $pSMRMONCOMMAND.parse('make profile with the history id.1 : 1 and id.12 : 9 '),
        'make profile with the history id.1 : 1 and id.12 : 9 ';
done-testing;