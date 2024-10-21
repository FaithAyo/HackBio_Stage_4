# Load required libraries
library(shiny)
library(shinydashboard)
library(TCGAbiolinks)
library(DT)
library(EDASeq)



# UI Layout
ui <- dashboardPage(
  dashboardHeader(title = "Functional Enrichment Analysis App"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Enrichment Analysis", tabName = "analysis", icon = icon("bar-chart")),
      menuItem("Contact", tabName = "contact", icon = icon("envelope"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Home tab
      tabItem(tabName = "home",
              fluidPage(
                h1("Welcome to the Functional Enrichment Analysis App"),
                p("This interactive R Shiny app performs functional enrichment analysis using the TCGAanalyze_EAcomplete() and TCGAvisualize_EAbarplot() functions from the TCGAbiolinks package."),
                p("Use the sidebar to navigate through the app.")
              )
      ),
      
      # Enrichment Analysis tab
      tabItem(tabName = "analysis",
              fluidRow(
                box(
                  title = "Enrichment Parameters", status = "primary", solidHeader = TRUE, width = 3,
                  #selectInput("speciesSelect", "Select Annotated Species:", choices = species_data$scientific_name),
                  #fileInput("geneFile", "Upload Gene List (.txt)", accept = ".txt"),
                  textAreaInput("gene_list", "Paste Gene List (One per line):", rows = 8, placeholder = "Paste your gene symbols or IDs here"),
                  h4("Select Enrichment Types:"),  # Section header
                  # numericInput("fdrCutoff", "FDR Cutoff", value = 0.05, min = 0, max = 1, step = 0.01),
                  h4("Select Enrichment Types:"),  # Section header
                  checkboxGroupInput("enrichmentTypes", "Enrichment Types:",
                                     choices = list("Biological Process" = "BP", 
                                                    "Cellular Component" = "CC", 
                                                    "Molecular Function" = "MF", 
                                                    "Pathway" = "Pathway"),
                                     selected = "BP"),  # Default selected option
                  actionButton("runAnalysis", "Run Enrichment Analysis")
                ),
                box(
                  title = "Results", status = "primary", solidHeader = TRUE, width = 9,
                  DTOutput("tableResults"),
                  plotOutput("enrichmentPlot"),
                  textOutput("summary")
                )
              )
      ),
      
      # Contact tab
      tabItem(tabName = "contact",
              fluidPage(
                h2("Contact Us"),
                p("For any inquiries or feedback, please reach out via:"),
                p("Email: faithojetayo@gmail.com, obiemmanuel167@gmail.com, hala9994321@gmail.com"),
                p("Slack: @chiddo, @hala, @FaithAyo1, @HackBio Cancer Internship 2024")
              )
      )
    )
  )
)

# Server logic
server <- function(input, output) {
  observeEvent(input$runAnalysis, {
    req(input$gene_list)  # Ensure a gene list is provided
    
    # Split pasted gene list into a vector
    geneData <- strsplit(input$gene_list, "\n")[[1]]
    geneData <- trimws(geneData)  # Trim any extra spaces
    
    EA_results <- list()  # Initialize results storage
    
    # Run analyses based on selected types
    if ("BP" %in% input$enrichmentTypes) {
      EA_results$ResBP <- TCGAanalyze_EAcomplete(
        TFname = "DEA genes", 
        RegulonList = geneData  
      )$ResBP
    }
    
    # Repeat for CC, MF, Pathway...
    
    # Display the table
    output$tableResults <- renderDT({
      resultsToDisplay <- list()
      
      if ("BP" %in% input$enrichmentTypes && !is.null(EA_results$ResBP)) {
        resultsToDisplay$BP <- as.data.frame(EA_results$ResBP)
      }
      # ... Check for other enrichment types ...
      
      # Combine results into a single data frame
      combinedResults <- Reduce(function(x, y) merge(x, y, all = TRUE), resultsToDisplay)
      datatable(combinedResults)
    })
    
    # Generate and display the bar plot
    output$enrichmentPlot <- renderPlot({
      req(EA_results$ResBP)  # Ensure there are results before plotting
      TCGAvisualize_EAbarplot(
        tf = rownames(EA_results$ResBP),
        GOBPTab = EA_results$ResBP,
        # ... Include other tables ...
        nRGTab = geneData,
        nBar = 10,
        filename = NULL,
        text.size = 1.5,
        mfrow = c(1, 1),
        xlim = NULL,
        fig.width = 30,
        fig.height = 15,
        color = c("orange", "blue", "green", "red")
      )
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
