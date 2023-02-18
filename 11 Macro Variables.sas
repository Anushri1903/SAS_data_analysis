/*01 Introduction*/
%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

%put _automatic_;

%put this is some text to be put to the log;

%put This text was output:  &systime &sysday &sysdate9 ;
%put The last dataset created was:  &syslast;

/*without macro variables*/
proc freq data=orion.Customer;
   table Country / nocum;
   footnote1 "Created 11:47 Wednesday, 11Mar2020";
   footnote2 "By user jhshows0";
run;

footnote;

/*with macro variables*/
proc freq data=orion.Customer;
   table Country / nocum;
   footnote1 'Created &systime &sysday, &sysdate9';
   footnote2 'By user &sysuserid ';
run;

footnote;

/*with macro variables*/
proc freq data=orion.Customer;
   table Country / nocum;
   footnote1 "Created &systime &sysday, &sysdate9";
   footnote2 "By user &sysuserid";
run;

footnote;

%let mymacvar=Some text (often code goes here);
%put Mymacvar:  &mymacvar;

%let txt="Some text in quotes";
%put The macro variable txt is:  &txt;

/* without macro variables*/
proc freq data=orion.order_fact;
   where year(order_date)=2007;
   table order_type;
   title "Order Types for 2007";
run;
proc means data=orion.order_fact;
   where year(order_date)=2007;
   class order_type;
   var Total_Retail_Price;
   title "Price Statistics for 2007";
run;
title;

/* with  macro variables*/
%let year=2006;
proc freq data=orion.order_fact;
   where year(order_date)=&year;
   table order_type;
   title "Order Types for &year";
run;
proc means data=orion.order_fact;
   where year(order_date)=&year;
   class order_type;
   var Total_Retail_Price;
   title "Price Statistics for &year";
run;
title;

data normals;
    array x{10} x1-x10;
    call streaminit(654321);
    do rep=1 to 1000;
        do n=1 to 10;
        x{n}=rand("normal");
        end;
        mn=mean(of x{*});
        output;
    end;
run;  
ods select histogram;
proc univariate data=normals;
var mn;
histogram mn/normal;
run;

%let obs=100;
%let sampsize=1000;
%let seed=54321;
data normals;
    array x{*} x1-x&obs;
    call streaminit(&seed);
    do rep=1 to &sampsize;
        do n=1 to &obs;
        x{n}=rand("normal");
        end;
        mn=mean(of x{*});
        output;
    end;
run;  
ods select histogram;
proc univariate data=normals;
var mn;
histogram mn/normal;
run;


filename iris1 '/courses/d649d56dba27fe300/Data Sets/IrisDataNoHeaderCsv.csv';
PROC IMPORT DATAFILE=iris1
	DBMS=CSV
	OUT=DataNoHeaderCsv 
	replace;
	GETNAMES=no;
	
RUN;

%macro impdat(datanm);
filename iris "/courses/d649d56dba27fe300/Data Sets/&datanm..csv";
PROC IMPORT OUT=&datanm 
    DATAFILE=iris
	DBMS=CSV
	replace;
	GETNAMES=no;
	
RUN;
%mend;

%impdat(IrisDataNoHeaderCsv);

/*02 Program Flow*/
libname nhanes3 "&path/nhanes3";
proc reg data=nhanes3.chdagesbp outest=betas1;
model spf1=age1;
run;

proc reg data=nhanes3.chdagesbp
					outest=betas2
					;
model 
spf1=age1;run;


/*03 User-Defined Macro Variables*/
%let name= Ed Norton ; 
%put The value of the macro variable name is:  &name;
%let name2=' Ed Norton ';
%put name2 is &name2;
%let title="Joan's Report";
%put quotes are included in the saved text, title is  &title;
%let start=;
%put Macro variable may be assigned a null value:  &start;
%let sum=3+4;
%put Macro variables contain text, including numbers, no arithmetic is done. Sum is &sum;
%let total=0;
%let total=&total+&sum;
%put When macro variable definition included macro variables;
%put The included macro variables are "resolved" and then the definition is made;
%put total is now:  &total;

%let x = varlist;

%let &x = name age height;
%put The macro variable being defined can be a macro variable.  Still the resolution is done first.;
%put &varlist;
%put &x;


%let units = 5;
Proc print data=orion.order_fact;
Where quantity > &units;
Var order_date product_id quantity;
Title "Orders exceeding &units units";
Run;

%let lower = 29;
%let upper = 30;
Proc means data=nhanes3.agesbp;
Var age1 spf1;
Where &lower le age1 le &upper;
Run; 

title;
footnote;

%let office=Sydney;
proc print data=orion.employee_addresses;
where city="&office";
var employee_name;
title "&office Employees";
run;

%let date1=25may2007;
%let date2=15jun2007;
proc print data=orion.order_fact;
where order_date between "&date1"d and "&date2"d;
var order_date product_id quantity;
title "Orders between &date1 and &date2";
run;
title;

%put _user_;

Options symbolgen;
%let office=Sydney;
Proc print data=orion.employee_addresses;
Where city="&office";
Var employee_name;
Title "&office Employees";
Run;

title;
options nosymbolgen;

%let x1=First macro text;
%let x2=Second macro text;
%put &x1 &x2;

%symdel x1 x2;
%put &x1 &x2;

