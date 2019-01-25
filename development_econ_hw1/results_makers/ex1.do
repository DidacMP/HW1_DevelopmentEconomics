********************************* Question 1 ***********************************
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


****** 1.1. *******************************************************************
/* Report average CIW per household separately for rural and urban areas */

	mean(C I W) [pw=wgt_X]
	mean(C I W) [pw=wgt_X] if urban == 0 // Rural
	mean(C I W) [pw=wgt_X] if urban == 1 // Urban
  
/* Results

	All country means:
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   630.4209    8.29261      614.1603    646.6816
           I |   1145.694   31.10042      1084.711    1206.678
           W |   2194.078   76.31621      2044.432    2343.723
--------------------------------------------------------------


	Rural means

             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   575.4472   8.503298      558.7711    592.1232
           I |    970.979   29.89136      912.3583      1029.6
           W |   1907.113   73.77895      1762.423    2051.802
--------------------------------------------------------------


	Urban means
--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   823.9532   21.02565      782.6602    865.2461
           I |    1760.77   89.62197      1584.759    1936.782
           W |   3204.323   221.5019      2769.308    3639.337
--------------------------------------------------------------

*/




****** 1.2. *******************************************************************
/* CIW inequality: (1) Show histogram for CIW separately for rural and urban 
areas; (2) Report the variance of logs for CIW separately for rural and urban 
areas. */

   *** Part (1)

* Consumption 
 twoway (histogram C if urban==0, fcolor(none) lcolor(green)) /*
 */ (histogram C if urban==1, fcolor(none) lcolor(blue)), xtitle(Consumption) /*
 */ legend(order(1 "Rural" 2 "Urban")) xtitle("Consumption (in US dollars)")
 
 graph export "results\1_2_Chist.png", replace
 
* Income 
 twoway (histogram I if urban==0, fcolor(none) lcolor(green)) /*
 */ (histogram I if urban==1, fcolor(none) lcolor(blue)), xtitle(Consumption) /*
 */ legend(order(1 "Rural" 2 "Urban")) xtitle("Income (in US dollars)")
 
  graph export "results\1_2_Ihist.png", replace
 
* Wealth
 twoway (histogram W if urban==0, fcolor(none) lcolor(green)) /*
 */ (histogram W if urban==1, fcolor(none) lcolor(blue)), xtitle(Consumption) /*
 */ legend(order(1 "Rural" 2 "Urban")) xtitle("Wealth (in US dollars)")
 
 graph export "results\1_2_Whist.png", replace
 
 
 *** Part (2)
	* Generate logs
	gen log_C = log(C)
	gen log_I = log(I)
	gen log_W = log(W)
	
	* Generate variances
	egen var_C = sd(log_C)
	replace var_C = var_C^2
	egen var_I = sd(log_I)
	replace var_C = var_C^2
	egen var_W = sd(log_W)
	replace var_W = var_W^2
	
/* Results
	All country log-variances
	var_C = 0.158
	Var_I = 1.27
	Var_W = 1.68

	Rural log-variances
	var_C = 0.134
	Var_I = 1.245
	Var_W = 1.369
	
	Urban log-variances
	var_C = 0.136
	Var_I = 1.219
	Var_W = 2.74
		
*/




****** 1.3. *******************************************************************
/* Describe the joint cross-sectional behavior of CI */

corr(C I W)
corr(C I W) if urban == 0
corr(C I W) if urban == 1


/* Results

All country
             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.5425   1.0000
           W |   0.5003   0.3380   1.0000
		   
		   
		   
Rural		   
             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.4641   1.0000
           W |   0.4756   0.3332   1.0000
		   
		   
		   
Urban		   
             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.5655   1.0000
           W |   0.4932   0.2858   1.0000

*/




****** 1.4. *******************************************************************
/* Describe the CIW level, inequality, and covariances over the lifecycle */

* In order to do beautiful graphs generate means by urban/rural and whole country

   *** Levels
	egen C_m = mean(C), by(age)
	egen I_m = mean(I), by(age)
	egen W_m = mean(W), by(age)
	egen C_mm = mean(C), by(urban age)
	egen I_mm = mean(I), by(urban age)
	egen W_mm = mean(W), by(urban age)
	
