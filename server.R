library(shiny)
library(caret)
library(rpart)
library(rpart.plot)
library(rattle)
# Define server logic required to summarize and view the selected dataset
# loading the data file and creating the model
# load('sampleTrainingDataSubsetColumns.RData')
# inTrain <<- createDataPartition(y=sampleTrainingDataSubsetColumns$outcome, p=0.7, list=FALSE)
# validTrainDataTrain <<- sampleTrainingDataSubsetColumns[inTrain,]
# validTrainDataTest <<- sampleTrainingDataSubsetColumns[-inTrain,]
# modFitRpart <<- train(outcome~ .,data=sampleTrainingDataSubsetColumns,method="rpart")
load('modFitRpart.model')

shinyServer(
  function(input, output) {
    # This function essentially takes inputs relayed from the used and creates a data frame to predict on
    # using the model computed using the training dataset.
    f <- function(prevclsr, gender, race, appleduc, majorimp, applwork, applearn, applhour) 
      {
        if (race=="white") {
          newRow <- data.frame(prevclsr,gender,white=as.factor(1),black=as.factor(0),aian=as.factor(0),asian=as.factor(0),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)  
        } else if (race=="black") {
          newRow <- data.frame(prevclsr,gender,white=as.factor(0),black=as.factor(1),aian=as.factor(0),asian=as.factor(0),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)
        } else if (race=="aian") {
          newRow <- data.frame(prevclsr,gender,white=as.factor(0),black=as.factor(0),aian=as.factor(1),asian=as.factor(0),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)
        } else if (race=="asian") {
          newRow <- data.frame(prevclsr,gender,white=as.factor(0),black=as.factor(0),aian=as.factor(0),asian=as.factor(1),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)
        } else if (race=="nhpi") {
          newRow <- data.frame(prevclsr,gender,white=as.factor(0),black=as.factor(0),aian=as.factor(0),asian=as.factor(0),nhpi=as.factor(1),appleduc,majorimp,applwork,applearn,applhour)
        }
        
        results <- predict(modFitRpart,newdata=newRow)
        as.character(results[1])
      }
    
    # By declaring output as a reactive expression we ensure that:
    #
    #  1) It is only called when the inputs it depends on changes
    #  2) The computation and result are shared by all the callers (it 
    #     only executes a single time)
    x <- reactive(
          {
            f(input$prevclsr,input$gender,input$race,input$appleduc,input$majorimp,input$applwork,input$applearn,input$applhour)
          }
        )
    
    # The output$result is computed based on a reactive expression that
    # returns input$result When the user changes any of the input parameters field:
    #
    #  1) This expression is automatically called to recompute the output 
    #  2) The new caption is pushed back to the browser for re-display
    output$result <- renderText({x()})
    
    # This is a static display of the graph that was computed using the training data set
    output$newDecisionTree <- renderPlot({
      fancyRpartPlot(modFitRpart$finalModel)
    })
  }
)