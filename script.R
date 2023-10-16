## From: Building a Survival Model in Stan
##       R/Pharma 2023 Workshop
##       October 16, 2023
##       Daniel Lee - daniel@bayesianops.com
## GitHub repo: https://github.com/bayesianops/stan-survival-model-workshop



################################################################################
## Install packages
##
## - cmdstanr 0.6.0
## - cmdstan 2.33.1
## - posterior
## - bayesplot
## - survival
## - ggplot2 (optional)
## - gridExtra (optional)
################################################################################
install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

library(cmdstanr)
check_cmdstan_toolchain()
install_cmdstan(cores = 2)

install.packages("survival")

## optional
install.packages(c("ggplot2", "gridExtra"))





################################################################################
## Setup
################################################################################

library(cmdstanr)
library(posterior)
library(bayesplot)
color_scheme_set("brightblue")

library(survival)
library(ggplot2)
library(gridExtra)
options(width = 160)





################################################################################
## Explore data: Veterans' Administration Lung Cancer study
################################################################################
library(survival)
veteran
head(veteran)
plot(survfit(Surv(veteran$time, veteran$status) ~ 1))






################################################################################
## Simulating Data
## Inversion Sampling
################################################################################


rm(list = ls())

x <- rnorm(10000)     # normal rng
ggplot(data.frame(x = x), aes(x = x)) + geom_histogram()


p <- pnorm(x)         # cdf of normal distribution
ggplot(data.frame(p = p), aes(x = p)) + geom_histogram(boundary = 1)


## Inversion Sampling
p <- runif(10000, 0, 1)
x <- qnorm(p)
ggplot(data.frame(x = x), aes(x = x)) + geom_histogram()



## Simulate data
lambda = 0.1

N = 100
p = runif(N)
event_time = - log(1 - p) / lambda

Y = Surv(event_time)
plot(survfit(Y ~ 1))
curve(exp(-x * lambda), add = T, col = 'blue')


################################################################################
## 1. Constant Hazard Model
################################################################################

rm(list = ls())

mod_1 = cmdstan_model("survival_1.stan")
## mod_1 = cmdstan_model("solution/survival_1.stan")
mod_1$print()

data_list = list(N = length(event_time), event_time = event_time)
fit_1 = mod_1$sample(data = data_list,
                     seed = 123,
                     chains = 4,
                     parallel_chains = 4,
                     refresh = 500)


fit_1$summary()
mcmc_hist(fit_1$draws("lambda")) + vline_at(lambda, size = 1.5)


fit_1$diagnostic_summary()

event_time_hat_draws = fit_1$draws("event_time_hat")
lambda_draws = fit_1$draws("lambda")


iter = sample(1:1000, 1); chain = sample(1:4, 1)
plot(survfit(Surv(event_time_hat_draws[iter,chain,]) ~ 1), main = glue::glue("lambda = {lambda_draws[iter, chain, ]}; iter = {iter}, chain = {chain}"))



################################################################################
## 2. Add Covariates
################################################################################

rm(list = ls())

## include treatment

lambda = 0.1
beta = log(0.5)

N = 200
treatment = sample(c(0, 1), N, replace = TRUE)
p = runif(N)
event_time = -log(1 - p) / (lambda * exp(treatment * beta))


Y = Surv(event_time)
plot(survfit(Y ~ treatment))
curve(exp(-x * lambda), add = T, col = 'blue')
curve(exp(-x * lambda * exp(beta)), add = T, col = 'green') 


data_list = list(N = length(event_time), event_time = event_time, treatment = treatment)


mod_2 = cmdstan_model("survival_2.stan")
## mod_2 = cmdstan_model("solution/survival_2.stan")

mod_2$print()

fit_2 = mod_2$sample(data = data_list,
                   seed = 123,
                   chains = 4,
                   parallel_chains = 4,
                   refresh = 500)
fit_2$summary()
mcmc_hist(fit_2$draws("lambda")) + vline_at(lambda, size = 1.5)
mcmc_hist(fit_2$draws("beta")) + vline_at(beta, size = 1.5)


event_time_hat_draws = fit_2$draws("event_time_hat")
lambda_draws = fit_2$draws("lambda")
beta_draws = fit_2$draws("beta")


iter = sample(1:1000, 1); chain = sample(1:4, 1)
Y = Surv(event_time_hat_draws[iter,chain,])
plot(survfit(Y ~ treatment), main = glue::glue("lambda = {lambda_draws[iter, chain, ]}, beta = {beta_draws[iter, chain, ]}; iter = {iter}, chain = {chain}"))
curve(exp(-x * lambda), add = T, col = 'blue')
curve(exp(-x * lambda * exp(beta)), add = T, col = 'green') 





