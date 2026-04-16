**************************************************************************************************
*** This do file creates the dataset for 							    						*/
*** Tracking Under-Reported Financial Flows:            		                    	        */ 
*** China’s Development Finance and the Aid-Conflict Nexus Revisited						    */
**************************************************************************************************
*** Published in Journal of Conflict Resolution                             			        */
**************************************************************************************************


set more off

*local DIR "China in Africa\Econometrics"
*cd "`DIR'"



***************************************************
** Install "relogit"
***************************************************

cap net install ranktest, from(http://fmwww.bc.edu/RePEc/bocode/r)
cap net install ivreg2, from(http://fmwww.bc.edu/RePEc/bocode/i)
*Download STATA ado file "relogit" from http://gking.harvard.edu/relogit
*Download STATA ado file "btscs" from https://www.prio.org/Data/Stata-Tools/


***************************************************
** Create subfolder "processed2" to store modified files
***************************************************

** checks whether folder "processed2" exists and creates it if not
program define confirmdir, rclass
 	local cwd `"`c(pwd)'"'
	quietly capture cd `"`1'"'
	local confirmdir=_rc 
	quietly cd `"`cwd'"'
	return local confirmdir `"`confirmdir'"'
end 
	confirmdir `"processed2"'		  /* does folder "processed2" exist? */
		if `r(confirmdir)'!=0  {  /* folder does not yet exist */
			mkdir "processed2"  /* makes the folder  */
					      } 
	      else {
			di "folder processed already exists"
			}
program drop confirmdir

** checks whether folder "output" exists and creates it if not
program define confirmdir, rclass
 	local cwd `"`c(pwd)'"'
	quietly capture cd `"`1'"'
	local confirmdir=_rc 
	quietly cd `"`cwd'"'
	return local confirmdir `"`confirmdir'"'
end 
	confirmdir `"output"'		  /* does folder "processed2" exist? */
		if `r(confirmdir)'!=0  {  /* folder does not yet exist */
			mkdir "output"  /* makes the folder  */
					      } 
	      else {
			di "folder processed already exists"
			}
program drop confirmdir




cap log close
log using "processed2\Chinese Aid_dataset", replace


***************************************************
** Prepare GNI data
***************************************************

use "wdi_gdf_data.dta", clear
keep if series_name=="GNI (current US$)"
ren country_code code
keep code _*
reshape long _, i(code) j(year)
ren _ gni
ren code recipient_iso3
sort recipient_iso3 year, stable
save "processed2\gni_all.dta", replace

	
	
***************************************************
** Table 3
***************************************************

use "cwdata.dta", clear

* Column 1
relogit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store relogit_paper

* Column 2
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_paper

* Column 3
keep if year>=2000
keep if prio!=.
quietly logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
drop peaceyrs _spline*
btscs prio year countrynum if inmysample==1, g(peaceyrs) nspline(3)
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_2000

* Add China data
merge n:1 countrynum using "codes.dta", keep(1 3)
drop _merge

merge n:1 recipient_iso3 year using "work_dataset2.dta", keep(1 3)
drop _merge
keep if continent=="Africa"
merge n:1 recipient_iso3 year using "processed2\gni_all.dta", keep(1 3)
drop _merge
gen OFa_all_gni=OFa_all_current/gni*100
label var OFa_all_gni "OF amount/GNI"

* Column 4
quietly logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
drop peaceyrs _spline*
btscs prio year recipient_iso3 if inmysample==1, g(peaceyrs) nspline(3)
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_africa

* Ipolate
tsset countrynum year
sort countrynum year, stable
gen OFn_all1=l.OFn_all
gen OFn_oda1=l.OFn_oda
gen OFa_all_gni1=l.OFa_all_gni
by countrynum: ipolate OFn_all1 year, e gen(OFn_all1i)
by countrynum: ipolate OFn_oda1 year, e gen(OFn_oda1i)
by countrynum: ipolate OFa_all_gni1 year, e gen(OFa_all_gni1i)

save "processed2\finalsample.dta", replace

* Column 5
logit prio c.OFn_all1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

preserve
keep if e(sample)
save "processed2\estimationsample", replace
restore

margins, at(OFn_all=(0(1)10)) dydx(aidshock11) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock11) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock11) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Figure 4
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\figure4", replace

* Create Table 3
estout relogit_paper logit_paper logit_2000 logit_africa int_ofnumbers int_odanumbers int_ofintensity ///
 using "output\table3.txt", replace label delimiter(_tab) noabbrev ///
				cells(b(star fmt(%9.3f)) p(par fmt(3))) style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats( N N_clust aic bic, ///
				labels("Number of observations" "Number of countries" "AIC" "BIC") fmt(0 0 3 3))

				
