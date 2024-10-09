# Load required libraries
library(shiny)
library(shinydashboard)
library(TCGAbiolinks)
library(biomaRt)
library(visNetwork)
library(DT)
library(ggplot2)
library(plotly)

# Define species data
species_data <- data.frame(
  id = 1:4,
  scientific_name = c("Homo sapiens", "Bos taurus", "Capra hircus", "Clarias gariepinus"),
  common_name = c("Human", "Cow", "Goat", "Catfish"),
  ncbi_taxonomy_id = c("9606", "9913", "9925", "7955"),
  stringsAsFactors = FALSE
)

# UI Layout
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
      
      # Home tab
      tabItem(tabName = "home",
              fluidPage(
                h1("Welcome to the Functional Enrichment Analysis App"),
                p("This interactive R Shiny app is designed to perform functional enrichment analysis using the TCGAanalyze_EAcomplete() and TCGA_EAbarplot() functions from the TCGAbiolinks package in R. We hope you have a great experience."),
                p("Use the sidebar to navigate through the app.")
              )
      ),
      
      # Enrichment Analysis tab
      tabItem(tabName = "analysis",
              fluidRow(
                box(
                  title = "Enrichment Parameters", status = "primary", solidHeader = TRUE, width = 3,
                  selectInput("speciesSelect", "Select Annotated Species:", choices = species_data$scientific_name),
                  selectInput("enrichmentType", "Select Enrichment Type:", choices = c("Gene Ontology", "Pathways")),
                  numericInput("fdrCutoff", "FDR Cutoff", value = 0.05, min = 0, max = 1, step = 0.01),
                  actionButton("runAnalysis", "Run Enrichment Analysis")
                ),
                box(
                  title = "Results", status = "primary", solidHeader = TRUE, width = 9,
                  plotOutput("plotResults"),
                  DTOutput("geneInfo")
                )
              )
      ),
      
      # Protein Interaction tab
      tabItem(tabName = "interaction",
              fluidRow(
                box(
                  title = "Protein Interaction Network", status = "primary", solidHeader = TRUE, width = 12,
                  visNetworkOutput("proteinNetwork")
                )
              )
      ),
      
      # Contact tab
      tabItem(tabName = "contact",
              fluidPage(
                h2("Contact Us"),
                p("For any inquiries or feedback regarding the app, please reach out via:"),
                p("Email: faithojetayo@gmail.com, obiemmanuel167@gmail.com, hala9994321@gmail.com"),
                p("Slack: @chiddo, @hala, @FaithAyo1, @HackBio Cancer Internship 2024")
              )
      )
    )
  )
)

# The Server
server <- function(input, output, session) {
  
  # Gene sets
  geneSets <- list(
    "Example Gene List" = c("TP53", "BRCA1", "EGFR", "MYC", "KRAS", "PTEN"),
    "Another Gene List" = c("CDK2", "CCND1", "GATA3", "CDH1", "MTOR", "RB1")
  )
  
  # Reactive gene list
  geneList <- reactive({
    geneSets[["Example Gene List"]]
  })
  
  # Enrichment Analysis
  output$plotResults <- renderPlot({
    req(input$runAnalysis)
    mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
    gene_info <- getBM(attributes = c('hgnc_symbol', 'entrezgene_id'),
                       filters = 'hgnc_symbol',
                       values = geneList(),
                       mart = mart)
    
    entrez_ids <- gene_info$entrezgene_id
    
    query <- GDCquery(project = "TCGA-BRCA", 
                      data.category = "Transcriptome Profiling", 
                      experimental.strategy = "RNA-Seq", 
                      access = "open", 
                      workflow.type = "STAR - Counts")
    
    GDCdownload(query)
    data <- GDCprepare(query)
    
    results <- TCGAanalyze_EAcomplete(data = data, gene.list = entrez_ids, pvalueCutoff = input$fdrCutoff)
    TCGA_EAbarplot(results, showCategory = 10)
  })
  
  # Protein Interaction Network
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
}

# Run the application 
shinyApp(ui = ui, server = server)
