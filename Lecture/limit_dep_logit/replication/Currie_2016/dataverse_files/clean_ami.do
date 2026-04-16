 *=================================================================================
*Title: clean_ami.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Merge physician characteristics to hospitalization records
*=================================================================================

clear
set matsize 10000
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/hosp/
global datadir3 /Users/jvanparys/Documents/papers/AMI/data/phys/
global datadir4 /Users/jvanparys/Documents/papers/AMI/data/aha/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/
global resdir /Users/jvanparys/Documents/papers/AMI/results/

log using ${logdir}clean_ami.log, replace

*=========================================================================================
*Merge data with information on hospitals to identify cardiologists at teaching hospitals

guse ${datadir1}ip_ami_angina.dta

rename heart_surgery1 surgery1
rename heart_surgery surgery

sort sys_recid
merge sys_recid using ${datadir3}phys_merge_all_ami_angina.dta
tab _merge
keep if _merge==3

*================================================================================
*Drop patients diagnosed with angina;
*Drop patients who do not enter the hospital through the ED:

su any_ca2
drop if angina==1
su any_ca2
keep if emerg==1
su any_ca2

*================================================================================
*Tabulate types of physicians on record each year
*Note: This is before we restrict to physicians with at least 5 patients per 3-year period
*Note: This does not restrict to patients entering through the ER

#delimit;

replace o=1 if fp==1;
replace oper_o=1 if oper_fp==1;
replace other_o=1 if other_fp==1;

*================================================================================;
*Define procedures performed in a cath lab;
*Drop patients at hospitals that don't perform cath procedures in that quarter;
*Drop patients at hospitals that don't perform cath procedures outside of business hours;

ge invasive=0;
forvalues x=1/10 {;
replace invasive=1 if substr(pr`x',1,4)=="00.6";
replace invasive=1 if substr(pr`x',1,2)=="35";
replace invasive=1 if substr(pr`x',1,2)=="36";
replace invasive=1 if substr(pr`x',1,2)=="37";
replace invasive=1 if substr(pr`x',1,2)=="38";
replace invasive=1 if substr(pr`x',1,2)=="39";
};

ge angio=0;
forvalues x=1/10 {;
replace angio=1 if substr(pr`x',1,5)=="00.66";
replace angio=1 if substr(pr`x',1,4)=="36.0";
replace angio=1 if substr(pr`x',1,5)=="37.22";
replace angio=1 if substr(pr`x',1,5)=="37.23";
};

su invasive angio;
su invasive angio if any_ca==1;
su invasive angio if any_ca==0;

*================================================================================;
*Tabulate #patients and #hospitals before sample restrictions;

su sys_recid;
sort faclnbr;
by faclnbr: gen fac1=_n==1;
egen fac=sum(fac1);
sum fac angio invasive;
drop fac fac1;

preserve;
keep if angio==1;
sort faclnbr angio invasive;
by faclnbr: gen fac2=_n==1;
egen fac3=sum(fac2);
sum fac3;
restore;

*================================================================================;
*1.) How many hospital-quarters never perform invasive procedures?;
sort faclnbr year qtr;
by faclnbr year qtr: egen total_cath=sum(angio);
su total_cath, detail;
drop if total_cath==0;

*================================================================================;
*2.) How many hospital-quarters never perform cath procedures on weekends?;
ge weekend=0;
replace weekend=1 if weekday=="6" | weekday=="7";
su hr_arrival;
ge daytime=0;
replace daytime=1 if hr_arrival=="9" | hr_arrival=="10" | hr_arrival=="11" | hr_arrival=="12" |
hr_arrival=="13" | hr_arrival=="14" | hr_arrival=="15" | hr_arrival=="16" | hr_arrival=="17";

ge bus_hrs=0;
replace bus_hrs=1 if weekend==0;
su bus_hrs;

sort faclnbr year qtr weekday;
by faclnbr year qtr weekday: egen cath_day=sum(angio);
su cath_day, detail;
drop if cath_day==0;

*================================================================================;
*3.) How many hospitals do fewer than 36 cath procedures per year? (after dropping those that don't do any procedures);
sort faclnbr year;
by faclnbr year: egen temp=sum(angio);
su sys_recid if temp<36;
drop if temp<36;

*=================================================================================;
*4.) By diagnosis-year, tabulate shares of patients with invasive vs. non-invasive procedures;
*Drop diagnoses-years where the share invasive>90% or <10%;

ge heart_diag=.;
forvalues x=1/31 {;
replace heart_diag=`x' if dheart`x'==1;
};
tab heart_diag;

drop n;
ge n=1;
sort year heart_diag;
by year heart_diag: egen tot=sum(n);
by year heart_diag: egen tot_inv=sum(angio);
ge sh_inv=tot_inv/tot;
su sh_inv, detail;
drop if sh_inv<0.1 | sh_inv>0.9;

*=================================================================================;
*Tabulate shares with cardiologists and IM physicians;

su invasive surgery any_ca2 any_im;
su invasive surgery if any_ca2==1;
su invasive surgery if any_ca2==0;

*================================================================================;
*Tabulate #patients and #hospitals before sample restrictions;

su sys_recid;
sort faclnbr;
by faclnbr: gen fac4=_n==1;
egen fac5=sum(fac4);
sum fac5 angio invasive;
drop fac4 fac5;

preserve;
keep if angio==1;
sort faclnbr;
by faclnbr: gen fac6=_n==1;
egen fac7=sum(fac6);
sum fac7;
restore;

gsave ${datadir1}ip_ami_clean_er.dta, replace;

*=================================================================================;
*=================================================================================;
clear;
log close ;