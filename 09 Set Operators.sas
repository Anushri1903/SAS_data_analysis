/*02 Except Operator*/
data t1(drop=i) t2(drop=i rename=(z=w));
call streaminit(54321);
do i= 1 to 3;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  output t2;
end;
do i= 4 to 6;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  x=int(rand("uniform")*6);
  z=int(rand("uniform")*6);
  output t2;
end;
run;

/*Add duplicate to each file*/
data t1;
	set t1 end=done;
	output;
	if done then output;
run;
data  t2;
	set  t2 end=done;
	output;
	if _n_=1 then output;
run;

title "t1";
proc sql;
select * from t1;
quit;
title "t2";
proc sql;
select * from  t2;
quit;
title;

proc sql;
   select *
      from t1 
   except 
   select *
      from t2
;
quit;

proc sql;
   select *
      from t1 
   except corr 
   select *
      from t2;
quit;

proc sql;
   select *
   	from t1
	except all
   select * 
    from t2
;
quit;

proc sql;
   select *
      from t1 
   except corr all
   select *
      from t2;
quit;

%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";
proc sql;
   select Employee_ID, Job_Title
      from orion.Employee_organization
   except all
   select Employee_ID, Job_Title
      from orion.Sales;
quit;

/*What's wrong?*/
proc sql;
   select count(*) 'No. Non-Sales Employees'
      from (select *
               from orion.Employee_organization
               except all
             select *
                from orion.Sales);
quit;

proc contents data=orion.Employee_organization position;
   title 'ORION.Employee_organization';
run;
title;

proc contents data=orion.Sales position;
   title 'ORION.Sales';
run;
title;

proc sql;
   select count(*) 'No. Non-Sales Employees'
      from (select *
               from orion.Employee_organization
            except all corr
            select * 
               from orion.Sales);
quit;
proc sql;
select *
               from orion.Employee_organization
            except all corr
            select * 
               from orion.Sales
               ;
               quit;

/*03 Intersect Operators*/
data t1(drop=i) t2(drop=i rename=(z=w));
call streaminit(13453);
do i= 1 to 3;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  output t2;
end;
do i= 4 to 6;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t2;
end;
run;
data t1;
	set t1 end=done;
	output;
	if done then output;
run;
data  t2;
	set  t2 end=done;
	output;
	if _n_=1 then output;
run;

title "t1";
proc print data=t1 noobs;run;
title "t2";
proc print data=t2 noobs;run;
title;

proc sql;
	select * 
		from t1
		intersect
	select *
	from t2
	;
quit;

proc sql;
	select * 
		from t1
		intersect corr
	select *
	from t2
	;
quit;

proc sql;
	select * 
		from t1
		intersect  all
	select *
	from t2
	;
quit;

proc sql;
   select Employee_ID
      from orion.Sales
      where year(Hire_date)=2004
         and scan(Job_Title,-1) in ("III","IV")
   intersect all
   select distinct Employee_ID
      from orion.Order_fact
      where year(Order_date) le 2005;
quit;

/*04 Union Operators*/
data t1(drop=i) t2(drop=i rename=(z=w));
call streaminit(13453);
do i= 1 to 3;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  output t2;
end;
do i= 4 to 6;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t2;
end;
run;
data t1;
	set t1 end=done;
	output;
	if done then output;
run;
data  t2;
	set  t2 end=done;
	output;
	if _n_=1 then output;
run;

title "t1";
proc print data=t1 noobs;run;
title "t2";
proc print data=t2 noobs;run;
title;

/*union*/
proc sql;
select * 
	from t1
union
select *
    from t2
;
quit;

/*reverse order of union*/
proc sql;
select *
	from t2
union
select *
	from t1
;
quit;

/*create a table from union*/
proc sql;
	create table tot1 as
	select * 
	from t1
union
select *
    from t2
;
quit;
proc print data=tot1;run;

/*the corr option*/
proc sql;
select *
	from t2
union corr
select *
	from t1
;
quit;

/*the all option*/
proc sql;
select *
	from t2
union all
select *
	from t1
;
quit;	

/*both corr and all*/
proc sql;
select *
	from t2
union corr all
select *
	from t1
;
quit;	

proc sql;
   select 'Total Paid to ALL Level I Staff',  
          sum(Salary) format=comma12.
	 from orion.Staff
	 where scan(Job_Title,-1, ' ')='I'
   union
   select 'Total Paid to ALL Level II Staff', 
          sum(Salary) format=comma12.
	 from orion.Staff
	 where scan(Job_Title,-1,' ')='II'
   union
   select 'Total Paid to ALL Level III Staff',
          sum(Salary) format=comma12.
      from orion.Staff
	 where scan(Job_Title,-1,'  ')='III';
quit;

/*05 Outer Union Operator*/
data t1(drop=i) t2(drop=i rename=(z=w));
call streaminit(13453);
do i= 1 to 3;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  output t2;
end;
do i= 4 to 6;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t1;
  x=int(rand("uniform")*5);
  z=int(rand("uniform")*5);
  output t2;
end;
run;
data t1;
	set t1 end=done;
	output;
	if done then output;
run;
data  t2;
	set  t2 end=done;
	output;
	if _n_=1 then output;
run;

title "t1";
proc print data=t1 noobs;run;
title "t2";
proc print data=t2 noobs;run;
title;

/*outer union*/
proc sql;
select * 
	from t1
outer union
select *
    from t2
;
quit;

/*outer union corr*/
proc sql;
select * 
	from t1
outer union corr
select *
    from t2
;
quit;

data tot;
	set t1 t2;
run;
title "Data step with set statement results";
proc print data=tot;run;

data work.Admin_I work.Admin_II work.Admin_III work.Admin_IV;
     set orion.staff(keep=Employee_ID Job_Title Salary 
                     where=(Job_Title contains 'Secretary' or 
                            Job_Title contains 'Office A'));
	 level=scan(Job_Title,-1,' ');
	 if level = 'I' then output work.Admin_I;
	 else if level='II' then output work.Admin_II;
	 else if level='III' then output work.Admin_III;
	 else output Admin_IV;
	 drop level;
run;

proc sql;
   create table admin_i as
     select Employee_ID ,Job_Title, Salary,scan(Job_Title,-1,' ') as level 
	 from orion.staff
         where 
(Job_Title contains 'Secretary' or 
         Job_Title contains 'Office A') and calculated level="I";
quit;

proc sql;
   select *
      from work.Admin_I
   outer union corr
   select *
      from work.Admin_II
   outer union corr
   select *
      from work.Admin_III
   outer union corr
   select *
      from work.Admin_IV;
quit;

data admin;
set admin_i admin_ii admin_iii admin_iv;
run;
proc print data=admin;
run;