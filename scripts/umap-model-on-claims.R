# Part 4: UMAP on the claims text data (Module 2)
#
# Run from the project root (open vignette-umap.Rproj first).
# Output: data/processed/claims-results.RData, which is loaded by
# part4-claims-umap.qmd so the qmd does not need to refit anything.

library(tidyverse)
library(uwot)
library(class)

# ---- Step 1: Load and reintroduce the data ---------------------------------

load("data/raw/claims-raw.RData")      # creates claims_raw
source("scripts/preprocessing.R")      # parse_data(), nlp_fn()

# Raw class counts, for the "reintroduce the dataset" slide
raw_class_counts <- claims_raw %>%
  count(bclass, name = "n_docs")

# ---- Step 2: Prepare the data ----------------------------------------------

# Apply HTML parsing and cleaning
claims_parsed <- parse_data(claims_raw)

# Tokenization, lemmatization, and TF-IDF (one row per document)
claims_tfidf <- nlp_fn(claims_parsed)

# Readable class labels (bclass is the binary label in the raw data)
claims_labels <- claims_tfidf %>%
  select(.id, bclass) %>%
  mutate(
    class = if_else(str_detect(as.character(bclass), "^N/A"),
                    "No relevant content", "Relevant claim content"),
    class = factor(class)
  )

# Numeric TF-IDF features
tfidf_matrix <- claims_tfidf %>%
  select(-.id, -bclass) %>%
  as.matrix()

# Train/test split (80/20, stratified by class)
set.seed(197)
split <- claims_labels %>%
  mutate(row = row_number()) %>%
  group_by(class) %>%
  mutate(is_train = row %in% sample(row, size = floor(0.8 * n()))) %>%
  ungroup() %>%
  arrange(row)
train_idx <- which(split$is_train)
test_idx  <- which(!split$is_train)

# Drop very rare terms (fewer than 5 training docs). Uses training docs only.
keep_terms <- colSums(tfidf_matrix[train_idx, , drop = FALSE] > 0) >= 5
tfidf_matrix <- tfidf_matrix[, keep_terms, drop = FALSE]

# Summary of the prepared data
data_summary <- tibble(
  n_docs         = nrow(tfidf_matrix),
  n_features     = ncol(tfidf_matrix),
  n_train        = length(train_idx),
  n_test         = length(test_idx),
  pct_zero       = mean(tfidf_matrix == 0),
  missing_values = sum(is.na(tfidf_matrix))
)
class_counts <- count(claims_labels, class, name = "n_docs")

# ---- Step 3: Apply UMAP ----------------------------------------------------

# (a) 2D embedding of all documents, for visualization
set.seed(197)
umap_2d <- umap(
  tfidf_matrix,
  n_neighbors  = 15,
  n_components = 2,
  min_dist     = 0.1,
  metric       = "cosine",
  n_threads    = 1,
  verbose      = TRUE
)

umap_df <- as.data.frame(umap_2d)
colnames(umap_df) <- c("UMAP1", "UMAP2")
umap_df <- bind_cols(claims_labels, umap_df, split["is_train"])

# (b) 10D embedding fit on TRAINING docs only, then applied to the test docs.
#     This is UMAP used as feature extraction, not only a picture.
n_feat <- 10
set.seed(197)
t_fit <- system.time({
  umap_10d_model <- umap(
    tfidf_matrix[train_idx, ],
    n_neighbors  = 15,
    n_components = n_feat,
    min_dist     = 0.1,
    metric       = "cosine",
    n_threads    = 1,
    ret_model    = TRUE
  )
})[["elapsed"]]

set.seed(197)
t_transform <- system.time({
  test_embedding <- umap_transform(tfidf_matrix[test_idx, ], umap_10d_model)
})[["elapsed"]]

train_embedding <- umap_10d_model$embedding

# ---- Step 5: Evaluate ------------------------------------------------------
# Does the low-dimensional representation keep the class information?
# We use k-nearest-neighbors on held-out documents, with three feature sets.

y_train <- claims_labels$class[train_idx]
y_test  <- claims_labels$class[test_idx]
k <- 15

# Baseline 1: always predict the majority training class
majority_class <- names(which.max(table(y_train)))
acc_majority <- mean(as.character(y_test) == majority_class)

# Baseline 2: kNN on the full TF-IDF space (rows scaled to unit length so
# Euclidean distance orders neighbors the same way cosine distance does)
l2 <- function(m) m / pmax(sqrt(rowSums(m^2)), 1e-12)
pred_tfidf <- knn(l2(tfidf_matrix[train_idx, ]),
                  l2(tfidf_matrix[test_idx, ]), cl = y_train, k = k)
acc_tfidf <- mean(pred_tfidf == y_test)

# UMAP features: kNN on the 10 extracted dimensions
pred_umap <- knn(train_embedding, test_embedding, cl = y_train, k = k)
acc_umap <- mean(pred_umap == y_test)

eval_table <- tibble(
  features   = c("Majority class", "Full TF-IDF", "UMAP (10 dims)"),
  n_features = c(0, ncol(tfidf_matrix), n_feat),
  accuracy   = c(acc_majority, acc_tfidf, acc_umap)
)

confusion_umap <- as.data.frame(table(truth = y_test, predicted = pred_umap))

timing <- tibble(umap_fit_sec = t_fit, umap_transform_sec = t_transform)

# Test documents in the 10D embedding, for plotting the first two dims
test_embedding_df <- as.data.frame(test_embedding[, 1:2])
colnames(test_embedding_df) <- c("UMAP1", "UMAP2")
test_embedding_df$class <- y_test

# ---- Save ------------------------------------------------------------------

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
save(
  raw_class_counts, class_counts, data_summary,
  umap_df, test_embedding_df,
  eval_table, confusion_umap, timing,
  n_feat, k,
  file = "data/processed/claims-results.RData"
)

