*********************************** Income *************************************
* Author: Dídac Martí Pinto
* Date: 25/01/2019
* Course: Development Economics (CEMFI)
********************************************************************************

clear all
*global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory!
cd "$main"


****** I.1. Agricultural net production ****************************************


 ***** Non - Permanent crop *****
  ** Season 1
   use "raw_data\AGSEC5A.dta", replace
   drop if cropID == .
   drop if a5aq6a==. & a5aq6d==. & a5aq16==. & a5aq7a==. & a5aq7d==. & a5aq8==. /*
   */ & a5aq10==. & a5aq5_2 ==2 // no revenue but crop was mature
   replace a5aq6d = a5aq7d if  a5aq6b == a5aq7b & a5aq6c== a5aq7c & a5aq6d /*
   */ != a5aq7d // Same conversion weights for buy and sell 
   
  ** Production - season 1
   gen y = . // y = Production (in Kg)
   replace y = a5aq6a*a5aq6d if a5aq6d!=. // Quantity * Conversion factor
   replace y = a5aq6a if a5aq6c==1  // These were already in Kg 
   
  ** Production sold 
   gen ys = . // Production sold (in Kg)
   replace ys = a5aq7a*a5aq7d if a5aq7d!=. // Quantity * Conversion factor
   replace ys = 0 if a5aq7a==0
   replace ys = 0 if a5aq7a==.
   replace ys = a5aq7a if a5aq7c==1 // These were already in Kg
   
  ** Production kept
   gen hoard = y - ys
   replace ys = y if hoard<0
   
  ** Prices
   egen yy = sum(y), by(hh cropID)
   egen yyss = sum(ys), by(hh cropID)
   egen rev1 = sum(a5aq8), by(hh cropID)
   gen p = rev1 / yyss
   egen pm = mean(p), by(cropID) 
   
  ** Value unsold production
   gen up1 = pm*(yy-yyss)
   replace up1 = 0 if up1 == .
   replace rev1 = 0 if rev1 == .

  ** Costs: Tansportation costs - season 1
   gen tc1 = a5aq10 
   replace tc1 = 0 if tc1 ==.
   collapse (mean) up1 rev1 tc1, by(hh cropID)
   collapse (sum) up1 rev1 tc1, by(hh)
   save "cleaned_data\I1_part1_temp.dta", replace
   
  ** Season 2
   use "raw_data\AGSEC5B.dta", replace
   drop if cropID == .
   drop if a5bq6a==. & a5bq6d==. & a5bq16==. & a5bq7a==. & a5bq7d==. & a5bq8==. /*
   */ & a5bq10==. & a5bq5_2 ==2 // no revenue but crop was mature
   replace a5bq6d = a5bq7d if  a5bq6b == a5bq7b & a5bq6c== a5bq7c & a5bq6d /*
   */ != a5bq7d // Same conversion weights for buy and sell 
   
  ** Production - season 2
   gen y = . // y = Production (in Kg)
   replace y = a5bq6a*a5bq6d if a5bq6d!=. // Quantity * Conversion factor
   replace y = a5bq6a if a5bq6c==1  // These were already in Kg 
   
  ** Production sold 
   gen ys = . // Production sold (in Kg)
   replace ys = a5bq7a*a5bq7d if a5bq7d!=. // Quantity * Conversion factor
   replace ys = 0 if a5bq7a==0
   replace ys = 0 if a5bq7a==.
   replace ys = a5bq7a if a5bq7c==1 // These were already in Kg
   
  ** Production kept
   gen hoard = y - ys
   replace ys = y if hoard<0
   
  ** Prices
   egen yy = sum(y), by(hh cropID)
   egen yyss = sum(ys), by(hh cropID)
   egen rev2 = sum(a5bq8), by(hh cropID)
   gen p = rev2 / yyss
   egen pm = mean(p), by(cropID) 
   
  ** Value unsold production
   gen up2 = pm*(yy-yyss)
   replace up2 = 0 if up2 == .
   replace rev2 = 0 if rev2 == .

  ** Costs: Tansportation costs - season 2
   gen tc2 = a5bq10 
   replace tc2 = 0 if tc2 ==.
   collapse (mean) up2 rev2 tc2, by(hh cropID)
   collapse (sum) up2 rev2 tc2, by(hh)
   drop if up2<0
   save "cleaned_data\I1_part2_temp.dta", replace
   
  ** Costs: Rented-in land
   use "raw_data\AGSEC2B.dta", clear
   gen rl = a2bq9 // Rented land costs
   replace rl = 0 if rl ==.
   collapse (sum) rl, by(hh)
   save "cleaned_data\I1_part3_temp.dta", replace
  
  ** Costs: Hired labor - Season 1
   use "raw_data\AGSEC3A.dta", clear
   gen h1 = a3aq36 // Hired labor costs
   replace h1 = 0 if h1 ==.
  
  ** Costs: Pesticides and fertilizers - Season 1
   gen fer1 = a3aq8
   replace fer1 = 0 if fer1 == .
   gen fer2 = a3aq18
   replace fer2 = 0 if fer2 == .
   gen fer3 = a3aq27
   replace fer3 = 0 if fer3 == .
   gen ftot1 = fer1 + fer2 + fer3 // Sum costs all types of fertilizers
   
   collapse (sum) h1 ftot1, by(hh) 
   save "cleaned_data\I1_part4_temp.dta", replace
   
  ** Costs: Hired labor - Season 2
   use "raw_data\AGSEC3B.dta", clear
   gen h2 = a3bq36 // Hired labor costs
   replace h2 = 0 if h2 ==.
  
  ** Costs: Pesticides and fertilizers - season 2
   gen fer1 = a3bq8
   replace fer1 = 0 if fer1 == .
   gen fer2 = a3bq18
   replace fer2 = 0 if fer2 == .
   gen fer3 = a3bq27
   replace fer3 = 0 if fer3 == .
   gen ftot2 = fer1 + fer2 + fer3 // Sum costs all types of fertilizers
   
   collapse (sum) h2 ftot2, by(hh) 
   save "cleaned_data\I1_part5_temp.dta", replace
   
  ** Costs: Seeds - Season 1
   use "raw_data\AGSEC4A.dta", clear
   gen sc1 = a4aq15
   replace sc1 = 0 if sc1 == .
   collapse (sum) sc1, by(hh)
   save "cleaned_data\I1_part6_temp.dta", replace
 
  ** Costs: Seeds - Season 2
   use "raw_data\AGSEC4B.dta", clear
   gen sc2 = a4bq15
   replace sc2 = 0 if sc2 == .
   collapse (sum) sc2, by(hh)
   save "cleaned_data\I1_part7_temp.dta", replace
   
  ** Merge all non - permanent crop 
   cd "$main\cleaned_data\"
   use "I1_part1_temp.dta", replace
   merge 1:1 hh using "I1_part2_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part3_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part4_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part5_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part6_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part7_temp.dta"
   drop _merge
   
   replace up1 = 0 if up1 ==.
   replace up2 = 0 if up2 ==.
   replace rev1 = 0 if rev1 ==.
   replace rev2 = 0 if rev2 ==.
   replace tc1 = 0 if tc1 ==.
   replace tc2 = 0 if tc2 ==.
   replace rl = 0 if rl ==.
   replace h1 = 0 if h1 ==.
   replace h2 = 0 if h2 ==.
   replace ftot1 = 0 if ftot1 ==.
   replace ftot2 = 0 if ftot2 ==.
   replace sc1 = 0 if sc1 ==.
   replace sc2 = 0 if sc2 ==.
   
   gen npc = up1 + up2 + rev1 + rev2 - tc1 - tc2 - rl - h1 - h2 - ftot1 - ftot2 - sc1 - sc2
   
   save "I1_1_temp.dta" , replace
   rm "I1_part1_temp.dta" 
   rm "I1_part2_temp.dta" 
   rm "I1_part3_temp.dta" 
   rm "I1_part4_temp.dta" 
   rm "I1_part5_temp.dta" 
   rm "I1_part6_temp.dta"
   rm "I1_part7_temp.dta"
   
   
 ***** Livestock sales *****
   cd "$main\"
   
  ** Cattle
   use "raw_data\AGSEC6A.dta", clear
   keep if a6aq2 != 2 & a6aq3a != 0 & a6aq3a != . // Keep only those who own cattle
   gen ct_r = a6aq14a*a6aq14b if a6aq14a !=. & a6aq14a != 0  & a6aq14b !=. & /*
   */ a6aq14b !=0 // Cattle revenues = quantity * revenue per unit
   replace  ct_r = 0 if ct_r == . // 
   gen ct_c = a6aq5c if a6aq5c >0 & a6aq5c != . // Labor costs
   replace ct_c = 0 if ct_c == .
   
   collapse (sum) ct_r (mean) ct_c, by(hh)
   save "cleaned_data\I1_part1_temp.dta", replace
 
  ** Small animals
   use "raw_data\AGSEC6B.dta", clear 
   keep if a6bq2 != 2 & a6bq3a != 0 & a6bq3a != . // Keep only those who own small anim
   gen sa_r = a6bq14a*a6bq14b if a6bq14a !=. & a6bq14a != 0  & a6bq14b !=. & /*
   */ a6bq14b !=0 // Small animals revenues = quantity * revenue per unit
   replace sa_r = 0 if sa_r == .
   gen sa_c = a6bq5c if a6bq5c >0 & a6bq5c != . // Labor costs
   replace sa_c = 0 if sa_c == .
   
   collapse (sum) sa_r (mean) sa_c, by(hh)
   save "cleaned_data\I1_part2_temp.dta", replace
 
  ** Rabbits
   use "raw_data\AGSEC6C.dta", clear 
   keep if a6cq2 != 2 & a6cq3a != 0 & a6cq3a != . // Keep only those who own rabbits
   gen r_r = a6cq14a*a6cq14b if a6cq14a !=. & a6cq14a != 0  & a6cq14b !=. /*
   */ & a6cq14b !=0 // Rabbits revenues = quantity * revenue per unit
   replace r_r = 0 if r_r == .
   gen r_c = a6cq5c if a6cq5c >0 & a6cq5c != . 
   replace r_c = 0 if r_c ==.
   
   collapse (sum) r_r (mean) r_c, by(hh)
   save "cleaned_data\I1_part3_temp.dta", replace
   
  ** Other costs
  use "raw_data\AGSEC7.dta", clear
  keep if a7aq1 == 1
  egen oc1 = sum(a7bq2e), by(hh)
  egen oc2 = sum(a7bq3f), by(hh)
  egen oc3 = sum(a7bq5d), by(hh)
  egen oc4 = sum(a7bq6c), by(hh)
  egen oc5 = sum(a7bq7c), by(hh)
  egen oc6 = sum(a7bq7c), by(hh)
  replace oc1 = 0 if oc1 ==.
  replace oc2 = 0 if oc2 ==.
  replace oc3 = 0 if oc3 ==.
  replace oc4 = 0 if oc4 ==.
  replace oc5 = 0 if oc5 ==.
  replace oc6 = 0 if oc6 ==.
  gen toc = oc1 + oc2 + oc3 + oc4 + oc5 + oc6
  
  collapse (mean) toc, by(hh)
  save "cleaned_data\I1_part4_temp.dta", replace
  
  ** Merge all livestock
   cd "$main\cleaned_data\"
   use "I1_part1_temp.dta", replace
   merge 1:1 hh using "I1_part2_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part3_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part4_temp.dta"
   drop _merge
   
   replace ct_r = 0 if ct_r ==.
   replace ct_c = 0 if ct_c ==.
   replace r_r = 0 if r_r ==.
   replace r_c = 0 if r_c ==.
   replace sa_r = 0 if sa_r ==.
   replace sa_c = 0 if sa_c ==.
   replace toc = 0 if toc ==.
   
   gen livest = ct_r + r_r + sa_r - ct_c - r_c - sa_r - toc
   
   save "I1_2_temp.dta" , replace
   rm "I1_part1_temp.dta" 
   rm "I1_part2_temp.dta" 
   rm "I1_part3_temp.dta" 
   rm "I1_part4_temp.dta"

 
 ***** Livestock product *****
   cd "$main\"
   
  ** Meat 
   use "raw_data\AGSEC8A.dta", clear 
   gen p = a8aq5/a8aq3 if a8aq1 != 0 & a8aq5 != 0 & a8aq5 !=. & a8aq3 != 0 /*
   */ & a8aq3 !=. // Price of meat = revenue / quantity
   egen pm = mean(p), by(AGroup_ID)
   gen meat = .
   replace meat = pm*((a8aq1*a8aq2)-a8aq3) + a8aq5 if a8aq5 !=. 
   replace meat = pm *((a8aq1*a8aq2)-a8aq3) if a8aq5 ==.
   replace meat = a8aq5 if ((a8aq1*a8aq2)-a8aq3) == 0 & a8aq5 !=.
   replace meat = 0 if meat ==.
   
   collapse (sum) meat, by(hh)
   save "cleaned_data\I1_part1_temp.dta", replace
   
  ** Milk
   use "raw_data\AGSEC8B.dta", clear 
   gen dm = a8bq1* a8bq3 // Dairy milk
   replace dm = 0 if dm==.
   replace a8bq5_1 = dm if a8bq5_1 > dm & a8bq5_1!=0 & a8bq5_1!=.
   replace a8bq7 = 0 if a8bq6==0 | a8bq6==.
   replace a8bq7 = a8bq6 if a8bq7>a8bq6 
   replace a8bq5_1 = dm if dm < a8bq5 & a8bq5_1!=0 & a8bq9!=0 & a8bq9!=. & a8bq6==0
   replace a8bq5 = 0 if dm<a8bq5 & a8bq5_1!=0 & a8bq9!=0 & a8bq9!=.
   replace a8bq5_1 = a8bq5_1 * 30 * a8bq2
   replace a8bq7 = a8bq7 * 30 * a8bq2
   replace a8bq7 = 0 if a8bq5_1==a8bq1*a8bq2*30*a8bq3 // From day to year
   
   gen p = . // Create prices
   replace p = a8bq9/(a8bq5_1+a8bq7) if a8bq1!=0 & a8bq5_1!=0 & a8bq5_1 !=. /*
   */ & a8bq9!=0 & a8bq9 !=.| a8bq1 != 0 & a8bq6 != 0 & a8bq6 != . & a8bq7 != 0 /*
   */ & a8bq7 !=. & a8bq9 != 0 & a8bq9 !=.
   egen pm = mean(p), by(AGroup_ID)
   replace a8bq2 = a8bq2*(30.5) // From monthly to yearly
   gen milk = a8bq1*a8bq2*a8bq3 
   replace milk = 0 if milk ==.
   replace a8bq7 = 0 if a8bq7 ==. 
   replace a8bq5_1 = 0 if a8bq5_1==. 
   gen dif = (milk-(a8bq5_1+a8bq7)) // Production - sales

   gen milki = pm*(milk-(a8bq5_1+a8bq7)) // Milk income
   replace milki = pm*(milk-(a8bq5_1+a8bq7)) + a8bq9 if a8bq9!=. 
   replace milki = a8bq9 if milk-(a8bq5_1+a8bq7)==0 &  a8bq9!=. 

   collapse (sum) milki, by(hh)
   save "cleaned_data\I1_part2_temp.dta", replace
     
  ** Eggs 
   use "raw_data\AGSEC8C.dta", clear 
   gen eg_q = a8cq2*4 // Production of eggs per year
   gen egs_q = a8cq3*4 // Eggs sold per year
   gen eg_r = a8cq5*4 // Rrevenue by year
   replace egs_q = eg_q if egs_q>eg_q
   gen p = eg_r/egs_q if a8cq1 != 0 & a8cq1 != 0 & a8cq2 !=. & a8cq2 !=0 // Price
   egen pm = mean(p), by(AGroup_ID) // Median price
   replace eg_q = 0 if eg_q == .
   replace egs_q = 0 if egs_q == .
   replace eg_r = 0 if eg_r == .
   gen egg = pm*(eg_q - egs_q) + eg_r
   
   collapse (sum) egg, by(hh)
   drop if egg<0
   save "cleaned_data\I1_part3_temp.dta", replace   
   
  ** Dung 
   use "raw_data\AGSEC11.dta", clear 
   replace a11q1c = 0 if a11q1c ==.
   replace a11q5 = 0 if a11q5 ==.
   gen dung = a11q1c + a11q5 
   
   collapse (sum) dung, by(hh)
   save "cleaned_data\I1_part4_temp.dta", replace 
   
  ** Merge all livestock product
   cd "$main\cleaned_data\"
   use "I1_part1_temp.dta", replace
   merge 1:1 hh using "I1_part2_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part3_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_part4_temp.dta"
   drop _merge
   
   replace meat = 0 if meat ==.
   replace milki = 0 if milki ==.
   replace egg = 0 if egg ==.
   replace dung = 0 if dung ==.
   
   gen livest_prod = meat + milki + egg + dung
   
   save "I1_2_temp.dta" , replace
   rm "I1_part1_temp.dta" 
   rm "I1_part2_temp.dta" 
   rm "I1_part3_temp.dta" 
   rm "I1_part4_temp.dta" 
   
   
 ***** Renting-in agricultural equipment and structure capital *****
   cd "$main"
   use "raw_data\AGSEC10.dta", clear
   gen rentin = a10q8
   replace rentin = 0 if rentin == .
	
   collapse (sum) rentin, by(hh)
   save "cleaned_data\I1_3_temp.dta" , replace
	
		
 ***** Merge all parts of agricultural net production *****
   cd "$main\cleaned_data\"
   use "I1_1_temp.dta", replace
   merge 1:1 hh using "I1_2_temp.dta"
   drop _merge
   merge 1:1 hh using "I1_3_temp.dta"
   drop _merge
   
   replace npc = 0 if npc == .
   replace livest = 0 if livest == .
   replace livest_prod = 0 if livest_prod == .
   
   gen i1_a = npc + livest + livest_prod - rentin
   keep i1_a hh
	
   save "I1_temp.dta", replace
   rm "I1_1_temp.dta"
   rm "I1_2_temp.dta"
   rm "I1_3_temp.dta"

   
