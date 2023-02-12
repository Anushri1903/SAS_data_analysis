data arithmetic;
  one=1;                                                /*assignment*/
  two=1+one;                                        /*addition and variable on right hand side*/
  three=two*one+1;                              /*multiplication*/
  four=2**2;                                        /*exponentiation*/
  five=four+one;                                  /*variables on right hand side*/
  six=three*3-3;                                  /*subtraction*/
  seven=2**two+three;
  eight=two**2+2**2;                         /*note order*/
  nine=(three**3)-(9+3**2);               /*parens dictate order*/
  minus9=-nine;                                /*negative prefix*/
  ten=(two**2+1)*2;                        /*Parens take precedence*/
                                                     /*implied output*/
run; 

title "Arthmetic operators";
proc print data=arithmetic;
run;

title;


libname body '/courses/d649d56dba27fe300/STA5066';
data wtht;
  set body.bodyfat(keep=height weight);
	where (weight ne .) and (height ne .);
	rename weight=wt_lbs height=ht_in;
run;
proc print data=wtht(obs=15) noobs;
run;
proc means data=wtht;run;

/*convert units, weight and height*/
data wtht;
	set wtht;
	wt_kg=wt_lbs/2.20462;
	ht_m=ht_in/39.3701;
	bmi=wt_kg/ht_m**2;
run;
proc print data=wtht (obs=9) noobs;run;
proc means data=wtht;run;

data wtht;
	set wtht(drop=wt_kg ht_m);
	bmi2=wt_lbs/ht_in**2*703.07;
run;
proc print data=wtht (obs=9) noobs;run;
proc means data=wtht;run;

title "Random sample from around 30,000";
data chol_si;
input seqn chol_si @@;
datalines;
285 4.34 332 5.69 334 5.79 381 4.68 551 6.72 659 4.58 665 5.87 776 5.59 
857 4.34 885 4.73 916 3.57 964 4.34 978 3.85 1132 6.47 1141 6.10 1158 3.88 
1205 3.72 1253 6.54 1288 4.71 1356 6.15 1467 5.33 1589 5.17 1767 4.71 
1783 5.12 1858 7.11 1954 3.39 2073 6.21 2216 4.60 2262 3.59 2500 3.88 
2625 5.51 2669 5.33 2712 4.19 2771 5.30 2977 6.21 3289 4.24 3452 3.65 
3480 3.26 3798 5.97 3933 3.39 4096 5.07 4421 3.34 4434 4.91 4491 5.46 
4539 5.09 4556 5.77 4698 4.86 4703 3.88 4803 5.17 4902 3.62 5157 4.68 
5275 5.64 5368 2.82 5497 3.65 5543 6.80 5683 4.11 5758 4.99 6108 4.09 
6148 5.53 6324 3.80 6351 4.40 6414 4.76 6435 5.64 6508 3.72 6617 6.34 
6669 3.47 6936 3.57 7136 4.60 7173 4.40 7186 6.05 7284 4.97 7635 6.21 
7707 4.24 7759 6.36 7851 4.40 7890 4.50 7934 4.47 8159 4.32 8194 6.15 
8342 6.18 8436 4.97 8487 6.44 8519 4.24 8708 5.02 8791 4.14 8860 4.50 
8865 7.53 8911 4.81 8973 4.32 8985 3.98 9028 3.10 9148 4.14 9293 5.22 
9333 3.93 9539 5.72 9551 4.55 9801 3.28 
;
run;
proc print; run;
title;

data newchol;
  set chol_si;
	newchol=chol_si*38.67;
run;
proc print data=newchol;
run;

proc freq data=body.smoking;
tables exsmoker currentsmoker exsmoker*currentsmoker/norow nocol nopercent;
run; 

proc format;
   value smk 1="Never" 2="Past" 3="Current";
run;
data smoking2;
	set body.smoking(keep=exsmoker currentsmoker);
	smokcat=(not exsmoker and not currentsmoker)+
					2*(exsmoker and not currentsmoker)+
					3*currentsmoker;