* Create additional table
estout OFn_all OFn_oda OFa_all_gni ///
 using "output\table3_margins.txt", replace label delimiter(_tab) noabbrev ///
				cells(b(star fmt(%9.3f)) p(par fmt(3))) style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats( N N_clust aic bic, ///
				labels("Number of observations" "Number of countries" "AIC" "BIC") fmt(0 0 3 3))
				
				
				
***************************************************
** Table 4: 2SLS
***************************************************

use "processed2\finalsample.dta", clear
keep if year<=2005
drop if countryname==""
gen code=""
replace code="AGO" if countryname=="Angola"
replace code="BEN" if countryname=="Benin"
replace code="BWA" if countryname=="Botswana"
replace code="BFA" if countryname=="Burkina Faso (Upper Volta)"
replace code="CMR" if countryname=="Cameroon"
replace code="CPV" if countryname=="Cape Verde"
replace code="CAF" if countryname=="Central African Republic"
replace code="TCD" if countryname=="Chad"
replace code="COM" if countryname=="Comoros"
replace code="COG" if countryname=="Congo"
replace code="ZAR" if countryname=="Congo, Democratic Republic of (Zaire)"
replace code="CIV" if countryname=="Cote D'Ivoire"
replace code="DJI" if countryname=="Djibouti"
replace code="EGY" if countryname=="Egypt"
replace code="GNQ" if countryname=="Equatorial Guinea"
replace code="ERI" if countryname=="Eritrea"
replace code="ETH" if countryname=="Ethiopia(1993-)"
replace code="GAB" if countryname=="Gabon"
replace code="GMB" if countryname=="Gambia"
replace code="GHA" if countryname=="Ghana"
replace code="GIN" if countryname=="Guinea"
replace code="GNB" if countryname=="Guinea-Bissau"
replace code="KEN" if countryname=="Kenya"
replace code="LSO" if countryname=="Lesotho"
replace code="LBR" if countryname=="Liberia"
replace code="LBY" if countryname=="Libya"
replace code="MDG" if countryname=="Madagascar (Malagasy)"
replace code="MWI" if countryname=="Malawi"
replace code="MLI" if countryname=="Mali"
replace code="MRT" if countryname=="Mauritania"
replace code="MUS" if countryname=="Mauritius"
replace code="MAR" if countryname=="Morocco"
replace code="MOZ" if countryname=="Mozambique"
replace code="NAM" if countryname=="Namibia"
replace code="NER" if countryname=="Niger"
replace code="NGA" if countryname=="Nigeria"
replace code="RWA" if countryname=="Rwanda"
replace code="STP" if countryname=="Sao Tome and Principe"
replace code="SEN" if countryname=="Senegal"
replace code="SYC" if countryname=="Seychelles"
replace code="SLE" if countryname=="Sierra Leone"
replace code="SOM" if countryname=="Somalia"
replace code="ZAF" if countryname=="South Africa"
replace code="SWZ" if countryname=="Swaziland"
replace code="TZA" if countryname=="Tanzania/Tanganyika"
replace code="TGO" if countryname=="Togo"
replace code="TUN" if countryname=="Tunisia"
replace code="ZMB" if countryname=="Zambia"
replace code="ZWE" if countryname=="Zimbabwe (Rhodesia)"

replace code="COD" if code=="ZAR"
merge 1:1 code year using "taiwanr"
drop if _merge==2
drop _merge

tsset countrynum year
sort countrynum year, stable

* Use same sample as in logit regression
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
keep if e(sample) // keep sample constant to make comparisons

* Column 1
reg prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_africa

* Column 2-3
reg prio OFn_all aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers
ivreg2 prio (OFn_all=taiwanre) aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum) first
est store int_ofnumbersIV

* Column 4-5
reg prio OFn_oda aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers
ivreg2 prio (OFn_oda=taiwanre) aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum) first
est store int_odanumbersIV

* Column 6-7
reg prio OFa_all_gni aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity
ivreg2 prio (OFa_all_gni=taiwanre) aidshock11 aidshock11pos lPTSave_filled lassassinbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum) first
est store int_ofintensityIV

* Create Table 4
estout logit_africa int_ofnumbers int_ofnumbersIV int_odanumbers int_odanumbersIV int_ofintensity int_ofintensityIV ///
 using "output\table4.txt", replace label delimiter(_tab) noabbrev ///
				cells(b(star fmt(%9.3f)) p(par fmt(3))) style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats(rank ll_0 ll r2_a rss mss rmse r2 F df_r df_m N N_clust, ///
				fmt(3))



***************************************************
** Footnote 26: usage of a continuous measure of aid
***************************************************

use "processed2\finalsample.dta", clear

gen ln_aid_usd_2000=log(aid_usd_2000)

logit prio aidpergdp lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_africa
logit prio ln_aid_usd_2000 lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_africa
	
	
	
***************************************************
** Appendix E-1 (old Table 3; variables of interest are not lagged)
***************************************************

