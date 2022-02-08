#!/usr/bin/env perl6
use DSL::English::RecommenderWorkflows;

sub MAIN( Str $commands, Str $target = 'R-SMRMon' ) {
    put ToRecommenderWorkflowCode( $commands, $target );
}

