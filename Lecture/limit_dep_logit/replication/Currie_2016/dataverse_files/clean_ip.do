*=================================================================================
*Title: clean_ip.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient hospital data for FL. Core files for 1992-2014.
*Purpose: Convert ICD-9-CM codes to CCS codes
*Clean data for appending it later.
*=================================================================================

clear
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/hosp/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/hosp/
global logdir /Users/jvanparys/Documents/papers/AMI/log_files/

log using ${logdir}clean_ip.log, replace

#delimit ;

*=============================================================================================================;
*IP 1992-1994;
*=============================================================================================================;

forvalues x=1992/1994 {;
forvalues y=1/4 {;
		guse ${datadir1}ip`x'`y'.dta;
		*sample 0.1;
		destring year, force replace;
		destring qtr, force replace;
		rename gender sex;
		rename otherchgs othchgs;
		
		rename prindiag dx1;
		rename othdiag1 dx2;
		rename othdiag2 dx3;
		rename othdiag3 dx4;
		rename othdiag4 dx5;
		rename othdiag5 dx6;
		rename othdiag6 dx7;
		rename othdiag7 dx8;
		rename othdiag8 dx9;
		rename othdiag9 dx10;
		
		rename prin_proc pr1;
		rename othproc1 pr2;
		rename othproc2 pr3;
		rename othproc3 pr4;
		rename othproc4 pr5;
		rename othproc5 pr6;
		rename othproc6 pr7;
		rename othproc7 pr8;
		rename othproc8 pr9;
		rename othproc9 pr10;
		
		foreach a of varlist dx1-dx10 {;
			replace `a'="." if missing(`a');
		};
		
		foreach a of varlist dx1-dx10 {;
		gen length`a'=.;
		replace length`a'=4 if length(`a')==4; 
		replace length`a'=5 if length(`a')==5; 
		replace `a'=substr(`a',1,3)+"."+substr(`a',-1,1) if length`a'==4;
		replace `a'=substr(`a',1,3)+"."+substr(`a',-2,2) if length`a'==5;
		};
		
		drop lengthdx1-lengthdx10;
		
		foreach b of varlist pr1-pr10 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist pr1-pr10 {;
		gen length`b'=.;
		replace length`b'=3 if length(`b')==3; 
		replace length`b'=4 if length(`b')==4;
		replace `b'=substr(`b',1,2)+"."+substr(`b',-1,1) if length`b'==3;
		replace `b'=substr(`b',1,2)+"."+substr(`b',-2,2) if length`b'==4;
		};
		
		drop lengthpr1-lengthpr10;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		replace numdx=10 if dx10!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		replace numpr=10 if pr10!=".";
	
		rename nursechgs nurchgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race sex age losdays weekday ptcounty ptstate admtype admsrc 
	dischstat payer dx* numdx drg daysproc
	pr* numpr attenphyid operphyid 
	roomchgs icuchgs ccuchgs pharmchgs medchgs oncochgs labchgs 
	pathchgs radchgs therchgs nuclchgs ctscanchgs oprmchgs aneschgs respchgs 
	occupchgs erchgs cardiochgs mrichgs recovchgs laborchgs othchgs
	tchgs;
	
	destring qtr, force replace;
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	gen attenphyid1=substr(attenphyid,3,2);
	gen attenphyid2=substr(attenphyid,5,.);
	replace attenphyid2=substr(attenphyid,6,.) if inlist(substr(attenphyid,5,1),"0");
	replace attenphyid2=substr(attenphyid,7,.) if inlist(substr(attenphyid,5,2),"00");
	replace attenphyid2=substr(attenphyid,8,.) if inlist(substr(attenphyid,5,3),"000");
	replace attenphyid2=substr(attenphyid,9,.) if inlist(substr(attenphyid,5,4),"0000");
	replace attenphyid2=substr(attenphyid,10,.) if inlist(substr(attenphyid,5,5),"00000");
	replace attenphyid2=substr(attenphyid,11,.) if inlist(substr(attenphyid,5,6),"000000");
	replace attenphyid=attenphyid1+attenphyid2;
	
	gen operphyid1=substr(operphyid,3,2);
	gen operphyid2=substr(operphyid,5,.);
	replace operphyid2=substr(operphyid,6,.) if inlist(substr(operphyid,5,1),"0");
	replace operphyid2=substr(operphyid,7,.) if inlist(substr(operphyid,5,2),"00");
	replace operphyid2=substr(operphyid,8,.) if inlist(substr(operphyid,5,3),"000");
	replace operphyid2=substr(operphyid,9,.) if inlist(substr(operphyid,5,4),"0000");
	replace operphyid2=substr(operphyid,10,.) if inlist(substr(operphyid,5,5),"00000");
	replace operphyid2=substr(operphyid,11,.) if inlist(substr(operphyid,5,6),"000000");
	replace operphyid=operphyid1+operphyid2;


	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	gsave ${datadir2}ip`x'`y'_clean.dta, replace;
	clear;
	};
};

*=============================================================================================================;
*IP 1995-2004;
*=============================================================================================================;

