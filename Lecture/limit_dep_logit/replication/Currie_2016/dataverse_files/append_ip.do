*=================================================================================
*Title: append_ip.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Append IP data
*=================================================================================

clear
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/hosp/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/

log using ${logdir}append_ip.log, replace

#delimit ;

*=================================================================================;
*Create AMI and Hip fracture data sets from the IP HAC data;

forvalues x=1992/2005 {;
forvalues y=1/4 {;
guse ${datadir2}ip`x'`y'_hac.dta;
ge keep=.;
forvalues z=1/10 {;
replace keep=1 if substr(dx`z',1,5)=="411.1";
replace keep=1 if substr(dx`z',1,3)=="410";
};
keep if keep==1;
su sys_recid;
save ${datadir2}ip`x'`y'_ami_angina.dta, replace;
clear;
};
};

forvalues x=2006/2013 {;
forvalues y=1/4 {;
guse ${datadir2}ip`x'`y'_hac.dta;
ge keep=.;
forvalues s=6/10 {;
ge dx`s'=dx`s'_orig;
ge pr`s'=pr`s'_orig;
};
forvalues z=1/10 {;
replace keep=1 if substr(dx`z',1,5)=="411.1";
replace keep=1 if substr(dx`z',1,3)=="410";
};
keep if keep==1;
su sys_recid;
su;
save ${datadir2}ip`x'`y'_ami_angina.dta, replace;
clear;
};
};

forvalues y=1/2 {;
guse ${datadir2}ip2014`y'_hac.dta;
ge keep=.;
forvalues s=6/10 {;
ge dx`s'=dx`s'_orig;
ge pr`s'=pr`s'_orig;
};
forvalues z=1/10 {;
replace keep=1 if substr(dx`z',1,5)=="411.1";
replace keep=1 if substr(dx`z',1,3)=="410";
};
keep if keep==1;
su sys_recid;
su;
save ${datadir2}ip2014`y'_ami_angina.dta, replace;
clear;
};

*=================================================================================;
*Append AMI and Hip Fracture data;

use ${datadir2}ip19921_ami_angina.dta;
append using ${datadir2}ip19922_ami_angina.dta;
append using ${datadir2}ip19923_ami_angina.dta;
append using ${datadir2}ip19924_ami_angina.dta;

forvalues x=1993/2013 {;
forvalues y=1/4 {;
append using ${datadir2}ip`x'`y'_ami_angina.dta;
};
};

forvalues y=1/2 {;
append using ${datadir2}ip2014`y'_ami_angina.dta;
};

tab year;
su;

forvalues x=1/10 {;
replace pr`x'="." if missing(pr`x');
};

*=================================================================================;
*Fix variables;

tab sex;
replace sex="1" if sex=="M";
replace sex="2" if sex=="F";
replace sex="." if sex=="U";
destring sex, force replace;
replace sex=. if sex==3;
replace age=. if age==999;
replace age=. if age>125;

gen female=1 if sex==2;
replace female=0 if sex==1;
replace female=. if sex==3;
replace female=. if missing(sex);
gen age2=age*age;

*=================================================================================;
*Keep only AMI and Hip fracture patients;

