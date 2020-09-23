use v6;
use lib 'lib';
use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 10;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

#-----------------------------------------------------------
# Recommender algebra
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('join the recommender object with the recommender smr2'),
        'join the recommender object with the recommender smr2';

ok $pSMRMONCOMMAND.parse('join with the recommender smr2'),
        'join with the recommender smr2';

ok $pSMRMONCOMMAND.parse('join with the recommender smr2 using join type left'),
        'join with the recommender smr2';

ok $pSMRMONCOMMAND.parse('join with recommender smr2 with type "right"'),
        'join with recommender smr2 with type "right"';

ok $pSMRMONCOMMAND.parse('join with the recommender `aSMRs["p2"]`'),
        'join with the recommender `aSMRs["p2"]`';

ok $pSMRMONCOMMAND.parse('annex the matrix MatNew'),
        'annex the matrix MatNew';

ok $pSMRMONCOMMAND.parse('annex the matrix MatNew with tag type Type2'),
        'annex the matrix MatNew with tag type Type2';

ok $pSMRMONCOMMAND.parse('annex the matrix `smats[[1]]` with tag type `Keys[smats][[1]]`'),
        'annex the matrix `smats[[1]]` with tag type `Keys[smats][[1]]`';

ok $pSMRMONCOMMAND.parse('drop the tag types tt1, tt2, tt3'),
        'drop the tag types tt1, tt2, tt3';

ok $pSMRMONCOMMAND.parse('remove tag types "tt1", tt2, "tt3"'),
        'remove tag types "tt1", tt2, "tt3"';

done-testing;