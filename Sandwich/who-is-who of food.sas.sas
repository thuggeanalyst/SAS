/*1a*/
/*Load the data*/
DATA sandwich_data;
SET "/home/u58374793/food/sandwiches.sas7bdat";
RUN;

/*you shoul configure and ensure the data have been impoted before running the code*/
/* Data inspection*/
proc contents data=sandwich_data;
run;

/*Frequency distributions*/
/*frequency distribution of category and brand*/
proc freq data=sandwich_data;
   tables Brand*Category / norow nocol nopercent;
run;

proc freq data=sandwich_data;
    tables Brand*Category / chisq;
run;

/*Visualization*/
proc sgplot data=sandwich_data;
   vbar Category / group=Brand;
   title "Distribution of Sandwich Categories by Brand";
run;

/* Visualize the relationship using a bar chart */
proc sgplot data=sandwich_data;
    vbar Category / group=Brand groupdisplay=cluster;
    xaxis label="Category";
    yaxis label="Count";
run;


/*1b*/
/*Correlation analysis*/
proc corr data=sandwich_data;
   var TFat Protein Carb Fiber Sodium;
   with Calories Weight;
run;

/*Regression analysis*/
/* Regression analysis to see the impact of nutritional variables on calories and weight */
proc reg data=sandwich_data;
    model Calories = TFat Protein Carb Fiber Sodium;
    model Weight = TFat Protein Carb Fiber Sodium;
run;

/* Visualization of the relationships using scatter plots */
proc sgscatter data=sandwich_data;
    matrix Calories Weight TFat Protein Carb Fiber Sodium / diagonal=(histogram);
run;

