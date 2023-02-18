%let path= /courses/d649d56dba27fe300/STA5067/SAS Data;
/*01 Intro to PROC SQL*/
libname orion "&path/orion";
libname nh9ques "&path/nhanes1999/questionnaire";
libname nh9lab "&path/nhanes1999/lab";
libname nh9exam "&path/nhanes1999/exam";
libname nh9demo "&path/nhanes1999/demographics";
libname nh9diet "&path/nhanes1999/dietary";

libname nh9 (nh9demo nh9exam nh9lab nh9ques);
libname nhanes3 "&path/nhanes3";
proc sql ;
	select * 
	from orion.employee_payroll
	having salary=max(salary)
	;
quit;

proc sql ;
	select mean(salary) "Average Salary" format=dollar12., employee_gender 
	from orion.employee_payroll
	group by employee_gender
	;
quit;


proc sql ;
	create table newbp as
	select mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4) as mnsbp,
       mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4) as mndbp,
	   seqn
	from nh9.bloodpressure
	;
	select n(mnsbp) "mnsbp",n(mndbp) "mndbp"
	from newbp
	;
quit;

data tmp;
   input x b $ @@;
datalines;
1 a1 1 a2 2 b1 2 b2 4 d
;
proc print data=tmp;
title "tmp";
run;
title;
proc sql;
update tmp 
   set x=x*2
   where b contains "a";
title "tmp";
select * from tmp;
quit;
title;


proc sql ;
	select mean(ridageex) into : mnage 
		from nh9.demographics
		;
quit;
%put Average age:  &mnage;

proc sql;
	create table analysis as
	select		b.seqn, mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4) as mnsbp,
			mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4) as mndbp,
			riagendr=1 as male,
			ridageyr as age,
			ridreth2 as race_ethn,
			lbdhdl as hdl,
			lbxtc as chol,
			bmxbmi as bmi
	from 		nh9.bloodpressure(keep=seqn bpxsy1-bpxsy4 BPXDI1-BPXDI4) b,
			nh9.demographics (keep=seqn ridageyr riagendr RIDRETH2) c,
			nh9.bodymeasurements(keep=seqn bmxbmi) d,
			nh9.cholesterolhdl(keep= seqn LBDHDL LBXTC) e
	where	b.seqn=c.seqn and
			c.seqn=d.seqn and
			d.seqn=e.seqn
	order by seqn
	;
quit;

/*02 SQL Overview*/
proc sql;
    select *
    from orion.Employee_Payroll
    ;
quit;

proc sql;
   select Employee_ID, Employee_Gender,Salary
      from orion.Employee_Payroll
      where Employee_Gender = "F"
      order by Salary desc
	;
quit;

proc sql;
   select Employee_ID, Employee_Gender,Salary
      from orion.Employee_Payroll
      where Employee_Gender = "F"
      order by Salary desc;
quit;

/*This is correct*/
proc sql;
   select Employee_ID, Employee_Gender,
           Salary
      from orion.Employee_Payroll
      where Employee_Gender = 'M'
      order by Employee_ID;
quit;

  /* select must come before from */
proc sql;
   from orion.Employee_Payroll
   select Employee_ID, Employee_Gender,
          Salary
      where Employee_Gender = 'M'
      order by EmpID;
quit;

proc sql;
   validate
      select Employee_ID, Employee_Gender,Salary
	     from orion.Employee_Payroll
         where Employee_Gender = 'M'
         order by Employee_ID;
quit;
/*note the errors in the following*/
proc sql;
	validate
   from orion.Employee_Payroll
   select Employee_ID, Employee_Gender,
          Salary
      where Employee_Gender = 'M'
      order by EmpID;
quit;

proc sql;
   validate
   select Employee_ID, Employee_Gender, Salary,
      from orion.Employee_Payroll
      where Employee_Gender = 'F'
      order by Salary desc;
quit;

proc sql noexec;
	select Employee_ID, Employee_Gender,Salary
	     from orion.Employee_Payroll
         where Employee_Gender = 'M'
         order by Employee_ID
	;
	select Employee_ID, Employee_Gender,Salary,
	     from orion.Employee_Payroll
         where Employee_Gender = 'M'
         order by Employee_ID
	;
quit;

proc sql noexec;
   select Employee_ID, Employee_Gender,Salary,
      from orion.Employee_Payroll
      where Employee_Gender = 'F'
      order by Salary desc;
	reset exec;
	select Employee_ID, Employee_Gender,Salary
      from orion.Employee_Payroll
      where Employee_Gender = 'F'
      order by Salary desc;
	quit;

/*03 Specifying Columns*/
proc sql;
   describe table orion.Employee_Payroll
	;
quit;

proc sql;
	select *
   from orion.Employee_Payroll
	;
quit;

proc sql feedback;
	select *
   	from orion.Employee_Payroll;
quit;

proc sql;
   select Employee_ID, Employee_Gender,Salary
      from orion.Employee_Payroll;
quit;

proc sql;
   select Employee_ID, Salary, 
          Salary * .10 as Bonus
      from orion.Employee_Payroll;
quit;

