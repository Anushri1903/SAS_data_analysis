/*01 Defining Macro Variables in a Data Step*/
%let path=/courses/d649d56dba27fe300/STA5067/SAS Data;
libname orion "&path/orion";

/*This does not give us what we want*/
%let month=2;
%let year=2007;

data orders;
   keep order_date order_type quantity total_retail_price;
   set orion.order_fact end=final;
   where year(order_date)=&year and month(order_date)=&month;
   if order_type=3 then Number+1;
   if final then do;
      put Number=;
      if Number=0 then do;
         %let foot=No Internet Orders;
      	  end;
      else do;
         %let foot=Some Internet Orders;
      	  end;
      end;
run;

proc print data=orders;
   title "Orders for &month-&year";
   footnote "&foot";
run;

/*Replace the %let statements in the Data step with call symputx*/
%let month=2;
%let year=2007;

data orders;
   keep order_date order_type quantity total_retail_price;
   set orion.order_fact end=final;
   where year(order_date)=&year and month(order_date)=&month;
   if order_type=3 then Number+1;
   if final then do;
      put Number=;
      if Number=0 then do;
         call symputx('foot', 'No Internet Orders');
      end;
      else do;
         call symputx('foot', 'Some Internet Orders');
      end;
   end;
run;
proc print data=orders;
   title "Orders for &month-&year";
   footnote "&foot";
run;

%let month=1;
%let year=2007;

data orders; 
   keep order_date order_type quantity total_retail_price;
   set orion.order_fact end=final;
   where year(order_date)=&year and month(order_date)=&month;
   if order_type=3 then Number+1;
   if final then call symputx('num', Number);
run;

proc print data=orders;
   title "Orders for &month-&year";
   footnote "&num Internet Orders";
run;

%let month=1;
%let year=2007;

data orders (drop=last_order); 
   retain last_order 0;
   keep order_date order_type quantity total_retail_price;
   set orion.order_fact end=final;
   where year(order_date)=&year and month(order_date)=&month;
   if order_type=3 then do;
		Number+1;
		sumprice+total_retail_price;
		if order_date>last_order then last_order=order_date;
	end;
   if final then do;
	 call symputx('num', Number);
	 call symputx('avg',put(sumprice/number,dollar8.));
	 call symputx("last",put(last_order,mmddyy8.));
   end;
run;

proc print data=orders;
   title "Orders for &month-&year";
   footnote "&num Internet Orders";
   footnote2 "Average Internet Order: &avg";
   footnote3 "Last Internet Order: &last";
run;
title;footnote;

%let start=01Jan2007;
%let stop=31Dec2007;
proc means data=orion.order_fact noprint;
   where order_date between "&start"d and "&stop"d;
   var total_retail_price;
   output out=stats n=count mean=avg;
   run;
data _null_;
   set stats;
   call symputx('num_orders',count);
   call symputx('avg_order',put(avg,dollar8.2));
run;
%put Number of orders:  &num_orders;
%put Average price of orders: &avg_order;

%let start=01Jan2007;
%let stop=31Dec2007;
proc means data=orion.order_fact noprint;
   where order_date between "&start"d and "&stop"d;
   var total_retail_price;
   output out=stats n=count mean=avg;
   run;
data _null_;
   set stats;
   call symputx('Num_orders',count);
   call symputx('Avg_order',avg);
run;
%put Number of orders: &num_orders;
%put Average order price: &avg_order;

title "All orders between &start and &stop";
title2 "Number of orders: &num_orders";
title3 "Average order:  &avg_order";
proc print data=orion.order_fact ;
   where order_date between "&start"d and "&stop"d;
   var customer_id order_date order_id total_retail_price;
   run;
title;

/*02 Indirect Referencing of Macro Variables*/
/*hardcoding*/
proc print data=orion.order_fact;
   where customer_ID=9;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: 9";
   title2 "Customer Name: Cornelia Krahl";  
	
run;
title;footnote;

/*Table Lookup Application*/
%let custID=9;
proc print data=orion.order_fact;
   where customer_ID=&custID;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &custID";
   title2 "Customer Name: Cornelia Krahl";
run;
Title;

/*Step 3:  Add a DATA step to create a macro variable with the customer's name. 
Reference the macro variable in TITLE2.*/
%let custID=9;

data _null_;
   set orion.customer;
   where customer_ID=&custID;
   call symputx('name', Customer_Name);
run;

proc print data=orion.order_fact;
   where customer_ID=&custID;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &custID";
   title2 "Customer Name: &name";
run;

%let custID=9;
data _null_;
   set orion.customer;
   call symputx('name', Customer_Name);
run;
proc print data=orion.order_fact;
   where customer_ID=&custID;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &custID";
   title2 "Customer Name: &name";
run;

data _null_;
   set orion.customer;
   call symputx('name'||left(Customer_ID),customer_Name);
run;

%put _user_;

%let custID=9;
proc print data=orion.order_fact;
   where customer_ID=&custID;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &custID";
   title2 "Customer Name: &name9";
run;

%let custID=9;
proc print data=orion.order_fact;
   where customer_ID=&custID;
   var order_date order_type quantity total_retail_price;
   title1 "Customer Number: &custID";
   title2 "Customer Name: &&name&custID";
run;
title;

/*03 Retrieving Macro Variables in Data Step*/
data _null_;
   set orion.customer;
   call symputx('name'||left(Customer_ID), 
		     customer_Name);
run;

%put _user_;

data InternetCustomers;
   keep order_date customer_ID customer_name;
   set orion.order_fact;
   if order_type=3;
   length Customer_Name $ 20;
   Customer_Name=symget('name'||left(customer_ID));                     
run;

proc print data=InternetCustomers;
   var order_date customer_ID customer_name;
   title "Internet Customers";
run;







