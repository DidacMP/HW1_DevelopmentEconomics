********************************* Question 2.2 *********************************
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
	

*******************************************************************************
*******************************************************************************
****** 2.2. *******************************************************************
/* Redo separately for women and men, and by education groups (less than primary 
school completed, primary school completed, and secondary school completed or 
higher) */


****** 1.1. *******************************************************************
/* Report average CIW per household separately for rural and urban areas */


*** For men and women
	mean(C I W) [pw=wgt_X]
	mean(C I W) [pw=wgt_X] if gender == 1 // Male
	mean(C I W) [pw=wgt_X] if gender == 2 // Female
  
/* Results

	All country means:
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   630.4209    8.29261      614.1603    646.6816
           I |   1145.694   31.10042      1084.711    1206.678
           W |   2194.078   76.31621      2044.432    2343.723


	Men means

             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |    658.893   10.38068      638.5337    679.2524
           I |   1245.087   38.40537      1169.764     1320.41
           W |    2268.16   94.87615      2082.082    2454.238



	Women means
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   569.5703   13.29486      543.4746    595.6659
           I |    933.272   51.90935      831.3825    1035.162
           W |   2035.749   127.1797      1786.116    2285.382
		   

*/

*** For education level
	mean(C I W) [pw=wgt_X]
	mean(C I W) [pw=wgt_X] if educ == 10 | educ == 11 | educ == 12 | educ == 13 | /*
	*/ educ == 14 | educ == 15 | educ == 16  // Less than primary school
    mean(C I W) [pw=wgt_X] if educ == 17 | educ == 21 | educ == 22 // Less than high school
    mean(C I W) [pw=wgt_X] if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99 // Above high school

/* Results
Low educ

             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   561.0527   11.37667      538.7275     583.378
           I |   858.9326   37.55575      785.2343    932.6309
           W |   1640.131    82.3103      1478.608    1801.655


Medium educ

             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   674.8296   20.21919      635.0919    714.5673
           I |   1185.217   79.20092       1029.56    1340.874
           W |   2649.788   206.2916      2244.353    3055.222




High educ

             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
           C |   770.8769    17.4738      736.5718    805.1821
           I |   1699.022   69.47669      1562.623     1835.42
           W |   2697.374   160.7806      2381.724    3013.023


*/


****** 1.2. *******************************************************************
/* CIW inequality: (1) Show histogram for CIW separately for rural and urban 
areas; (2) Report the variance of logs for CIW separately for rural and urban 
areas. */

   *** Part (1)

   
*** Male and female
* Consumption 
 twoway (histogram C if gender==1, fcolor(none) lcolor(green)) /*
 */ (histogram C if gender==2, fcolor(none) lcolor(blue)), xtitle(Consumption) /*
 */ legend(order(1 "Male" 2 "Female")) xtitle("Consumption (in US dollars)")
 
 graph export "results\2_2_2Chist_mf.png", replace
 
* Income 
 twoway (histogram I if gender==1, fcolor(none) lcolor(green)) /*
 */ (histogram I if gender==2, fcolor(none) lcolor(blue)), xtitle(Consumption) /*
 */ legend(order(1 "Male" 2 "Female")) xtitle("Income (in US dollars)")
 
  graph export "results\2_2_2Ihist_mf.png", replace
 
* Wealth
 twoway (histogram W if gender==1, fcolor(none) lcolor(green)) /*
 */ (histogram W if gender==2, fcolor(none) lcolor(blue)), xtitle(Consumption) /*
 */ legend(order(1 "Male" 2 "Female")) xtitle("Wealth (in US dollars)")
 
 graph export "results\2_2_2Whist_mf.png", replace
 
 
 
 *** By education
 * Consumption 
 twoway (histogram C if educ == 10 | educ == 11 | educ == 12 | educ == 13 | /*
	*/ educ == 14 | educ == 15 | educ == 16, fcolor(none) lcolor(green)) /*
 */ (histogram C if educ == 17 | educ == 21 | educ == 22, fcolor(none) lcolor(blue)) /*
 */ (histogram C if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99 /*
	*/ , fcolor(none) lcolor(magenta)), xtitle(Consumption) /*
 */ legend(order(1 "Low educ" 2 "Medium educ" 3 "High educ")) xtitle("Consumption (in US dollars)")
 graph export "results\2_2_2Chist_educ.png", replace
 
* Income 
 twoway (histogram I if educ == 10 | educ == 11 | educ == 12 | educ == 13 | /*
	*/ educ == 14 | educ == 15 | educ == 16, fcolor(none) lcolor(green)) /*
 */ (histogram C if educ == 17 | educ == 21 | educ == 22, fcolor(none) lcolor(blue)) /*
 */ (histogram C if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99 /*
	*/ , fcolor(none) lcolor(magenta)), xtitle(Consumption) /*
 */ legend(order(1 "Low educ" 2 "Medium educ" 3 "High educ")) xtitle("Incom (in US dollars)")
 graph export "results\2_2_2Ihist_educ.png", replace
 
 
