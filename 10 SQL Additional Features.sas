/*01 SQL Options*/
%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

proc sql inobs=10;
title "orion.Price_List - INOBS=10";
   select Product_ID, 
          Unit_Cost_Price format=comma8.2,
	     Unit_Sales_Price format=comma8.2,
          Unit_Sales_Price-Unit_Cost_Price  as Margin format=comma8.2
      from orion.Price_List
;
quit;
title;
proc sql outobs=10;
title "10 Most Profitable Customers";
   select Customer_ID, 
          sum(Unit_Sales_Price-Unit_Cost_Price)
          as Profit_2007 format=comma8.2
      from orion.Price_List as p,
           orion.Order_Fact as o
      where p.Product_ID=o.Product_id
            and year(Order_date) =2007
      group by Customer_ID
      order by Profit_2007 desc;
quit;
title;


proc sql number outobs=10;
title "Top 10 Employee's 2007 Charitable Donations";
   select Employee_Name, Sum(Qtr1,Qtr2, Qtr3,Qtr4) as Donation_Total
      from orion.Employee_Addresses as a,
           orion.Employee_donations as d
	   where a.Employee_ID=d.Employee_ID
	   order by Donation_Total desc, Employee_Name
;
reset nonumber outobs=9;
title "Top 9 Employee's 2007 Charitable Donations";
   select Employee_Name, Sum(Qtr1,Qtr2, Qtr3,Qtr4) as Donation_Total
      from orion.Employee_Addresses as a,
           orion.Employee_donations as d
	  where a.Employee_ID=d.Employee_ID
	  order by Donation_Total desc, Employee_Name
;
quit;
title;

/*02 Interfacing Proc Sql and Macro Language*/
%put _automatic_;

data tmp;
set orion.sales;
run;

%put &syslast;

proc sql;
	select count(*) 
	from orion.sales
	;
%put sqlobs:  &sqlobs;
%put sqlrc:  &sqlrc;
quit;

/*with an error: comma after count(*)*/
proc sql;
	select count(*), 
	from orion.sales
	;
%put sqlobs:  &sqlobs;
%put sqlrc:  &sqlrc;
quit;

%let bigsalary=5000000;

%put The value of bigsalary is &bigsalary;

%let datasetname=Employee_Payroll;
%let bigsalary=100000;
options symbolgen;
proc sql;
title "Salaries > &bigsalary";
   select  Employee_ID, Salary
      from orion.&datasetname
      where Salary > &bigsalary
;
quit;
title;

proc sql noprint;
   select avg(Salary)
      into :MeanSalary
      from orion.Employee_payroll;
%put The average salary is &MeanSalary;
quit;

proc sql;
select avg(Salary),min(Salary),max(Salary)
   into :MeanSalary, :MinSalary, :MaxSalary
   from orion.Employee_payroll;
quit;
%put Mean: &meansalary Min: &minsalary 
     Max: &maxsalary;

/*Steps 1 and 2*/
%let Dept=Sales;
proc sql noprint;
   select avg(Salary) 
      into :MeanSalary
      from orion.Employee_payroll as p,
           orion.Employee_Organization as o
      where p.Employee_ID=o.Employee_ID
            and Department=propcase("&Dept")
;
reset print number;
title "&Dept Department Employees Earning";
title2 "More Than The Department Average "
       "Of &meansalary";
select p.Employee_ID, Salary
   from orion.Employee_payroll as p,
        orion.Employee_Organization as o
   where p.Employee_ID=O.Employee_ID
     and Department=Propcase("&Dept")
     and Salary > &meansalary
;
quit;
title;

/*Change department to Engineering*/
%let Dept=Engineering;
proc sql noprint;
   select avg(Salary) 
      into :MeanSalary
      from orion.Employee_payroll as p,
           orion.Employee_Organization as o
      where p.Employee_ID=o.Employee_ID
            and Department=propcase("&Dept")
