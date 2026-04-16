*=================================================================================
*Title: phys_merge_other.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Merge physician license information to hospitalization records
*=================================================================================

clear
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/phys/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/hosp/
global datadir3 /Users/jvanparys/Documents/papers/AMI/data/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/
global resdir /Users/jvanparys/Documents/papers/AMI/results/

log using ${logdir}phys_merge_other.log, replace

#delimit ;

*=================================================================================;
*Merge patient data with license data;

guse ${datadir3}ip_ami_angina.dta;

drop if missing(otherphyid);

drop attenphyid;
rename otherphyid attenphyid;

*Merge with license data;
*Drop physicians who are missing;

sort attenphyid;
merge attenphyid using ${datadir1}lic_base.dta;
tab _merge;
drop if _merge==2 | _merge==1;

*Note: 3% don't match. Drop these.

*=================================================================================;
*Collapse data to physician-level;

drop N;
sort attenphyid year;
by attenphyid: gen id=_n;
by attenphyid year: gen n=_n;
by attenphyid year: gen N=_N;
sum N, detail;
sum N if n==1, detail;

*=================================================================================;
*Merge with license data;

keep attenphyid N faclnbr sys_recid;
sort attenphyid;
merge attenphyid using ${datadir1}edu.dta;
tab _merge;
drop if _merge==2 | _merge==1;
drop _merge;

sort attenphyid;
merge attenphyid using ${datadir1}cert.dta;
tab _merge;
drop if _merge==2;
drop _merge;

sort attenphyid;
merge attenphyid using ${datadir1}gen.dta;
tab _merge;
drop if _merge==2;
drop _merge;

sort attenphyid;
merge attenphyid using ${datadir1}opt.dta;
tab _merge;
drop if _merge==2;
drop _merge;
sort attenphyid;

*=================================================================================;
*Create specialty variables;

*IM, FP, CA, and other;

su;
tab c10;
tab c11;
tab e16;
tab e17;
tab e18;

gen im=0;
forvalues x=2/41 {;
quietly: replace im=1 if regexm(c`x', "INTERNAL")==1;
quietly: replace im=1 if regexm(c`x', "IM")==1;
};
forvalues x=13/376 {;
quietly: replace im=1 if regexm(e`x', "INTERNAL")==1;
};

gen fp=0;
forvalues x=2/41 {;
quietly: replace fp=1 if regexm(c`x', "FAM")==1;
quietly: replace fp=1 if regexm(c`x', "FM")==1;
};
forvalues x=13/376 {;
quietly: replace fp=1 if regexm(e`x', "FAMILY")==1;
};

gen ca=0;
forvalues x=2/41 {;
quietly: replace ca=1 if regexm(c`x', "CARDI")==1;
quietly: replace ca=1 if regexm(c`x', "THORAC")==1;
quietly: replace ca=1 if regexm(c`x', "TS")==1;
quietly: replace ca=1 if regexm(c`x', "VASCULAR")==1;
};
forvalues x=13/376 {;
quietly: replace ca=1 if regexm(e`x', "CARDI")==1;
quietly: replace ca=1 if regexm(e`x', "THORAC")==1;
quietly: replace ca=1 if regexm(e`x', "VASCULAR")==1;
};

replace im=0 if ca==1;
replace fp=0 if im==1 | ca==1;

gen o=0;
replace o=1 if im!=1 & fp!=1 & ca!=1;

su im fp ca o;
su im fp ca o if N<9;
su im fp ca o if N>10;

drop e13-e376 temp meddate2 c2-c41;
rename N year_volume;
rename attenphyid otherphyid;
foreach a of varlist ca im fp o lang1 lang2 meddate resdate_min resdate_max
medschool-maxdate {;
rename `a' other_`a';
};
keep sys_recid otherphyid other_*;
su;
compress;
sort sys_recid;

save ${datadir1}phys_merge_other_ami_angina.dta, replace;

*=================================================================================;

clear;
log close ;