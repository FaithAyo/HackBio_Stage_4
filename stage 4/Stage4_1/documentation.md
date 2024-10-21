# Documentation for Functional Enrichment Analysis App
---

## Overview
This R Shiny app performs functional enrichment analysis by implementing two core functions from the TCGAbiolinks package: `TCGAanalyze_EAcomplete()` and `TCGAvisualize_EAbarplot()`. These functions allow users to analyze gene lists to identify enriched Gene Ontology (GO) terms and biological pathways. The app presents results in both tabular and graphical formats, making it easy to explore biological processes, cellular components, molecular functions, and pathways.
---

### Installation and Requirements
Ensure the following libraries are installed to run the app:
```r
install.packages(c("shiny", "shinydashboard", "TCGAbiolinks", "DT"))
```

#### Features and Functionalities

1. **Home Tab:**
   - Provides a brief introduction and navigation instructions for using the app.

2. **Enrichment Analysis Tab:**
   - **Input:**
     - Users can either paste a list of genes (one per line) into the provided text area or upload gene lists (file input functionality is commented for future implementation).
     - Users select enrichment types, including Biological Process (BP), Cellular Component (CC), Molecular Function (MF), and Pathways.
   - **Output:**
     - The app runs the `TCGAanalyze_EAcomplete()` function for the selected enrichment types and displays results in a dynamic table.
     - A bar plot of the top enriched terms is generated using `TCGAvisualize_EAbarplot()`, allowing users to visualize the top 10 enriched categories.

3. **Contact Tab:**
   - Provides contact information for the development team for support and inquiries.

## Methods

1. **Enrichment Analysis:**
   - The app utilizes the `TCGAanalyze_EAcomplete()` function to perform functional enrichment analysis. It takes in a user-provided gene list and classifies the genes according to Gene Ontology categories such as Biological Process, Cellular Component, Molecular Function, and Pathways.
   - The app also uses `TCGAvisualize_EAbarplot()` to render bar plots of the most enriched terms. This function displays the enrichment results in an easy-to-read format, helping users to quickly grasp which terms are overrepresented in their dataset.

2. **Data Handling:**
   - Gene lists are split into vectors and processed through `TCGAanalyze_EAcomplete()`. The results are then stored in a list and displayed in a table using `DT` for dynamic and interactive tables.
   - The bar plot is rendered based on the top terms from the enrichment results.

#### Challenges Encountered

One of the main challenges during development was fully understanding the task and replicating the functionality of the original ShinyGO app. We faced difficulties with package installations due to missing dependencies, which required multiple trials and troubleshooting to resolve. Additionally, we encountered server timeout errors while attempting to deploy the app, which slowed down our progress. Time constraints also added pressure as we worked to stay on schedule. Finally, generating meaningful plots involved fine-tuning parameters to achieve clear and informative visualizations.

## How to Use the App
---
1. **Input:**
   - Paste a gene list in the designated text area.
   - Select enrichment types (Biological Process, Cellular Component, Molecular Function, Pathway).
   - Click "Run Enrichment Analysis."

2. **Output:**
   - A dynamic table with enriched terms and associated statistics.
   - A bar plot showing the top 10 enriched terms.

#### Conclusion
This app provides a straightforward interface for conducting functional enrichment analysis, leveraging the powerful tools in the TCGAbiolinks package. It simplifies the process of understanding the biological relevance of gene sets through interactive visualizations and tables.
