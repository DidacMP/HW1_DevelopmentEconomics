********************************* Question 3 *********************************
* Author: Dídac Martí Pinto
* Date: 25/01/2019
* Course: Development Economics (CEMFI)
********************************************************************************

	clear all
	*global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory!
	cd "$main"

	use "cleaned_data\CIW.dta", replace
 
	* Trim the top and bottom 2%
	_pctile W, nq(100)
	drop if W >r(r98) 
	_pctile I, nq(100)
	drop if I >r(r98) 
	_pctile C, nq(100)
	drop if C >r(r98)
	
	* Conversion to USD 2013 (to make results more interpretable)
	replace C = C/3696.24
	replace I = I/3696.24
	replace W = W/3696.24
	
****** 3.1. *******************************************************************
/*  Plot the level of CIW and labor supply by zone (or district) against the 
level of household income by zone */

collapse (mean) C I W, by(district_code)
drop if I > 5000 // Drop the outlier

* Consumption and income
twoway (scatter C I), title("Levels of consumption and income")
graph export "results\3_1_levCI.png", replace

* Wealth and income
twoway (scatter W I), title("Levels of wealth and income")
graph export "results\3_1_levWI.png", replace


****** 3.2. *******************************************************************
/* Plot the inequality of CIW and labor supply by zone (or district) against the 
level of household income by zone */

	use "cleaned_data\CIW.dta", replace
 
	* Trim the top and bottom 2%
	_pctile W, nq(100)
	drop if W >r(r98) 
	_pctile I, nq(100)
	drop if I >r(r98) 
	_pctile C, nq(100)
	drop if C >r(r98)
	
	* Conversion to USD 2013 (to make results more interpretable)
	replace C = C/3696.24
	replace I = I/3696.24
	replace W = W/3696.24

	* Take logs
	gen log_C = log(C)
	gen log_I = log(I)
	gen log_W = log(W)
	
	* Generate variances
	egen var_C = sd(log_C), by(district_code)
	replace var_C = var_C^2
	egen var_I = sd(log_I), by(district_code)
	replace var_C = var_C^2
	egen var_W = sd(log_W), by(district_code)
	replace var_W = var_W^2
	drop if var_C == . | var_I == . | var_W == .
	
	collapse (mean) var_C var_I var_W I, by(district_code)
	
	* Consumption and income
	twoway (scatter var_C I), title("Inequality of consumption and level of income")
	graph export "results\3_2_ineqCI.png", replace

	* Wealth and income
	twoway (scatter var_W I), title("Inequality of wealth and level of income")
	graph export "results\3_2_ineqWI.png", replace

	
	
****** 3.3. *******************************************************************
/* Plot the covariances of CIW and labor supply by zone (or district) against 
the level of household income by zone. */

	use "cleaned_data\CIW.dta", replace
 
	* Trim the top and bottom 2%
	_pctile W, nq(100)
	drop if W >r(r98) 
	_pctile I, nq(100)
	drop if I >r(r98) 
	_pctile C, nq(100)
	drop if C >r(r98)
	
	* Conversion to USD 2013 (to make results more interpretable)
	replace C = C/3696.24
	replace I = I/3696.24
	replace W = W/3696.24
	
	* Take logs
	gen log_C = log(C)
	gen log_I = log(I)
	gen log_W = log(W)
	
	* Covariances
	sort district_code
	egen cov_CI = corr(C I), by(district_code)
	egen cov_WI = corr(W I), by(district_code)
	
	collapse (mean) cov_CI cov_WI I, by(district_code)
	drop if I>5000
	
	* Consumption and income
	twoway (scatter cov_CI I), title("covariance(C,I) and level of I")
	graph export "results\3_3_covCI.png", replace

	* Wealth and income
	twoway (scatter cov_WI I), title("covariance(W,I) and level of I")
	graph export "results\3_3_covWI.png", replace

	
	

