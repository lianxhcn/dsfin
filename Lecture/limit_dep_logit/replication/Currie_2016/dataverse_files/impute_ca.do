 *=================================================================================
*Title: impute_ca.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Impute cardiologists to patients without cardiologists listed on their records
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

log using ${logdir}impute_ca.log, replace

*=========================================================================================
*Merge data with information on hospitals to identify cardiologists at teaching hospitals

guse ${datadir1}ip_ami_clean_er.dta

su any_ca2

#delimit ;

*================================================================================;
*Decision-maker: (1) Attending cardiologist or (2) Operating cardiologist;

ge phyid=".";
replace phyid=attenphyid if ca==1;
replace phyid=operphyid if oper_ca==1 & phyid==".";
replace phyid=otherphyid if other_ca==1 & phyid==".";
replace phyid=attenphyid if phyid==".";

local a medschool medschooldates graddate degree otherdegree firstname midname
lastname suffix mindate maxdate meddate resdate_min resdate_max lang1 lang2 im fp ca o;

foreach x of local a {;
ge impute_`x'=`x' if phyid==attenphyid;
replace impute_`x'=oper_`x' if phyid==operphyid;
replace impute_`x'=other_`x' if phyid==otherphyid;
};

*================================================================================
*Create sample of patients without any cardiologist;

preserve;
keep if any_ca2==0;
drop phyid impute_*;
gsave ${datadir1}ip_ami_clean_noca_er.dta, replace;
restore;

*================================================================================;
*Create cardiologist-hospital-quarter-weekday data set;

keep if any_ca2==1;
save ${datadir1}ip_ami_clean_ca_er.dta, replace;

keep phyid faclnbr year qtr weekday impute_*;

sort faclnbr year qtr weekday phyid ;
su year;

*=================================================================================;
*Create experience variables;

gen pdate=".";
forvalues x=1992/2014 {;
replace pdate="3/31/`x'" if qtr==1 & year==`x';
replace pdate="6/30/`x'" if qtr==2 & year==`x';
replace pdate="9/30/`x'" if qtr==3 & year==`x';
replace pdate="12/31/`x'" if qtr==4 & year==`x';
};

gen pat_date=date(pdate, "MDY");

gen impute_exp_med=pat_date-impute_meddate;
gen impute_exp_med_yr=impute_exp_med/365;

gen impute_exp_res=pat_date-impute_resdate_max;
gen impute_exp_res_yr=impute_exp_res/365;

replace impute_exp_med_yr=impute_exp_res_yr+3 if impute_exp_med_yr==.;
replace impute_exp_med_yr=impute_exp_res_yr+3 if missing(impute_exp_med_yr);

replace impute_exp_res_yr=impute_exp_med_yr-3 if impute_exp_res_yr==.;
replace impute_exp_res_yr=impute_exp_med_yr-3 if missing(impute_exp_res_yr);
replace impute_exp_res_yr=. if impute_exp_res_yr<-4;

replace impute_exp_res_yr=0 if impute_exp_res_yr<0 & impute_exp_res_yr!=.;
replace impute_exp_res_yr=. if impute_exp_res_yr>60;
sum impute_exp_res_yr, detail;

*================================================================================;
*Number of patients per hospital-qtr-weekday-physician;

by faclnbr year qtr weekday phyid: gen num_patients=_N;

*================================================================================;
*Keep only one observation per physician-hospital-qtr-weekday;

ge tag=1;
by faclnbr year qtr weekday phyid: gen n=_n;
by faclnbr year qtr weekday: egen total_patients=sum(tag);
ge share=num_patients/total_patients;
su share, detail;

su num_patients if n==1, detail;
su num_patients, detail;

keep if n==1;
su year;

*================================================================================;
*Keep only the physician-hospital-qtr-weekday who treats the most patients;

sort faclnbr year qtr weekday;
by faclnbr year qtr weekday: gen num_phys=_N;
by faclnbr year qtr weekday: gen m=_n;
su num_phys if m==1, detail;
by faclnbr year qtr weekday: egen max_N=max(num_patients);

