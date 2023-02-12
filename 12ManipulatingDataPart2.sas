/*01 Transforming Data*/
%let zip1=32308;
%let zip2=45202;
data t;
state1=zipstate(&zip1);
put "state for zip &zip1: " state1;
state2=zipstate(&zip2);
put "state for zip &zip2: " state2;
run;
proc contents data=t;run;

Libname SasData "/courses/d649d56dba27fe300/STA5066";
data contrib;
   set SasData.employee_donations;
   Total=sum( of Qtr1-Qtr4);
   if Total ge 50;
run;

proc print data=contrib noobs;
   title "Contributions $50 and Over";
   var Employee_ID Qtr1 Qtr2 Qtr3 Qtr4 Total;
run;

/*02 Manipulating Character Values*/
proc print data=sasdata.biz_list (obs=12);
run;

data item;
length item_code $20.;
input item_code;
str1=substr(item_code,1,3);
str2=substr(item_code,5,1);
str3=substr(item_code,7,5);
str4=substr(item_code,13,3);
str5=substr(item_code,17);
datalines;
978-1-59994-397-8
;
run;
proc print data=item;
run;

data code;
     length code $ 10;
	input code $;
    Last_position=length(Code);
datalines;
Abc
Abcd
Abced
;
run;
proc contents data=code;
run;
proc print data=code;
run;

data code;
Code = "ABC4  ";
Last_position=length(Code);
run;
proc print data=code;
run;

data charities;
  length ID $ 5;
  set SasData.biz_list;
  if substr(Acct_Code,length(Acct_Code),1)="2";
ID=substr(Acct_Code,1,length(Acct_Code)-1);
run;
proc print data=charities;
run;

data t;
	l=length(2);
	put "Length of numeric argument: " l;
run;

data t;
	l=length("");
	put "Length of null argument: " l;
	l1=length("    ");
	put "length of blanks argument: " l1;
	l2=length("D M");
	put "length with embedded blanks: " l2;
run;

data t;
	l=lengthn("");
	put "Length of null argument: " l;
	l1=lengthn("    ");
	put "length of blanks argument: " l1;
	l2=lengthn("D M");
	put "length with embedded blanks: " l2;
run;

data prop;
Name = "SURF&LINK SPORTS";
Pname = propcase(Name);
Pname2 = propcase(Name," &");
run;
proc print data=prop;
run;

data charities;
  length ID $ 5;
  set SasData.biz_list;
  if substr(Acct_Code,length(Acct_Code),1)="2";
  ID=substr(Acct_Code,1,length(Acct_Code)-1);
  Name = propcase(Name);
run;
proc print data=charities;
run;

data names;
   infile datalines dlm='#';
   input CommonName : $20. CapsName : $20.;
   PropcaseName=propcase(capsname, " -'");
   datalines;
Delacroix, Eugene# EUGENE DELACROIX
O'Keeffe, Georgia# GEORGIA O'KEEFFE
Rockwell, Norman# NORMAN ROCKWELL
Burne-Jones, Edward# EDWARD BURNE-JONES
;
proc print data=names noobs;
   title 'Names of Artists';
run;

/*03 Other Useful Character Functions */
proc print data=SasData.contacts;
run;

data phrase;
phrase="software and services";
Second=scan(Phrase,2," ");
put "Second word in phrase: " second;
run;
proc print data=phrase;
run;

data charities;
	set sasdata.biz_list;
	if char(right(Acct_Code),6) = '2';
	ID = left(substr(right(Acct_Code),1,5));
run;

proc print data=charities noobs;
run;

data Scan_Quiz;
  Text = "New Year's Day, January 1st, 2016"; 
  Year1 = scan(Text,-1);
  Year2 = scan(Text,6);
  Year3 = scan(Text,6,', ');
run;

proc print data=Scan_Quiz;
run;

data labels;
   set SasData.contacts;
   length FMName LName $ 15;
   FMName = scan(Name,2,",");            
   LName = scan(Name,1,",");
run;
proc print data=labels;
run;

data cat;
string1="  Both Leading and Trailing   ";
string2="  Leading only";
string3="Trailing only     ";
result1=cat(string1,string2,string3);
put "result1: " result1;
result2=cats(string1,string2,string3);
put "result2: " result2;
result3=catt(string1,string2,string3);
put "result3: " result3;
result4=catx(" ",string1,string2,string3);
put "result4: " result4;
run;

data labels;
   set SasData.contacts;
   length FullName $ 30 FMName LName $ 15;
   FMName = scan(Name,2,",");            
   LName = scan(Name,1,",");
   FullName = catx(" ",Title,FMName,LName);
run;
proc print data=labels noobs;
var ID FullName Address1 Address2;
run; 

data tmp;
 length area $ 3 number $ 8 phone $ 14;
 area="919";
 number="531-0000";
 phone="("||area||") "||number;
put "Concatenation Operator Results:  " phone;
run;

proc print data=SasData.clean_up;
run;

data find;
Text="AUSTRALIA, DENMARK, US";
Pos1=find(Text,"US");
Pos2=find(Text," US");
Pos3=find(Text,"us");
Pos4=find(Text,"us","I");
Pos5=find(Text,"us","I",10);
run;
proc print data=find;
run;

data loc;
Location = "Columbus, GA 43227";
state=zipstate(43227);
put "Correct State: " state;
run;

data loc;
Location = "Columbus, GA 43227";
substr(Location,11,2)="OH";
put "Edited location: " location;
run;

data correct;
  set SasData.clean_up;
  if find(Product,"Mittens","I") gt 0 then do;
     substr(Product_ID,9,1) = "5";
  end;
