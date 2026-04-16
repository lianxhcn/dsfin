 *=================================================================================
*Title: predict_ami_year.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Predict whether patients will get certain types of procedures
*Angio = angioplasties and/or cardiac caths
*Uses full sample
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

log using ${logdir}predict_ami_year.log, replace

*=========================================================================================

guse ${datadir1}ip_ami_match_er.dta

#delimit ;

su angio invasive;

*================================================================================;
*Generate physician experience;
drop pat_date impute_exp* N;

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

gen impute_exp_res1=1 if impute_exp_res_yr<=r(p25);
replace impute_exp_res1=0 if impute_exp_res_yr>r(p25) & impute_exp_res_yr!=.;
replace impute_exp_res1=. if missing(impute_exp_res_yr);

gen impute_exp_res2=1 if impute_exp_res_yr>r(p25) & impute_exp_res_yr<=r(p50);
replace impute_exp_res2=0 if impute_exp_res_yr<=r(p25) | impute_exp_res_yr>r(p50);
replace impute_exp_res2=. if missing(impute_exp_res_yr);

gen impute_exp_res3=1 if impute_exp_res_yr>r(p50) & impute_exp_res_yr<=r(p75);
replace impute_exp_res3=0 if impute_exp_res_yr<=r(p50) | impute_exp_res_yr>r(p75);
replace impute_exp_res3=. if missing(impute_exp_res_yr);

gen impute_exp_res4=1 if impute_exp_res_yr>r(p75);
replace impute_exp_res4=0 if impute_exp_res_yr<=r(p75) & impute_exp_res_yr!=.;
replace impute_exp_res4=. if missing(impute_exp_res_yr);

ge impute_ex=.;
replace impute_exp_res_yr=0 if impute_exp_res_yr<0;
forvalues x=3(3)36 {;
replace impute_ex=`x' if `x'-2<=impute_exp_res_yr & impute_exp_res_yr<`x';
};
replace impute_ex=36 if 34<=impute_exp_res_yr;
replace impute_ex=. if impute_exp_res_yr==.;
replace impute_ex=. if missing(impute_exp_res_yr);

sort year;
by year: su ca im o oper_ca oper_im oper_o any_ca any_ca2;

*=================================================================================;
*Classify teaching hospitals from Accreditation Council for Graduate Medical Education (ACGME);

*Cardiovascular disease;
ge acgme_ca=0;
replace acgme_ca=1 if faclnbr==100001 | faclnbr==100022 | faclnbr==100034
| faclnbr==100056 | faclnbr==100151 | faclnbr==100082 | faclnbr==110025
| faclnbr==100059 | faclnbr==100060 | faclnbr==100113 | faclnbr==100170
| faclnbr==120011 | faclnbr==100208 | faclnbr==120008;

*Internal Medicine (broader category that includes cardiovascular disease);
ge acgme_im=0;
replace acgme_im=1 if faclnbr==100131 | faclnbr==100168 | faclnbr==100264
| faclnbr==100082 | faclnbr==100113 | faclnbr==110025 | faclnbr==120011
| faclnbr==100001 | faclnbr==100151 | faclnbr==100170 | faclnbr==100110
| faclnbr==100263 | faclnbr==100022 | faclnbr==100208 | faclnbr==100034
| faclnbr==100059 | faclnbr==100060 | faclnbr==120008 | faclnbr==100006
| faclnbr==100007 | faclnbr==120001 | faclnbr==120002 | faclnbr==23960096
| faclnbr==100250 | faclnbr==100254 | faclnbr==100128 | faclnbr==100056;

su acgme_im acgme_ca;

tab faclnbr if acgme_ca==1;

ge focus=0;
replace focus=1 if acgme_im==1;

ge focus2=0;
replace focus2=1 if acgme_ca==1;

ge focus3=0;
replace focus3=1 if faclnbr==100034 | faclnbr==100059 | faclnbr==100060;

*================================================================================;
*Discharge status;

replace dischstat="." if missing(dischstat);

gen dis_home=.;
replace dis_home=1 if dischstat=="01" | dischstat=="06" | dischstat=="08";
replace dis_home=0 if dischstat!="01" & dischstat!="06" & dischstat!="08";

gen dis_facility=.;
replace dis_facility=1 if dischstat=="02" | dischstat=="03" | dischstat=="04" |
dischstat=="05" | dischstat=="21" | dischstat=="62" | dischstat=="63" | dischstat=="64" |
dischstat=="65" | dischstat=="66" | dischstat=="70" | dischstat=="50" | dischstat=="51";
replace dis_facility=0 if dischstat!="02" & dischstat!="03" & dischstat!="04" &
dischstat!="05" & dischstat!="21" & dischstat!="62" & dischstat!="63" & dischstat!="64" &
dischstat!="65" & dischstat!="66" & dischstat!="70" & dischstat!="50" & dischstat!="51";

