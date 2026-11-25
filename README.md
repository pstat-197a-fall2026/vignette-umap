# vignette-umap

Vignette on implementing Uniform Manifold Approximation and Projection (UMAP) for visualization and non-linear dimensionality reduction on high dimensional data; created as a class project for PSTAT197A in Fall 2026.

### Contributors

- Lawrence Huynh

- Henry Ding

- Adrian Filip

- Tyler Hoong

### Abstract

UMAP is a tool for both visualization of high dimensional data and for non-linear feature extraction. This vignette demonstrates both use cases using the `uwot` library in R. We explore how UMAP works, the assumptions it makes on the data, and its pros and cons. We then go through two worked examples to demonstrate the use cases:

- Visualizing multi-dimensional customer data in 2D

- Feature extraction on vectorized webpage text data as a preprocessing step before classification

### Repository Contents

- `vignette.qmd`: Final quarto source for the vignette

- `vignette.html`: Final rendered version of the vignette

- `scripts/`: Scripts used for drafting the vignette

  - `part4-preprocessing.R`: Runs UMAP on the Module 2 claims TF-IDF data (2D for plotting, 10D as extracted features), evaluates with kNN on held-out pages, and saves the results to `claims-results.RData`
 
  - `part4-applyingtoclaimsdata.qmd`: Applies UMAP to the Module 2 claims text data in five steps (dataset, prepare, UMAP, visualize, evaluate), where 10 UMAP features reach 77.5% kNN accuracy on held-out pages versus 81.0% for all 5,367 TF-IDF features.

- `data`: Data used in the vignette

  - `processed/`: processed claims results data
 
    - `claims-results.Rdata`: Contains class counts, the data summary, the 2D UMAP embedding, the kNN accuracy table, the confusion matrix, timings, and the settings `n_feat` and `k`

  - `raw/`: Original unmodified data
 
    - `claims-raw.RData`: contains raw HTML and class labels for 2,165 webpages

    - `claims-test.RData`: contains raw HTML for 929 unlabeled webpages

- `img/`: Images for the vignette

### References

<https://umap-learn.readthedocs.io/en/latest/index.html>

<https://cran.r-project.org/web/packages/umap/vignettes/umap.html>

<https://pair-code.github.io/understanding-umap/>