****** I.2. Labor market income ************************************************
   cd "$main"
   use "raw_data\GSEC8_1.dta", replace
   rename HHID hh
   
  * Main occupation
   gen lab_w_i = 0 // Labor weekly income
   replace lab_w_i = (h8q31a+h8q31b)*35 if h8q31c==1 // Assume 35 hrs worked per week 
   replace lab_w_i = (h8q31a+h8q31b)*5 if h8q31c==2 // Assume 5 days worked a week 
   replace lab_w_i = (h8q31a+h8q31b) if h8q31c==3 // Week
   replace lab_w_i = (h8q31a+h8q31b)/4 if h8q31c==4 // Assume 4 weeks per month
   replace lab_w_i = lab_w_i*h8q30b*h8q30a // Total year income (main occupation)
   replace lab_w_i = 0 if lab_w_i ==.   
   
  * Secondary occupation
   gen lab2_w_i = 0 // Labor weekly income
   replace lab2_w_i = (h8q45a+h8q45b)*35 if h8q31c==1 // Assume 35 hrs worked per week 
   replace lab2_w_i = (h8q45a+h8q45b)*5 if h8q31c==2 // Assume 5 days worked a week 
   replace lab2_w_i = (h8q45a+h8q45b) if h8q31c==3 // Week
   replace lab2_w_i = (h8q45a+h8q45b)/4 if h8q31c==4 // Assume 4 weeks per month
   replace lab2_w_i = lab2_w_i*h8q44b*h8q44 // Total year income (secondary occupation)
   replace lab2_w_i = 0 if lab2_w_i ==.
 
  * Total labor income
   gen i2_l = lab_w_i + lab2_w_i
   collapse (sum) i2_l, by(hh)
   save "cleaned_data\I2_temp.dta", replace 
  

