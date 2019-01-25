********************************* Consumption **********************************
* Author: Dídac Martí Pinto
* Date: 25/01/2019
* Course: Development Economics (CEMFI)
********************************************************************************

clear all
*global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory!
cd "$main"

* Create consumption using the data provided by the World Bank
	use "raw_data\UNPS_2013-14_Consumption_Aggregate.dta"
	gen C = cpexp30*12  // Anualize
	label var C "CONSUMPTION"

* Drop duplicates (1 observation dropped)
	sort HHID
	quietly by HHID:  gen dup = cond(_N==1,0,_n) 
	drop if dup > 0 
	
* Small adjustments for the merge
	rename HHID hh
	keep C hh district_code urban ea region regurb wgt_X hsize

* Save consumption
	save "cleaned_data\C.dta", replace
