/*import data*/
DATA Ass2Credit;
SET "/home/u58374793/Consumer Credit analysis/ass2credit.sas7bdat";
RUN;

/* Check the contents of the dataset */
proc contents data=Ass2Credit;
run;

proc sort data=Ass2Credit;
  by TARGET;
run;

/* Canonical Discriminant Analysis */
proc candisc data=Ass2Credit out=can_out;
    class TARGET;
    var CollectCnt InqFinanceCnt24 InqTimeLast TLTimeFirst TLBalHCPct 
        TLSatPct TLSum TLOpenPct TLDel60Cnt24;
run;

/* Check the contents of the can_out dataset */
proc contents data=can_out;
run;

/* Print the first few observations of the can_out dataset */
proc print data=can_out(obs=10);
run;

/* Plotting the results */
proc sgplot data=can_out;
    scatter x=Can1 y=TARGET / group=TARGET;
    xaxis label="Canonical Discriminant Function 1";
    yaxis label="TARGET";
run;

/*Prepare data for visualization */
/* Sort the discrim_out dataset by TARGET */
/* Perform Canonical Discriminant Analysis */
proc discrim data=Ass2Credit testdata=Ass2Credit out=discrim_out canonical;
    class TARGET;
    var CollectCnt InqFinanceCnt24 InqTimeLast TLTimeFirst TLBalHCPct TLSatPct TLSum TLOpenPct TLDel60Cnt24;
run;

data plotclass;
  merge Ass2Credit discrim_out;
run;

proc template;
    define statgraph classify;
        begingraph;
            layout overlay;
                contourplotparm x=Can1 y=Can2 z=_into_ / contourtype=fill nhint=30 gridded=false;
                scatterplot x=Can1 y=Can2 / group=TARGET includemissinggroup=false markercharacter=TARGET;
            endlayout;
        endgraph;
    end;
run;

/* Step 5: Render the plot */
proc sgrender data = plotclass template = classify;
run;

/*Fisher Discriminant Analysis */
/* Perform Canonical Discriminant Analysis with reduced variables */
proc discrim data=Ass2Credit out=discrim_out_reduced canonical;
    class TARGET;
    var InqFinanceCnt24 TLSatPct TLDel60Cnt24;
run;

/* Inspect the new discriminant results */
proc print data=discrim_out_reduced;
run;

/* Check classification accuracy */
proc discrim data=Ass2Credit testdata=Ass2Credit testout=discrim_out_reduced;
    class TARGET;
    var InqFinanceCnt24 TLSatPct TLDel60Cnt24;
run;