run;

proc print data=correct noobs;
run;

data correct;
   set SasData.clean_up;
   if find(Product,"Mittens","I") > 0 then do;
      substr(Product_ID,9,1) = "5";
      Product=Tranwrd(Product,"Luci ","Lucky ");
   end;
run;

proc print data=correct noobs;
run;

data compress;
ID ="20 01-005 024";
New_ID1=compress(ID);
New_ID2=compress(ID,"-");
New_ID3=compress(ID," -");
run;
proc print data=compress;
run;

data correct;
   set SasData.clean_up;
   if find(Product,"Mittens","I") > 0 then do;
      substr(Product_ID,9,1) = "5";
      Product=tranwrd(Product,"Luci ","Lucky ");
   end;
   Product_ID = compress(Product_ID);
   Product = propcase(Product);
run;

proc print data=correct noobs;
run;

data t;
	length varlist $ 100;
	input varlist $50.;
	put "Varlist: " varlist;
	numwrds=countw(varlist);
	put "Number of words: " numwrds;
	datalines;
	age
	age sbp
	age sbp chol
	age sbp chol bmi
	;
run;

/*04 Manipulating Numeric Values*/

data truncate;
NewVar1=round(12.12);
NewVar2=round(42.65,.1);
NewVar3=round(-6.478);
NewVar4=round(96.47,10);
run;
proc print data=truncate;
run;

data truncate;
NewVar5=round(12.69,.25);
NewVar6=round(42.65,.5);
run;

proc print data=truncate;
run;

data truncate;
Var1=6.478;
CeilVar1=ceil(Var1);
FloorVar1=floor(Var1);
IntVar1=int(Var1);
Var2=-6.478;
CeilVar2=ceil(Var2);
FloorVar2=floor(Var2);
IntVar2=int(Var2);
run;

proc print data=truncate;
run;

data descript;
  Var1=12;   
   Var2=.;   
   Var3=7;    
   Var4=5;
   SumVars=sum(Var1,Var2,Var3,Var4);
   AvgVars=mean(of Var1-Var4);
   MissVars=nmiss(of Var:);
run;
proc print data=descript;
run;

data donation_stats;
   set SasData.employee_donations;
   keep Employee_ID Total AvgQT NumQT;
   Total = sum(of Qtr1-Qtr4);
   AvgQT = round(Mean(of Qtr1-Qtr4),1);
   NumQt = n(of Qtr1-Qtr4);
run;

proc print data=donation_stats (obs=10) noobs;
   var Employee_ID Total AvgQt NumQt;
run;

/*05 Converting Data Types*/

Proc contents data=sasdata.convert position;
Run;
proc print data=sasdata.convert;
run;

data hrdata;
   keep EmpID;
   set SasData.convert;
   EmpID = ID + 11000;
run;
proc print data=hrdata;
run;

data hrdata;
   keep GrossPay Bonus;
   set SasData.convert;
   /*Grosspay is character*/
   Bonus = GrossPay * .10;
run;
proc print data=hrdata;
run;

data conversions;
   CVar1="32000";
   CVar2="32.000";
   CVar3="03may2008";
   CVar4="030508";
   NVar1=input(CVar1,5.);
   NVar2=input(CVar2,commax6.);
   NVar3=input(CVar3,date9.);
   NVar4=input(CVar4,ddmmyy6.);
run;
proc print data=conversions;
run;

data hrdata;
   keep EmpID GrossPay Bonus HireDate hired;
   set SasData.convert;
   EmpID = input(ID,5.)+11000;
   Bonus = input(GrossPay,comma6.)*.10;
   HireDate = input(Hired,mmddyy10.);
run;
Proc print data=hrdata;
Run;

data hrdata;
   keep EmpID GrossPay Bonus HireDate hired;
   set SasData.convert;
	 /*does this change grosspay to numeric?*/
	 GrossPay=input(GrossPay,comma6.);
   EmpID = input(ID,5.)+11000;
   Bonus = input(GrossPay,comma6.)*.10;
   HireDate = input(Hired,mmddyy10.);
run;
proc print data=hrdata;
run;
proc contents data=hrdata position;
Run;

data hrdata(drop=CharGross);
   set SasData.convert(rename=
		(GrossPay=CharGross));            
GrossPay=input(CharGross,comma6.);
run;
proc print data=hrdata;
run;
proc contents data=hrdata; run;

data hrdata;
keep Phone Code Mobile;
  set SasData.convert;
Phone="(" || Code || ") " || Mobile;
run;
proc print data=hrdata;
run;

data conversion;
NVar1=614;
NVar2=55000;
NVar3=366;
CVar1=put(NVar1,3.);
CVar2=put(NVar2,dollar7.);
CVar3=put(NVar3,date9.); 
run;
proc print data=conversion;
run;

data hrdata;
  keep Phone Code Mobile;
  set SasData.convert;
  Phone="(" || put(Code,3.) || ") " 
		|| Mobile;
run;
proc print data=hrdata;
run;

data hrdata;
   keep EmpID GrossPay Bonus Phone HireDate;
   set SasData.convert(rename=(GrossPay=
                             CharGross));
   EmpID = input(ID,5.)+11000;
   GrossPay = input(CharGross,comma6.);
   Bonus = GrossPay*.10;
   HireDate = input(Hired,mmddyy10.);
   Phone=cat("(",Code,") ",Mobile);
run;

proc print data=hrdata noobs;
   var EmpID GrossPay Bonus Phone HireDate;
   format HireDate mmddyy10.;
run;












