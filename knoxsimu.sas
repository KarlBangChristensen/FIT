* simulation;

libname FIT '/home/ifsv/pzs913/FIT';
* libname FIT 'p:\FIT';
filename r url 'https://raw.githubusercontent.com/KarlBangChristensen/Rasch/master/rasch_include_all.sas';
%include r;
%macro knox_simu(samplesize, from, to);
	%do sim=&from %to &to;
		data pp;
			do id=1 to &samplesize.;
				MLE=-0.3+2*rannor(0);
				output;
			end;
		run;
		%rasch_simu(	etafile=FIT.cml_eta, 
						ppfile=pp, 
						estimate=MLE, 
						outfile=simu);
		data simu;
			set simu;
			sum=sum(of I4-I17);
		run;
		data simu;
			set simu;
			if sum in (0,14) then delete;
		run;
		%rasch_data(	data=simu,
						item_names=FIT.knox_in);
		%rasch_MML(		data=simu,
						item_names=FIT.knox_in,
						out=mml);
		%rasch_ppar(	DATA=simu, 
						ITEM_NAMES=FIT.knox_in, 
						DATA_IPAR=mml_ipar, 
						out=pp);
		%rasch_itemfit(	DATA=simu, 
						ITEM_NAMES=FIT.knox_in, 
						DATA_IPAR=mml_ipar, 
						DATA_POPPAR=pp_outdata, 
						NCLASS=3, 
						OUT=fit);
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
		data out&sim;
			merge fit_chisq fit_fitresid fit_ftest fit_infit fit_outfit;
			by item;
			sim=&sim;
		run;
	%end;
	data FIT.out_N&samplesize.;
		set out&from.-out&to.;
		N=&samplesize;
	run;
%mend knox_simu;

/*
%knox_simu(samplesize=35, from=1, to=4000);
%knox_simu(samplesize=70, from=1, to=4000);
%knox_simu(samplesize=105, from=1, to=4000);
%knox_simu(samplesize=140, from=1, to=4000);
%knox_simu(samplesize=210, from=1, to=4000);
%knox_simu(samplesize=350, from=1, to=4000);
%knox_simu(samplesize=700, from=1, to=4000);
*/
%knox_simu(samplesize=1050, from=1, to=4000);
%knox_simu(samplesize=1400, from=1, to=4000);
%knox_simu(samplesize=2100, from=1, to=4000);
%knox_simu(samplesize=3500, from=1, to=4000);
