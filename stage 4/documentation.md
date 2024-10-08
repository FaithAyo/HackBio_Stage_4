Here’s a detailed documentation report for your R Shiny Functional Enrichment Analysis App, explaining each part of the code.

---

# **Functional Enrichment Analysis App Documentation**

### **Overview**
This R Shiny app is designed to perform functional enrichment analysis using the `TCGAanalyze_EAcomplete()` and `TCGA_EAbarplot()` functions from the TCGAbiolinks package. The app also includes features for visualizing protein interaction networks and a user-friendly interface for selecting species and performing analyses.

---

## **Code Breakdown**

### 1. **Loading Required Libraries**
```r
library(shiny)
library(shinydashboard)
library(TCGAbiolinks)
library(biomaRt)
library(visNetwork)
library(DT)
library(ggplot2)
library(plotly)
```
- **shiny**: Provides the framework for building web applications.
- **shinydashboard**: Adds UI components like sidebars, tabs, and dashboards to the Shiny app.
- **TCGAbiolinks**: Enables access to The Cancer Genome Atlas (TCGA) data for RNA-seq analysis and functional enrichment.
- **biomaRt**: Facilitates querying biological databases like Ensembl for retrieving gene data.
- **visNetwork**: Creates interactive network visualizations, which we use for protein interaction networks.
- **DT**: Displays data tables interactively.
- **ggplot2** and **plotly**: Used to generate and interact with plots and visualizations.

---

### 2. **Species Data Definition**
```r
species_data <- data.frame(
  id = 1:4,
  scientific_name = c("Homo sapiens", "Bos taurus", "Capra hircus", "Clarias gariepinus"),
  common_name = c("Human", "Cow", "Goat", "Catfish"),
  ncbi_taxonomy_id = c("9606", "9913", "9925", "7955"),
  stringsAsFactors = FALSE
)
```
Defines the species available for enrichment analysis, storing their scientific names, common names, and NCBI taxonomy IDs in a data frame.

---

### 3. **UI Layout**
#### 3.1. **Dashboard Structure**
```r
ui <- dashboardPage(
  dashboardHeader(title = "Functional Enrichment Analysis App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Enrichment Analysis", tabName = "analysis", icon = icon("bar-chart")),
      menuItem("Protein Interaction", tabName = "interaction", icon = icon("connectdevelop")),
      menuItem("Contact", tabName = "contact", icon = icon("envelope"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home", ... ),
      tabItem(tabName = "analysis", ... ),
      tabItem(tabName = "interaction", ... ),
      tabItem(tabName = "contact", ... )
    )
  )
)
```
- **dashboardHeader()**: Sets the title of the application at the top.
- **dashboardSidebar()**: Provides the sidebar for navigation, with four main sections:
  - Home
  - Enrichment Analysis
  - Protein Interaction
  - Contact
- **dashboardBody()**: Defines the content of each tab within the app using `tabItems()`.

#### 3.2. **Home Tab**
```r
tabItem(tabName = "home",
  fluidPage(
    h1("Welcome to the Functional Enrichment Analysis App"),
    p("This interactive R Shiny app is designed to perform ..."),
    p("Use the sidebar to navigate through the app.")
  )
)
```
Displays a welcome message and brief instructions on using the app.

#### 3.3. **Enrichment Analysis Tab**
```r
tabItem(tabName = "analysis",
  fluidRow(
    box(
      title = "Enrichment Parameters", ..., 
      selectInput("speciesSelect", "Select Annotated Species:", choices = species_data$scientific_name),
      selectInput("enrichmentType", "Select Enrichment Type:", choices = c("Gene Ontology", "Pathways")),
      numericInput("fdrCutoff", "FDR Cutoff", value = 0.05, min = 0, max = 1, step = 0.01),
      actionButton("runAnalysis", "Run Enrichment Analysis")
    ),
    box(
      title = "Results", ..., 
      plotOutput("plotResults"),
      DTOutput("geneInfo")
    )
  )
)
```
- **selectInput()**: Allows the user to choose a species for enrichment analysis from the list defined earlier.
- **numericInput()**: Allows the user to set an FDR (False Discovery Rate) cutoff for filtering results.
- **actionButton()**: Triggers the enrichment analysis when clicked.
- **plotOutput()**: Displays the results of the enrichment analysis as a plot.
- **DTOutput()**: Shows gene information in an interactive table.