****** I.3. Business income ****************************************************
   cd "$main"
   use "raw_data\gsec12.dta", replace
   rename hhid hh
   
   replace h12q13 = 0 if h12q13==. // h12q13 = monthly gross revenue
   replace h12q15 = 0 if h12q15==. // h12q15 = monthly expenditure on wages
   replace h12q16 = 0 if h12q16==. // h12q16 = monthly expenditure on raw material
   replace h12q17 = 0 if h12q17==. // h12q17 = monthly expenditure on other
   replace h12q12 = 0 if h12q12==. // h12q12 = months operating
   
   gen i3_b = ( h12q13 - h12q15 - h12q16 - h12q17 ) * h12q12
   collapse (sum) i3_b, by(hh)
   save "cleaned_data\I3_temp.dta", replace 

****** I.4. Other income *******************************************************
   cd "$main"
   use "raw_data\GSEC11A.dta", clear
   
   rename HHID hh
   replace h11q5 = 0 if h11q5 == .
   replace h11q6 = 0 if h11q6 == .
   gen i4_o = h11q5 + h11q6
   
   collapse (sum) i4_o, by(hh)
   save "cleaned_data\I4_temp.dta", replace 
   
 ****** I.5. Transfers *******************************************************  
   cd "$main"
   use "raw_data\GSEC15B.dta", clear
   rename HHID hh
   
   gen i5_t = h15bq10*h15bq11
   replace i5_t = 0 if i5_t==.
 
   collapse (sum) i5_t, by(hh)
   save "cleaned_data\I5_temp.dta", replace
   
****** I. Final merge **********************************************************
   cd "$main\cleaned_data\"
   use "I1_temp.dta", replace
   merge 1:1 hh using "I2_temp.dta"
   drop _merge
   merge 1:1 hh using "I3_temp.dta"
   drop _merge
   merge 1:1 hh using "I4_temp.dta"
   drop _merge
   merge 1:1 hh using "I5_temp.dta"
   drop _merge
   
   replace i1_a = 0 if i1_a == .
   replace i2_l = 0 if i2_l == .
   replace i3_b = 0 if i3_b == .
   replace i4_o = 0 if i4_o == .
   replace i5_t = 0 if i5_t == .
   
   gen I = i1_a + i2_l + i3_b + i4_o + i5_t
   
  * Relabel variables to make them informative
   label var i1_a "I: Agricultural net production"
   label var i2_l "I: Labor market income"
   label var i3_b "I: Business income"
   label var i4_o "I: Other income"
   label var i5_t "I: Transfers"
   label var I "INCOME"

   save "I.dta" , replace
   rm "I1_temp.dta"
   rm "I2_temp.dta" 
   rm "I3_temp.dta"
   rm "I4_temp.dta"
   rm "I5_temp.dta"
 
