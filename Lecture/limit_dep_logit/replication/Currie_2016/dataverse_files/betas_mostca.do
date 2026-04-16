*=================================================================================
*Title: betas.do
*Author: Jessica Van Parys
*Date modified: 7/15/2016
*Data: In-patient for FL. Core files for 1992-2014.
*Purpose: Put together final data set
*=================================================================================

clear
set matsize 10000
set more off
capture log close

global datadir1 /Users/jvanparys/Documents/papers/AMI/data/
global datadir2 /Users/jvanparys/Documents/papers/AMI/data/ab/
global datadir3 /Users/jvanparys/Documents/papers/AMI/data/aha/
global datadir4 /Users/jvanparys/Documents/papers/AMI/data/phys/
global logdir /Users/jvanparys/Documents/papers/AMI/logs/
global resdir /Users/jvanparys/Documents/papers/AMI/results/

log using ${logdir}betas_mostca.log, replace

*=================================================================================
*AMI
#delimit ;

*=================================================================================;
*Alphas and betas estimated at the imputed-physician level;

forvalues x=1(1)13 {;
guse ${datadir2}ip_betas_`x'000_ami_er_mostca_robust.dta;
su;
keep if alpha_ang!=. & beta_ang!=.;
local a alpha_ang beta_ang se_alpha_ang se_beta_ang alpha_inv beta_inv se_alpha_inv se_beta_inv
alpha_ca_ang beta_ca_ang se_alpha_ca_ang se_beta_ca_ang alpha_ca_inv beta_ca_inv se_alpha_ca_inv se_beta_ca_inv
alpha_im_ang beta_im_ang se_alpha_im_ang se_beta_im_ang alpha_im_inv beta_im_inv se_alpha_im_inv se_beta_im_inv;

keep sys_recid `a';
su sys_recid `a';
foreach y of local a {;
rename `y' ind_`y';
};

save ${datadir2}ip_betas_`x'000s_ami_er_mostca_robust.dta, replace;
clear; 
};

*=================================================================================;
*Append all estimates together;

use ${datadir2}ip_betas_1000s_ami_er_mostca_robust.dta;
forvalues x=2(1)13 {;
append using ${datadir2}ip_betas_`x'000s_ami_er_mostca_robust.dta;
};
sort sys_recid;
su;
save ${datadir2}ip_betas_1_13000_er_mostca_robust.dta, replace;

*=================================================================================;
*Merge estimates with main data set;

guse ${datadir1}ip_ami_predict_year_er_mostca.dta;
*drop c_female-row2 b_female-row;
drop alpha_ang beta_ang se_alpha_ang se_beta_ang alpha_inv beta_inv se_alpha_inv se_beta_inv
alpha_ca_ang beta_ca_ang se_alpha_ca_ang se_beta_ca_ang alpha_ca_inv beta_ca_inv se_alpha_ca_inv se_beta_ca_inv
alpha_im_ang beta_im_ang se_alpha_im_ang se_beta_im_ang alpha_im_inv beta_im_inv se_alpha_im_inv se_beta_im_inv;

sort sys_recid;
merge sys_recid using ${datadir2}ip_betas_1_13000_er_mostca.dta;
tab _merge;
keep if _merge==3;
drop _merge;

*=================================================================================;

replace radchgs=radchgs+therchgs+nuclchgs+ctscanchgs+mrichgs+occupchgs if year<2006;

sort faclnbr year;
merge faclnbr year using ${datadir3}fl_2001_2011_ahal_c2c.dta;
tab _merge;
drop if _merge==2;
drop _merge;
sort faclnbr year;
by faclnbr year: ge temp=gapicc if year==2001;
by faclnbr: egen gapicc_temp=min(temp);
replace gapicc=gapicc_temp if year<2001;
by faclnbr year: ge temp2=gapicc if year==2011;
by faclnbr: egen gapicc_temp2=max(temp2);
replace gapicc=gapicc_temp2 if year>2011;

ge ltchgs=log(tchgs);
ge gccr=tchgs*gapicc;
ge lgccr=log(gccr);

*=================================================================================;
*Code patient race and payer;

destring race, force replace;
replace race=. if race==8;
replace race=. if missing(race);

gen mcaid=1 if payer=="C" | payer=="D" | payer=="O";
replace mcaid=0 if payer=="A" | payer=="B" | payer=="E" | payer=="F"
| payer=="G" | payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="L"
| payer=="M" | payer=="N";
replace mcaid=. if payer=="P";
replace mcaid=. if missing(payer);

gen mcaid_hmo=1 if payer=="D";
replace mcaid_hmo=0 if payer=="A" | payer=="B" | payer=="C" | payer=="E" | payer=="F"
| payer=="G" | payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="L"
| payer=="M" | payer=="N" | payer=="O";
replace mcaid=. if payer=="P";
replace mcaid=. if missing(payer);

gen mcare=1 if payer=="A" | payer=="B";
replace mcare=0 if payer=="C" | payer=="D" | payer=="E" | payer=="F"
| payer=="G" | payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="L"
| payer=="M" | payer=="N" | payer=="O";
replace mcare=. if payer=="P";
replace mcare=. if missing(payer);

