/*01 Defining Calling Macro*/
%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

%macro time;
   %put The current time is %sysfunc(time(),timeampm.).;
%mend time;

options mcompilenote=all;
%macro time;
 %put The current time is %sysfunc(time(),timeampm.).;
%mend time;
options mcompilenote=none;

%time

%macro calc;
   proc means data=orion.order_fact &stats;
	 var &vars;
   run;
%mend calc;


%let stats=min max;
%let vars=quantity;
%calc

options mprint;
%calc
options nomprint;

/*02 Macro Parameters*/
%macro calc;
   proc means data=orion.order_fact &stats;
	 var &vars;
   run;
%mend calc;

%let stats=min max;
%let vars=quantity;
%calc

%let stats=n mean;
%let vars=discount;
%calc

%macro calc(stats,vars);
   proc means data=orion.order_fact &stats;
	 var &vars;
   run;
%mend calc;

%macro count(opts, start, stop);
   proc freq data=orion.order_fact;
      where order_date between 
	       "&start"d and "&stop"d;
      table order_type / &opts;
      title1 "Orders from &start to &stop";
   run;
%mend count;
options mprint;
%count(nocum,01jan2004,31dec2004)
%count(,01jul2004,31dec2004)
title;

%macro count(opts=,start=01jan04,stop=31dec04);
   proc freq data=orion.order_fact;
      where order_date between 
	       "&start"d and "&stop"d;
      table order_type / &opts;
      title1 "Orders from &start to &stop";
   run;
%mend count;
options mprint;
%count(opts=nocum)
%count(stop=01jul04,opts=nocum nopercent)
%count()
title;

%macro count(opts,start=01jan04,stop=31dec04);
   proc freq data=orion.order_fact;
      where order_date between 
	       "&start"d and "&stop"d;
      table order_type / &opts;
      title1 "Orders from &start to &stop";
   run;
%mend count;
options mprint;
%count(nocum)
%count(stop=30jun04,start=01apr04)
%count(nocum nopercent,stop=30jun04)
%count()
title;

/*03 Example: Set Axes Macro*/
libname nhanes3 "&path/nhanes3";

proc contents data=nhanes3.bodyfat;
run;

proc sgplot data=nhanes3.bodyfat;
scatter x=weight y=pctbodyfat1;
run;

proc sgplot data=nhanes3.bodyfat;
scatter x=weight y=pctbodyfat1;
xaxis labelattrs=(Family=Arial Size=8 Weight=Bold)
      valueattrs=(Family=Arial Size=8 Weight=Bold);
yaxis labelattrs=(Family=Arial Size=8 Weight=Bold)
      valueattrs=(Family=Arial Size=8 Weight=Bold);

run;

%macro set_axes;
xaxis labelattrs=(Family=Arial Size=8 Weight=Bold)
      valueattrs=(Family=Arial Size=8 Weight=Bold);
yaxis labelattrs=(Family=Arial Size=8 Weight=Bold)
      valueattrs=(Family=Arial Size=8 Weight=Bold);
%mend;

options mprint;
proc sgplot data=nhanes3.bodyfat;
scatter x=weight y=pctbodyfat1;
%set_axes
run;

/*04 Example: All Means Macro*/   
title "Numeric Variables, nhanes3.examsub2";
proc means data=nhanes3.examsub2;
run;
title;

%macro allmns(dat);
/*get basic data on numeric variables*/
title "Numeric Variables, dataset: &dat";
proc means data=&dat;
run;
title;
%mend;


%allmns(nhanes3.examsub2)


/*05 Example:  Bootstrap Macro*/
proc surveyselect data=chol
reps=100
Samprate=1
method=urs
out=outboot
seed=54321;
run;

%let data=chol;
%let reps=10;
%let seed=54321;
%let outdat=outboot;
proc surveyselect data=&data
reps=&reps
samprate=1
method=urs
out=&outdat(drop=numberhits)
seed=&seed;
run;

%macro bootsamp(indat=,outdat=outboot,reps=5,seed=54321);
proc surveyselect data=&indat
outhits
reps=&reps
samprate=1
method=urs
out=&outdat (drop=numberhits)
seed=&seed;
run;
%mend bootsamp;

%bootsamp(indat=orion.customer)
proc print data=outboot;
run;