/*04 Delimiting macro variables*/
libname nh9ques "&path/nhanes1999/questionnaire";
libname nh9lab "&path/nhanes1999/lab";
libname nh9exam "&path/nhanes1999/exam";
libname nh9demo "&path/nhanes1999/demographics";
libname nh9diet "&path/nhanes1999/dietary";

libname nh9 (nh9demo nh9exam nh9lab nh9ques);

%let mac=waist;
proc means data=nh9.bodymeasurements;
var bmx&mac;
run;

/*Why do we get an error here?*/
%let datanm=IrisDataNoHeaderCsv;
filename iris "/courses/d649d56dba27fe300/Data Sets/&datanm.csv";
PROC IMPORT OUT=&datanm 
    DATAFILE=iris
	DBMS=CSV
	replace;
	GETNAMES=no;
	
RUN;

/*Correct way*/
%let datanm=IrisDataNoHeaderCsv;
filename iris "/courses/d649d56dba27fe300/Data Sets/&datanm..csv";
PROC IMPORT OUT=&datanm 
    DATAFILE=iris
	DBMS=CSV
	replace;
	GETNAMES=no;
	
RUN;

/*05 macro functions*/
%let lower=lowercaseword;
%let upper=%UPCASE(lowercaseword) ;
%let upper2=%upcase(&lower);
%put lower=&lower upper=&upper upper2=&upper2;


%let str1=thisisastringwithoutspaces;
%let sub1=%SUBSTR(thisisastringwithoutspaces,5,2);
%let sub2=%SUBSTR(&str1,8,6);
%put str1=&str1  sub1=&sub1  sub2=&sub2;
%put date9=&sysdate9;

%put year=%substr(&sysdate9,6);


%let str1=this is a string with spaces;
%let word1=%scan(&str1,2);
%let word2=%scan(this is a string with spaces,4);
%put str1=&str1  word1=&word1  word2=&word2;
data tmp;
  do i=1 to 4;
  x=i**2;
  output;
  end;
run;  
%put syslast=&syslast;
%put dsn=%scan(&syslast,2,.);

%let dietvars=PROTEIN FAT TOTAL_CARBOHYDRATE Alcohol CALCIUM 
              PHOSPHORUS IRON SODIUM POTASSIUM SATURATED_FAT 
              OLEIC_ACID LINOLEIC_ACID CHOLESTEROL;
%put Variables: &dietvars;
/*Find the number of variables*/
 %let numvars=%sysfunc(countw(&dietvars));
 %put Number of variables=  &numvars;
/*Find the fifth variable*/
 %let var5=%scan(&dietvars,5);
 %put Fifth variable= &var5;
/*find the last variable*/
%let lastvar=%scan(&dietvars,&numvars);
%put Last variable=&lastvar;


%let str1=this is simple text;
%let index1=%INDEX(this is simple text,is);
%let index2=%INDEX(&str1,text);
%put str1=&str1  index1=&index1 index2=&index2;

%let sum=2+7;
%let sum1=%EVAL(&sum);
%let sum2=%EVAL(&sum1>7);
%let sum3=%EVAL(&sum<=7;);
%put sum=&sum  sum1=&sum1 sum2=&sum2 sum3=&sum3;

%let x=%eval(2+2);
%put x=&x;
%let z=3;
%let x=%eval(&z+2);
%put x=&x;
%let x=%eval(&x+&z);
%put &x;

%let thisyr=2007;
%let lastyr=%eval(&thisyr-1);
%put thisyr=&thisyr  lastyr=&lastyr;
proc means data=orion.order_fact maxdec=2 min max mean;
   class order_type;
   var total_retail_price;
   where year(order_date) between &lastyr and &thisyr;
   title1 "Orders for &lastyr and &thisyr";
   title2 "(as of &sysdate9)";
run;


%let name=JUSTIN SHOWS;
%put name=&name;
%let name1=%sysfunc(propcase(&name));
%put name1=&name1;
%let varlist=alc bmi sbp diab chol chd;
%let numvars=%SYSFUNC(countw("&varlist"));
%put varlist=&varlist numvars=&numvars;

title1 "%sysfunc(today(),weekdate.)";
title2 "%sysfunc(time(),timeAMPM8.)";
data orders;
   set orion.Order_fact;
   where year(Order_Date)=2007;
   Lag=Delivery_Date - Order_Date;
run;
proc means data=orders maxdec=2 min max mean;
   class Order_Type;
   var Lag;
run;
title;

%let dietvars=PROTEIN   FAT TOTAL_CARBOHYDRATE Alcohol   CALCIUM PHOSPHORUS IRON SODIUM
 POTASSIUM SATURATED_FAT OLEIC_ACID      LINOLEIC_ACID CHOLESTEROL;
%put &dietvars;
%let varlist=%sysfunc(compbl(&dietvars));
%put &varlist;
%let varlist=%sysfunc(translate(&varlist,","," "));
%put &varlist;

%let str1=proc means data=orion.payroll min max;;
%put str1=&str1;

%let str1=proc means data=orion.payroll min max%str(;);
%let str2=%str(proc means data=orion.payroll min max;);
%put str1=&str1;
%put str2=&str2;

%let statement=%str(title "S&P 500";);
%put &statement;
%let statement=%nrstr(title "S&P 500";);
%put &statement;




