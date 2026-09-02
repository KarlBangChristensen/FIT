* evaluate;
libname FIT 'P:\FIT';

%let nitems=10;
proc contents data=FIT.out_PW_I&nitems.;
run;
data new;
	set FIT.out_PW_I&nitems.;
	item_no=substr(item,5,2)*1;
	under=(fitresid<-2.5);
	over=(fitresid>2.5);
run;
title 'FitResid empirical null distribution based on 2000 data sets simulated under the Rasch model';
proc sql;
	select 
		item, 
		mean(fitresid) as mean format 8.2, 
		std(fitresid) as SD format 8.2, 
		/*sum(over) as over,*/ 100*mean(over) as percent_over format 8.1, 
		/*sum(under) as under,*/ 100*mean(under) as percent_under format 8.1
	from new
	where N=300
	group by item;
quit;
proc sql;
	create table extremes as
	select 
		sim, 
		N,
		max(fitresid) as max, 
		min(fitresid) as min
	from new
	group by sim, N;
quit;
data extremes;
	set extremes;
	under=(max<-2.5);
	over=(max>2.5);
run;
title 'min(FitResid) empirical null distribution based on 2000 data sets simulated under the Rasch model';
proc sql;
	select 
		mean(min) as mean format 8.2 label='k', 
		std(min) as SD format 8.2, 
		/*sum(under) as under,*/ 100*mean(under) as percent_under format 8.1
	from extremes
	where N=300;
quit;
title 'max(FitResid) empirical null distribution based on 2000 data sets simulated under the Rasch model';
proc sql;
	select 
		mean(max) as mean format 8.2 label='k', 
		std(max) as SD format 8.2, 
		/*sum(over) as over,*/ 100*mean(over) as percent_over format 8.1, 
	from extremes
	where N=300;
quit;

