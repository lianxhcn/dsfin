
*************************************************************************                                           *************************************************************************
******************                                            ***********
******************    ESTIMATION OF ORDERED CHOICE MODELS    ******************                                            ***********
*************************************************************************                                           *************************************************************************

** ALL THE COMMENTS IN CAPITAL CASE LETTERS

clear
#delimit;

set more off;
capture log close;

log using ordered.log, replace;

use pension2.dta;


* DEPENDENT VARIABLE:  pctstck;

* VALUES:     pctstck=0:    MOSTLY BONDS;
*		pctstck=50:   MIXED;
*		pctstck=100:  MOSTLY STOCKS;


tab pctstck;


* LINEAR REGRESSION MODEL;
*************************;

* MODEL SPECIFICATION AND OLS ESTIMATION;

reg pctstck choice age educ female finc101 prftshr, robust;


* ORDERED PROBIT MODEL;
**********************;

* MODEL SPECIFICATION AND MAXIMUM LIKELIHOOD ESTIMATION;

oprobit pctstck choice age educ female finc101 prftshr, robust;


* ESTIMATED PROBABILITIES (from the ordered probit model);
*********************************************************;

predict ep0 ep50 ep100;

* or, alternatively;

predict p0, outcome(0);
predict p50, outcome(50);
predict p100, outcome(100);

sum p0 p50 p100;


* AVERAGE MARGINAL EFFECTS (from the ordered probit model);
**********************************************************;

* Note: The command "mfx" computes the average marginal effects for any kind of model. It is a post estimation command. Then, it takes the previous estimated model. For nonlinear models, the average marginal effects depend on the whole vector of explanatory variables. Stata computes the effects at the mean values of the regressors;

mfx, predict(p outcome(0));
mfx, predict(p outcome(50));
mfx, predict(p outcome(100));


log close;