gen mcare_hmo=1 if payer=="B";
replace mcare_hmo=0 if payer=="A" | payer=="C" | payer=="D" | payer=="E" | payer=="F"
| payer=="G" | payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="L"
| payer=="M" | payer=="N" | payer=="O";
replace mcare=. if payer=="P";
replace mcare=. if missing(payer);

gen private=1 if payer=="E" | payer=="F" | payer=="G";
replace private=0 if payer=="A" | payer=="B" | payer=="C" | payer=="D"
| payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="L"
| payer=="M" | payer=="N" | payer=="O";
replace private=. if payer=="P";
replace private=. if missing(payer);

gen private_hmo=1 if payer=="F";
replace private_hmo=0 if payer=="A" | payer=="B" | payer=="C" | payer=="D"
| payer=="E" | payer=="G" | payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="L"
| payer=="M" | payer=="N" | payer=="O";
replace private=. if payer=="P";
replace private=. if missing(payer);

gen self=1 if payer=="L" | payer=="N";
replace self=0 if payer=="A" | payer=="B" | payer=="C" | payer=="D"
| payer=="E" | payer=="F" | payer=="G" | payer=="H" | payer=="I" 
| payer=="J" | payer=="K" | payer=="M" | payer=="O";
replace self=. if payer=="P";
replace self=. if missing(payer);

gen other=1 if payer=="H" | payer=="I" | payer=="J" | payer=="K" | payer=="M";
replace other=0 if payer=="A" | payer=="B" | payer=="C" | payer=="D"
| payer=="E" | payer=="F" | payer=="G" | payer=="L" | payer=="N" | payer=="O";
replace other=. if payer=="P";
replace other=. if missing(payer);

sum sys_recid private private_hmo mcaid_hmo mcare_hmo self other;

*There is a problem with white Hispanics in Miami-Dade
from 2006-2009;
*For that reason, just code race as white, black, or other;

gen white=1 if race==4 & year<2010;
replace white=0 if race!=4 & year<2010;
replace white=1 if race==5 & year>2009;
replace white=0 if race!=5 & year>2009;
replace white=. if race==.;

gen black=1 if race==3;
replace black=0 if race!=3;
replace black=. if race==.;

gen hisp=1 if race==6 & year<2010;
replace hisp=1 if race==5 & year<2010;
replace hisp=0 if race!=5 & race!=6 & year<2010;
replace hisp=1 if race==9 & year>2009;
replace hisp=0 if race!=9 & year>2009;
replace hisp=. if race==.;

gen other_race=0;
replace other_race=1 if white!=1 & black!=1 & hisp!=1;
replace other_race=. if race==.;

sum female white black other_race hisp;

*=================================================================================;
*Code characteristics for attendings, operatings, and other physicians;

replace attenphyid="." if missing(attenphyid);
replace operphyid="." if missing(operphyid);
replace otherphyid="." if missing(otherphyid);

ge atten=attenphyid!=".";
ge oper=operphyid!=".";
ge other_phy=otherphyid!=".";
su atten oper other_phy;

foreach x of varlist firstname lang1 lang2 medschool meddate resdate_max {;
rename `x' atten_`x';
};

replace impute_o=1 if impute_fp==1;
replace o=1 if fp==1;
replace oper_o=1 if oper_fp==1;
replace other_o=1 if other_fp==1;

drop impute_ex*;

*================================================================================;
*Generate ME vs. OS physicians;

gen atten_me=0;
replace atten_me=1 if substr(attenphyid,1,2)=="ME";
gen oper_me=0;
replace oper_me=1 if substr(operphyid,1,2)=="ME";
gen other_me=0;
replace other_me=1 if substr(otherphyid,1,2)=="ME";
gen impute_me=0;
replace impute_me=1 if substr(phyid,1,2)=="ME";

*=================================================================================;
*Generate Physician Gender and Language Ability;

global a impute atten oper other;

foreach x of global a {;
rename `x'_firstname first;
sort first;
merge first using ${datadir4}names_new.dta;
tab _merge;
drop if _merge==2;

ge `x'_female_phys=.;
replace `x'_female_phys=1 if gender=="f";
replace `x'_female_phys=0 if gender=="m";

rename first `x'_first;
drop _merge;

gen `x'_spanish=1 if `x'_lang1=="SPANISH" | `x'_lang2=="SPANISH";
replace `x'_spanish=0 if `x'_lang1!="SPANISH" & `x'_lang2!="SPANISH";

replace `x'_lang1="." if missing(`x'_lang1);
replace `x'_lang2="." if missing(`x'_lang2);