forvalues x=1995/2004 {;
forvalues y=1/4 {;
		guse ${datadir1}ip_`x'`y'.dta;
		*sample 0.01;
		destring year, force replace;
		destring qtr, force replace;
		rename gender sex;
		rename otherchgs othchgs;
		
		rename prindiag dx1;
		rename othdiag1 dx2;
		rename othdiag2 dx3;
		rename othdiag3 dx4;
		rename othdiag4 dx5;
		rename othdiag5 dx6;
		rename othdiag6 dx7;
		rename othdiag7 dx8;
		rename othdiag8 dx9;
		rename othdiag9 dx10;
		
		rename prin_proc pr1;
		rename othproc1 pr2;
		rename othproc2 pr3;
		rename othproc3 pr4;
		rename othproc4 pr5;
		rename othproc5 pr6;
		rename othproc6 pr7;
		rename othproc7 pr8;
		rename othproc8 pr9;
		rename othproc9 pr10;
		
		foreach a of varlist dx1-dx10 {;
			replace `a'="." if missing(`a');
		};
		
		foreach a of varlist dx1-dx10 {;
		gen length`a'=.;
		replace length`a'=4 if length(`a')==4; 
		replace length`a'=5 if length(`a')==5; 
		replace `a'=substr(`a',1,3)+"."+substr(`a',-1,1) if length`a'==4;
		replace `a'=substr(`a',1,3)+"."+substr(`a',-2,2) if length`a'==5;
		};
		
		drop lengthdx1-lengthdx10;
		
		foreach b of varlist pr1-pr10 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist pr1-pr10 {;
		gen length`b'=.;
		replace length`b'=3 if length(`b')==3; 
		replace length`b'=4 if length(`b')==4;
		replace `b'=substr(`b',1,2)+"."+substr(`b',-1,1) if length`b'==3;
		replace `b'=substr(`b',1,2)+"."+substr(`b',-2,2) if length`b'==4;
		};
		
		drop lengthpr1-lengthpr10;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		replace numdx=10 if dx10!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		replace numpr=10 if pr10!=".";
	
		rename nursechgs nurchgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race sex age losdays weekday ptcounty ptstate admtype admsrc 
	dischstat payer dx* numdx drg daysproc
	pr* numpr attenphyid operphyid 
	roomchgs icuchgs ccuchgs pharmchgs medchgs oncochgs labchgs 
	pathchgs radchgs therchgs nuclchgs ctscanchgs oprmchgs aneschgs respchgs 
	occupchgs erchgs cardiochgs mrichgs recovchgs laborchgs othchgs
	tchgs;
	
	destring qtr, force replace;
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	gen attenphyid1=substr(attenphyid,3,2);
	gen attenphyid2=substr(attenphyid,5,.);
	replace attenphyid2=substr(attenphyid,6,.) if inlist(substr(attenphyid,5,1),"0");
	replace attenphyid2=substr(attenphyid,7,.) if inlist(substr(attenphyid,5,2),"00");
	replace attenphyid2=substr(attenphyid,8,.) if inlist(substr(attenphyid,5,3),"000");
	replace attenphyid2=substr(attenphyid,9,.) if inlist(substr(attenphyid,5,4),"0000");
	replace attenphyid2=substr(attenphyid,10,.) if inlist(substr(attenphyid,5,5),"00000");
	replace attenphyid2=substr(attenphyid,11,.) if inlist(substr(attenphyid,5,6),"000000");
	replace attenphyid=attenphyid1+attenphyid2;
	
	gen operphyid1=substr(operphyid,3,2);
	gen operphyid2=substr(operphyid,5,.);
	replace operphyid2=substr(operphyid,6,.) if inlist(substr(operphyid,5,1),"0");
	replace operphyid2=substr(operphyid,7,.) if inlist(substr(operphyid,5,2),"00");
	replace operphyid2=substr(operphyid,8,.) if inlist(substr(operphyid,5,3),"000");
	replace operphyid2=substr(operphyid,9,.) if inlist(substr(operphyid,5,4),"0000");
	replace operphyid2=substr(operphyid,10,.) if inlist(substr(operphyid,5,5),"00000");
	replace operphyid2=substr(operphyid,11,.) if inlist(substr(operphyid,5,6),"000000");
	replace operphyid=operphyid1+operphyid2;

	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	gsave ${datadir2}ip`x'`y'_clean.dta, replace;
	clear;
	};
};

*=============================================================================================================;
*IP 2005;
*=============================================================================================================;