* Wealth
 twoway (histogram W if educ == 10 | educ == 11 | educ == 12 | educ == 13 | /*
	*/ educ == 14 | educ == 15 | educ == 16, fcolor(none) lcolor(green)) /*
 */ (histogram C if educ == 17 | educ == 21 | educ == 22, fcolor(none) lcolor(blue)) /*
 */ (histogram C if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99 /*
	*/ , fcolor(none) lcolor(magenta)), xtitle(Consumption) /*
 */ legend(order(1 "Low educ" 2 "Medium educ" 3 "High educ")) xtitle("Wealth (in US dollars)")
 graph export "results\2_2_2Whist_educ.png", replace
 

 *** Part (2)
 
 *** For men and women
	* Generate logs
	gen log_C = log(C)
	gen log_I = log(I)
	gen log_W = log(W)
	
	* Generate variances
	egen var_C = sd(log_C), by(gender)
	replace var_C = var_C^2,
	egen var_I = sd(log_I), by(gender)
	replace var_C = var_C^2
	egen var_W = sd(log_W), by(gender)
	replace var_W = var_W^2
	
/* Results

	Men
	var_C = 0.151
	Var_I = 1.21
	Var_W = 1.66
	
	Women
	var_C = 0.151
	Var_I = 1.366
	Var_W = 1.711
		
*/


 *** For education group
 drop log_C log_I log_W var_C var_I var_W
 
 preserve // repeat the process for the three groups
 keep if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99 
	* Generate logs
	gen log_C = log(C)
	gen log_I = log(I)
	gen log_W = log(W)
	
	* Generate variances
	egen var_C = sd(log_C)
	replace var_C = var_C^2,
	egen var_I = sd(log_I)
	replace var_C = var_C^2
	egen var_W = sd(log_W)
	replace var_W = var_W^2
restore
	
/* Results. Variances

	Low educ
	var_C = 0.117
	Var_I = 1.207
	Var_W = 1.404
	
	Medium educ
	var_C = 0.129
	Var_I = 1.155
	Var_W = 1.763
	
	High educ
    var_C = 0.123
	Var_I = 1.102
	Var_W = 2.02
		
*/


****** 1.3. *******************************************************************
/* Describe the joint cross-sectional behavior of CI */


* By men and women
corr(C I W) if gender == 1 // Men
corr(C I W) if gender == 2 // Women

* By education
corr(C I W) if educ == 10 | educ == 11 | educ == 12 | educ == 13 | /*
	*/ educ == 14 | educ == 15 | educ == 16 // Less than primary school
corr(C I W) if educ == 17 | educ == 21 | educ == 22 // Less than high school
corr(C I W) if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99 // Above high school

/* Results

Men
             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.5485   1.0000
           W |   0.5048   0.3471   1.0000

Women
	
             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.5165   1.0000
           W |   0.4874   0.3125   1.0000

Low educ

             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.4843   1.0000
           W |   0.4828   0.2892   1.0000



Medium educ

             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.3987   1.0000
           W |   0.4844   0.3981   1.0000



High educ

             |        C        I        W
-------------+---------------------------
           C |   1.0000
           I |   0.4915   1.0000
           W |   0.4475   0.2660   1.0000

		
*/



****** 1.4. *******************************************************************
/* Describe the CIW level, inequality, and covariances over the lifecycle */

* I will focus only in the levels (I don't they are so relevant the other ones here)

   *** Levels: Men and women
	egen C_mm = mean(C), by(gender age)
	egen I_mm = mean(I), by(gender age)
	egen W_mm = mean(W), by(gender age)
	
preserve
	drop if age < 20
	drop if age > 60
	
	* Men lifecycle
	twoway (connected C_mm I_mm W_mm age if gender == 1, sort), /*
	*/ title("2.2.4.Men lifecyle Levels")
	graph export "results\2_2_4_Men_lifecylelev.png", replace

	* Women lifecycle
	twoway (connected C_mm I_mm W_mm age if gender == 2, sort), /*
	*/ title("2.2.4.Women lifecyle Levels")
	graph export "results\2_2_4_Women_lifecylelev.png", replace
restore



   *** Levels: Education
   drop C_m I_m W_m C_mm I_mm W_mm

	preserve 
	drop if age < 20
	drop if age > 60
	keep if educ == 10 | educ == 11 | educ == 12 | educ == 13 | /*
	*/ educ == 14 | educ == 15 | educ == 16
	egen C_mm = mean(C), by(age)
	egen I_mm = mean(I), by(age)
	egen W_mm = mean(W), by(age)
	* Low educ lifecycle
	twoway (connected C_mm I_mm W_mm age, sort), /*
	*/ title("2.2.4.Low educ lifecyle Levels")
	graph export "results\2_2_4_lowe_lifecylelev.png", replace
	restore
	
	* Medium educ lifecycle
	preserve
	drop if age < 20
	drop if age > 60
    keep if educ == 17 | educ == 21 | educ == 22
	egen C_mm = mean(C), by(age)
	egen I_mm = mean(I), by(age)
	egen W_mm = mean(W), by(age)
	twoway (connected C_mm I_mm W_mm age, sort), /*
	*/ title("2.2.4.Medium educlifecyle Levels")
	graph export "results\2_2_4_mede_lifecylelev.png", replace
	restore
	
	* High educ lifecycle
	preserve
	drop if age < 20
	drop if age > 60
	egen C_mm = mean(C), by(age)
	egen I_mm = mean(I), by(age)
	egen W_mm = mean(W), by(age)
    keep if educ == 23 | educ == 31 | educ == 32 | educ == 33 /*
	*/| educ == 34 | educ == 35 | educ == 36 | educ == 41 | educ == 51 | educ == 99
	twoway (connected C_mm I_mm W_mm age, sort), /*
	*/ title("2.2.4.High educ lifecyle Levels")
	graph export "results\2_2_4_highe_lifecylelev.png", replace
	restore

****** 1.5. *******************************************************************

* I don't think it is very relevant this question to be analyzed by gender or educ, 
* I prefer to focus on other parts
