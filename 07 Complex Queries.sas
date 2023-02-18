%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname nhanes3 "&path/nhanes3";
/*01 SQL Data Step Merge Mix and Match*/
proc contents data=nhanes3.adult;
run;

proc contents data=nhanes3.mortality;
run;

%let demographics=hsageir hssex DMAETHNR dmaracer dmarethn SDPSTRA6 SDPPSU6 WTPFQX6;
%let lib=work;
proc format lib=&lib;
    value f_SEX 1="Male" 2="Female";
	/*dmaracer*/
    value f_RACER 1="White" 2="Black" 3="Other" 8="Mexican-American of unknown race";
	/*DMARETHN */
    value f_rethn 1="Non-Hispanic white" 2="Non-Hispanic black" 3="Mexican-American" 4="Other";
	/*DMAETHNR*/    
    value f_ethnr 1="Mexican-American" 2="Other Hispanic" 3="Not Hispanic";
run;
proc sql;
	create table &lib..adultdemographics as
	select seqn,
		   hsageir as age ,
		   hssex as sex format=f_sex.,
		   dmaracer as race format=f_racer.,
		   dmarethn as race_ethn format=f_rethn.,
		   dmaethnr as hispanic format= f_ethnr.,
		   SDPSTRA6 as strata, /*strata for survey procs*/
		   SDPPSU6 as cluster, /*cluster for survey procs*/
		   WTPFQX6 as weight /*weight for survey procs*/
		   from nhanes3.adult
		   where seqn in (select seqn from nhanes3.mortality 
		   where eligstat=1)
	;
run;
	
proc contents data=&lib..adultdemographics;
run;

%let demographics=hsageir hssex DMAETHNR dmaracer dmarethn SDPSTRA6 SDPPSU6 WTPFQX6;
%let lib=work;
proc format lib=&lib;
    value f_SEX 1="Male" 2="Female";
	/*dmaracer*/
    value f_RACER 1="White" 2="Black" 3="Other" 8="Mexican-American of unknown race";
	/*DMARETHN */
    value f_rethn 1="Non-Hispanic white" 2="Non-Hispanic black" 3="Mexican-American" 4="Other";
	/*DMAETHNR*/    
    value f_ethnr 1="Mexican-American" 2="Other Hispanic" 3="Not Hispanic";
run;
proc sql;
	create table &lib..adultdemographics as
	select seqn,
		   hsageir as age ,
		   hssex as sex format=f_sex.,
		   dmaracer as race format=f_racer.,
		   dmarethn as race_ethn format=f_rethn.,
		   dmaethnr as hispanic format= f_ethnr.,
		   SDPSTRA6 as strata, /*strata for survey procs*/
		   SDPPSU6 as cluster, /*cluster for survey procs*/
		   WTPFQX6 as weight /*weight for survey procs*/
		   from nhanes3.mortality l left join nhanes3.adult r
		   on l.seqn=r.seqn 
		   where eligstat=1
	;
run;
	
proc contents data=&lib..adultdemographics;
run;

proc contents data=nhanes3.lab;run;
proc means data=nhanes3.lab;run;

%let lib=work;
%let sub=HGP   HTP   TCP TGP  LCP HDP FBPSI CRP   SGP URP;
%let u=  88888 88888 888 8888 888 888 8888  88888 888 88888;
%let numvar=10;
proc sql;
	create table onmort as
	select * 
	from nhanes3.lab (keep= seqn &sub)
	where seqn in (select seqn 
					from nhanes3.mortality
					where eligstat=1)
	;
quit;						
data &lib..labsubset (drop=i label="Lab subset, Nhanes3, fill values replaced by unknowns");
   set onmort;
array vars{*} &sub;
array unk{&numvar} _temporary_ (&u);
do i=1 to dim(vars);
  if vars{i}=unk{i} then vars{i}=.;
end;
rename HGP=Hemoglobin
HTP=Hematocrit
TCP=cholesterol
TGP=triglycerides
LCP=ldl
HDP=hdl
FBPSI=fibrinogen
CRP=c_reactive_protein
SGP=glucose
URP=urinary_creatinine;
run;

proc contents data=&lib..labsubset;
run;

