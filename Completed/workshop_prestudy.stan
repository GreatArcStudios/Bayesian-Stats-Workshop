data {
    // must tell the program how many observations we have
    int<lower=0> N; // num obs
    // the data we use to fit
    vector[N] prestudy_scores; // the target (response var)
    vector[N] entrance_gpa; // n-dim int array of entrance gpas
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
    // flag to control prior vs posterior
    real only_prior;
}

parameters {
    real beta_0; // always have an intercept
    real beta_1; // the entrance gpa coeff.

    // random effect params
    // can also be formulated like here: https://rpubs.com/kaz_yos/stan-multi-1
    real<lower = 0> tau_lecsec; // standard dev of the random effect
    vector<multiplier = tau_lecsec>[J_lecsec] u_lecsec; // the random effects

    // natural data variance
    // notice how it's half normally distributed
    real<lower=0> sigma;
}

transformed parameters{
    // modelling the mean
    vector[N] mu = beta_0 + beta_1 * entrance_gpa + u_lecsec[lec_sec];
}

model {
    //priors
    sigma ~ normal(mu_sigma, tau_sigma);
    beta_0 ~ normal(mu_intercept, tau_intercept);
    beta_1 ~ normal(mu_beta1, tau_beta1);
    tau_lecsec ~ normal(mu_tau_lecsec, tau_tau_lecsec);

    // random effects
    u_lecsec ~ normal(0, tau_lecsec);

    //likelihood, posterior is proportional to likelihood * prior
    if(only_prior == 0){
        // prestudy_scores described by normal distn
        prestudy_scores ~ normal(mu, sigma);
    }
}

generated quantities {
    vector[N] log_lik;
    vector[N] y_pred;
    for(i in 1:N){
        log_lik[i] = normal_lpdf(prestudy_scores[i] | mu[i], sigma);
        y_pred[i] = normal_rng(mu[i], sigma);
    }
}