gen `x'_oth_language=0;
replace `x'_oth_language=1 if `x'_lang1!="." & `x'_lang1!="SPANISH";
replace `x'_oth_language=1 if `x'_lang2!="." & `x'_lang2!="SPANISH";

*=====================================================================================;
*Generate Medical School Country;

gen `x'_us=0;
local a ALABAMA ALASKA ARIZONA ARKANSAS CALIFORNIA COLORADO CONNECTICUT DELAWARE FLORIDA
GEORGIA HAWAII IDAHO ILLINOIS INDIANA IOWA KANSAS KENTUCKY LOUISIANA MAINE MASSACH`useTTS
MICHIGAN MINNESOTA MISSISSIPPI MISSOURI MONTANA NEBRASKA NEVADA HAMPSHIRE JERSEY 
CAROLINA OHIO OKLAHOMA OREGON PENNSYLVANIA RHODE DAKOTA TENNESSEE TEXAS UTAH VERMONT
VIRGINIA WASHINGTON WISCONSIN WYOMING 

OSTEO KIRKSVILLE ALBANY BAYLOR BOSTON COLUMBIA CORNELL CREIGHTON DARTMOUTH DAVILA
DREXEL DUKE EMORY GEORGETOWN HOWARD JEFFERSON HOPKINS ERIE LINCOLN LOYOLA MARSHALL
MAYO MEHARRY MERCER MIDWESTERN MOREHO`use SINAI NORTHEASTERN SOUTHEASTERN PHILADELPHIA
ROSALIND RUSH STANFORD SUNY TEMPLE TOURO TUFTS TULANE UNIFORMED CINCINNATI UMDNJ
MIAMI PIKEVILLE PITTSBURGH ROCHESTER TOLEDO VANDERBILT WAYNE WRIGHT YALE YESHIVA
EINSTEIN BOWMAN BROWN CHICAGO DOWNSTATE FURMAN GEORGETOEN HAHNEMAN HARVARD QUILLEN
LSU MCP NOVA NSU ROSALAND STONY IRVINE UCLA UCONN UCSD UCSF ARKANAS LOUISVILLE
WORCESTER NJ N.J. MINNEAP JACKSON ALBUQUE ARKNSAS FLORIA MARYLAND MISSISSIPI CALIFOR
USF PENNSYL CONNETICUT PITTSBURG FRANCISCO TENNESSE SOUTHWESTERN SPELMAN RUTGERS RWJ
LOUISANA GEORGETOEN FINCH BUFFALO Kirksville CCOM PRITZKER PSU;

foreach b of local a {;
replace `x'_us=1 if regexm(`x'_medschool, "`b'")==1;
};
replace `x'_us=1 if regexm(`x'_medschool, "Rush Medical College")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UAB")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NEW MEXICO")==1;
replace `x'_us=1 if regexm(`x'_medschool, "CASE WESTERN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "CHARLES DREW")==1;
replace `x'_us=1 if regexm(`x'_medschool, "DES MOINES")==1;
replace `x'_us=1 if regexm(`x'_medschool, "LOMA LINDA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NEW YORK")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ST LOUIS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ST. LOUIS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NEW ENGLAND")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WAKE FOREST")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WESTERN UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ARMED FORCES")==1;
replace `x'_us=1 if regexm(`x'_medschool, "CASE NESTERN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "EASTERN V")==1;
replace `x'_us=1 if regexm(`x'_medschool, "GEORGE WASHN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "LA STATE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED COLL OF")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED COLLEGE OF PA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED COLLEGE OF PENN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED UNIVERSITY OF SOUTH CA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MICH STATE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "PA STATE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "PENN STATE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ROBERT WOOD")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SAINT LOUIS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "HEALTH SCI")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF CT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF FL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF IL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF KY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF NORTH TX")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF OK")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF PA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF S. AL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF S. FL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SOUTH FL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF TN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF TX")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF VT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "HLTH SC")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV. OF CONN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV. OF CA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV.OF FL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF CT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF FL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF MEDICINE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UT SOUTHWESTERN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "VA COMMONWEALTH")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SAN DIEGO")==1;
replace `x'_us=1 if regexm(`x'_medschool, "CHAPEL HILL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SO. FL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SOUTH AL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEMPHIS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "BUFFALO")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY COLLEGE OF M")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF VA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF AR")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF AL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL UNIVERSITY OF SOUTH CA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL UNIVERSITY OF SC")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL UNIVERSITY MD")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MCV VIRGINIA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "COLLEGE OF MEDICAL SCIENCES")==1;
replace `x'_us=1 if regexm(`x'_medschool, "AMERICAN UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Armed Forces Medical College")==1;
replace `x'_us=1 if regexm(`x'_medschool, "COLUBIA UNIVERSITY COLLEGE OF PHYSICIAN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Duke University School of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Eastern Virginia Medical School")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Emory University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Harvard University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "INSTITUTE OF MEDICINE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "INSTITUTE OF MEDICINE I")==1;
replace `x'_us=1 if regexm(`x'_medschool, "INSTITUTE OF MEDICINE II")==1;
replace `x'_us=1 if regexm(`x'_medschool, "LOUSIANA STATE UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Lake Erie College of Osteo Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Louisiana State University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Louisiana State Medical School")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED UNIV OF SC COLL OF MED,CH")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED. COLL OF GA SCH OF MED, AU")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL COLLEGE OF GA.")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL COLLEGE OF PENN. UNIV.")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL COLLEGE OF VIRGINA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Medical College of Virgina")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Mount Sinai School of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Mt. Sinai Medical Center")==1;
replace `x'_us=1 if regexm(`x'_medschool, "N.H. MUNICIPAL MEDICAL COLLEGE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NEW JERSESY MED SCHOOL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NORTH WESTERN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NY UNIV SOM")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NYU SCHOOL OF MEDICINE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Nova Southeastern University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "OH STATE UNIV COLL OF MED COL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "OH STATE UNIV COLL OF MED,COL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Ohio State University School of Medicin")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Philadelphia College of Osteopathic Med")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ST.LOUIS UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "STATE UNIVERSITY OF NY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SWARTHMORE COLLEGE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Southeastern University/Nova")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Southern Illinois University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Stanford University School of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "State University of NY Downstate")==1;
replace `x'_us=1 if regexm(`x'_medschool, "State University of New York Upstate")==1;
replace `x'_us=1 if regexm(`x'_medschool, "The Chicago Medical School")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF AZ COLL OF MED, TUCSON")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF CINCINN COLL OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MD SCH OF MED,BALTIMO")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MD SCH OF MED,BALTIMOR")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MN MEDICAL SCHOOL MINN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF OF FL COLL MED, GAINES")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF SOUTHN AL COLL OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF VA SCH OF MED, CHARLOT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF WA SCH OF MED, SEATTLE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY ILLONOIS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF CALIF-DAVIS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF NC")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF PENNSYVANIA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF SOUTHERN CA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVESITY OF MISSIPPI")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UPSTATE MEDICAL CENTER")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Uiversity of Alabama")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Chicago")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Florida")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Health Sciences, Chicago")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Louisville")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Maryland")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Mississippi")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Oregon Health Sciences")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Pittsburgh School of Medi")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of South Alabama")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of South Florida")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Tennessee College of Medi")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Texas")==1;
replace `x'_us=1 if regexm(`x'_medschool, "VANDERBEILT UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WV UNIV SCH OF MED MORGANTOWN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WV UNIV SCH OF MED, MORGANTOWN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "hahnemann university")==1;

