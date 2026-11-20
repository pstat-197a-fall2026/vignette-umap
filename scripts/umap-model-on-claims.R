# Apply HTML parsing and cleaning
claims_parsed <- parse_data(claims_raw)

# Tokenization, lemmatization, and TF-IDF
claims_tfidf <- nlp_fn(claims_parsed)

library(uwot)
library(ggplot2)
library(dplyr)

# Extract document labels
claims_labels <- claims_tfidf %>%
  select(.id, bclass)

# Extract numerical TF-IDF features
tfidf_matrix <- claims_tfidf %>%
  select(-.id, -bclass) %>%
  as.matrix()

# Check dimensions
dim(tfidf_matrix)

# Check for missing values
sum(is.na(tfidf_matrix))

set.seed(197)

umap_model <- umap(
  tfidf_matrix,
  n_neighbors = 15,
  n_components = 2,
  min_dist = 0.1,
  metric = "cosine",
  n_threads = 1,
  verbose = TRUE
)

# Convert UMAP output into dataframe
umap_df <- as.data.frame(umap_model)

# Rename dimensions
colnames(umap_df) <- c("UMAP1", "UMAP2")

# Add document labels
umap_df <- bind_cols(claims_labels, umap_df)

# Plot
ggplot(umap_df, aes(x = UMAP1, y = UMAP2, color = bclass)) +
  geom_point(alpha = 0.6, size = 1.5) +
  labs(
    title = "UMAP Visualization of Claims Text Data",
    subtitle = "TF-IDF document representations",
    x = "UMAP Dimension 1",
    y = "UMAP Dimension 2",
    color = "Claim Classification"
  ) +
  theme_minimal()