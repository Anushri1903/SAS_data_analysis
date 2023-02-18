/*01 Simulating Sampling Distributions with the Data Step*/
%let obs = 10;  /* size of each sample */
%let reps = 1000;  /* number of samples   */  
%let seed=54321;
 
data SimUni;
call streaminit(&seed);
do rep = 1 to &reps;
   do i = 1 to &obs;
      x = rand("Uniform");
      output;
   end;
end;
run;

proc means data=SimUni noprint;
   by rep;
   var x;
   output out=OutUni mean=MeanX;
run;
proc print data=outuni(obs=10);run;

proc means data=OutUni N Mean Std P5 P95;
   var MeanX;
run;
proc univariate data=OutUni;
   label MeanX = "Sample Mean of U(0,1) Data";
   histogram MeanX / normal;             
   ods select Histogram moments goodnessoffit;
run;

proc univariate data=OutUni noprint;
   var MeanX;
   output out=Pctl95 N=N mean=MeanX pctlpts=2.5 97.5 pctlpre=Pctl;
run;

proc print data=Pctl95 noobs; 
run;

proc sql;
  select sum(meanx>.7)/count(*) as prob
	from outuni;
quit;

%let obs = 31; 
%let reps = 10000; 
%let seed=54321;
 
data Normals(drop=i);
call streaminit(&seed);
do rep = 1 to &reps;
   do i = 1 to &obs;
      x = rand("Normal");
      output;
   end;
end;
run;

proc means data=Normals noprint;
   by rep;
   var x;
   output out=StatsNorm mean=SampleMean median=SampleMedian var=SampleVar;
run;

proc means data=StatsNorm Var;
   var SampleMean SampleMedian;
run;

proc sgplot data=StatsNorm;
   title "Sampling Distributions of Mean and Median for N(0,1) Data";
   density SampleMean /   type=kernel legendlabel="Mean";
   density SampleMedian / type=kernel legendlabel="Median";
   refline 0 / axis=x;
run;

/* scale the sample variances by (N-1)/sigma^2*/
%let N=&obs;
data OutStatsNorm;
   set StatsNorm;
   ScaledVar = SampleVar * (&N-1)/1; 
run;

/* Fit chi-square distribution to data */
proc univariate data=OutStatsNorm;
   label ScaledVar = "Variance of Normal Data (Scaled)";
   histogram ScaledVar / gamma(alpha=15 sigma=2);   
   ods select Histogram;
run;

/*The effect of sample size*/
%let reps = 1000;
%let seed=54321;

data SimUniSize;
call streaminit(&seed);
do obs = 10, 30, 50, 100;
   do rep = 1 to &reps;
      do i = 1 to obs;
         x = rand("Uniform");
         output;
      end;
   end;
end;
run;

proc means data=SimUniSize noprint;
   by obs rep;
   var x;
   output out=OutStats mean=SampleMean;
run;

proc print data=outstats(obs=10);
run;

proc means data=OutStats Mean Std;
   class obs;
   var SampleMean;
    run;

proc means data=OutStats noprint;
  class obs;
  var SampleMean;
  output out=out(where=(_TYPE_=1)) Mean=Mean Std=Std;
run;



/*02 Sampling Distributions of the Mean in IML*/

/*Complete code for data step version*/
%let obs = 10; 
%let reps = 1000; 
data uniforms;
call streaminit(54321);
do rep = 1 to &reps;
do i = 1 to &obs;
x = rand("Uniform");
output;
end;
end;
run;
proc means data=uniforms noprint;
by rep;
var x;
output out=MeansUni mean=Meanx;
run;
proc univariate data=meansuni;
label meanx = "Sample Mean of U(0,1) Data";
histogram Meanx / normal; 
ods select Histogram moments;
run;

%let obs = 10;
%let reps = 1000;
proc iml;
call randseed(54321);
x = j(&reps,&obs);       /* many samples (rows), each of size N */
call randgen(x, "Uniform");  /* 1. Simulate data                    */
s = x[,:];                   /* 2. Compute statistic for each row   */
Mean = mean(s);              /* 3. Summarize and analyze ASD        */
StdDev = std(s);
call qntl(q, s, {0.05 0.95});
print Mean StdDev (q`)[colname={"5th Pctl" "95th Pctl"}];
/* compute proportion of statistics greater than 0.7 */
Prob = mean(s > 0.7);
print Prob[format=percent7.2];
quit;

%let obs = 10;
%let reps = 1000;
proc iml;
call randseed(123);
x = j(&reps,&obs);       /* many samples (rows), each of size N */
call randgen(x, "Uniform");  /* 1. Simulate data*/
c="x1":"x&obs";
show c;
create unif from x [colname=c];
append from x;
close unif;
quit;
proc contents data=unif;
run;

%let obs=10;
data stats (keep=mean std max);
set unif;
mean=mean(of x1-x10);
std=std(of x1-x10);
max=max(of x:);
run;
proc means data=stats;
run;	
proc univariate data=stats;
var mean std max;
ods select qqplot;
qqplot mean std max;
run;








