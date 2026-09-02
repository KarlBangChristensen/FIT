* AMTS simulation;
libname FIT '/home/ifsv/pzs913/FIT';
*libname FIT 'p:\FIT';
filename r url 'https://raw.githubusercontent.com/KarlBangChristensen/Rasch/master/rasch_include_all.sas';
%include r;

%macro AMTS_simu(samplesize, from, to, seed=0);
	options nonotes nomprint;
	ods exclude all;
	%do sim=&from %to &to;
		%do id=1 %to &samplesize.;
			proc sql outobs=1;
				create table d&id as 
				select A.*
					from FIT.pp_amts_cml_outdata as A
					order by ranuni(0);
			quit;			
		%end;
		%let items=ADDRESS AGE COUNTBAC DOB FIRSTWW MONARCH MONTH NAME TIME YEAR;
		data pp;
			set d1-d&samplesize;
			ADDRESS=ranbin(&seed,1,exp(WLE-2.05)/(1+exp(WLE-2.05)));
			AGE=ranbin(&seed,1,exp(WLE-(-0.62))/(1+exp(WLE-(-0.62))));
			COUNTBAC=ranbin(&seed,1,exp(WLE-0.37)/(1+exp(WLE-0.37)));
			DOB=ranbin(&seed,1,exp(WLE-(-1.72))/(1+exp(WLE-(-1.72))));
			FIRSTWW=ranbin(&seed,1,exp(WLE-(-0.16))/(1+exp(WLE-(-0.16))));
			MONARCH=ranbin(&seed,1,exp(WLE-0.17)/(1+exp(WLE-0.17)));
			MONTH=ranbin(&seed,1,exp(WLE-0.37)/(1+exp(WLE-0.37)));
			NAME=ranbin(&seed,1,exp(WLE-(-0.62))/(1+exp(WLE-(-0.62))));
			TIME=ranbin(&seed,1,exp(WLE-0.05)/(1+exp(WLE-0.05)));
			YEAR=ranbin(&seed,1,exp(WLE-0.13)/(1+exp(WLE-0.13)));
			keep WLE &items;
		run;
		data simu;
			set pp;
			sum=sum(of address--year);
		run;
		data simu;
			set simu;
			if sum in (0,10) then delete;
		run;
		%rasch_data(	data=simu,
						item_names=FIT.AMTS_in);
		%rasch_CML(		data=simu,
						item_names=FIT.AMTS_in,
						out=cml);
		%rasch_ppar(	DATA=simu, 
						ITEM_NAMES=FIT.AMTS_in, 
						DATA_IPAR=cml_ipar, 
						out=pp);
		%rasch_itemfit(	DATA=simu, 
						ITEM_NAMES=FIT.AMTS_in, 
						DATA_IPAR=cml_ipar, 
						DATA_POPPAR=pp_outdata, 
						NCLASS=3, 
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
		data out&samplesize._&sim;
			merge fit_chisq fit_fitresid fit_ftest fit_infit fit_outfit;
			by item;
			sim=&sim;
		run;
	%end;
	data FIT.AMTS_out_N&samplesize._&from._&to.;
		set out&samplesize._&from.-out&samplesize._&to.;
		N=&samplesize;
	run;
	options notes;
	ods exclude none;
%mend AMTS_simu;


