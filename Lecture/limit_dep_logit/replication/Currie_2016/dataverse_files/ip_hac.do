*===================================================================================================
*Title: ip_hac.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Purpose: Code hospital-acquired conditions
*===================================================================================================

cap log close
clear
log using "/Users/jvanparys/Documents/papers/AMI/log_files/ip_hac.log", replace
set matsize 10000
set more off

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/lic/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/hosp/
global datadir3 /Users/jvanparys/Documents/papers/AMI/data/use_lic/

*=========================================================================================
*Keep only most necessary variables. Compress data sets and append
*IP data set

#delimit;

*=========================================================================================;
*1994-2005;

forvalues q=1994/2005 {;
forvalues s=1/4 {;

guse ${datadir2}ip`q'`s'_clean.dta;

*sample 0.001;
*sum *;

*ICD-9-CM codes for hospital-acquired conditions (HACs);
*482.4x Pneumonia due to Staphylococcus (CCS 122);

ge septicemia=0;
ge difficile=0;
ge pneumonia=0;
ge foreign=0;
ge embolism=0;
ge blood=0;
ge ulcer=0;
ge falls=0;
ge catheter=0;
ge vascular=0;
ge glycemic=0;
ge cabg=0;
ge ortho=0;
ge bariatric=0;
ge implant=0;
ge vein=0;
ge venous=0;
ge never_event=0;

foreach x of varlist dx* {;
gen `x'_de=`x';
destring `x'_de, force replace;
};

*=================================================================================
*Other diagnoses;
*Years 1994-2005;

forvalues x=2/10 {;

replace septicemia=1 if substr(dx`x',1,3)=="038";
replace difficile=1 if dx`x'=="008.45";
replace pneumonia=1 if substr(dx`x',1,5)=="482.4";

replace foreign=1 if dx`x'=="998.4";

local a 999.1 999.60 999.61 999.62 999.63 999.69;

foreach n of local a {;
replace embolism=1 if dx`x'=="`n'";
};

replace ulcer=1 if dx`x'=="707.23";
replace ulcer=1 if dx`x'=="707.24";

replace falls=1 if dx`x'_de>799.99 & dx`x'_de<840;
replace falls=1 if dx`x'_de>839.99 & dx`x'_de<855;
replace falls=1 if dx`x'_de>924.99 & dx`x'_de<950;
replace falls=1 if dx`x'_de>990.99 & dx`x'_de<995;

local a 996.64 112.2 590.10 590.11 590.2 590.3 590.80 590.81 595.0 597.0 599.0;

foreach n of local a {;
replace catheter=1 if dx`x'=="`n'";
};

local a 999.31 999.32 999.33;

foreach n of local a {;
replace vascular=1 if dx`x'=="`n'";
};

local a 250.10 250.11 250.12 250.13 250.20 250.21 250.22 250.23 251.0
249.10 249.11 249.20 249.21;

foreach n of local a {;
replace glycemic=1 if dx`x'=="`n'";
};

local a 36.10 36.11 36.12 36.13 36.14 36.15 36.16 36.17 36.18 36.19;

forvalues r=1/10 {;
foreach z of local a {;
replace cabg=1 if dx`x'=="519.2" & pr`r'=="`z'";
};
};

local a 81.01 81.02 81.03 81.04 81.05 81.06 81.07 81.08 81.23 81.24
81.31 81.32 81.33 81.34 81.35 81.36 81.37 81.38 81.83 81.85;

forvalues r=1/10 {;
foreach z of local a {;
replace ortho=1 if dx`x'=="996.67" & pr`r'=="`z'";
replace ortho=1 if dx`x'=="998.59" & pr`r'=="`z'";
};
};

local a 44.38 44.39 44.95;

forvalues r=1/10 {;
foreach z of local a {;
replace bariatric=1 if dx1=="278.01" & dx`x'=="539.01" & pr`r'=="`z'";
replace bariatric=1 if dx1=="278.01" & dx`x'=="539.81" & pr`r'=="`z'";
replace bariatric=1 if dx1=="278.01" & dx`x'=="998.59" & pr`r'=="`z'";
};
};

local a 00.50 00.51 00.52 00.53 00.54 37.80 37.81 37.82 37.83 37.85
37.86 37.87 37.94 37.96 37.98 37.74 37.75 37.76 37.77 37.79 37.89;

forvalues r=1/10 {;
foreach z of local a {;
replace implant=1 if dx`x'=="996.61" & pr`r'=="`z'";
replace implant=1 if dx`x'=="998.59" & pr`r'=="`z'";
};
};

local a 00.85 00.86 00.87 81.51 81.52 81.54;

forvalues r=1/10 {;
foreach z of local a {;
replace implant=1 if dx`x'=="415.11" & pr`r'=="`z'";
replace implant=1 if dx`x'=="415.13" & pr`r'=="`z'";
replace implant=1 if dx`x'=="415.19" & pr`r'=="`z'";
replace implant=1 if dx`x'=="453.40" & pr`r'=="`z'";
replace implant=1 if dx`x'=="453.40" & pr`r'=="`z'";
replace implant=1 if dx`x'=="453.41" & pr`r'=="`z'";
replace implant=1 if dx`x'=="453.42" & pr`r'=="`z'";
replace implant=1 if dx`x'=="453.43" & pr`r'=="`z'";
};
replace venous=1 if dx`x'=="512.1" & pr`r'=="38.93";
};

replace never_event=1 if dx`x'=="E876.5";
replace never_event=1 if dx`x'=="E876.6";
replace never_event=1 if dx`x'=="E876.7";

};

ge hac=0;
replace hac=1 if foreign==1 | embolism==1 | blood==1 | ulcer==1 | falls==1
| catheter==1 | vascular==1 | glycemic==1 | cabg==1 | ortho==1 | bariatric==1
| implant==1 | vein==1 | venous==1 | never_event==1 | septicemia==1 | difficile==1
| pneumonia==1;

*su;

order sys_recid year qtr hac never_event septicemia difficile pneumonia foreign
embolism blood ulcer falls catheter vascular glycemic cabg ortho bariatric
implant vein venous dx* pa* pr*;
su;
compress;

gsave ${datadir2}ip`q'`s'_hac.dta, replace;
clear;

};
};