gen dis_died=.;
replace dis_died=1 if dischstat=="20";
replace dis_died=0 if dischstat!="20";

gen dis_left=.;
replace dis_left=1 if dischstat=="07";
replace dis_left=0 if dischstat!="07";

ge dis_hospital=0 if dischstat!=".";
replace dis_hospital=1 if dischstat=="02";

replace dis_facility=0 if dis_hospital==1;

*=================================================================================;
*Run predictions;
*Pooled data;

gen yrqtr=string(year)+string(qtr);
gen dyrqtr=string(year)+string(qtr)+dx1;

local a female age age2 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv;
sort yrqtr;
tab yrqtr, gen(t);
ge t=.;
forvalues x=1/90 {;
replace t=`x' if t`x'==1;
};
su t if yrqtr=="19921";

tab qtr, ge(dqtr);

foreach y of varlist dheart* {;
gen age_`y'=age*`y';
};

su age, detail;

ge age45=0;
replace age45=1 if age<46 & age!=.;
ge age50=0;
replace age50=1 if age>45 & age<51;
ge age55=0;
replace age55=1 if age>50 & age<56;
ge age60=0;
replace age60=1 if age>55 & age<61;
ge age65=0;
replace age65=1 if age>60 & age<66;
ge age70=0;
replace age70=1 if age>65 & age<71;
forvalues x=71/90 {;
ge age`x'=0;
replace age`x'=1 if age==`x';
};
ge age95=0;
replace age95=1 if age>90 & age!=.;

local a female arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv;
local d age50-age95;
local f dheart1-dheart31; 
local g dqtr1-dqtr4;
local h t1-t90;

*=================================================================================;
*Run predictions;
**Logit model;

*=================================================================================;
*All;

*Angio procedure is outcome variable;
eststo: xi: logit angio `a' `d' `f' `h', robust;

ge xb_overall_ang=.;
forvalues x=1992/2014 {;
eststo: xi: logit angio `a' `d' `f' `g' if year==`x', robust;
predict xb_`x'_ang, xb;
replace xb_overall_ang=xb_`x'_ang if year==`x';
gen ll_`x'_ang=e(ll);
gen pr_`x'_ang=e(r2_p);
};

*Invasive is outcome variable;
eststo: xi: logit invasive `a' `d' `f' `h', robust;

ge xb_overall_inv=.;
forvalues x=1992/2014 {;
eststo: xi: logit invasive `a' `d' `f' `g' if year==`x', robust;
predict xb_`x'_inv, xb;
replace xb_overall_inv=xb_`x'_inv if year==`x';
gen ll_`x'_inv=e(ll);
gen pr_`x'_inv=e(r2_p);
};

*=================================================================================;
*Cardiology Teaching Hospitals;
*Invasive as outcome variable;

eststo: xi: logit invasive `a' `d' `f' `h' if focus2==1, robust;

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
gen inv_c_`y'=.;
gen inv_n_`y'=.;
};
ge b0_ca_inv=.;

forvalues x=1992/2014 {;
eststo: xi: logit invasive `a' `d' `f' `g' if focus2==1 & year==`x', robust;
gen ll_ca_`x'_inv=e(ll);
gen pr_ca_`x'_inv=e(r2_p);

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace inv_c_`y'=_b[`y'] if year==`x';
};

replace b0_ca_inv=_b[_cons] if year==`x';

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace inv_n_`y'=`y'*inv_c_`y' if year==`x';
};
};

egen row2_inv=rowtotal(inv_n_*);
ge xb_ca_inv=b0_ca_inv+row2_inv;

*=================================================================================;
*Cardiology Teaching Hospitals;
*Angio as outcome variable;

eststo: xi: logit angio `a' `d' `f' `h' if focus2==1, robust;

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
gen ang_c_`y'=.;
gen ang_n_`y'=.;
};
ge b0_ca_ang=.;

forvalues x=1992/2014 {;
eststo: xi: logit angio `a' `d' `f' `g' if focus2==1 & year==`x', robust;
gen ll_ca_`x'_ang=e(ll);
gen pr_ca_`x'_ang=e(r2_p);

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace ang_c_`y'=_b[`y'] if year==`x';
};
replace b0_ca_ang=_b[_cons] if year==`x';

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace ang_n_`y'=`y'*ang_c_`y' if year==`x';
};
};

