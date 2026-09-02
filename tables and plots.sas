libname FIT1 'p:\FIT\1_1000';
libname FIT2 'p:\FIT\1001_2000';
libname FIT2 'c:\dropbox\FIT\1_1000';
libname FIT1 'c:\dropbox\FIT\1001_2000';
ODS LISTING GPATH = 'P:\FIT\AMTS';
%macro perc(name, N);
	data AMTS_out_n&N.;
		set FIT2.AMTS_out_n&N.;
		if item='ADDRESS' then item_no=1;
		if item='AGE' then item_no=2;
		if item='COUNTBAC' then item_no=3;
		if item='DOB' then item_no=4;
		if item='FIRSTWW' then item_no=5;
		if item='MONARCH' then item_no=6;
		if item='MONTH' then item_no=7;
		if item='NAME' then item_no=8;
		if item='TIME' then item_no=9;
		if item='YEAR' then item_no=10;
	run;
	proc means data=AMTS_out_n&N. mean std p1 p5 p95 p99 max ndec=1 nonobs;
		ods output Means.Summary=table_&name._&N._1;
		var &name;
		class item;
	run;
	proc sql noprint;
		create table &name._max&N. as select 
			sim, 
			max(&name.) as _&name.
		from AMTS_out_n&N.
		group by sim;
	quit;
	proc means data=&name._max&N. mean std p1 p5 p95 p99 max ndec=1 nonobs;
		ods output Means.Summary=table_&name._&N._2;
		var _&name;
	run;
	proc univariate data=&name._max&N. noprint;
		var _&name;
		output out=perc_&name._max&N. pctlpre=&name._ pctlpts=95 99;
	run;
	proc sql noprint;
		select &name._95 format 8.1, &name._99 format 8.1 into :_95, :_99
		from perc_&name._max&N.;
	quit;
	ODS GRAPHICS / 	RESET 
				IMAGENAME = "&name._max_N&N." 
				IMAGEFMT =PNG
 				HEIGHT = 8in 
				WIDTH = 12in;
	proc sgplot data=&name._max&N.;
		histogram _&name;
		refline &_95 &_99 / axis=x lineattrs=(thickness=2 color=black pattern=3);
		xaxis valueattrs=(size=14) labelattrs=(size=14);
		yaxis valueattrs=(size=14) labelattrs=(size=14);
		inset "95th percentile &_95" "99th percentile &_99" / 
		position=topright
		LABELALIGN=LEFT
		VALUEALIGN=RIGHT
		textattrs=(size=13);
		label _&name="&name - maximum  - N=&N";
	run;
	*;

	%do i=1 %to 10;
		%let i=&i.;
		proc sql;
			create table &name._&i._&N. as select 
				sim, 
				&name. as _&name.
			from AMTS_out_n&N.
			where item_no=&i.
			order by sim;
		quit;
		proc univariate data=&name._&i._&N. noprint;
			var _&name;
			output out=perc_&name._&i._&N. pctlpre=&name._ pctlpts=95 99;
		run;
		proc sql noprint;
			select &name._95 format 8.1, &name._99 format 8.1 into :_95, :_99
			from perc_&name._&i._&N.;
		quit;

		ODS GRAPHICS / 	RESET 
					IMAGENAME = "&name._I&i._N&N." 
					IMAGEFMT =PNG
	 				HEIGHT = 8in 
					WIDTH = 12in;
		proc sgplot data=&name._&i._&N.;
			histogram _&name;
			refline &_95 &_99 / axis=x lineattrs=(thickness=2 color=black pattern=3);
			xaxis valueattrs=(size=14) labelattrs=(size=14);
			yaxis valueattrs=(size=14) labelattrs=(size=14);
			inset "95th percentile &_95" "99th percentile &_99" / 
				position=topright
				textattrs=(size=13)
				LABELALIGN=LEFT
				VALUEALIGN=RIGHT;
			label _&name="&name - item &i - N=&N";
		run;
	%end;
	data FIT2.table_&name._&N.; set 
		table_&name._&N._1 (rename=(
			&name._Mean   =Mean  
			&name._StdDev =StdDev
			&name._P1     =P1    
			&name._P5     =P5    
			&name._P95    =P95   
			&name._P99    =P99   
			&name._Max    =Max 
		))
		table_&name._&N._2 (rename=(
			_&name._Mean   =Mean  
			_&name._StdDev =StdDev 
			_&name._P1     =P1    
			_&name._P5     =P5    
			_&name._P95    =P95   
			_&name._P99    =P99   
			_&name._Max    =Max 
		))
		;
		N=&N.;
	run;
%mend perc;
%macro runall(name);
	%let _=197; %perc(name=&name, N=&_.); 
	%let _=300; %perc(name=&name, N=&_.); 
	%let _=400; %perc(name=&name, N=&_.); 
	%let _=500; %perc(name=&name, N=&_.); 
	%let _=600; %perc(name=&name, N=&_.); 
	%let _=700; %perc(name=&name, N=&_.); 
	%let _=800; %perc(name=&name, N=&_.); 
	%let _=900; %perc(name=&name, N=&_.); 
	data FIT2.table_&name.; set 
		FIT2.table_&name._197
		FIT2.table_&name._300 
		FIT2.table_&name._400 
		FIT2.table_&name._500 
		FIT2.table_&name._600 
		FIT2.table_&name._700 
		FIT2.table_&name._800 
		FIT2.table_&name._900 
		; 
	run;
%mend runall;

%macro runall(name);
	%let _=197; %perc(name=&name, N=&_.); 
	%let _=300; %perc(name=&name, N=&_.); 
	%let _=400; %perc(name=&name, N=&_.); 
	%let _=500; %perc(name=&name, N=&_.); 
	%let _=600; %perc(name=&name, N=&_.); 
	%let _=700; %perc(name=&name, N=&_.); 
	%let _=800; %perc(name=&name, N=&_.); 
	%let _=900; %perc(name=&name, N=&_.); 
	data FIT2.table_&name.; set 
		FIT2.table_&name._197
		FIT2.table_&name._300 
		FIT2.table_&name._400 
		FIT2.table_&name._500 
		FIT2.table_&name._600 
		FIT2.table_&name._700 
		FIT2.table_&name._800 
		FIT2.table_&name._900 
		; 
	run;
%mend runall;
%runall(chisq);
%runall(FitResid);
%runall(FValue);
%runall(infit);
%runall(infit_t);
%runall(outfit);
%runall(outfit_t);

%let name=chisq;
%let name=fitresid;
data plot;
	set FIT1.table_&name.;
	if item='ADDRESS' then location=2.05;
	if item='AGE' then location=(-0.62);
	if item='COUNTBAC' then location=0.37;
	if item='DOB' then location=(-1.72);
	if item='FIRSTWW' then location=(-0.16);
	if item='MONARCH' then location=0.17;
	if item='MONTH' then location=0.37;
	if item='NAME' then location=(-0.62);
	if item='TIME' then location=0.05;
	if item='YEAR' then location=0.13;
run;
proc print data=plot noobs;
	var location;
run;	
proc sgplot data=plot;
	series x=location y=p95 / group=N;
run;
proc sgplot data=FIT2.table_chisq;
	series x=N y=p95 / group=item;
run;
