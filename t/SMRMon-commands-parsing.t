use v6;
use lib 'lib';
use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 2;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;


#-----------------------------------------------------------
# General pipeline commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('filter the recommendation matrix with rr, jj, kk, pp'),
'filter the recommendation matrix with rr, jj, kk, pp';


ok $pSMRMONCOMMAND.parse('show pipeline value'),
'show pipeline value';

done-testing;