use v6;
use lib 'lib';
use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 2;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar.new;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------


ok $pSMRMONCOMMAND.parse('create the recommender wit dataseta ds1'),
        'create the recommender wit dataseta ds1';

ok $pSMRMONCOMMAND.parse('create using the matrixes <||>'),
        'create using the matrixes <||>';



done-testing;