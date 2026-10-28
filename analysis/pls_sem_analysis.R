# Generative AI Adoption Among University Students
# PLS-SEM analysis workflow
# Author: Mithoon Chakraborty

required_packages <- c("seminr", "psych")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop("Install required packages first: ", paste(missing_packages, collapse = ", "))
}

library(seminr)
library(psych)

# -----------------------------------------------------------------------------
# 1. Load private cleaned data
# -----------------------------------------------------------------------------

data_path <- "data/GenAI_FINAL_SmartPLS_Ready.csv"
if (!file.exists(data_path)) {
  stop(
    "Private cleaned data not found. Place GenAI_FINAL_SmartPLS_Ready.csv in data/."
  )
}

dat <- read.csv(data_path, stringsAsFactors = FALSE, check.names = FALSE)

expected_vars <- c(
  "PEOU1", "PEOU2", "PEOU3", "PEOU4",
  "PU1", "PU2", "PU3", "PU4",
  "SI1", "SI2", "SI3",
  "BI1", "BI2", "BI3",
  "AGE", "EXP"
)

missing_vars <- setdiff(expected_vars, names(dat))
if (length(missing_vars) > 0) {
  stop("Missing variables: ", paste(missing_vars, collapse = ", "))
}

dat <- dat[, expected_vars]
dat[] <- lapply(dat, as.numeric)

cat("N =", nrow(dat), "\n")
cat("Missing values =", sum(is.na(dat)), "\n")

# -----------------------------------------------------------------------------
# 2. Descriptive statistics
# -----------------------------------------------------------------------------

print(psych::describe(dat))

# -----------------------------------------------------------------------------
# 3. Measurement model
# Conceptually, PEOU, PU, SI, and BI are reflective constructs.
# Mode A is used here to align the estimation with standard PLS-SEM.
# -----------------------------------------------------------------------------

measurement_model <- constructs(
  composite("PEOU", multi_items("PEOU", 1:4), weights = mode_A),
  composite("PU", multi_items("PU", 1:4), weights = mode_A),
  composite("SI", multi_items("SI", 1:3), weights = mode_A),
  composite("BI", multi_items("BI", 1:3), weights = mode_A),
  composite("AGE_CTRL", single_item("AGE"), weights = mode_A),
  composite("EXP_CTRL", single_item("EXP"), weights = mode_A)
)

# -----------------------------------------------------------------------------
# 4. Structural model
# -----------------------------------------------------------------------------

structural_model <- relationships(
  paths(from = "PEOU", to = "PU"),
  paths(from = c("PEOU", "PU", "SI", "AGE_CTRL", "EXP_CTRL"), to = "BI")
)

# -----------------------------------------------------------------------------
# 5. Estimate PLS-SEM model
# -----------------------------------------------------------------------------

pls_model <- estimate_pls(
  data = dat,
  measurement_model = measurement_model,
  structural_model = structural_model,
  inner_weights = path_weighting,
  missing_value = NA,
  maxIt = 300,
  stopCriterion = 7
)

pls_summary <- summary(pls_model)
print(pls_summary)

# Useful objects
cat("\nOuter loadings\n")
print(pls_summary$loadings)

cat("\nReliability / validity\n")
print(pls_summary$reliability)
print(pls_summary$validity$htmt)
print(pls_summary$validity$fl_criteria)

cat("\nStructural VIF\n")
print(pls_summary$vif_antecedents)

cat("\nR-squared\n")
print(pls_model$rSquared)

# -----------------------------------------------------------------------------
# 6. Bootstrap inference: 5,000 resamples
# -----------------------------------------------------------------------------

set.seed(20261011)
boot_model <- bootstrap_model(
  seminr_model = pls_model,
  nboot = 5000,
  cores = 1,
  seed = 20261011
)

boot_summary <- summary(boot_model, alpha = 0.05)
print(boot_summary$bootstrapped_paths)

# Specific indirect effect: PEOU -> PU -> BI
mediation <- specific_effect_significance(
  boot_seminr_model = boot_model,
  from = "PEOU",
  through = "PU",
  to = "BI",
  alpha = 0.05
)
print(mediation)

# -----------------------------------------------------------------------------
# 7. Out-of-sample prediction
# 10-fold cross-validation, 10 repetitions
# -----------------------------------------------------------------------------

set.seed(20261011)
prediction <- predict_pls(
  model = pls_model,
  technique = predict_DA,
  noFolds = 10,
  reps = 10,
  cores = 1
)

prediction_summary <- summary(prediction)
print(prediction_summary)

# -----------------------------------------------------------------------------
# Final reported SmartPLS structural results
# -----------------------------------------------------------------------------

reported_results <- data.frame(
  Path = c("PEOU -> PU", "PU -> BI", "PEOU -> BI", "SI -> BI", "AGE_CTRL -> BI", "EXP_CTRL -> BI"),
  Beta = c(0.506, 0.457, 0.048, 0.077, 0.186, 0.125),
  T = c(4.538, 3.072, 0.342, 0.580, 1.769, 0.914),
  P = c("<.001", ".002", ".732", ".562", ".077", ".361"),
  f2 = c(0.345, 0.205, 0.002, 0.007, 0.043, 0.017)
)

print(reported_results)
