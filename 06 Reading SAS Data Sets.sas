libname orion '/courses/d649d56dba27fe300/STA5066' access=readonly;
title "Equality comparison operator";
data sub1;
  set orion.sales;
  where Gender = 'M';/*eq*/
run;

proc print data=sub1(obs=5) noobs;
var last_name first_name gender;
run;

title;

title "Non-equality operator ";
data sub1;
  set orion.sales;
  where Salary ne .;/* ^= */
run;

proc print data=sub1;
 var last_name first_name salary;
run;

title;

title "Greater than comparison operator";
data sub1;
  set orion.sales;
  where Salary > 84260;
run;

proc print data=sub1;
  var last_name first_name salary;
run;

title;

title "Greater than or equal to operator";
data sub1;
  set orion.sales;
  where Salary >= 84260;
run;

proc print data=sub1;
  var last_name first_name salary;
run;

title;

title "The in operator with character variable";
data sub1;
  set orion.sales;
  where Country in ('AU','US');
run;

proc print data=sub1;
 var last_name first_name country;
run;

title;

title "The in operator with numeric variable";
data sub1;
  set orion.sales;
where employee_id in (120102,120142,121025,121145);
run;

proc print data=sub1;
 var last_name first_name employee_id ;
run;

title;

title "Arithmetic to find all employees with monthly salary < 2200";

data sub1;
  set orion.sales;
    where Salary / 12 < 2200;
run;

proc print data=sub1;
  var last_name first_name salary;
run;

title;

title "Arithmetic to find all employees with monthly salary plus 10% greater than 7500";

data sub1;
  set orion.sales;
  where (Salary / 12) * 1.10 > 7500;
run;

proc print data=work.sub1;
  var last_name first_name salary;
run;

title;

title "Logical AND operator";

data sub1;
  set orion.sales;
	/* parens add readability*/
  where (Gender ne 'M') and (Salary >=50000);
run;

proc print data=sub1;
  var last_name first_name gender salary;
run;

title;

title "Logical OR operator";

data sub1;
  set orion.sales;
	/* parens add readability*/
  where (Gender ne 'M') or (Salary >= 50000);
run;

proc print data=sub1;
  var last_name first_name gender salary;
run;

title;

title "Logical NOT operator";

data sub1;
  set orion.sales;
	/* parens add readability*/
  where Country not in ('AU', 'US');
run;

/*note we get no observations*/
proc print data=sub1;
  var last_name first_name country;
run;

title;

title "Logical operators, a more complex example";

data sub1;
  set orion.sales;
	/* parens add readability*/
  where (  (country ne 'US') and (salary ge 50000)  ) or 
        (  (country ='US') and (salary gt 75000)  );


run;

proc print data=work.sub1;
  var last_name first_name country salary;
run;

title;

data temp;
   input X;
   if X =3 or X=4 then Match = 'Yes';
   else Match = 'No';
datalines;
3
7
.
;
title "Listing of Results";
proc print data=temp noobs;
run;
title;

data temp;
   input X;
   if X in (3,4) then Match = 'Yes';
   else Match = 'No';
datalines;
3
7
.
;
title "Listing of Results";
proc print data=temp noobs;
run;
title;

data tmp;
  input x y;
  equal=(x=y);
datalines;
  7 7
  7 6
  5 5
  3 4
;
proc print data=tmp;
run;

proc means data=orion.sales;
var salary;
run;

data sub1;
  set orion.sales;
	where salary between 30000 and 40000;
run;

proc print data=sub1;
run;

title "List of salaries excluding those between $40,000 and $50,000";

data sub2;
  set orion.sales;
	where salary not between 40000 and 50000;
run;

proc print data=sub2;
run;

title;

title "List of last names that contain the string 'an' ";

data sub1;
  set orion.sales;
	where last_name contains 'an';
run;

proc print data=sub1;
run;

title;

title "List all last names that begin with 'M'";
data sub1;
  set orion.sales;
	where last_name like 'M%';
run;

proc print data=sub1;
run;
title;

title "Names that contain 'i' followed by any character followed by 'a' ";
data sub2;
  set orion.sales;
	where last_name like '%i_a%';
