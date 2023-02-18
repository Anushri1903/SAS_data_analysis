/*01 Ordering Data*/
%let path= /courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";
libname nh9ques "&path/nhanes1999/questionnaire";
libname nh9lab "&path/nhanes1999/lab";
libname nh9exam "&path/nhanes1999/exam";
libname nh9demo "&path/nhanes1999/demographics";
libname nh9diet "&path/nhanes1999/dietary";

libname nh9 (nh9demo nh9exam nh9lab nh9ques);
libname nhanes3 "&path/nhanes3";

proc sql;
   select Employee_ID, Salary
      from orion.Employee_payroll
      where Employee_Hire_Date < '01JAN1979'd
	;
quit;

proc sql;
   select Employee_ID, Salary
      from orion.Employee_payroll
      where Employee_Hire_Date < '01JAN1979'd
      order by Salary desc;
quit;

proc sql;
select Employee_ID,
       max(Qtr1,Qtr2,Qtr3,Qtr4)
   from orion.Employee_donations
   where Paid_By="Cash or Check"
   order by 2 desc, Employee_ID;
quit;

proc sql;
   select Employee_ID 
          label="Employee Identifier",
          sum(Qtr1,Qtr2,Qtr3,Qtr4) 
	     "Annual Donation" format=dollar7.2,
	     Recipients
   from orion.Employee_donations
   where Paid_By="Cash or Check"
   order by 2 desc, Employee_ID
;
quit;

proc sql;
title 'Annual Bonuses for Active Employees';
   select Employee_ID label='Employee Number',
          'Bonus is:',
           Salary *.05 format=comma12.2
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
      order by Salary desc
;
quit;
title;

/*02 Using Summary Functions*/
proc sql;
   select Employee_ID 
          label='Employee Identifier',
	     Qtr1,Qtr2,Qtr3,Qtr4,
          sum(Qtr1,Qtr2,Qtr3,Qtr4) 
	     label='Annual Donation' 
	     format=comma9.2
      from orion.Employee_donations
      where Paid_By="Cash or Check"
      order by 6 desc
;
quit;

proc sql;
   select sum(Qtr1) 
          'Total Quarter 1 Donations'
      from orion.Employee_Donations
;
quit;
title;

proc means data=orion.Employee_donations
           sum maxdec=0;
   var Qtr1;
run;

proc sql;
   select count(*) as Count
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
;
quit;

proc sql;
   select 'The Average Salary is:',
          avg(Salary)
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
;
     select 'The Mean Salary is:',
          mean(Salary)
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
;
quit;
title;

/*03 Remerging*/
proc sql;
   select Employee_id "Employee ID",Employee_Gender as Gender,
	 				salary format=dollar12.2,
          avg(Salary) format=dollar12.2 as Average 
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
;
quit;

/*look at the error message*/
proc sql noremerge;
   select Employee_Gender,
          avg(Salary) as Average
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
;
quit;

/*04 Group by having*/
proc sql;
   select Employee_Gender,
          avg(Salary) as Average
      from orion.Employee_Payroll
      where Employee_Term_Date is missing
      group by Employee_Gender
;
quit;

proc sql;
   select Department, count(*) as Count
      from orion.Employee_Organization
      group by Department
;
quit;

proc sql;
title "Male Employee Salaries";
   select Employee_ID, Salary format=comma12.,
          Salary / sum(Salary) 
          format=percent6.2
      from orion.Employee_Payroll
      where Employee_Gender="M"
            and Employee_Term_Date is missing
      order by 3 desc
;
quit;
title;

proc sql;
   select Department, count(*) as Count
      from orion.Employee_Organization
	 group by Department
	 having Count ge 25
	 order by Count desc
;
quit;


/*05 Grouping with Boolean Conditions*/
proc sql ;
   select Department,Job_Title,
          (find(Job_Title,"manager","i") >0)
          "Manager" 
      from orion.Employee_Organization
;
quit;

proc sql;
title "Manager to Employee Ratios";
   select Department,
          sum((find(Job_Title,"manager","i") >0))
            as Managers,
          sum((find(Job_Title,"manager","i") =0))
            as Employees,
          calculated Employees/calculated Managers
          "E/M Ratio" format=8.3
      from orion.Employee_Organization
      group by Department
;
quit;

/*06 Framingham Heart Study Example */

proc contents data=sashelp.heart position;run;

