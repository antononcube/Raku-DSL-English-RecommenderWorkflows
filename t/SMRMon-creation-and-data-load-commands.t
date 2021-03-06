use v6;
use lib 'lib';
use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 15;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('create with ds2'),
        'create with ds2';

ok $pSMRMONCOMMAND.parse('create recommender with ds2'),
        'create recommender with ds2';

ok $pSMRMONCOMMAND.parse('create recommender object with ds2'),
        'create recommender object with ds2';

ok $pSMRMONCOMMAND.parse('generate the recommender'),
        'generate the recommender';

ok $pSMRMONCOMMAND.parse('create the recommender with dataset ds1 using the column id'),
        'create the recommender with dataset ds1 using the column id';

ok $pSMRMONCOMMAND.parse('create using the matrices `<||>`'),
        'create using the matrices `<||>`';

ok $pSMRMONCOMMAND.parse('create using the matrices `<| word->mat1, stem->mat2 |>`'),
        'create using the matrices `<| word->mat1, stem->mat2 |>`';

ok $pSMRMONCOMMAND.parse('create using the matrices mat1, mat2, mat3'),
        'create using the matrices mat1, mat2, mat3';

ok $pSMRMONCOMMAND.parse('create with matrices smats'),
        'create with matrices smats';

#-----------------------------------------------------------
# Data load commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('load data dfTitanic'),
        'load data dfTitanic';

ok $pSMRMONCOMMAND.parse('load data s2'),
        'load data s2';

ok $pSMRMONCOMMAND.parse('use smrObj'),
        'use smrObj';

ok $pSMRMONCOMMAND.parse('use recommender smr'),
        'use recommender smr';

ok $pSMRMONCOMMAND.parse('use recommender object smr'),
        'use recommender object smr';

ok $pSMRMONCOMMAND.parse('use the smr object smr2'),
        'use the smr object smr2';

done-testing;