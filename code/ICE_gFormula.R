pacman::p_load(
  rio,
  here,
  skimr,
  tidyverse,
  lmtest,
  sandwich,
  broom, 
  xtable
)

thm <- theme_classic() +
  theme(
    legend.position = "top",
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.key = element_rect(fill = "transparent", colour = NA)
  )
theme_set(thm)

a <- read_csv(here("data", "nhefs.csv")) %>% select(seqn, qsmk, wt82_71, age, 
                                                    income, race, sex)

table(a$income)

a$income3 <- dplyr::case_when(
  a$income %in% 11:16 ~ "Low",
  a$income %in% 17:19 ~ "Middle",
  a$income %in% 20:22 ~ "High",
  TRUE ~ NA_character_
)

a$income3 <- factor(
  a$income3,
  levels = c("Low", "Middle", "High")
)

b <- a %>% mutate(qsmk = factor(qsmk), 
                  race = factor(race),
                  sex = factor(sex)) %>% 
  select(-income)




# ── ICE g-formula ─────────────────────────────────────────────────────────────
# Step 1: fit outcome model — estimates the inner expectation E(Y | A, W)
# note, this model assumes no interaction
fit <- lm(wt82_71 ~ qsmk + age + race + sex + income3, data = b)

# Step 2: counterfactual datasets — set A=a for everyone, keep observed W
b_a1 <- b %>% mutate(qsmk = factor(1, levels = levels(b$qsmk)))
b_a0 <- b %>% mutate(qsmk = factor(0, levels = levels(b$qsmk)))

# Step 3: inner expectation — predicted E(Y | A=a, W_i) for each individual i
b$Q1 <- predict(fit, newdata = b_a1)   # E(Y | A=1, W_i)
b$Q0 <- predict(fit, newdata = b_a0)   # E(Y | A=0, W_i)

# Step 4: outer expectation — average over empirical distribution of W
# This empirically implements:
#   sum_{w4} sum_{w3} sum_{w2} integral E(Y|a, w1,w2,w3,w4) f(w) dw1
# using the sample as a plug-in for f(w1, w2, w3, w4)
E_Ya1 <- mean(b$Q1)
E_Ya0 <- mean(b$Q0)

cat("E(Y^{a=1}) =", round(E_Ya1, 3), "\n")
cat("E(Y^{a=0}) =", round(E_Ya0, 3), "\n")
cat("ATE =", round(E_Ya1 - E_Ya0, 3), "\n")