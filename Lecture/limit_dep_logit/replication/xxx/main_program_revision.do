clear 
set more off
cd "C:\Users\Yin Liao\Dropbox\stata Data_MSrevision"

capture ssc install reghdfe
capture ssc install estout
capture ssc install esttab
capture ssc install egenmore

/**********Table 1 Summary Statistics and Randomization Check*****/

clear
use full_sample.dta, replace

gen male=0
replace male = 1 if gender==1
gen informal_insurance = 1/2*(past_dependence+future_dependence)

// Panel A: full sample
summarize male age loanamount annual_income family_size education financial_literacy shame_aversion informal_insurance
// Panel A: control group
summarize male age loanamount annual_income family_size education financial_literacy shame_aversion informal_insurance if group==1
// Panel A: VIS group
summarize male age loanamount annual_income family_size education financial_literacy shame_aversion informal_insurance if group==2
// Panel A: LIS group
summarize male age loanamount annual_income family_size education financial_literacy shame_aversion informal_insurance if group==3


// Panel A: t-test p-value (control-VIS)

clear
use full_sample.dta, replace

gen male=0
replace male = 1 if gender==1
gen informal_insurance = 1/2*(past_dependence+future_dependence)
keep if group==1 |group==2

ttest male, by(group)
ttest age, by(group)
ttest loanamount, by(group)
ttest annual_income, by(group)
ttest family_size, by(group)
ttest education, by(group)
ttest financial_literacy, by(group)
ttest shame_aversion, by(group)
ttest informal_insurance, by(group)

// Panel A: t-test p-value (control-LIS)

clear
use full_sample.dta, replace

gen male=0
replace male = 1 if gender==1
gen formal_loan = borrow_before
gen informal_insurance = 1/2*(past_dependence+future_dependence)
keep if group==1 |group==3

ttest male, by(group)
ttest age, by(group)
ttest loanamount, by(group)
ttest annual_income, by(group)
ttest family_size, by(group)
ttest education, by(group)
ttest financial_literacy, by(group)
ttest shame_aversion, by(group)
ttest informal_insurance, by(group)

//Panel A : t-test p-value (VIS-LIS)

clear
use full_sample.dta, replace

gen male=0
replace male = 1 if gender==1
gen formal_loan = borrow_before
gen informal_insurance = 1/2*(past_dependence+future_dependence)
keep if group==2 |group==3

ttest male, by(group)
ttest age, by(group)
ttest loanamount, by(group)
ttest annual_income, by(group)
ttest family_size, by(group)
ttest education, by(group)
ttest financial_literacy, by(group)
ttest shame_aversion, by(group)
ttest informal_insurance, by(group)

//Panel B: New borrowers
clear
use new_repeat_fullsample.dta, replace

gen male=0
replace male = 1 if gender==1
summarize male age loanamount annual_income family_size education financial_literacy shame_aversion informal_insurance if borrow_before==0

//Panel B: Repeat borrowers
summarize male age loanamount annual_income family_size education financial_literacy shame_aversion informal_insurance if borrow_before==1

//Panel B: t-test p-value (new-repeat)
ttest male, by(borrow_before)
ttest age, by(borrow_before)
ttest loanamount, by(borrow_before)
ttest annual_income, by(borrow_before)
ttest family_size, by(borrow_before)
ttest education, by(borrow_before)
ttest financial_literacy, by(borrow_before)
ttest shame_aversion, by(borrow_before)
ttest informal_insurance, by(borrow_before)

/******Table 2 (no code need: both the number and calculation appeared in the table)****/

/******Table 3 Treatment Effects on Delinquency (main experiment)******/
* The code is for full sample results; repeated borrowers' data and 
* code are not able to be disclosed according to an agreement with partner 
* institution.                                                              
/**********************************************************************/

clear
use delinquent.dta, replace
gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
gen consumption = 0
replace consumption = 1 if loan_use==1

// Full sample (New+repeated borrowers) Column (1) 

keep if VISgroup==1 | Controlgroup==1
probit  Delinquent VISgroup, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (2) 

probit  Delinquent VISgroup gender Age Education log_income log_loansize consumption, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (3) 
probit  Delinquent VISgroup gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (4) 

clear
use delinquent.dta, replace
gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
gen consumption = 0
replace consumption = 1 if loan_use==1

probit  Delinquent VISgroup LISgroup gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

/******* Table 4 (supplementary experiment) ******/
* The data and code for supplementary experiment are not
* able to disclosed according to an agreement with partner 
* institution.       
/**********************************************************/

