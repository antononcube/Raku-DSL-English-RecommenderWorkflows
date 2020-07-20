#!/usr/bin/env perl6
use DSL::English::RecommenderWorkflows;

sub MAIN( Str $commands ) {
    put ToRecommenderWorkflowCode( $commands );
}