egen row2=rowtotal(ang_n_*);
ge xb_ca_ang=b0_ca_ang+row2;

*=================================================================================;
*=================================================================================;
*Internal Medicine Teaching Hospitals;
*Invasive procedure is outcome;

eststo: xi: logit invasive `a' `d' `f' `h' if focus==1 & year!=., robust;

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
gen inv_b_`y'=.;
gen inv_m_`y'=.;
};
ge b0_im_inv=.;

forvalues x=1992/2014 {;
eststo: xi: logit invasive `a' `d' `f' `g' if focus==1 & year==`x', robust;
gen ll_im_`x'_inv=e(ll);
gen pr_im_`x'_inv=e(r2_p);

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace inv_b_`y'=_b[`y'] if year==`x';
};
replace b0_im_inv=_b[_cons] if year==`x';

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace inv_m_`y'=`y'*inv_b_`y' if year==`x';
};
};

egen row_inv=rowtotal(inv_m_*);
ge xb_im_inv=b0_im_inv+row_inv;

*=================================================================================;
*Internal Medicine Teaching Hospitals;

eststo: xi: logit angio `a' `d' `f' `h' if focus==1 & year!=., robust;

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
gen ang_b_`y'=.;
gen ang_m_`y'=.;
};
ge b0_im_ang=.;

forvalues x=1992/2014 {;
eststo: xi: logit angio `a' `d' `f' `g' if focus==1 & year==`x', robust;
gen ll_im_`x'_ang=e(ll);
gen pr_im_`x'_ang=e(r2_p);

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace ang_b_`y'=_b[`y'] if year==`x';
};
replace b0_im_ang=_b[_cons] if year==`x';

foreach y of varlist female age50-age95 arrhythmia hypertension chf peripheral_disease dementia
cere_disease copd lupus ulc liver_disease cancer diabetes kidney_disease hiv dheart1-dheart31 {;
replace ang_m_`y'=`y'*ang_b_`y' if year==`x';
};
};

egen row=rowtotal(ang_m_*);
ge xb_im_ang=b0_im_ang+row;

*=================================================================================;

corr xb_overall_ang xb_ca_ang xb_im_ang;
corr xb_overall_inv xb_ca_inv xb_im_inv;

keep if xb_overall_ang!=. & xb_im_ang!=. & xb_ca_ang!=.;

*================================================================================;
*Restrict sample to physicians who treat at least 5 patients every 3 years;

ge exp_id=phyid+string(impute_ex);

sort exp_id;
by exp_id: ge N=_N;
su N, detail;
drop if N<5;
su N, detail;

sort faclnbr;
by faclnbr: gen fac4=_n==1;
egen fac5=sum(fac4);
sort phyid;
by phyid: gen phy1=_n==1;
egen phy=sum(phy1);
sum phy fac5 invasive;

preserve;
keep if invasive==1;
sort faclnbr;
by faclnbr: gen fac6=_n==1;
egen fac7=sum(fac6);
sort phyid;
by phyid: gen phy2=_n==1;
egen phy3=sum(phy2);
sum phy3 fac7;
restore;

egen new_id=group(exp_id);
su new_id;

ge time=string(faclnbr)+string(year)+string(qtr);
egen time_id=group(time);
su time_id;

ge alpha_ang=.;
ge beta_ang=.;
ge se_alpha_ang=.;
ge se_beta_ang=.;

ge alpha_inv=.;
ge beta_inv=.;
ge se_alpha_inv=.;
ge se_beta_inv=.;

ge alpha_ca_ang=.;
ge beta_ca_ang=.;
ge se_alpha_ca_ang=.;
ge se_beta_ca_ang=.;

ge alpha_ca_inv=.;
ge beta_ca_inv=.;
ge se_alpha_ca_inv=.;
ge se_beta_ca_inv=.;

ge alpha_im_ang=.;
ge beta_im_ang=.;
ge se_alpha_im_ang=.;
ge se_beta_im_ang=.;

ge alpha_im_inv=.;
ge beta_im_inv=.;
ge se_alpha_im_inv=.;
ge se_beta_im_inv=.;

gsave ${datadir1}ip_ami_predict_year_er.dta, replace;

estpost su pr_19* pr_20* pr_ca* pr_im*;
esttab using ${resdir}ami_fit_year_er.csv, replace;
eststo clear;

*=================================================================================;
*=================================================================================;
clear;
log close ;