title "Read in data";
/*2018 data*/
FILENAME REFFILE '/####/#####/2018Sep.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; 
RUN;


/*2019 data*/
FILENAME REFFILE '/####/####/2019Sep.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; 
RUN;


data Ad2018;
 set work.import;
 Display_Spend2=input(Display_Spend, comma14.);
 Social_Display_Spend2=input(Social_Display_Spend, comma14.);
 keep Company_Num Entity_Type Company Category Impressions Non_Buy_Impressions 
      Display_Spend2 Social_Display_Spend2 Unique_Visitor;
 rename Display_Spend2 = Display_Spend
        Social_Display_Spend2 = Social_Display_Spend;
run;

data Ad2019;
 set work.import1;
 Display_Spend2=input(Display_Spend, comma14.);
 Social_Display_Spend2=input(Social_Display_Spend, comma14.);
 keep Company_Num Entity_Type Company Category Impressions Non_Buy_Impressions 
      Display_Spend2 Social_Display_Spend2 Unique_Visitor;
 rename Display_Spend2 = Display_Spend
        Social_Display_Spend2 = Social_Display_Spend;
run;
title;
/*********************************************************/

title "Clean missing values (2018)";
data Ad2018_cleaned;
 set Ad2018;
 IF Company_Num = '' then delete;
 IF Entity_Type = '' then delete;
 IF Company = '' then delete;
 IF Category = '' then delete;
 IF Impressions = '' then delete;
 IF Non_Buy_Impressions = '' then delete;
 IF Display_Spend = '' then delete;
 IF Unique_Visitor = '' then delete;
 IF Social_Display_Spend = '' then delete;
run;
title;

title "Validate cleaning (2018): no missing values detected";
proc print data=Ad2018_cleaned;
 where Company_Num is missing or
       Entity_Type is missing or
       Company is missing or
       Category is missing or
       Impressions is missing or
       Non_Buy_Impressions is missing or
       Display_Spend is missing or
       Unique_Visitor is missing or
       Social_Display_Spend is missing;
run;
title;

title "Check for extreme values (2018): no anormalies detected";
ods select extremeobs;
proc univariate data=Ad2018_cleaned;
 var Impressions Non_Buy_Impressions Display_Spend
     Unique_Visitor Social_Display_Spend;
run;
title;
/*********************************************************/

title "Clean missing values (2019)";
data Ad2019_cleaned;
 set Ad2019;
 IF Company_Num = '' then delete;
 IF Entity_Type = '' then delete;
 IF Company = '' then delete;
 IF Category = '' then delete;
 IF Impressions = '' then delete;
 IF Non_Buy_Impressions = '' then delete;
 IF Display_Spend = '' then delete;
 IF Unique_Visitor = '' then delete;
 IF Social_Display_Spend = '' then delete;
run;
title;

title "Validate cleaning (2019): no missing values detected";
proc print data=Ad2019_cleaned;
 where Company_Num is missing or
       Entity_Type is missing or
       Company is missing or
       Category is missing or
       Impressions is missing or
       Non_Buy_Impressions is missing or
       Display_Spend is missing or
       Unique_Visitor is missing or
       Social_Display_Spend is missing;
run;
title;

title "Check for extreme values (2019): no anormalies detected";
ods select extremeobs;
proc univariate data=Ad2019_cleaned;
 var Impressions Non_Buy_Impressions Display_Spend
     Unique_Visitor Social_Display_Spend;
run;
title;
/*********************************************************/
/*********************************************************/
/*********************************************************/

/********************************ANALYSIS: SECTION 1***********************************/
title "Analysis of Display_Ad_Impressions in the category of insurance";
proc means data=Ad2018_cleaned mean median max min;
 title3 "2018";
 var Impressions;
 where Category = "Insurance";
run;

proc means data=Ad2019_cleaned mean median max min;
 title3 "2019";
 var Impressions;
 where Category = "Insurance";
run;
title;

/*********************************************************/
title "Analysis of Display_Ad_Impressions for all categories in 2018";
proc means data=Ad2018_cleaned mean median max min;
 class category;
 var Impressions;
 ods output Summary = cat2018;
run;

proc sort data=cat2018;
 by descending impressions_mean;
run;

proc print data=cat2018 (obs=10);
run;
title;

