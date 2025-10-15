use lib <. lib>;
use DSL::English::RecommenderWorkflows;
use DSL::English::RecommenderWorkflows::Grammar;
use DSL::English::RecommenderWorkflows::Actions::WL::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::Raku::SMRMon;

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
                  :$actions = DSL::English::RecommenderWorkflows::Actions::Raku::SMRMon.new) {
    $pCOMMAND.parse($command, :$rule, :$actions).made;
}

my $command = "
make new recommender;
create from dfTitanic;
apply LSI functions IDF, None, Cosine;
get top 30 recommendations by profile male and 1st;
join across with dfTitanic; echo value";

#say smr-subparse($command, rule => 'workflow-commands-list');
my $res = smr-interpret($command, rule => 'workflow-commands-list');
my $checkStr = 'my $obj = ML::SparseMatrixRecommender.new';
with $res.match(/ $checkStr /):g { if $/.list.elems > 1 { $res .= subst($checkStr) } }
say $res;

say '-' x 120;
#`(
my $pres = smr-parse('apply LSI functions IDF, None, Cosine', rule => 'TOP');

#say $pres.WHAT;
#say $pres.hash;

say $pres<workflow-command><lsi-apply-command><lsi-funcs-list><lsi-func>>>.hash>>.keys.flat;

my $pres2 = smr-interpret('apply LSI functions IDF, None, Cosine');

say $pres2;
)
say '-' x 120;

my $pres3 = smr-parse('get top 30 recommendations by profile male and 1st', rule => 'TOP');


say $pres3<workflow-command><recommend-by-profile-command>;

say smr-interpret('get top 30 recommendations by profile male and 1st');