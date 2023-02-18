%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname nh9ques "&path/nhanes1999/questionnaire";
libname nh9lab "&path/nhanes1999/lab";
libname nh9exam "&path/nhanes1999/exam";
libname nh9demo "&path/nhanes1999/demographics";
libname nh9diet "&path/nhanes1999/dietary";

libname nh9 (nh9demo nh9exam nh9lab nh9ques);



proc sql; 
	describe table dictionary.tables
	;
	select memname,nvar,nobs
	from dictionary.tables
	where libname="NH9"
	;
quit;

proc contents data=nh9.bloodpressure;
proc contents data=nh9.demographics;
proc contents data=nh9.bodymeasurements;
proc contents data=nh9.cholesterolhdl;
run;

proc sql inobs=100;
select mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4),BPXSar
from nh9.bloodpressure
;
quit;

proc sql ;
	create table newbp as
	select mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4) as mnsbp,
       mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4) as mndbp,
	   seqn
	from nh9.bloodpressure
	;
	select n(mnsbp) "mnsbp",n(mndbp) "mndbp"
	from newbp
	;
quit;

data newbp( drop=bpxsy1-bpxsy4 bpxdi1-bpxdi4);
  set nh9.bloodpressure(keep=seqn bpxsy1-bpxsy4 bpxdi1-bpxdi4);
  mnsbp=mean(of BPXSY1-BPXSY4);
  mndbp=mean(of BPXDI1-BPXDI4);
run;
proc means data=newbp;
run;


proc means data=nh9.demographics;
var ri: seqn;
run;


data newbp(drop=bpxsy1-bpxsy4 BPXDI1-BPXDI4);
  set nh9.bloodpressure(keep=seqn bpxsy1-bpxsy4 BPXDI1-BPXDI4);
  mnsbp=mean(of BPXSY1-BPXSY4);
  mndbp=mean(of BPXDI1-BPXDI4);
data demog (drop=riagendr);
	set nh9.demographics (keep=seqn ridageyr riagendr RIDRETH2);
	male=riagendr=1;
	rename	ridageyr=age
			ridreth2=race_ethn;
data chol;
	set nh9.cholesterolhdl(keep= seqn LBDHDL LBXTC);
	rename	lbdhdl=hdl
		lbxtc=chol;
data body;
	set nh9.bodymeasurements(keep=seqn bmxbmi rename=(bmxbmi=bmi));
run;


proc sort data=newbp;by seqn;run;
proc sort data=demog;by seqn;run;
proc sort data=chol;by seqn;run;
proc sort data=body;by seqn;run;
data analysis;
	merge newbp(in=b) demog(in=c) chol(in=d) body(in=e);
	by seqn;
	if b and c and d and e;
run;

proc contents data=analysis;
run;

proc sql;
	create table analysis as
	select	b.seqn, mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4) as mnsbp,
			mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4) as mndbp,
			riagendr=1 as male,
			ridageyr as age,
			ridreth2 as race_ethn,
			lbdhdl as hdl,
			lbxtc as chol,
			bmxbmi as bmi
	from 	nh9.bloodpressure(keep=seqn bpxsy1-bpxsy4 BPXDI1-BPXDI4) b,
			nh9.demographics (keep=seqn ridageyr riagendr RIDRETH2) c,
			nh9.bodymeasurements(keep=seqn bmxbmi) d,
			nh9.cholesterolhdl(keep= seqn LBDHDL LBXTC) e
	where	b.seqn=c.seqn and
			c.seqn=d.seqn and
			d.seqn=e.seqn
	order by seqn
	;
quit;