;
reset print number;
title "&Dept Department Employees Earning";
title2 "More Than The Department Average "
       "Of &meansalary";
select p.Employee_ID, Salary
   from orion.Employee_payroll as p,
        orion.Employee_Organization as o
   where p.Employee_ID=O.Employee_ID
     and Department=Propcase("&Dept")
     and Salary > &meansalary
;
quit;
title;

/*Step 1*/
proc sql;
   select substr(put(Customer_Type_ID,4.),1,1)
          as Tier, count(*)
      from orion.Customer
      group by Tier;
%let Rows=&SQLOBS;
%put NOTE:  There are &Rows Tiers;
quit;

/*Step 2*/
proc sql;
   select substr(put(Customer_Type_ID,4.),1,1)
          as Tier, count(*)
      from orion.Customer
      group by Tier;
%let Rows=&SQLOBS;
reset noprint;
   select substr(put(Customer_Type_ID,4.),1,1) 
          as Tier, count(*)
      into :Tier1-:Tier&Rows,:Count1-:Count&Rows
      from orion.Customer
      group by Tier;
%put NOTE: Tier1 is &tier1  Count1 is: &count1;
%put NOTE: Tier2 is &tier2  Count2 is: &count2;
%put NOTE: Tier3 is &tier3  Count3 is: &count3;
quit;

/*Step 3*/
proc sql;
   select substr(put(Customer_Type_ID,4.),1,1)
          as Tier, count(*)
      from orion.Customer
      group by Tier;
%let Rows=&SQLOBS;
reset noprint;
   select substr(put(Customer_Type_ID,4.),1,1) 
          as Tier, count(*)
      into :Tier1-:Tier&Rows,:Count1-:Count&Rows
      from orion.Customer
      group by Tier;
reset print;
title "Tier &Tier3 Customers (&Count3 total)";
   select Customer_Name, Country
      from orion.Customer
      where substr(put(Customer_Type_ID,4.),1,1)
            ="&Tier3"
      order by country, Customer_Name
;
quit;

proc sql;
   create table Payroll as
      select Employee_ID, Employee_Gender, Salary,
             Birth_Date format=date9.,   
             Employee_Hire_Date as Hire_Date 
             format=date9., 
             Employee_Term_Date as Term_Date 
             format=date9. 
        from orion.Employee_Payroll
        order by Employee_ID;
quit;

proc sql noprint;
select Name
   into :Column_Names separated by ","
   from Dictionary.Columns
   where libname ="WORK"
   and memname="PAYROLL"
   and upcase(Name) like '%DATE%';
reset print;
title "Dates of Interest by Employee_ID";
select Employee_ID, &Column_Names
   from work.Payroll
   order by Employee_ID;
quit;

proc sql;
alter table Payroll
   add Date_Last_Raise date, 
       Promotion_Date date;
update Payroll
   set Promotion_Date=Hire_Date+180
   where Term_Date is missing 
     and today()-180 ge Hire_Date; 
update Payroll
   set Date_Last_Raise=Promotion_Date+180
   where Term_Date is missing 
     and today()-180 ge Promotion_Date; 
quit;

proc sql noprint;
select Name
   into :Column_Names separated by ","
   from Dictionary.Columns
   where libname ="WORK"
   and memname="PAYROLL"
   and upcase(Name) like '%DATE%';
reset print;
title "Dates of Interest by Employee_ID";
select Employee_ID, &Column_Names
   from work.Payroll
   order by Employee_ID;
quit;

proc sql noprint;
select Name
   into :Column_Names separated by ","
   from Dictionary.Columns
   where libname ="ORION"
   and memname="EMPLOYEE_PAYROLL"
   and upcase(Name) like '%DATE%';
reset print;
title "Dates of Interest by Employee_ID";
select Employee_ID, &Column_Names
   from orion.Employee_Payroll
   order by Employee_ID;
quit;




