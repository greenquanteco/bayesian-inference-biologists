install.packages("brms")

install.packages("pkgbuild")
pkgbuild::check_build_tools(debug = TRUE)

install.packages(
  "cmdstanr",
  repos = c(
    "https://stan-dev.r-universe.dev",
    getOption("repos")
  )
)

library(cmdstanr)
check_cmdstan_toolchain()
cmdstanr::install_cmdstan(overwrite=TRUE)

#cmdstanr::install_cmdstan(version = "2.37.0")

cmdstanr::cmdstan_version()

library(brms)
options(brms.backend = "cmdstanr")


# Generate example data
set.seed(123)
x <- runif(100, 0, 10)
y <- rpois(100, exp(1.5 + 0.2 * x))
dx <- data.frame(x, y)

# Fit Bayesian Poisson GLM
mod <- brm(
  y ~ x,
  data = dx,
  family = poisson(link = "log"),
  prior = c(
    prior(normal(0, 2), class = "Intercept"),
    prior(normal(0, 1), class = "b")
  ),
  chains = 3,
  iter = 2000,
  warmup = 1000,
  seed = 123
)

# Examine the results
summary(mod)
plot(mod)
