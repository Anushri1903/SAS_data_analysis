libname ref '/courses/d649d56dba27fe300/STA5066' access=readonly;
proc contents data=ref.budget;
run;

proc contents data=ref._all_;
run;

proc contents data=ref.budget position;
run;

proc contents data=ref._all_ nods;
run;

proc contents data=ref._all_ nods details;
run;

proc contents data=ref.customer_dim position details;
run;

proc print data=ref.customer_dim;
run;

/* (obs= ) restricts the number of rows*/
proc print data=ref.customer_dim (obs=5) noobs;
   var customer_id customer_gender;
run;

data temp;
  data5mon=3;
  5monthsdata=3;
  data#5=3;
  five months data=3;
  five_months_data=3;
  FiveMonthsData=3;
run;

proc print data=temp;
run;

data temp;
      var=3;
	 VAR=5;
	 firstname="Dan";
	 output;
	 FirstName="Peter";
	 output;
	 firSTnAME="Sam";
	 output;
run;

proc print data=temp;
run;

proc contents data=ref.nhanes1_5066;
run;

proc freq data=ref.nhanes1_5066;
tables activ;
run;

proc means data=ref.nhanes1_5066 n nmiss mean;
var chol;
run;

data work.dates;
   	 dateorigin=mdy(1,1,1960);
	 daybefore=mdy(12,31,1959);
	 dayafter=mdy(1,2,1960);
	 earlydate=mdy(12,7,1941);
	 turnofcentury=mdy(1,1,2000);
run;

proc print data=dates;
run;










