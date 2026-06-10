pacman::p_load(
  here,
  tidyverse
)

# ── Data: Sato & Matsuyama (2003), Table 1 in the manuscript ─────────────
# Effect of tamoxifen (A) on breast cancer recurrence (Y) among 4,901 women,
# with positive lymph node metastasis (W) as the sole binary confounder.
#   A = 1: tamoxifen use;  A = 0: no tamoxifen
#   Y = 1: recurrence;    Y = 0: no recurrence
#   W = 1: positive lymph node metastasis; W = 0: no metastasis

sato_tab <- tribble(
  ~W, ~A, ~Y,    ~N,
   0,  0,  0, 1421,
   0,  0,  1,  171,
   0,  1,  0, 1238,
   0,  1,  1,   96,
   1,  0,  0,  507,
   1,  0,  1,  253,
   1,  1,  0,  847,
   1,  1,  1,  368
)

# Expand grouped table to individual-level rows
d <- sato_tab %>% uncount(N)

# ── Outcome model ─────────────────────────────────────────────────────────
# With two binary variables, a saturated model (A*W interaction) recovers
# the exact stratum-specific means from the table — no parametric smoothing.
fit <- lm(Y ~ A * W, data = d)

# Counterfactual predictions for every individual under A=1 and A=0
d$Q1 <- predict(fit, newdata = transform(d, A = 1))  # E(Y | A=1, W_i)
d$Q0 <- predict(fit, newdata = transform(d, A = 0))  # E(Y | A=0, W_i)

# ── NICE g-formula ────────────────────────────────────────────────────────
# E(Y^a) = sum_w  E(Y | A=a, W=w) * P(W=w)
#        = E(Y|A=a,W=1)*P(W=1) + E(Y|A=a,W=0)*P(W=0)
#
# Implementation: group by W, compute the mean prediction within each stratum
# (the inner expectation), then weight by the stratum's sample proportion
# (the outer weighted sum).

nice <- d %>%
  group_by(W) %>%
  summarise(
    prob  = n() / nrow(d),   # P(W = w)
    EY_a1 = mean(Q1),        # E(Y | A=1, W=w)
    EY_a0 = mean(Q0),        # E(Y | A=0, W=w)
    .groups = "drop"
  )

E_Ya1_NICE <- sum(nice$EY_a1 * nice$prob)
E_Ya0_NICE <- sum(nice$EY_a0 * nice$prob)

cat("NICE  E(Y^{a=1}) =", round(E_Ya1_NICE, 3), "(paper: 0.165)\n")
cat("NICE  E(Y^{a=0}) =", round(E_Ya0_NICE, 3), "(paper: 0.198)\n")
cat("NICE  ATE        =", round(E_Ya1_NICE - E_Ya0_NICE, 3), "(paper: -0.033)\n")

# ── ICE g-formula ─────────────────────────────────────────────────────────
# E(Y^a) = E[ E(Y | A=a, W) ]
#
# Implementation: average the counterfactual predictions Q1 and Q0 over
# ALL individuals in the sample.  This marginalizes over the overall (marginal)
# distribution of W, which is what the outer expectation E[.] requires.
# The averaging is NOT restricted to those with A=1 or A=0.

E_Ya1_ICE <- mean(d$Q1)
E_Ya0_ICE <- mean(d$Q0)

cat("\nICE   E(Y^{a=1}) =", round(E_Ya1_ICE, 3), "(paper: 0.165)\n")
cat("ICE   E(Y^{a=0}) =", round(E_Ya0_ICE, 3), "(paper: 0.198)\n")
cat("ICE   ATE        =", round(E_Ya1_ICE - E_Ya0_ICE, 3), "(paper: -0.033)\n")

# ── Note on equivalence ───────────────────────────────────────────────────
# With a single binary confounder W and a saturated outcome model, NICE and
# ICE are algebraically identical: both reduce to
#   E(Y|A=a,W=1)*P(W=1) + E(Y|A=a,W=0)*P(W=0).
# NICE computes this via a grouped weighted sum; ICE computes it implicitly
# via a sample mean over all individuals.  As established in the manuscript,
# NICE and ICE are nonparametrically equivalent in general.

# ── Non-parametric verification (mirrors Table 1 arithmetic) ─────────────
# The stratum means and P(W) are read directly from the grouped table,
# reproducing the exact hand calculation shown in Section 3 of the manuscript.

EY_a1_w1 <- with(sato_tab %>% filter(A == 1, W == 1),
                 sum(Y * N) / sum(N))
EY_a1_w0 <- with(sato_tab %>% filter(A == 1, W == 0),
                 sum(Y * N) / sum(N))
EY_a0_w1 <- with(sato_tab %>% filter(A == 0, W == 1),
                 sum(Y * N) / sum(N))
EY_a0_w0 <- with(sato_tab %>% filter(A == 0, W == 0),
                 sum(Y * N) / sum(N))

N_total <- sum(sato_tab$N)
P_W1    <- sum(sato_tab$N[sato_tab$W == 1]) / N_total
P_W0    <- 1 - P_W1

E_Ya1_NP <- EY_a1_w1 * P_W1 + EY_a1_w0 * P_W0
E_Ya0_NP <- EY_a0_w1 * P_W1 + EY_a0_w0 * P_W0

cat("\nNon-parametric  E(Y^{a=1}) =", round(E_Ya1_NP, 3), "\n")
cat("Non-parametric  E(Y^{a=0}) =", round(E_Ya0_NP, 3), "\n")
cat("Non-parametric  ATE        =", round(E_Ya1_NP - E_Ya0_NP, 3), "\n")
