/*01 Intro to SQL Joins*/
data tmp1 tmp2;
		call streaminit(54321);
   do id=1 to 12;
		chol=int(rand("Normal",240,40));
		sbp=int(rand("Normal",120,20));
		if id<6 then output tmp1;
		else output tmp2;
	end;
run;

title "tmp1";
proc print data=tmp1 noobs;run;
title "tmp2";
run;
proc print data=tmp2 noobs;run;
title "tmp1 inner join tmp2";
run;
title;

proc sql;
select * from tmp1
union
select * from tmp2
;
quit;

title "Concatenation, data step";
data tot1;
	set tmp1 tmp2;
run;
proc print data=tot1 noobs;run;
title;

data tmp1(keep=id chol sbp) tmp2(keep=id weight height);
		call streaminit(54321);
   do id=1,7,4,2,6;
		chol=int(rand("Normal",240,40));
		sbp=int(rand("Normal",120,20));
		output tmp1;
  	end;
   do id=2,1,5,7,3;
		height=round(rand("Normal",69,5),.25);
		weight=round(rand("Normal",160,10),.5);
		output tmp2;
	end;
run;
title "tmp1";
proc print data=tmp1 noobs;run;
title "tmp2";
proc print data=tmp2 noobs;run;


title "tmp1 inner join tmp2";
proc sql;
select * from tmp1,tmp2
where tmp1.id=tmp2.id
;
quit;

proc sql;
create table tmp3 as
select * from tmp1,tmp2
where tmp1.id=tmp2.id
;
select * from tmp3
;
quit;

proc sort data=tmp1;by id;run;
proc sort data=tmp2;by id;run;
data tot1;
	merge tmp1 tmp2;
	by id;
run;

/*02 Inner Joins*/
data tmp1(keep=id chol sbp) tmp2(keep=id weight height);
		call streaminit(54321);
   do id=1,7,4,2,6;
		chol=int(rand("Normal",240,40));
		sbp=int(rand("Normal",120,20));
		output tmp1;
  	end;
   do id=2,1,5,7,3;
		height=round(rand("Normal",69,5),.25);
		weight=round(rand("Normal",160,10),.5);
		output tmp2;
	end;
run;
title "tmp1";
proc print data=tmp1 noobs;run;
title "tmp2";
proc print data=tmp2 noobs;run;

title "Cartesian Product Join";
proc sql;
select * from tmp1,tmp2
;
quit;
title;

title "Inner Join with WHERE clause";
proc sql;
select * from tmp1,tmp2
where tmp1.id=tmp2.id
;
quit;
title;

title "Inner Join with WHERE clause";
title2 "And conditions other than join condition";
proc sql;
select * from tmp1,tmp2
where tmp1.id=tmp2.id and
	weight<180  
;
quit;
title;

data tmp1(keep=id chol sbp) tmp2(keep=id weight height chol);
		call streaminit(54321);
   do id=1,7,4,2,6;
		chol=int(rand("Normal",240,40));
		sbp=int(rand("Normal",120,20));
		output tmp1;
  	end;
   do id=2,1,5,7,3;
		height=round(rand("Normal",69,5),.25);
		weight=round(rand("Normal",160,10),.5);
		chol=int(rand("Normal",240,40));
		output tmp2;
	end;
run;
title "tmp1";
proc print data=tmp1 noobs;run;
title "tmp2";
proc print data=tmp2 noobs;run;

proc sql;
	select *
	from tmp1 as one,tmp2 as two
	where one.id=two.id
	;
quit;

/*specify which table to take chol from*/
proc sql;
	select one.id,one.chol,height,weight,sbp
	from tmp1 as one,tmp2 as two
	where one.id=two.id
	;
quit;

/*Use a DATA step option*/
proc sql;
	select one.id, chol,height,weight,sbp
	from tmp1 as one,tmp2(drop=chol) as two
	where one.id=two.id
	;
quit;

data tmp1(keep=id chol sbp) tmp2(keep=id weight height chol);
		call streaminit(54321);
   do id=1,7,4,2,6;
		chol=int(rand("Normal",240,40));
		sbp=int(rand("Normal",120,20));
		if id=2 then chol=.;
		output tmp1;
  	end;
   do id=2,1,5,7,3;
		height=round(rand("Normal",69,5),.25);
		weight=round(rand("Normal",160,10),.5);
		chol=int(rand("Normal",240,40));
		output tmp2;
	end;
run;
title "tmp1";
proc print data=tmp1 noobs;run;
title "tmp2";
proc print data=tmp2 noobs;run;