run;
proc freq data=smoking2;
format smokcat smk.;
tables exsmoker*currentsmoker smokcat/norow nocol nopercent;
run;

/*SAS Functions*/
data tmp;
input x y @@;
datalines;
1 2 3 . . 4 5 6
;
run;
proc print data=tmp;
run; 
data tmp;
 set tmp;
 s1=x+y;
 s2=sum(x,y);
run;
proc print data=tmp;
run; 

/*
  subset of systolic blood pressures taken at a clinic
  sbp1 is taken by a nurse at admission
  sbp2 is taken by the physician at beginning of exam
  sbp3 is taken by the physician at end of exam (roughly 1 hour)

  The usual procedure is to characterize a patient's pressure
  by the mean of all AVAILABLE pressures
*/
data bp;
  input sbp1 sbp2 sbp3 @@;
  mnsbp=(sbp1+sbp2+sbp3)/3;/*average of 3 measurements*/ 
  datalines;
 120     124     120   136     170     140   140     .       135
 130     118     116    164     175     160     .     128     122
 136     110     120   120     118     126   142     140     120
 122     122     116   124     114       .   144     150       .
 130     130     124   136     136     134   116     .       100
 122     138     120   118     108      98   144     140     160
 152     148     138   104     118     108   126     132     130
;
title "Calculated average of three measurements";
proc print data=bp;
run;
title;

data bp;
  input sbp1 sbp2 sbp3 @@;
 mnsbp=mean(sbp1,sbp2,sbp3);/*average of 3 measurements*/   
datalines;
 120     124     120   136     170     140   140     .       135
 130     118     116    164     175     160     .     128     122
 136     110     120   120     118     126   142     140     120
 122     122     116   124     114       .   144     150       .
 130     130     124   136     136     134   116     .       100
 122     138     120   118     108      98   144     140     160
 152     148     138   104     118     108   126     132     130
;

title "Mean function to find average all available from three measurements";
proc print data=bp;run;title;

data total;
  input source1 source2 @@;
  total=sum(source1,source2);
datalines;
108255    10853  87975     .  26600      2780
 .          25438  26190     15472  26480      .
 32040     24217  26780     22778  28100      4859
 .     27427  30070     25562
;
proc print data=total noobs;
run;

data work.comp;
   set body.sales;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
run;
proc print data=comp;
run;

data somedates;
  infile datalines dlm=",";
	input date1 :date9. date2 :date9.;
	datalines;
18AUG1976,01JUL2003
11MAY1954,01JAN1981
21DEC1974,01MAY1999
23DEC1944,01JAN1974
01FEB1978,21JAN1953
23FEB1984,01AUG2006
15DEC1986,01OCT2006
20NOV1949,01NOV1979
23JUL1949,15NOV1978
17FEB1969,01JUL1990
;

title "somedates dateset, sas dates";
proc print data=somedates;
run;
title;

data somedates;
  infile datalines dlm=",";
	input date1 :date9. date2 :date9.;
	datalines;
18AUG1976,01JUL2003
11MAY1954,01JAN1981
21DEC1974,01MAY1999
23DEC1944,01JAN1974
01FEB1978,21JAN1953
23FEB1984,01AUG2006
15DEC1986,01OCT2006
20NOV1949,01NOV1979
23JUL1949,15NOV1978
17FEB1969,01JUL1990
;

title "somedates dateset, sas dates";
proc print data=somedates;
format date1 date2 date9.;
run;

title;

data somedates;
  infile datalines dlm=",";
  input date1 :date9. date2 :date9.;
	dayofmonth=day(date1);
  datalines;
18AUG1976,01JUL2003
11MAY1954,01JAN1981
21DEC1974,01MAY1999
23DEC1944,01JAN1974
01FEB1978,21JAN1953
23FEB1984,01AUG2006
15DEC1986,01OCT2006
20NOV1949,01NOV1979
23JUL1949,15NOV1978
17FEB1969,01JUL1990
;
run;