title "Analysis of Display_Ad_Impressions for all categories in 2019";
proc means data=Ad2019_cleaned mean median max min;
 class category;
 var Impressions;
 ods output Summary = cat2019;
run;

proc sort data=cat2019;
 by descending impressions_mean;
run;

proc print data=cat2019 (obs=10);
run;
title;

/********************************ANALYSIS: SECTION 2***********************************/
title "Analysis for insurance field 2019";
data insurance2019;
	set Ad2019_cleaned;
	IF Category ^= 'Insurance' then delete;
	value = unique_visitor/(display_spend + social_display_spend);/*add a new variable "value"*/
run;

proc univariate data = insurance2019;
	var unique_visitor;
run;

proc sort data = insurance2019;
	by descending unique_visitor;
run;	

proc print data = insurance2019(obs = 5);
	by descending unique_visitor;
run;

proc sort data = insurance2019;
	by descending value;
run;
	
proc print data = insurance2019(obs = 5);
	by descending value;
run;
title;

title "Analysis for insurance field 2018";
data insurance2018;
	set Ad2018_cleaned;
	IF Category ^= 'Insurance' then delete;
	value = unique_visitor/(display_spend + social_display_spend);
run;

proc univariate data = insurance2018;
	var unique_visitor;
run;

proc sort data = insurance2018;
	by descending unique_visitor;
run;	

proc print data = insurance2018(obs = 5);
	by descending unique_visitor;
run;

proc sort data = insurance2018;
	by descending value;
run;
	
proc print data = insurance2018(obs = 5);
	by descending value;
run;
title;

/********************************ANALYSIS: SECTION 3***********************************/
data Amazon_2019;
	set Ad2019_cleaned;
	where Company_Num=1;
	keep Company Category 
		Impressions Non_buy_impressions Display_Spend 
		Unique_Visitor Social_Display_Spend;	
run;

data Amazon_2018;
	set Ad2018_cleaned;
	where Company_Num=5;
	keep Company Category 
		Impressions Non_buy_impressions Display_Spend 
		Unique_Visitor Social_Display_Spend;
run;


proc sort data=Amazon_2019 ;
	by Category;
run;

proc sort data=amazon_2018;
	by Category;
run;

data Amazon;
	merge Amazon_2019 Amazon_2018;
run;

proc means data=amazon sum max min;
	class Category;
run;
	
/********************************ANALYSIS: SECTION 4***********************************/
/*subset Google*/
data Google_2019;
 set Ad2019_cleaned;
 where Company_Num=14;
 keep Company_Num Company Category 
  Impressions Non_buy_impressions Display_Spend 
  Unique_Visitor Social_Display_Spend; 
run;  

data Google_2018;
 set Ad2018_cleaned;
 where Company_Num=13;
 keep Company_Num Company Category 
  Impressions Non_buy_impressions Display_Spend 
  Unique_Visitor Social_Display_Spend; 
run;  

proc sort data=Google_2019 ;
 by Category;
run;

proc sort data=Google_2018;
 by Category;
run;

/* select the category that has the most ad impressions*/
proc sql;
  select distinct Company, Category,Impressions,
  sum(Impressions) as sum label='Sum of Impressions' format=comma14.2, 
  max(Impressions) as max label='Max of Impressions' format=comma14.2, 
  min(Impressions) as min label='Min of Impressions' format=comma14.2,
  avg(Impressions) as avg label='Avg of Impressions' format=comma14.2
  from Google_2018
  group by Category;
quit;


proc sql;
  title "2018";
  select distinct Company, Sum
  from (select Company,sum(Impressions) as sum label='Sum of Impressions' format=comma14.2
       from Google_2018
       group by Company)
   having Sum=max(Sum);
quit;

proc sql;
  select distinct Company, Category,Impressions,
  sum(Impressions) as sum label='Sum of Impressions' format=comma14.2, 
  max(Impressions) as max label='Max of Impressions' format=comma14.2, 
  min(Impressions) as min label='Min of Impressions' format=comma14.2,
  avg(Impressions) as avg label='Avg of Impressions' format=comma14.2
  from Google_2019
  group by Category;
quit;

proc sql;
  title "2019";
  select distinct Company, Sum
  from (select Company,sum(Impressions) as sum label='Sum of Impressions' format=comma14.2
       from Google_2019
       group by Company)
   having Sum=max(Sum);
quit;














