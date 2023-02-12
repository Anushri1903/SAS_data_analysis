libname orion '/courses/d649d56dba27fe300/STA5066';

/*01 Create Accumulating Variables*/

proc contents data=orion.aprsales;run;
proc print data=orion.aprsales;run;

data mnthtot;
   set orion.aprsales;
   Mth2Dte=Mth2Dte+SaleAmt;
run;

proc print data=mnthtot;
run;

data mnthtot;
   set orion.aprsales;
   retain Mth2Dte 0;
   Mth2Dte=Mth2Dte+SaleAmt;
run;

proc print data=mnthtot;
run;

proc print data=orion.aprsales2;
run;

data mnthtot;
   set orion.aprsales2;
   retain Mth2Dte 0;
   Mth2Dte=Mth2Dte+SaleAmt;
run;

proc print data=mnthtot;
run;

data mnthtot;
   set orion.aprsales2;
   retain Mth2Dte 0;
   Mth2Dte=sum(Mth2Dte,SaleAmt);
run;

proc print data=mnthtot;
run;

data mnthtot2;
   set orion.aprsales2;
   Mth2Dte+SaleAmt;
run;

proc print data=mnthtot2;
run;

/*02 Accumulating Totals for Groups*/

data example;
  call streaminit(57186921);
  do id=1 to 6;
   num=int(rand("uniform")*5+1); /*num will be in (1,2,3,4,5,6)*/
      do obs=1 to num;
         x=round(rand("normal",69,3));
         output;
     end;
  end;
drop num obs;
run;

proc print data=example;
run;

data demo;
  set example;
	by id; /*this creates the 
	         first. and last.
	         variables*/
  first=first.id;
  last=last.id;
run;

proc print data=demo;
run;

data numobs;
  set example;
	by id;
	if first.id then numobs=0;
	numobs+1;/*automatically retains numobs*/
	if last.id then output;
run;

proc print data=numobs;
run;

proc contents data=orion.specialsals;run;
proc print data=orion.specialsals;run;

proc sort data=orion.specialsals 
		out=salsort;
   by Dept;
run;

data deptsals;
   set salsort;
   by Dept;
   first=first.dept;
	last=last.dept;
run;
proc print data=deptsals;
run;

proc sort data=orion.specialsals out=salsort;
   by Dept;
run;

data deptsals(keep=Dept DeptSal);
   set SalSort;
   by Dept;
   if First.Dept then DeptSal=0;
   DeptSal+Salary;
   if Last.Dept;
run;
proc print data=deptsals;
run;

proc contents data=orion.projsals;run;
proc print data=orion.projsals;run;

proc sort data=orion.projsals 
          out=projsort;
   by Proj Dept;
run;
proc print data=projsort;run;

data pdsals;
   set projsort;
   by Proj Dept; 
	firstproj=first.proj;
	 lastproj=last.proj; 
   firstdept=first.dept;
	 lastdept=last.dept;
run;
proc print data=pdsals;
run;

data pdsals(keep= Proj Dept 
		        DeptSal NumEmps);
   set projsort;
   by Proj Dept;
   if First.Dept then do;
      DeptSal=0;
      NumEmps=0;
   end;
   DeptSal+Salary;
   NumEmps+1;
   if Last.Dept;
run;
proc print data=pdsals noobs;
run;

/*03 Do Loop Processing*/

data compound;
   Amount=50000;
   Rate=.045;
   Yearly=Amount*Rate;
   /*Sum statement:   variable + expression  
   The sum statement ignores a missing value for the expression
   i.e. the previous total remains unchanged.
   */
   Quarterly+((Quarterly+Amount)*Rate/4);/*end of 1st qtr*/
   Quarterly+((Quarterly+Amount)*Rate/4);/*end of 2nd qtr*/
   Quarterly+((Quarterly+Amount)*Rate/4);/*end of 3rd qtr*/
   Quarterly+((Quarterly+Amount)*Rate/4);/*end of 4th qtr*/
run;
proc print data=compound noobs;
title "Interest earned in one year, yearly & quarterly compounding";
run;

title;

data compound;
   Amount=50000;
   Rate=.045;
   Yearly=Amount*Rate;
	do i=1 to 4;
   		Quarterly+((Quarterly+Amount)*Rate/4);
	  end;
run;
proc print data=compound noobs;
title "Interest earned in one year, yearly & quarterly compounding";
run;

title;