use "cwdata.dta", clear

* Column 1
relogit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store relogit_paper

* Column 2
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_paper

* Column 3
keep if year>=2000
keep if prio!=.
quietly logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
drop peaceyrs _spline*
btscs prio year countrynum if inmysample==1, g(peaceyrs) nspline(3)
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_2000

* Add China data
merge n:1 countrynum using "codes.dta", keep(1 3)
drop _merge

merge n:1 recipient_iso3 year using "work_dataset2.dta", keep(1 3)
drop _merge
keep if continent=="Africa"
merge n:1 recipient_iso3 year using "processed2\gni_all.dta", keep(1 3)
drop _merge
gen OFa_all_gni=OFa_all_current/gni*100
label var OFa_all_gni "OF amount/GNI"

* Column 4
quietly logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
drop peaceyrs _spline*
btscs prio year recipient_iso3 if inmysample==1, g(peaceyrs) nspline(3)
keep if year>=2000
logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_africa

* Column 5
logit prio c.OFn_all##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock11) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock11) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock11) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Appendix E-1
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE1", replace

* Create old Table 3
estout relogit_paper logit_paper logit_2000 logit_africa int_ofnumbers int_odanumbers int_ofintensity ///
 using "output\table3_old.txt", replace label delimiter(_tab) noabbrev ///
				cells(b(star fmt(%9.3f)) p(par fmt(3))) style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats( N N_clust aic bic, ///
				labels("Number of observations" "Number of countries" "AIC" "BIC") fmt(0 0 3 3))
	
* Create additional table
estout OFn_all OFn_oda OFa_all_gni ///
 using "output\table3_margins_old.txt", replace label delimiter(_tab) noabbrev ///
				cells(b(star fmt(%9.3f)) p(par fmt(3))) style(fixed) starlevels(* 0.10 ** 0.05 *** 0.01) stats( N N_clust aic bic, ///
				labels("Number of observations" "Number of countries" "AIC" "BIC") fmt(0 0 3 3))


								
***************************************************
** Appendix E-2 (dropped intermediate outcome variables)
***************************************************			
		
use "processed2\finalsample.dta", clear

* Column 5
logit prio c.OFn_all1i##i.aidshock11 aidshock11pos /*lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks*/ linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil /*linstab*/ ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock11) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda1i##i.aidshock11 aidshock11pos /*lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks*/ linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil /*linstab*/ ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock11) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni1i##i.aidshock11 aidshock11pos /*lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks*/ linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population loil /*linstab*/ ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock11) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Appendix E-2
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE2", replace



***************************************************
** Appendix E-3 (replace cubic splines with t, t2, t3)
***************************************************			
		
use "processed2\finalsample.dta", clear
ren peaceyrs peaceyrs1
gen peaceyrs2=peaceyrs1*peaceyrs1
gen peaceyrs3=peaceyrs2*peaceyrs1

* Column 5
logit prio c.OFn_all1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn peaceyrs1 peaceyrs2 peaceyrs3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock11) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn peaceyrs1 peaceyrs2 peaceyrs3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock11) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn peaceyrs1 peaceyrs2 peaceyrs3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock11) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\appendixE3", replace

* Create Appendix E-3
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE3", replace



***************************************************
** Appendix E-4: linear probability model
***************************************************

use "processed2\finalsample.dta", clear

* Column 4
quietly logit prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
drop peaceyrs _spline*
btscs prio year recipient_iso3 if inmysample==1, g(peaceyrs) nspline(3)
reg prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum)
est store logit_africa

* Column 5
reg prio c.OFn_all1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock11) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
reg prio c.OFn_oda1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock11) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
reg prio c.OFa_all_gni1i##i.aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock11) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Appendix E-4
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE4", replace

	

***************************************************
** Appendix E-5: linear probability model with country-fixed effects
***************************************************

use "processed2\finalsample", clear

* Column 4
quietly xtreg prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum) fe
drop peaceyrs _spline*
btscs prio year recipient_iso3 if inmysample==1, g(peaceyrs) nspline(3)
xtreg prio aidshock11 aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn ColdWar _spline1 _spline2 _spline3, cluster(countrynum) fe
est store logit_africa

* Column 5
gen inter=OFn_all1i*aidshock11
xtreg prio OFn_all1i aidshock11 inter aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum) fe
est store int_ofnumbers

predictnl marginal = _b[aidshock11]+_b[inter]*OFn_all1i if e(sample), se(semarginal)
gen conf1 = marginal-1.645*semarginal
gen conf2 = marginal+1.645*semarginal
keep if e(sample) & OFn_all1i>=0 & OFn_all1i<=10
scatter marginal OFn_all1i if e(sample) || line marginal conf1 conf2 OFn_all1i if e(sample) & OFn_all1i>=0 & OFn_all1i<=10, ///
pstyle(p2 p3 p3) sort legend(off) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)") scheme(s1mono) xlabel(0(2)10)
graph save "output\OFn_all", replace

