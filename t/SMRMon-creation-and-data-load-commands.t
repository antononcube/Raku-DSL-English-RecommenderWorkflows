use v6;

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 16;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------

# 1
ok $pSMRMONCOMMAND.parse('create with ds2'),
        'create with ds2';

# 2
ok $pSMRMONCOMMAND.parse('create recommender with ds2'),
        'create recommender with ds2';

# 3
ok $pSMRMONCOMMAND.parse('create recommender object with ds2'),
        'create recommender object with ds2';

# 4
ok $pSMRMONCOMMAND.parse('generate the recommender'),
        'generate the recommender';

# 5
ok $pSMRMONCOMMAND.parse('create the recommender with dataset ds1 using the column id'),
        'create the recommender with dataset ds1 using the column id';

# 6
ok $pSMRMONCOMMAND.parse('create using the matrices `<||>`'),
        'create using the matrices `<||>`';

# 7
ok $pSMRMONCOMMAND.parse('create using the matrices `<| word->mat1, stem->mat2 |>`'),
        'create using the matrices `<| word->mat1, stem->mat2 |>`';

# 8
ok $pSMRMONCOMMAND.parse('create using the matrices mat1, mat2, mat3'),
        'create using the matrices mat1, mat2, mat3';

# 9
ok $pSMRMONCOMMAND.parse('create using the matrices mat1, mat2, and mat3'),
        'create using the matrices mat1, mat2, and mat3';

# 10
ok $pSMRMONCOMMAND.parse('create with matrices smats'),
        'create with matrices smats';

#-----------------------------------------------------------
# Data load commands
#-----------------------------------------------------------

# 11
ok $pSMRMONCOMMAND.parse('load data dfTitanic'),
        'load data dfTitanic';

# 12
ok $pSMRMONCOMMAND.parse('load data s2'),
        'load data s2';

# 13
ok $pSMRMONCOMMAND.parse('use smrObj'),
        'use smrObj';

# 14
ok $pSMRMONCOMMAND.parse('use recommender smr'),
        'use recommender smr';

# 15
ok $pSMRMONCOMMAND.parse('use recommender object smr'),
        'use recommender object smr';

# 16
ok $pSMRMONCOMMAND.parse('use the smr object smr2'),
        'use the smr object smr2';

done-testing;