/*02 Complex SQL Joins*/
libname orion "&path/orion";
proc sql;
   create table avgsalary as
   select Job_Title, 
          avg(Salary) as Job_Avg  format=comma7.
             from orion.Employee_payroll as p, 
           orion.Employee_organization as o
      where p.Employee_ID=o.Employee_ID
            and not Employee_Term_Date
            and o.Department="Sales"
   group by Job_Title;
quit;

/*Now do inner join:*/
proc sql;
select Last_name, emp.Job_Title, 
          Salary format=comma7., Job_Avg format=comma7.
      from avgsalary as job,
           orion.Sales as emp
       where emp.Job_Title=job.Job_Title
             and Salary < Job_Avg*.95
       order by Job_Title, Last_name;
quit;

/*2nd Method*/
proc sql;
title  "Sales Department Average Salary"; 
title2 "By Job Title";
   select Job_Title, 
          avg(Salary) as Job_Avg 
          format=comma7.
             from orion.Employee_payroll as p, 
           orion.Employee_organization as o
      where p.Employee_ID=o.Employee_ID
            and not Employee_Term_Date
            and o.Department="Sales"
   group by Job_Title;
quit;
title;

proc sql;
title  "Employees with salaries less than";
title2 "95% of the average for their job";
   select Last_Name, emp.Job_Title, 
          Salary format=comma7., Job_Avg format=comma7.
      from (select Job_Title, 
                   avg(Salary) as Job_Avg format=comma7.
               from orion.Employee_payroll as p, 
                    orion.Employee_organization as o
               where p.Employee_ID=o.Employee_ID
                    and not Employee_Term_Date
                    and o.Department="Sales"
               group by Job_Title) as job,
           orion.Sales as emp
       where emp.Job_Title=job.Job_Title
             and Salary < Job_Avg*.95
       order by Job_Title, Last_Name;
quit;
title;

libname train "&path/train";

proc contents data=train.flightdelays;run;
proc print data=train.flightdelays (obs=100);
run;

proc sql;
title "Flight destinations and delays";
    create table delays as
    select destination,
			avg(delay) as average,
			max(delay) as max,
			sum(delay>0) as late,
			sum(delay<=0) as early 
		  from train.flightdelays
		  group by destination
          order by average;

	select destination,
	   average format=3.0 label="Average Delay",
	   max format=3.0 label="Maximum Delay",
	   late/(late+early) as prob format=5.2
	     label="Probability of Delay"
	from delays;
	
title;
quit;

/*Embed first step in an in-line query*/
proc sql;
title "Flight destinations and delays";
	select destination,
	   average format=3.0 label="Average Delay",
	   max format=3.0 label="Maximum Delay",
	   late/(late+early) as prob format=5.2
	     label="Probability of Delay"
	from (select destination,
			avg(delay) as average,
			max(delay) as max,
			sum(delay>0) as late,
			sum(delay<=0) as early 
		  from train.flightdelays
		  group by destination)
	order by average;
title;
quit;

/*Step 1*/
proc sql;
select distinct Employee_ID
   from orion.Order_Fact as o, 
        orion.Product_Dim as p
   where o.Product_ID=p.Product_ID
	    and year(Order_Date)=2003
	    and Product_Name contains
         'Expedition Zero' 
	    and Employee_ID ne 99999999;
quit;

/*Step 2*/
proc sql;
select Manager_ID 
   from orion.Employee_Organization as o,
      (select distinct Employee_ID
          from orion.Order_Fact as o, 
	          orion.Product_Dim as p
          where o.Product_ID=p.Product_ID
	       and year(Order_Date)=2003
	       and Product_Name 
               contains 'Expedition Zero' 
	       and Employee_ID ne 99999999) as ID
   where o.Employee_ID=ID.Employee_ID;
quit;

/*Step 3*/
proc sql;
select Employee_Name format=$25. as Name, City
   from orion.Employee_Addresses
   where Employee_ID in
       (select Manager_ID 
           from orion.Employee_Organization as o,
           (select distinct Employee_ID
               from orion.Order_Fact as o, 
	               orion.Product_Dim as p
               where o.Product_ID=p.Product_ID
               and year(Order_Date)=2003 
               and Product_Name contains 
                   'Expedition Zero'
               and Employee_ID ne 99999999) as ID
            where o.Employee_ID=ID.Employee_ID);
