/*01 Conditional Processing*/
%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

proc sql;
	title "Order dates on orion.order_fact";
	select min(order_date) format= mmddyy8.,
	       max(order_date) format= mmddyy8.
	from orion.order_fact;
   select today()-max(order_date) into :diff
   from orion.order_fact;
quit;
title;
%put No of days between yesterday and max order date: &diff;

data recent_orders;
   set orion.order_fact;
   order_date=order_date+&diff;/*make last order today*/;
run;   
proc sql;
  select min(order_date) as first_date format=mmddyy10.,
         max(order_date) as last_date format=mmddyy10.
  from recent_orders;
  ;
quit;

%macro daily;
   proc print data=recent_orders;
      where order_date="&sysdate9"d;
      var product_id total_retail_price;
      title "Daily sales: &sysdate9";
   run;
   title;
%mend daily;

%daily

%macro weekly;
   proc means data=recent_orders n sum mean;
      where order_date between 
	    "&sysdate9"d - 6 and "&sysdate9"d;
      var quantity total_retail_price;
      title "Weekly sales: &sysdate9";
   run;
   title;
%mend weekly;

%weekly

%macro reports;
   %daily
   %if &sysday=Friday %then %weekly;
%mend reports;
%reports

%macro reports;
   %daily
   %if &sysday=Friday %then %weekly;
%mend reports;
options mlogic;
%reports
options nomlogic;

%macro reports;
   %daily
   %if &sysday=Friday %then %weekly;
%mend reports;
options mprint;
%reports
options nomprint;

%macro reports;
   %daily
   %if &sysday=Friday %then %weekly;
%mend reports;
options mlogic mprint;
%reports
options nomlogic nomprint;

%macro reports;
   proc print data=recent_orders;
      where order_date="&sysdate9"d;
      var product_id total_retail_price;
      title "Daily sales: &sysdate9";
   run;
   title;
 %if &sysday=Friday %then %do;
   proc means data=recent_orders n sum mean;
      where order_date between 
		"&sysdate9"d - 6 and "&sysdate9"d;
      var quantity total_retail_price;
      title "Weekly sales: &sysdate9";
   run;
   title;
 %end;
%mend reports;
%reports

%let path2=/courses/d649d56dba27fe300/STA5067/SAS Programs;
options macrogen;
%macro reports;
   %include "&path2/daily.sas";
   %if &sysday=Friday %then %do;   
	  %include "&path2/weekly.sas";
   %end;
%mend reports;
%reports
options nomacrogen;

%macro reports;
   %include "&path2/daily.sas" /source2;
   %if &sysday=Friday %then %do;   
	  %include "&path2/weekly.sas" /source2;
   %end;
%mend reports;
%reports

data tmp;
set sashelp.heart;
where AgeAtStart >50;
where Sex='Male';
run;
proc freq data=tmp;
tables Sex;
run;
proc means data=tmp;
Var AgeAtStart;
run;

data tmp;
set sashelp.heart;
where AgeAtStart >50;
where same and Sex='Male';
run;
proc freq data=tmp;
tables Sex;
run;
proc means data=tmp;
var AgeAtStart;
run;

%macro count(type=,start=01jan2016,stop=31dec2016);
   proc freq data=recent_orders;
      where order_date between "&start"d and "&stop"d;
      table quantity;
      title1 "Orders from &start to &stop";
	%if &type=  %then %do;
         title2 "For All Order Types";
      %end;
      %else %do;
         title2 "For Order Type &type Only";
         where same and order_type=&type;
      %end;
   run;
   title;
%mend count;

options mprint mlogic;
%count()
%count(type=3)
options nomprint nomlogic;

%macro cust(place);
  %let place=%upcase(&place);
  data customers;
    set orion.customer;
    %if &place=US %then %do;
	where country='US';
	keep customer_name customer_address country;
    %end;
    %else %do;
       	where country ne 'US';
       	keep customer_name customer_address country location;
	length location $ 12;
	if      country="AU" then location='Australia';
	else if country="CA" then location='Canada';
	else if country="DE" then location='Germany';
	else if country="IL" then location='Israel';
	else if country="TR" then location='Turkey';
	else if country="ZA" then location='South Africa';
    %end;
  run;
%mend cust;

options mprint;
%cust(us)

%cust(international)
proc sql;
select distinct country 
from customers;
quit;
options nomprint;

options mprint;
%macro counts(rows);
    title 'Customer Counts by Gender';
    proc freq data=orion.customer_dim;
    	  tables
    %if &rows ne  %then &rows *;
       customer_gender;
    run;
%mend counts;

%counts()
%counts(customer_age_group)
options nomprint;

/*02 Parameter Validation*/
%macro customers(place);
   %let place=%upcase(&place);
   %if &place=AU
   or  &place=CA
   or  &place=DE
   or  &place=IL
   or  &place=TR
   or  &place=US
   or  &place=ZA %then %do;
       proc print data=orion.customer;
          var customer_name customer_address country;
          where upcase(country)="&place";
          title "Customers from &place";
       run;
   %end;
   %else %put Sorry, no customers from &place..;
%mend customers;
%customers(de)
%customers(aa)

%macro customers(place) / minoperator;
   %let place=%upcase(&place);
   %if &place in AU CA DE IL TR US ZA %then %do;       	
         proc print data=orion.customer;
         var customer_name customer_address country;
         where upcase(country)="&place";
         title "Customers from &place";
      run;
   %end;
   %else %put Sorry, no customers from &place..;
%mend customers;

%customers(de)
%customers(aa)

