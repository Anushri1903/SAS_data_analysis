%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname fram "&path/fram";
libname orion "&path/orion";

/*01 Data Step Merge Review*/
data htwt;
length id 8;
input height weight id @@;
datalines;
56.50 98  1  62.25 145 2  62.50 128 3 64.75 119 4 
68.75 144 5 60.00 117 6  58.00 125 7 
;
run;

data chol;
length id 8;
input chol id @@;
datalines;
234 1  172 2  248 3  215 4 
145 5  281 6  335 7 
;
run;

proc print data=htwt noobs;
run;

proc print data=chol noobs;
run;

data tot1;
  merge htwt chol;
	by id;
run;
proc print data=tot1 noobs;run;

proc sort data=htwt;
  by id;
run;

proc sort data=chol;
  by id;
run;

data tot1;
  merge htwt chol;
    by id;
run;

proc print data=tot1;
run;

data htwt;
input height weight id @@;
datalines;
56.50 98 1 62.25 145 2 62.50 128 3 
64.75 119 4 68.75 144 5 60.00 117 6 
63.00 156 9 63.00 134 10 
;
run;

data chol;
input chol id @@;
datalines;
215 1 145 2 281 3 335 4 196 7 
;
run;

proc print data=htwt noobs;
run;

proc print data=chol noobs;
run;

data tot4;
merge htwt(in=h) chol(in=c);
by id;
run;
proc print data=tot4 noobs;
run;

data tot3;
merge htwt chol;
run;
proc print data=tottmp;
run;

data tot5;
merge htwt(in=h) chol(in=c);
by id;
if h;
run;
proc print data=tot5 noobs;
run;

data tot6;
merge htwt(in=h) chol(in=c);
by id;
if c;
run;
proc print data=tot6 noobs;
run;

data tot6;
merge htwt(in=h) chol(in=c);
if h and c;
run;
proc print data=tot6 noobs;
run;

data htwt;
length id 8;
input height weight id @@;
datalines;
56.50 98 1 62.25 145 2 62.50 128 3 64.75 119 4  
68.75 144 5 60.00 117 6 63.00 156 9 63.00 134 10 
;
run;
data chol;
length id 8;
input chol id @@;
datalines;
215 1 145 2 281 3 335 4 196 7 
;
run;
data bp;
length id 8;
input dbp sbp id @@;
datalines;
83 125 1 73 108 4  71 108 5 79 116 6 
89 170 7 80 120 8 70 108 9 79 123 10 
;
run;

proc print data=htwt noobs;run;
proc print data=chol noobs;run;
proc print data=bp noobs;run;

proc sort data=bp;by id;run;
proc sort data=htwt;by id;run;
proc sort data=chol;by id;run;

data tot6;
  merge bp(in=b) htwt(in=h) chol(in=c);
    by id;
    if b and h and c;
run;
proc print data=tot6 noobs; run;

data chol1 (keep=sbp height chol id);
	length id 8;
   set fram.frex4(obs=15 );
	 where sbp ne . and height ne . and chol ne .;
	 id=_n_;
run;
data chol2 (obs=15 keep= chol id);
	call streaminit(12345);	 
	do id=1 to 15;
	 chol=int(rand("normal",240,40));
	 output;
	end;
run;
proc print data=chol1 noobs;run;
proc print data=chol2 noobs;run;

proc sort data=chol1;by id;run;
proc sort data=chol2;by id;run;
data totchol;
	merge chol1 chol2;
	by id;
run;
proc print data=totchol noobs;run;

data totchol2;
	merge chol2 chol1;
	by id;
run;
proc print data=totchol2 noobs;run;

/*02 Formatting Longitudinal Data*/
proc contents data=orion.qtr1;run;
proc contents data=orion.qtr2;run;
proc contents data=orion.qtr3;run;
proc contents data=orion.qtr4;run;

proc sort data=orion.qtr1 out=qtr1;by id;
proc sort data=orion.qtr2 out=qtr2;by id;
proc sort data=orion.qtr3 out=qtr3;by id;
proc sort data=orion.qtr4 out=qtr4;by id;

data wide;
merge qtr1(rename=(qtr=qtr1)) qtr2(rename=(qtr=qtr2)) qtr3(rename=(qtr=qtr3)) qtr4(rename=(qtr=qtr4)); 
by id;
run;

proc corr data=wide;
var qtr:;
run;

data long (keep=id quarter qtr);
  set qtr1 (in=a)
	 qtr2 (in=b) 
	 qtr3 (in=c) 
	 qtr4 (in=d); 
	if a then quarter=1;
	else if b then quarter=2;
	else if c then quarter=3;
	else if d then quarter=4;
run;

proc sort data=long;by id quarter;run;
proc print data=long noobs;run;

proc sgplot data=long;
series x=quarter y=qtr/group=id;
run;

proc sgplot data=long;
series x=quarter y=qtr/group=id markers;
run;

proc sgplot data=long;
series x=quarter y=qtr/group=id markers 
		markerattrs=(symbol=circlefilled);
run;

proc sgplot data=long;
series x=quarter y=qtr/group=id markers 
		markerattrs=(symbol=circlefilled size=12)
		lineattrs=(thickness=3);
run;

title "Spaghetti Plot for 15 Employees";
proc sgplot data=long;
series x=quarter y=qtr/group=id markers 
		markerattrs=(symbol=circlefilled size=12)
		lineattrs=(thickness=3);
run;
title;

title "Spaghetti Plot for 15 Participants";
proc sgplot data=long;
series x=quarter y=qtr/group=id markers 
		markerattrs=(symbol=circlefilled size=12)
		lineattrs=(thickness=3);
xaxis label="Quarter" labelattrs=(family=swiss weight=bold);
yaxis label="Donation" labelattrs=(family=swiss weight=bold);
run;
title;


/*03 Creating the Example Data Set*/
proc contents data=orion.employee_donations;
run;

/*select a random sample of size 15*/
proc surveyselect data=orion.employee_donations(keep=qtr1-qtr4)
	out=ftmp
	method=srs
	sampsize=15
	seed=54321
;
run;

/*assign a meaningless id*/
data ftmp;
	length id 8;
	set ftmp;
	id=_n_;
run;

proc print data=ftmp;run;

/*get rid of labels and formats*/
proc datasets lib=work memtype=data;
   modify ftmp;
     attrib _all_ label=' ';
     attrib _all_ format=;
quit;

/*do a random sort on data*/
data ftmp;
  set ftmp;
  call streaminit(5764313);
  ranx=rand("uniform");
  id=_n_;
run;

proc sort data=ftmp;by ranx;run;

/*create a separate file for each of the quarters*/
data 	qtr1(keep=id qtr1 rename=(qtr1=qtr))
		qtr2 (keep=id qtr2 rename=(qtr2=qtr))
		qtr3 (keep=id qtr3 rename=(qtr3=qtr))
		qtr4 (keep=id qtr4 rename=(qtr4=qtr)) 
		;
set ftmp;
output qtr1; 
output qtr2;
output qtr3;
output qtr4;
run;

proc contents data=qtr1;run;
proc contents data=qtr2;run;
proc contents data=qtr3;run;
proc contents data=qtr4;run;


