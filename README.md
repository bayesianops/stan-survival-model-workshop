# Building a Survival Model in Stan

This repository contains the materials from a 2-hour workshop taught
on October 16, 2023 as part of [R/Pharma
2023](https://rinpharma.com/workshop/2023conference/).


## Contents

* Slides: [Building-a-Survival-Model-in-Stan.pdf](Building-a-Survival-Model-in-Stan.pdf)
* R script to generate data and run models: [script.R](script.R)

There are 4 examples, each in its own Stan program (`survival_1.stan`,
`survival_2.stan`, `survival_3.stan`, `survival_4.stan`). These
programs are meant for you to complete as part of the workshop.
The full, working programs are in the `solution/` folder.



## Description

In this hands-on workshop, we will be building a survival model from
scratch in Stan. We will work through some of the math, how it
connects with Stan code, and building from a simple model to one that
includes censoring. Although the example will be survival analysis,
the workshop will be geared towards exploring hierarchical models,
priors, and simulation.  For this workshop, it would be helpful to
have a working Stan installation (CmdStanR) and some familiarity with
Stan programming.



## Bio

Daniel Lee is a computational Bayesian statistician who helped create
and develop Stan, the open-source statistical modeling language. He
has 20 years of experience in numeric computation and software; over
10 years of experience creating and working with Stan; and has spent
the last 5 years working on pharma-related models including joint
models for estimating oncology treatment efficacy and PK/PD
models. Past projects have covered estimating vote share for state and
national elections; clinical trials for rare diseases and
non-small-cell lung cancer; satellite control software for television
and government; retail price sensitivity; data fusion for U.S. Navy
applications; sabermetrics for an MLB team; and assessing “clutch”
moments in NFL footage. Daniel has led workshops and given talks in
applied statistics and Stan at Columbia University, MIT, Penn State,
UC Irvine, UCLA, University of Washington, Vanderbilt University,
Amazon, Climate Corp, Swiss Statistical Society, IBM AI Systems Day,
R/Pharma, StanCon, PAGANZ, ISBA, PROBPROG, and NeurIPS. He holds a
B.S. in Mathematics with Computer Science from MIT, and a Master of
Advanced Studies in Statistics from Cambridge University.