/* why the (drop=i)?*/
data compound(drop=i);
Amount=50000;
Rate=.045;
   do i=1 to 20;
      Yearly +(Yearly+Amount)*Rate;
   end;
   do i=1 to 80;
      Quarterly+((Quarterly+Amount)*Rate/4);
   end;
run;

proc print data=compound;
run;

data invest;
   do Year=2018 to 2020;
      Capital+5000;
      Capital+(Capital*.045);
   end;
run;

proc print data=invest;
title "Capital after 3 years at 4.5% annual interest";
run;

title;

proc print data=orion.growth;
run;


data forecast;
   set orion.growth;
   do Year=1 to 6;
  	 Total_Employees=Total_Employees*(1+Increase);
  	 output;
   end;
run;

proc print data=forecast noobs;
run;

data invest;
   do until(Capital>1000000);
      Year+1;
      Capital+5000;
      Capital+(Capital*.045);
      output;
   end;
run;

proc print data=invest noobs;
   format Capital dollar14.2;
run;

data invest;
   do year=1 to 100 until(Capital>250000 or year>30 );
      Capital+5000;
      Capital+(Capital*.045);
   end;
run;

proc print data=invest noobs;
   format Capital dollar14.2;
run;

data invest;
  do Year=1 to 100 while (Capital lt 250000 or year=30);
    Capital+5000;
    Capital+(Capital*.045);
    output;
  end;
run;

proc print data=invest noobs;
   format capital dollar14.2;
run;

title "Output statement outside do loop";
data tmp1;
do i=1 to 3;
end;
output;
run;

proc print data=tmp1;
run;

title "Output statement inside do loop";
data tmp2;
  do i=1 to 3;
	  output;
  end;
run;

proc print data=tmp2;
run;

title;

data invest (drop=i) ;
  do Year=1 to 5;
    Capital+5000;
       do i=1 to 4;
         Capital+(Capital*.045/4);
      end;
  output;
  end;
run;

proc print data=invest noobs;
   format capital dollar14.2;
run;

title "Non-integer increment in do loop";
data tmp;
   do i=1 to 3 by .5;/*non-integer increment*/
	   x=i**2;
	   output;
   end;
run;

proc print data=tmp;
run;

title;

title "Negative increment in do loop";
data tmp;
   do i=4 to 1 by -.5;/*negative increment*/
	   x=i**2;
	   output;
   end;
run;

proc print data=tmp;
run;

title;

data tmp;
   do i=1,5,9,14;
	   x=i**2;
	 output;
	 end;

proc print data=tmp;
run;

title "Do Loop with Character Index";

data tmp;
   do i='M','F','X';
	   output;
	 end;
run;

proc print data=tmp;
run;

title;

/*04 Example, Binary Search (Interval Halving)*/

data tmp;
low=1;
high=2;
do i=1 to 100; 
   midpt=(high+low)/2;
   sqrt3=midpt;
   if midpt*midpt<3 then low=midpt;
   else high=midpt;
   output;
end;
tsqrt3=sqrt(3);
output;
run;
proc print data=tmp;
run;

data tmp;
do i = 1, 1, 2, 3, 5, 8, 13, 21;
   x = lag(i);
   output;
end;
run;

proc print data=tmp;
run;

data tmp;
do i = 1, 1, 2, 3, 5, 8, 13, 21;
   x = lag2(i);
   output;
end;
run;

proc print data=tmp;
run;

data tmp;
low=1;
high=2;
do i=1 to 1000 until (abs(diff)<.00001 and diff ne .); 
   midpt=(high+low)/2;
   sqrt3=midpt;
   diff=sqrt3-lag(sqrt3);
   if midpt*midpt<3 then low=midpt;
   else high=midpt;
   output;
end;
tsqrt3=sqrt(3);
output;
run;
proc print data=tmp;
run;

/*05 Data Step Arrays*/

title "The Employee Donations Dataset";

proc print data=orion.employee_donations (obs=10);
run;

title;

data charity;   
   set orion.employee_donations;
   keep employee_id qtr1-qtr4; 
   Qtr1=Qtr1*1.25;
   Qtr2=Qtr2*1.25;
   Qtr3=Qtr3*1.25;
   Qtr4=Qtr4*1.25;
run;
proc print data=charity (obs=10);
run; 


data charity;
   set orion.employee_donations;
   keep employee_id qtr1-qtr4; 
   array Contrib{4} qtr1-qtr4;
   do i=1 to 4;        
      Contrib{i}=Contrib{i}*1.25;
   end; 
