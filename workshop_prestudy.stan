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

}

transformed parameters{

}

model {

}

generated quantities {

}