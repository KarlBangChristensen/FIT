libname FIT 'p:\FIT';
/*
%let name=out_pw_i12;
%let name=Amts_out_n197;
%let name=Amts_out_n300;
%let name=Amts_out_n400;
%let name=Amts_out_n500;
%let name=Amts_out_n600;
%let name=Amts_out_n700;
%let name=Amts_out_n800;
%let name=Amts_out_n900;
*/
data FIT.&name.;	
set 
FIT.&name._1_50 FIT.&name._51_100
FIT.&name._101_150 FIT.&name._151_200
FIT.&name._201_250 FIT.&name._251_300
FIT.&name._301_350 FIT.&name._351_400
FIT.&name._401_450 FIT.&name._451_500
FIT.&name._501_550 FIT.&name._551_600
FIT.&name._601_650 FIT.&name._651_700
FIT.&name._701_750 FIT.&name._751_800
FIT.&name._801_850 FIT.&name._851_900
FIT.&name._901_950 FIT.&name._951_1000
FIT.&name._1001_1050 FIT.&name._1051_1100
FIT.&name._1101_1150 FIT.&name._1151_1200
FIT.&name._1201_1250 FIT.&name._1251_1300
FIT.&name._1301_1350 FIT.&name._1351_1400
FIT.&name._1401_1450 FIT.&name._1451_1500
FIT.&name._1501_1550 FIT.&name._1551_1600
FIT.&name._1601_1650 FIT.&name._1651_1700
FIT.&name._1701_1750 FIT.&name._1751_1800
FIT.&name._1801_1850 FIT.&name._1851_1900
FIT.&name._1901_1950 FIT.&name._1951_2000
;
run;
*;
proc datasets lib=FIT memtype=data;
delete
&name._1_50 &name._51_100
&name._101_150 &name._151_200
&name._201_250 &name._251_300
&name._301_350 &name._351_400
&name._401_450 &name._451_500
&name._501_550 &name._551_600
&name._601_650 &name._651_700
&name._701_750 &name._751_800
&name._801_850 &name._851_900
&name._901_950 &name._951_1000
&name._1001_1050 &name._1051_1100
&name._1101_1150 &name._1151_1200
&name._1201_1250 &name._1251_1300
&name._1301_1350 &name._1351_1400
&name._1401_1450 &name._1451_1500
&name._1501_1550 &name._1551_1600
&name._1601_1650 &name._1651_1700
&name._1701_1750 &name._1751_1800
&name._1801_1850 &name._1851_1900
&name._1901_1950 &name._1951_2000
;
run;
quit;
