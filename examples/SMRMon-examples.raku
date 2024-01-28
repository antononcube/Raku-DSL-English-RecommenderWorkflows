use lib './lib';
use lib '.';
use DSL::English::RecommenderWorkflows;
use DSL::English::RecommenderWorkflows::Grammar;

use JSON::Marshal;

# Shortcuts
#-----------------------------------------------------------
my $pCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

sub smr-parse(Str:D $command, Str:D :$rule = 'TOP') {
    $pCOMMAND.parse($command, :$rule);
}

sub smr-interpret(Str:D $command,
                  Str:D:$rule = 'TOP',
                  :$actions = DSL::English::RecommenderWorkflows::Actions::WL::SMRMon.new) {
    $pCOMMAND.parse($command, :$rule, :$actions).made;
}

#----------------------------------------------------------


#say ToRecommenderWorkflowCode('
#use smrObj2;
#make metadata recommender for tag type passengerClass over passengerAge and passengerSex;
#recommend by profile male;
#join across with dfTitanic by id column "id"',
#        'R-SMRMon');

#say ToRecommenderWorkflowCode('
#DSL TARGET WL-SMRMon;
#use smrObj;
#recommend by profile Word:quantile, Symbol:nonlinearmodelfit; join across with dsNotebooksdata;
#echo pipeline value',
#        'R-SMRMon');

#my @commands = (
#'create from dfTitanic;
#recommend by profile hr.12=3 and rr.12->4;
#join with recommender smrObj2 with join type "left";
#annex the matrix `smats[[1]]` using tag type "Gen2";
#remove tag types "Gen1", Gen3;
#assign pipeline value to smrObjNew;
#');

my @commands = (
'include setup code
create from dfTitanic
recommend by profile hr.12=3 and rr.12->4
recommend by history item.1=1 and item.2=0.3
classify to TagType1 the profile hr:12, hr:7
classify by profile hr:12, hr:7 to tag type TagType2
extend recommendations with dfTitanicData by "IDVAR"
explain the recommendations
echo value
assign pipeline value to XXDF1
');

#my @commands = ('
#use recommender smrObj;
#recommend by profile Groceries;
#join across with dfMint by column ID;
#echo pipeline value;
#');

#my @targets = <WL-SMRMon R-SMRMon Python-SMRMon Raku-SBR>;
#my @targets = <Bulgarian English Russian>;
my @targets = <WL::SMRMon>;

for @commands -> $c {
    say "\n", '=' x 20;
    say $c.trim;
    for @targets -> $t {
        say '-' x 20;
        say $t.trim;
        say '-' x 20;
        say ToRecommenderWorkflowCode($c, $t, format => 'hash');
    }
}

#my $pres = smr-parse(@commands[0], rule => "workflow-commands-list");
#
#say $pres;

#my $res = smr-interpret(
#        @commands[0],
#        rule => "workflow-commands-list",
#        actions => DSL::English::RecommenderWorkflows::Actions::R::SMRMon.new);
#
#say $res.raku;
#
#say $res.raku;

#my $res2 = $res.

#say marshal(%res);