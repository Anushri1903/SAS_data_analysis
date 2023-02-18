/*01 Views*/
%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

proc sql;
create view orion.Tom_Zhou as
   select Employee_Name as Name format=$25.0,
          Job_Title as Title format=$15.0,
          Salary 'Annual Salary' format=comma10.2,
          int((today()-Employee_Hire_Date)/365.25) 
             as YOS 'Years of Service'
      from orion.Employee_Addresses as a,
           orion.Employee_Payroll as p,
           orion.Employee_Organization as o
      where a.Employee_ID=p.Employee_ID and
            o.Employee_ID=p.Employee_ID and
            Manager_ID=120102;/*Tom Zhou’s id*/
quit;

proc contents data=orion.tom_zhou;
run;

proc sql;
title "Tom Zhou's Direct Reports";
title2 "By Title and Years of Service";
   select *
      from orion.Tom_Zhou
      order by Title desc, YOS desc;
quit;
title;

proc sql;
   describe view orion.Tom_Zhou;
quit;

/*02 Creating Tables*/


proc sql;
   create table Discounts
      (Product_ID num format=z12.,
       Start_Date date,
       End_Date date,
       Discount num format=percent.);
quit;
proc contents data=discounts;run;

proc sql;
   create table Testing_Types
      (Char_Column char(4),
       Varchar_Column varchar,
       Int_Column int, 
       SmallInt_Column smallint, 
       Dec_Column dec, 
       Num_Column num,  
       Float_Column float, 
       Real_Column real,
       Date_Column date,
       Double_Column double precision);
quit;
proc contents data=testing_types;run;

proc sql; 
create table work.New_Sales_Staff like orion.Sales
;
quit;
proc contents data=new_sales_staff;
run;

proc sql;
create table work.Melbourne as
   select Employee_Name as Name,Salary
      from orion.Staff as s,
           orion.Employee_addresses as a
      where s.Employee_ID=a.Employee_ID
	       and City ="Melbourne";
quit;
proc contents data=melbourne;
run;

proc sql;
   create table Discounts
      (Product_ID num format=z12.,
       Start_Date date,
       End_Date date,
       Discount num format=percent.);
quit;
proc contents data=discounts;run;

proc sql;
insert into Discounts
   set Product_ID=230100300006,
       Start_Date='01MAR2007'd,
       End_Date='15MAR2007'd,Discount=.33
   set Product_ID=230100600018,
       Start_Date='16MAR2007'd,
       End_Date='31MAR2007'd, Discount=.15
;
quit;
proc print data=discounts;run;

proc sql;
   create table Discounts
      (Product_ID num format=z12.,
       Start_Date date,
       End_Date date,
       Discount num format=percent.)
;
insert into Discounts
   values (230100300006,'01MAR2007'd,
          '15MAR2007'd,.33)
   values (230100600018,'16MAR2007'd,
          '31MAR2007'd,.15)
;
select * from discounts;
quit;

proc sql;
   create table Discounts
      (Product_ID num format=z12.,
       Start_Date date,
       End_Date date,
       Discount num format=percent.)
;
insert into Discounts 
(Start_Date,End_Date, Product_ID, Discount)
   values ('01MAR2007'd,'15MAR2007'd,230100300006,.33)
   values ('16MAR2007'd,'31MAR2007'd,230100600018,.15)
;

select * from discounts;
quit;

proc sql;
   create table Discounts
      (Product_ID num format=z12.,
       Start_Date date,
       End_Date date,
       Discount num format=percent.)
;
insert into Discounts
     (Product_ID,Discount,Start_Date,End_Date)
      select distinct Product_ID,.35,
             '01MAR2007'd,'31mar2007'd
         from orion.Product_Dim
         where Supplier_Name contains 
              'Pro Sportswear Inc'
;
select * from discounts;
quit;

/*03 Integrity Constraints*/
proc sql;
create table Discounts
  (Product_ID num format=z12.,
   Start_Date date,
   End_Date date,
   Discount num format=percent.
   )
;
describe table discounts;
quit;
proc contents data=discounts;run;

proc sql;
create table Discounts
  (Product_ID num format=z12.,
   Start_Date date,
   End_Date date,
   Discount num format=percent.,
   constraint ok_discount 
   check (Discount le .5))
;
describe table discounts;
quit;
proc contents data=discounts;run;

proc sql;
insert into Discounts
   values (240500200009,'01Mar2007'd,
           '31Mar2007'd,.45)
   values (220200200036,'01Mar2007'd,
           '31Mar2007'd,.54)
   values (220200200038,'01Mar2007'd,
           '31Mar2007'd,.25)
;
quit;

proc sql undo_policy=none;
create table Discounts
  (Product_ID num format=z12.,
   Start_Date date,
   End_Date date,
   Discount num format=percent.,
   constraint ok_discount 
   check (Discount le .5))
;
insert into Discounts
   values (240500200009,'01Mar2007'd,
           '31Mar2007'd,.45)
   values (220200200036,'01Mar2007'd,
           '31Mar2007'd,.54)
   values (220200200038,'01Mar2007'd,
           '31Mar2007'd,.25)
;
quit;

proc sql undo_policy=optional;
create table Discounts
  (Product_ID num format=z12.,
   Start_Date date,
   End_Date date,
   Discount num format=percent.,
   constraint ok_discount 
   check (Discount le .5))
;
insert into Discounts
   values (240500200009,'01Mar2007'd,
           '31Mar2007'd,.45)
   values (220200200036,'01Mar2007'd,
           '31Mar2007'd,.54)
   values (220200200038,'01Mar2007'd,
           '31Mar2007'd,.25)
;
quit;
proc print data=discounts noobs;run;

proc sql;
   describe table constraints Discounts;
quit;

 /* correct second entry and re-run */
proc sql undo_policy=none;
   insert into Discounts
      values (240500200009,'01Mar2007'd,
              '31Mar2007'd,.45)
      values (220200200036,'01Mar2007'd,
              '31Mar2007'd,.45)
      values (220200200038,'01Mar2007'd,
              '31Mar2007'd,.25);
quit;
proc sql;
   select * from discounts;
quit;









