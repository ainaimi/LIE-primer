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


expit <- function(x){
  1/(1+exp(-x))
}

n <- 1e6

z0 <- rbinom(n, size = 1, prob = .5)

a0 <- rbinom(n, size = 1, prob = expit(-1 + log(1.5)*z0))

z1 <- rbinom(n, size = 1, prob = expit(-1 + log(1.5)*z0 + log(1.5)*a0 + log(1.5)*z0*a0))

a1 <- rbinom(n, size = 1, prob = expit(-1 + log(1.5)*z0 + log(1.5)*a0 + log(1.5)*z1))

y <- rnorm(n, mean = 150 + 1.5*z0 + 1.5*a0 - 1.5*z1  + 2*a1, sd = 1)

a <- data.frame(z0, a0, z1, a1, y)

head(a)

write_csv(a, here("data", "time_varying_data.csv"))

a %>% 
  group_by(z0, a0, z1, a1) %>% 
  summarize(meanY = mean(y), n = n()) %>% 
  xtable(.)

d <- a

# Step 1: inner expectation — fit E(Y | Z0, A0, Z1, A1), predict under (a0, a1)
fit1     <- lm(y ~ z0 + a0 + z1 + a1, data = d)
d$Q1_11  <- predict(fit1, newdata = transform(d, a0 = 1, a1 = 1))
d$Q1_00  <- predict(fit1, newdata = transform(d, a0 = 0, a1 = 0))

# Step 2: middle expectation — fit E(Q1 | Z0, A0), predict under a0
fit2_11  <- lm(Q1_11 ~ z0 + a0, data = d)
fit2_00  <- lm(Q1_00 ~ z0 + a0, data = d)
d$Q2_11  <- predict(fit2_11, newdata = transform(d, a0 = 1))
d$Q2_00  <- predict(fit2_00, newdata = transform(d, a0 = 0))

# Step 3: outer expectation — average over empirical distribution of Z0
E_Ya1    <- mean(d$Q2_11)
E_Ya0    <- mean(d$Q2_00)

round(E_Ya1 - E_Ya0, 2)