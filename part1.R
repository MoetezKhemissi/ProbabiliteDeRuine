library(MASS) # pour la distribution log-normale
library(stats) # pour les fonctions de distribution

# Paramètres
n_simulations <- 10000
r <- 10  # Nombre de succès pour la distribution binomiale négative
p <- 0.5  # Probabilité de succès
lambda_exp <- 0.3  # Paramètre pour la distribution exponentielle
mu <- 0  # Moyenne pour la distribution log-normale
sigma <- 1  # Écart-type pour la distribution log-normale

# Simulation Monte Carlo
simulate_costs <- function(distribution, n_simulations, r, p, lambda_exp, mu, sigma) {
  total_costs <- numeric(n_simulations)
  for (i in 1:n_simulations) {
    n_claims <- rnbinom(1, size = r, prob = p)
    if (distribution == "exponential") {
      claim_costs <- rexp(n_claims, rate = lambda_exp)
    } else if (distribution == "lognormal") {
      claim_costs <- rlnorm(n_claims, meanlog = mu, sdlog = sigma)
    }
    total_costs[i] <- sum(claim_costs)
  }
  return(total_costs)
}

total_costs_1 <- simulate_costs("exponential", n_simulations, r, p, lambda_exp, mu, sigma)
total_costs_2 <- simulate_costs("lognormal", n_simulations, r, p, lambda_exp, mu, sigma)

# Calcul des quantiles extrêmes
quantile_95_1 <- quantile(total_costs_1, 0.95)
quantile_99_1 <- quantile(total_costs_1, 0.99)
quantile_95_2 <- quantile(total_costs_2, 0.95)
quantile_99_2 <- quantile(total_costs_2, 0.99)

print(c(quantile_95_1, quantile_99_1, quantile_95_2, quantile_99_2))