replace `x'_us=1 if regexm(`x'_medschool, "ALBERT EISTEIN COLLEGE OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "AUGUSTA COLLEGE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Albany Medical College")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Albert Ginstein College of MD")==1;
replace `x'_us=1 if regexm(`x'_medschool, "BOSTIN UNIV SCH OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "BRANDEIS UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "CAROL DAVILLA SCH MEDICINE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "CASE WESTER RESERVE UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "COLL OF PHYSICIANS AND SURGEON")==1;
replace `x'_us=1 if regexm(`x'_medschool, "COLLEGE OF PHYSICIANS & SURGEO")==1;
replace `x'_us=1 if regexm(`x'_medschool, "COLLEGE OF PHYSICIANS AND SURG")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Chicago Medical School")==1;

replace `x'_us=1 if regexm(`x'_medschool, "Columbia")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Columbia College of Physicians & Surger")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Cornell University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "DENISON UNIV GRANVILLE OH")==1;
replace `x'_us=1 if regexm(`x'_medschool, "DESMOINES UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Des Moines University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Drexel University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Drexel University College of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Duke School of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "EAST TENNEESSEE STATE UNIVERSI")==1;
replace `x'_us=1 if regexm(`x'_medschool, "EAST TN STATE UNIV.")==1;
replace `x'_us=1 if regexm(`x'_medschool, "EAST TN STATE UNIVERSITY")==1;

replace `x'_us=1 if regexm(`x'_medschool, "Eastern Viriginia Medical")==1;
replace `x'_us=1 if regexm(`x'_medschool, "FERRIS STATE COLLEGE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "FERRIS STATE UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "FSU COLLEGE OF MEDICINE, TALLAHASSEE, F")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Florida State University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "GEORGTOWN UNIV SCH OF MED,DC")==1;
replace `x'_us=1 if regexm(`x'_medschool, "GSU MEDICAL COLLEGE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "George Washington University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Georgetown University SOM")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Georgetown University School of Medicin")==1;
replace `x'_us=1 if regexm(`x'_medschool, "HANEMANN UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "HAVARD MED SCHOOL")==1;

replace `x'_us=1 if regexm(`x'_medschool, "HOBART AND WILLIAM SMITH COLLE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Howard University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "IN UNIV SCH MED INDIAPOL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "IN UNIV SCH OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "IN UNIV SCHOOL OF MEDICINE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "IN UNIVERSITY SCH OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "IN UNIVERSITY SCHOOLOF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "INDIANIA UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Indiana University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Jefferson College of Thomas Jefferson U")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Jefferson Medical college")==1;
replace `x'_us=1 if regexm(`x'_medschool, "LA ST UNIV MED COLL")==1;

replace `x'_us=1 if regexm(`x'_medschool, "LAGUARDIA HOSPITAL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Lake Erie Colle Osteo Med")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Lake Erie College of Osteopathic Medici")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Loma Linda University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Louisiana STATE UNIVERSITY SCH OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Louisiana State Univ")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Loyola University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Loyola University, Stritch School of Me")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MASSACHUSETTS INST. OF TECHNOL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MCV VIRGINA COMMONWEALTH UNIV")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED COL OF GA SCH OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED SCH OF SC")==1;

