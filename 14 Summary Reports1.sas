/*01 Proc Freq*/
libname nhanes3 '/courses/d649d56dba27fe300/STA5066';

proc contents data=nhanes3.exam;
run;

proc freq data=nhanes3.exam nlevels;
tables seqn/noprint;
run;

proc contents data=nhanes3.Nhanes1_5066;
run;

proc freq data=nhanes3.nhanes1_5066;
tables activ;
run;

proc freq data=nhanes3.nhanes1_5066;
tables activ diabetic gender race smoking_status vital_status;
run;

proc freq data=nhanes3.nhanes1_5066;
tables activ diabetic gender 
race smoking_status vital_status/nocum;
run;

proc freq data=nhanes3.nhanes1_5066;
tables sbp;
run;

proc freq data=nhanes3.nhanes1_5066 ;
   tables activ / chisq plots=none;
run; 

proc freq data=nhanes3.nhanes1_5066;
tables gender*activ;
run;

proc freq data=nhanes3.nhanes1_5066;
tables gender*activ/nocol nopercent;
run;

proc freq data=nhanes3.nhanes1_5066;
tables activ*gender/norow nopercent;
run;

proc freq data=nhanes3.nhanes1_5066;
tables age;
run;

proc format;
	value agefmt low-39="<40"
				40-49="40-49"
				50-59="50-59"
				60-high="60-69"
				;
run;
proc freq data=nhanes3.nhanes1_5066;
tables age;
format age agefmt.;
run;

proc freq data=nhanes3.nhanes1_5066;
where gender="Male";
tables age*diabetic/nocol nopercent;
format age agefmt.;
run;

proc freq data=nhanes3.nhanes1_5066;
tables gender*activ/crosslist;
run;

proc freq data=nhanes3.nhanes1_5066;
tables gender*activ/crosslist norow nocol nopercent;
run;

proc freq data=nhanes3.nhanes1_5066;
where gender="Male";
tables age*diabetic/list;
format age agefmt.;
run;

proc freq data=nhanes3.nhanes1_5066;
tables diabetic*vital_status/
			nocol nopercent chisq;
run;

proc freq data=nhanes3.nhanes1_5066;
tables race*diabetic*vital_status/
		nocol nopercent chisq;
run;

proc freq data=nhanes3.nhanes1_5066;
tables race*gender*diabetic*vital_status/
		nocol nopercent chisq;
run;

proc freq data=nhanes3.nhanes1_5066;
tables race*(diabetic activ)/
		nocol nopercent chisq;
run;

proc freq data=nhanes3.nhanes1_5066;
tables (race diabetic)* activ/nocol nopercent chisq;
run;

proc freq data=nhanes3.nhanes1_5066;
tables (race diabetic)* (activ gender)/nocol nopercent chisq;
run;

data cigsdth;
   do cigs=0 to 1;
	 do dth=0 to 1;
	 	input number @@;
		output;
	 end;
	 end;
datalines;
819 132 1498 333
;
run;
proc 
print data=cigsdth;run;
proc freq data= cigsdth;
tables cigs*dth/nocol nopercent chisq;
weight number;
run;

/*02 Proc Means */
proc means data=nhanes3.nhanes1_5066;
run; 

proc means data=nhanes3.nhanes1_5066;
   var sbp bmi chol;
run;


proc means data=nhanes3.nhanes1_5066;
   var sbp;
   class Gender;
run;

proc means data=nhanes3.nhanes1_5066 median min max;
   var bmi;
   class gender;
run;

proc means data=nhanes3.nhanes1_5066 ;
   var chol;
   class gender;
run;

proc means data=nhanes3.nhanes1_5066 maxdec=1;
   var chol;
   class gender;
run;

libname orion '/courses/d649d56dba27fe300/STA5066';
proc means data=orion.sales;
   var Salary;
   class Country;
run;

proc means data=orion.sales nonobs;
   var Salary;
   class Country;
run;

proc means data=nhanes3.nhanes1_5066 noprint;
   var sbp;
   output out=means;
run;

proc print data=means;
run;

proc means data=nhanes3.nhanes1_5066 noprint;
   var sbp;
   class gender;
   output out=means1;
run;

proc print data=means1;
run;


proc means data=nhanes3.nhanes1_5066 noprint;
   var sbp;
	 class gender race;
   output out=work.means2
          min=minSbp max=maxSbp
          sum=sumSbp mean=aveSbp;
run;

proc print data=means2;
run;

proc means data=orion.sales noprint nway;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;

proc means data=orion.sales noprint descendtypes;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;

