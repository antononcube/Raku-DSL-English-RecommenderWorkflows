use lib './lib';
use lib '.';
use DSL::English::RecommenderWorkflows;
use DSL::English::RecommenderWorkflows::Grammar;

#say DSL::English::RecommenderWorkflows::Grammar.parse("prove the recommendation id.123 using the profile");
#
#say "\n=======\n";
#
#say DSL::English::RecommenderWorkflows::Grammar.parse("prove the recommendation id.123 using the profile tag.1->1, tag.2->1, and tag.3->0.5");
#
#say "\n=======\n";

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

say ToRecommenderWorkflowCode('
DSL TARGET WL-SMRMon;
create from dfTitanic;
recommend by profile hr.12=3 and rr.12->4;
join with recommender smrObj2 with join type "left";
annex the matrix `smats[[1]]` using tag type "Gen2";
remove tag types "Gen1", Gen3;
');

say "\n=======\n";

#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     echo value;
#     prove recommendations by metadata' );
#
#say "\n=======\n";
#
#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     echo value;
#     prove recommended items id.123, id.99 by metadata' );

# say "\n=======\n";

#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     echo value;
#     display proof follows;
#     prove recommended items id.123, id.99 with the profile tag.1, tag.23' );
#
#say "\n=======\n";
#
#my $commands = '
#create from dfTitanic;
#recomend with history id.5=10, id.7=3;
#join across recommendations with the data frame dfTitanic;
#echo pipeline value';
#
#say to_SMRMon_R( $commands );
#
#say "\n=======\n";
#
#say to_SMRMon_Python( $commands );
#
#say "\n=======\n";
#
#say to_SMRMon_WL( $commands );

#say to_SMRMon_R('
#     use recommender smrObj2;
#     recomend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value' );
#
#say to_SMRMon_R('
#     use recommender smrObj2;
#     compute profile for the history id.5, id.993;
#     echo value;
#     find top 5 recommendations;
#     extend recommendations with dfTitanic;
#     echo value;');

#say to_SMRMon_R('
#    use recommender smrObj;
#     show recommender matrix properties;
#     show recommender matrix property;
#     display the tag types;
#     show the recommender itemColumnName;
#     show the sparse matrix number of rows;
#     show the sparse matrix number of columns;
#     display the recommender matrix density;
#     show the sparse matrix columns;
#     filter the recommendation matrix with male, 30, 40;
#     show sparse matrix dimensions;
#     show the sub-matrix passengerClass columns;
#     show the tag type passengerSurvival density;'
#);


#say "\n=======\n";
#
#say to_SMRMon_WL('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     prove the recommendated item
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value
#');
#
#say "\n=======\n";
#
#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value
#');
#
#say "\n=======\n";
#
#say to_SMRMon_Py('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value
#');

