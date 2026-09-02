%include '/home/ifsv/pzs913/FIT/simu.sas';

%let nitems=10;
%let from=1801;
%let to=1850;
%simu(samplesize=300, numberofitems=&nitems., from=&from., to=&to.);
%simu(samplesize=350, numberofitems=&nitems., from=&from., to=&to.);
%simu(samplesize=400, numberofitems=&nitems., from=&from., to=&to.);
%simu(samplesize=450, numberofitems=&nitems., from=&from., to=&to.);
%simu(samplesize=500, numberofitems=&nitems., from=&from., to=&to.);
%simu(samplesize=550, numberofitems=&nitems., from=&from., to=&to.);
%simu(samplesize=600, numberofitems=&nitems., from=&from., to=&to.);
	
data FIT.out_PW_I&nitems._&from._&to.;
	set 
	FIT.out_PW_I&nitems._N300_&from._&to.
	FIT.out_PW_I&nitems._N350_&from._&to.
	FIT.out_PW_I&nitems._N400_&from._&to.
	FIT.out_PW_I&nitems._N450_&from._&to.
	FIT.out_PW_I&nitems._N500_&from._&to.
	FIT.out_PW_I&nitems._N550_&from._&to.
	FIT.out_PW_I&nitems._N600_&from._&to.
	;
run;
proc datasets library=FIT;
	delete
	out_PW_I&nitems._N300_&from._&to.
	out_PW_I&nitems._N350_&from._&to.
	out_PW_I&nitems._N400_&from._&to.
	out_PW_I&nitems._N450_&from._&to.
	out_PW_I&nitems._N500_&from._&to.
	out_PW_I&nitems._N550_&from._&to.
	out_PW_I&nitems._N600_&from._&to.
	;
quit;
