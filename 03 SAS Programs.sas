/*01 Introduction*/
filename nh3 '/courses/d649d56dba27fe300/Data Sets/nh3.txt';
title 'Example';
data nh3;
infile nh3;
input age gender $;
run;

proc print data=nh3;
run;

proc ttest data=nh3;
class gender;
var age;
run; 

/*03 Data Step*/ 
data iris1;
infile datalines dlm=",";
input sepal_length sepal_width petal_length petal_width	variety $ ;
datalines;
5.1,3.5,1.4,0.2,setosa
4.9,3,1.4,0.2,setosa
4.7,3.2,1.3,0.2,setosa
4.6,3.1,1.5,0.2,setosa
5,3.6,1.4,0.2,setosa
5.4,3.9,1.7,0.4,setosa
4.6,3.4,1.4,0.3,setosa
5,3.4,1.5,0.2,setosa
4.4,2.9,1.4,0.2,setosa
4.9,3.1,1.5,0.1,setosa
5.4,3.7,1.5,0.2,setosa
4.8,3.4,1.6,0.2,setosa
4.8,3,1.4,0.1,setosa
;
run;


FILENAME sales '/courses/d649d56dba27fe300/Data Sets/sales.csv';
PROC IMPORT DATAFILE=sales
DBMS=CSV
OUT=WORK.dlm1;
GETNAMES=No;
RUN; 
proc print data=dlm1;
run;
data sales;
set dlm1;
rename Var2=First_Name Var3=Last_Name Var5=Salary Var6=Job_title;
run; 

/*04 PROC STEP*/
proc print data=sales  ;
var salary job_title;
run;


proc print data=sales (obs=10) noobs;
var salary Job_title;
run;

proc means data=sales;
   class Job_Title;
   var Salary;
run;

proc means data=sales n mean std clm;
   class Job_Title;
   var Salary;
run;




