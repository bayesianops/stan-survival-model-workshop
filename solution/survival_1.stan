// 1. Constant hazard model
data {
  int<lower = 0> N;
  vector<lower = 0>[N] event_time;
}
parameters {
  real<lower = 0> lambda;
}
model {
  // prior for lambda
  lambda ~ normal(0, 1);
  // likelihood for each event time
  for (n in 1:N) {
    target += -lambda * event_time[n] + log(lambda);
  }
}
generated quantities {
  vector<lower = 0>[N] event_time_hat;

  for (n in 1:N) {
    event_time_hat[n] = -log(1 - uniform_rng(0, 1)) / lambda;
  }
}

