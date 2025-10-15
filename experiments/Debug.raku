#use lib <. lib>;
use DSL::English::RecommenderWorkflows;
use DSL::English::RecommenderWorkflows::Grammar;
use DSL::English::RecommenderWorkflows::Actions::WL::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::R::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::Python::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::Bulgarian::Standard;
use DSL::English::RecommenderWorkflows::Actions::English::Standard;
use DSL::English::RecommenderWorkflows::Actions::Russian::Standard;

# Shortcuts
#-----------------------------------------------------------
my $pCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

sub smr-subparse(Str:D $command, Str:D :$rule = 'TOP') {
    $pCOMMAND.subparse($command, :$rule);
}

sub smr-parse(Str:D $command, Str:D :$rule = 'TOP') {
    $pCOMMAND.parse($command, :$rule);
}

sub smr-interpret(Str:D $command,
                  Str:D:$rule = 'TOP',
                  :$actions = DSL::English::RecommenderWorkflows::Actions::Russian::Standard.new) {
    $pCOMMAND.parse($command, :$rule, :$actions).made;
}


#my $pres3 = smr-parse('retrieve with should (survived) must (male and 1st), must not (female)', rule => 'TOP');
#my $pres3 = smr-parse('create with the dataset dsRand using the column id', rule => 'TOP');
my $pres3 = smr-parse('joins across with the dataset dsRand on id', rule => 'TOP');

say $pres3;

#say smr-interpret('retrieve with should (survived) must (male and 1st) must not (female)');
#say smr-interpret('create with the dataset dsRand using the column id');
say smr-interpret('joins across with the dataset dsRand on id');
say smr-interpret('joins across');