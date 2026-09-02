libname FIT '/home/ifsv/pzs913/FIT';
* libname FIT 'p:\FIT';
filename r url 'https://raw.githubusercontent.com/KarlBangChristensen/Rasch/master/rasch_include_all.sas';
%include r;
* Knox cube test data (N=35, I=18);
data FIT.knox;
input name $ 1-7 gender $ i1-i18;
datalines;
Richard M 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 
Tracie  F 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
Walter  M 1 1 1 1 1 1 1 1 1 0 0 1 0 0 0 0 0 0 
Blaise  M 1 1 1 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 
Ron     M 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
William M 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
Susan   F 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 
Linda   F 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
Kim     F 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
Carol   F 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 
Pete    M 1 1 1 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 
Brenda  F 1 1 1 1 1 0 1 0 1 1 0 0 0 0 0 0 0 0 
Mike    M 1 1 1 1 1 0 0 1 1 1 1 1 0 0 0 0 0 0 
Zula    F 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 
Frank   M 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 
Dorothy F 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 0 
Rod     M 1 1 1 1 0 1 1 1 1 1 0 0 0 0 0 0 0 0 
Britton F 1 1 1 1 1 1 1 1 1 1 0 0 1 0 0 0 0 0 
Janet   F 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 
David   M 1 1 1 1 1 1 1 1 1 1 0 0 1 0 0 0 0 0 
Thomas  M 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 
Betty   F 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 
Bert    M 1 1 1 1 1 1 1 1 1 1 0 0 1 1 0 0 0 0 
Rick    M 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 1 1 0 
Don     M 1 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 
Barbara F 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
Adam    M 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 
Audrey  F 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 0 
Anne    F 1 1 1 1 1 1 0 0 1 1 1 0 0 1 0 0 0 0 
Lisa    F 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 
James   M 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
Joe     M 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 
Martha  F 1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 
Elsie   F 1 1 1 1 1 1 1 1 1 1 0 1 0 1 0 0 0 0 
Helen   F 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
;
run;
data FIT.knox_in;
input item_no item_name $ item_text $ max group;
datalines;
1 i4 x 1 1
2 i5 x 1 2
3 i6 x 1 3
4 i7 x 1 4
5 i8 x 1 5
6 i9 x 1 6
7 i10 x 1 7
8 i11 x 1 8
9 i12 x 1 9
10 i13 x 1 10
11 i14 x 1 11
12 i15 x 1 12
13 i16 x 1 13
14 i17 x 1 14
;
run;
%rasch_data(data=FIT.knox,
            item_names=FIT.knox_in);
%rasch_CML( data=FIT.knox,
           	item_names=FIT.knox_in,
			out=FIT.CML);
%rasch_ppar(DATA=FIT.knox, 
			ITEM_NAMES=FIT.knox_in, 
			DATA_IPAR=FIT.CML_ipar, 
			out=FIT.pp_cml);
