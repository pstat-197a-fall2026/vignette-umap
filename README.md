# vignette-umap

Vignette on implementing Uniform Manifold Approximation and Projection (UMAP) for visualization and non-linear dimensionality reduction on high dimensional data; created as a class project for PSTAT197A in Fall 2026*.*

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

- `vignette.qmd`: Quarto source for the vignette

- `vignette.html`: Rendered version of the vignette

- `scripts/`: Scripts used for making the vignette

- `data`: Data used in the vignette

  - `processed/`: processed claims results data

  - `raw/`: Original unmodified data

- `img/`: Images for the vignette

### References

<https://umap-learn.readthedocs.io/en/latest/index.html>

<https://cran.r-project.org/web/packages/umap/vignettes/umap.html>

<https://pair-code.github.io/understanding-umap/>
