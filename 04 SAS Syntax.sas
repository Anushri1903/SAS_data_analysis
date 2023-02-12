filename pt '/courses/d649d56dba27fe300/Data Sets/PlatingTransistors.txt';
data Trans;
  infile pt;
  input Thick @@;
  label Thick = 'Plating Thickness (mils)';
run;

title 'Analysis of Plating Thickness';
proc print data=Trans (obs=10) label; 
run;

filename emps '/courses/d649d56dba27fe300/Data Sets/newemps.csv';
data NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile emps dlm=",";
   input First_Name $ Last_Name $  
         Job_Title $ Salary /*numeric*/;
run;
data employees_tmp;
set newsalesemps;
call streaminit(54321);
if rand("uniform") le .05 then  job_title="";
if rand("uniform") le .1 then  salary=.;
run;
proc print data=employees_tmp;
run;

proc univariate data=work.trans; 
	histogram thick;
	qqplot thick;
run;
	
data tmp;
	x=5;
	y=x*2;
	z=x**2;
	a=sqrt(z);
	b="A character variable";	
run;
proc print data=tmp;
run;

data tmp;
	do i=1 to 5;
		x=i;
		y=x*2;
		z=x**2;
		a=sqrt(z);
		b="A character variable";
		output;
	end;	
run;
proc print data=tmp;
run;

/*
  Source:  R 9.2 (AER package)
	Written by R using write.foreign
*/ 
*------------------------------------------------------------|
|Wages of employees of a US bank.                            |
|Source Online complements to Heij, de Boer, Franses, Kloek, | 
|and van Dijk (2004).                                        |
|References                                                  |
|Heij, C., de Boer, P.M.C., Franses, P.H., Kloek, T. and     | 
|van Dijk, H.K. (2004).                                      | 
|Econometric Methods with Applications in Business and       |
|Economics.  Oxford: Oxford University Press.                | 
|------------------------------------------------------------;

PROC FORMAT;
value job 
     1 = "custodial" 
     2 = "admin" 
     3 = "management" 
;

value gender 
     1 = "male" 
     2 = "female" 
;

value minority 
     1 = "no" 
     2 = "yes" 
;
run;

FILENAME wages '/courses/d649d56dba27fe300/Data Sets/BankWages.txt';
DATA  wages ;
  INFILE  '/courses/d649d56dba27fe300/Data Sets/BankWages.txt' DLM=',';
  INPUT job education gender minority;
  FORMAT job job. gender gender. minority minority.;
RUN;

proc print data=wages (obs=25);
run;

FILENAME emps '/courses/d649d56dba27fe300/Data Sets/newemps.csv';
data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile emps dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary /*numeric*/;
run;
/*proc print data=NewSalesEmps;  run;  */
proc means data=NewSalesEmps;
   *class Job_Title;
   var Salary;
run;

proc freq data=sashelp.heart;
tables sex*status;
run;

Filename emps '/courses/d649d56dba27fe300/Data Sets/newemps.csv';
data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile emps dlm=",";
   input First_Name $ Last_Name $  
         Job_Title $ Salary /*numeric*/;
	  bonus=salary*.1;
run;
proc print data=NewSalesEmps(obs=21) noobs;
run;


data NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18 Job_Title $ 25;
   infile emps dlm=',';
   input First_Name $ Last_Name $ Job_Title $ Salary ;
run;
/*missing semicolon*/
proc means data=NewSalesEmps 
   var Salary;
run;

/*incorrect key word
Notice that average is not blue because the correct keyword is mean*/
proc means data=NewSalesEmps average;
   var Salary;
run;


