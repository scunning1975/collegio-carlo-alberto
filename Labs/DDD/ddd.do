********************************************************************************
* name: ddd.do
* author: scott cunningham (baylor)
* description: simulation for triple diff with potential outcomes but using an unbiased did which really makes the need for triple diff irrelevant. 
* last updated: march 5, 2024
********************************************************************************

clear
capture log close
set seed 20200403

* States, Groups, and Time Setup
set obs 40
gen state = _n

* Generate treatment groups
gen experimental = 0
replace experimental = 1 in 1/20

* 50 cities per state
expand 50
bysort state: gen city_no = _n
egen city = group(city_no state)
drop city_no

* Three groups per city: men (1), married women (2), and older women (3)
expand 3
bysort city state: gen worker = _n
egen id = group(worker city state)

* Time, 10 years
expand 10
sort state
bysort state city worker: gen year = _n

* Setting years
foreach y of numlist 1/10 {
    local year 2010 + `y' - 1
    replace year = `year' if year == `y'
}

* Define the after period (post-2015)
gen after = year >= 2015

* Baseline earnings in 2010 with different values for experimental and non-experimental states
gen 	baseline = 40000 if worker == 3  // Married women
replace baseline = 45000 if worker == 2  // Older women
replace baseline = 50000 if worker == 1  // Men

* Adjust baseline for experimental states
replace baseline = 1.5 * baseline if experimental == 1

* Annual wage growth for Y(0)
gen year_diff = year - 2010
gen y0 = baseline + 1000 * year_diff

* Adding random error to Y(0)
gen error = rnormal(0, 1500)
replace y0 = y0 + error

* Define Y(1) with an ATT of -$5000 for married women in experimental states post-2015
gen 	y1 = y0
replace y1 = y0-5000 if experimental==1 & worker==2 & after==1
gen delta = y1-y0
su delta if experimenta==1 & worker==2 & after==1

* Treatment indicator
gen 	treat = 0
replace treat = 1 if experimental==1 & worker == 2 & after==1

* Final earnings using switching equation
gen earnings = treat*y1 + (1-treat)*y0


**************************************************************************** 
* Case 1: Triple differences based on unbiased DiD and a null comparison DiD
**************************************************************************** 

* 1. After, Married, Experimental
egen avg_wage_ame = mean(earnings) if after == 1 & experimental == 1 & worker == 2

* 2. Before, Married, Experimental
egen avg_wage_bme = mean(earnings) if after == 0 & experimental == 1 & worker == 2

* 3. After, Single Men and Older Women, Experimental
egen avg_wage_asoe = mean(earnings) if after == 1 & experimental == 1 & worker != 2

* 4. Before, Single Men and Older Women, Experimental
egen avg_wage_bsoe = mean(earnings) if after == 0 & experimental == 1 & worker != 2

* 5. After, Married, Non-Experimental
egen avg_wage_amn = mean(earnings) if after == 1 & experimental == 0 & worker == 2

* 6. Before, Married, Non-Experimental
egen avg_wage_bmn = mean(earnings) if after == 0 & experimental == 0 & worker == 2

* 7. After, Single Men and Older Women, Non-Experimental
egen avg_wage_ason = mean(earnings) if after == 1 & experimental == 0 & worker != 2

* 8. Before, Single Men and Older Women, Non-Experimental
egen avg_wage_bson = mean(earnings) if after == 0 & experimental == 0 & worker != 2


** Unbiased DiD = -5000
* Summarize and store the averages in macros
summarize avg_wage_ame, meanonly
local after_married_exp = r(mean)

summarize avg_wage_bme, meanonly
local before_married_exp = r(mean)

summarize avg_wage_amn, meanonly
local after_married_nonexp = r(mean)

summarize avg_wage_bmn, meanonly
local before_married_nonexp = r(mean)

* Calculate the DiD estimate
local DiD = (`after_married_exp' - `before_married_exp') - (`after_married_nonexp' - `before_married_nonexp')

* Display the result
display "Difference-in-Differences Estimate: " `DiD'






** Unbiased DDD with irrelevant comparison groups
* Summarize and store the averages for control groups in macros
summarize avg_wage_asoe, meanonly
local after_control_exp = r(mean)

summarize avg_wage_bsoe, meanonly
local before_control_exp = r(mean)

summarize avg_wage_ason, meanonly
local after_control_nonexp = r(mean)

summarize avg_wage_bson, meanonly
local before_control_nonexp = r(mean)

* Calculate the DiD for married women and control group in experimental states
local DiD_married_exp = (`after_married_exp' - `before_married_exp')
local DiD_control_exp = (`after_control_exp' - `before_control_exp')

* Calculate the DiD for married women and control group in non-experimental states
local DiD_married_nonexp = (`after_married_nonexp' - `before_married_nonexp')
local DiD_control_nonexp = (`after_control_nonexp' - `before_control_nonexp')

* Calculate the Triple Difference estimate
local TripleDiff = (`DiD_married_exp' - `DiD_control_exp') - (`DiD_married_nonexp' - `DiD_control_nonexp')

* Display the result
display "Triple Difference Estimate: " `TripleDiff'


****** Triple diff regression

gen 	married_women = 0
replace married_women = 1 if worker==2

reg earnings after##experimental##married_women, cluster(state)

su delta if experimenta==1 & worker==2 & after==1
di `r(mean)'

****** Triple diff event study

reg earnings i.year##experimental##married_women, cluster(state)


** A trick to plot the event study

ssc install coefplot

gen 	treated=0
replace treated=1 if experimental==1 & married_women==1

reg earnings experimental##married_women year##experimental year##married_women treated##ib2014.year, cluster(state)


coefplot, keep(1.treated#*) omitted baselevels cirecast(rcap) ///
    rename(1.treated#([0-9]+).year = \1, regex) at(_coef) ///
    yline(0, lp(solid)) xline(2014.5, lpattern(dash)) ///
    xlab(2010(1)2019)

	
	
capture log close
exit

reg l_homicide treat##ib2005.year, cluster(state)

coefplot, keep(1.treat#*) omitted baselevels cirecast(rcap) ///
    rename(1.treat#([0-9]+).year = \1, regex) at(_coef) ///
    yline(0, lp(solid)) xline(2005.5, lpattern(dash)) ///
    xlab(2000(1)2010)
	