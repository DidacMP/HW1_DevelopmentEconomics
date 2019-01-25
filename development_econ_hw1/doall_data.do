******************************** Data cleaner **********************************
* Author: Dídac Martí Pinto
* Date: 25/01/2019
* Course: Development Economics (CEMFI)
* Instructions: Change the directory on this file and simply run, nothing else 
* has to be changed to build the data. 
********************************************************************************

clear all 
global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory!

* Construct consumption income and wealth
    cd "$main\build_files\"
	do "c_build.do"
	
	cd "$main\build_files\"
	do "i_build.do"
	
	cd "$main\build_files\"
	do "w_build.do"

* Merge CIW
	clear all 
	cd "$main\cleaned_data\"
	use "C.dta", replace
	merge 1:1 hh using "I.dta"
	drop _merge
	merge 1:1 hh using "W.dta"
	drop _merge

* Merge to obtain age and gender
    cd "$main"
    rename hh HHID 
    merge m:m HHID using "raw_data\GSEC2.dta" 
    drop _merge
    keep if h2q4==1 // Keep only the household
    rename h2q8 age 
    rename h2q3 gender
    keep C I W HHID PID district_code urban ea region regurb wgt_X hsize age gender h2q4
	
* Merge to obtain education
	merge 1:1 HHID PID using "raw_data\GSEC4.dta" 
    drop _merge
    keep if h2q4 == 1 
    rename h4q7 educ
    keep C I W HHID PID district_code urban ea region regurb wgt_X hsize age gender h2q4 educ
	
* Basic data cleaning
    drop if I == 0
	drop if C ==.
    drop if C > I + W 
	
* Save final file with CIW
    rename HHID hh 
	save "cleaned_data\CIW.dta", replace
	
	
