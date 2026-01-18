# ---------------------------------------------------------
# PROJECT: Predictive Modeling for Breast Cancer Diagnostics
# AUTHOR:  Collins Amoo
# ---------------------------------------------------------

# METHODOLOGY OVERVIEW:
# I employed the CART (Classification and Regression Trees) algorithm, 
# which is the R implementation equivalent to the J48 algorithm.

# Install/load packages
if (!require(pacman)) install.packages("pacman")
pacman::p_load(
  mlbench, dplyr, tidymodels, rpart, rpart.plot, caret,
  visdat, shiny
)

# 1) LOAD + CLEAN DATA
data("BreastCancer", package = "mlbench")
cancer_data <- BreastCancer[, -1] # drop ID column
cancer_data[cancer_data == "?"] <- NA
cancer_data <- na.omit(cancer_data)

cancer_data <- cancer_data %>%
  mutate(across(-Class, ~ as.integer(as.character(.))),
         Class = factor(Class))

# -------------------------
# 2) DATA SPLITTING (Methodology)
# Partitioned into 80% training and 20% test sets using stratified sampling.
# -------------------------
set.seed(123)
cancer_split <- initial_split(cancer_data, prop = 0.8, strata = Class)
train_cancer <- training(cancer_split)
test_cancer  <- testing(cancer_split)

# -------------------------
# 3) MODEL TRAINING
# The model was trained using Gini Impurity to determine optimal splits.
# -------------------------
cancer_model <- rpart(
  Class ~ .,
  data = as.data.frame(train_cancer),
  method = "class"
)

# ---------------------------------------------------------
# 4) MODEL EVALUATION (CONFUSION MATRIX)
# This section evaluates the model's real-world applicability 
# and checks for critical False Negatives.
# ---------------------------------------------------------
predictions <- predict(cancer_model, newdata = test_cancer, type = "class")
conf_matrix <- confusionMatrix(predictions, test_cancer$Class)

# Print the Evaluation to the Console
print(conf_matrix)

# -------------------------
# 5) DEPLOYMENT: THE SHINY ASSISTANT
# -------------------------
ui <- fluidPage(
  titlePanel("Breast Cancer Diagnostic Tool (Decision Tree)"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Input clinical descriptors to generate prediction:"),
      sliderInput("clump", "Clump Thickness", min = 1, max = 10, value = 5),
      sliderInput("size",  "Cell Size",       min = 1, max = 10, value = 5),
      sliderInput("shape", "Cell Shape",      min = 1, max = 10, value = 5),
      
      tags$hr(),
      
      sliderInput("marg",  "Marginal Adhesion", min = 1, max = 10, value = 1),
      sliderInput("epith", "Epithelial Cell Size", min = 1, max = 10, value = 1),
      sliderInput("bare",  "Bare Nuclei", min = 1, max = 10, value = 1),
      sliderInput("chrom", "Bl Chromatin", min = 1, max = 10, value = 1),
      sliderInput("norm",  "Normal Nucleoli", min = 1, max = 10, value = 1),
      sliderInput("mit",   "Mitoses", min = 1, max = 10, value = 1),
      
      actionButton("predict", "Predict", class = "btn-primary")
    ),
    
    mainPanel(
      h3("Diagnostic Result"),
      textOutput("prediction_text"),
      tags$hr(),
      h4("Model Visualization (Clinical Logic)"),
      plotOutput("tree_plot", height = "550px")
    )
  )
)

server <- function(input, output) {
  
  output$tree_plot <- renderPlot({
    rpart.plot(cancer_model, main = "Tumor Classification Logic", box.palette = "BuGn")
  })
  
  observeEvent(input$predict, {
    new_patient <- data.frame(
      Cl.thickness    = as.integer(input$clump),
      Cell.size       = as.integer(input$size),
      Cell.shape      = as.integer(input$shape),
      Marg.adhesion   = as.integer(input$marg),
      Epith.c.size    = as.integer(input$epith),
      Bare.nuclei     = as.integer(input$bare),
      Bl.cromatin     = as.integer(input$chrom),
      Normal.nucleoli = as.integer(input$norm),
      Mitoses         = as.integer(input$mit)
    )
    
    pred_class <- predict(cancer_model, newdata = new_patient, type = "class")
    pred_prob  <- predict(cancer_model, newdata = new_patient, type = "prob")
    
    output$prediction_text <- renderText({
      cls <- as.character(pred_class)
      pmax <- round(max(pred_prob[1, ]), 3)
      paste0("The model classifies this sample as: ", cls, " (Confidence: ", pmax * 100, "%)")
    })
  })
}

shinyApp(ui = ui, server = server)