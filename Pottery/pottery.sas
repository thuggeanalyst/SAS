
/* Step 1: Import the data */
proc import datafile="/home/u58374793/Pottery/pottery.csv" 
    out=pottery 
    dbms=csv 
    replace;
    getnames=yes;
run;

/*you shoul configure and ensure the data have been impoted before running the code*/
/* Compute averages for each kiln */
proc means data=pottery noprint;
    class kiln;
    var Al2O3 Fe2O3 MgO CaO Na2O K2O TiO2 MnO BaO;
    output out=pottery_avg mean=;
run;

/* Verify the averaged data */
proc print data=pottery_avg;
run;

/* Remove the overall mean row (_TYPE_ = 0) */
data pottery_avg;
    set pottery_avg;
    if _TYPE_ = 0 then delete;
run;

/* Create the region variable */
data pottery_avg;
    set pottery_avg;
    if kiln = 1 then region = 1;
    else if kiln in (2, 3) then region = 2;
    else if kiln in (4, 5) then region = 3;
run;

/* Verify the data with region variable */
proc print data=pottery_avg;
run;

/* Standardize the numeric variables */
proc standard DATA=pottery_avg mean=0 std=1 out=pottery_std;
    var Al2O3 Fe2O3 MgO CaO Na2O K2O TiO2 MnO BaO;
run;

/* Verify the standardized data */
proc print data=pottery_std (obs=10);
run;

/* Create distance matrix using Euclidean distances */
proc distance data=pottery_std out=pottery_dist method=euclid;
    var interval(Al2O3 Fe2O3 MgO CaO Na2O K2O TiO2 MnO BaO kiln);
run;

/* Visualize the distance matrix */
proc print data=pottery_dist;
run;

/* Create heatmap of the distance matrix */
proc corr data=pottery_dist noprint outp=corrout;
    var _numeric_;
run;

/* Merge the kiln variable back to the distance matrix */
data pottery_dist_kiln;
    merge pottery_dist pottery_std(keep=kiln);
run;

/* Perform hierarchical clustering using the centroid method */
proc cluster data=pottery_avg method=centroid outtree=tree;
    id kiln;
run;

/*Perform MDS using the distance matrix */
proc mds data=pottery_dist_kiln out=mds_out level=interval;
    id kiln;
run;




