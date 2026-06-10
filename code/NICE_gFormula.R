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

# table
a[1:8,] %>% select(-income) %>% xtable(.)

b <- a %>% mutate(qsmk = factor(qsmk), 
                  race = factor(race),
                  sex = factor(sex)) %>% 
  select(-income)


# figure
GGally::ggpairs(b[,-1],
                upper = list(continuous = GGally::wrap("cor", size = 5))) +
  theme(strip.text = element_text(size = 16),
        axis.text  = element_text(size = 16))
ggsave(here("figures", "nhefs_variables.png"))


## nice 
# implements: sum_{w4} sum_{w3} sum_{w2} [ int E(Y|a,w1,w2,w3,w4) f(w1) dw1 ] * P(w2,w3,w4)
# note that this could be done by also stratifying this model within levels of qsmk
fit <- lm(wt82_71 ~ qsmk + age + race + sex + income3, data = b)

# inner expectation: E(Y | A=a, W_i) for each individual
b$Q1 <- predict(fit, newdata = b %>% mutate(qsmk = factor(1, levels = levels(b$qsmk))))
b$Q0 <- predict(fit, newdata = b %>% mutate(qsmk = factor(0, levels = levels(b$qsmk))))

# NICE: group by discrete cells (w2, w3, w4), average Q over age within each
# cell (the empirical integral over w1), then weight by cell probability
nice <- b %>%
  group_by(race, sex, income3) %>%
  summarise(
    prob      = n() / nrow(b),   # P(W2=w2, W3=w3, W4=w4)
    EY_a1     = mean(Q1),        # integral E(Y|A=1, w1, w2, w3, w4) f(w1) dw1
    EY_a0     = mean(Q0),
    .groups   = "drop"
  )

nice  # inspect each cell's contribution

E_Ya1_NICE <- sum(nice$EY_a1 * nice$prob)
E_Ya0_NICE <- sum(nice$EY_a0 * nice$prob)

cat("NICE E(Y^{a=1}) =", round(E_Ya1_NICE, 3), "\n")
cat("NICE E(Y^{a=0}) =", round(E_Ya0_NICE, 3), "\n")
cat("NICE ATE        =", round(E_Ya1_NICE - E_Ya0_NICE, 3), "\n")

