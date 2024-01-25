import numpy as np
import scipy.stats as stats

# Paramètres
n_simulations = 10000
initial_reserve = 20
claim_rate_lambda = 10
premium_rate = 10000
sampled_claim_rate_lambda = 15
# Paramètres pour les distributions de coût des sinistres
lambda_exp = 0.3  # Distribution exponentielle
mu = 0          # Distribution log-normale (moyenne)
sigma = 1       # Distribution log-normale (écart-type)

def simulate_ruin_probability(cost_distribution):
    total_weight = 0
    ruin_count = 0

    for _ in range(n_simulations):
        n_claims_sampled = np.random.poisson(lam=sampled_claim_rate_lambda)
        weight = (stats.poisson.pmf(n_claims_sampled, claim_rate_lambda) /
                  stats.poisson.pmf(n_claims_sampled, sampled_claim_rate_lambda))

        if cost_distribution == "exponential":
            claim_costs = np.random.exponential(scale=1/lambda_exp, size=n_claims_sampled)
        elif cost_distribution == "lognormal":
            claim_costs = np.random.lognormal(mean=mu, sigma=sigma, size=n_claims_sampled)

        cumulative_claims = np.cumsum(claim_costs)
        premium_income = np.arange(len(cumulative_claims)) * premium_rate
        reserve = initial_reserve + premium_income - cumulative_claims
        ruin_occurred = np.any(reserve < 0)

        if ruin_occurred:
            total_weight += weight
            ruin_count += 1

    return total_weight / n_simulations if ruin_count > 0 else 0

def simulate_ruin_quantiles(cost_distribution):
    deficits_at_ruin = []

    for _ in range(n_simulations):
        n_claims = np.random.poisson(lam=claim_rate_lambda)

        if cost_distribution == "exponential":
            claim_costs = np.random.exponential(scale=1/lambda_exp, size=n_claims)
        elif cost_distribution == "lognormal":
            claim_costs = np.random.lognormal(mean=mu, sigma=sigma, size=n_claims)

        cumulative_claims = np.cumsum(claim_costs)
        premium_income = np.arange(len(cumulative_claims)) * premium_rate
        reserve = initial_reserve + premium_income - cumulative_claims

        if np.any(reserve < 0):
            deficits_at_ruin.append(-reserve[reserve < 0][0])


    quantile_95 = np.percentile(deficits_at_ruin, 95) if deficits_at_ruin else None
    quantile_99 = np.percentile(deficits_at_ruin, 99) if deficits_at_ruin else None
    return quantile_95, quantile_99


# Calcul de la probabilité de ruine pour chaque distribution de coût
probability_of_ruin_exp = simulate_ruin_probability("exponential")
probability_of_ruin_lognorm = simulate_ruin_probability("lognormal")
quantiles_exp = simulate_ruin_quantiles("exponential")
quantiles_lognorm = simulate_ruin_quantiles("lognormal")
print(probability_of_ruin_exp)
print(probability_of_ruin_lognorm)
print(quantiles_exp)
print(quantiles_lognorm)

