******************************** Data cleaner **********************************
* Author: Dídac Martí Pinto
* Date: 25/01/2019
* Course: Development Economics (CEMFI)
* Instructions: Change the directory on this file and simply run, nothing else 
* has to be changed to build the data. 
********************************************************************************

clear all 
global main "C:\Users\Didac\Desktop\development_econ_hw1\" //Set your directory!

* Do all the exercises
    cd "$main\results_makers\"
	do "ex1.do"
	
	cd "$main\results_makers\"
	do "ex2_2.do"
	
	cd "$main\results_makers\"
	do "ex3.do"
