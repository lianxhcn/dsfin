 *=================================================================================
*Title: robust2.do
*Author: Jessica Van Parys
*Date modified: 7/16/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Estimate robustness for responses to reviewers (part 2)
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

log using ${logdir}robust2.log, replace

*=================================================================================
*=================================================================================
#delimit ;

guse ${datadir1}ip_ami_final_er_mostca.dta;

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
*replace mind_beta_im_ang=1 if hind_beta_im_ang==1;

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

ge facyr=string(faclnbr)+string(year);
ge facyrqtr=string(faclnbr)+string(year)+string(qtr);

rename ind_alpha_im_ang alpha_im_ang;
rename ind_beta_im_ang beta_im_ang;

local a xb_im_ang lind_alpha_im_ang hind_alpha_im_ang lind_beta_im_ang 
mind_beta_im_ang alpha_im_ang beta_im_ang sub
female age50 age55 age60 age65 age70 age71 age72 age73 age74 age75 age76
age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88
age89 age90 age95 arrhythmia hypertension chf peripheral_disease 
dementia cere_disease copd lupus ulc liver_disease cancer diabetes
kidney_disease hiv
impute_exp_cat impute_us impute_top20 impute_female_phys impute_spanish;

sort faclnbr year qtr;
foreach x of local a {;
by faclnbr year: egen m`x'=mean(`x');
ge diff_`x'=`x'-m`x';
};

foreach x of varlist diff_xb_im_ang diff_lind_alpha_im_ang diff_hind_alpha_im_ang
diff_lind_beta_im_ang diff_mind_beta_im_ang diff_alpha_im_ang diff_beta_im_ang {;
egen z`x'=std(`x');
};

local b diff_sub diff_female diff_age50 diff_age55 diff_age60 diff_age65 diff_age70 diff_age71 
diff_age72 diff_age73 diff_age74 diff_age75 diff_age76
diff_age77 diff_age78 diff_age79 diff_age80 diff_age81 diff_age82 diff_age83 diff_age84 diff_age85 
diff_age86 diff_age87 diff_age88 diff_age89 diff_age90 diff_age95 diff_arrhythmia diff_hypertension 
diff_chf diff_peripheral_disease diff_dementia diff_cere_disease diff_copd diff_lupus diff_ulc 
diff_liver_disease diff_cancer diff_diabetes diff_kidney_disease diff_hiv
diff_impute_exp_cat diff_impute_us diff_impute_top20 diff_impute_female_phys diff_impute_spanish;

*=================================================================================;
*=================================================================================;
*Responses to reviewer's points (numbered as in document);

*3a. Or the authors could de-mean each physician's mean patient appropriateness index 
from her hospital's mean patient index in the regression described above and omit 
hospital fixed effects;

eststo: reg diff_lind_beta_im_ang zdiff_xb_im_ang `b' if low==1, cluster(phyid);
eststo: reg diff_lind_beta_im_ang zdiff_xb_im_ang `b' if high==1, cluster(phyid);

eststo: reg diff_mind_beta_im_ang zdiff_xb_im_ang `b' if low==1, cluster(phyid);
eststo: reg diff_mind_beta_im_ang zdiff_xb_im_ang `b' if high==1, cluster(phyid);

eststo: reg diff_lind_alpha_im_ang zdiff_xb_im_ang `b' if low==1, cluster(phyid);
eststo: reg diff_lind_alpha_im_ang zdiff_xb_im_ang `b' if high==1, cluster(phyid);

eststo: reg diff_hind_alpha_im_ang zdiff_xb_im_ang `b' if low==1, cluster(phyid);
eststo: reg diff_hind_alpha_im_ang zdiff_xb_im_ang `b' if high==1, cluster(phyid);

esttab using ${resdir}robust_matching.csv, b(4) se(4) r2(2) replace;
eststo clear;

*=================================================================================;
*=================================================================================;
*=================================================================================;

clear;
log close ;