replace `x'_us=1 if regexm(`x'_medschool, "MED. COLL OF GA SCH OF MED,")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED. COLLEGE OF VA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MED. COLLEGE, UNIVERSITY OF MA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL COLLEGE OF GA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MEDICAL COLLEGE OF VA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MI STATE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MICH ST")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MICHIGAN STATE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MOREHOUSE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Med Coll of Pennsylvania, Hahnemann Sch")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Medical College of Ohio")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Medical College of Wisconsin")==1;

replace `x'_us=1 if regexm(`x'_medschool, "Michigan State")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Midwest")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Morehouse")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NORTHWESTERN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NY College of Osteopathic Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NY MEDICAL COLLEGE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "NYCOM")==1;
replace `x'_us=1 if regexm(`x'_medschool, "New England College of Osteopathic Medi")==1;
replace `x'_us=1 if regexm(`x'_medschool, "New York")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Northeastern")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Nova")==1;
replace `x'_us=1 if regexm(`x'_medschool, "OH ST")==1;

replace `x'_us=1 if regexm(`x'_medschool, "ORAL ROBERT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "OSU College of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "OUHSC")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Ohio")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Oklahoma")==1;
replace `x'_us=1 if regexm(`x'_medschool, "PURDUE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Penn St")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Philadelphia")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Pikeville")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ROBERT JOHNSON MEDICAL SCHOOL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "ROBERT W")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Robert W")==1;

replace `x'_us=1 if regexm(`x'_medschool, "S.U.N.Y")==1;
replace `x'_us=1 if regexm(`x'_medschool, "SOUTHERN ILLINIOS UNIVERSITY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Southeastern College of osteopathic Med")==1;
replace `x'_us=1 if regexm(`x'_medschool, "St Louis University School of Medicine")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Stanford Medical School")==1;
replace `x'_us=1 if regexm(`x'_medschool, "State University of New York- Brooklyn")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Suny")==1;
replace `x'_us=1 if regexm(`x'_medschool, "TUFT'S")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Texas Tech University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Tuft")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Tulane")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UC Davis School of Medicine")==1;

replace `x'_us=1 if regexm(`x'_medschool, "UNI OF FL COLL OF MED GAINES")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF COLL OF MED,GAINESVILL")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF CONN. SCHL OF MEDICINE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF HAWII AT MANOA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF LOIUSVILLE SCH OF MED")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MASSACHUSETTS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MD")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MED & DENISTRY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MEDICAL SCH OF MED, BA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MI")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF MS")==1;

replace `x'_us=1 if regexm(`x'_medschool, "UNI OF PENN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF PITTS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF SC")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF TENNE")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF VA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV OF WI")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIV.OF VA SCH")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF MARLYAND")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MASSACHUSETT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "MASSCHUSETTS")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF MED & DENTISTRY")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF MS")==1;

replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF NV")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF PA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "PENNYSLVANIA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UNIVERSITY OF TENN")==1;
replace `x'_us=1 if regexm(`x'_medschool, "VIRGINA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UTESA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "UTMB")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Univ of AR")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Univ of CT")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University College of Medical Sciences")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Alabama")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Arizona")==1;

replace `x'_us=1 if regexm(`x'_medschool, "Arkansas")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Cincinnati")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Connecticut")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Illinois")==1;
replace `x'_us=1 if regexm(`x'_medschool, "University of Medicine and D")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Miami")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Missouri")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Kansas")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Nebraska")==1;
replace `x'_us=1 if regexm(`x'_medschool, "North Carolina")==1;
replace `x'_us=1 if regexm(`x'_medschool, "South Carolina")==1;
replace `x'_us=1 if regexm(`x'_medschool, "South FL")==1;

replace `x'_us=1 if regexm(`x'_medschool, "Southern California")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Tennessee")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Vermont")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Virginia")==1;
replace `x'_us=1 if regexm(`x'_medschool, "A COMMONWELTH UNIV")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Vanderbuilt")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Virginia Commonwealth")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WEST VA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WEST VIRGINA")==1;
replace `x'_us=1 if regexm(`x'_medschool, "WV UNIV")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Wayne State University")==1;
replace `x'_us=1 if regexm(`x'_medschool, "West Virginia")==1;

replace `x'_us=1 if regexm(`x'_medschool, "Western University of Health Sciences")==1;
replace `x'_us=1 if regexm(`x'_medschool, "Yale")==1;
replace `x'_us=1 if regexm(`x'_medschool, "rush univ")==1;
replace `x'_us=1 if regexm(`x'_medschool, "conneticut")==1;
replace `x'_us=1 if regexm(`x'_medschool, "tennessee")==1;
replace `x'_us=1 if regexm(`x'_medschool, "COLLEGE OF MED. SCIECES,")==1;
replace `x'_us=1 if regexm(`x'_medschool, "sackler")==1;

