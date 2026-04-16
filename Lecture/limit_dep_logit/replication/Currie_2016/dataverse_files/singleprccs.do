/************************************************************************************
Program Name: SinglePRCCS.do 
Description : Assign Single-Level Procedure CCS category array (prccs#) from Stata. 
Developed   : By Bob Houchens
Updated     : By David Ross on 10/27/2009.
************************************************************************************/

* Generate a unique identifier
*
egen _obs = seq()
*
* Reshape the data into long format with one observation per procedure
*
reshape long pr, i(_obs) j(prnum)
*
* Generate a temporary procedure variable that will be reformatted by the clean function in preparation for the merge
*
generate _pr = pr
*
* Check the validity of the procedure
*
capture: icd9p check _pr, generate(invalid)
*
* replace invalid temporary diagnoses in preparation for the clean function
*
replace _pr="0000" if invalid > 0 & invalid < 10
drop invalid
*
* Format the temporary procedure with a decimal to match the format in singleprCCS.  Sort by formatted procedure.
*
icd9p clean _pr, dots
sort _pr
*
* Merge the CCS category variable, prccs, that matches the temporary procedure
*
merge _pr using "/Users/jvanparys/Documents/papers/AMI/do_files/statasingledxccs/SinglePRCCS.dta", nokeep
*
* Drop temporary variables and put data in original shape
*
drop _merge _pr
reshape wide pr prccs, i(_obs) j(prnum)
drop _obs
