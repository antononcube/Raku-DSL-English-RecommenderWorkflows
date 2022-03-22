=begin pod

=head1 DSL::English::RecommenderWorkflows

C<DSL::English::RecommenderWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify recommender workflows.

=head1 Synopsis

    use DSL::English::RecommenderWorkflows;
    my $gcode = ToRecommenderWorkflowCode("recommend for history r1->1, r2->2, and r3->5; explain the first recommendation");
    my $rlcode = to_SMRMon_R("recommend for history r1->1, r2->2, and r3->5; explain the first recommendation");

=end pod

unit module DSL::English::RecommenderWorkflows;

use DSL::Shared::Utilities::CommandProcessing;

use DSL::English::RecommenderWorkflows::Grammar;
use DSL::English::RecommenderWorkflows::Actions::Bulgarian::Standard;
use DSL::English::RecommenderWorkflows::Actions::English::Standard;
use DSL::English::RecommenderWorkflows::Actions::Python::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::R::SMRMon;
use DSL::English::RecommenderWorkflows::Actions::R::tidyverse;
use DSL::English::RecommenderWorkflows::Actions::Raku::SBR;
use DSL::English::RecommenderWorkflows::Actions::WL::SMRMon;

my %targetToAction{Str} =
    "Bulgarian"        => DSL::English::RecommenderWorkflows::Actions::Bulgarian::Standard,
    "English"          => DSL::English::RecommenderWorkflows::Actions::English::Standard,
    "Python"           => DSL::English::RecommenderWorkflows::Actions::Python::SMRMon,
    "Python-SMRMon"    => DSL::English::RecommenderWorkflows::Actions::Python::SMRMon,
    "R"                => DSL::English::RecommenderWorkflows::Actions::R::SMRMon,
    "R-SMRMon"         => DSL::English::RecommenderWorkflows::Actions::R::SMRMon,
    "R-tidyverse"      => DSL::English::RecommenderWorkflows::Actions::R::tidyverse,
    "Raku"             => DSL::English::RecommenderWorkflows::Actions::Raku::SBR,
    "Raku-SBR"         => DSL::English::RecommenderWorkflows::Actions::Raku::SBR,
    "Mathematica"      => DSL::English::RecommenderWorkflows::Actions::WL::SMRMon,
    "WL"               => DSL::English::RecommenderWorkflows::Actions::WL::SMRMon,
    "WL-SMRMon"        => DSL::English::RecommenderWorkflows::Actions::WL::SMRMon;

my %targetToAction2{Str} = %targetToAction.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToAction = |%targetToAction , |%targetToAction2;

my Str %targetToSeparator{Str} =
    "Bulgarian"        => "\n",
    "English"          => "\n",
    "R"                => " %>%\n",
    "R-SMRMon"         => " %>%\n",
    "R-tidyverse"      => " %>%\n",
    "Mathematica"      => " \\[DoubleLongRightArrow]\n",
    "Python"           => "",
    "Python-SMRMon"    => "",
    "Raku"             => ";\n",
    "Raku-SBR"         => ";\n",
    "WL"               => " \\[DoubleLongRightArrow]\n",
    "WL-SMRMon"        => " \\[DoubleLongRightArrow]\n";

my Str %targetToSeparator2{Str} = %targetToSeparator.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToSeparator = |%targetToSeparator , |%targetToSeparator2;

#-----------------------------------------------------------
proto ToRecommenderWorkflowCode(Str $command, Str $target = 'R-SMRMon', | ) is export {*}

multi ToRecommenderWorkflowCode ( Str $command, Str $target = 'R-SMRMon', *%args ) {

    my $lang = %args<language>:exists ?? %args<language> !! 'English';
    $lang = $lang.wordcase;

    my $gname = "DSL::{$lang}::RecommenderWorkflows::Grammar";

    try require ::($gname);
    if ::($gname) ~~ Failure { die "Failed to load the grammar $gname." }

    my Grammar $grammar = ::($gname);

    DSL::Shared::Utilities::CommandProcessing::ToWorkflowCode( $command,
                                                               :$grammar,
                                                               :%targetToAction,
                                                               :%targetToSeparator,
                                                               :$target,
                                                               |%args )
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