gen heart=0;
forvalues x=1/10 {;
replace heart=1 if substr(dx`x',1,3)=="410";
};

gen angina=0;
forvalues x=1/10 {;
replace angina=1 if substr(dx`x',1,5)=="411.1";
};

drop keep;
*Drop patients whose attendings are not physicians;
keep if substr(attenphyid,1,2)=="ME" | substr(attenphyid,1,2)=="OS";

*=================================================================================;
*Create dummy variables for each type of AMI;

tab dx1;
tab dx2;

forvalues x=1/31 {;
ge dheart`x'=0;
};

forvalues x=1/10 {;
replace dheart1=1 if dx`x'=="410.00"; 
};
forvalues x=1/10 {;
replace dheart2=1 if dx`x'=="410.01"; 
};
forvalues x=1/10 {;
replace dheart3=1 if dx`x'=="410.02"; 
};
forvalues x=1/10 {;
replace dheart4=1 if dx`x'=="410.10"; 
};
forvalues x=1/10 {;
replace dheart5=1 if dx`x'=="410.11"; 
};
forvalues x=1/10 {;
replace dheart6=1 if dx`x'=="410.12"; 
};
forvalues x=1/10 {;
replace dheart7=1 if dx`x'=="410.20"; 
};
forvalues x=1/10 {;
replace dheart8=1 if dx`x'=="410.21"; 
};
forvalues x=1/10 {;
replace dheart9=1 if dx`x'=="410.22"; 
};
forvalues x=1/10 {;
replace dheart10=1 if dx`x'=="410.30"; 
};
forvalues x=1/10 {;
replace dheart11=1 if dx`x'=="410.31"; 
};
forvalues x=1/10 {;
replace dheart12=1 if dx`x'=="410.32"; 
};
forvalues x=1/10 {;
replace dheart13=1 if dx`x'=="410.40"; 
};
forvalues x=1/10 {;
replace dheart14=1 if dx`x'=="410.41"; 
};
forvalues x=1/10 {;
replace dheart15=1 if dx`x'=="410.42"; 
};
forvalues x=1/10 {;
replace dheart16=1 if dx`x'=="410.50"; 
};
forvalues x=1/10 {;
replace dheart17=1 if dx`x'=="410.51"; 
};
forvalues x=1/10 {;
replace dheart18=1 if dx`x'=="410.52"; 
};
forvalues x=1/10 {;
replace dheart19=1 if dx`x'=="410.60"; 
};
forvalues x=1/10 {;
replace dheart20=1 if dx`x'=="410.61"; 
};
forvalues x=1/10 {;
replace dheart21=1 if dx`x'=="410.62"; 
};
forvalues x=1/10 {;
replace dheart22=1 if dx`x'=="410.70"; 
};
forvalues x=1/10 {;
replace dheart23=1 if dx`x'=="410.71"; 
};
forvalues x=1/10 {;
replace dheart24=1 if dx`x'=="410.72"; 
};
forvalues x=1/10 {;
replace dheart25=1 if dx`x'=="410.80"; 
};
forvalues x=1/10 {;
replace dheart26=1 if dx`x'=="410.81"; 
};
forvalues x=1/10 {;
replace dheart27=1 if dx`x'=="410.82"; 
};
forvalues x=1/10 {;
replace dheart28=1 if dx`x'=="410.90"; 
};
forvalues x=1/10 {;
replace dheart29=1 if dx`x'=="410.91"; 
};
forvalues x=1/10 {;
replace dheart30=1 if dx`x'=="410.92"; 
};
forvalues x=1/10 {;
replace dheart31=1 if dx`x'=="411.1"; 
};

*=================================================================================;
*AMI;

gen heart_no_proc=0;
replace heart_no_proc=1 if pr1==".";

ge heart_surgery1=0;
replace heart_surgery1=1 if substr(pr1,1,4)=="00.6" | substr(pr1,1,4)=="00.5";
replace heart_surgery1=1 if substr(pr1,1,2)=="35";
replace heart_surgery1=1 if substr(pr1,1,2)=="36";
replace heart_surgery1=1 if substr(pr1,1,2)=="37" & substr(pr1,1,4)!="37.2";
replace heart_surgery1=1 if substr(pr1,1,2)=="38" & substr(pr1,1,4)!="38.2";
replace heart_surgery1=1 if substr(pr1,1,2)=="39";

ge heart_surgery=0;
forvalues x=1/10 {;
replace heart_surgery=1 if substr(pr`x',1,4)=="00.6" | substr(pr`x',1,4)=="00.5";
replace heart_surgery=1 if substr(pr`x',1,2)=="35";
replace heart_surgery=1 if substr(pr`x',1,2)=="36";
replace heart_surgery=1 if substr(pr`x',1,2)=="37" & substr(pr`x',1,4)!="37.2";
replace heart_surgery=1 if substr(pr`x',1,2)=="38" & substr(pr`x',1,4)!="38.2";
replace heart_surgery=1 if substr(pr`x',1,2)=="39";
};

ge keep=0;
replace keep=1 if heart_surgery==1;
forvalues x=1/10 {;
replace keep=1 if heart==1 & substr(pr`x',1,4)=="37.2";
replace keep=1 if heart==1 & substr(pr`x',1,4)=="38.2";
forvalues y=87/99 {;
replace keep=1 if heart==1 & substr(pr`x',1,2)=="`y'";
};
};
replace keep=1 if pr1==".";
su keep;

#delimit cr
*=================================================================================
*Create comorbidity variables

gen arrhythmia=0
forvalues x=1/10 {
replace arrhythmia=1 if dxccs`x'==106
}

gen hypertension=0
forvalues x=1/10 {
replace hypertension=1 if dxccs`x'==98 | dxccs`x'==99
}

gen chf=0
forvalues x=1/10 {
replace chf=1 if dxccs`x'==108
}

gen peripheral_disease=0
forvalues x=1/10 {
replace peripheral_disease=1 if dxccs`x'==114
}

gen dementia=0
forvalues x=1/10 {
replace dementia=1 if dxccs`x'==653
}

gen cere_disease=0
forvalues x=1/10 {
replace cere_disease=1 if dxccs`x'>108 & dxccs`x'<117 & dxccs`x'!=114
}

gen copd=0
forvalues x=1/10 {
replace copd=1 if dxccs`x'==127
}

gen lupus=0
forvalues x=1/10 {
replace lupus=1 if dxccs`x'==210 | dxccs`x'==211
}

gen ulc=0
forvalues x=1/4 {
replace ulc=1 if dxccs`x'==139 | dxccs`x'==140
}

gen liver_disease=0
forvalues x=1/10 {
replace liver_disease=1 if dxccs`x'>149 & dxccs`x'<152
}

gen cancer=0
forvalues x=1/10 {
replace cancer=1 if dxccs`x'>10 & dxccs`x'<48
}

gen diabetes=0
forvalues x=1/10 {
replace diabetes=1 if dxccs`x'>48 & dxccs`x'<51
}

gen hemiplegia=0
forvalues x=1/10 {
replace hemiplegia=1 if substr(dx1,1,3)=="342"
}

gen kidney_disease=0
forvalues x=1/10 {
replace kidney_disease=1 if dxccs`x'>155 & dxccs`x'<159
}

gen hiv=0
forvalues x=1/10 {
replace hiv=1 if dxccs`x'==5 
}

#delimit ;
*=================================================================================;
compress;
su;

ge late=0;
replace late=1 if hr_arrival!="99" & hr_arrival!="." & year>2009;
ge emerg=0;
replace emerg=1 if admsrc=="07" | condtn=="P7" | late==1;

sort year;
by year: sum angina;
by year: sum heart*;

sum heart* angina;

gsave ${datadir1}ip_ami_angina.dta, replace;
clear;

*=================================================================================;
*=================================================================================;

log close ;