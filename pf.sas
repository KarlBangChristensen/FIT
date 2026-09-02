%let path=C:\Dropbox\FIT;
libname fit "&path";
proc print data=fit.PF;
run;
options nofmterr;
%let macropath=c:\dropbox\macro;
%include "&macropath\macros\rasch_include_all.sas";
data in;
input item_no item_name $ item_text $ max group;
datalines;
1 pf01 x 1 1
2 pf02 x 1 2
3 pf03 x 1 3
4 pf04 x 1 4
5 pf05 x 1 5
6 pf06 x 1 6
7 pf07 x 1 7
8 pf08 x 1 8
9 pf09 x 1 9
10 pf10 x 1 10
;
run;
data fit.pf_NM;
	set fit.pf;
	nm=nmiss(of pf01-pf10);
	if nm>0 then delete;
run;
%rasch_data(	data=fit.pf_NM,
            	item_names=in);
%rasch_CML( 	data=fit.pf_NM,
            	item_names=in,
				out=CML);
ods html;
ods tagsets.tablesonlylatex file="&path\eta.tex" stylesheet="sas.sty"(url="sas");
proc print data=cml_ipar(drop=LowerCL UpperCL) noobs;
	format estimate standarderror 8.2;
run;
ods tagsets.tablesonlylatex close;				
%rasch_ppar(	DATA=fit.pf_NM, 
				ITEM_NAMES=in, 
				DATA_IPAR=cml_ipar, 
				out=pp);
ods tagsets.tablesonlylatex file="&path\theta.tex" stylesheet="sas.sty"(url="sas");
proc print data=pp_latent(drop=wle wle_se) noobs;
	format mle mle_se 8.2;
run;
ods tagsets.tablesonlylatex close;
*;
%rasch_itemfit(	DATA=fit.pf_NM, 
				ITEM_NAMES=in, 
				DATA_IPAR=cml_ipar, 
				DATA_POPPAR=pp_outdata, 
				NCLASS=3, 
				OUT=pffit);
proc print data=pffit_infit_outfit;
run;
proc print data=pffit_fitresid;
run;
