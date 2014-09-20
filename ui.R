library(shiny)

# Define UI for dataset viewer application
shinyUI(
  pageWithSidebar(
  
    # Application title
    headerPanel("Case Success Determiner!"),
  
    # Sidebar with controls to provide a caption, select a dataset, and 
    # specify the number of observations to view. Note that changes made
    # to the caption in the textInput control are updated in the output
    # area immediately as you type
    sidebarPanel(
      selectInput("prevclsr", "Choose a prevclsr:", 
                  choices = c(0:8)),
      
      selectInput("gender", "Choose a gender:", 
                  choices = c(1:2)),
      
      selectInput("race", "Choose a race:", 
                  choices = c("white", "black", "aian", "asian", "nhpi")),
      
      selectInput("appleduc", "Choose a appleduc:", 
                  choices = c(0:8)),
      
      selectInput("majorimp", "Choose a majorimp:", 
                  choices = c(0:19)),
      
      selectInput("applwork", "Choose a applwork:", 
                  choices = c(1, 2, 3, 5, 6, 7, 8, 9, 10, 11)),
      
      numericInput("applearn", "applearn", 0, min = 0, max = 5000),
      
      numericInput("applhour", "applhour", 0, min = 0, max = 100)
    ),
  
  
    # Show the caption, a summary of the dataset and an HTML table with
    # the requested number of observations
    mainPanel(
      plotOutput('newDecisionTree'),
      
  #     verbatimTextOutput("summary"), 
  #     
  #     tableOutput("view"),
      p('Case Success Result:'),
      textOutput('result')
  #     p('Case Success'),
  #     textOutput('text2'),
      
      #plotOutput('newHist')
    )
  )
)