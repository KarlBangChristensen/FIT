* simulation;

libname FIT '/home/ifsv/pzs913/FIT';
*libname FIT 'p:\FIT';

filename r url 'https://raw.githubusercontent.com/KarlBangChristensen/Rasch/master/rasch_include_all.sas';
%include r;

%macro simu(samplesize, numberofitems, from, to, seed=0);
	options nonotes nomprint;
	ods exclude all;
	%let samplesize=&samplesize.;
	%let numberofitems=&numberofitems.;
	%do sim=&from %to &to;
		* simulate data;
		data simu;
			do id=1 to &samplesize.;
				theta=ranuni(&seed.);
				output;
			end;			
		run;
		data simu;
			set simu;
			array item[&numberofitems.] item1-item&numberofitems.;
			do i=1 to &numberofitems.;
				beta=4*(i-1)/(&numberofitems.-1);
				item[i]=ranbin(&seed,1,exp(theta-beta)/(1+exp(theta-beta)));
			end;
		run;
		data simu;
			set simu;
			sum=sum(of item1-item&numberofitems.);
		run;
		data simu;
			set simu;
			if sum in (0,&numberofitems.) then delete;
		run;
		data simu;
			set simu;
			drop beta i sum;
		run;
		*;
		data in;
			%do i=1 %to &numberofitems.;
				%let i=&i.;
				item_no=&i.; 
				item_name="item&i.   ";
				item_text='x';
				max=1;
				group=&i.;
				output;
			%end;
		run;
		%rasch_data(	data=simu,
						item_names=in);
		%rasch_PW(		data=simu,
						item_names=in,
						out=PW);
		%rasch_ppar(	DATA=simu, 
						ITEM_NAMES=in, 
						DATA_IPAR=PW_ipar, 
						out=pp);
		%rasch_itemfit(	DATA=simu, 
						ITEM_NAMES=in, 
						DATA_IPAR=PW_ipar, 
						DATA_POPPAR=pp_outdata, 
						NCLASS=2, 
						OUT=fit);
		options nonotes;
		proc sort data=fit_chisq;
			by item;
		run;
		proc sort data=fit_fitresid; 
			by item;
		run;
		proc sort data=fit_ftest;
			by item;
		run;
		proc sort data=fit_infit;
			by item;
		run;
		proc sort data=fit_outfit;
			by item;
		run;
		data out_&sim;
			merge fit_chisq fit_fitresid fit_ftest fit_infit fit_outfit;
			by item;
			sim=&sim;
		run;
	%end;
	data FIT.out_PW_I&numberofitems._N&samplesize._&from._&to.;
		set out_&from.-out_&to.;
		numberofitems=&numberofitems.;
		N=&samplesize.;
	run;
	options notes;
	ods exclude none;
%mend simu;