proc sql;
	select sex as gender, count(cholesterol) as n,
          mean(cholesterol) format=8.1 as mnchol, 
          std(cholesterol) as stdchol format=8.1
	from sashelp.heart
	group by sex
   ;
quit;

proc sql outobs=17;
  select sex,cholesterol,
         703*weight/(height**2) format 4.1 as bmi
		from sashelp.heart
  		where calculated bmi ne .
	;
quit; 

proc sql;
	create table bmitmp as
	select sex, 703*weight/(height**2) format 4.1 as bmi
           from sashelp.heart
	where calculated bmi ne .
;
quit; 

proc print data=bmitmp (obs=17);
run;

/*create class based on bmi*/
proc sql outobs=11;
	create table bmi1 as
	select sex as gender,
           703*weight/(height**2) format 4.1 as bmi,
	      case 
	      when calculated bmi < 18.5 then 'Underweight'
	      when calculated bmi between 18.5 and 24.9 then 'Normal'
	      when calculated bmi between 25 and 30 then 'Overweight'
	      when calculated bmi > 30 then 'Obese'
	      end as weight_class
           from sashelp.heart
           where calculated bmi ne . 
           ;
        quit; 

proc sql;
   select count(*) 
	 from sashelp.heart;
quit;

/*07 SQL to summarize simulated data*/
%let reps=10000;
%let obs=25;
data normalmean;
call streaminit(1768315);
do reps=1 to &reps;
  do obs=1 to &obs;
    sales=round(rand("normal",250,40),.01);
    output;
  end;
end;
run;

proc sql;
	create table means as
	select mean(sales)as mnreps
	from normalmean
	group by reps;
quit;

ods select histogram;
proc univariate data=means;
var mnreps;
histogram mnreps/normal;
title "&reps Replications of normal mean";
title2 "From a sample of size &obs";
run;
title;

%let reps=1000;
%let obs=25;
data normalmean;
call streaminit(1768315);
do reps=1 to &reps;
  do obs=1 to &obs;
    sales=round(rand("normal",250,40),.01);
    output;
  end;
end;
run;

proc sql noprint;
create table means as
select mean(sales)as mnreps
from normalmean
group by reps;
quit;

ods select histogram;
proc univariate data=means;
var mnreps;
histogram mnreps/normal;
run;

/*08 Demonstrating Regression*/

proc sgplot data=sashelp.class;
	scatter x=age y=height/group=sex
	       markerattrs=(symbol=circlefilled);
	reg x=age y=height/group=sex;
run;



proc sgplot data=nhanes3.bodyfat;
scatter x=Age y=pctbodyfat1;
run;

proc reg data=nhanes3.bodyfat plots=none;
model pctbodyfat1=age;
run;


proc sql noprint;
 create table mnbfage as
 select age,count(pctbodyfat1) as n,mean(pctbodyfat1) as mnbf
 from nhanes3.bodyfat
 group by age;
quit;

proc sgplot data=mnbfage;
series x=age y=mnbf;
run;

/*09 Meta Analysis Fixed Effects Model*/
/*Specialist care for stroke patients from nine studies: comparing specialist
multidisciplinary team care for managing stroke inpatients with routine management
in general medical wards. 

Data are from Normand, Meta-Analysis Tutorial, Stat Med 1989
*/
data stroke;
input source $20. n1 los1 sd1 n2 los2 sd2;
label n1 ="Number strokes (specialist)"
      los1 ="Length of stay (specialist)"
      sd1="Standard deviation (specialist)"
      n2 ="Number strokes (routine)"
      los2 ="Length of stay (routine)"
      sd2="Standard deviation (routine)"
;
mndiff=los1-los2;
vardiff=sd1*sd1/n1+sd2*sd2/n2;
precdiff=1/vardiff;
datalines;
Edinburgh            155 55 47 156 75 65  
Orpington-Mild       31 27 7 32 29 4
Orpington-Moderate   75 64 17 71 119 29
Orpington-Severe     18 66 20 18 137 48 
Montreal-Home        8 14 8 13 18 11 
Montreal-Transfer    57 19 7 52 18 4 
Newcastle(1993)      34 52 45 33 41 34 
Umea(1985)           110 21 16 183 31 27 
Uppsala(1982)        60 30 27 52 23 20 
;

run;

PROC SQL;
	SELECT SUM(mndiff*precdiff)/SUM(precdiff) AS estimate, 
    1/SUM(precdiff) AS VarEst
	FROM work.stroke;
QUIT;

