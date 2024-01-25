import numpy as np
import scipy.stats as stats

# Parameters
n_simulations = 10000   # Number of simulations
claim_count_distribution = "negative_binomial"  # Non-Poisson distribution for claim counts
claim_cost_distribution_1 = "exponential"  # Satisfying Cramér's condition
claim_cost_distribution_2 = "lognormal"  # Not satisfying Cramér's condition

# Negative Binomial Distribution Parameters
r = 10  # Number of successes
p = 0.5  # Probability of success

# Exponential Distribution Parameter
lambda_exp = 0.3  # Rate parameter

# Lognormal Distribution Parameters
mu = 0  # Mean
sigma = 1  # Standard deviation

# Monte Carlo Simulation
total_costs_1 = []
total_costs_2 = []
for _ in range(n_simulations):
    # Generate number of claims
    n_claims = np.random.negative_binomial(r, p)

    # Generate claim costs
    costs_1 = np.random.exponential(scale=1/lambda_exp, size=n_claims)
    costs_2 = np.random.lognormal(mean=mu, sigma=sigma, size=n_claims)

    # Sum costs to get total cost
    total_costs_1.append(np.sum(costs_1))
    total_costs_2.append(np.sum(costs_2))

# Calculate extreme quantiles
quantile_95_1 = np.percentile(total_costs_1, 95)
quantile_99_1 = np.percentile(total_costs_1, 99)
quantile_95_2 = np.percentile(total_costs_2, 95)
quantile_99_2 = np.percentile(total_costs_2, 99)

print(quantile_95_1)

print(quantile_99_1)

print(quantile_95_2)

print(quantile_99_2)