/*the coalesce function*/
data t;
   input x1 x2 x3 @@;
   x=coalesce(x1,x2,x3);
datalines;
1 2 3 . 2 3 . . 3
;
run;
proc print data=t noobs;run;

proc sql;
	select one.id, coalesce(one.chol,two.chol) ,
              height,weight,sbp
	from tmp1 as one,tmp2 as two
	where one.id=two.id
	;
quit;

%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

proc sql;
title "Australian Employees' Birth Months"; 
select Employee_Name as Name format=$25., 
                    City format=$25.,
       month(Birth_Date) 'Birth Month' format=3.
   from orion.Employee_Payroll,
        orion.Employee_Addresses
   where Employee_Payroll.Employee_ID=
         Employee_Addresses.Employee_ID 
         and Country='AU'
   order by 3,City, Employee_Name;
quit;
title;

libname nhanes3 "&path/nhanes3";

proc sql;
  create table analysis as
  select * from
  nhanes3.adultdemographics as a, 
  nhanes3.examsub2 as e, 
  nhanes3.labsub2 as l,
  nhanes3.mortsub2 as m
  where a.seqn=e.seqn and e.seqn=l.seqn and
        l.seqn=m.seqn;
quit;
proc means data=analysis;
run; 

proc sql;
title "Australian Employees' Birth Months"; 
select Employee_Name as Name format=$25.,
       City format=$25.,
       month(Birth_Date) 'Birth Month' format=3.
   from orion.Employee_Payroll
        inner join
        orion.Employee_Addresses
        on Employee_Payroll.Employee_ID=
           Employee_Addresses.Employee_ID
   where Country='AU'
   order by 3,City, Employee_Name;
quit;

libname train "&path/train";

proc sql;
title "Employee Names and Job Codes";
  	select s.empid,lastname,firstname,jobcode
	    from train.staffmaster as s,
	     train.payrollmaster as p
    where s.empid=p.empid;
title;

proc sql;
title "New York Employees";
  	select substr(firstname,1,1)||"."|| lastname
	       as name,
		   jobcode,
		   int((today()-dateofbirth)/365.25) as age 
	from train.staffmaster as s,
	     train.payrollmaster as p
    where s.empid=p.empid
			and state="NY"
	order by 2,3;
title;
quit; 

proc sql;
title "Average age of NY Employees";
	select jobcode,
	       count(p.empid) as Employees,
		   avg(int((today()-dateofbirth)/365.25)) 
		       format 4.1 as AvgAge
		   from train.payrollmaster as p,
		        train.staffmaster as s
		   where p.empid=s.empid
		         and state="NY"
		   group by jobcode
		   order by jobcode;
title;
quit;

proc sql;
title "Australian Employees' Birth Months"; 
select Employee_Name as Name format=$25.,
       City format=$25.,
       month(Birth_Date) 'Birth Month' format=3.
   from orion.Employee_Payroll
        inner join
        orion.Employee_Addresses
        on Employee_Payroll.Employee_ID=
           Employee_Addresses.Employee_ID
   where Country='AU'
   order by 3,City, Employee_Name;
quit;

proc sql;
title "Australian Employees' Birth Months"; 
create table aussies as
select Employee_Name as Name format=$25.,
       City format=$25.,
       month(Birth_Date) 'Birth Month' format=3.
   from orion.Employee_Payroll
        inner join
        orion.Employee_Addresses
        on Employee_Payroll.Employee_ID=
           Employee_Addresses.Employee_ID
   where Country='AU'
   order by 3,City, Employee_Name;
quit;
proc print data=aussies (obs=15);run;

libname nh9Mort "&path/nhanes1999/mortality";
libname nh9ques "&path/nhanes1999/questionnaire";
libname nh9lab "&path/nhanes1999/lab";
libname nh9exam "&path/nhanes1999/exam";
libname nh9demo "&path/nhanes1999/demographics";

libname nh9 (nh9demo nh9exam nh9lab nh9mort nh9ques);

proc contents data=nh9.mortality;
proc contents data=nh9.bloodpressure;
proc contents data=nh9.demographics;
proc contents data=nh9.bodymeasurements;
proc contents data=nh9.cholesterolhdl;
run;

proc sql inobs=100;
select mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4),BPXSar
from nh9.bloodpressure
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

proc means data=nh9.demographics;
var ri: seqn;
run;


