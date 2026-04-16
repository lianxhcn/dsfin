*=================================================================================
*Title: reg_all.do
*Author: Jessica Van Parys
*Date modified: 7/16/2016
*Data: In-patient data for FL. Core files for 1992-2014
*Purpose: Estimate robustness for full sample (e.g., Table 9b)
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

log using ${logdir}reg_all.log, replace

*=================================================================================
*=================================================================================
#delimit ;

guse ${datadir1}ip_ami_final_er.dta;

drop fac4 fac5;

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

ge impute_exp_res_yr2=impute_exp_res_yr*impute_exp_res_yr;

tab faclnbr, ge(fac);

foreach x of varlist ind_alpha_im_ang ind_beta_im_ang {;
egen z`x'=std(`x');
};

ge surg=numpr_surg>0;

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

foreach x of varlist lag_ind_alpha_im_ang lag_ind_beta_im_ang {;
egen z`x'=std(`x');
};

su zind_alpha_im_ang zlag_ind_alpha_im_ang zind_beta_im_ang zlag_ind_beta_im_ang;

drop ex3 ex6 ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33;

ge ex3=impute_exp_cat==1;
ge ex6=impute_exp_cat==2;
ge ex9=impute_exp_cat==3;
ge ex12=impute_exp_cat==4;
ge ex15=impute_exp_cat==5;
ge ex18=impute_exp_cat==6;
ge ex21=impute_exp_cat==7;
ge ex24=impute_exp_cat==8;
ge ex27=impute_exp_cat==9;
ge ex30=impute_exp_cat==10;
ge ex33=impute_exp_cat==11;

su t1-t90;

local a female age50-age95 arrhythmia hypertension chf peripheral_disease dementia cere_disease 
copd lupus ulc liver_disease cancer diabetes kidney_disease hiv;
local b t1-t90;
local c impute_exp_cat impute_us impute_top20 impute_female_phys impute_spanish;
local e ex6 ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33;
local f white black hisp mcaid mcare private self;
local g fac1-fac212;

*=================================================================================;
*How do ind_beta_im_angs predict outcomes?;

egen zhac=std(hac);

ge dis_home_nurse=0;
replace dis_home_nurse=1 if dis_home==1;
replace dis_home_nurse=1 if dischstat=="03";

su hac dis_home dis_hospital dis_facility dis_died dis_left;

sort faclnbr;

foreach x of varlist gpharmchgs glabchgs gradchgs gmedchgs gcardiochgs goprmchgs gothchgs {;
gen l`x'=log(`x');
};

foreach x of varlist losdays dis_home dis_facility surgery
dis_died dis_left numpr numpr_surg 
lgccr lgpharmchgs lglabchgs lgradchgs lgmedchgs lgcardiochgs lgoprmchgs lgothchgs 
gccr gpharmchgs glabchgs gradchgs gmedchgs gcardiochgs goprmchgs gothchgs {;
egen z`x'=std(`x');
};

ge facyr=string(faclnbr)+string(year);

*=================================================================================;
*=================================================================================;
*Table 9b;
*Betas;

eststo: areg zind_beta_im_ang `e' impute_us impute_top20 impute_female_phys impute_spanish xb_im_ang sub `a', ab(facyr) vce(robust);
eststo: areg zind_beta_im_ang zlag_ind_beta_im_ang ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33
impute_us impute_top20 impute_female_phys impute_spanish xb_im_ang sub `a', ab(facyr) vce(robust);
eststo: areg zind_beta_im_ang zlag_ind_beta_im_ang zlag_ind_alpha_im_ang ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33
impute_us impute_top20 impute_female_phys impute_spanish xb_im_ang sub `a', ab(facyr) vce(robust);

esttab using ${resdir}tab9b.csv, b(4) se(4) r2(2) replace;
eststo clear;

*Alphas;

eststo: areg zind_alpha_im_ang `e' impute_us impute_top20 impute_female_phys impute_spanish xb_im_ang sub `a', ab(facyr) vce(robust);
eststo: areg zind_alpha_im_ang zlag_ind_alpha_im_ang ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33
impute_us impute_top20 impute_female_phys impute_spanish xb_im_ang sub `a', ab(facyr) vce(robust);
eststo: areg zind_alpha_im_ang zlag_ind_alpha_im_ang zlag_ind_beta_im_ang ex9 ex12 ex15 ex18 ex21 ex24 ex27 ex30 ex33
impute_us impute_top20 impute_female_phys impute_spanish xb_im_ang sub `a', ab(facyr) vce(robust);

esttab using ${resdir}tab9b.csv, b(4) se(4) r2(2) replace;
eststo clear;

*=================================================================================;
*Outcomes for full sample of patients (not reported in the paper);

*Table 6;
foreach x of varlist hac dis_died dis_home {;
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' if low==1, ab(facyr) cluster(phyid);
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' if high==1, ab(facyr) cluster(phyid);
};

esttab using ${resdir}tab6.csv, b(3) se(3) r2(2) replace;
eststo clear; 

*Appendix Table A3;
foreach x of varlist hac dis_died dis_home {;
eststo: xi: areg `x' lamb hamb lalb malb `c' xb_im_ang sub `a' if low==1, ab(facyr) cluster(phyid);
eststo: xi: areg `x' lamb hamb lalb malb `c' xb_im_ang sub `a' if high==1, ab(facyr) cluster(phyid);
};

esttab using ${resdir}taba4a.csv, b(3) se(3) r2(2) replace;
eststo clear;

*Appendix Table A4;
foreach x of varlist hac dis_died dis_home {;
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' `f' if low==1, ab(facyr) cluster(phyid);
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' `f' if high==1, ab(facyr) cluster(phyid);
};

esttab using ${resdir}taba5.csv, b(3) se(3) r2(2) replace;
eststo clear;

*=================================================================================;
*=================================================================================;
*Costs;
*High alpha, low beta, low alpha;

*Table 7;

foreach x of varlist angio lgccr losdays {;
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' if low==1, ab(facyr) cluster(phyid);
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' if high==1, ab(facyr) cluster(phyid);
};

esttab using ${resdir}tab7.csv, b(2) se(2) r2(2) replace;
eststo clear;

*Table 8;

foreach x of varlist lgpharmchgs lglabchgs lgradchgs lgmedchgs lgcardiochgs lgoprmchgs lgothchgs {;
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' if low==1, ab(facyr) cluster(phyid);
eststo: xi: areg `x' lind_beta_im_ang lind_alpha_im_ang hind_alpha_im_ang `c' xb_im_ang sub `a' if high==1, ab(facyr) cluster(phyid);
};

esttab using ${resdir}tab8.csv, b(2) se(2) r2(2) replace;
eststo clear;

*=================================================================================;
*=================================================================================;
clear;
log close ;