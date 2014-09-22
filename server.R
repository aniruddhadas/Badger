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
        # This is a hack
        if(prevclsr=="3 - success") {
          prevclsr=as.factor(3)
        } else if (prevclsr=="0 - failure") {
          prevclsr=as.factor(0)
        }
        
        # This is a hack
        if(majorimp=="1 - Blindness") {
          majorimp=as.factor(1)
        } else if(majorimp=="5 - Hearing Loss, Primary Communication Visual") {
          majorimp=as.factor(5)
        } else if (majorimp=="6 - Hearing Loss, Primary Communication Auditory") {
          majorimp=as.factor(6)
        }  else {
          majorimp=as.factor(0)
        }
        
        #, "Extended Employment", 
        # this is a hack
        if(applwork=="Employment without Supports in Integrated Setting") {
          applwork = as.factor(1)
        } else if(applwork=="Extended Employment") {
          applwork = as.factor(2)
        } else if(applwork=="Self-employment (except BEP)") {
          applwork = as.factor(3)
        }
              
        #c("No formal schooling","Elementary education","Secondary education, no high school diploma",
        #"Special education certificate of completion/attendance",
        #"High school graduate or equivalency certificate","Post-secondary education, no degree",
        #"Associate degree or Vocational/Technical Certificate","Bachelors degree",
        #"Masters degree or higher"))
        if(appleduc=="No formal schooling") {
          appleduc=as.factor(0)
        } else if (appleduc=="Elementary education") {
          appleduc=as.factor(1)
        } else if (appleduc=="Secondary education, no high school diploma") {
          appleduc=as.factor(2)
        } else if (appleduc=="Special education certificate of completion/attendance") {
          appleduc=as.factor(3)
        } else if (appleduc=="Post-secondary education, no degree") {
          appleduc=as.factor(4)
        } else if (appleduc=="Associate degree or Vocational/Technical Certificate") {
          appleduc=as.factor(5)
        } else if (appleduc=="Bachelors degree") {
          appleduc=as.factor(6)
        } else if (appleduc=="Masters degree or higher") {
          appleduc=as.factor(7)
        }
        
        if(gender=="male") {
          genderfactor=as.factor(1)
        } else {
          genderfactor=as.factor(2)
        }
        
        if (race=="White") {
          newRow <- data.frame(prevclsr,gender=genderfactor,white=as.factor(1),black=as.factor(0),aian=as.factor(0),asian=as.factor(0),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)  
        } else if (race=="African American") {
          newRow <- data.frame(prevclsr,gender=genderfactor,white=as.factor(0),black=as.factor(1),aian=as.factor(0),asian=as.factor(0),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)
        } else if (race=="American Indian") {
          newRow <- data.frame(prevclsr,gender=genderfactor,white=as.factor(0),black=as.factor(0),aian=as.factor(1),asian=as.factor(0),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)
        } else if (race=="Asian") {
          newRow <- data.frame(prevclsr,gender=genderfactor,white=as.factor(0),black=as.factor(0),aian=as.factor(0),asian=as.factor(1),nhpi=as.factor(0),appleduc,majorimp,applwork,applearn,applhour)
        } else if (race=="Native Hawaiian Pacific Islander") {
          newRow <- data.frame(prevclsr,gender=genderfactor,white=as.factor(0),black=as.factor(0),aian=as.factor(0),asian=as.factor(0),nhpi=as.factor(1),appleduc,majorimp,applwork,applearn,applhour)
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
    output$result <- renderText({
        ans <- x()
        if(ans){
          str1 <- paste("<b>", "Based on the model chances are high this will be a success case.", "</b>"); 
        } else {
          str1 <- paste("<b>", "This might not be a great case to work with!", "</b>");
        }
      })
    
    # This is a static display of the graph that was computed using the training data set
    output$newDecisionTree <- renderPlot({
      fancyRpartPlot(modFitRpart$finalModel)
    })
  }
)