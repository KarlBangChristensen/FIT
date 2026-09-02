%let path=P:\FIT;
libname FIT "&path";
filename r url 'https://raw.githubusercontent.com/KarlBangChristensen/Rasch/master/rasch_include_all.sas';
%include r;
proc import datafile="&path\SPADI.csv" dbms=CSV out=FIT.SPADI replace;
run;
*;
data FIT.SPADI_P_in;
input item_name $ @@;
datalines;
P1 P2 P3 P4 P5
;
run;
data FIT.SPADI_P_in;
	set FIT.SPADI_P_in;
	item_no=_n_; 
	item_text='x';
	max=5; 
	group=_n_;
run;
%rasch_data(
	data=FIT.SPADI,
    item_names=FIT.SPADI_P_in);
%rasch_PW( 
	data=FIT.SPADI,
	item_names=FIT.SPADI_P_in,
	out=FIT.SPADI_P);
%rasch_ppar(
	DATA=FIT.SPADI, 
	ITEM_NAMES=FIT.SPADI_P_in, 
	DATA_IPAR=FIT.SPADI_P_ipar, 
	out=FIT.pp_SPADI_P);
%rasch_itemfit(	
	DATA=FIT.SPADI, 
	ITEM_NAMES=FIT.SPADI_P_in, 
	DATA_IPAR=FIT.SPADI_P_ipar, 
	DATA_POPPAR=FIT.pp_SPADI_P_outdata, 
	NCLASS=3, 
	PPAR=MLE,
	OUT=fit_P);
proc print data=fit_P_fitresid;
run;
proc print data=fit_P_chisq;
run;
proc print data=fit_P_ftest;
run;
*;
data FIT.SPADI_D_in;
input item_name $ @@;
datalines;
D1 D2 D3 D4 D5 D6 D7 D8
;
run;
data FIT.SPADI_D_in;
	set FIT.SPADI_D_in;
	item_no=_n_; 
	item_text='x';
	max=5; 
	group=_n_;
run;
%rasch_data(
	data=FIT.SPADI,
	item_names=FIT.SPADI_D_in);
%rasch_PW( 
	data=FIT.SPADI,
	item_names=FIT.SPADI_D_in,
	out=FIT.SPADI_D);
%rasch_ppar(
	DATA=FIT.SPADI, 
	ITEM_NAMES=FIT.SPADI_D_in, 
	DATA_IPAR=FIT.SPADI_D_ipar, 
	out=FIT.pp_SPADI_D);
%rasch_itemfit(	
	DATA=FIT.SPADI, 
	ITEM_NAMES=FIT.SPADI_D_in, 
	DATA_IPAR=FIT.CML_SPADI_D_ipar, 
	DATA_POPPAR=FIT.pp_SPADI_D_outdata, 
	NCLASS=3, 
	PPAR=MLE,
	OUT=fit_D);
proc print data=fit_D_fitresid;
run;
proc print data=fit_D_chisq;
run;
proc print data=fit_D_ftest;
run;
