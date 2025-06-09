# Lalonde

The National Supported Work (NSW) Demonstration dataset is one of the most commonly used dataset in econometrics based on [Lalonde (1986)](https://business.baylor.edu/scott_cunningham/teaching/lalonde-1986.pdf) and [Dehejia and Wahba (2002)](https://business.baylor.edu/scott_cunningham/teaching/dehejia-and-wahba-2002.pdf). Both the original 1986 article by Lalonde as well as the follow-up articles by Dehejia and Wahba used the data to evaluate contemporary approaches to causal inference using non-experimental data. Cleverly, they start with an experimental dataset to establish 'true' causal effect and then use a non-experimental dataset consisting of a control group of randomly sampled American households to see if covariate adjustment can recover causal effects under fairly dramatic selection problems. 

In [Causal Inference 1](github.com/Mixtape-Sessions/Causal-Inference-1), we have already shown that the nonexperimental dataset suffers from severe negative selection into the job trainings program.  Simple comparisons often found negative effects of job training on earnings despite the fact the program had an average positive effect of around $1700 higher real earnings in 1978. That lab found that some selection on observable methods like propensity score weighting and nearest neighbor matching recovered causal effects close to that found using experimental data. 

In this lab, we will study the performance of several difference-in-differences estimators using both the experimental and non-experimental datasets. 

1. We will first perform analysis on the experimental dataset `https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_exp_panel.dta`

   a. Under random assignment, the simple difference-in-means identifies the ATE, and since the original NSW was a randomized experiment, we can do this.  Calculate the simple difference-in-means on the experimental dataset to estimate the "treatment effect" two separate ways: (1) manually calculate averages for both treatment (`ever_treated=1`) and control (`ever_treated=0`) and use them to estimate the returns to the program, and (2) estimate the effect with an OLS specification. In both cases, use only the year `78` and `re` variable for real earnings. 

   b. Estimate the effect of the treatment, `ever_treated`, on real earnings, `re`, in a difference-in-differences estimator using years `78` for post period and `75` as the pre-period (ignoring for now year `74`). As with 1a, do this in the following two ways: (1) manually calculate the four means you need for the DiD equation and then estimate using the DiD equation, and (2) estimate the ATT using the OLS specification for the DiD equation with robust standard errors. Reminder to only use `78` and `75` (i.e., do not include `74` in OLS analysis). 

   c. Check the pre-trends for 1974 relative to 1975 two ways: (1) manually calculate the DiD equation on 1974 relative to 1975 and (2) estimate the dynamic OLS specification with an interaction of `ever_treated` with `74`, an interaction of `ever_treated` with `78`.  Compare your answers for 2c to what you found in 2a and 2b. 

2. Now, we turn to the non-experimental dataset `https://raw.github.com/Mixtape-Sessions/Causal-Inference-2/master/Lab/Lalonde/lalonde_nonexp_panel.dta`. 

   a. Repeat 1a (simple difference-in-means for `78` only), 1b (DiD using manual calculations and OLS specification for `78` and `75` only) and 1c (event study calculations manually and dynamic OLS specification for `78`, `75` and `74`)

   b. Repeat 1b and 1c (OLS specifications) controlling linearly for `age, agesq, agecube, educ, educsq, marr, nodegree, black, hisp, re74, u74` with robust standard errors.

   c. Use the `DRDID` command to estimate a doubly-robust difference-in-differences with covariates `age + agesq + agecube + educ + educsq + marr + nodegree + black + hisp + re74 + u74`, `id` panel unit identifier, `year` as the panel time identifier, and reporting the outcome regression analysis [(Heckman, Ichimura and Todd 1997)](http://jenni.uchicago.edu/papers/Heckman_Ichimura-Todd_REStud_v64-4_1997.pdf), inverse probability weight estimator [(Abadie 2005)](https://academic.oup.com/restud/article-abstract/72/1/1/1581053?redirectedFrom=fulltext), doubly robust [(Sant'anna and Zhao 2020)](https://www.sciencedirect.com/science/article/abs/pii/S0304407620301901).  Compare these results with 1a, 1b, 2a and 2b. 
