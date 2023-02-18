%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname nhlab "&path/nhanes1999/lab";
libname nhmort "&path/nhanes1999/mortality";
libname nh9 (nhlab nhmort);
libname orion "&path/orion";
libname train "&path/train";
/*01 Intro to Subqueries*/
proc sql;
   create table bp2 as
	 select
	 mean(bpxsy1,bpxsy2,bpxsy3,bpxsy4) as mnsbp,
	 mean(bpxdi1,bpxdi2,bpxdi3,bpxdi4) as mndbp,
	 seqn
	 from nh9.bloodpressure
	 where calculated mnsbp ne . and calculated mndbp ne . and
				seqn in (select seqn from nh9.mortality
	 								where eligstat=1)
;
quit;
proc means data=bp2;
run;

/*02 Subqueries*/
proc sql;
select * 
   from orion.Staff
;
select avg(Salary) as MeanSalary
   from orion.Staff
;
select Job_Title, avg(Salary) as MeanSalary
   from orion.Staff
   group by Job_Title
   having avg(Salary) > 38041.51
;
quit;

/*03 Types of Subqueries*/
proc sql;
select Employee_ID, avg(Salary) as MeanSalary
   from orion.Employee_payroll
   where 'AU'=
	(select Country
    from orion.supervisors
    where Employee_payroll.Employee_ID=
          Supervisors.Employee_ID)
;
quit;

/*04 Noncorrelated Subqueries*/
proc sql;
   select count(distinct job_title) 
	 from orion.staff
;
proc freq data=orion.staff nlevels;
table job_title/noprint;
run;

proc sql;
   select Job_Title, avg(Salary) as MeanSalary
      from orion.Staff
      group by Job_Title
      having avg(Salary) > 
         ( select avg(Salary) as MeanSalary
             from orion.Staff  );
quit;

proc sql;
   select Employee_ID, 
          Employee_Name, City, 
          Country 
      from orion.Employee_Addresses
      where Employee_ID in
        (select Employee_ID
            from orion.Employee_Payroll
            where month(Birth_Date)=2)
      order by 1
;
quit;

/*single-value non correlated subquery*/
proc sql;
	select jobcode,
	avg(salary) as AvgSalary
	format=dollar11.2
	from train.payrollmaster
	group by jobcode
	having avg(salary) >
	(select avg(salary) from
	   train.payrollmaster)
;
quit;

/*multiple value noncorrelated subquery*/
proc sql;
	select empid,lastname,firstname,
		city,state
	from train.staffmaster
	where empid in
		(select empid 
         from train.payrollmaster
		 where month(dateofbirth)=12)
;
quit;

/* any keyword*/
proc sql;
	select empid,jobcode,dateofbirth
	from train.payrollmaster
	where jobcode in ("FA1","FA2")
	 and dateofbirth < any
	 (select dateofbirth
	  from train.payrollmaster
	  where jobcode="FA3")
;
quit;

/*all keyword*/
proc sql;
	select empid,jobcode,dateofbirth
	from train.payrollmaster
	where jobcode in ("FA1","FA2")
	 and dateofbirth < all
	 (select dateofbirth
	  from train.payrollmaster
	  where jobcode="FA3")
;
quit;

/*05 Correlated Subqueries*/
proc sql;  
   create table work.Supervisors as 
      select distinct Manager_Id as Employee_Id, 
             upcase(Country) as Country
         from orion.Employee_Addresses as e, 
              orion.Staff as s
         where e.Employee_Id=s.Manager_Id
           and e.employee_id in 
              (120103,120104,120260,120262,120668,120672,120679,120735,
               120736,120780,120782,120798,120800,121141,121143)
;
quit;
proc print data=supervisors;run;

proc sql;
  select Employee_ID,
         catx(' ',scan(Employee_Name,2),
         scan(Employee_Name,1)) as Manager_Name length=25
     from orion.Employee_Addresses
     where 'AU'=
       (select Country
           from Work.Supervisors
           where Employee_Addresses.Employee_ID=
								Supervisors.Employee_ID) ;
quit;

/*create table aliases*/
proc sql;
  select Employee_ID,
         catx(' ',scan(Employee_Name,2),
         scan(Employee_Name,1)) as Manager_Name length=25
     from orion.Employee_Addresses as e
     where 'AU'=
       (select Country
           from Work.Supervisors as s
           where e.Employee_ID=s.Employee_ID) 
;
quit;

proc sql;
  select Employee_ID,
         catx(' ',scan(Employee_Name,2),
         scan(Employee_Name,1)) as Manager_Name length=25
     from orion.Employee_Addresses e
     where 'AU'=
       (select Country
           from Work.Supervisors s
           where e.Employee_ID=s.Employee_ID) 
;
quit;

proc sql;
   select Employee_ID, Job_Title
      from orion.sales 
	 where not exists
	   (select *
            from orion.Order_Fact
            where Sales.Employee_ID=Order_Fact.Employee_ID);
quit;

proc sql;
	select lastname,firstname
	from train.staffmaster as a
	where "NA"=
		(select jobcategory
		 from train.supervisors as b
		 where a.empid=
		       b.empid);
quit;

proc sql;
	select lastname,firstname
	from train.flightattendants as a
	where not exists
	  (select * 
	   from train.flightschedule as s
	   where a.empid=
	   		   s.empid);
quit;




