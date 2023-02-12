/*01 PROC TABULATE*/
/*create the analytic data set*/
/*note that this example is from SAS help*/
data year_sales;
   input Month $ Quarter $ SalesRep $14. Type $ Units Price @@;
   AmountSold=Units*price;
   datalines;
01 1 Hollingsworth Deluxe    260 49.50 01 1 Garcia        Standard   41 30.97
01 1 Hollingsworth Standard  330 30.97 01 1 Jensen        Standard  110 30.97
01 1 Garcia        Deluxe    715 49.50 01 1 Jensen        Standard  675 30.97
02 1 Garcia        Standard 2045 30.97 02 1 Garcia        Deluxe     10 49.50
02 1 Garcia        Standard   40 30.97 02 1 Hollingsworth Standard 1030 30.97
02 1 Jensen        Standard  153 30.97 02 1 Garcia        Standard   98 30.97
03 1 Hollingsworth Standard  125 30.97 03 1 Jensen        Standard  154 30.97
03 1 Garcia        Standard  118 30.97 03 1 Hollingsworth Standard   25 30.97
03 1 Jensen        Standard  525 30.97 03 1 Garcia        Standard  310 30.97
04 2 Garcia        Standard  150 30.97 04 2 Hollingsworth Standard  260 30.97
04 2 Hollingsworth Standard  530 30.97 04 2 Jensen        Standard 1110 30.97
04 2 Garcia        Standard 1715 30.97 04 2 Jensen        Standard  675 30.97
05 2 Jensen        Standard   45 30.97 05 2 Hollingsworth Standard 1120 30.97
05 2 Garcia        Standard   40 30.97 05 2 Hollingsworth Standard 1030 30.97
05 2 Jensen        Standard  153 30.97 05 2 Garcia        Standard   98 30.97
06 2 Jensen        Standard  154 30.97 06 2 Hollingsworth Deluxe     25 49.50
06 2 Jensen        Standard  276 30.97 06 2 Hollingsworth Standard  125 30.97
06 2 Garcia        Standard  512 30.97 06 2 Garcia        Standard 1000 30.97
07 3 Garcia        Standard  250 30.97 07 3 Hollingsworth Deluxe     60 49.50
07 3 Garcia        Standard   90 30.97 07 3 Hollingsworth Deluxe     30 49.50
07 3 Jensen        Standard  110 30.97 07 3 Garcia        Standard   90 30.97
07 3 Hollingsworth Standard  130 30.97 07 3 Jensen        Standard  110 30.97
07 3 Garcia        Standard  265 30.97 07 3 Jensen        Standard  275 30.97
07 3 Garcia        Standard 1250 30.97 07 3 Hollingsworth Deluxe     60 49.50
07 3 Garcia        Standard   90 30.97 07 3 Jensen        Standard  110 30.97
07 3 Garcia        Standard   90 30.97 07 3 Hollingsworth Standard  330 30.97
07 3 Jensen        Standard  110 30.97 07 3 Garcia        Standard  465 30.97
07 3 Jensen        Standard  675 30.97 08 3 Jensen        Standard  145 30.97
08 3 Garcia        Deluxe    110 49.50 08 3 Hollingsworth Standard  120 30.97
08 3 Hollingsworth Standard  230 30.97 08 3 Jensen        Standard  453 30.97
08 3 Garcia        Standard  240 30.97 08 3 Hollingsworth Standard  230 49.50
08 3 Jensen        Standard  453 30.97 08 3 Garcia        Standard  198 30.97
08 3 Hollingsworth Standard  290 30.97 08 3 Garcia        Standard 1198 30.97
08 3 Jensen        Deluxe     45 49.50 08 3 Jensen        Standard  145 30.97
08 3 Garcia        Deluxe    110 49.50 08 3 Hollingsworth Standard  330 30.97
08 3 Garcia        Standard  240 30.97 08 3 Hollingsworth Deluxe     50 49.50
08 3 Jensen        Standard  453 30.97 08 3 Garcia        Standard  198 30.97
08 3 Jensen        Deluxe    225 49.50 09 3 Hollingsworth Standard  125 30.97
09 3 Jensen        Standard  254 30.97 09 3 Garcia        Standard  118 30.97
09 3 Hollingsworth Standard 1000 30.97 09 3 Jensen        Standard  284 30.97
09 3 Garcia        Standard  412 30.97 09 3 Jensen        Deluxe    275 49.50
09 3 Garcia        Standard  100 30.97 09 3 Jensen        Standard  876 30.97
09 3 Hollingsworth Standard  125 30.97 09 3 Jensen        Standard  254 30.97
09 3 Garcia        Standard 1118 30.97 09 3 Hollingsworth Standard  175 30.97
09 3 Jensen        Standard  284 30.97 09 3 Garcia        Standard  412 30.97
09 3 Jensen        Deluxe    275 49.50 09 3 Garcia        Standard  100 30.97
09 3 Jensen        Standard  876 30.97 10 4 Garcia        Standard  250 30.97
10 4 Hollingsworth Standard  530 30.97 10 4 Jensen        Standard  975 30.97
10 4 Hollingsworth Standard  265 30.97 10 4 Jensen        Standard   55 30.97
10 4 Garcia        Standard  365 30.97 11 4 Hollingsworth Standard 1230 30.97
11 4 Jensen        Standard  453 30.97 11 4 Garcia        Standard  198 30.97
11 4 Jensen        Standard   70 30.97 11 4 Garcia        Standard  120 30.97
11 4 Hollingsworth Deluxe    150 49.50 12 4 Garcia        Standard 1000 30.97
12 4 Jensen        Standard  876 30.97 12 4 Hollingsworth Deluxe    125 49.50
12 4 Jensen        Standard 1254 30.97 12 4 Hollingsworth Standard  175 30.97
;
run;

