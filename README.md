# vignette-umap

Vignette on implementing Uniform Manifold Approximation and Projection (UMAP) for visualization and non-linear dimensionality reduction on high dimensional data; created as a class project for PSTAT 197A in Fall 2026.

## Contributors

- Lawrence Huynh

- Henry Ding

- Adrian Filip

- Tyler Hoong

## Abstract

UMAP is a tool for both visualization of high dimensional data and for non-linear feature extraction. This vignette demonstrates both use cases using the `uwot` library in R. We explore how UMAP works, the assumptions it makes on the data, and its pros and cons. We then go through two worked examples to demonstrate the use cases:

- Visualizing multi-dimensional customer data in 2D

- Feature extraction on vectorized webpage text data as a preprocessing step before classification

## Repository Contents

- `vignette.qmd`: Final quarto source for the vignette

- `vignette.html`: Final rendered version of the vignette

- `scripts/`: Scripts used for drafting the vignette

  - `claims-preprocessing.R`: Runs UMAP on the Module 2 claims TF-IDF data (2D for plotting, 10D as extracted features), evaluates with kNN on held-out pages, and saves the results to `claims-results.RData`
 
  - `applyingtoclaimsdata.qmd`: Applies UMAP to the Module 2 claims text data in five steps (dataset, prepare, UMAP, visualize, evaluate), where 10 UMAP features reach 77.5% kNN accuracy on held-out pages versus 81.0% for all 5,367 TF-IDF features

- `data`: Data used in the vignette

  - `processed/`: Processed claims results data
 
    - `claims-results.Rdata`: Contains class counts, the data summary, the 2D UMAP embedding, the kNN accuracy table, the confusion matrix, timings, and the settings `n_feat` and `k`

  - `raw/`: Original unmodified data
 
    - `claims-raw.RData`: Contains raw HTML and class labels for 2,165 webpages

    - `claims-test.RData`: Contains raw HTML for 929 unlabeled webpages

- `img/`: Images for the vignette

  - `claims-knn-accuracy.png`: Held-out kNN accuracy for three feature sets: 10 UMAP features reach 77.5%, close to the 81.0% from all 5,367 TF-IDF features and well above the 54.4% majority-class baseline
 
  - `claims-umap-2d.png`: A 2D UMAP of the claims pages' TF-IDF features, colored by class, showing some structure but heavy overlap between relevant and non-relevant pages 

## References
 
Coenen, A., & Pearce, A. (n.d.). *Understanding UMAP*. Google PAIR. Retrieved November 25, 2026, from <https://pair-code.github.io/understanding-umap/>
 
Konopka, T. (2023). *Uniform manifold approximation and projection in R* [Package vignette]. In *umap: Uniform manifold approximation and projection* (R package version 0.2.10.0). The Comprehensive R Archive Network. <https://cran.r-project.org/web/packages/umap/vignettes/umap.html>
 
McInnes, L. (2018). *UMAP: Uniform manifold approximation and projection for dimension reduction* (Version 0.6.0) [Software documentation]. Retrieved November 25, 2026, from <https://umap-learn.readthedocs.io/en/latest/index.html>