#### 3.4. **Protein Interaction Tab**
```r
tabItem(tabName = "interaction",
  fluidRow(
    box(
      title = "Protein Interaction Network", ..., 
      visNetworkOutput("proteinNetwork")
    )
  )
)
```
Displays an interactive protein-protein interaction network using **visNetworkOutput()**.

#### 3.5. **Contact Tab**
```r
tabItem(tabName = "contact",
  fluidPage(
    h2("Contact Us"),
    p("For any inquiries ..."),
    p("Email: ..."),
    p("Slack: ...")
  )
)
```
Displays contact details for users to reach out for feedback or inquiries.

---

### 4. **Server Logic**
#### 4.1. **Defining Gene Sets**
```r
geneSets <- list(
  "Example Gene List" = c("TP53", "BRCA1", "EGFR", "MYC", "KRAS", "PTEN"),
  "Another Gene List" = c("CDK2", "CCND1", "GATA3", "CDH1", "MTOR", "RB1")
)
```
Defines example gene sets for enrichment analysis.

#### 4.2. **Reactive Gene List**
```r
geneList <- reactive({
  geneSets[["Example Gene List"]]
})
```
- **reactive()**: Generates a reactive gene list from the predefined sets.

#### 4.3. **Enrichment Analysis**
```r
output$plotResults <- renderPlot({
  req(input$runAnalysis)
  mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  gene_info <- getBM(attributes = c('hgnc_symbol', 'entrezgene_id'),
                     filters = 'hgnc_symbol', values = geneList(), mart = mart)
  
  entrez_ids <- gene_info$entrezgene_id
  query <- GDCquery(project = "TCGA-BRCA", ...)
  GDCdownload(query)
  data <- GDCprepare(query)
  
  results <- TCGAanalyze_EAcomplete(data = data, gene.list = entrez_ids, pvalueCutoff = input$fdrCutoff)
  TCGA_EAbarplot(results, showCategory = 10)
})
```
- **renderPlot()**: Creates a plot for the enrichment analysis.
- **req()**: Ensures that the analysis only runs after the user clicks the "Run Enrichment Analysis" button.
- **useMart()** and **getBM()**: Retrieve gene information from Ensembl.
- **TCGAanalyze_EAcomplete()** and **TCGA_EAbarplot()**: Perform enrichment analysis and plot the results.

#### 4.4. **Protein Interaction Network**
```r
output$proteinNetwork <- renderVisNetwork({
  edges <- data.frame(from = c("BRCA1", "KRAS", "EGFR"), to = c("TP53", "MYC", "PTEN"), value = c(1, 1, 1))
  nodes <- data.frame(id = c("BRCA1", "KRAS", "EGFR", "TP53", "MYC", "PTEN"),
                      label = c("BRCA1", "KRAS", "EGFR", "TP53", "MYC", "PTEN"),
                      group = c(1, 1, 1, 2, 2, 2),
                      value = c(10, 20, 30, 40, 50, 60))
  
  visNetwork(nodes, edges) %>%
    visEdges(arrows = 'to') %>%
    visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)
})
```
Creates an interactive protein-protein interaction network using **visNetwork()**. Nodes represent proteins, while edges represent interactions between them.

---

### 5. **Running the Application**
```r
shinyApp(ui = ui, server = server)
```
This command launches the app with the defined **UI** and **server** components.

---

This documentation outlines the purpose and functionality of each component in your Shiny app. Let me know if you need further adjustments!