run;

proc print data=sub2;
run;
title;

title "Contents before the drop statement"; 
proc contents data=orion.sales;
run;

data subset;
  set orion.sales;
  drop Employee_ID Gender   
     Country Birth_Date;
run;

title "Contents after the drop statement";
proc contents data=subset;
run;

title;

title "Contents before the keep statement"; 
proc contents data=orion.sales;
run;

data subset;
  set orion.sales;
  keep First_Name Last_Name 
       Salary Job_Title 
       Hire_Date;
run;

title "Contents after the keep statement";
proc contents data=subset;
run;

title;

title "Contents of original dataset";
proc contents data=orion.sales;

data subset1;
   set orion.sales;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
run;

title "Contents of new dataset with labels added";
proc contents data=work.subset1;
run;

title "Sales dataset with labels added";
proc print data=work.subset1(obs=17) label;/*label option*/
run;

title;

proc contents data=orion.labsub2;
run;


data work.subset1;
   set orion.sales;
run;

proc contents data=subset1 position details;   
run;

data work.subset1;
   set orion.sales;
	 where country="AU";
run;
proc print data=subset1 (obs=20);run;

/***** add subset columns *****/
data work.subset1;
   set orion.sales;
	 where country="AU";
	 keep first_name last_name salary hire_date;
run;
proc print data=subset1 (obs=20);run;

data work.subset1;
   set orion.sales;
	 where country="AU";
	 keep first_name last_name job_title salary hire_date;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Salary comma8. Hire_Date ddmmyy10.;
run;

title "Contents with labels and formats added, comma format for salary";
proc contents data=work.subset1;
run;
title;

proc print data=work.subset1 label;
  var salary hire_date;
run;
title;
/*Why do we get an error?*/

data nh1;
set orion.nhanes1_5066;
run;

proc contents data=nh1;
run;

data nh1;
	set orion.nhanes1_5066;
	where gender="Male";
run;

proc contents data=nh1;
run;

data nh1;
	set orion.nhanes1_5066;
	where (gender="Male") and 
	(age ge 40 and age le 49);
run;

proc contents data=nh1;
run;

data nh1;
	set orion.nanesh1_5066;
	where gender="Male" and age between 40 and 49;
run;

proc contents data=nh1;
run;

data nh1;
	set orion.nhanes1_5066;
	where gender="Male" and age ge 40 and age le 49;
	drop gender;
run;

proc contents data=nh1;
run;

data nh1;
	set orion.nhanes1_5066;
	where gender="Male" and age ge 40 and age le 49;
	drop gender;
	keep age sbp dbp bmi vital_status;
run;

proc contents data=nh1;
run;

data nh1;
	set orion.nhanes1_5066;
	where gender="Male" and age ge 40 and age le 49;
	drop gender;
	keep age sbp dbp bmi vital_status;
	format bmi 4.1;
run;

proc print data=nh1 (obs=10) noobs;
var bmi;
run;

data nh1;
	set orion.nhanes1_5066;
	where gender="Male" and age ge 40 and age le 49;
	drop gender;
	keep age sbp dbp bmi vital_status;
	format bmi 4.1;
	label 	age="Age (yrs)"
		sbp="Systolic Blood Pressure (mmHg)"
		dbp="Diastolic Blood Pressure (mmHg)"
		bmi="Body mass index (kg/m^2)";
run;

proc contents data=nh1;
run;

proc print data=nh1 (obs=5) noobs label;
run;

data nh1;
	set orion.nhanes1_5066;
	where gender="Male" and age ge 40 and age le 49;
	drop gender;
	keep age sbp dbp bmi vital_status;
	format bmi 4.1;
	label age="Age (yrs)"
		sbp="Systolic Blood Pressure (mmHg)"
		dbp="Diastolic Blood Pressure (mmHg)"
		bmi="Body mass index (kg/m^2)";
	rename 	age=age_yrs
			sbp=bp_sys
			dbp=bp_dias
			bmi=bodymassindex;
run;

proc contents data=nh1;
run;

proc print data=nh1 label;
run;











