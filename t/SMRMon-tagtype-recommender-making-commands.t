use v6;
use lib 'lib';
use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 4;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

#-----------------------------------------------------------
# Tag type recommender making
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('make tag type recommender for passengerClass'),
'make tag type recommender for passengerClass';

ok $pSMRMONCOMMAND.parse('make a metadata recommender for passengerClass'),
'make a metadata recommender for passengerClass';

ok $pSMRMONCOMMAND.parse('make a metadata recommender for passengerClass over passengerSex and passngerAge'),
'make a metadata recommender for passengerClass over passengerSex and passngerAge';

ok $pSMRMONCOMMAND.parse('make a metadata recommender for the tag type passengerClass over the tag types passengerSex and passngerAge'),
'make a metadata recommender for passengerClass over passengerSex and passngerAge';

done-testing;