forvalues y=1/4 {;
		guse ${datadir1}ip2005`y'.dta;
		*sample 0.01;
		destring year, force replace;
		destring qtr, force replace;
		rename gender sex;
		rename otherchgs othchgs;
		rename SYS_RECID sys_recid;
		rename PRO_CODE pro_code;
		rename MOD_CODE mod_code;
		rename FAC_REGION fac_region;
		rename FAC_COUNTY fac_county;
		gen hr_arrival=".";
		gen ecode1=".";
		gen ecode2=".";
		gen ecode3=".";
		
		rename prindiag dx1;
		
		rename OTHDIAG1 dx2;
		rename OTHDIAG2 dx3;
		rename OTHDIAG3 dx4;
		rename OTHDIAG4 dx5;
		rename OTHDIAG5 dx6;
		rename OTHDIAG6 dx7;
		rename OTHDIAG7 dx8;
		rename OTHDIAG8 dx9;
		rename OTHDIAG9 dx10;
		
		rename PRIN_PROC pr1;
		rename OTHPROC1 pr2;
		rename OTHPROC2 pr3;
		rename OTHPROC3 pr4;
		rename OTHPROC4 pr5;
		rename OTHPROC5 pr6;
		rename OTHPROC6 pr7;
		rename OTHPROC7 pr8;
		rename OTHPROC8 pr9;
		rename OTHPROC9 pr10;
		
		foreach a of varlist dx1-dx10 {;
			replace `a'="." if missing(`a');
		};
		
		foreach a of varlist dx1-dx10 {;
		gen length`a'=.;
		replace length`a'=4 if length(`a')==4; 
		replace length`a'=5 if length(`a')==5; 
		replace `a'=substr(`a',1,3)+"."+substr(`a',-1,1) if length`a'==4;
		replace `a'=substr(`a',1,3)+"."+substr(`a',-2,2) if length`a'==5;
		};
		
		drop lengthdx1-lengthdx10;
		
		foreach b of varlist pr1-pr10 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist pr1-pr10 {;
		gen length`b'=.;
		replace length`b'=3 if length(`b')==3; 
		replace length`b'=4 if length(`b')==4;
		replace `b'=substr(`b',1,2)+"."+substr(`b',-1,1) if length`b'==3;
		replace `b'=substr(`b',1,2)+"."+substr(`b',-2,2) if length`b'==4;
		};
		
		drop lengthpr1-lengthpr10;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		replace numdx=10 if dx10!=".";
		
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		replace numpr=10 if pr10!=".";
	
		rename nursechgs nurchgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race sex age losdays weekday ptcounty ptstate admtype admsrc 
	dischstat payer dx* numdx drg daysproc hr_arrival
	pr* numpr ecode1 attenphyid operphyid 
	roomchgs icuchgs ccuchgs pharmchgs medchgs oncochgs labchgs 
	pathchgs radchgs therchgs nuclchgs ctscanchgs oprmchgs aneschgs respchgs 
	occupchgs erchgs cardiochgs mrichgs recovchgs laborchgs othchgs
	tchgs;
	
	replace radchgs=radchgs+therchgs+ctscanchgs+mrichgs+nuclchgs;
	destring qtr, force replace;
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	gen attenphyid1=substr(attenphyid,3,2);
	gen attenphyid2=substr(attenphyid,5,.);
	replace attenphyid2=substr(attenphyid,6,.) if inlist(substr(attenphyid,5,1),"0");
	replace attenphyid2=substr(attenphyid,7,.) if inlist(substr(attenphyid,5,2),"00");
	replace attenphyid2=substr(attenphyid,8,.) if inlist(substr(attenphyid,5,3),"000");
	replace attenphyid2=substr(attenphyid,9,.) if inlist(substr(attenphyid,5,4),"0000");
	replace attenphyid2=substr(attenphyid,10,.) if inlist(substr(attenphyid,5,5),"00000");
	replace attenphyid2=substr(attenphyid,11,.) if inlist(substr(attenphyid,5,6),"000000");
	replace attenphyid=attenphyid1+attenphyid2;
	
	gen operphyid1=substr(operphyid,3,2);
	gen operphyid2=substr(operphyid,5,.);
	replace operphyid2=substr(operphyid,6,.) if inlist(substr(operphyid,5,1),"0");
	replace operphyid2=substr(operphyid,7,.) if inlist(substr(operphyid,5,2),"00");
	replace operphyid2=substr(operphyid,8,.) if inlist(substr(operphyid,5,3),"000");
	replace operphyid2=substr(operphyid,9,.) if inlist(substr(operphyid,5,4),"0000");
	replace operphyid2=substr(operphyid,10,.) if inlist(substr(operphyid,5,5),"00000");
	replace operphyid2=substr(operphyid,11,.) if inlist(substr(operphyid,5,6),"000000");
	replace operphyid=operphyid1+operphyid2;

	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	gsave ${datadir1}ip2005`y'_clean.dta, replace;
	clear;
};

*=============================================================================================================;
*IP 2006-2009;
*=============================================================================================================;

forvalues x=2006/2009 {;
	forvalues y=1/4 {;
		guse ${datadir1}ip`x'`y'.dta;
		*sample 0.01;
		*su;
		destring year, force replace;
		destring qtr, force replace;
		rename gender sex;
		rename otherchgs othchgs;
		rename SYS_RECID sys_recid;
		rename PRO_CODE pro_code;
		rename MOD_CODE mod_code;
		rename FAC_REGION fac_region;
		rename FAC_COUNTY fac_county;
		rename HR_ARRIVAL hr_arrival;
		rename ECODE1 ecode1;
		rename ECODE2 ecode2;
		rename ECODE3 ecode3;
		
		rename prindiag dx1;
		
		rename OTHDIAG1 dx2;
		rename OTHDIAG2 dx3;
		rename OTHDIAG3 dx4;
		rename OTHDIAG4 dx5;
		rename OTHDIAG5 dx6;
		rename OTHDIAG6 dx7;
		rename OTHDIAG7 dx8;
		rename OTHDIAG8 dx9;
		rename OTHDIAG9 dx10;
		
		rename OTHDIAG10 dx11;
		rename OTHDIAG11 dx12;
		rename OTHDIAG12 dx13;
		rename OTHDIAG13 dx14;
		rename OTHDIAG14 dx15;
		rename OTHDIAG15 dx16;
		rename OTHDIAG16 dx17;
		rename OTHDIAG17 dx18;
		rename OTHDIAG18 dx19;
		rename OTHDIAG19 dx20;
		
		rename OTHDIAG20 dx21;
		rename OTHDIAG21 dx22;
		rename OTHDIAG22 dx23;
		rename OTHDIAG23 dx24;
		rename OTHDIAG24 dx25;
		rename OTHDIAG25 dx26;
		rename OTHDIAG26 dx27;
		rename OTHDIAG27 dx28;
		rename OTHDIAG28 dx29;
		rename OTHDIAG29 dx30;
		rename OTHDIAG30 dx31;
		
		rename POA_PRIN_D pa1;
		rename POA1 pa2;
		rename POA2 pa3;
		rename POA3 pa4;
		rename POA4 pa5;
		rename POA5 pa6;
		rename POA6 pa7;
		rename POA7 pa8;
		rename POA8 pa9;
		rename POA9 pa10;
		
		rename POA10 pa11;
		rename POA11 pa12;
		rename POA12 pa13;
		rename POA13 pa14;
		rename POA14 pa15;
		rename POA15 pa16;
		rename POA16 pa17;
		rename POA17 pa18;
		rename POA18 pa19;
		rename POA19 pa20;
		
		rename POA20 pa21;
		rename POA21 pa22;
		rename POA22 pa23;
		rename POA23 pa24;
		rename POA24 pa25;
		rename POA25 pa26;
		rename POA26 pa27;
		rename POA27 pa28;
		rename POA28 pa29;
		rename POA29 pa30;
		rename POA30 pa31;
		
		rename prinproc pr1;
		rename OTHPROC1 pr2;
		rename OTHPROC2 pr3;
		rename OTHPROC3 pr4;
		rename OTHPROC4 pr5;
		rename OTHPROC5 pr6;
		rename OTHPROC6 pr7;
		rename OTHPROC7 pr8;
		rename OTHPROC8 pr9;
		rename OTHPROC9 pr10;
		
		rename OTHPROC10 pr11;
		rename OTHPROC11 pr12;
		rename OTHPROC12 pr13;
		rename OTHPROC13 pr14;
		rename OTHPROC14 pr15;
		rename OTHPROC15 pr16;
		rename OTHPROC16 pr17;
		rename OTHPROC17 pr18;
		rename OTHPROC18 pr19;
		rename OTHPROC19 pr20;
		
		rename OTHPROC20 pr21;
		rename OTHPROC21 pr22;
		rename OTHPROC22 pr23;
		rename OTHPROC23 pr24;
		rename OTHPROC24 pr25;
		rename OTHPROC25 pr26;
		rename OTHPROC26 pr27;
		rename OTHPROC27 pr28;
		rename OTHPROC28 pr29;
		rename OTHPROC29 pr30;
		rename OTHPROC30 pr31;
		
		foreach a of varlist dx1-dx31 {;
			replace `a'="." if missing(`a');
		};
		
		foreach b of varlist pr1-pr31 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist dx1-dx31 {;
			gen `b'_orig=`b';
		};
		
		foreach b of varlist pr1-pr31 {;
			gen `b'_orig=`b';
		};
		
		drop dx6-dx31 pr6-pr31;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		
		replace numdx=10 if dx10!="." & dx11==".";
		replace numdx=11 if dx11!="." & dx12==".";
		replace numdx=12 if dx12!="." & dx13==".";
		replace numdx=13 if dx13!="." & dx14==".";
		replace numdx=14 if dx14!="." & dx15==".";
		replace numdx=15 if dx15!="." & dx16==".";
		replace numdx=16 if dx16!="." & dx17==".";
		replace numdx=17 if dx17!="." & dx18==".";
		replace numdx=18 if dx18!="." & dx19==".";
		
		replace numdx=19 if dx19!="." & dx20==".";
		replace numdx=20 if dx20!="." & dx21==".";
		replace numdx=21 if dx21!="." & dx22==".";
		replace numdx=22 if dx22!="." & dx23==".";
		replace numdx=23 if dx23!="." & dx24==".";
		replace numdx=24 if dx24!="." & dx25==".";
		replace numdx=25 if dx25!="." & dx26==".";
		replace numdx=26 if dx26!="." & dx27==".";
		replace numdx=27 if dx27!="." & dx28==".";
		replace numdx=28 if dx28!="." & dx29==".";
		replace numdx=29 if dx29!="." & dx30==".";
		replace numdx=30 if dx30!="." & dx31==".";
		replace numdx=31 if dx31!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		
		replace numpr=10 if pr10!="." & pr11==".";
		replace numpr=11 if pr11!="." & pr12==".";
		replace numpr=12 if pr12!="." & pr13==".";
		replace numpr=13 if pr13!="." & pr14==".";
		replace numpr=14 if pr14!="." & pr15==".";
		replace numpr=15 if pr15!="." & pr16==".";
		replace numpr=16 if pr16!="." & pr17==".";
		replace numpr=17 if pr17!="." & pr18==".";
		replace numpr=18 if pr18!="." & pr19==".";
		
		replace numpr=19 if pr19!="." & pr20==".";
		replace numpr=20 if pr20!="." & pr21==".";
		replace numpr=21 if pr21!="." & pr22==".";
		replace numpr=22 if pr22!="." & pr23==".";
		replace numpr=23 if pr23!="." & pr24==".";
		replace numpr=24 if pr24!="." & pr25==".";
		replace numpr=25 if pr25!="." & pr26==".";
		replace numpr=26 if pr26!="." & pr27==".";
		replace numpr=27 if pr27!="." & pr28==".";
		replace numpr=28 if pr28!="." & pr29==".";
		replace numpr=29 if pr29!="." & pr30==".";
		replace numpr=30 if pr30!="." & pr31==".";
		replace numpr=31 if pr31!="."; 

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race sex age losdays weekday ptcounty ptstate admtype admsrc
	dischstat payer admitdiag dx* pa* numdx drg daysproc hr_arrival
	pr* numpr ecode1 attenphyid operphyid otherphyid 
	roomchgs nuriiichgs icuchgs ccuchgs pharmchgs medchgs oncochgs 
	labchgs radchgs oprmchgs aneschgs respchgs phyocchgs erchgs cardiochgs 
	traumachgs recovchgs laborchgs obserchgs behavchgs othchgs tchgs;
	
	replace numdx=10 if numdx>10 & numdx!=.;
	replace numpr=10 if numpr>10 & numpr!=.;
	destring qtr, force replace;
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	su;
	
	gsave ${datadir1}ip`x'`y'_clean.dta, replace;
	clear;
	};
};

