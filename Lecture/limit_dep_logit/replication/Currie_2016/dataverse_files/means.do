 *=================================================================================
*Title: means.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Estimate means for the sample
*=================================================================================

clear
set matsize 10000
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/aha/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/
global resdir /Users/jvanparys/Documents/papers/AMI/results/

log using ${logdir}means.log, replace

*=================================================================================
*=================================================================================
#delimit ;

guse ${datadir1}ip_ami_final_er_mostca.dta;

foreach x of varlist gccr gpharmchgs glabchgs gradchgs gmedchgs gcardiochgs goprmchgs gothchgs {;
replace `x'=`x'/0.57284 if year==1992;
replace `x'=`x'/0.60906 if year==1993;
replace `x'=`x'/0.63116 if year==1994;
replace `x'=`x'/0.65350 if year==1995;
replace `x'=`x'/0.66927 if year==1996;
replace `x'=`x'/0.67482 if year==1997;
replace `x'=`x'/0.67979 if year==1998;
replace `x'=`x'/0.69155 if year==1999;
replace `x'=`x'/0.70988 if year==2000;
replace `x'=`x'/0.73092 if year==2001;
replace `x'=`x'/0.75749 if year==2002;
replace `x'=`x'/0.80158 if year==2003;
replace `x'=`x'/0.84069 if year==2004;
replace `x'=`x'/0.87267 if year==2005;
replace `x'=`x'/0.91082 if year==2006;
replace `x'=`x'/0.94252 if year==2007;
replace `x'=`x'/0.97050 if year==2008;
replace `x'=`x'/1 if year==2009;
replace `x'=`x'/1.02949 if year==2010;
replace `x'=`x'/1.05181 if year==2011;
replace `x'=`x'/1.07770 if year==2012;
replace `x'=`x'/1.10132 if year==2013;
replace `x'=`x'/1.11591 if year==2014;
};

su any_ca2;

ge p00_6=0;
forvalues x=1/10 {;
replace p00_6=1 if substr(pr`x',1,4)=="00.6";
};
ge p00_66=0;
forvalues x=1/10 {;
replace p00_66=1 if substr(pr`x',1,5)=="00.66";
};
ge p36_0=0;
forvalues x=1/10 {;
replace p36_0=1 if substr(pr`x',1,4)=="36.0";
};
ge p36_1=0;
forvalues x=1/10 {;
replace p36_1=1 if substr(pr`x',1,4)=="36.1";
};
ge p37_21=0;
forvalues x=1/10 {;
replace p37_21=1 if substr(pr`x',1,5)=="37.21";
};
ge p37_22=0;
forvalues x=1/10 {;
replace p37_22=1 if substr(pr`x',1,5)=="37.22";
};
ge p37_23=0;
forvalues x=1/10 {;
replace p37_23=1 if substr(pr`x',1,5)=="37.23";
};
ge p38_93=0;
forvalues x=1/10 {;
replace p38_93=1 if substr(pr`x',1,5)=="38.93";
};

su sys_recid if p00_6==1;
su sys_recid if p00_66==1;

su sys_recid if p36_0==1;
su sys_recid if p36_1==1;
su sys_recid if p37_21==1;
su sys_recid if p37_22==1;
su sys_recid if p37_23==1;
su sys_recid if p38_93==1;

ge o00_66=0;
replace o00_66=1 if p00_66==1 & p36_0==0 & p37_22==0 & p37_23==0;
ge o36_0=0;
replace o36_0=1 if p00_66==0 & p36_0==1 & p37_22==0 & p37_23==0;
ge o37_22=0;
replace o37_22=1 if p00_66==0 & p36_0==0 & p37_22==1 & p37_23==0;
ge o37_23=0;
replace o37_23=1 if p00_66==0 & p36_0==0 & p37_22==0 & p37_23==1;

su sys_recid if o00_66==1;
su sys_recid if o36_0==1;
su sys_recid if o37_22==1;
su sys_recid if o37_23==1;

*=================================================================================;


drop fac4 fac5 phy1 phy;

sort faclnbr;
by faclnbr: gen fac4=_n==1;
egen fac5=sum(fac4);
sort phyid;
by phyid: gen phy1=_n==1;
egen phy=sum(phy1);
sum phy fac5 invasive;

preserve;
keep if angio==1;
sort faclnbr;
by faclnbr: gen fac6=_n==1;
egen fac7=sum(fac6);
sort phyid;
by phyid: gen phy2=_n==1;
egen phy3=sum(phy2);
sum phy3 fac7;
restore;

su ind_alpha_im_ang, detail;
su ind_beta_im_ang, detail;

ge ind_alpha_im_ang_t=ind_alpha_im_ang/ind_se_alpha_im_ang;
ge ind_beta_im_ang_t2=(ind_beta_im_ang-1)/ind_se_beta_im_ang;

su ind_alpha_im_ang_t, detail;
su ind_beta_im_ang_t2, detail;

*=================================================================================;

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

su lalb malb halb if acgme_im==1;
su lamb mamb hamb if acgme_im==1;
su lahb mahb hahb if acgme_im==1;

su lalb malb halb if acgme_im==0;
su lamb mamb hamb if acgme_im==0;
su lahb mahb hahb if acgme_im==0;

*Dummies for regressions - lamb, hamb, lalb, malb, (omitted mamb);
replace lamb=1 if hind_beta_im_ang==1 & lind_alpha_im_ang==1;
replace mamb=1 if hind_beta_im_ang==1 & mind_alpha_im_ang==1;
replace hamb=1 if hind_beta_im_ang==1 & hind_alpha_im_ang==1;
replace malb=1 if hind_alpha_im_ang==1 & lind_beta_im_ang==1;

su lamb hamb lalb malb mamb;
*=================================================================================;
*=================================================================================;

*All;

local a female age white black hisp other_race mcaid mcare private self other;
local b xb_im_ang xb_ca_ang sub numdx arrhythmia-hiv;
local c angio invasive surgery numpr numpr_surg losdays;
local d hac dis_home dis_hospital dis_facility dis_died dis_left;
local e gccr gpharmchgs glabchgs gradchgs gmedchgs gcardiochgs goprmchgs gothchgs;
local f ind_beta_inv ind_alpha_inv ind_beta_im_ang ind_alpha_im_ang ind_beta_ca_inv ind_alpha_ca_inv 
impute_ca impute_im impute_o impute_exp_res_yr impute_me impute_us impute_top20 impute_female_phys impute_spanish;

estpost sum `a' `b' `c' `d' `f';
esttab using ${resdir}means_er.csv, cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") replace;
eststo clear;

estpost sum `e' ;
esttab using ${resdir}means_er_costs.csv, cells("mean(fmt(0)) sd(fmt(0)) min(fmt(0)) max(fmt(0)) count(fmt(0))") replace;
eststo clear;

*Low;
estpost sum `a' `b' `c' `d' `f' if low==1;
esttab using ${resdir}means_er_low.csv, cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") replace;
eststo clear;

estpost sum `e' if low==1;
esttab using ${resdir}means_er_low_costs.csv, cells("mean(fmt(0)) sd(fmt(0)) min(fmt(0)) max(fmt(0)) count(fmt(0))") replace;
eststo clear;

*High;
estpost sum `a' `b' `c' `d' `f' if high==1;
esttab using ${resdir}means_er_high.csv, cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") replace;
eststo clear;

estpost sum `e' if high==1;
esttab using ${resdir}means_er_high_costs.csv, cells("mean(fmt(0)) sd(fmt(0)) min(fmt(0)) max(fmt(0)) count(fmt(0))") replace;
eststo clear;

*=================================================================================;
clear;
log close ;