title "Day function, somedates";
proc print data=somedates;
  var date1 dayofmonth;
format date1 date9.;
run;

title;

data somedates;
  infile datalines dlm=",";
  input date1 :date9. date2 :date9.;
	month=month(date1);
  datalines;
18AUG1976,01JUL2003
11MAY1954,01JAN1981
21DEC1974,01MAY1999
23DEC1944,01JAN1974
01FEB1978,21JAN1953
23FEB1984,01AUG2006
15DEC1986,01OCT2006
20NOV1949,01NOV1979
23JUL1949,15NOV1978
17FEB1969,01JUL1990
;
run;

title "Month function, somedates";
proc print data=somedates;
  var date1 month;
	format date1 date9.;
run;

title;

data somedates;
  infile datalines dlm=",";
  input date1 :date9. date2 :date9.;
  year=year(date1);
  datalines;
18AUG1976,01JUL2003
11MAY1954,01JAN1981
21DEC1974,01MAY1999
23DEC1944,01JAN1974
01FEB1978,21JAN1953
23FEB1984,01AUG2006
15DEC1986,01OCT2006
20NOV1949,01NOV1979
23JUL1949,15NOV1978
17FEB1969,01JUL1990
;
run;

title "year function, somedates";
proc print data=somedates;
  var date1 year;
	format date1 date9.;
run;

title;

data mdy;
  input month day year;
	date=mdy(month,day,year);
	datalines;
   8      18    1976
   5      11    1954
  12      21    1974
  12      23    1944
   2       1    1978
   2      23    1984
  12      15    1986
  11      20    1949
   7      23    1949
   2      17    1969
;
run;

title "Using the mdy function";
proc print data=mdy;
format date date10.;
run;

data mdy;
  input month year;
	date=mdy(month,15,year);
	datalines;
   8          1976
   5          1954
  12          1974
  12          1944
   2          1978
   2          1984
  12          1986
  11          1949
   7          1949
   2          1969
;
run;

title "Using the mdy function and 15 for missing day";
proc print data=mdy;
format date date9.;
run;

title;

data work.comp;
   set body.sales;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
   drop Gender Salary Job_Title 
        Country Birth_Date Hire_Date;
run;
proc print data=work.comp;
run;

data work.comp(drop=Salary Hire_Date);
   set body.sales(keep=Employee_ID First_Name 
                        Last_Name Salary Hire_Date);
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
run;


data work.bonus;
   set body.sales;
   if Country='US' then Bonus=500;
   else if Country='AU' then Bonus=300;
run;
proc print data=work.bonus;
   var First_Name Last_Name Country Bonus;
run;

data work.bonus;
   set body.sales;
   if Country='US' then Bonus=500;
   else Bonus=300;
run;

data work.bonus;
   set body.sales;
   if Country='US' then do;
      Bonus=500;
	 Freq='Once a Year';
   end;
   else if Country='AU' then do;
      Bonus=300;
	 Freq='Twice a Year';
   end;
run;
proc print data=work.bonus;
   var First_Name Last_Name 
       Country Bonus Freq;
run;

data work.bonus;
   set body.sales;
   length Freq $ 12;
   if Country='US' then do;
      Bonus=500;
	 Freq='Once a Year';
   end;
   else if Country='AU' then do;
      Bonus=300;
	 Freq='Twice a Year';
   end;
run;
proc print data=work.bonus;
   var First_Name Last_Name 
       Country Bonus Freq;
run;

data work.bonus;
   set body.sales;
   length Freq $ 12;
   if Country='US' then do;
      Bonus=500;
	 Freq='Once a Year';
   end;
   else do;
      Bonus=300;
	 Freq='Twice a Year';
   end;
run;

data work.december;
   set body.sales;
   where Country='AU';
   BonusMonth=month(Hire_Date);
   if BonusMonth=12;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
run;
proc print data=december;
run;

data body;
    set body.exam (keep=seqn bm:);
run;
proc contents data=body;
run;

