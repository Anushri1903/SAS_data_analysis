/*01 Simulating Univariate Distributions with the Data Step*/
%let obs=10;
%let seed=54321;
data tmp;
do i=1 to &obs;
	x=rand("uniform");
	output;
end;
run;
proc print data=tmp;run;

data uniforms(drop=i);
	call streaminit(45321);
	do i=1 to 1000000;
		x=ceil(10*rand("uniform"));
		output;
	end;
run;
proc freq data=uniforms ;
tables x/chisq plots=none;
run;

data uniforms2;
	set uniforms;
	x1=lag(x);
run;
proc corr data=uniforms2;
run;

data rand (drop=i);
call streaminit(54321);
	do i=1 to 1000000;
		x=rand("Uniform");
		output;
	end;
run;
proc sort data=rand out=tmp nodupkeys;
by x;
run;

%let seed=54321;/*i=372,972,159*/
%let seed=654321;/*i=1,715,805,341*/
%let seed=321;/*i=2,369,593,872*/
%let seed=1;/*i=2,320,193,736*/
data _null_;
call streaminit(&seed);
x0=rand("Uniform");
do until (x=x0);
i+1;
x=rand("Uniform");
end;
put "i=" i ;
run;

%let seed=754313;
%let numobs=10000;
data normals;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("normal");
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=normals;
var x;
histogram x/normal;
run;

%let seed=754313;
%let numobs=10000;
data chisquares;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("chisq",4);
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=chisquares;
var x;
histogram x/gamma;
run;

%let seed=754313;
%let numobs=10000;
data chisquares;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("chisq",4);
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=chisquares;
var x;
histogram x/gamma(alpha=2,sigma=2);
run;

%let seed=754313;
%let numobs=10000;
data chisquares;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("chisq",4);
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=chisquares;
var x;
histogram x/gamma(alpha=2,sigma=2) kernel(color=red);
run;

%let seed=754313;
%let numobs=10000;
data exponentials;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("exponential");
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=exponentials;
var x;
histogram x/exponential kernel(color=red);
run;

%let seed=754313;
%let numobs=10000;
data exponentials(drop=i);
	call streaminit(&seed);
	do i=1 to &numobs;
		x=5*rand("exponential");
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=exponentials;
var x;
histogram x/exponential kernel(color=red);
run;
proc means data=exponentials n std mean; run;

%let seed=754313;
%let numobs=10000;
data exponentials;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("weibull",1,.2);
		output;
	end;
run;
ods select histogram goodnessoffit;
proc univariate data=exponentials;
var x;
histogram x/exponential kernel(color=red);
run;

%let seed=754313;
%let numobs=10000;
data bernoullis;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("bernoulli",.25);
		output;
	end;
run;
proc freq data=bernoullis;
tables x;
run;

%let seed=754313;
%let numobs=10000;
data binomials;
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("binomial",.25,12);
		output;
	end;
run;
proc freq data=binomials;
tables x;
run;
proc means data=binomials;
var x;
run;

%let seed=754313;
%let numobs=10000;
data poissons(drop=i);
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("poisson",10);
		output;
	end;
run;
proc means data=poissons;
run;

%let seed=754313;
%let numobs=10000;
data tabular(drop=i);
	call streaminit(&seed);
	do i=1 to &numobs;
		x=rand("table",.2,.3,.1,.4);
		output;
	end;
run;
proc freq data=tabular;
run;

/*02 Simulating Univariate Distributions with IML*/
%let obs=100000000;
%let seed=34561;
data tmp;
  call streaminit(&seed);
  do i=1 to &obs;
  	x=rand("normal");
	output;
  end;
run;
proc iml;
  t0=time();
  call randseed(&seed);
  x=j(&obs,1,.);
  call randgen(x,"normal");
  t1=time()-t0;
  print t1 ;
quit;

%let obs=10000;
%let seed=34561;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"normal");
  create temp var {x};
  append from x;
  close temp; /*necessary to allow access*/
  submit;
	ods select histogram goodnessoffit;
	proc univariate data=temp;
	var x;
	histogram x/normal;
	run;
  endsubmit; 
quit;

%let obs=10000;
%let seed=54321;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"chisq",4);
  create temp var {x};
  append from x;
   close temp; /*necessary to allow access*/
quit;

ods select histogram goodnessoffit;
proc univariate data=temp;
var x;
histogram x/gamma(alpha=2,sigma=2) kernel(color=red);
run;

%let obs=10000;
%let seed=34561;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"exponential");
  create temp var {x};
  append from x;
   close temp; 
quit;
ods select histogram goodnessoffit;
proc univariate data=temp;
var x;
histogram x/exponential ;
run;

%let obs=10000;
%let seed=54321;
proc iml;
  t0=time();
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"weibull",2,.2);
  t1=time()-t0;
  print t1 ;
  create temp var {x};
  append from x;
   close temp; /*necessary to allow access*/
quit;

ods select histogram goodnessoffit;
proc univariate data=temp;
var x;
histogram x/weibull; 
run;

%let obs=10000;
%let seed=54321;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"bernoulli",.25);
  create temp var {x};
  append from x;
   close temp; /*necessary to allow access*/
quit;

proc freq data=temp;
tables x;
run;

%let obs=10000;
%let seed=54321;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"binomial",.25,12);
  create temp var {x};
  append from x;
   close temp; /*necessary to allow access*/
quit;

proc freq data=temp;
tables x;
run;
proc means data=temp;
var x;
run;

%let obs=10000;
%let seed=54321;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  call randgen(x,"poisson",10);
  create temp var {x};
  append from x;
   close temp; /*necessary to allow access*/
quit;


proc means data=temp;
var x;
run;

%let obs=10000;
%let seed=54321;
proc iml;
  x=j(&obs,1,.);
  call randseed(&seed);
  prob={.2,.3,.1,.4};
  call randgen(x,"table",prob);
  create temp var {x};
  append from x;
   close temp; /*necessary to allow access*/
quit;
proc freq data=temp;
tables x;
run;
