*=================================================================================
*Title: ami_mostca13.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Estimate betas and alphas for each cardiologist
*=================================================================================

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/ab/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/
global resdir /Users/jvanparys/Documents/papers/AMI/results/

log using ${logdir}ami_mostca13.log, replace

*=================================================================================
*AMI
#delimit ;

guse ${datadir1}ip_ami_predict_year_er_mostca.dta;

keep sys_recid time new_id surgery invasive angio
xb_overall_ang xb_overall_inv xb_ca_ang xb_ca_inv xb_im_ang xb_im_inv
alpha_ang beta_ang se_alpha_ang se_beta_ang alpha_inv beta_inv se_alpha_inv se_beta_inv
alpha_ca_ang beta_ca_ang se_alpha_ca_ang se_beta_ca_ang alpha_ca_inv beta_ca_inv se_alpha_ca_inv se_beta_ca_inv
alpha_im_ang beta_im_ang se_alpha_im_ang se_beta_im_ang alpha_im_inv beta_im_inv se_alpha_im_inv se_beta_im_inv;

*There are 12,456 cells in the ER AMI sample, where we exclude hospital-quarters with 0 invasive procedures,
and where we keep patients with either cardiologists or patients who visit hospitals where at least half of AMI
patients receive cardiologist assignments;

compress;

forvalues x=12001/12456 {;

*Surgery results;
quietly: firthlogit angio xb_overall_ang if new_id==`x';
replace alpha_ang=_b[_cons] if new_id==`x';
replace se_alpha_ang=_se[_cons] if new_id==`x';
replace beta_ang=_b[xb_overall_ang] if new_id==`x';
replace se_beta_ang=_se[xb_overall_ang] if new_id==`x';

quietly: firthlogit angio xb_ca_ang if new_id==`x';
replace alpha_ca_ang=_b[_cons] if new_id==`x';
replace se_alpha_ca_ang=_se[_cons] if new_id==`x';
replace beta_ca_ang=_b[xb_ca_ang] if new_id==`x';
replace se_beta_ca_ang=_se[xb_ca_ang] if new_id==`x';

quietly: firthlogit angio xb_im_ang if new_id==`x';
replace alpha_im_ang=_b[_cons] if new_id==`x';
replace se_alpha_im_ang=_se[_cons] if new_id==`x';
replace beta_im_ang=_b[xb_im_ang] if new_id==`x';
replace se_beta_im_ang=_se[xb_im_ang] if new_id==`x';

*Invasive results;
quietly: firthlogit invasive xb_overall_inv if new_id==`x';
replace alpha_inv=_b[_cons] if new_id==`x';
replace se_alpha_inv=_se[_cons] if new_id==`x';
replace beta_inv=_b[xb_overall_inv] if new_id==`x';
replace se_beta_inv=_se[xb_overall_inv] if new_id==`x';

quietly: firthlogit invasive xb_ca_inv if new_id==`x';
replace alpha_ca_inv=_b[_cons] if new_id==`x';
replace se_alpha_ca_inv=_se[_cons] if new_id==`x';
replace beta_ca_inv=_b[xb_ca_inv] if new_id==`x';
replace se_beta_ca_inv=_se[xb_ca_inv] if new_id==`x';

quietly: firthlogit invasive xb_im_inv if new_id==`x';
replace alpha_im_inv=_b[_cons] if new_id==`x';
replace se_alpha_im_inv=_se[_cons] if new_id==`x';
replace beta_im_inv=_b[xb_im_inv] if new_id==`x';
replace se_beta_im_inv=_se[xb_im_inv] if new_id==`x';

};

su;
sort sys_recid;

gsave ${datadir2}ip_betas_13000_ami_er_mostca.dta, replace;

*=================================================================================;

clear;
log close ;