* Column 6
cap drop inter marginal semarginal conf*
gen inter=OFn_oda1i*aidshock11
xtreg prio OFn_oda1i aidshock11 inter aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum) fe
est store int_ofnumbers

predictnl marginal = _b[aidshock11]+_b[inter]*OFn_oda1i if e(sample), se(semarginal)
gen conf1 = marginal-1.645*semarginal
gen conf2 = marginal+1.645*semarginal
keep if e(sample) & OFn_oda1i>=0 & OFn_oda1i<=10
scatter marginal OFn_oda1i if e(sample) || line marginal conf1 conf2 OFn_oda1i if e(sample) & OFn_oda1i>=0 & OFn_oda1i<=10, ///
pstyle(p2 p3 p3) sort legend(off) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)") scheme(s1mono) xlabel(0(2)10)
graph save "output\OFn_oda", replace

* Column 7
cap drop inter marginal semarginal conf*
gen inter=OFa_all_gni1i*aidshock11
xtreg prio OFa_all_gni1i aidshock11 inter aidshock11pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum) fe
est store int_ofnumbers

predictnl marginal = _b[aidshock11]+_b[inter]*OFa_all_gni1i if e(sample), se(semarginal)
gen conf1 = marginal-1.645*semarginal
gen conf2 = marginal+1.645*semarginal
keep if e(sample) & OFa_all_gni1i>=0 & OFa_all_gni1i<=10
scatter marginal OFa_all_gni1i if e(sample) || line marginal conf1 conf2 OFa_all_gni1i, ///
pstyle(p2 p3 p3) sort legend(off) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)") scheme(s1mono) xlabel(0(2)10)
graph save "output\OFa_all_gni", replace

* Create Appendix E-5
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE5", replace

		
							
***************************************************
** Appendix E-6: aid shocks defined at the lowest 25%
***************************************************
	
use "processed2\finalsample.dta", clear

* Column 5
logit prio c.OFn_all1i##i.aidshock22 aidshock22pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock22) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda1i##i.aidshock22 aidshock22pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock22) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni1i##i.aidshock22 aidshock22pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock22) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Appendix E-6
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE6", replace



***************************************************
** Appendix E-7: aid shocks defined at the lowest 20%
***************************************************
	
use "processed2\finalsample.dta", clear

* Column 5
logit prio c.OFn_all1i##i.aidshock55 aidshock55pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock55) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda1i##i.aidshock55 aidshock55pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock55) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni1i##i.aidshock55 aidshock55pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock55) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Appendix E-7
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE7", replace



***************************************************
** Appendix E-8: aid shocks defined at the lowest 10%
***************************************************
	
use "processed2\finalsample.dta", clear

* Column 5
logit prio c.OFn_all1i##i.aidshock44 aidshock44pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofnumbers

margins, at(OFn_all=(0(1)10)) dydx(aidshock44) post
est store OFn_all
marginsplot, scheme(s1mono) level(90) title("(a) Number of OF projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_all", replace

* Column 6
logit prio c.OFn_oda1i##i.aidshock44 aidshock44pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_odanumbers

margins, at(OFn_oda=(0(1)10)) dydx(aidshock44) post
est store OFn_oda
marginsplot, scheme(s1mono) level(90) title("(b) Number of ODA projects") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFn_oda", replace

* Column 7
logit prio c.OFa_all_gni1i##i.aidshock44 aidshock44pos lPTSave_filled lassassinbanks lriotsbanks lstrikesbanks ldemonstrationsbanks linfantmort lnciv lpartautocracy lpartdemocracy lfactionaldemoc lfulldemocracy lln_rgdpc  lln_population  loil linstab ethfrac relfrac ncontig logmtn _spline1 _spline2 _spline3, cluster(countrynum)
est store int_ofintensity

margins, at(OFa_all_gni=(0(0.2)10)) dydx(aidshock44) post
est store OFa_all_gni
marginsplot, scheme(s1mono)	level(90) title("(c) OF amount/GNI") yline(0, lpattern(dash)) xtitle("") ytitle("Effects on Pr(conflict)")
graph save "output\OFa_all_gni", replace

* Create Appendix E-8
cd output
graph combine OFn_all.gph OFn_oda.gph OFa_all_gni.gph, altshrink scheme(s1mono)	row(1) ycommon xcommon
cd ..
sum OFn_all OFn_oda OFa_all_gni if e(sample)	
graph save "output\appendixE8", replace
	

	
***************************************************
** Final commands
***************************************************

cd output
erase OFn_all.gph
erase OFn_oda.gph
erase OFa_all_gni.gph
cd ..

cap log close
