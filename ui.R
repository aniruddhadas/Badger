library(shiny)

# Define UI for dataset viewer application
shinyUI(
  pageWithSidebar(
  
    # Application title
    headerPanel("Case Success Determiner for Vocational Rehabilitation!"),
    
    # Sidebar with controls to provide a caption, 
    # select a previous closure
    sidebarPanel(
      selectInput("prevclsr", "Choose previous closure:", 
                  choices = c(0:7)),
      # select a gender  
      selectInput("gender", "Choose gender:", 
                  choices = c("male", "female")),
      
      # select a race
      selectInput("race", "Choose race:", 
                  choices = c("White", "African American", "American Indian", "Asian", "Native Hawaiian Pacific Islander")),
      
      # select a education status
      selectInput("appleduc", "Education status at time of application:", 
                  choices = c(0:8)),
      
      # select major impairment
      selectInput("majorimp", "Choose a major impairment:", 
                  choices = c(0:19)),
      
      # select application status at work
      selectInput("applwork", "Choose work type at time of application:", 
                  choices = c(1, 2, 3, 5, 6, 7, 8, 9, 10, 11)),
      
      # select earn at application
      numericInput("applearn", "How much earned at time of application?", 0, min = 0, max = 5000),
      
      # select working hours at application
      numericInput("applhour", "How many hours working at the time of application?", 0, min = 0, max = 100)
    ),
  
  
    # Show the caption, a summary of the dataset and an HTML table with
    # the requested number of observations
    mainPanel(
      plotOutput('newDecisionTree'),
      
      h3('Case Success Result:'),
      htmlOutput('result'),
      
      p('Hint: Try changing "How much earned at time of application?" to 500')
    )
  )
)