/****** Table 5 Mechanism analysis: Informal risk insurance *****/
* The code is for full sample results (Panel A); repeated borrowers' data and 
* code (Panel B) are not able to be disclosed according to an agreement with 
* partner institution.                                                              
/**********************************************************************/

clear all
use delinquent.dta, replace
gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
gen consumption = 0
replace consumption = 1 if loan_use==1

keep if VISgroup==1 | Controlgroup==1
egen mdependence=mean(Dependence)
egen pdependence = pctile(Dependence), p(70)

gen  high_dependence = 0
replace high_dependence =1 if Dependence>mdependence
gen VIS_high_dependence = VISgroup*high_dependence

// Full sample (New+repeated borrowers) Column (1) 
probit  Delinquent VISgroup VIS_high_dependence high_dependence, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (2) 
probit  Delinquent VISgroup VIS_high_dependence high_dependence gender Age Education log_income log_loansize consumption, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (3) 

probit  Delinquent VISgroup VIS_high_dependence high_dependence gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (4) 

clear all
use delinquent.dta, replace
gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
gen consumption = 0
replace consumption = 1 if loan_use==1

egen mdependence=mean(Dependence)
gen  high_dependence = 0
replace high_dependence =1 if Dependence>mdependence
gen VIS_high_dependence = VISgroup*high_dependence
gen LIS_high_dependence = LISgroup*high_dependence

probit  Delinquent VISgroup VIS_high_dependence high_dependence LISgroup LIS_high_dependence gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)


/****** Table 6 Mechanism analysis: Shaming penalties ******/
* The code is for full sample results (Panel A); repeated borrowers' data and 
* code (Panel B) are not able to be disclosed according to an agreement with 
* partner institution.                                                              
/**********************************************************************/

clear all
use delinquent.dta, replace
gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
gen consumption = 0
replace consumption = 1 if loan_use==1
egen mshame=mean(Shame_aversion)
keep if VISgroup==1 | Controlgroup==1
//egen pshame = pctile(Shame_aversion), p(25)


//gen  high_shame = 0
//replace high_shame =1 if Shame_aversion>mshame
//gen VIS_high_shame = VISgroup*high_shame

gen  high_shame = 0
replace high_shame =1 if Shame_aversion>mshame
gen VIS_high_shame = VISgroup*high_shame

// Full sample (New+repeated borrowers) Column (1) 
probit  Delinquent VISgroup VIS_high_shame high_shame, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (2) 
probit  Delinquent VISgroup VIS_high_shame high_shame gender Age Education log_income log_loansize consumption, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (3) 
probit  Delinquent VISgroup VIS_high_shame high_shame gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

// Full sample (New+repeated borrowers) Column (4) 
clear all
use delinquent.dta, replace
gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
gen consumption = 0
replace consumption = 1 if loan_use==1
egen mshame=mean(Shame_aversion)


gen  high_shame = 0
replace high_shame =1 if Shame_aversion>mshame
gen VIS_high_shame = VISgroup*high_shame
gen LIS_high_shame = LISgroup*high_shame

probit  Delinquent VISgroup VIS_high_shame high_shame LISgroup LIS_high_shame gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

/**** Table 7 Additional Heterogeneous analysis *****/
clear all
use fullsample_hetergenous.dta, replace
keep if VISgroup==1 | Controlgroup==1


gen log_income = log(Annual_income)
gen log_loansize = log(Loanamount)
encode Gender, gen(gender_dum)
egen mshame=mean(Shame_aversion)


egen mloansize = mean(log_loansize)
gen Low_loansize=0
replace Low_loansize=1 if log_loansize<mloansize

egen mincome = mean(log_income)
gen High_income = 0
replace High_income = 1 if log_income>mincome

gen consumption = 0
replace consumption = 1 if loan_use==1

gen VIS_old = VISgroup*old
gen VIS_male = VISgroup*male
gen VIS_lowloansize = VISgroup*Low_loansize
gen VIS_consumption = VISgroup*consumption
gen VIS_highincome = VISgroup*High_income

probit  Delinquent VISgroup VIS_lowloansize Low_loansize i.Month i.villageID, vce(robust)
margins, dydx(*)

probit  Delinquent VISgroup VIS_consumption  consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

probit  Delinquent VISgroup VIS_old old gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

probit  Delinquent VISgroup VIS_male gender Age Education log_income log_loansize consumption i.Month i.villageID, vce(robust)
margins, dydx(*)

probit  Delinquent VISgroup VIS_highincome High_income i.Month i.villageID, vce(robust)
margins, dydx(*)




