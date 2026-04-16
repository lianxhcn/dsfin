 *=================================================================================
*Title: robust1.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Estimate robustness for responses to reviewers (part 1)
*=================================================================================

clear
set matsize 10000
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/aha/
global datadir3 /Users/jvanparys/Documents/papers/AMI/data/phys/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/
global resdir /Users/jvanparys/Documents/papers/AMI/results/

log using ${logdir}robust1.log, replace

*=================================================================================
*=================================================================================
#delimit ;

guse ${datadir1}ip_ami_final_er.dta;

ge n=1;
sort faclnbr year phyid;
by faclnbr year phyid: ge test=1 if _n==1;
by faclnbr year phyid: egen total_phys=sum(test);
by faclnbr year: egen total_patients=sum(n);
ge ratio_patients_phys=total_patients/total_phys;
su ratio_patients_phys, detail;

ge low_ratio=0;
replace low_ratio=1 if ratio_patients_phys<r(p25) & ratio_patients_phys!=.;

*=================================================================================;
*Create binary ind_beta_im_ang variables to classify physicians;

ge ind_beta_im_ang_t2=(ind_beta_im_ang-1)/ind_se_beta_im_ang;
ge ind_alpha_im_ang_t=ind_alpha_im_ang/ind_se_alpha_im_ang;

su ind_alpha_im_ang_t, detail;
su ind_beta_im_ang_t2, detail;

ge lind_beta_im_ang=0;
replace lind_beta_im_ang=1 if ind_beta_im_ang_t2<-1.96 & ind_beta_im_ang_t2!=.;
ge mind_beta_im_ang=0;
replace mind_beta_im_ang=1 if ind_beta_im_ang_t2>-1.96 & ind_beta_im_ang_t2<1.96;
ge hind_beta_im_ang=0;
replace hind_beta_im_ang=1 if ind_beta_im_ang_t2>1.96 & ind_beta_im_ang_t2!=.;

su lind_beta_im_ang mind_beta_im_ang hind_beta_im_ang;

*=================================================================================;
*Create binary ind_alpha_im_ang variables to classify physicians;

ge lind_alpha_im_ang=0;
replace lind_alpha_im_ang=1 if ind_alpha_im_ang_t<-1.96 & ind_alpha_im_ang_t!=.;
ge mind_alpha_im_ang=0;
replace mind_alpha_im_ang=1 if ind_alpha_im_ang_t>-1.96 & ind_alpha_im_ang_t<1.96;
ge hind_alpha_im_ang=0;
replace hind_alpha_im_ang=1 if ind_alpha_im_ang_t>1.96 & ind_alpha_im_ang_t!=.;

su lind_alpha_im_ang mind_alpha_im_ang hind_alpha_im_ang;

*=================================================================================;
*3x3 table;

ge lalb=0;
replace lalb=1 if lind_alpha_im_ang==1 & lind_beta_im_ang==1;
ge lamb=0;
replace lamb=1 if lind_alpha_im_ang==1 & mind_beta_im_ang==1;
ge lahb=0;
replace lahb=1 if lind_alpha_im_ang==1 & hind_beta_im_ang==1;

ge malb=0;
replace malb=1 if mind_alpha_im_ang==1 & lind_beta_im_ang==1;
ge mamb=0;
replace mamb=1 if mind_alpha_im_ang==1 & mind_beta_im_ang==1;
ge mahb=0;
replace mahb=1 if mind_alpha_im_ang==1 & hind_beta_im_ang==1;

ge halb=0;
replace halb=1 if hind_alpha_im_ang==1 & lind_beta_im_ang==1;
ge hamb=0;
replace hamb=1 if hind_alpha_im_ang==1 & mind_beta_im_ang==1;
ge hahb=0;
replace hahb=1 if hind_alpha_im_ang==1 & hind_beta_im_ang==1;

su lalb malb halb;
su lamb mamb hamb;
su lahb mahb hahb;

*Dummies for regressions - lamb, hamb, lalb, malb, (omitted mamb);
replace lamb=1 if hind_beta_im_ang==1 & lind_alpha_im_ang==1;
replace mamb=1 if hind_beta_im_ang==1 & mind_alpha_im_ang==1;
replace hamb=1 if hind_beta_im_ang==1 & hind_alpha_im_ang==1;
replace malb=1 if hind_alpha_im_ang==1 & lind_beta_im_ang==1;

su lamb hamb lalb malb mamb;