quit;

/*Multiway Join*/
proc sql;
   select distinct Employee_Name format=$25. as Name, City
      from orion.Order_Fact as of,  
           orion.Product_Dim as pd,
           orion.Employee_Organization as eo,
           orion.Employee_Addresses as ea
      where of.Product_ID=pd.Product_ID
            and of.Employee_ID=eo.Employee_ID
            and ea.Employee_ID=eo.Manager_ID 
            and Product_Name contains 'Expedition Zero'
            and year(Order_Date)=2003
            and eo.Employee_ID ne 99999999  
;
quit;

/*Query1-Identify Crews for Copenhagen (CPH) flight*/
proc sql;
  select empid
  	from train.flightschedule
	where date="04mar2013"d and destination="CPH";
quit;

/*query 2 –get the job categories and states, make query 1 a subquery */
proc sql;
   select substr(jobcode,1,2) as JobCategory,state
   from train.staffmaster as s,train.payrollmaster as p
   where s.empid=p.empid and s.empid in 
   		(select empid
  	     from train.flightschedule
	     where date="04mar2013"d and destination="CPH");
quit;

/*Find supervisors*/
proc contents data=train.supervisors;run;
proc print data=train.supervisors;run;

/*make query 2 an inline view in query 3*/
proc sql;
	select empid  
    from train.supervisors as m,
	(select substr(jobcode,1,2) as JobCategory,state
   from train.staffmaster as s,train.payrollmaster as p
   where s.empid=p.empid and s.empid in 
   		(select empid
  	     from train.flightschedule
	     where date="04mar2013"d and destination="CPH")) as c
		 where m.jobcategory=c.jobcategory
		     and
	     m.state=c.state;
quit;

/*make query 3 a subquery to query 4 to get names*/
proc sql; 
  select firstname,lastname
  from train.staffmaster
     where empid in
(select empid  
    from train.supervisors as m,
	(select substr(jobcode,1,2) as JobCategory,state
   from train.staffmaster as s,train.payrollmaster as p
   where s.empid=p.empid and s.empid in 
   		(select empid
  	     from train.flightschedule
	     where date="04mar2013"d and destination="CPH")) as c
		 where m.jobcategory=c.jobcategory
		     and
	     m.state=c.state);
quit;

/*use traditional sas programming*/
/*find the crew*/
proc sort data=train.flightschedule (drop=flightnumber)
    out=crew (keep=empid);
	where destination="CPH" and
	      date="04mar2013"d;
by empid;
run;

/*find the state and job code for crew*/
proc sort data=train.payrollmaster
     (keep=empid jobcode) out=payroll;
by empid;
run;
proc sort data=train.staffmaster
      (keep=empid state firstname lastname)
	  out=staff;
by empid;
run;
data st_cat(keep=state jobcategory);
  merge crew (in=one)
        staff
		payroll;
  by empid;
  if one;
  jobcategory=substr(jobcode,1,2);
run;

/* find supervisor id*/
proc sort data=st_cat;
by jobcategory state;
run;
proc sort data=train.supervisors
    out=superv;
by jobcategory state;
run;
data super (keep=empid);
	merge st_cat(in=s)
	      superv;
	by jobcategory state;
	if s;
run;

/*find names of supervisors*/
proc sort data=super;
by empid;
run;
data names (drop=empid);
merge super (in=super)
	  staff (keep=empid firstname lastname);
by empid;
if super;
run;
proc print data=names noobs uniform;
run;

/*same problem using a multiway join*/
proc sql;
  select distinct e.firstname,e.lastname
  from train.flightschedule as a,
       train.staffmaster as b,
	   train.payrollmaster as c,
	   train.supervisors as d,
	   train.staffmaster as e
	   where a.date="04mar2013"d and
	   a.destination="CPH" and
	   a.empid=b.empid and
	   a.empid=c.empid and
	   d.jobcategory=substr(c.jobcode,1,2) and
	   d.state=b.state and
	   d.empid=e.empid;
quit;

