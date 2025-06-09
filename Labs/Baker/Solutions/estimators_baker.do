*-> Install packages, if needed
  * ssc install reghdfe, replace
  * ssc install drdid, replace
  * ssc install csdid, replace
  * ssc install eventstudyinteract, replace
  * ssc install did_imputation, replace
  * ssc install event_plot, replace
  * ssc install did2s, replace
  * ssc install jwdid, replace
  * ssc install xtevent, replace

*-> Load data 
  use "https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Baker/baker.dta", clear

  cap drop treated
  gen treated = 0
  replace treated = 1 if year > treat_date & treat_date ~= .

  * First year is year 1
  cap drop rel_year
  gen rel_year = year - treat_date + 1

  * Stata requires you to not have negative numbers in factor variable for regressions, so you have to shift
  cap drop rel_year_shifted
  qui sum rel_year
  local min_rel_year = `r(min)'
  gen rel_year_shifted = rel_year + -1 * `min_rel_year'

  * leads/lags of treatment, excluding -1
  forvalues k = 24(-1)0 {
    gen pre_`k' = rel_year == -`k'
  }
  forvalues k = 1/17 {
    gen post_`k' = rel_year == `k'
  }

*-> TWFE
  * pre_0 is omitted
  reghdfe y pre_24-pre_1 post_1-post_17, absorb(id year) vce(cluster id)
  est store est_twfe
  event_plot est_twfe, default_look stub_lead(pre_#) stub_lag(post_#)

*-> Sun and Abraham
  preserve 
  cap drop last_cohort
  gen last_cohort = (treat_date == 2004)
  keep if year < 2004
  eventstudyinteract y pre_24-pre_1 post_1-post_17, ///
    absorb(id year) vce(cluster id) ///
    cohort(treat_date) control_cohort(last_cohort)
  event_plot e(b_iw)#e(V_iw), default_look stub_lead(pre_#) stub_lag(post_#)
  restore

  * Store for later
  matrix sa_b = e(b_iw)
  matrix sa_v = e(V_iw)

*-> Callaway and Sant'anna
  
  csdid y, ivar(id) time(year) gvar(treat_date) notyet
  estat event, estore(est_cs)
  event_plot est_cs, default_look stub_lead(Tm#) stub_lag(Tp#) 

*-> BJS
  preserve
  keep if year < 2004
  did_imputation y id year treat_date, allhorizons pretrends(24) minn(0) autosample
  est store est_bjs
  event_plot est_bjs, default_look stub_lead(pre#) stub_lag(tau#) 
  restore

*-> Gardner 
  did2s y, first_stage(i.year i.id) second_stage(pre_24-pre_0 post_1-post_17) treatment(treated) cluster(id)
  est store est_gardner
  event_plot est_gardner, default_look stub_lead(pre_#) stub_lag(post_#) 

*-> Wooldridge
  jwdid y, ivar(id) tvar(year) gvar(treat_date)
  estat event, post
  matrix w_b = e(b)
  matrix w_v = e(V)
  matrix list e(b)
  event_plot w_b#w_v, default_look stub_lag(r2vs1._at@#.__event__)

*-> All together

event_plot est_twfe est_bjs est_gardner est_cs sa_b#sa_v w_b#w_v, ///
  stub_lead(pre_# pre# pre_# Tm# pre_# r2vs1._at@#.__event__) ///
	stub_lag(post_# tau# post_# Tp# post_# _#) /// 
  default_look plottype(scatter) ciplottype(rcap) ///
  together perturb(-0.325(0.13)0.325) noautolegend /// 
	graph_opt( ///
		xtitle("Periods since the event") ytitle("Average causal effect") ///
    yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal)) ///
    legend( ///
      order(1 "OLS" 3 "Borusyak et al." 5 "Gardner" 7 "Callaway-Sant'Anna" 9 "Sun and Abraham" 11 "Wooldridge") ///
    ) ///
	) ///
	lag_opt1(msymbol(Sh) color(black)) lag_ci_opt1(color(black)) ///
	lag_opt2(msymbol(+) color(cranberry)) lag_ci_opt2(color(cranberry)) ///
	lag_opt3(msymbol(D) color(navy)) lag_ci_opt3(color(navy)) ///
	lag_opt4(msymbol(T) color(forest_green)) lag_ci_opt4(color(forest_green)) ///
	lag_opt5(msymbol(S) color(dkorange)) lag_ci_opt5(color(dkorange)) ///
	lag_opt6(msymbol(O) color(purple)) lag_ci_opt6(color(purple)) 