/*a two-way table*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Amount Sold by Each Sales Representative';
   class SalesRep; 
   /*SalesRep is specified as a class variable. A category is created for each unique value of SalesRep wherever SalesRep is used in a TABLE statement.*/

   var AmountSold; 
   /*AmountSold is an analysis variable in the VAR statement. The values of AmountSold are used to compute statistics wherever AmountSold is used in a TABLE statement.  */

   table SalesRep, /*SalesRep is in the row dimension of the TABLE statement. A row is created for each unique value of SalesRep. */ 

         AmountSold;/*AmountSold is in the column dimension of the TABLE statement. The default statistic for analysis variables, SUM, is used to summarize the values of AmountSold. */

run;
title;

/*three-way table*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Quarterly Sales by Each Sales Representative';
   class SalesRep Quarter; 
   var AmountSold; 
   table SalesRep, 
         Quarter, 
         AmountSold; 
run;
title;

/*multiple tables*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Sales of Deluxe Model Versus Standard Model';
   class SalesRep Type;
   var AmountSold Units;
   table Type; /*produces a one-dimensional table */
   table Type, Units; /*produces a two-dimensional table */
   table SalesRep, Type, AmountSold;/*produces a three-dimensional table*/
run; 
title;

/*hierarchical tables*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Amount Sold Per Item by Each Sales Representative';
   class SalesRep Type;
   var AmountSold;
   table SalesRep*Type,
         AmountSold;
run;
title;

/*formatting output*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Amount Sold Per Item by Each Sales Representative';
   class SalesRep Type;
   var AmountSold;
   table SalesRep*Type,
         AmountSold*f=dollar16.2;
run;
title;

/*calculating descriptive statistics*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Average Amount Sold Per Item by Each Sales Representative';
   class SalesRep Type;
   var AmountSold;
   table SalesRep*Type,
         AmountSold*mean*f=dollar16.2;
run;
title;

/*including multiple statistics*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Sales Summary by Representative and Product';
   class SalesRep Type;
   var AmountSold;
   table SalesRep*Type,
         AmountSold*n AmountSold*f=dollar16.2;
run;
title;

/*reduce code*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Sales Summary by Representative and Product';
   class SalesRep Type;
   var AmountSold;
   table SalesRep*Type,
         AmountSold*(n sum*f=dollar16.2);
run;
title;

/*including totals*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Sales Report';
   class SalesRep Type;
   var AmountSold;
   table SalesRep*Type all,
         AmountSold*(n (mean sum)*f=dollar16.2);
run;
title;

/*include labels*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Sales Performance';
   class SalesRep Type;
   var AmountSold;
   table SalesRep='Sales Representative' *
         (Type='Type of Coffee Maker' all) all,
         AmountSold=' ' *
         (N='Sales'
         SUM='Amount' *f=dollar16.2
         colpctsum='% Sales'
         mean='Average Sale' *f=dollar16.2);
run;
title;

/*styles*/
proc tabulate data=year_sales format=comma10.;
   title1 'TruBlend Coffee Makers, Inc.';
   title2 'Sales Performance';
   class SalesRep;
   class Type / style=[font_style=italic];
   var AmountSold;
   table SalesRep='Sales Representative'*(Type='Type of Coffee Maker'
         all*[style=[background=yellow font_weight=bold]])
         all*[style=[font_weight=bold]],
         AmountSold=' '*(colpctsum='% Sales' mean='Average Sale'*
         f=dollar16.2);
