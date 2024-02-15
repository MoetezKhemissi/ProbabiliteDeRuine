library(ggplot2)

# Paramètres de simulation
n_simulations <- 100  # Réduit pour une meilleure lisibilité du graphique
n_claims <- 50  # Nombre de sinistres par simulation
initial_reserve <- 100  # Réserve initiale
premium_rate <- 1.2  # Taux de prime par période
lambda_exp <- 0.1  # Taux pour la distribution exponentielle des coûts des sinistres

set.seed(123) # Pour la reproductibilité

# Fonction pour simuler une trajectoire de réserve
simulate_reserve_trajectory <- function(n_claims, initial_reserve, premium_rate, lambda_exp) {
  claim_costs <- rexp(n_claims, rate = lambda_exp)
  cumulative_claims <- cumsum(claim_costs)
  premium_income <- seq_along(cumulative_claims) * premium_rate
  reserve <- initial_reserve + premium_income - cumulative_claims
  return(reserve)
}

# Générer les trajectoires de réserve pour plusieurs simulations
trajectories <- t(replicate(n_simulations, simulate_reserve_trajectory(n_claims, initial_reserve, premium_rate, lambda_exp)))

# Préparer les données pour ggplot
data <- data.frame(time = rep(1:n_claims, n_simulations),
                   reserve = as.vector(trajectories),
                   simulation = rep(1:n_simulations, each = n_claims))

# Créer le graphique
ggplot(data, aes(x = time, y = reserve, group = simulation)) +
  geom_line(alpha = 0.5) +  # Utiliser une faible opacité pour mieux voir les trajectoires
  theme_minimal() +
  labs(title = "Évolution de la Réserve Financière dans les Simulations de Monte-Carlo",
       x = "Temps (Nombre de sinistres)",
       y = "Réserve Financière") +
  theme(legend.position = "none") # Pas de légende nécessaire