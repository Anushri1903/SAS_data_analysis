/*00 Proc Sort*/
data exsort;
input id age gender $ @@;
datalines;
1 35 M 7 44 F 3 27 M
2 23 M 5 33 F 6 29 F
;
run;
proc print;run; /*why does this work?*/

proc sort data=exsort out=sorted;  
/*out= creates a new dataset*/
by id;
run;
title "Data sorted by id";
proc print data=sorted;
run;
title;

proc sort data=exsort out=sort1;
by gender;
run;

title "Unsorted Data";
proc print data=exsort;
run;

title "Data sorted by gender";
proc print data=sort1;
run;

title;

title "Original data";
proc print data=exsort;
run;

proc sort data=exsort; 
 /*original data are replaced with sorted version*/
by age;
run;

title "Original dataset, after sort by age";
proc print data=exsort;
run;

title;

proc sort data=exsort; 
 /*original data are replaced with sorted version*/
by age;
run;

title "Original dataset, after sort by age";
proc print data=exsort;
run;

title;


proc sort data=exsort;
by descending age ;  /*in reverse order*/
run;

title "Original dataset, sort by age in descending order";
proc print data=exsort;
run;

title;

data exsort;
   input id age sbp @@;
datalines;
1 35 122 8 35 118 9 35 135  7 44 121
10 44 115 3 27 122 11 27 114 12 27 118
;
run;
proc print data=exsort;
run;

proc sort data=exsort out=ex1;
by age sbp;
run;

title "Original Data";
proc print data=exsort;
run;

title "Sorted by age and sbp within age";
proc print data=ex1;
run;

title;

proc sort data=exsort out=ex2;
by sbp age;
run;

title "Original Data";
proc print data=exsort;
run;

title "Sorted by sbp and age with sbp";
proc print data=ex2;
run;
Title;

proc sort data=exsort out=ex3;
by descending age sbp;
run;

title "Sorted by descending age and sbp within age";
proc print data=ex3;
run;

title;

/*02 Concatenating SAS Data Sets*/
/*create example data*/
data data1;
input height weight id @@;
datalines;
56.50 98 1 62.25 145 2  62.50 128 3  64.75 119 4  68.75 144 5 
;
run;

proc print data=data1 noobs;
title "Data1";
run;

data data2;
input height weight id @@;
datalines;
60 117 6  58 125 7  59 149 8  63 156 9  63 134 10 
;
run;

proc print data=data2 noobs;
title "Data2";
run;
title;

data data3;
	set data1 data2;
run;
proc print data=data3;run;

/*create example data*/
data data4;
input ht wt id @@;
datalines;
56.50 98 1 62.25 145 2  62.50 128 3  64.75 119 4  68.75 144 5 
;
run;

proc print data=data4 noobs;
title "Data4";
run;

data data5;
input height weight id @@;
datalines;
60 117 6  58 125 7  59 149 8  63 156 9  63 134 10 
;
run;

proc print data=data5 noobs;
title "Data5";
run;
title;

data data6;
	set data4 data5;
run;
proc print data=data6;
title "Data6";
run;
title;

data total;
  set data1 
	data4(rename=(wt=weight ht=height)) data5;
run;
proc print data=total;
run;

data total(rename=(weight=wt height=ht));
  set data1 
	data4(rename=(wt=weight ht=height)) data5;
run;
proc print data=total;
run;

/*five copies of data1*/
data five;
	set data1 data1 data1 data1 data1;
run;
proc print data=five noobs;
title "Five copies of data1";
run;
title;


/*03 Proc Append */
data master;
input height weight id @@;
datalines;
56.50 98 1 62.25 145 2  62.50 128 3  64.75 119 4  68.75 144 5 
;
run;

proc print data=master noobs;
run;

data newdata;
input height weight id @@;
datalines;
60 117 6  58 125 7  59 149 8  63 156 9  63 134 10 
;
run;

proc print data=newdata noobs;
run;

/*Appending a new dataset to an existing dataset*/

proc append base=master data=newdata;
run;

proc print data=master;
run;
proc print data=newdata;
run;

/*master1 and newdata1 have different variables
   note the log message*/
data master1;
input height weight chol id @@;
datalines;
56.50 98 234 1 
62.25 145 172 2 
62.50 128 248 3 
64.75 119 215 4 
68.75 144 145 5 
;
run;

data newdata1;
input height weight id;
datalines;
60 117 6 
58 125 7 
59 149 8 
63 156 9 
63 134 10 
;
run;

proc append base=master1 data=newdata1;
run;