run;

/*02 /*****Enhancing Output*****/

/*a simple report*/
libname orion '/courses/d649d56dba27fe300/STA5066';
title "The sales data set";
footnote "A Basic Report";
proc print data=orion.sales(obs=3);
   var Employee_ID First_Name Last_Name Salary;
run;
title;
footnote;

/*some enhancements*/
proc print data=orion.sales(obs=3) label;
   var Employee_ID First_Name Last_Name Salary;
   title 'Orion Sales Employees';
   title2 'Males Only';
   footnote 'Confidential';
   label Employee_ID='Sales ID' First_Name='First Name'
         Last_Name='Last Name' Salary='Annual Salary';
   format Salary dollar8.;
   where Gender='M';   
   by Country;
run;
title;/* Reset Global Statements */
footnote;

/*footnotes*/

footnote1 'By Human Resource Department';
footnote3 'Confidential';

proc means data=orion.sales;
   var Salary; 
   title 'Orion Star Sales Employees';
run;

footnote;/* Reset Global Statements */

/*changing and cancelling footnotes*/
proc print data=orion.sales(obs=3);
   footnote1 'The First Line';
   footnote2 'The Second Line';
run;
proc print data=orion.sales(obs=3);
   footnote2 'The Next Line';
run;
proc print data=orion.sales(obs=3);
   footnote 'The Top Line'(obs=3);
run;
proc print data=orion.sales(obs=3);
   footnote3 'The Third Line';
run;
proc print data=orion.sales(obs=3);
   footnote;
run;


/****** systems functions ******/

/*Sysdate and systime macro variables*/
proc freq data=orion.sales;
   tables Gender Country;
   footnote1 'Orion Star Sales Employee Listing';
   footnote2 "Created on &sysdate9 at &systime";
run;
footnote;

/* %let and %sysfunc */
%let currentdate=%sysfunc(today(),worddate.);
%let currenttime=%sysfunc(time(),timeampm.);

proc freq data=orion.sales;
   tables Gender Country;
   footnote1 'Orion Star Employee Summary';
   footnote2 "Created &currentdate";
   footnote3 "at &currenttime";
run;

footnote;

/* Using labels within procs*/

proc freq data=orion.sales;
   tables Gender Country;
	 /*temporary label for duration of proc*/
   label Gender='Sales Employee Gender';
run;

proc contents data=orion.sales;
run;

/*proc print with label option*/
footnote "proc print without label option";
proc print data=orion.sales (obs=10);
   var Employee_ID  Salary;
   label Employee_ID='Sales ID'
         Salary='Annual Salary';