preserve
	drop if age < 20
	drop if age > 60
	
	* Rural lifecycle
	twoway (connected C_mm I_mm W_mm age if urban == 0, sort), /*
	*/ title("1.4.Rural lifecyle Levels")
	graph export "results\1_4_Rural_lifecylelev.png", replace

	* Urban lifecycle
	twoway (connected C_mm I_mm W_mm age if urban == 1, sort), /*
	*/ title("1.4.Urban lifecyle Levels")
	graph export "results\1_4_Urban_lifecylelev.png", replace

	* All country
	twoway (connected C_m I_m W_m age, sort), /*
	*/ title("1.4.All lifecyle Levels")
	graph export "results\1_4_All_lifecylelev.png", replace
restore

	
	
	
   *** Inequality
   	egen var_CC = sd(log_C), by(age)
	replace var_CC = var_CC^2
	egen var_II = sd(log_I), by(age)
	replace var_CC = var_CC^2
	egen var_WW = sd(log_W), by(age)
	replace var_WW = var_WW^2
	egen v_CC = sd(log_C), by(age urban)
	replace v_CC = v_CC^2
	egen v_II = sd(log_I), by(age urban)
	replace v_CC = v_CC^2
	egen v_WW = sd(log_W), by(age urban)
	replace v_WW = v_WW^2

preserve
	drop if age < 20
	drop if age > 60
	
	* Rural lifecycle
	twoway (connected v_CC v_II v_WW age if urban == 0, sort), /*
	*/ title("1.4.Rural lifecyle Inequality")
	graph export "results\1_4_Rural_lifecyleineq.png", replace

	* Urban lifecycle
	twoway (connected v_CC v_II v_WW age if urban == 1, sort), /*
	*/ title("1.4.Urban lifecyle Inequality")
	graph export "results\1_4_Urban_lifecyleineq.png", replace

	* All country
	twoway (connected var_CC var_II var_WW age, sort), /*
	*/ title("1.4.All lifecyle Inequality")
	graph export "results\1_4_All_lifecyleineq.png", replace
restore

  
  
  ** Covariances 

preserve
	drop if age < 20
	drop if age > 60
	
	gen covCI=.
	forvalues i=20/60 {
    corr log_C log_I if age==`i', c
    replace covCI = `r(cov_12)' if age==`i'
}
	gen covCW=.
	forvalues i=20/60 {
    corr log_C log_W if age==`i', c
    replace covCW = `r(cov_12)' if age==`i'
}
	gen covWI=.
	forvalues i=20/60 {
    corr log_W log_I if age==`i', c
    replace covWI = `r(cov_12)' if age==`i'
}

	* All country
	twoway (connected covCI covWI covCW age, sort), /*
	*/ title("1.4.All lifecyle Covariances")
	graph export "results\1_4_All_lifecylecov.png", replace
restore


****** 1.5. *******************************************************************
/*  Rank your households by income, and dicuss the behavior of the top and 
bottom of the consumption and wealth distributions conditional on income */

	use "cleaned_data\CIW.dta", replace
	
	* Conversion to USD 2013 (to make results more interpretable)
	replace C = C/3696.24
	replace I = I/3696.24
	replace W = W/3696.24
	
	* Now I don't trim the top and the bottom
	
	
	* Analysis top 10% 
preserve
	_pctile I, nq(100)
	drop if I <r(r90) 
	mean(C I W)
restore

	* Analysis bottom 10% 
	sort I
preserve
	_pctile I, nq(100)
	drop if I >r(r10) 
	mean(C I W)
restore
	
	
/* Results


Top
--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |    1801.54   80.85282      1642.384    1960.697
           I |   25191.29   10447.98      4624.723    45757.86
           W |   13700.99    1843.29      10072.53    17329.46
--------------------------------------------------------------



Bottom

             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   392.6328   31.22516       331.167    454.0987
           I |  -39.41381   64.44097     -166.2641    87.43647
           W |   1708.137   242.5363      1230.711    2185.563


*/
	







