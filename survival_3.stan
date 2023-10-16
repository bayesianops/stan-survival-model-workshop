// 3. Add censored
data {
  int<lower = 0> N;
  vector<lower = 0>[N] real event_time;
  array[N] int<lower = 0, upper = 1> treatment;
  array[N] int<lower = 0, upper = 1> censored;
}
parameters {
  real<lower = 0> lambda;
  real beta;
}
model {
  lambda ~ normal(0, 1);
  beta ~ normal(0, 1);
  for (n in 1:N) {
    real lambda_n = lambda * exp(treatment[n] * beta);
    if (censored[n] == 0) {
      target += -lambda_n * event_time[n] + log(lambda_n);
    } else {
      // TODO: add censored likelihood
    }
  }
}
generated quantities {
  vector<lower = 0>[N] event_time_hat;

  for (n in 1:N) {
    event_time_hat[n] = -log(1 - uniform_rng(0, 1))
      / (lambda * exp(treatment[n] * beta));
  }
}