replace `x'_us=0 if regexm(`x'_medschool, "CAROL DAVILA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "CENTRAL AMERICA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "PUNJAB")==1;
replace `x'_us=0 if regexm(`x'_medschool, "NUESTRA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "DAMASCUS")==1;
replace `x'_us=0 if regexm(`x'_medschool, "DELA SALLE")==1;
replace `x'_us=0 if regexm(`x'_medschool, "DE MIRANDA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "GHANDI")==1;
replace `x'_us=0 if regexm(`x'_medschool, "GR.T.POPA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "DELHI")==1;
replace `x'_us=0 if regexm(`x'_medschool, "CALCUTT")==1;
replace `x'_us=0 if regexm(`x'_medschool, "BULGARIA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "NANJING")==1;
replace `x'_us=0 if regexm(`x'_medschool, "NATIONAL UNIV. OF COLUMBIA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "PANJAB")==1;
replace `x'_us=0 if regexm(`x'_medschool, "SAN JUAN")==1;
replace `x'_us=0 if regexm(`x'_medschool, "TBILISI")==1;
replace `x'_us=0 if regexm(`x'_medschool, "THANJAVUR")==1;
replace `x'_us=0 if regexm(`x'_medschool, "SAN JUA")==1;
replace `x'_us=0 if regexm(`x'_medschool, "DE SAN MARC")==1;
replace `x'_us=0 if regexm(`x'_medschool, "UNIVERSIDAD")==1;
replace `x'_us=0 if regexm(`x'_medschool, "ZHENJIANG")==1;

replace `x'_us=. if `x'_medschool==".";
replace `x'_us=. if `x'_medschool=="COLLEGE OF MEDICINE";
replace `x'_us=. if `x'_medschool=="COLLEGE OF MEDICINE & SURGERY";
replace `x'_us=. if `x'_medschool=="Dates of Attendance";
replace `x'_us=. if `x'_medschool=="FAMILY PRACTICE RESIDENCY PROGRAM";
replace `x'_us=. if `x'_medschool=="MEDICAL SCHOOL";
replace `x'_us=. if `x'_medschool=="School of Medical Sciences";
replace `x'_us=. if `x'_medschool=="UNIVERSITY OF MEDICAL SCHOOL";
replace `x'_us=. if `x'_medschool=="UNKNOWN";
replace `x'_us=. if `x'_medschool=="0";
replace `x'_us=. if `x'_medschool=="1";
replace `x'_us=. if `x'_medschool=="48";
replace `x'_us=. if `x'_medschool=="50";
replace `x'_us=. if `x'_medschool=="32";
replace `x'_us=. if `x'_medschool=="50";
replace `x'_us=. if `x'_medschool=="UNIVERSITY MEDICINE";

tab `x'_medschool if `x'_us==0;

su `x'_us;

*=================================================================================
*Create physician top-20 ranking from research rankings;

*Generate Top 20 Medical School Ranking;
*Note: Some schools are tied, so there are 22 schools in the top 20;

gen `x'_top20=0;
replace `x'_top20=1 if regexm(`x'_medschool, "BAYLOR")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "CASE WEST")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "COLUMBIA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "CORNELL")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "DUKE")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "EMORY")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "HOPKIN")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "SINAI")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "NORTHWESTERN")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF ALABAMA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "LOS ANGELES")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UCLA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF CALIFORNIA-LOS")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "SAN DIEGO")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UCSD")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF CHICAGO")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF MICHIGAN")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF NORTH CAROLINA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF PENNSYLVANIA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF PITTSBURGH")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF ROCHESTER")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIV OF ROCHESTER")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF VIRGINIA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIV OF VIRGINIA")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "UNIVERSITY OF WISCONSIN")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "VANDERBILT")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "WASHINGTON UNIVERSITY")==1;
replace `x'_top20=1 if regexm(`x'_medschool, "YALE")==1;
replace `x'_top20=. if `x'_medschool==".";

replace `x'_top20=0 if regexm(`x'_medschool, "GEORGE WASHINGTON UNIVERSITY")==1;
replace `x'_top20=0 if regexm(`x'_medschool, "LOYOLA UNIVERSITY")==1;
replace `x'_top20=0 if substr(`x'_medschool,1,10)=="UNI. VALLE";
replace `x'_top20=0 if regexm(`x'_medschool, "UNIVERSITY OF MISSOURI")==1;
replace `x'_top20=0 if regexm(`x'_medschool, "SOUTH CAROLINA")==1;

*================================================================================;
*Generate FL Medical School Ranking;

gen `x'_flmed=0;
replace `x'_flmed=1 if regexm(`x'_medschool, "FLORIDA")==1;
replace `x'_flmed=1 if regexm(`x'_medschool, "FL")==1;

*================================================================================;
*Generate Top 20 Medical School Ranking from Primary Care Rankings;

