%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

proc sql noprint;
   select sum(total_retail_price) format=dollar8.
   	into : total
      from orion.order_fact
      where year(order_date)=2007 and order_type=3;
quit;

%put Total sales: &total;

title 'Top 2007 Sales';
proc sql outobs=3 double;
   select total_retail_price, order_date format=mmddyy10.
     	into :price1-:price3, :date1-:date3
	from orion.order_fact
	where year(order_date)=2007
	order by total_retail_price desc;
quit;
title;

%put Top 3 sales amounts: #1: &price1 #2: &price2 #3: &price3;
%put Top 3 sales dates: #1: &date1 #2: &date2 #3: &date3;

proc sql noprint;
   select distinct country into :countries 
      separated by ', '
      from orion.customer;
quit;
%put Customer Countries: &Countries;

proc sql;
   select name, value
      from dictionary.macros
      where scope='GLOBAL'
	 order by name;
quit;

proc sql noprint;
   select name into: vars separated by ' '
	 from dictionary.macros
	 where scope='GLOBAL';
quit;
%put &vars;

%macro deletemymacvars;

   proc sql noprint;
	select name into: vars separated by ' '
	   from dictionary.macros
	   where scope='GLOBAL';
   quit;

   %symdel &vars;

%mend deletemymacvars;

proc sql;
   select name
   from dictionary.macros
   where scope="GLOBAL";
quit;

%deletemymacvars

proc sql;
   select name
   from dictionary.macros
   where scope="GLOBAL";
quit;


