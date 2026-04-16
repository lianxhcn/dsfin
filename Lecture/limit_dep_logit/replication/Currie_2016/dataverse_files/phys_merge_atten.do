*=================================================================================
*Title: phys_merge_atten.do
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

log using ${logdir}phys_merge_atten.log, replace

#delimit ;

*=================================================================================;
*Clean education data;

insheet using ${datadir1}edudata.csv;
gen n=1;
rename v1 attenphyid;
rename v2 medschool;
rename v3 medschooldates;
rename v4 graddate;
rename v5 degree;
rename v6 otherdegree;
rename v7 firstname;
rename v8 midname;
rename v9 lastname;
rename v10 suffix;
rename v11 mindate;
rename v12 maxdate;

gen meddate=date(graddate, "MDY");
su meddate n;
gen temp=substr(medschooldates,10,.);
gen meddate2=date(temp, "MDY");
su meddate2;
replace meddate=meddate2 if meddate==.;

gen resdate_min=date(mindate, "MDY");
gen resdate_max=date(maxdate, "MDY");

forvalues x=13/376 {;
rename v`x' e`x';
};

sort attenphyid;
save ${datadir1}edu.dta, replace;

keep attenphyid;
sort attenphyid;
save ${datadir1}lic_base.dta, replace;

clear;

*=================================================================================;
*Clean certifications data;

insheet using ${datadir1}certdata.csv;
rename v1 attenphyid;

forvalues x=2/41 {;
rename v`x' c`x';
};

sort attenphyid;
save ${datadir1}cert.dta, replace;
clear;

*=================================================================================;
*Clean general data;

insheet using ${datadir1}gendata.csv;
rename licenseid attenphyid;
rename license_activity_status activity;
rename controlled_substance_provider controlled;
rename license_date issue_date;
rename discipline_on_file disc;
rename public_complaint public;
drop address*;

sort attenphyid;
save ${datadir1}gen.dta, replace;
clear;

*=================================================================================;
*Clean general data;

insheet using ${datadir1}optdata.csv;
rename v1 attenphyid;
rename v2 lang1;
rename v3 lang2;

sort attenphyid;
save ${datadir1}opt.dta, replace;
clear;

*=================================================================================;
*Merge patient data with license data;

guse ${datadir3}ip_ami_angina.dta;

*Merge with license data;
*Drop physicians who are missing;

sort attenphyid;
merge attenphyid using ${datadir1}lic_base.dta;
tab _merge;
drop if _merge==2 | _merge==1;

*Note: 2.16% don't match. Drop these.

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

su N if fp==1, detail;
histogram N if fp==1;
graph export ${resdir}histogram_fp.ps, replace;

sum N if im==1, detail;
histogram N if im==1;
graph export ${resdir}histogram_im.ps, replace;

su N if ca==1, detail;
histogram N if ca==1;
graph export ${resdir}histogram_ca.ps, replace;

sum N, detail;
histogram N;
graph export ${resdir}histogram_volume.ps, replace;

drop e13-e376 temp meddate2 c2-c41;
rename N year_volume;
su;
compress;
sort sys_recid;

save ${datadir1}phys_merge_atten_ami_angina.dta, replace;

*=================================================================================;

clear;
log close ;