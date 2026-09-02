%let path=P:\FIT;
libname FIT "&path";
proc import datafile="&path\raw data amts" dbms=sav out=FIT.AMTS_for replace;
run;
data FIT.AMTS;
	set FIT.AMTS_for;
	format _ALL_;
run;