run;

proc print data=charity (obs=10);
run;

data test;
   set orion.employee_donations;
   array val{4} qtr1-qtr4;
   Tot1=sum(of qtr1-qtr4);
   Tot2=sum(of val{*});
run;

proc print data=test;
   var employee_id tot1 tot2;
run;

data charity;
   set orion.employee_donations;
   keep employee_id qtr1-qtr4; 
   array Contrib{*} qtr1-qtr4;
   do i=1 to dim(contrib);
      Contrib{i}=Contrib{i}*1.25;
   end; 
run; 

proc print data=charity (obs=10);
run;

data percent(drop=i);              
   set orion.employee_donations;
   array Contrib{4} qtr1-qtr4;        
   array Percent{4};
   Total=sum(of contrib{*});           
   do i=1 to 4;     
      percent{i}=contrib{i}/total;
   end;                               
run; 

proc print data=percent  (obs=10)   noobs ;
   var Employee_ID percent1-percent4;
   format percent1-percent4 percent6.;
run;

data change;                 
   set orion.employee_donations;
   drop i; 
   array Contrib{4} qtr1-qtr4;        
   array Diff{3};                  
   do i=1 to 3;                       
      diff{i}=contrib{i+1}-contrib{i};
   end;                               
run; 

proc print data=change (obs=10)  noobs ;  
   var Employee_ID Diff1-Diff3;         
run;

data compare(drop=i Goal1-Goal4);
   set orion.employee_donations;
   array Contrib{4} Qtr1-Qtr4;
   array Diff{4};
   array Goal{4} (10,20,20,15);
   do i=1 to 4;
      Diff{i}=Contrib{i}-Goal{i};
   end;
run;

proc print data=compare (obs=10) noobs ;
run;

data compare(drop=i Goal1-Goal4);
   set orion.employee_donations;
   array Contrib{4} Qtr1-Qtr4;
   array Diff{4};
   array Goal{4} (10,20,20,15);
   do i=1 to 4;
      Diff{i}=sum(Contrib{i},-Goal{i});
   end;
run;

proc print data=compare (obs=10) noobs;
   var Employee_id diff1-diff4 qtr1-qtr4;
run;

data compare(drop=i);
   set orion.employee_donations;
   array Contrib{4} Qtr1-Qtr4;
   array Diff{4};
   array Goal{4} _temporary_ (10,20,20,15);
   do i=1 to 4;
      Diff{i}=Contrib{i}-Goal{i};
   end;
run;
proc print data=compare noobs;
   var employee_id diff1-diff4;
run;

%let demographics=seqn hsageir hssex dmaethnr dmaracer dmarethn;
libname nhanes3 '/courses/d649d56dba27fe300/STA5066';
proc format ;
    value f_HSSEX 1="Male" 2="Female";
    value f_RACER 1="White" 2="Black" 3="Other"  8="Mexican-American of unknown race";
   value f_rethn 1="Non-Hispanic white" 2="Non-Hispanic black"  3="Mexican-American" 4="Other";
    value f_ethnr 1="Mexican-American" 2="Other Hispanic" 3="Not Hispanic";
data bone1;
    set nhanes3.exam (keep=&demographics BD:);
    /* keep protocol scans and those not qc rejected*/
    where bdpexflr=0 and bdpscan ne 2;      /*eligible and acceptable scan*/
    format hssex f_hssex. dmaracer f_racer. dmarethn f_rethn. dmaethnr f_ethnr.;
run;

proc means data=bone1;
run;

title "Fix Fill-values Femor Neck Data";

data bone2 (drop=i);
    set bone1 (drop=BDPTECH BDPEXFLR BDPSCAN);
    array bone{17} BDPFNARE--BDPD0;
    array unk{17} _temporary_ (8888,16*88888);
    do i=1 to 17;
    if bone{i} eq unk{i} then bone{i}=.;
    end;
run;

proc means data=bone2;
run;

title;

/*06 Longitudinal Data*/

proc contents data=nhanes3.sbp100;
run;

proc print data=nhanes3.sbp100 (obs=10);
run;

data sbp100_long (keep= id exam sbp dth);
set nhanes3.sbp100;
	id=_n_;
  array s{15} spf1-spf15;
	do exam=1 to 15;
    if dth eq exam then leave;
    sbp=s{exam};
    output;
  end;
run;

proc print data=sbp100_long (obs=75);
run;



