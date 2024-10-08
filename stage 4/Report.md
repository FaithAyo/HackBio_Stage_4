#Functional Enrichment 

### **Functional Enrichment Analysis App Report**

#### **Introduction**
The Functional Enrichment Analysis App is an interactive R Shiny web application designed to analyze gene sets for functional enrichment using data from The Cancer Genome Atlas (TCGA). The app allows users to select species, perform enrichment analysis, and visualize protein-protein interactions. It is built using R's Shiny framework, integrating bioinformatics tools such as `TCGAbiolinks` and `biomaRt` to enable analysis of gene ontology (GO) terms and pathways.

#### **App Functionality**
The app features four main sections:

1. **Home**: Provides an introduction and navigation guide.
2. **Enrichment Analysis**: Allows users to select a species, an enrichment type (Gene Ontology or Pathways), and specify a false discovery rate (FDR) cutoff for analysis. Upon running the analysis, the app retrieves gene information from the Ensembl database and uses the TCGA dataset to conduct functional enrichment.
3. **Protein Interaction**: Displays a protein-protein interaction network of selected genes in an interactive format, allowing users to explore gene interactions visually.
4. **Contact**: Lists contact information for support and feedback.

#### **Methods Used for Analysis**
- **Gene Information Retrieval**: The app uses the `biomaRt` package to retrieve gene symbols and corresponding Entrez IDs from Ensembl for the selected species.
- **TCGA Data Query**: Using the `TCGAbiolinks` package, the app queries the TCGA database for transcriptomic data related to specific projects (e.g., TCGA-BRCA for breast cancer).
- **Enrichment Analysis**: The `TCGAanalyze_EAcomplete()` function is used to conduct enrichment analysis, identifying overrepresented GO terms and pathways in the gene set. Results are displayed using `TCGA_EAbarplot()`.
- **Protein Interaction Network**: The app employs `visNetwork` to visualize protein-protein interactions, showcasing connections between selected genes and their functional interactions.

#### **Challenges Encountered**
- **Species Customization**: Modifying the app to work with a variety of species required mapping species data correctly, ensuring that gene annotations for species like catfish and goat were available through `biomaRt`.
- **Data Availability**: One challenge was ensuring data availability for various projects in TCGA, as some species and datasets were more commonly represented than others.
- **Performance Optimization**: Handling large datasets during gene enrichment analysis caused performance issues, requiring optimizations in data retrieval and analysis processes.
- **Visualization of Complex Data**: Displaying protein interaction networks in an intuitive and responsive way presented some challenges in ensuring the interactivity was user-friendly while also scalable for larger datasets.

#### **Conclusion**
The Functional Enrichment Analysis App provides a streamlined platform for performing gene set enrichment analysis across multiple species, with additional capabilities for visualizing protein interactions. Despite challenges related to species data and handling large datasets, the app successfully integrates TCGA data and functional annotations into a user-friendly interface for bioinformatics research.