proc sql;
	create table analysis as
	select	a.seqn,mortstat=1 as dead,permth_exm,
			mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4) as mnsbp,
			mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4) as mndbp,
			riagendr=1 as male,
			ridageyr as age,
			ridreth2 as race_ethn,
			lbdhdl as hdl,
			lbxtc as chol,
			bmxbmi as bmi
	from 	nh9.mortality(keep=seqn eligstat mortstat permth_exm) a,
			nh9.bloodpressure(keep=seqn bpxsy1-bpxsy4 BPXDI1-BPXDI4) b,
			nh9.demographics (keep=seqn ridageyr riagendr RIDRETH2) c,
			nh9.bodymeasurements(keep=seqn bmxbmi) d,
			nh9.cholesterolhdl(keep= seqn LBDHDL LBXTC) e
	where	eligstat eq 1 and
			a.seqn=b.seqn and
			b.seqn=c.seqn and
			c.seqn=d.seqn and
			d.seqn=e.seqn
	order by seqn
	;
quit;

proc sql;
	create table analysis as
	select	a.seqn,mortstat=1 as dead,
			mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4) as mnsbp,
			mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4) as mndbp,
			riagendr=1 as male,
			ridageyr as age,
			ridreth2 as race_ethn,
			lbdhdl as hdl,
			lbxtc as chol,
			bmxbmi as bmi
	from 	nh9.mortality(keep=seqn eligstat mortstat) as a 
				inner join
				nh9.bloodpressure(keep=seqn bpxsy1-bpxsy4 BPXDI1-BPXDI4) as b 
				on a.seqn=b.seqn
				inner join
			  nh9.demographics (keep=seqn ridageyr riagendr RIDRETH2) as c
				on a.seqn=c.seqn
				inner join
			  nh9.bodymeasurements(keep=seqn bmxbmi) as d 
				on a.seqn=d.seqn
				inner join
			  nh9.cholesterolhdl(keep= seqn LBDHDL LBXTC) as e
				on a.seqn=e.seqn
	      where	eligstat eq 1 
	order by seqn
	;
quit;
proc means data=analysis;
run;

/*03 Outer Joins*/
data tmp1(keep=id chol sbp) 
		 tmp2(keep=id weight height)
		 tmp3(keep=id weight height chol);
	 call streaminit(54321);
   do id=1,7,4,2,6;
		  chol=int(rand("Normal",240,40));
		  sbp=int(rand("Normal",120,20));
		  output tmp1;
  	end;
   do id=2,1,5,7,3;
		  height=round(rand("Normal",69,5),.25);
		  weight=round(rand("Normal",160,10),.5);
		  output tmp2;
	 end;
	 do id=2,1,5,7,3;
	 		height=round(rand("Normal",69,5),.25);
		  weight=round(rand("Normal",160,10),.5);
		  chol=int(rand("Normal",240,40));
		output tmp3;
	end;
run;
title "tmp1";proc print data=tmp1 noobs;run;
title "tmp2";proc print data=tmp2 noobs;run;
title "tmp3";proc print data=tmp3 noobs;run;
title;

proc sql;
select * from 
	tmp1 left join tmp2
	on tmp1.id=tmp2.id
;
quit;

proc sql;
select * from tmp1 right join tmp2
on tmp1.id=tmp2.id
;
quit;

proc sql;
select * 
from tmp1 full join tmp2 
	on tmp1.id=tmp2.id
;
quit;

proc sql;
select * 
from tmp1  left join tmp3
on tmp1.id=tmp3.id
;
quit;

proc sql;
select * 
from tmp1  right join tmp3
on tmp1.id=tmp3.id
;
quit;

proc sql;
select * from tmp1 full join tmp3 
	on tmp1.id=tmp3.id
;
quit;

proc sql;
select coalesce(a.id,b.id) as id,
      	coalesce(a.chol,b.chol) as chol,
	weight,height,sbp
from tmp1 as a full join 	tmp3 as b
	on tmp1.id=tmp3.id
;
quit;

proc sql;
   select Employee_payroll.Employee_ID, 
          Employee_Gender, Recipients
      from orion.Employee_payroll 
           left join 
           orion.Employee_donations
      on Employee_payroll.Employee_ID= 
         Employee_donations.Employee_ID
      where Marital_Status="M"
;
quit;

proc sql;
title "All March flights";
select m.date,
          m.flightnumber label="Left",
	   f.destination  label="Right",
	   delay label="Delay in Minutes"
from (train.marchflights as m
      left join 
	 train.flightdelays as f
	 on m.date=f.date
	 and m.flightnumber=f.flightnumber)
order by delay;
title;
quit;









