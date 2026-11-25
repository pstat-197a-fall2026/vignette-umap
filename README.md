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

```
vignette-umap/
├── README.md                          # Project introduction
├── vignette.qmd                       # Final Quarto source for the vignette
├── vignette.html                      # Final rendered version of the vignette
│
├── data/
│   ├── raw/                           # Original unmodified data
│   │   ├── claims-raw.RData           # Raw HTML and labels for 2,165 webpages
│   │   └── claims-test.RData          # Raw HTML for 929 unlabeled webpages
│   └── processed/
│       └── claims-results.RData       # Class counts, data summary, 2D embedding, kNN accuracy
│                                      #   table, confusion matrix, timings, n_feat and k
│
├── img/                               # Images for the vignette
│   ├── claims-umap-2d.png             # 2D UMAP of claims pages, colored by class
│   └── claims-knn-accuracy.png        # Held-out kNN accuracy: 77.5% (10 UMAP features)
│                                      #   vs 81.0% (5,367 TF-IDF features) vs 54.4% (baseline)
│
└── scripts/                           # Scripts used for drafting the vignette
    ├── claims-preprocessing.R         # Runs UMAP on the claims TF-IDF data (2D for plotting,
    │                                  #   10D as extracted features), evaluates with kNN on
    │                                  #   held-out pages, saves results to claims-results.RData
    └── applyingtoclaimsdata.qmd       # Applies UMAP to the claims text data in five steps
                                       #   (dataset, prepare, UMAP, visualize, evaluate)
```

## References
 
Coenen, A., & Pearce, A. (n.d.). *Understanding UMAP*. Google PAIR. Retrieved November 25, 2026, from <https://pair-code.github.io/understanding-umap/>
 
Konopka, T. (2023). *Uniform manifold approximation and projection in R* [Package vignette]. In *umap: Uniform manifold approximation and projection* (R package version 0.2.10.0). The Comprehensive R Archive Network. <https://cran.r-project.org/web/packages/umap/vignettes/umap.html>
 
McInnes, L. (2018). *UMAP: Uniform manifold approximation and projection for dimension reduction* (Version 0.6.0) [Software documentation]. Retrieved November 25, 2026, from <https://umap-learn.readthedocs.io/en/latest/index.html>
