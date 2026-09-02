%let path=P:\FIT;
libname FIT "&path";
filename r url 'https://raw.githubusercontent.com/KarlBangChristensen/Rasch/master/rasch_include_all.sas';
%include r;
data FIT.AMTS_in;
input item_name $;
datalines;
age
time
address
name
year
dob
month
firstww
monarch
countbac
;
run;
data FIT.AMTS_in;
	set FIT.AMTS_in;
	item_no=_n_; 
	item_text='x';
	max=1; 
	group=_n_;
run;
%rasch_data(data=FIT.AMTS,
            item_names=FIT.AMTS_in);
%rasch_CML( data=FIT.AMTS,
           	item_names=FIT.AMTS_in,
			out=FIT.CML_AMTS);
%rasch_PW( 	data=FIT.AMTS,
           	item_names=FIT.AMTS_in,
			out=FIT.PW_AMTS);
proc print data=FIT.PW_AMTS_ipar noobs;
run;
proc sort data=FIT.PW_AMTS_ipar out=sorted;
	by estimate;
run;
proc print data=sorted noobs;
	var item_name Estimate LowerCL UpperCL;
	format Estimate LowerCL UpperCL 8.1;
run;
%rasch_ppar(DATA=FIT.AMTS, 
			ITEM_NAMES=FIT.AMTS_in, 
			DATA_IPAR=FIT.PW_AMTS_ipar, 
			out=FIT.pp_AMTS_PW);
ods pdf file="&path\ipar.pdf";
proc sgplot data=FIT.PW_AMTS_ipar;
	histogram estimate / nbins=100;
	xaxis values=(-4 to 4);
run;
ods pdf close;
ods pdf file="&path\ppar.pdf";
proc sgplot data=FIT.pp_AMTS_PW_outdata;
	histogram MLE / nbins=100;
	xaxis values=(-4 to 4);
run;
ods pdf close;
data noext;
	set FIT.AMTS;
	score=sum(of age time address name year dob month firstww monarch countbac);
	if score in (0,10) then delete;
run;
*
%rasch_itemfit(	DATA=FIT.AMTS, 
				ITEM_NAMES=FIT.AMTS_in, 
				DATA_IPAR=FIT.PW_AMTS_ipar, 
				DATA_POPPAR=FIT.pp_AMTS_PW_outdata, 
				NCLASS=3, 
				PPAR=MLE,
				OUT=fit);
%rasch_itemfit(	DATA=noext, 
				ITEM_NAMES=FIT.AMTS_in, 
				DATA_IPAR=FIT.PW_AMTS_ipar, 
				DATA_POPPAR=FIT.pp_AMTS_PW_outdata, 
				NCLASS=3, 
				PPAR=MLE,
				OUT=fit_noext);
proc print data=fit_noext_infit;
run;
proc print data=fit_noext_outfit;
run;
proc print data=fit_noext_fitresid;
run;
proc print data=fit_noext_chi;
run;
proc print data=fit_noext_ftest;
run;



proc print data=fit_fitresid;
run;
proc print data=fit_chi;
run;
