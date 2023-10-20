// 2. Add Covariates
data {
  int<lower = 0> N;
  vector<lower = 0>[N] event_time;
  array[N] int<lower = 0, upper = 1> treatment;
}
parameters {
  real<lower = 0> lambda;
  real beta;
}
model {
  lambda ~ normal(0, 1);
  beta ~ normal(0, 1);
  for (n in 1:N) {
    // TODO: update likelihood to include covariate
    target += -lambda * event_time[n] + log(lambda);
  }
}
generated quantities {
  vector<lower = 0>[N] event_time_hat;

  for (n in 1:N) {
    event_time_hat[n] = -log(1 - uniform_rng(0, 1))
      / (lambda * exp(treatment[n] * beta));
  }
}