run;

footnote "proc print with a label option";
proc print data=orion.sales (obs=10) label;
   var Employee_ID Salary;
   label Employee_ID='Sales ID'
         Salary='Annual Salary';
run;

footnote;

/*the split option*/
proc print data=orion.sales (obs=10) split='*';
   var Employee_ID Salary;
   label Employee_ID='Sales ID'
         Salary='Annual*Salary';
run;

/*split option with permanent labels*/
data bonus;
   set orion.sales;
   Bonus=Salary*0.10;
   label Salary='Annual*Salary'
         Bonus='Annual*Bonus';
   keep Employee_ID First_Name 
        Last_Name Salary Bonus;
run;
proc contents data=bonus;
run;

proc print data=bonus split='*';
run;

/*temporary vs permanent labels*/
data bonus;
   set orion.sales;
   Bonus=Salary*0.10;
   label Bonus='Annual Bonus';
run;

proc print data=bonus (obs=10) label;
   label Bonus='Mid-Year Bonus';
run;

proc print data=bonus (obs=10) label;
run;


/********formats******/

/*Format with proc print*/
proc print data=orion.sales (obs=10) label;
   var Employee_ID Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
           Salary='Annual Salary'
           Birth_Date='Date of Birth'
          Hire_Date='Date of Hire';
   format Salary dollar10.0
          Birth_Date Hire_Date monyy7.;
run;

/*Format with proc freq*/
proc freq data=orion.sales;
   tables Hire_Date;
   format Hire_Date year4.;
run;

/*Permanent vs temporary formats*/
data bonus;
   set orion.sales;
   Bonus=Salary*0.10;
   format Salary Bonus comma8.;
   keep Employee_ID First_Name 
        Last_Name Salary Bonus;
run;

footnote "Print with permanent formats";
proc print data=bonus (obs=12);
run;

footnote "Print with temporary formats";
proc print data=bonus (obs=12);
   format Bonus dollar8.;
run;

footnote;


/******User defined formats*****/
/*A format-name
Names the format that you are creating
Cannot be more than 32 characters 
For character values, must have a dollar sign ($) as  the first character, and a letter or underscore as the second character
For numeric values, must have a letter or underscore as the first character
Cannot end in a number
Cannot be the name of a SAS format
Does not end with a period in the VALUE statement.
*/

/*character variable formats*/
proc format;
   value $ctryfmt  'AU' = 'Australia'
                   'US' = 'United States' 
                  other = 'Miscoded';
run;

footnote "User-defined character format";

proc print data=orion.sales (obs=9) label;
   var Employee_ID  Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Salary dollar10.0 
          Birth_Date Hire_Date monyy7.
          Country $ctryfmt.;
run;

footnote;

/*user-defined numerics formats*/
proc format;
   value tiers  20000-49999  = 'Tier 1'                  
                     50000-99999  = 'Tier 2'
                 100000-250000 = 'Tier 3';
run;

footnote "User-defined numeric formats";
proc print data=orion.sales (obs=7) label;
   var Employee_ID  Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;

footnote;


/*the < construct*/
proc format;
   value tiers  20000-<50000  = 'Tier 1'                  
                50000- <100000 = 'Tier 2'
               100000-250000 = 'Tier 3'
                 other="Illegal Category";
run;

footnote "User defined numeric formats with <";
proc print data=orion.sales (obs=8) label;
   var Employee_ID  Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;
footnote;

/*The low and high keywords*/
proc format;
   value tiers    low-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-high   = 'Tier 3';
run;
footnote "User-defined formats with low and high keywords";
proc print data=orion.sales label;
   var Employee_ID job_title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         job_title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;
footnote;

/*format with proc freq*/
proc format;
   value tiers    low-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-high   = 'Tier 3';
run;

footnote "User-defined formats with low and high keywords";

proc freq data=orion.sales;
   tables salary;
   format Salary tiers.;
run;

footnote;

