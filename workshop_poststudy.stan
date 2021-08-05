data {
    // must tell the program how many observations we have
    int<lower=0> N; // num obs
    // data we will use to fit
    vector[N] poststudy_scores; // the target
    vector[N] entrance_gpa; // n-dim int array of entrance gpas
    vector[N] study_times; // n-dim int array of study_times
    vector[N] prestudy_scores; // n-dim int array of prestudy_scores
    int<lower = 0> J_lecsec; // lecture section categories
    int<lower = 1, upper = J_lecsec>  lec_sec[N]; // n-dim int array of lecture sections

    // prior inputs
    real mu_sigma;
    real tau_sigma;

    real mu_intercept;
    real tau_intercept;

    real mu_tau_lecsec;
    real tau_tau_lecsec;

    real mu_beta1;
    real tau_beta1;

    real mu_beta2;
    real tau_beta2;

    real mu_beta3;
    real tau_beta3;

    real only_prior;
}

parameters {
    real beta_0; // always have an intercept
    real beta_1;
    real beta_2;
    real beta_3;
    // random effect params
    real<lower = 0> tau_lecsec;
    vector<multiplier = tau_lecsec>[J_lecsec] u_lecsec;

    // natural data variance
    // notice how it's half normally distributed
    real<lower=0> sigma;
}

transformed parameters{
    // model for the mean
    vector[N] mu = beta_0 + beta_1 * entrance_gpa +
                   beta_2 * prestudy_scores + beta_3 * study_times + u_lecsec[lec_sec];
}

model {
    //priors
    sigma ~ normal(mu_sigma, tau_sigma);
    beta_0 ~ normal(mu_intercept, tau_intercept);
    beta_1 ~ normal(mu_beta1, tau_beta1);
    beta_2 ~ normal(mu_beta2, tau_beta2);
    beta_3 ~ normal(mu_beta3, tau_beta3);
    tau_lecsec ~ normal(mu_tau_lecsec, tau_tau_lecsec);

    // random effects
    u_lecsec ~ normal (0, tau_lecsec);

    //likelihood (use the log likelihood)
    if(only_prior == 0){
        // poststudy_scores described by normal distn
        poststudy_scores ~ normal(mu, sigma);
    }
}

generated quantities {
    vector[N] log_lik;
    vector[N] y_pred;
    for(i in 1:N){
        log_lik[i] = normal_lpdf(poststudy_scores[i] | mu[i], sigma);
        // predict in sample
        y_pred[i] = normal_rng(mu[i], sigma);
    }
}