# Collegio Carlo Alberto on Applied Causal Panel Methods

Welcome to the materials for the **Collegio Carlo Alberto on Applied Causal Panel Methods**, a weeklong intensive course (9:00–16:00 daily) focused on advanced techniques for estimating causal effects in panel data.

---

## About the Workshop

This workshop introduces and explores some of the most important modern methods in causal inference for panel data, including:

- Difference-in-Differences (DiD)
- Event studies and dynamic treatment effects
- Aggregation, weighting, covariates and parallel trends diagnostics
- Recent innovations like CS, SA, DCDH, Honest DiD
- Heavy emphasis on application, interpretation, and implementation, as well as trouble shooting

---

## Schedule Overview -- Times

There are five days.  The following is our schedule:
Monday (day 1):
- 14:00 to 17:00 (3 hours, no breaks)
Tuesday to Thursday (days 2-4):
- 10:00 to 12:00 (2 hours)
- 12:00 to 13:00 (lunch)
- 13:00 to 16:15 (3 hours plus a 15-min break)
Friday (day 5)
- 14:00 to 16:00 (2 hours, no breaks)

## Schedule Overview -- Coverage

Monday: The Core of DiD (2x2)
- Review of 2×2 DiD -- four averages, three subtractions
- Review Potential outcomes and ATT 
- Estimation with "the three regressions" equivalence to 2x2
- New: Weighting by Population 
- In class: Castle Doctrine 2x2 and three regressions with and without population weights
- Review: Event studies, leads/lags, and long difference estimation
- Review: Other falsification strategies -- 1) Placebo group, same outcome and 2) Placebo outcome, same group
- Review: Triple differences
- Homework: Concealed carry (Lott and Mustard 1997; Donohue et al. 2011) and checklist

Tuesday: Violations of Parallel Trends with Covariates in 2x2 and 2xT
- Sampling problems
--> Compositional changes in repeated cross sections and two propensity score adjustment (Hong 2013)
--> Conditional independence missingness, imputation and imputation (Cunningham 2026) vs missing at random (Wooldridge 2010)

- Conditional parallel trends 
--> Covariate selection -- Common Sense versus Automated Covariate Selection with ML
--> Imbalance diagnostics: Propensity scores and Normalized difference in mean outcomes table
--> Estimation with Abadie IPW, Heckman, Ichimura and Todd OR, DR, and TWFE
- Using drdid, csdid, and did for 2×T event studies
- In class: Covariates and castle doctrine 2x2 and 2xT
- Homework: Concealed carry and checklist (covariate selection and 2xT)


Wednesday: Introducing Differential Timing (GxT)
- Reviewing Bacon decomposition of TWFE
- Reviewing Callaway & Sant’Anna with simulation
- Craigslist case study

Thursday: More on Differential Timing
- Sun & Abraham and dCDH estimators
- Borusyak et al., two-stage diff-in-diff, 
- Honest DiD
- Castle Doctrine coding exercise
- Continuous DiD and revisiting the abortion clinic closures 

Friday: Reviewing concealed carry together

---

## Structure

This repository contains:

- `/slides/` – Lecture slides for each day  
- `/code/` – Hands-on Stata and R code  
- `/data/` – Sample datasets used during exercises  
- `README.md` – This file  
- (Optional) `/references/` – Additional readings and papers

---

## Who Is This For?

Economists, data scientists, policy analysts, and researchers working with longitudinal or panel data who want to:

- Understand when and how DiD assumptions break down
- Learn how modern tools address those problems
- Practice implementing these methods in real code

---

## Tools

We’ll primarily use:
- **Stata** (`csdid`, `drdid`, `eventstudyinteract`)
- **R** (`did`, `fixest`, `synth`, `honestdid`)

Participants should be comfortable with basic regression and panel data structures but no prior experience with DiD is assumed.

---

## Optional Reading

- Cunningham (2021), *Causal Inference: The Mixtape*
- Baker, Callaway, Cunningham, Goodman-Bacon and Sant'Anna (2025), *Working Paper*
- Callaway & Sant’Anna (2021), *JoE*
- Goodman-Bacon (2021), *JoE*
- Sun and Abraham (2021), *JoE*
- de Chaisemartin and D'Haultfœielle (2020), *AER*
- Borusyak, et al. (2024), *Restud*
- Roth & Rambachan (2023), *Honest DiD*
- Callaway, Goodman-Bacon & Sant’Anna (2025), *AER R&R*


---

## License

MIT License. Materials are freely available for educational use.

---

## Questions?

Feel free to fork, clone, or reuse anything here. For questions, reach out via [GitHub Issues](https://github.com/scunning1975/Collegio-Carlo-Alberto/issues) or contact Scott Cunningham directly.