proc print data=master1;
run;

/*note difference in log message*/

data m1;
 set master1;
run;

data nd1;
  set newdata1;
run;

proc append base=nd1 data=m1;/*note reversal or roles*/
run;

proc print data=nd1;
run;

data newdata2;
input height weight chol id @@;
datalines;
56.50 98 234 1  62.25 145 172 2 62.50 128 248 3 
64.75 119 215 4 68.75 144 145 5  
;
run;

data master2;
input height weight id @@;
datalines;
60 117 6  58 125 7  59 149 8  63 156 9  63 134 10 
;
run;
proc append base=master2 data=newdata2 force;
run;

proc print data=master2;
run;

/*04 Merging One-to-One*/
data htwt;
input height weight id @@;
datalines;
56.50 98  1  62.25 145 2  62.50 128 3 64.75 119 4 
68.75 144 5 60.00 117 6  58.00 125 7 
;
run;

data chol;
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

/*positional merging*/
data positionalmerge;
  merge htwt chol;
run;
proc print data=positionalmerge;
run;

proc sort data=htwt;
  by id;
run;

proc sort data=chol;
  by id;
run;

data total;
  merge htwt chol;
    by id;
run;

proc print data=htwt;
run;

proc print data=chol;
run;

proc print data=total;
run;

data htwt;
input height weight id @@;
datalines;
56.50 98 1  62.50 128 3  64.75 119 4  68.75 144 5 
60.00 117 6  63.00 156 9  63.00 134 10 
;
run;

data chol;
input chol id @@;
datalines;
215 1  145 2  281 3  335 4  196 7 
;
run;

proc print data=htwt noobs;
run;

proc print data=chol noobs;
run;

data total;
merge htwt chol;
by id;
proc print data=total;
run;

/*forgotten by variable*/
data total;
merge htwt chol;
run;
proc print data=htwt;run;
proc print data=chol;run;
proc print data=total;
run;

data htwt;
input height weight id @@;
datalines;
56.50 98 1 62.25 145 2 62.50 128 3 64.75 119 4  68.75 144 5 60.00 117 6 63.00 156 9 63.00 134 10 
;
run;
data chol;
input chol id @@;
datalines;
215 1 145 2 281 3 335 4 196 7 
;
run;
data bp;
input dbp sbp id @@;
datalines;
83 125 1 73 108 4  71 108 5 79 116 6 
89 170 7 80 120 8 70 108 9 79 123 10 
;
run;

data total;
	merge htwt chol bp;
	by id;
run;
proc print data=total;
run;

proc sort data=bp;
   by id;
run;

proc sort data=htwt;
  by id;
run;

proc sort data=chol;
  by id;
run;

data total;
  merge bp htwt chol;
    by id;
run;

proc print data=bp   noobs;
run;

proc print data=htwt   noobs;
run;

proc print data=chol noobs;
run;

proc print data=total  noobs ;
run;

data tmp1;
input x @@;
id=_n_;
datalines;
1  1  1  1  1
;

data tmp2;
input x @@;
id=_n_;
datalines;
2  2  2  2  2
;

proc print data=tmp1;
run;

proc print data=tmp2;
run;

proc sort data=tmp1;
  by id;
run;

proc sort data=tmp2;
  by id;
run;

data tot1;
  merge tmp2 tmp1;
	  by id;
run;

proc print data=tot1 noobs;
run;

data tmp1;
input x;
id=_n_;
datalines;
1
1
1
1
1
;

data tmp2;
input x;
id=_n_;
datalines;
2
2
2
2
2
;

proc sort data=tmp1;
  by id;
run;

proc sort data=tmp2;
  by id;
run;
/*note difference from version 1*/
data tot2;
  merge tmp1 tmp2;
	  by id;
run;

proc print data=tot2 noobs;
run;

data htwt;
input height weight id;
datalines;
56.50 98 1 
62.25 145 2 
62.50 128 3 
64.75 119 4 
68.75 144 5 
60.00 117 6 
63.00 156 9 
63.00 134 10 
;
run;

data chol;
input chol id1;
datalines;
215 1 
145 2 
281 3 
335 4 
196 7 
;
run;
proc sort data=chol;
  by id1;
run;

proc sort data=htwt;
  by id;
run;

data total;
  merge chol(rename =(id1=id))  htwt;
    by id;

proc print data=total;
run;

data chol;
input chol id1;
datalines;
215 1 
145 2 
281 3 
335 4 
196 7 
;
run;

data chol;
  set chol;
  rename id1=id;/*this is the last thing done by data step*/
