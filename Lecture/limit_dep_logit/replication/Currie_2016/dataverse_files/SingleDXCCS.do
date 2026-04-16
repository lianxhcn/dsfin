/************************************************************************************
Program Name: SingleDXCCS.do 
Description : Assign Single-Level Diagnosis CCS category array (dxccs#) from Stata. 
Developed   : By Bob Houchens
Updated     : By David Ross on 10/27/2009.
************************************************************************************/

* Generate a unique identifier
*
egen _obs = seq()
*
* Reshape the data into long format with one observation per diagnosis
*
reshape long dx, i(_obs) j(dxnum)
*
* Generate a temporary diagnosis variable that will be reformatted by the clean function in preparation for the merge
*
generate _dx = dx
*
* Check the validity of the diagnosis
*
capture: icd9 check _dx, generate(invalid)
*
* replace invalid temporary diagnoses in preparation for the clean function
*
replace _dx="0000" if invalid > 0 & invalid < 10
drop invalid
*
* Sort by diagnosis.
* Format the temporary diagnosis with a decimal to match the format in singleDXCCS.  Sort by formatted diagnosis.
*
icd9 clean _dx, dots
sort _dx
*
* Merge the CCS category variable, dxccs, that matches the temporary diagnosis
*
merge _dx using "/Users/jvanparys/Documents/papers/AMI/do_files/statasingledxccs/SingleDXCCS.dta", nokeep
* 
* Drop temporary variables and put data in original shape
*
drop _merge _dx
reshape wide dx dxccs, i(_obs) j(dxnum)
drop _obs
