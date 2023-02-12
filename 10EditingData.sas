/*Video 1, Slides 1-10 */
/*Raw data errors*/
data raw;
  infile datalines dlm=",";
	input name $ interest state $;
	datalines;
dan,25,FL
pete,200,MA
jane,300,GA
ellen,none,AZ
;
run;
proc print data=raw;
run;

/*Video 2, Slides 11-17*/
filename rawdata "/courses/d649d56dba27fe300/Data Sets/nonsales.csv";
/*version 1*/
data work.nonsales;
infile rawdata dlm=",";
   input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date date9. 
         Hire_Date date9.;
run;
proc print data=nonsales(obs=25);
run;

/*version 2*/
data work.nonsales;
infile rawdata dlm=",";
   input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date9. 
         Hire_Date :date9.;
run;
proc print data=nonsales(obs=25);
run;

/*version 3*/
data work.nonsales;
infile rawdata dlm="," dsd missover;
length Employee_ID 8 First $ 12 Last $ 18 
          Gender $ 1 Salary 8 Job_Title $ 25
          Country $ 2 Birth_Date Hire_Date 8;

   input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date9. 
         Hire_Date :date9.;
run;
proc print data=nonsales(obs=25);
run;

/*Video 3, Slides 18-35 */
libname orion '/courses/d649d56dba27fe300/STA5066';
proc print data=orion.nonsales;
   var Employee_ID Last Job_Title;
   where Job_Title = ' ';
run;

proc print data=orion.nonsales;
   var Employee_ID Birth_Date Hire_Date;
   where Hire_Date < '01JAN1974'd;
run;

proc print data=orion.nonsales;
   var Employee_ID Gender Salary Job_Title
       Country Birth_Date Hire_Date;
   where Employee_ID = . or
         Gender not in ('F','M') or
         Salary not between 24000 and 500000 or
         Job_Title = ' ' or
         Country not in ('AU','US') or
         Birth_Date > Hire_Date or
         Hire_Date < '01JAN1974'd;
run;

/*Video 4, Slides 36-45*/
proc freq data=orion.nonsales;
   tables Gender Country;
run;

proc freq data=orion.nonsales;
   tables Employee_ID;
run;

proc freq data=orion.nonsales nlevels;
   tables Gender Country Employee_ID/noprint;
run;

data EmpsDUP;
   input First $ Gender $ EmpID @@;
   datalines;
Matt  M 121160 Julie F 121161 Brett M 121162
Julie F 121161 Chris F 121161 Julie   F   121163
;
run;

proc print data=empsdup;
run;
proc sort data=EmpsDUP 
          out=EmpsDUP1 nodupkey;
  by EmpID;/*by variable is key*/
run;

proc print data=EmpsDUP1;
run;

data EmpsDUP;
   input First $ Gender $ EmpID @@;
   datalines;
Matt  M 121160 Julie F 121161 Brett M 121162 Julie F 121161
Chris F 121161 Julie   F   121163 Matt  M 121160
;
run;
proc print data=EmpsDUP;
run;
proc sort data=EmpsDUP 
               out=EmpsDUP2 noduprecs;
  by EmpID;
run;

proc print data=empsdup2;
run;



data EmpsDUP;
   input First $ Gender $ EmpID @@;
   datalines;
Matt  M 121160 Julie F 121161 Brett M 121162 Julie F 121161
Chris F 121161 Julie   F   121163 Matt  M 121160
;
run;

proc print data=empsdup;
run;

proc sort data=empsdup;
   by empid;
run;

data dups;
   set empsdup;
	 by empid;
	   if not (first.empid and last.empid) then output;
run;

proc print data=dups;
run;

data EmpsDUP;
   input First $ Gender $ EmpID @@;
   datalines;
Matt  M 121160 Julie F 121161 Brett M 121162 Julie F 121161
Chris F 121161 Julie   F   121163 Matt  M 121160
;
run;

proc print data=empsdup;
run;

proc sort data=empsdup nodupkeys outdups=dups;
   by empid;
run;
proc print data=dups;
run;

/*Video 5, Slides 46-69 */
proc means data=orion.nonsales;
   var Salary;
run;

proc means data=orion.nonsales 
		n nmiss min max;
   var Salary;
run;

ods select extremeobs missingvalues;
proc univariate data=orion.nonsales;
   var Salary;
run;

data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
run;
proc freq data=clean;
tables country;
run;


data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
   if       Employee_ID=120106 then Salary=26960;
   else if Employee_ID=120115 then Salary=26500;
   else if Employee_ID=120191 then Salary=24015;
   else if Employee_ID=120112 then Job_Title='Security Guard I';
   else if Employee_ID=120107 then Hire_Date='21JAN1995'd;
   else if Employee_ID=120111 then Hire_Date='01NOV1978'd;
   else if Employee_ID=121011 then Hire_Date='01JAN1998'd;
   if Gender not in ('F','M') then Gender='F';
   if _N_=7 then Employee_ID=120109;
   else if _N_=14 then Employee_ID=120116;
run;

proc print data=work.clean;
   var Employee_ID Gender Salary Job_Title Country Hire_Date;
run;

proc print data=work.clean;
   var Employee_ID Gender Salary Job_Title
       Country Birth_Date Hire_Date;
   where Employee_ID = . or
         Gender not in ('F','M') or
         Salary not between 24000 and 500000 or
         Job_Title = ' ' or
         Country not in ('AU','US') or
         Birth_Date > Hire_Date or
         Hire_Date < '01JAN1974'd;
run;

proc freq data=work.clean nlevels;
   tables Gender Country Employee_ID/noprint;
run;