%macro customers(place) / minoperator;
   %let place=%upcase(&place);
   proc sql noprint;
      select distinct country into :list separated by ' '
   		 from orion.customer;
   quit;
   %if &place in &list %then %do;             	
	proc print data=orion.customer;
	   var customer_name customer_address country;
         where upcase(country)="&place";
         title "Customers from &place";
      run;
   %end;
   %else %do;
	  %put Sorry, no customers from &place..;
	  %put Valid countries are: &list..;
   %end;
%mend customers;
%customers(de)
%customers(aa)

%macro customers(place);
   %let place=%upcase(&place);
   proc sql noprint;
      select distinct country into :list separated by '*'
         from orion.customer;
   quit;
   %if %index(*&list*,*&place*) > 0 %then %do;
      proc print data=orion.customer;
	   var customer_name customer_address country;
         where upcase(country)="&place";
         title "Customers from &place";
      run;
   %end;
   %else %do;
	%put Sorry, no customers from &place..;
	%put Valid countries are: &list..;
   %end;
%mend customers;

%customers(de)
%customers(aa)

/*03 Iterative Processing*/
data _null_;
   set orion.country end=no_more;
   call symputx('Country'||left(_n_),country_name);
   if no_more then call symputx('numrows',_n_);
run;
proc sql;
select name from dictionary.macros
where scope="GLOBAL";
quit;

data _null_;
   set orion.country end=no_more;
   call symputx('Country'||left(_n_),country_name);
   if no_more then call symputx('numrows',_n_);
run;
proc sql;
select name, value from dictionary.macros
where scope="GLOBAL" and upcase(name) contains "COUNTRY";
quit;

proc sql;
describe table dictionary.macros;
quit;

%macro putloop;
   %do i=1 %to &numrows;
      %put Country&i is &&country&i;
   %end;
%mend putloop;
%putloop

%macro readraw(first=2003,last=2007);
  %do year=&first %to &last;
	 data year&year; 
      set orion.orders&year;
	 run;
  %end;
%mend readraw;	

options mlogic mprint;

%readraw(first=2004,last=2006)
options nomlogic nomprint;


%macro split (data=, var=);
  proc sort data=&data(keep=&var) out=values nodupkey;
     by &var;
  run;
  data _null_;
     set values end=last;
     call symputx('site'||left(_n_),&var);
     if last then call symputx('count',_n_);
  run;
  %put _local_;
%mend split;

%split(data=orion.customer, var=country)

%macro split (data=, var=);
  proc sort data=&data(keep=&var) out=values nodupkey;
     by &var;
  run;
  data _null_;
     set values end=last;
     call symputx('site'||left(_n_),&var);
     if last then call symputx('count',_n_);
  run;
  data
     %do i=1 %to &count;
        &&site&i
     %end;
  ;
     set &data;
        select(&var);
        %do i=1 %to &count;
           when("&&site&i") output &&site&i;
        %end;
        otherwise;
        end;
  run;
%mend split;
options mprint;
%split(data=orion.customer, var=customer)
options nomprint;

%macro printlib(lib=WORK);
  %let lib=%upcase(&lib);
  data _null_;
    set sashelp.vstabvw end=final;
    where libname="&lib";
    call symputx('dsn'||left(_n_),memname);
    if final then call symputx('totaldsn',_n_);
  run;
  %put _local_;
%mend printlib;

%printlib(lib=orion)   

%macro printlib(lib=WORK,obs=5);
  %let lib=%upcase(&lib);
  data _null_;
    set sashelp.vstabvw end=final;
    where libname="&lib";
    call symputx('dsn'||left(_n_),memname);
    if final then call symputx('totaldsn',_n_);
  run;
  %do i=1 %to &totaldsn;
    proc print data=&lib..&&dsn&i(obs=&obs);
       title "&lib..&&dsn&i Data Set";
    run;
  %end;
%mend printlib;
%printlib(lib=orion)               

%macro stats(datasets);
    %let i=1;
    %let dsn=%scan(&datasets,1);
    %do %while(&dsn ne );
	  title "ORION.%upcase(&dsn)";
        proc means data=orion.&dsn n min mean max;  
	  run;
        %let i=%eval(&i+1);
	  %let dsn=%scan(&datasets,&i);
    %end;
	title;
%mend stats;

options mprint;
%stats(staff supervisors country)
options nomprint;

%macro stats(datasets);
   %let i=1;
   %do %until(&dsn= );
      %let dsn=%scan(&datasets,&i);
      %if &dsn= %then %put NOTE: Processing completed.;
      %else %if %sysfunc(exist(orion.&dsn)) %then %do;
	   title "ORION.%upcase(&dsn)";
         proc means data=orion.&dsn n min mean max;
	   run;
      %end;
      %else %put ERROR: No &dsn dataset in ORION library.;
      %let i=%eval(&i+1);
   %end;
%mend stats;

options mprint;
%stats(discount music orders)
options nomprint;

data tmp;
do i=1 to 5;
output;
end;
run;
data tmp1;
set tmp tmp;
proc print data=tmp1 noobs;
run;

%macro mkcopies(reps,newdata,copydata);
  data &newdata;
  set
  %do i=1 %to &reps;
  &copydata 
  %end;
  ;
  run;
%mend mkcopies;

options mprint;
%mkcopies(6,tmp2,tmp);
proc print data=tmp2;
run;
options nomprint;

/*05 Global and Local Symbol Tables*/
libname fram "&path/fram";

%macro simple;
proc sql;
select count(*) into :numobs
from fram.frex4
;
quit;
%mend;

%simple
%put &numobs;

%macro simple;
%global numobs;
proc sql;
select count(*) into :numobs
from fram.frex4
;
quit;
%mend;

%simple
%put &numobs;