################################################################################
## 3. Add Censoring
################################################################################

rm(list = ls())

lambda = 0.1
beta = log(0.5)
censor_time = 40

N = 200
treatment = sample(c(0, 1), N, replace = TRUE)
p = runif(N)
true_event_time = -log(1 - p) / (lambda * exp(treatment * beta))
censored = ifelse(true_event_time > censor_time, 1, 0)
event_time = pmin(true_event_time, censor_time)

data_list = list(N = length(event_time), event_time = event_time, treatment = treatment, censored = censored)




Y = Surv(event_time, censored == 0)
plot(survfit(Y ~ treatment))
curve(exp(-x * lambda), add = T, col = 'blue')
curve(exp(-x * lambda * exp(beta)), add = T, col = 'green') 





mod_3 = cmdstan_model("survival_3.stan")
## mod_3 = cmdstan_model("solution/survival_3.stan")

mod_3$print()

fit_3 = mod_3$sample(data = data_list,
                     seed = 123,
                     chains = 4,
                     parallel_chains = 4,
                     refresh = 500)
fit_3$summary()
mcmc_hist(fit_3$draws("lambda")) + vline_at(lambda, size = 1.5)
mcmc_hist(fit_3$draws("beta")) + vline_at(beta, size = 1.5)


event_time_hat_draws = fit_3$draws("event_time_hat")
lambda_draws = fit_3$draws("lambda")
beta_draws = fit_3$draws("beta")


iter = sample(1:1000, 1); chain = sample(1:4, 1)
Y = Surv(event_time_hat_draws[iter,chain,])
plot(survfit(Y ~ treatment), main = glue::glue("lambda = {lambda_draws[iter, chain, ]}, beta = {beta_draws[iter, chain, ]}; iter = {iter}, chain = {chain}"))
curve(exp(-x * lambda), add = T, col = 'blue')
curve(exp(-x * lambda * exp(beta)), add = T, col = 'green') 



################################################################################
## 4. Hierarchical Model
################################################################################


rm(list = ls())

mu_lambda = 0.3
sigma_lambda = 0.05
beta = log(0.5)
censor_time = 15

N = 200
lambda = rnorm(N, mu_lambda, sigma_lambda)
treatment = sample(c(0, 1), N, replace = TRUE)
p = runif(N)
true_event_time = -log(1 - p) / (lambda * exp(treatment * beta))
censored = ifelse(true_event_time > censor_time, 1, 0)
event_time = pmin(true_event_time, censor_time)

data_list = list(N = length(event_time), event_time = event_time, treatment = treatment, censored = censored)




Y = Surv(event_time, censored == 0)
plot(survfit(Y ~ treatment))
curve(exp(-x * mu_lambda), add = T, col = 'blue')
curve(exp(-x * mu_lambda * exp(beta)), add = T, col = 'green') 




mod_4 = cmdstan_model("survival_4.stan")
## mod_4 = cmdstan_model("solution/survival_4.stan")

mod_4$print()

fit_4 = mod_4$sample(data = data_list,
                     seed = 123,
                     chains = 4,
                     parallel_chains = 4,
                     refresh = 500)
fit_4$summary()
mcmc_hist(fit_4$draws("mu_lambda")) + vline_at(mu_lambda, size = 1.5)
mcmc_hist(fit_4$draws("sigma_lambda")) + vline_at(sigma_lambda, size = 1.5)
mcmc_hist(fit_4$draws("beta")) + vline_at(beta, size = 1.5)





fit_4$diagnostic_summary()



fit_4 = mod_4$sample(data = data_list,
                     seed = 123,
                     chains = 4,
                     parallel_chains = 4,
                     refresh = 500,
                     adapt_delta = 0.999)





################################################################################
## Slides: Generate constant hazard plots ("constant hazard function")
################################################################################

t = 0:100
lambda = 0.1

surv = data.frame(t = t, h = lambda, Lambda = lambda * t, S = exp(-lambda * t))

p1 = ggplot(surv, aes(x = t, y = h)) + geom_line() + ggtitle('hazard function')
p2 = ggplot(surv, aes(x = t, y = Lambda)) + geom_line() + ggtitle('cumulative hazard function')
p3 = ggplot(surv, aes(x = t, y = S)) + geom_line() + ggtitle('survival function')


grid.arrange(arrangeGrob(p1, p2, ncol=2), p3)