proc contents data=orion.sales;run;
proc print data=orion.sales(obs=23);run;
proc freq data=orion.sales;
tables country;
run;

proc means data=orion.sales noprint;
   var Salary;
   class Gender Country;
   output out=work.means mean=aveSalary;
run;

proc print data=means;
run;

title;
data gender_summary(keep=Gender aveSalary)  
     country_summary(keep=Country aveSalary);
   set work.means;
   if _type_=1 then output country_summary;
   else if _type_=2 then output gender_summary;
run;

proc print data=gender_summary;
run;

proc print data=country_summary;
run;

proc sort data=orion.sales out=sort_country;
   by Country;
run;

data detail_country;
   merge sort_country 
         country_summary
		(rename=(aveSalary=CountrySalary));
   by Country;
run;

proc print data=detail_country (obs=10);
run;

proc sort data=detail_country out=sort_gender;
   by Gender;
run;
data detail_country_gender;
   merge sort_gender
       gender_summary(rename=(aveSalary=GenderSalary));
   by Gender;
   if Salary>CountrySalary then CS='Above Average'; else CS='Below Average';
   if Salary>GenderSalary then GS='Above Average'; else GS='Below Average';
   label CS='Comparison*to Country*Salary Average'
         GS='Comparison*to Gender*Salary Average';
run;
proc print data=detail_country_gender (obs=100);
run;

proc sort data=detail_country_gender;
   by Employee_ID;
run;

proc print data=detail_country_gender split='*';
   var First_Name Last_Name Salary CS GS;
run;

data normmns;
  call streaminit(57131);/*seed*/
  do rep=1 to 10000;
	  do n=1 to 9;
	  	x=rand("normal");/*random standard normal*/
		output;
	  end;
  end;
run;

proc means data=normmns noprint mean;
	by rep;
	var x;
	output out=means mean=mn_x;
run;

ods select histogram goodnessoffit;
proc univariate data=means;
var mn_x;
histogram mn_x/normal;
run;

/*03 Proc Univariate*/
/*create analytic data set*/

data nhanes1_a;
	set nhanes3.nhanes1_5066;
	id=_n_+100000;
run;

/*a basic call */
proc univariate data=nhanes1_a;
var sbp;
run;

/*the id statement*/
proc univariate data=nhanes1_a;
var sbp;
id id;
run;

/*add a histogram*/
proc univariate data=nhanes1_a;
var sbp;
histogram sbp;
run;

/*add an overlay of a normal and an inset-- 
see SAS help for list of parametric distributions*/
proc univariate data=nhanes1_a;
var sbp;
histogram sbp/normal;
inset mean(6.1) std(5.1) n /position=ne;
run;


/*a lognormal with inset statement*/
title 'Systolic Blood Pressure';
ods select ParameterEstimates GoodnessOfFit FitQuantiles histogram;
proc univariate data=nhanes1_a;
   var sbp;
   histogram / lognormal (theta=est) midpoints=80 to 280 by 10;
   inset n mean(5.1) std='Std Dev' (4.1) skewness (5.3)
             / pos = ne  header = 'Summary Statistics';      
run;
title;

/*add a class statement, midpoints of histogram,
   estimate an offset (theta)*/
title 'Systolic Blood Pressure';
ods select ParameterEstimates GoodnessOfFit FitQuantiles histogram;
proc univariate data=nhanes1_a;
class gender;
   var sbp;
   histogram / lognormal (theta=est) midpoints=80 to 280 by 10;
   inset n mean(5.1) std='Std Dev' (4.1) skewness (5.3)
             / pos = ne  header = 'Summary Statistics';      
run;

title;

/*qqplots */
proc univariate data=nhanes1_a mu0=135;
var sbp;
qqplot sbp/normal ;
qqplot sbp/lognormal(sigma=est theta=est);
run;


/*cdf plots*/
proc univariate data=nhanes1_a mu0=135;
var sbp;
cdfplot sbp/normal ;
cdfplot sbp/lognormal(sigma=est theta=est);
run;

/*non parametric density estimation*/
proc univariate data=nhanes1_a mu0=135;
var sbp;
histogram sbp/kernel;
run;

/*parametric and non parametric density estimation*/
proc univariate data=nhanes1_a mu0=135;
var sbp;
histogram sbp/lognormal kernel;
run;

/*create a data set with frequencies
  quick intro to PROC SQL*/
proc sql;
  create table sbpfreqs as
		select sbp, count(*) as num
		from nhanes1_a
		group by sbp
		;
		select * from sbpfreqs
		;
quit;

/* the freq statement*/
proc univariate data=sbpfreqs;
var sbp;
freq num;
run;






