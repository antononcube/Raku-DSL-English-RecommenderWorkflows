=begin pod

=head1 RecommenderWorkflows

C<RecommenderWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify recommender workflows.

=head1 Synopsis

    use RecommenderWorkflows;
    my $rcode = to_SMRMon_R("recommend for history r1->1, r2->2, and r3->5; explain the first recommendation");
    my $wlcode = to_SMRMon_WL("recommend for history r1->1, r2->2, and r3->5; explain the first recommendation");

=end pod

unit module DSL::English::RecommenderWorkflows;

use DSL::Shared::Utilities::MetaSpecsProcessing;

use DSL::English::RecommenderWorkflows::Grammar;
use DSL::English::RecommenderWorkflows::Actions::Python::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::R::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::WL::SMRMon;

my %targetToAction =
    "Python"           => DSL::English::RecommenderWorkflows::Actions::Python::SMRMon,
    "Python-SMRMon"    => DSL::English::RecommenderWorkflows::Actions::Python::SMRMon,
    "R"                => DSL::English::RecommenderWorkflows::Actions::R::SMRMon,
    "R-SMRMon"         => DSL::English::RecommenderWorkflows::Actions::R::SMRMon,
    "Mathematica"      => DSL::English::RecommenderWorkflows::Actions::WL::SMRMon,
    "WL"               => DSL::English::RecommenderWorkflows::Actions::WL::SMRMon,
    "WL-SMRMon"        => DSL::English::RecommenderWorkflows::Actions::WL::SMRMon;

my %targetToSeparator{Str} =
    "R"                => " %>%\n",
    "R-SMRMon"         => " %>%\n",
    "Mathematica"      => " ==>\n",
    "Python"           => "\n",
    "Python-SMRMon"    => "\n",
    "WL"               => " ==>\n",
    "WL-SMRMon"        => " ==>\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToRecommenderWorkflowCode(Str $command, Str $target = 'R-SMRMon' ) is export {*}

multi ToRecommenderWorkflowCode ( Str $command where not has-semicolon($command), Str $target = 'R-SMRMon' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = DSL::English::RecommenderWorkflows::Grammar.parse($command.trim, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToRecommenderWorkflowCode ( Str $command where has-semicolon($command), Str $target = 'R-SMRMon' ) {

    my $specTarget = get-dsl-spec( $command, 'target');

    $specTarget = !$specTarget ?? $target !! $specTarget.value;

    die 'Unknown target.' unless %targetToAction{$specTarget}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToRecommenderWorkflowCode($_, $specTarget) }, @commandLines;

    @cmdLines = grep { $_.^name eq 'Str' }, @cmdLines;

    return @cmdLines.join( %targetToSeparator{$specTarget} ).trim;
}

#-----------------------------------------------------------
proto to_SMRMon_Python($) is export {*}

multi to_SMRMon_Python ( Str $command ) {
    return ToRecommenderWorkflowCode( $command, 'Python-SMRMon' );
}

#-----------------------------------------------------------
proto to_SMRMon_R($) is export {*}

multi to_SMRMon_R ( Str $command ) {
    return ToRecommenderWorkflowCode( $command, 'R-SMRMon' );
}

#-----------------------------------------------------------
proto to_SMRMon_WL($) is export {*}

multi to_SMRMon_WL ( Str $command ) {
    return ToRecommenderWorkflowCode( $command, 'WL-SMRMon' );
}
