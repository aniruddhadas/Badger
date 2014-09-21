library(shiny)

# Define UI for dataset viewer application
shinyUI(
  pageWithSidebar(
  
    # Application title
    headerPanel("Case Success Determiner!"),
    
    # Sidebar with controls to provide a caption, 
    # select a previous closure
    # 
    sidebarPanel(
      selectInput("prevclsr", "Choose previous closure:", 
                  choices = c(0:8)),
      
      selectInput("gender", "Choose gender:", 
                  choices = c(1:2)),
      
      selectInput("race", "Choose race:", 
                  choices = c("white", "black", "aian", "asian", "nhpi")),
      
      selectInput("appleduc", "Education status at time of application:", 
                  choices = c(0:8)),
      
      selectInput("majorimp", "Choose a major impairment:", 
                  choices = c(0:19)),
      
      selectInput("applwork", "Choose work type at time of application:", 
                  choices = c(1, 2, 3, 5, 6, 7, 8, 9, 10, 11)),
      
      numericInput("applearn", "How much earned at time of application?", 0, min = 0, max = 5000),
      
      numericInput("applhour", "How many hours working at the time of application?", 0, min = 0, max = 100)
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