*=================================================================================
*Title: readme.do
*Author: Jessica Van Parys 
*Date modified: 7/15/2016
*Data: Florida AHCA Inpatient Databases 1992-2014
*Purpose: Order of do-files to create final sample of data and results.

*=================================================================================
*Authors: Janet Currie, W. Bentley MacLeod, and Jessica Van Parys
*Title: Provider Practice Style and Patient Health Outcomes: Evidence from Heart Attacks
*Journal: The Journal of Health Economics
*Year: 2016
*=================================================================================
*=================================================================================

#delimit;

*=================================================================================;
*Sample construction;
*=================================================================================;

1. do ${dodir}ip_clean.do, forvalues x=1992/2014 and y=1/4; 
*Creates ip`x'`y'_clean.dta;

2. do ${dodir}ip_hac.do, forvalues x=1992/2014 and y=1/4;
*Creates ip`x'`y'_hac.dta;

3. do ${dodir}append_ip.do;
*Appends IP data for 1992-2014;
*Keeps only AMI codes (dx = 410) or angina codes (dx = 411.1);
*Codes procedure categories;
*Creates ${datadir1}ip_ami_angina.dta;

4. do ${dodir}phys_merge_atten.do;
*Merges with attending physician license data;
*Keeps matches. Loses ~2% of sample;
*Codes physician characteristics;
*Creates ${datadir1}phys_merge_atten_ami_angina.dta;

5. do ${dodir}phys_merge_oper.do;
*Merges with operating physician license data;
*Keeps matches;
*Codes physician characteristics;
*Creates ${datadir1}phys_merge_oper_ami_angina.dta;

6. do ${dodir}phys_merge_other.do;
*Merges with other physician license data;
*Keeps matches;
*Codes physician characteristics;
*Creates ${datadir1}phys_merge_other_ami_angina.dta;

7. do ${dodir}phys_merge_all.do;
*Combines attending, operating, and other physician files;
*Creates ${datadir1}phys_merge_all_ami_angina.dta;

8. do ${dodir}clean_ami.do;
*Restricts the sample;
*Excludes patients diagnosed with angina/keeps patients with AMI;
*Excludes AMI patients who do not enter through the ED;
*Excludes patients who go to hospital in quarters when no invasive procedures are performed;
*Creates ${datadir1}ip_ami_clean_er.dta;

9. do ${dodir}impute_ca.do;
*Imputes cardiologists to patients without cardiologists based on same hospital-year-qtr-weekday;
*Creates ${datadir1}ip_ami_match_er.dta;

10. do ${dodir}predict_ami_year.do;
*Generates XB index for (1) average practice styles, (2) practice styles at internal-medicine-accredited 
institutions, and (3) practice styles at cardiology-accredited institutions;
*Generates XB index for angio/cardiac cath procedures as well as "invasive" procedures;
*Uses full sample;
*Creates ${datadir1}ip_ami_predict_year_er.dta;

11. do ${dodir}predict_ami_year_mostca.do;
*Generates XB index for (1) average practice styles, (2) practice styles at internal-medicine-accredited 
institutions, and (3) practice styles at cardiology-accredited institutions;
*Generates XB index for angio/cardiac cath procedures as well as "invasive" procedures;
*Uses restricted sample for robustness;
*Creates ${datadir1}ip_ami_predict_year_er_mostca.dta;

**Following do-files are in the "ab" folder;
*Estimate betas and alphas for each cardiologist;
do ${dodir}ami_angio`x'.do, forvalues x=1/13 for full sample;
do ${dodir}ami_angio_mostca`x'.do, forvalues x=1/13 for robust sample;
**;

12. do ${dodir}betas.do;
*Creates remaining variables;
*Saves final data set: ${datadir1}ip_ami_final_er.dta;

13. do ${dodir}betas_mostca.do;
*Creates remaining variables;
*Saves final data set: ${datadir}ip_ami_final_er_mostca.dta;

*=================================================================================;
*Results Files;
*=================================================================================;

1. do ${dodir}means.do;
*Creates sample means: Tables 1, 2, 3, 4, 5a, 5b;

2. do ${dodir}reg_mostca.do;
*Creates Tables 6a, 7, 8, 9, A3, and A4;

3. do ${dodir}reg_all.do;
*Creates Table 9b, 6b, and other tables for full sample (not presented in published paper);

4. do ${dodir}table9c_10.do;
*Creates Table 9c and Table 10;

5. do ${dodir}robust1.do;
*Creates results for response to journal reviewers;

6. do ${dodir}robust2.do;
*Creates Table 5c;

*=================================================================================;
*=================================================================================;

clear;
log close ;