run;

proc sort data=chol;
  by id;
run;

proc sort data=htwt;
  by id;
run;

data total;
  merge chol htwt;
    by id;

proc print data=total;
run;

data htwt;
input height weight id;
datalines;
56.50 98 1 
62.25 145 2 
62.50 128 3 
64.75 119 4 
68.75 144 5 
60.00 117 6 
63.00 156 9 
63.00 134 10 
;
run;

data chol;
input chol id;
datalines;
215 1 
145 2 
281 3 
335 4 
196 7 
;
run;

********** IN= Option Matches Only **********;
data total;
   merge htwt(in=onhtwt) 
         chol(in=onchol);
   by id;
   /*intersection of htwt and chol*/
   if onhtwt=1 and onchol=1;
run;

proc print data=htwt;
run;

proc print data=chol;
run;

proc print data=total;
run;

data htwt;
input height weight id;
datalines;
56.50 98 1 
62.25 145 2 
62.50 128 3 
64.75 119 4 
68.75 144 5 
60.00 117 6 
63.00 156 9 
63.00 134 10 
;
run;

data chol;
input chol id;
datalines;
215 1 
145 2 
281 3 
335 4 
196 7 
;
run;

********** IN= Option non-Matches Only **********;
data total;
   merge htwt(in=onhtwt) 
         chol(in=onchol);
   by id;
   /*observations only in one data set*/
   if onhtwt ne 1 or onchol ne 1;
run;

proc print data=htwt;
run;

proc print data=chol;
run;

proc print data=total;
run;

data htwt;
input height weight id;
datalines;
56.50 98 1 
62.25 145 2 
62.50 128 3 
64.75 119 4 
68.75 144 5 
60.00 117 6 
63.00 156 9 
63.00 134 10 
;
run;

data chol;
input chol id;
datalines;
215 1 
145 2 
281 3 
335 4 
196 7 
;
run;

********** IN= Option to create three datasets **********;
data onboth htwtonly cholonly;
   merge htwt(in=onhtwt) 
         chol(in=onchol);
   by id;
   if onhtwt = 1 and onchol = 1 then output onboth;
	 if onhtwt =1 and onchol =0 then output htwtonly;
	 if onhtwt=0 and onchol=1 then output cholonly;
run;

proc print data=onboth noobs;
run;

proc print data=cholonly noobs;
run;

proc print data=htwtonly noobs;
run;


data htwt;
input height weight id;
datalines;
56.50 98 1 
62.25 145 2 
62.50 128 3 
64.75 119 4 
68.75 144 5 
60.00 117 6 
63.00 156 9 
63.00 134 10 
;
run;

data chol;
input chol id;
datalines;
215 1 
145 2 
281 3 
335 4 
196 7 
;
run;

********** IN= Option to tabulate completeness **********;
data total;
   merge htwt(in=onhtwt) 
         chol(in=onchol);
   by id;
onht=onhtwt;
onch=onchol;
run;


proc freq data=total;
tables onht*onch/norow nocol nopercent;
run;

/*05 Interleaving SAS Data Sets*/
data tmp1;
	length id height weight 8;
  input height weight id @@;
datalines;
56.50 98 1 62.25 145 2 62.50 128 3 64.75 119 4 68.75 144 5 
60.00 117 6 58.00 125 7 59.00 149 8 63.00 156 9 63.00 134 10 
58.00 105 11 65.75 151 12 64.50 185 13 67.50 144 14 59.25 156 15 
63.00 186 16 65.25 128 17 64.50 166 18 62.00 156 19 61.25 137 20 
63.25 150 21 61.00 142 22 58.50 131 23 63.50 182 24 61.50 107 25 
60.50 96 26 62.50 137 27 63.75 136 28 64.50 133 29 65.25 149 30 
66.25 137 31 59.00 95 32 65.75 138 33 57.50 165 34 69.00 162 35 
63.00 156 36 62.00 168 37 62.25 195 38 61.50 131 39 60.75 165 40 
60.75 122 41 62.50 142 42 62.00 106 43 58.50 136 44 62.25 127 45 
;
run;
proc print data=tmp1 noobs;
run;

data odd even;
  set tmp1;
    if mod(id,2) = 0 then output even;
	  else output odd;
run;

proc print data=odd noobs;
title "Odd numbered id's";
run;

proc print data=even noobs;
title "Even numbered id's";
run;

data tot;
  set odd even;
by id;
run;

proc print data=tot noobs;
title "Data sets odd and even, interleaved";
run;
title;









