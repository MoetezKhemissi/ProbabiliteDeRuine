# Paramètres
initial_reserve <- 20
claim_rate_lambda <- 10
premium_rate <- 10000
sampled_claim_rate_lambda <- 15

simulate_ruin_probability <- function(cost_distribution, n_simulations, initial_reserve, claim_rate_lambda, premium_rate, sampled_claim_rate_lambda, lambda_exp, mu, sigma) {
  total_weight <- 0
  ruin_count <- 0
  
  for (i in 1:n_simulations) {
    n_claims_sampled <- rpois(1, lambda = sampled_claim_rate_lambda)
    weight <- dpois(n_claims_sampled, lambda = claim_rate_lambda) / dpois(n_claims_sampled, lambda = sampled_claim_rate_lambda)
    
    if (cost_distribution == "exponential") {
      claim_costs <- rexp(n_claims_sampled, rate = lambda_exp)
    } else if (cost_distribution == "lognormal") {
      claim_costs <- rlnorm(n_claims_sampled, meanlog = mu, sdlog = sigma)
    }
    
    cumulative_claims <- cumsum(claim_costs)
    premium_income <- seq_along(cumulative_claims) * premium_rate
    reserve <- initial_reserve + premium_income - cumulative_claims
    ruin_occurred <- any(reserve < 0)
    
    if (ruin_occurred) {
      total_weight <- total_weight + weight
      ruin_count <- ruin_count + 1
    }
  }
  
  return(ifelse(ruin_count > 0, total_weight / n_simulations, 0))
}

simulate_ruin_quantiles <- function(cost_distribution, n_simulations, initial_reserve, claim_rate_lambda, premium_rate, lambda_exp, mu, sigma) {
  deficits_at_ruin <- numeric()
  
  for (i in 1:n_simulations) {
    n_claims <- rpois(1, lambda = claim_rate_lambda)
    
    if (cost_distribution == "exponential") {
      claim_costs <- rexp(n_claims, rate = lambda_exp)
    } else if (cost_distribution == "lognormal") {
      claim_costs <- rlnorm(n_claims, meanlog = mu, sdlog = sigma)
    }
    
    cumulative_claims <- cumsum(claim_costs)
    premium_income <- seq_along(cumulative_claims) * premium_rate
    reserve <- initial_reserve + premium_income - cumulative_claims
    
    if (any(reserve < 0)) {
      deficits_at_ruin <- c(deficits_at_ruin, -min(reserve[reserve < 0]))
    }
  }
  
  quantile_95 <- quantile(deficits_at_ruin, 0.95, na.rm = TRUE)
  quantile_99 <- quantile(deficits_at_ruin, 0.99, na.rm = TRUE)
  return(c(quantile_95, quantile_99))
}

# Calculs
probability_of_ruin_exp <- simulate_ruin_probability("exponential", n_simulations, initial_reserve, claim_rate_lambda, premium_rate, sampled_claim_rate_lambda, lambda_exp, mu, sigma)
probability_of_ruin_lognorm <- simulate_ruin_probability("lognormal", n_simulations, initial_reserve, claim_rate_lambda, premium_rate, sampled_claim_rate_lambda, lambda_exp, mu, sigma)
quantiles_exp <- simulate_ruin_quantiles("exponential", n_simulations, initial_reserve, claim_rate_lambda, premium_rate, lambda_exp, mu, sigma)
quantiles_lognorm <- simulate_ruin_quantiles("lognormal", n_simulations, initial_reserve, claim_rate_lambda, premium_rate, lambda_exp, mu, sigma)

print(c(probability_of_ruin_exp, probability_of_ruin_lognorm))
print(c(quantiles_exp, quantiles_lognorm))