/*format with proc means*/
proc format;
   value tiers    low-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-high   = 'Tier 3';
run;

footnote "User-defined formats with low and high keywords";

proc means data=bonus;
   class salary;
	 var bonus;
   format Salary tiers.;
run;

footnote;

/*multiple formats*/
proc format;
   value $ctryfmt  'AU' = 'Australia'
                   'US' = 'United States' 
                  other = 'Miscoded';
   value tiers    low-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-high   = 'Tier 3';
run;

footnote "Multiple User-defined Formats";

proc print data=orion.sales (obs=5) label ;
   var Employee_ID Job_title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         job_title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Country $ctryfmt. 
          Salary tiers.;
run;
proc freq data=orion.sales;
   tables Country Salary;
   format Country $ctryfmt. Salary tiers.;
run;

footnote;


/* Picture formats, example from SAS help
salaries are in euros, 1.61 the exchange rate
i.e. 1.61 dollars per euro*/
data staff;
   infile datalines dlm='#';
   input Name & $16. IdNumber $ Salary
         Site $ HireDate date8.;
   format hiredate date8.;
   datalines;
Capalleti, Jimmy#  2355# 21163# BR1# 30JAN13
Chen, Len#         5889# 20976# BR1# 18JUN06
Davis, Brad#       3878# 19571# BR2# 20MAR04
Leung, Brenda#     4409# 34321# BR2# 18SEP94
Martinez, Maria#   3985# 49056# US2# 10JAN93
Orfali, Philip#    0740# 50092# US2# 16FEB03
Patel, Mary#       2398# 35182# BR3# 02FEB90
Smith, Robert#     5162# 40100# BR5# 15APR06
Sorrell, Joseph#   4421# 38760# US1# 19JUN11
Zook, Carla#       7385# 22988# BR3# 18DEC10
;
run;
proc print data=staff;run;


/*picture format, 1.61 is exchange rate */
/*Define the USCURRENCY. picture format. 
The PICTURE statement creates a template for printingnumbers. 
LOW-HIGH ensures that all values are included in the range.
The MULT= statement option specifies that each value is multipliedby 1.61. 
The PREFIX= statement adds a US dollar sign to any numberthat you format.
The picture contains six digit selectors, five for the salary 
and one for the dollar sign prefix.*/ 
proc format ;
      picture uscurrency low-high='000,000' (mult=1.61 prefix='$');
   run;
proc print data=staff noobs label;
   label salary='Salary in U.S. Dollars';
   format salary uscurrency.;
   title "STAFF with a Format for the Variable Salary";
run;
title;

/***** displaying missing data ******/
proc print data=sashelp.heart(obs=20);
var cholesterol;
run;

options missing=U;

proc print data=sashelp.heart(obs=20);
var cholesterol;
run;

options missing=.;

proc format;
value miss
	.="Unknown";
;
run;
proc print data=sashelp.heart(obs=20);
var cholesterol;
format cholesterol miss.;
run;


/**** USING WHERE STATEMENT IN PROCs ******/
footnote "WHERE Statement with PROC PRINT";
proc print data=orion.sales;
   var First_Name Last_Name Country Salary;
   where Salary > 75000;
run;

footnote;


footnote "WHERE Statement with PROC MEANS";
proc means data=orion.sales;
   var Salary;
   where Country = 'AU' and gender="M";
run;

footnote;

/*USING BY STATEMENTS WITH PROCs*/
footnote "By Statement with proc print";

proc sort data=orion.sales out=work.sort;
   by Country descending Gender Last_Name;
run;


proc print data=work.sort;
   var Employee_ID First_Name Last_Name Salary;
   by Country descending Gender;
run;

footnote;

footnote "BY Statement with PROC MEANS";
proc means data=work.sort;
   var Salary;
   by Country descending Gender;
run;

footnote;

footnote "BY Statement with PROC FREQ";
proc freq data=work.sort;
   tables Gender;
   by Country;
run;

footnote;

