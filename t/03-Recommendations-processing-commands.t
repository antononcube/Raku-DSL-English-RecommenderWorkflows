use v6;

use lib '.';
use lib './lib';

use DSL::English::RecommenderWorkflows::Grammar;
use Test;

plan 15;

# Shortcut
my $pSMRMONCOMMAND = DSL::English::RecommenderWorkflows::Grammar;

#-----------------------------------------------------------
# Explanations commands
#-----------------------------------------------------------

## 1
ok $pSMRMONCOMMAND.parse('explain the recommendations'),
        'explain the recommendations';

## 2
ok $pSMRMONCOMMAND.parse('prove the recommendations with the consumption history'),
        'explain the recommendations with the consumption history';

## 3
ok $pSMRMONCOMMAND.parse('explain the recommended items by profile'),
        'explain the recommended items by profile';

## 4
ok $pSMRMONCOMMAND.parse('prove the recommended items by profile'),
        'prove the recommended items by profile';

## 5
ok $pSMRMONCOMMAND.parse('explain recommended items using the profile'),
        'explain recommended items using the profile';

## 6
ok $pSMRMONCOMMAND.parse('explain recommended item id.122 using metadata'),
        'explain recommended item id.122 using metadata';

## 7
ok $pSMRMONCOMMAND.parse('prove the recommendation id.122 using history'),
        'prove the recommendation id.122 using history';

## 8
ok $pSMRMONCOMMAND.parse('explain by metadata the recommendation id.123'),
        'explain by metadata the recommendation id.123';

## 9
ok $pSMRMONCOMMAND.parse('prove by history the recommendation id.123'),
        'prove by history the recommendation id.123';


#-----------------------------------------------------------
# Extend recommendations
#-----------------------------------------------------------

## 10
ok $pSMRMONCOMMAND.parse('extend recommendations with dataset ds1'),
        'extend recommendations with dataset ds1';

## 11
ok $pSMRMONCOMMAND.parse('extend recommendations with the dataset ds1 by "passenger"'),
        'extend recommendations with the dataset ds1 by "passenger"';

## 12
ok $pSMRMONCOMMAND.parse('extend recommendations with the dataset ds1 by `PAS1`'),
        'extend recommendations with the dataset ds1 by `PAS1`';

## 13
ok $pSMRMONCOMMAND.parse('extend recommendations with the dataset ds1 by column passenger'),
        'extend recommendations with the dataset ds1 by column passenger';

## 14
ok $pSMRMONCOMMAND.parse('join recommendations with the dataset ds1 using the id column passenger'),
        'join recommendations with the dataset ds1 using the id column passenger';

## 15
ok $pSMRMONCOMMAND.parse('join recommendations with the dataset ds1 using the identifier column passenger'),
        'join recommendations with the dataset ds1 using the identifier column passenger';


#-----------------------------------------------------------
# Filter recommendations
#-----------------------------------------------------------


done-testing;