*Calculate the number of year-quarter-weekdays worked by each physician at each hospital;
*Compare the number for highest volume physicians and all other physicians;
sort phyid faclnbr year qtr weekday;
by phyid faclnbr: ge tag_work=_n;

*Create two ways of matching physicians: (1) Pick based on maximum tenure at the hospital
among physicians who worked in the same hospital-year-qtr-weekday or
(2) Pick based on highest volume in the same hospital-year-qtr-weekday;
*Calculate the degree of overlap in these measures: Are high-volume physicians also high tenure?;

sort faclnbr year qtr weekday;
by faclnbr year qtr weekday: egen max_work=max(tag_work);
by faclnbr year qtr weekday: egen max_exp=max(impute_exp_res_yr);

ge pick_work=max_work==tag_work;
ge pick_patients=max_N==num_patients;
ge pick_exp=max_exp==impute_exp_res_yr;

*Some hospital-year-qtr-weekdays have ties for the most patients per physician;
*In the case of ties, pick the physician with the most tenure (i.e., most days worked at that hospital);
ge both1=0;
replace both1=1 if pick_work==1 & pick_patients==1;
sort faclnbr year qtr weekday;
by faclnbr year qtr weekday: egen duplicates=sum(pick_patients);
by faclnbr year qtr weekday: egen max_both1=max(both1);
su duplicates if m==1, detail;
replace pick_patients=0 if pick_work==0 & duplicates>1 & max_both1==1 & duplicates!=.;

ge both2=0;
replace both2=1 if pick_patients==1 & pick_exp==1;
sort faclnbr year qtr weekday;
by faclnbr year qtr weekday: egen duplicates2=sum(pick_patients);
by faclnbr year qtr weekday: egen max_both2=max(both2);
su duplicates2 if m==1, detail;
replace pick_patients=0 if pick_exp==0 & duplicates2>1 & max_both2==1 & duplicates2!=.;

*The match is the percentage of hospital-year-qtr-weekday-physicians who are picked to have both
the most patients in that day as well as the most days of tenure among their colleagues working on
that day;
ge match1=0;
replace match1=1 if pick_work==pick_patients;
ge match2=0;
replace match2=1 if pick_patients==pick_exp;
ge match3=0;
replace match3=1 if pick_work==pick_exp;
ge match_all=0;
replace match_all=1 if pick_work==pick_patients & pick_patients==pick_exp;
su match1 match2 match3 match_all;

su impute_exp_res_yr if pick_patients==1, detail;
su impute_exp_res_yr if pick_patients==0, detail;

compress;

*================================================================================;

keep if max_N==num_patients;

sort faclnbr year qtr weekday;
by faclnbr year qtr weekday: gen duplicates3=_N;
by faclnbr year qtr weekday: gen m2=_n;
sort faclnbr year qtr weekday;
su duplicates3 if m2==1, detail;
keep if m2==1;

sort faclnbr year qtr weekday;
save ${datadir1}collapse_ami_ca_er.dta, replace;

*================================================================================;
*Merge patients without cardiologists with list of potential cardiologist matches;
*Assign the cardiologist who treats the most patients/works the most/less likely to have measurement error;
*Only keep patients that have a match;

guse ${datadir1}ip_ami_clean_noca_er.dta;
drop _merge;
sort faclnbr year qtr weekday;
merge m:1 faclnbr year qtr weekday using ${datadir1}collapse_ami_ca_er.dta;
tab _merge;
keep if _merge==3;
su num_phys, detail;

append using ${datadir1}ip_ami_clean_ca_er.dta;

drop never_event dx1_de-dxccs10_de ip-operphyid2 dx1_orig-pr30_orig keep late num_patients year_volume
total_cath temp n tot tot_inv sh_inv max_N m m2 _merge tag pdate duplicates duplicates2 duplicates3;

order phyid impute_*;

gsave ${datadir1}ip_ami_match_er.dta, replace;

*================================================================================;
*=================================================================================;
clear;
log close ;