*=============================================================================================================;
*IP 2010-2011;
*Through Q2 2011;
*=============================================================================================================;

forvalues y=1/4 {;
		guse ${datadir1}ip_2010`y'.dta;
		*sample 0.01;
		destring year, force replace;
		destring qtr, force replace;
		rename otherchgs othchgs;
		rename adm_prior admtype;
		rename atten_phyi attenphyid;
		rename oper_phyid operphyid;
		rename othoper_ph otherphyid;
		rename msdrg drg;
		rename edhr_arr hr_arrival;
		
		*su;
		rename prindiag dx1;
		
		rename othdiag1 dx2;
		rename othdiag2 dx3;
		rename othdiag3 dx4;
		rename othdiag4 dx5;
		rename othdiag5 dx6;
		rename othdiag6 dx7;
		rename othdiag7 dx8;
		rename othdiag8 dx9;
		rename othdiag9 dx10;
		
		rename othdiag10 dx11;
		rename othdiag11 dx12;
		rename othdiag12 dx13;
		rename othdiag13 dx14;
		rename othdiag14 dx15;
		rename othdiag15 dx16;
		rename othdiag16 dx17;
		rename othdiag17 dx18;
		rename othdiag18 dx19;
		rename othdiag19 dx20;
		
		rename othdiag20 dx21;
		rename othdiag21 dx22;
		rename othdiag22 dx23;
		rename othdiag23 dx24;
		rename othdiag24 dx25;
		rename othdiag25 dx26;
		rename othdiag26 dx27;
		rename othdiag27 dx28;
		rename othdiag28 dx29;
		rename othdiag29 dx30;
		rename othdiag30 dx31;
		
		rename poa_prin_d pa1;
		rename poa1 pa2;
		rename poa2 pa3;
		rename poa3 pa4;
		rename poa4 pa5;
		rename poa5 pa6;
		rename poa6 pa7;
		rename poa7 pa8;
		rename poa8 pa9;
		rename poa9 pa10;
		
		rename poa10 pa11;
		rename poa11 pa12;
		rename poa12 pa13;
		rename poa13 pa14;
		rename poa14 pa15;
		rename poa15 pa16;
		rename poa16 pa17;
		rename poa17 pa18;
		rename poa18 pa19;
		rename poa19 pa20;
	
		rename poa20 pa21;
		rename poa21 pa22;
		rename poa22 pa23;
		rename poa23 pa24;
		rename poa24 pa25;
		rename poa25 pa26;
		rename poa26 pa27;
		rename poa27 pa28;
		rename poa28 pa29;
		rename poa29 pa30;
		rename poa30 pa31;
		
		rename prinproc pr1;
		rename othproc1 pr2;
		rename othproc2 pr3;
		rename othproc3 pr4;
		rename othproc4 pr5;
		rename othproc5 pr6;
		rename othproc6 pr7;
		rename othproc7 pr8;
		rename othproc8 pr9;
		rename othproc9 pr10;
		
		rename othproc10 pr11;
		rename othproc11 pr12;
		rename othproc12 pr13;
		rename othproc13 pr14;
		rename othproc14 pr15;
		rename othproc15 pr16;
		rename othproc16 pr17;
		rename othproc17 pr18;
		rename othproc18 pr19;
		rename othproc19 pr20;
		
		rename othproc20 pr21;
		rename othproc21 pr22;
		rename othproc22 pr23;
		rename othproc23 pr24;
		rename othproc24 pr25;
		rename othproc25 pr26;
		rename othproc26 pr27;
		rename othproc27 pr28;
		rename othproc28 pr29;
		rename othproc29 pr30;
		rename othproc30 pr31;
		
		foreach a of varlist dx1-dx31 {;
			replace `a'="." if missing(`a');
		};
		
		foreach b of varlist pr1-pr31 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist dx1-dx31 {;
			gen `b'_orig=`b';
		};
		
		foreach b of varlist pr1-pr31 {;
			gen `b'_orig=`b';
		};
		
		drop dx6-dx31 pr6-pr31;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		
		replace numdx=10 if dx10!="." & dx11==".";
		replace numdx=11 if dx11!="." & dx12==".";
		replace numdx=12 if dx12!="." & dx13==".";
		replace numdx=13 if dx13!="." & dx14==".";
		replace numdx=14 if dx14!="." & dx15==".";
		replace numdx=15 if dx15!="." & dx16==".";
		replace numdx=16 if dx16!="." & dx17==".";
		replace numdx=17 if dx17!="." & dx18==".";
		replace numdx=18 if dx18!="." & dx19==".";
		
		replace numdx=19 if dx19!="." & dx20==".";
		replace numdx=20 if dx20!="." & dx21==".";
		replace numdx=21 if dx21!="." & dx22==".";
		replace numdx=22 if dx22!="." & dx23==".";
		replace numdx=23 if dx23!="." & dx24==".";
		replace numdx=24 if dx24!="." & dx25==".";
		replace numdx=25 if dx25!="." & dx26==".";
		replace numdx=26 if dx26!="." & dx27==".";
		replace numdx=27 if dx27!="." & dx28==".";
		replace numdx=28 if dx28!="." & dx29==".";
		replace numdx=29 if dx29!="." & dx30==".";
		replace numdx=30 if dx30!="." & dx31==".";
		replace numdx=31 if dx31!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		
		replace numpr=10 if pr10!="." & pr11==".";
		replace numpr=11 if pr11!="." & pr12==".";
		replace numpr=12 if pr12!="." & pr13==".";
		replace numpr=13 if pr13!="." & pr14==".";
		replace numpr=14 if pr14!="." & pr15==".";
		replace numpr=15 if pr15!="." & pr16==".";
		replace numpr=16 if pr16!="." & pr17==".";
		replace numpr=17 if pr17!="." & pr18==".";
		replace numpr=18 if pr18!="." & pr19==".";
		
		replace numpr=19 if pr19!="." & pr20==".";
		replace numpr=20 if pr20!="." & pr21==".";
		replace numpr=21 if pr21!="." & pr22==".";
		replace numpr=22 if pr22!="." & pr23==".";
		replace numpr=23 if pr23!="." & pr24==".";
		replace numpr=24 if pr24!="." & pr25==".";
		replace numpr=25 if pr25!="." & pr26==".";
		replace numpr=26 if pr26!="." & pr27==".";
		replace numpr=27 if pr27!="." & pr28==".";
		replace numpr=28 if pr28!="." & pr29==".";
		replace numpr=29 if pr29!="." & pr30==".";
		replace numpr=30 if pr30!="." & pr31==".";
		replace numpr=31 if pr31!="."; 
		
		gen nuriiichgs=nur1chgs+nur2chgs+nur3chgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race ethnicity sex age losdays weekday ptcounty ptstate admtype admsrc
	dischstat payer admitdiag dx* pa* numdx drg daysproc hr_arrival
	pr* numpr ecode1 attenphyid operphyid otherphyid 
	roomchgs nuriiichgs icuchgs ccuchgs pharmchgs medchgs oncochgs 
	labchgs radchgs oprmchgs aneschgs respchgs phyocchgs erchgs cardiochgs 
	traumachgs recovchgs laborchgs obserchgs behavchgs othchgs tchgs;
	
	replace numdx=10 if numdx>10 & numdx!=.;
	replace numpr=10 if numpr>10 & numpr!=.;
	destring qtr, force replace;
	*Call Hispanics code "9" in race for 2010-2011;
	replace race="9" if ethnicity=="E1";
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";

	gsave ${datadir2}ip2010`y'_clean.dta, replace;
	clear;
};

forvalues y=1/2 {;
		guse ${datadir1}ip_2011`y'.dta;
		*sample 0.01;
		destring year, force replace;
		destring qtr, force replace;
		rename otherchgs othchgs;
		rename adm_prior admtype;
		rename atten_phyi attenphyid;
		rename oper_phyid operphyid;
		rename othoper_ph otherphyid;
		rename msdrg drg;
		rename edhr_arr hr_arrival;
		
		*rename admitdiag dx1;
		rename prindiag dx1;
		
		rename othdiag1 dx2;
		rename othdiag2 dx3;
		rename othdiag3 dx4;
		rename othdiag4 dx5;
		rename othdiag5 dx6;
		rename othdiag6 dx7;
		rename othdiag7 dx8;
		rename othdiag8 dx9;
		rename othdiag9 dx10;
		
		rename othdiag10 dx11;
		rename othdiag11 dx12;
		rename othdiag12 dx13;
		rename othdiag13 dx14;
		rename othdiag14 dx15;
		rename othdiag15 dx16;
		rename othdiag16 dx17;
		rename othdiag17 dx18;
		rename othdiag18 dx19;
		rename othdiag19 dx20;
		
		rename othdiag20 dx21;
		rename othdiag21 dx22;
		rename othdiag22 dx23;
		rename othdiag23 dx24;
		rename othdiag24 dx25;
		rename othdiag25 dx26;
		rename othdiag26 dx27;
		rename othdiag27 dx28;
		rename othdiag28 dx29;
		rename othdiag29 dx30;
		rename othdiag30 dx31;
		
		rename poa_prin_d pa1;
		rename poa1 pa2;
		rename poa2 pa3;
		rename poa3 pa4;
		rename poa4 pa5;
		rename poa5 pa6;
		rename poa6 pa7;
		rename poa7 pa8;
		rename poa8 pa9;
		rename poa9 pa10;
		
		rename poa10 pa11;
		rename poa11 pa12;
		rename poa12 pa13;
		rename poa13 pa14;
		rename poa14 pa15;
		rename poa15 pa16;
		rename poa16 pa17;
		rename poa17 pa18;
		rename poa18 pa19;
		rename poa19 pa20;
	
		rename poa20 pa21;
		rename poa21 pa22;
		rename poa22 pa23;
		rename poa23 pa24;
		rename poa24 pa25;
		rename poa25 pa26;
		rename poa26 pa27;
		rename poa27 pa28;
		rename poa28 pa29;
		rename poa29 pa30;
		rename poa30 pa31;
		
		rename prinproc pr1;
		rename othproc1 pr2;
		rename othproc2 pr3;
		rename othproc3 pr4;
		rename othproc4 pr5;
		rename othproc5 pr6;
		rename othproc6 pr7;
		rename othproc7 pr8;
		rename othproc8 pr9;
		rename othproc9 pr10;
		
		rename othproc10 pr11;
		rename othproc11 pr12;
		rename othproc12 pr13;
		rename othproc13 pr14;
		rename othproc14 pr15;
		rename othproc15 pr16;
		rename othproc16 pr17;
		rename othproc17 pr18;
		rename othproc18 pr19;
		rename othproc19 pr20;
		
		rename othproc20 pr21;
		rename othproc21 pr22;
		rename othproc22 pr23;
		rename othproc23 pr24;
		rename othproc24 pr25;
		rename othproc25 pr26;
		rename othproc26 pr27;
		rename othproc27 pr28;
		rename othproc28 pr29;
		rename othproc29 pr30;
		rename othproc30 pr31;
		
		foreach a of varlist dx1-dx31 {;
			replace `a'="." if missing(`a');
		};
		
		foreach b of varlist pr1-pr31 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist dx1-dx31 {;
			gen `b'_orig=`b';
		};
		
		foreach b of varlist pr1-pr31 {;
			gen `b'_orig=`b';
		};
		
		drop dx6-dx31 pr6-pr31;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		
		replace numdx=10 if dx10!="." & dx11==".";
		replace numdx=11 if dx11!="." & dx12==".";
		replace numdx=12 if dx12!="." & dx13==".";
		replace numdx=13 if dx13!="." & dx14==".";
		replace numdx=14 if dx14!="." & dx15==".";
		replace numdx=15 if dx15!="." & dx16==".";
		replace numdx=16 if dx16!="." & dx17==".";
		replace numdx=17 if dx17!="." & dx18==".";
		replace numdx=18 if dx18!="." & dx19==".";
		
		replace numdx=19 if dx19!="." & dx20==".";
		replace numdx=20 if dx20!="." & dx21==".";
		replace numdx=21 if dx21!="." & dx22==".";
		replace numdx=22 if dx22!="." & dx23==".";
		replace numdx=23 if dx23!="." & dx24==".";
		replace numdx=24 if dx24!="." & dx25==".";
		replace numdx=25 if dx25!="." & dx26==".";
		replace numdx=26 if dx26!="." & dx27==".";
		replace numdx=27 if dx27!="." & dx28==".";
		replace numdx=28 if dx28!="." & dx29==".";
		replace numdx=29 if dx29!="." & dx30==".";
		replace numdx=30 if dx30!="." & dx31==".";
		replace numdx=31 if dx31!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		
		replace numpr=10 if pr10!="." & pr11==".";
		replace numpr=11 if pr11!="." & pr12==".";
		replace numpr=12 if pr12!="." & pr13==".";
		replace numpr=13 if pr13!="." & pr14==".";
		replace numpr=14 if pr14!="." & pr15==".";
		replace numpr=15 if pr15!="." & pr16==".";
		replace numpr=16 if pr16!="." & pr17==".";
		replace numpr=17 if pr17!="." & pr18==".";
		replace numpr=18 if pr18!="." & pr19==".";
		
		replace numpr=19 if pr19!="." & pr20==".";
		replace numpr=20 if pr20!="." & pr21==".";
		replace numpr=21 if pr21!="." & pr22==".";
		replace numpr=22 if pr22!="." & pr23==".";
		replace numpr=23 if pr23!="." & pr24==".";
		replace numpr=24 if pr24!="." & pr25==".";
		replace numpr=25 if pr25!="." & pr26==".";
		replace numpr=26 if pr26!="." & pr27==".";
		replace numpr=27 if pr27!="." & pr28==".";
		replace numpr=28 if pr28!="." & pr29==".";
		replace numpr=29 if pr29!="." & pr30==".";
		replace numpr=30 if pr30!="." & pr31==".";
		replace numpr=31 if pr31!="."; 
		
		gen nuriiichgs=nur1chgs+nur2chgs+nur3chgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race ethnicity sex age losdays weekday ptcounty ptstate admtype admsrc
	dischstat payer admitdiag dx* pa* numdx drg daysproc hr_arrival
	pr* numpr ecode1 attenphyid operphyid otherphyid 
	roomchgs nuriiichgs icuchgs ccuchgs pharmchgs medchgs oncochgs 
	labchgs radchgs oprmchgs aneschgs respchgs phyocchgs erchgs cardiochgs 
	traumachgs recovchgs laborchgs obserchgs behavchgs othchgs tchgs;
	
	replace numdx=10 if numdx>10 & numdx!=.;
	replace numpr=10 if numpr>10 & numpr!=.;
	destring qtr, force replace;
	*Call Hispanics code "9" in race for 2010-2011;
	replace race="9" if ethnicity=="E1";
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	
	gsave ${datadir2}ip2011`y'_clean.dta, replace;
	clear;
};


forvalues y=3/4 {;
		guse ${datadir1}ip_2011`y'.dta;
		*sample 0.01;
		destring year, force replace;
		destring qtr, force replace;
		rename otherchgs othchgs;
		rename adm_prior admtype;
		rename atten_phyi attenphyid;
		rename oper_phyid operphyid;
		rename othoper_ph otherphyid;
		rename msdrg drg;
		rename edhr_arr hr_arrival;
		
		*rename admitdiag dx1;
		rename prindiag dx1;
		
		rename othdiag1 dx2;
		rename othdiag2 dx3;
		rename othdiag3 dx4;
		rename othdiag4 dx5;
		rename othdiag5 dx6;
		rename othdiag6 dx7;
		rename othdiag7 dx8;
		rename othdiag8 dx9;
		rename othdiag9 dx10;
		
		rename othdiag10 dx11;
		rename othdiag11 dx12;
		rename othdiag12 dx13;
		rename othdiag13 dx14;
		rename othdiag14 dx15;
		rename othdiag15 dx16;
		rename othdiag16 dx17;
		rename othdiag17 dx18;
		rename othdiag18 dx19;
		rename othdiag19 dx20;
		
		rename othdiag20 dx21;
		rename othdiag21 dx22;
		rename othdiag22 dx23;
		rename othdiag23 dx24;
		rename othdiag24 dx25;
		rename othdiag25 dx26;
		rename othdiag26 dx27;
		rename othdiag27 dx28;
		rename othdiag28 dx29;
		rename othdiag29 dx30;
		rename othdiag30 dx31;
		
		rename poa_prin_d pa1;
		rename poa1 pa2;
		rename poa2 pa3;
		rename poa3 pa4;
		rename poa4 pa5;
		rename poa5 pa6;
		rename poa6 pa7;
		rename poa7 pa8;
		rename poa8 pa9;
		rename poa9 pa10;
		
		rename poa10 pa11;
		rename poa11 pa12;
		rename poa12 pa13;
		rename poa13 pa14;
		rename poa14 pa15;
		rename poa15 pa16;
		rename poa16 pa17;
		rename poa17 pa18;
		rename poa18 pa19;
		rename poa19 pa20;
	
		rename poa20 pa21;
		rename poa21 pa22;
		rename poa22 pa23;
		rename poa23 pa24;
		rename poa24 pa25;
		rename poa25 pa26;
		rename poa26 pa27;
		rename poa27 pa28;
		rename poa28 pa29;
		rename poa29 pa30;
		rename poa30 pa31;
		
		rename prinproc pr1;
		rename othproc1 pr2;
		rename othproc2 pr3;
		rename othproc3 pr4;
		rename othproc4 pr5;
		rename othproc5 pr6;
		rename othproc6 pr7;
		rename othproc7 pr8;
		rename othproc8 pr9;
		rename othproc9 pr10;
		
		rename othproc10 pr11;
		rename othproc11 pr12;
		rename othproc12 pr13;
		rename othproc13 pr14;
		rename othproc14 pr15;
		rename othproc15 pr16;
		rename othproc16 pr17;
		rename othproc17 pr18;
		rename othproc18 pr19;
		rename othproc19 pr20;
		
		rename othproc20 pr21;
		rename othproc21 pr22;
		rename othproc22 pr23;
		rename othproc23 pr24;
		rename othproc24 pr25;
		rename othproc25 pr26;
		rename othproc26 pr27;
		rename othproc27 pr28;
		rename othproc28 pr29;
		rename othproc29 pr30;
		rename othproc30 pr31;
		
		foreach a of varlist dx1-dx31 {;
			replace `a'="." if missing(`a');
		};
		
		foreach b of varlist pr1-pr31 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist dx1-dx31 {;
			gen `b'_orig=`b';
		};
		
		foreach b of varlist pr1-pr31 {;
			gen `b'_orig=`b';
		};
		
		drop dx6-dx31 pr6-pr31;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		
		replace numdx=10 if dx10!="." & dx11==".";
		replace numdx=11 if dx11!="." & dx12==".";
		replace numdx=12 if dx12!="." & dx13==".";
		replace numdx=13 if dx13!="." & dx14==".";
		replace numdx=14 if dx14!="." & dx15==".";
		replace numdx=15 if dx15!="." & dx16==".";
		replace numdx=16 if dx16!="." & dx17==".";
		replace numdx=17 if dx17!="." & dx18==".";
		replace numdx=18 if dx18!="." & dx19==".";
		
		replace numdx=19 if dx19!="." & dx20==".";
		replace numdx=20 if dx20!="." & dx21==".";
		replace numdx=21 if dx21!="." & dx22==".";
		replace numdx=22 if dx22!="." & dx23==".";
		replace numdx=23 if dx23!="." & dx24==".";
		replace numdx=24 if dx24!="." & dx25==".";
		replace numdx=25 if dx25!="." & dx26==".";
		replace numdx=26 if dx26!="." & dx27==".";
		replace numdx=27 if dx27!="." & dx28==".";
		replace numdx=28 if dx28!="." & dx29==".";
		replace numdx=29 if dx29!="." & dx30==".";
		replace numdx=30 if dx30!="." & dx31==".";
		replace numdx=31 if dx31!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		
		replace numpr=10 if pr10!="." & pr11==".";
		replace numpr=11 if pr11!="." & pr12==".";
		replace numpr=12 if pr12!="." & pr13==".";
		replace numpr=13 if pr13!="." & pr14==".";
		replace numpr=14 if pr14!="." & pr15==".";
		replace numpr=15 if pr15!="." & pr16==".";
		replace numpr=16 if pr16!="." & pr17==".";
		replace numpr=17 if pr17!="." & pr18==".";
		replace numpr=18 if pr18!="." & pr19==".";
		
		replace numpr=19 if pr19!="." & pr20==".";
		replace numpr=20 if pr20!="." & pr21==".";
		replace numpr=21 if pr21!="." & pr22==".";
		replace numpr=22 if pr22!="." & pr23==".";
		replace numpr=23 if pr23!="." & pr24==".";
		replace numpr=24 if pr24!="." & pr25==".";
		replace numpr=25 if pr25!="." & pr26==".";
		replace numpr=26 if pr26!="." & pr27==".";
		replace numpr=27 if pr27!="." & pr28==".";
		replace numpr=28 if pr28!="." & pr29==".";
		replace numpr=29 if pr29!="." & pr30==".";
		replace numpr=30 if pr30!="." & pr31==".";
		replace numpr=31 if pr31!="."; 
		
		gen nuriiichgs=nur1chgs+nur2chgs+nur3chgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race sex ethnicity age losdays weekday ptcounty ptstate admtype admsrc condtn
	dischstat payer admitdiag dx* pa* numdx drg daysproc hr_arrival
	pr* numpr ecode1 attenphyid operphyid otherphyid 
	roomchgs nuriiichgs icuchgs ccuchgs pharmchgs medchgs oncochgs 
	labchgs radchgs oprmchgs aneschgs respchgs phyocchgs erchgs cardiochgs 
	traumachgs recovchgs laborchgs obserchgs behavchgs othchgs tchgs;
	
	replace numdx=10 if numdx>10 & numdx!=.;
	replace numpr=10 if numpr>10 & numpr!=.;
	replace admsrc="07" if condtn=="P7";
	destring qtr, force replace;
	*Call Hispanics code "9" in race for 2010-2011;
	replace race="9" if ethnicity=="E1";
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	
	gsave ${datadir2}ip2011`y'_clean.dta, replace;
	clear;
};

*=============================================================================================================;
*2012-2014;
*=============================================================================================================;

forvalues x=2012/2014 {;
forvalues y=1/4 {;
		guse ${datadir1}ip_`x'`y'.dta;
		*sample 0.01;
		destring year, force replace;
		destring qtr, force replace;
		rename otherchgs othchgs;
		rename adm_prior admtype;
		rename atten_phyi attenphyid;
		rename oper_phyid operphyid;
		rename othoper_ph otherphyid;
		rename msdrg drg;
		rename edhr_arr hr_arrival;
		
		*rename admitdiag dx1;
		rename prindiag dx1;
		
		rename othdiag1 dx2;
		rename othdiag2 dx3;
		rename othdiag3 dx4;
		rename othdiag4 dx5;
		rename othdiag5 dx6;
		rename othdiag6 dx7;
		rename othdiag7 dx8;
		rename othdiag8 dx9;
		rename othdiag9 dx10;
		
		rename othdiag10 dx11;
		rename othdiag11 dx12;
		rename othdiag12 dx13;
		rename othdiag13 dx14;
		rename othdiag14 dx15;
		rename othdiag15 dx16;
		rename othdiag16 dx17;
		rename othdiag17 dx18;
		rename othdiag18 dx19;
		rename othdiag19 dx20;
		
		rename othdiag20 dx21;
		rename othdiag21 dx22;
		rename othdiag22 dx23;
		rename othdiag23 dx24;
		rename othdiag24 dx25;
		rename othdiag25 dx26;
		rename othdiag26 dx27;
		rename othdiag27 dx28;
		rename othdiag28 dx29;
		rename othdiag29 dx30;
		rename othdiag30 dx31;
		
		rename poa_prin_d pa1;
		rename poa1 pa2;
		rename poa2 pa3;
		rename poa3 pa4;
		rename poa4 pa5;
		rename poa5 pa6;
		rename poa6 pa7;
		rename poa7 pa8;
		rename poa8 pa9;
		rename poa9 pa10;
		
		rename poa10 pa11;
		rename poa11 pa12;
		rename poa12 pa13;
		rename poa13 pa14;
		rename poa14 pa15;
		rename poa15 pa16;
		rename poa16 pa17;
		rename poa17 pa18;
		rename poa18 pa19;
		rename poa19 pa20;
	
		rename poa20 pa21;
		rename poa21 pa22;
		rename poa22 pa23;
		rename poa23 pa24;
		rename poa24 pa25;
		rename poa25 pa26;
		rename poa26 pa27;
		rename poa27 pa28;
		rename poa28 pa29;
		rename poa29 pa30;
		rename poa30 pa31;
		
		rename prinproc pr1;
		rename othproc1 pr2;
		rename othproc2 pr3;
		rename othproc3 pr4;
		rename othproc4 pr5;
		rename othproc5 pr6;
		rename othproc6 pr7;
		rename othproc7 pr8;
		rename othproc8 pr9;
		rename othproc9 pr10;
		
		rename othproc10 pr11;
		rename othproc11 pr12;
		rename othproc12 pr13;
		rename othproc13 pr14;
		rename othproc14 pr15;
		rename othproc15 pr16;
		rename othproc16 pr17;
		rename othproc17 pr18;
		rename othproc18 pr19;
		rename othproc19 pr20;
		
		rename othproc20 pr21;
		rename othproc21 pr22;
		rename othproc22 pr23;
		rename othproc23 pr24;
		rename othproc24 pr25;
		rename othproc25 pr26;
		rename othproc26 pr27;
		rename othproc27 pr28;
		rename othproc28 pr29;
		rename othproc29 pr30;
		rename othproc30 pr31;
		
		foreach a of varlist dx1-dx31 {;
			replace `a'="." if missing(`a');
		};
		
		foreach b of varlist pr1-pr31 {;
			replace `b'="." if missing(`b');
		};
		
		foreach b of varlist dx1-dx31 {;
			gen `b'_orig=`b';
		};
		
		foreach b of varlist pr1-pr31 {;
			gen `b'_orig=`b';
		};
		
		drop dx6-dx31 pr6-pr31;
		
		gen numdx=.;
		replace numdx=0 if dx1==".";
		replace numdx=1 if dx1!="." & dx2==".";
		replace numdx=2 if dx2!="." & dx3==".";
		replace numdx=3 if dx3!="." & dx4==".";
		replace numdx=4 if dx4!="." & dx5==".";
		replace numdx=5 if dx5!="." & dx6==".";
		replace numdx=6 if dx6!="." & dx7==".";
		replace numdx=7 if dx7!="." & dx8==".";
		replace numdx=8 if dx8!="." & dx9==".";
		replace numdx=9 if dx9!="." & dx10==".";
		
		replace numdx=10 if dx10!="." & dx11==".";
		replace numdx=11 if dx11!="." & dx12==".";
		replace numdx=12 if dx12!="." & dx13==".";
		replace numdx=13 if dx13!="." & dx14==".";
		replace numdx=14 if dx14!="." & dx15==".";
		replace numdx=15 if dx15!="." & dx16==".";
		replace numdx=16 if dx16!="." & dx17==".";
		replace numdx=17 if dx17!="." & dx18==".";
		replace numdx=18 if dx18!="." & dx19==".";
		
		replace numdx=19 if dx19!="." & dx20==".";
		replace numdx=20 if dx20!="." & dx21==".";
		replace numdx=21 if dx21!="." & dx22==".";
		replace numdx=22 if dx22!="." & dx23==".";
		replace numdx=23 if dx23!="." & dx24==".";
		replace numdx=24 if dx24!="." & dx25==".";
		replace numdx=25 if dx25!="." & dx26==".";
		replace numdx=26 if dx26!="." & dx27==".";
		replace numdx=27 if dx27!="." & dx28==".";
		replace numdx=28 if dx28!="." & dx29==".";
		replace numdx=29 if dx29!="." & dx30==".";
		replace numdx=30 if dx30!="." & dx31==".";
		replace numdx=31 if dx31!=".";
		
		gen numpr=.;
		replace numpr=0 if pr1==".";
		replace numpr=1 if pr1!="." & pr2==".";
		replace numpr=2 if pr2!="." & pr3==".";
		replace numpr=3 if pr3!="." & pr4==".";
		replace numpr=4 if pr4!="." & pr5==".";
		replace numpr=5 if pr5!="." & pr6==".";
		replace numpr=6 if pr6!="." & pr7==".";
		replace numpr=7 if pr7!="." & pr8==".";
		replace numpr=8 if pr8!="." & pr9==".";
		replace numpr=9 if pr9!="." & pr10==".";
		
		replace numpr=10 if pr10!="." & pr11==".";
		replace numpr=11 if pr11!="." & pr12==".";
		replace numpr=12 if pr12!="." & pr13==".";
		replace numpr=13 if pr13!="." & pr14==".";
		replace numpr=14 if pr14!="." & pr15==".";
		replace numpr=15 if pr15!="." & pr16==".";
		replace numpr=16 if pr16!="." & pr17==".";
		replace numpr=17 if pr17!="." & pr18==".";
		replace numpr=18 if pr18!="." & pr19==".";
		
		replace numpr=19 if pr19!="." & pr20==".";
		replace numpr=20 if pr20!="." & pr21==".";
		replace numpr=21 if pr21!="." & pr22==".";
		replace numpr=22 if pr22!="." & pr23==".";
		replace numpr=23 if pr23!="." & pr24==".";
		replace numpr=24 if pr24!="." & pr25==".";
		replace numpr=25 if pr25!="." & pr26==".";
		replace numpr=26 if pr26!="." & pr27==".";
		replace numpr=27 if pr27!="." & pr28==".";
		replace numpr=28 if pr28!="." & pr29==".";
		replace numpr=29 if pr29!="." & pr30==".";
		replace numpr=30 if pr30!="." & pr31==".";
		replace numpr=31 if pr31!="."; 
		
		gen nuriiichgs=nur1chgs+nur2chgs+nur3chgs;
		rename phythchgs phyocchgs;

	keep sys_recid year qtr faclnbr pro_code fac_region fac_county zipcode
	race sex ethnicity age losdays weekday ptcounty ptstate admtype admsrc condtn
	dischstat payer admitdiag dx* pa* numdx drg daysproc hr_arrival
	pr* numpr ecode1 attenphyid operphyid otherphyid 
	roomchgs nuriiichgs icuchgs ccuchgs pharmchgs medchgs oncochgs 
	labchgs radchgs oprmchgs aneschgs respchgs phyocchgs erchgs cardiochgs 
	traumachgs recovchgs laborchgs obserchgs behavchgs othchgs tchgs;
	
	replace numdx=10 if numdx>10 & numdx!=.;
	replace numpr=10 if numpr>10 & numpr!=.;
	replace admsrc="07" if condtn=="P7";
	destring qtr, force replace;
	*Call Hispanics code "9" in race for 2010-2011;
	replace race="9" if ethnicity=="E1";
	
	gen ip=1;
	gen er=0;
	gen am=0;
	
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/SingleDXCCS.do";
	do "/Users/jvanparys/Documents/papers/AMI/do_files/samples/statasingledxccs/singleprccs.do";
	
	gsave ${datadir2}ip`x'`y'_clean.dta, replace;
	clear;
};

*=============================================================================================================;
*=============================================================================================================;

log close ;