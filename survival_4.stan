// 4. Hierarchical model
data {
  int<lower = 0> N;
  vector<lower = 0>[N] event_time;
  array[N] int<lower = 0, upper = 1> treatment;
  array[N] int<lower = 0, upper = 1> censored;
}
parameters {
  real<lower = 0> mu_lambda;
  real<lower = 0> sigma_lambda;
  vector<lower = 0>[N] lambda;
  real beta;
}
model {
  // TODO: add hierchical model for lambda
  // mu_lambda ~ ...
  // sigma_lambda ~ ...
  // lambda ~ ...
  
  beta ~ normal(0, 1);
  
  for (n in 1:N) {
    // TODO: update likelihood 
    real lambda_n = lambda * exp(treatment[n] * beta);
    if (censored[n] == 0) {
      target += -lambda_n * event_time[n] + log(lambda_n);
    } else {
      target += -lambda_n * event_time[n];
    }
  }
}
generated quantities {
  vector<lower = 0>[N] event_time_hat;

  for (n in 1:N) {
    event_time_hat[n] = -log(1 - uniform_rng(0, 1))
      / (lambda[n] * exp(treatment[n] * beta));
  }
}