gen `x'_top20_pc=0;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "HARVARD")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "MICHIGAN STATE")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "OREGON HEALTH")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF ALABAMA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF AL")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UCLA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF CALIFORNIA-LOS")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "LOS ANGELES")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF COLORADO")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF IOWA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF IA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF MASSACH`useTTS")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF MA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF MINNESOTA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF MINNESOTA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "MINNEAPOLIS")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF NEBRASKA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF NORTH CAROLINA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF NORTH CAROLINA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF NC")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF PENNSYLVANIA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF PA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF PITTSBURGH")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF ROCHESTER")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF ROCHESTER")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF VIRGINIA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIV OF VIRGINIA")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "UNIVERSITY OF WASHINGTON")==1;
replace `x'_top20_pc=1 if regexm(`x'_medschool, "WAKE FOREST")==1;
replace `x'_top20_pc=. if `x'_medschool==".";

replace `x'_top20_pc=0 if regexm(`x'_medschool, "GEORGE WASHINGTON UNIVERSITY")==1;
replace `x'_top20_pc=0 if regexm(`x'_medschool, "LOYOLA UNIVERSITY")==1;
replace `x'_top20_pc=0 if substr(`x'_medschool,1,10)=="UNI. VALLE";
replace `x'_top20_pc=0 if regexm(`x'_medschool, "UNIVERSITY OF MISSOURI")==1;
replace `x'_top20_pc=0 if regexm(`x'_medschool, "SOUTH CAROLINA")==1;

*=================================================================================;
*Create experience variables;

gen `x'_exp_med=pat_date-`x'_meddate;
gen `x'_exp_med_yr=`x'_exp_med/365;

gen `x'_exp_res=pat_date-`x'_resdate_max;
gen `x'_exp_res_yr=`x'_exp_res/365;

replace `x'_exp_med_yr=`x'_exp_res_yr+3 if `x'_exp_med_yr==.;
replace `x'_exp_med_yr=`x'_exp_res_yr+3 if missing(`x'_exp_med_yr);

replace `x'_exp_res_yr=`x'_exp_med_yr-3 if `x'_exp_res_yr==.;
replace `x'_exp_res_yr=`x'_exp_med_yr-3 if missing(`x'_exp_res_yr);
replace `x'_exp_res_yr=. if `x'_exp_res_yr<-4;

replace `x'_exp_res_yr=0 if `x'_exp_res_yr<0 & `x'_exp_res_yr!=.;
replace `x'_exp_res_yr=. if `x'_exp_res_yr>60;
sum `x'_exp_res_yr, detail;

gen `x'_exp_res1=1 if `x'_exp_res_yr<=r(p25);
replace `x'_exp_res1=0 if `x'_exp_res_yr>r(p25) & `x'_exp_res_yr!=.;
replace `x'_exp_res1=. if missing(`x'_exp_res_yr);

gen `x'_exp_res2=1 if `x'_exp_res_yr>r(p25) & `x'_exp_res_yr<=r(p50);
replace `x'_exp_res2=0 if `x'_exp_res_yr<=r(p25) | `x'_exp_res_yr>r(p50);
replace `x'_exp_res2=. if missing(`x'_exp_res_yr);

gen `x'_exp_res3=1 if `x'_exp_res_yr>r(p50) & `x'_exp_res_yr<=r(p75);
replace `x'_exp_res3=0 if `x'_exp_res_yr<=r(p50) | `x'_exp_res_yr>r(p75);
replace `x'_exp_res3=. if missing(`x'_exp_res_yr);

gen `x'_exp_res4=1 if `x'_exp_res_yr>r(p75);
replace `x'_exp_res4=0 if `x'_exp_res_yr<=r(p75) & `x'_exp_res_yr!=.;
replace `x'_exp_res4=. if missing(`x'_exp_res_yr);

ge `x'_ex=.;
replace `x'_exp_res_yr=0 if `x'_exp_res_yr<0;
forvalues y=3(3)30 {;
replace `x'_ex=`y' if `y'-3<=`x'_exp_res_yr & `x'_exp_res_yr<`y';
};
replace `x'_ex=33 if 30<=`x'_exp_res_yr;
replace `x'_ex=. if `x'_exp_res_yr==.;
replace `x'_ex=. if missing(`x'_exp_res_yr);

forvalues y=3(3)33 {;
ge `x'_ex`y'=0;
};

replace `x'_exp_res_yr=0 if `x'_exp_res_yr<0;
forvalues y=3(3)30 {;
replace `x'_ex`y'=1 if `y'-3<=`x'_exp_res_yr & `x'_exp_res_yr<`y';
replace `x'_ex`y'=. if `x'_exp_res_yr==.;
replace `x'_ex`y'=. if missing(`x'_exp_res_yr);
};
replace `x'_ex33=1 if 30<=`x'_exp_res_yr & `x'_exp_res_yr!=.;
su `x'_ex3-`x'_ex33;

};
*=================================================================================;
*Create variables;

local z 410.02 410.12 410.22 410.32 410.42 410.52 410.62 410.72 410.82 410.92;
ge sub=0;
forvalues y=1/10 {;
foreach x of local z {;
replace sub=1 if dx`y'=="`x'";
};
};

drop othchgs;
ge othchgs=tchgs-pharmchgs-labchgs-radchgs-medchgs-cardiochgs-oprmchgs;