proc sql;
   select *
   from orion.staff(keep=job_title salary obs=10);
quit;

proc sql;
	select Job_Title, Salary,
		case scan(Job_Title,-1,' ')
		when 'I' then Salary*.05
		when 'II' then Salary*.07
		when 'III' then Salary*.10
		when 'IV' then Salary*.12
		else Salary*.08
		end as Bonus format dollar12.2
	from orion.Staff
	;
quit;

proc sql;
   select Job_Title, Salary,
          case
             when scan(Job_Title,-1,' ')='I'
                  then Salary*.05
             when scan(Job_Title,-1,' ')='II'
                  then Salary*.07
             when scan(Job_Title,-1,' ')='III'
                 then Salary*.10
             when scan(Job_Title,-1,' ')='IV'
                 then Salary*.12
             else Salary*.08
          end as Bonus
       from orion.Staff
	;
quit;

proc sql;
   select Employee_ID, Employee_Gender,
          int((today()-Birth_Date)/365.25)
          as Age
      from orion.Employee_Payroll;
quit;

proc sql;
   create table work.birth_months as
      select Employee_ID, Birth_Date, 
             month(Birth_Date) as  
             Birth_Month, 
             Employee_gender
      from orion.Employee_Payroll
	;
   describe table work.birth_months
	;
quit;
proc print data=birth_months;
run;

libname nhanes3 "&path/nhanes3";
data body;
    set nhanes3.exam (keep=seqn bm:);
run;

proc contents data=body;
run;

/*use single - for numbered variables*/
proc contents data=orion.employee_donations;
run;
data donations;
  set orion.employee_donations(keep=employee_id qtr1-qtr4);
run;  
proc print data=donations (obs=5);
run;


proc contents data=nhanes3.adultdemographics position;
run;

data raceethnicity;
   set nhanes3.adultdemographics(keep=race_ethnicity--hispanic);
run;

proc print data=raceethnicity (obs=10);
run; 

data donations;
  set orion.employee_donations(keep=employee_id qtr1-qtr4
                            rename=(qtr1-qtr4=quarter1-quarter4));
run;  
proc print data=donations (obs=5);
run;


proc sql;
	select libname,memname,nvar
	from dictionary.tables
	where memname="EXAM" and libname="NHANES3"
	;
quit;

proc sql;
	create table body as 
	select * 
	from nhanes3.exam (keep=seqn bm:)
	order by seqn
	;
quit;

proc means data=body;
run;

/*What is wrong here?*/
proc sql;
	create table donations as 
	select qtr1-qtr4 
	from orion.employee_donations
	;
quit;

proc print data=donations;
run;

/*Correct way*/
proc sql;
	create table donations as 
	select * 
	from orion.employee_donations (keep=qtr1-qtr4)
	;
quit;

proc print data=donations;
run;


/*04 Distinct and Unique Keywords*/
proc sql;
   select Department
      from orion.Employee_Organization
	;
quit;

proc sql;
   select distinct Department
      from orion.Employee_Organization
	;
quit;

proc sql;
   select unique department
      from orion.Employee_Organization
	;
quit;

/*05 Selecting Rows with Where clause*/
proc sql;
   select Employee_ID, Job_Title, Salary
      from orion.Staff
      where Salary > 112000
	;
quit;

proc sql;
   select Employee_ID, Job_Title, Salary
      from orion.Staff
      where Salary > 112000 and gender="F"
	;
quit;

proc sql;
   select Employee_ID, Job_Title, Salary
      from orion.Staff
      where Salary > 112000 or gender="F"
	;
quit;

proc sql;
   select Employee_ID, Job_Title, Salary
      from orion.Staff
      where not (Salary <= 112000)
	;
quit;

/*06 Calculated Keyword*/
proc sql;
   select Employee_ID, Salary, 
          Salary * .10 as Bonus
      from orion.Employee_Payroll
	;
quit;

/*Why does this not work?*/
proc sql;
   select Employee_ID, Employee_Gender,
          Salary, Salary * .10 as Bonus
      from orion.Employee_Payroll
      where Bonus < 3000
	;
quit;

proc sql;
   select Employee_ID, Employee_Gender,
        Salary, Salary * .10 as Bonus
      from orion.Employee_Payroll
      where Salary * .10 < 3000
	;
quit;

proc sql;
   select Employee_ID, Employee_Gender,
    Salary, Salary * .10 as Bonus
      from orion.Employee_Payroll
      where calculated Bonus < 3000
	;
quit;

proc sql;
   select Employee_ID, Employee_Gender,
        Salary, Salary * .10 as Bonus,
          calculated Bonus/2 as Half
      from orion.Employee_Payroll
      where calculated Bonus < 3000
	;
quit;


/*07 Where clause operators*/
proc sql;
	select Employee_Name
	from orion.Employee_Addresses(obs=10)
	;
	select Employee_Name, Employee_ID
	from orion.Employee_Addresses
	where Employee_Name contains ', N'
	;
quit;

proc sql;
   select Employee_ID, Job_title
      from orion.Employee_Organization
      where Job_title like 'Security%'
	;
quit;



