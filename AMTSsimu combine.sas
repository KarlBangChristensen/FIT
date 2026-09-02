libname FIT 'p:\FIT';
%let N=197;
*%let N=300;
*%let N=400;
*%let N=500;
*%let N=600;
*%let N=700;
*%let N=800;
*%let N=900;
data FIT.out_AMTS;	set 
FIT.AMTS_out_N197
FIT.AMTS_out_N300
FIT.AMTS_out_N400
FIT.AMTS_out_N500
FIT.AMTS_out_N600
FIT.AMTS_out_N700
FIT.AMTS_out_N800
FIT.AMTS_out_N900
;
run;