foreach x of varlist pharmchgs labchgs radchgs medchgs cardiochgs oprmchgs othchgs {;
ge g`x'=`x'*gapicc;
};

*=================================================================================;
*Define surgical and non-surgical procedures;

forvalues x=1/10 {;
ge surgical`x'=1;
replace surgical`x'=0 if pr`x'=="."; 
replace surgical`x'=0 if missing(pr`x'); 
replace surgical`x'=0 if substr(pr`x',1,4)=="01.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="03.3"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="04.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="05.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="06.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="07.1"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="08.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="09.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="10.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="11.2";
replace surgical`x'=0 if substr(pr`x',1,4)=="12.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="14.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="15.0"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="16.2"; 

replace surgical`x'=0 if substr(pr`x',1,2)=="17"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="18.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="20.3"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="21.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="22.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="24.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="25.0"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="26.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="27.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="28.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="29.1"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="31.4"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="33.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="34.2"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="37.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="38.2"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="40.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="41.3"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="42.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="44.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="45.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="48.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="49.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="50.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="51.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="52.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="54.2"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="55.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="56.3"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="57.3"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="58.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="59.2"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="60.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="61.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="62.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="63.0"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="64.1"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="65.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="66.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="67.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="68.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="70.2"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="71.1"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="75.1"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="76.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="83.2"; 

replace surgical`x'=0 if substr(pr`x',1,4)=="85.1"; 
replace surgical`x'=0 if substr(pr`x',1,4)=="86.1"; 

replace surgical`x'=0 if substr(pr`x',1,2)=="87"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="88"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="89"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="90"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="91"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="92"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="93"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="94"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="95"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="96"; 
replace surgical`x'=0 if substr(pr`x',1,2)=="97"; 
};

ge numpr_surg=surgical1+surgical2+surgical3+surgical4+surgical5+surgical6+surgical7+surgical8+surgical9+surgical10;

sum surg* numpr_surg;

*=================================================================================;
*Keep observations with non-missing data;

su sys_recid if atten_us==.;

ge missing_phys_data=0;
foreach x of varlist impute_top20 impute_us impute_exp_res_yr impute_female_phys impute_spanish {;
replace missing_phys_data=1 if `x'==.;
replace `x'=0 if `x'==.;
};
su missing_phys_data;

ge missing_race=0;
replace missing_race=1 if white==.;
replace white=0 if white==.;
replace black=0 if black==.;
replace hisp=0 if hisp==.;

ge missing_ins=0;
replace missing_ins=1 if mcaid==.;
replace mcaid=0 if mcaid==.;
replace mcare=0 if mcare==.;
replace self=0 if self==.;
replace private=0 if private==.;

su ind_beta_im_ang ind_alpha_im_ang female age xb_im_ang arrhythmia losdays hac dis_home gccr tchgs;

keep if ind_beta_im_ang!=. & ind_alpha_im_ang!=. & female!=. & age!=. & xb_im_ang!=.
& arrhythmia!=. & losdays!=. & hac!=. & dis_home!=. & tchgs!=.;

xtile pct=xb_im_ang, nq(100);
su pct;
ge low=0;
replace low=1 if pct<=33;
ge med=0;
replace med=1 if 33<pct & pct<=66;
ge high=0;
replace high=1 if 66<pct;

*=================================================================================;
*Create average characteristics within cells;

replace oper=0 if oper==.;
replace other=0 if other==.;
rename ca atten_ca;
rename im atten_im;
rename o atten_o;
*rename fp atten_fp;

global b me us top20 female_phys spanish oth_language exp_res_yr exp_med_yr ex3 ex6 ex9 ex12
ex15 ex18 ex21 ex24 ex27 ex30 ex33 ca im o;

foreach x of global b {;
replace oper_`x'=0 if oper_`x'==.;
replace other_`x'=0 if other_`x'==.;
};

foreach x of global b {;
ge `x'=atten_`x'+oper_`x'+other_`x';
sort time;
by time: egen sum_`x'=sum(`x');
};

drop num_phys;
ge num_phys=atten+oper+other_phy;
sort time;
by time: egen sum_num_phys=sum(num_phys);

foreach x of global b {;
ge av_`x'=sum_`x'/sum_num_phys;
};

drop av_o;
ge av_o=1-av_ca-av_im;

rename medschooldates atten_medschooldates;
rename graddate atten_graddate;
rename degree atten_degree;
rename otherdegree atten_otherdegree;
rename midname atten_midname;
rename lastname atten_lastname;
rename suffix atten_suffix;
rename mindate atten_mindate;
rename maxdate atten_maxdate;
rename resdate_min atten_resdate_min;
rename activity atten_activity;
rename controlled atten_controlled;
rename issue_date atten_issue_date;
rename disc atten_disc;
rename public atten_public;
rename fp atten_fp;

drop pr31_orig dyrqtr dqtr1-age_dheart31 temp gapicc_temp N;

*=================================================================================;
*Save clean data set;

gsave ${datadir1}ip_ami_final_er_mostca.dta, replace;

su;

*=================================================================================;
*=================================================================================;

clear;
log close ;