*=================================================================================;
*=================================================================================;
*Create lags of alphas and betas;

ge impute_exp=.;
forvalues x=3(3)30 {;
replace impute_exp=`x' if `x'-3<=impute_exp_res_yr & impute_exp_res_yr<`x' & impute_exp_res_yr!=.;
};
replace impute_exp=33 if 30<=impute_exp_res_yr & impute_exp_res_yr!=.;

ge impute_exp_cat=.;
replace impute_exp_cat=1 if impute_exp==3;
replace impute_exp_cat=2 if impute_exp==6;
replace impute_exp_cat=3 if impute_exp==9;
replace impute_exp_cat=4 if impute_exp==12;
replace impute_exp_cat=5 if impute_exp==15;
replace impute_exp_cat=6 if impute_exp==18;
replace impute_exp_cat=7 if impute_exp==21;
replace impute_exp_cat=8 if impute_exp==24;
replace impute_exp_cat=9 if impute_exp==27;
replace impute_exp_cat=10 if impute_exp==30;
replace impute_exp_cat=11 if impute_exp==33;

su sys_recid impute_exp impute_exp_cat;

sort phyid;
forvalues x=3(3)33 {;
gen temp`x'=ind_alpha_im_ang if impute_exp==`x';
by phyid: egen alpha`x'=max(temp`x');
su temp`x' alpha`x';
drop temp`x';
};
forvalues x=3(3)33 {;
gen temp`x'=ind_beta_im_ang if impute_exp==`x';
by phyid: egen beta`x'=max(temp`x');
su temp`x' beta`x';
drop temp`x';
};

ge lag_alpha=.;
ge lag_beta=.;
forvalues x=3(3)33 {;
replace lag_alpha=alpha`x' if impute_exp==`x'+3;
replace lag_beta=beta`x' if impute_exp==`x'+3;
};

rename lag_alpha lag_ind_alpha_im_ang;
rename lag_beta lag_ind_beta_im_ang;

su ind_alpha_im_ang lag_ind_alpha_im_ang ind_beta_im_ang lag_ind_beta_im_ang;

foreach x of varlist ind_beta_im_ang ind_alpha_im_ang lag_ind_alpha_im_ang lag_ind_beta_im_ang {;
egen z`x'=std(`x');
};

drop fac4 fac5;
egen phyid2=group(phyid);

sort phyid2 year qtr;
by phyid2: gen patient=_n;

xtset phyid2 patient;

local a female age50-age95 arrhythmia-hiv;
local b t1-t90;
local c impute_exp_cat impute_us impute_top20 impute_female_phys impute_spanish;
local e ex3 ex6 ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33;
local f white black hisp mcaid mcare private self;
local g fac1-fac157;

ge facyr=string(faclnbr)+string(year);

*=================================================================================;
*=================================================================================;
*=================================================================================;
*Responses to reviewer's points (numbered as in document);

*1.	One way to test whether matching occurs is to see if the Betas are further away from 1 
in situations where there is likely to be less matching (e.g., smaller hospitals with only 
one cardiologist on call);

su ind_beta_im_ang, detail;
histogram ind_beta_im_ang if ind_beta_im_ang>-1 & ind_beta_im_ang<3, xtitle("")
xsc(r(-1(1)3)) xlabel(-1(1)3) title("Distribution of Responsiveness")
subtitle("AMI Cardiologists 1992-2014");
graph export ${resdir}beta_mostca.ps, replace;

preserve;
drop if low_ratio==1;

su ind_beta_im_ang, detail;
histogram ind_beta_im_ang if ind_beta_im_ang>-1 & ind_beta_im_ang<3, xtitle("")
xsc(r(-1(1)3)) xlabel(-1(1)3) title("Distribution of Responsiveness")
subtitle("AMI Cardiologists 1992-2014");
graph export ${resdir}beta_mostca_dropq1.ps, replace;
restore;

*=================================================================================;
*=================================================================================;

*8.	Why do more physicians have alpha<0 versus greater than zero. Is it because high-volume physicians 
have less invasive practice style or because of functional form? Need to tabulate patient volume by high and low alpha 
(my guess is that high-volume physicians have low alpha).;

drop total_patients;
sort phyid;
by phyid: egen total_patients=sum(n);
su total_patients, detail;

su total_patients if lind_alpha_im_ang==1, detail;
su total_patients if hind_alpha_im_ang==1, detail;

*=================================================================================;
*=================================================================================;
*=================================================================================;

clear;
log close ;