libname STA5066 '/courses/d649d56dba27fe300/STA5066';

/*01 Intro*/
proc contents data=STA5066.chd2018;
run;

proc sql;
	select gender, age
    from STA5066.chd2018(obs=15)
	;
quit;

proc sql outobs=15;
	select gender,age
        from STA5066.chd2018
	;
quit;

proc sql;
	select distinct gender
	from STA5066.chd2018
	;
quit;

proc sql outobs=20;
	select  age, sbp1, chol
	 from STA5066.chd2018
	 where gender ="Female"
	;
quit;

proc sql outobs=30;
	/* the where clause and the order by clause*/
	select gender,age,sbp1,chol
	 from STA5066.chd2018
	 where gender ="Female"
	 order by age desc
	;
quit;

proc sql outobs=50;
title "Males on the chd2018 data set";
	select age label="Age at Start",
         sbp1 as systolic label="Systolic Blood Pressure",  
         chol as cholesterol label ="Serum Cholesterol mg/dL"
	from STA5066.chd2018
    where gender="Male"
	order by age desc
	;
quit;
title;

/* summary functions*/
proc sql;
/*with a single variable, the column is summarized across all rows*/	
	select count(*) as numobs
	from STA5066.chd2018
	;
quit;

proc sql outobs=25;
	select sbp1,sbp2,sbp3,mean(sbp1,sbp2,sbp3) as mnsbp
	from STA5066.chd2018
	;
quit;

proc sql;
	create table females as
	select age,
           mean(sbp1,sbp2,sbp3) as mnsbp,
           chol,
		   gender
	from STA5066.chd2018
	where gender="Female"
	order by age desc;
	;
	select distinct(gender) 
	from females
	;
quit;

proc contents data=females;
run;

/*02 Create Analytic Data Set*/
proc contents data=STA5066.nhanes1_5066;
run;

proc sql outobs=10;
   select *
   from STA5066.nhanes1_5066
	;
quit;

proc freq data=STA5066.nhanes1_5066 nlevels;
tables _all_/noprint;
run;

proc freq data=STA5066.nhanes1_5066;
tables gender activ vital_status race smoking_status diabetic/norow nocol nopercent nocum;
run;

proc sql;
    select  gender,
            count(*) as numobs
        from STA5066.nhanes1_5066
        group by gender
        ;
    select distinct activ,
                count(*) as numobs
        from STA5066.nhanes1_5066
        group by activ
        ;
    select vital_status,
            count(*) 
        from STA5066.nhanes1_5066
        group by vital_status
        ;
    select distinct race,
                    count(*)
        from STA5066.nhanes1_5066
        group by race
        ;   
    select distinct smoking_status,
                    count(*)
        from STA5066.nhanes1_5066
        group by smoking_status
        ;    
    select distinct  diabetic,
                    count(*)
        from STA5066.nhanes1_5066
        group by diabetic
        ;                    
 quit;
 
 proc sql outobs=15;
    select gender,
            (gender="Male") as male
    from STA5066.nhanes1_5066
    ;
quit;     

proc sql outobs=25;
    select (gender="Male") as male,
        case(activ)
            when "Quite Inactive" then 1
            when "Moderately Active" then 2
            when "Very Active" then 3
            else .  
        end as activity label="Activity Level",
             (smoking_status="Current Smoker") as current_smoker,
             (race="Black") as black,
             (vital_status="Dead" ) as dead
      from STA5066.nhanes1_5066
    ;
quit; 

proc sql outobs=100;
    select  gender="Male" as male,age,bmi,chol,dbp,sbp,
            case(activ)
                 when "Quite Inactive" then 1
                 when "Moderately Active" then 2
                 when "Very Active" then 3
                 else .  
             end as activity label="Activity Level",
             smoking_status="Current Smoker" as current_smk,
             vital_status="Dead" as dead,
             diabetic="Diabetic" as diabetic
    from STA5066.nhanes1_5066
    ;
quit;

proc sql;
    create table chd2018_a as
    select 
            gender="Male" as male,
            age,
            bmi label="Body Mass Index",
            chol as cholesterol label="Serum Cholesterol (mg/dL)",
            dbp as diastolic label="Diastolic BP (mmHg)",
            sbp as systolic label="Systolic BP (mmHg)",
            case(activ)
                 when "Quite Inactive" then 1
                 when "Moderately Active" then 2
                 when "Very Active" then 3
                 else .  
             end as activity label="Activity Level",
             smoking_status="Current Smoker" as current_smk label="Currently Smokes Cigarettes",
             vital_status="Dead" as dead,
             diabetic="Diabetic" as diabetic
    from STA5066.nhanes1_5066
    ;
quit;
proc contents data=chd2018_a;
run;
proc print data=chd2018_a(obs=25);
run;

/*03 Summary*/
proc sql noprint;
   select mean(sbp1) into : mnsbp
   from STA5066.chd2018
   ;
quit;
%put Mean SBP: &mnsbp;

data tmp1;
 input id sbp;
datalines;
  5 122
  3 124
  4 132
  2 130
  1 126
  ;
run;
proc print data=tmp1;
run;

data tmp2;
 input id1 chol;
datalines;
  1 220
  3 225
  4 215
  2 228
  5 218
  ;
run;
proc print data=tmp2;
run;

proc sql;
  select id,sbp,chol
  from tmp1 a,tmp2 b/*inner join with table aliases*/
  where a.id=b.id1
  order by id
  ;
quit;




