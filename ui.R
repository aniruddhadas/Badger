library(shiny)

# Define UI for dataset viewer application
shinyUI(
  pageWithSidebar(
  
    # Application title
    headerPanel("Case Success Determiner for Vocational Rehabilitation (VR)!"),
    
    # Sidebar with controls to provide a caption, 
    # select a previous closure
    sidebarPanel(
      selectInput("prevclsr", "Choose previous closure (prevclsr):", 
                  choices = c("success", "failure")),
      # select a gender  
      selectInput("gender", "Choose gender:", 
                  choices = c("male", "female")),
      
      # select a race
      selectInput("race", "Choose race (white, black, aian, asian, nhpi):", 
                  choices = c("White", "African American", "American Indian", "Asian", "Native Hawaiian Pacific Islander")),
      
      # select a education status
      selectInput("appleduc", "Education status at time of application (appleduc):", 
                  choices = c("No formal schooling","Elementary education","Secondary education, no high school diploma","Special education certificate of completion/attendance","High school graduate or equivalency certificate","Post-secondary education, no degree","Associate degree or Vocational/Technical Certificate","Bachelors degree","Masters degree or higher")),
      
      # select major impairment
      selectInput("majorimp", "Choose a major impairment (majorimp):", 
                  choices = c("Blindness", "Hearing Loss, Primary Communication Visual", "Hearing Loss, Primary Communication Auditory", "Other")),
      
      # select application status at work
      selectInput("applwork", "Choose work type at time of application (applwork):", 
                  choices = c("Employment without Supports in Integrated Setting", "Extended Employment", "Self-employment (except BEP)")),
      
      # select earn at application
      numericInput("applearn", "How much the client is earning at time of application $/hour (applearn)?", 0, min = 0, max = 5000),
      
      # select working hours at application
      numericInput("applhour", "How many hours working at the time of application (applhour)?", 0, min = 0, max = 100)
    ),
  
  
    # Show the caption, a summary of the dataset and an HTML table with
    # the requested number of observations
    mainPanel(
      h3('Case Success Result:'),
      htmlOutput('result'),
      p('Hint: Try changing "How much the client is earning at time of application $/hour (applearn)?" to 500. 500 means that the applicant was earning $500/hour before starting with the application, if so there is a high chance he will be gainfully employed at the end of the process.'),
      
      plotOutput('newDecisionTree'),
      br(),
      h3('References'),
      p('[1]Presentation: http://rpubs.com/aniruddhadas/badger'),
      p('[2]More Details: https://www2.ed.gov/policy/speced/guid/rsa/pd-04-04.pdf')
    )
  )
)