*=================================================================================
*Primary diagnoses not present on admission;
*Years 2006-2014;

forvalues q=2006/2014 {;
forvalues s=1/4 {;

guse ${datadir2}ip`q'`s'_clean.dta;

*sample 0.001;
*sum *;

*ICD-9-CM codes for hospital-acquired conditions (HACs);
*482.4x Pneumonia due to Staphylococcus (CCS 122);

ge septicemia=0;
ge difficile=0;
ge pneumonia=0;
ge foreign=0;
ge embolism=0;
ge blood=0;
ge ulcer=0;
ge falls=0;
ge catheter=0;
ge vascular=0;
ge glycemic=0;
ge cabg=0;
ge ortho=0;
ge bariatric=0;
ge implant=0;
ge vein=0;
ge venous=0;
ge never_event=0;

su; 
foreach x of varlist dx* {;
gen `x'_de=`x';
destring `x'_de, force replace;
};

*=================================================================================
*Other diagnoses not present on admission;
*Years 2006-2011;

forvalues x=2/31 {;

replace septicemia=1 if substr(dx`x'_orig,1,3)=="038";
replace difficile=1 if dx`x'_orig=="008.45";
replace pneumonia=1 if substr(dx`x'_orig,1,5)=="482.4";

replace foreign=1 if dx`x'_orig=="998.4";

local a 999.1 999.60 999.61 999.62 999.63 999.69;

foreach n of local a {;
replace embolism=1 if dx`x'_orig=="`n'";
};

replace ulcer=1 if dx`x'_orig=="707.23";
replace ulcer=1 if dx`x'_orig=="707.24";

replace falls=1 if dx`x'_orig_de>799.99 & dx`x'_orig_de<840;
replace falls=1 if dx`x'_orig_de>839.99 & dx`x'_orig_de<855;
replace falls=1 if dx`x'_orig_de>924.99 & dx`x'_orig_de<950;
replace falls=1 if dx`x'_orig_de>990.99 & dx`x'_orig_de<995;

local a 996.64 112.2 590.10 590.11 590.2 590.3 590.80 590.81 595.0 597.0 599.0;

foreach n of local a {;
replace catheter=1 if dx`x'_orig=="`n'";
};

local a 999.31 999.32 999.33;

foreach n of local a {;
replace vascular=1 if dx`x'_orig=="`n'";
};

local a 250.10 250.11 250.12 250.13 250.20 250.21 250.22 250.23 251.0
249.10 249.11 249.20 249.21;

foreach n of local a {;
replace glycemic=1 if dx`x'_orig=="`n'";
};
local a 36.10 36.11 36.12 36.13 36.14 36.15 36.16 36.17 36.18 36.19;

forvalues r=1/31 {;
foreach z of local a {;
replace cabg=1 if dx`x'_orig=="519.2" & pr`r'_orig=="`z'";
};
};

local a 81.01 81.02 81.03 81.04 81.05 81.06 81.07 81.08 81.23 81.24
81.31 81.32 81.33 81.34 81.35 81.36 81.37 81.38 81.83 81.85;

forvalues r=1/31 {;
foreach z of local a {;
replace ortho=1 if dx`x'_orig=="996.67" & pr`r'_orig=="`z'";
replace ortho=1 if dx`x'_orig=="998.59" & pr`r'_orig=="`z'";
};
};

local a 44.38 44.39 44.95;

forvalues r=1/31 {;
foreach z of local a {;
replace bariatric=1 if admitdiag=="278.01" & dx`x'_orig=="539.01" & pr`r'_orig=="`z'";
replace bariatric=1 if admitdiag=="278.01" & dx`x'_orig=="539.81" & pr`r'_orig=="`z'";
replace bariatric=1 if admitdiag=="278.01" & dx`x'_orig=="998.59" & pr`r'_orig=="`z'";
};
};

local a 00.50 00.51 00.52 00.53 00.54 37.80 37.81 37.82 37.83 37.85
37.86 37.87 37.94 37.96 37.98 37.74 37.75 37.76 37.77 37.79 37.89;

forvalues r=1/31 {;
foreach z of local a {;
replace implant=1 if dx`x'_orig=="996.61" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="998.59" & pr`r'_orig=="`z'";
};
};

local a 00.85 00.86 00.87 81.51 81.52 81.54;

forvalues r=1/31 {;
foreach z of local a {;
replace implant=1 if dx`x'_orig=="415.11" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="415.13" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="415.19" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="453.40" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="453.40" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="453.41" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="453.42" & pr`r'_orig=="`z'";
replace implant=1 if dx`x'_orig=="453.43" & pr`r'_orig=="`z'";
};
replace venous=1 if dx`x'_orig=="512.1" & pr`r'_orig=="38.93";
};

replace never_event=1 if dx`x'_orig=="E876.5";
replace never_event=1 if dx`x'_orig=="E876.6";
replace never_event=1 if dx`x'_orig=="E876.7";
};

ge hac=0;
replace hac=1 if foreign==1 | embolism==1 | blood==1 | ulcer==1 | falls==1
| catheter==1 | vascular==1 | glycemic==1 | cabg==1 | ortho==1 | bariatric==1
| implant==1 | vein==1 | venous==1 | never_event==1 | septicemia==1 | difficile==1
| pneumonia==1;

su;

*su;

order sys_recid year qtr hac never_event septicemia difficile pneumonia foreign
embolism blood ulcer falls catheter vascular glycemic cabg ortho bariatric
implant vein venous admitdiag dx* pa* pr*;

su;
compress;

gsave ${datadir2}ip`q'`s'_hac.dta, replace;
clear;
};
};

*=========================================================================================;

clear;


log close;
clear
