*=================================================================================
*Title: phys_merge_all.do
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

log using ${logdir}phys_merge_all.log, replace

#delimit ;

*=================================================================================;
*Merge patient data with license data;

use ${datadir1}phys_merge_atten_ami_angina.dta;
sort sys_recid;
merge sys_recid using ${datadir1}phys_merge_oper_ami_angina.dta;
tab _merge;
drop _merge;
sort sys_recid;
merge sys_recid using ${datadir1}phys_merge_other_ami_angina.dta;
tab _merge;
drop _merge;

ge any_ca=0;
replace any_ca=1 if ca==1 | oper_ca==1;

ge any_ca2=0;
replace any_ca2=1 if ca==1 | oper_ca==1 | other_ca==1;

ge any_im=0;
replace any_im=1 if im==1 | oper_im==1;

ge any_im2=0;
replace any_im2=1 if im==1 | oper_im==1 | other_im==1;

su;

su ca im fp o oper_ca oper_im oper_fp oper_o if any_ca==0;
su ca im fp o oper_ca oper_im oper_fp oper_o if any_ca==1;
su any_im if any_ca==0;
sort sys_recid;

save ${datadir1}phys_merge_all_ami_angina.dta, replace;

*=================================================================================;

clear;
log close ;