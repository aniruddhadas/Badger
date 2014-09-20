#reading in data
load('rsa911_02to12.RData')
head(rsa911, n = 7)
str(rsa911)
#rsa911$outcome <- (rsa911$clsrtype == 3)
library(caret)
sampleTestData <- createDataPartition(y=rsa911$clsrtype, p=0.001, list=FALSE)
sampleTrainingData <- rsa911[sampleTestData,]
dim(sampleTrainingData)
sampleTrainingData$outcome <- (sampleTrainingData$clsrtype == 3)
dim(sampleTrainingData)
sampleTrainingData$clsrtype <- NULL

head(sampleTrainingData$outcome)
str(sampleTrainingData)

sampleTrainingDataSubsetColumns <- sampleTrainingData[c("prevclsr", "gender", "white", "black", "aian", "asian", "nhpi", "appleduc", "majorimp", "applwork", "applearn", "applhour", "outcome")]
#sampleTrainingDataSubsetColumns[,1:8] = as.factor(sampleTrainingDataSubsetColumns[,1:8]) 
# a <- lapply(sampleTrainingDataSubsetColumns[1:10], as.factor)
# a$applearn <- sampleTrainingDataSubsetColumns$applearn
# a$applhour <- sampleTrainingDataSubsetColumns$applhour
# a$outcome <- sampleTrainingDataSubsetColumns$outcome
# 

factorCols <- c("prevclsr","gender","white","black","aian","asian","nhpi","appleduc","majorimp","applwork")

sampleTrainingDataSubsetColumns[,factorCols]<- data.frame(apply(sampleTrainingDataSubsetColumns[factorCols], 2, as.factor))
str(sampleTrainingDataSubsetColumns)
sampleTrainingDataSubsetColumns$outcome <- as.factor(sampleTrainingDataSubsetColumns$outcome)
sampleTrainingDataSubsetColumns <- na.omit(sampleTrainingDataSubsetColumns)
save(sampleTrainingDataSubsetColumns, file="sampleTrainingDataSubsetColumns.RData")

library(caret)
inTrain <- createDataPartition(y=sampleTrainingDataSubsetColumns$outcome, p=0.7, list=FALSE)
validTrainDataTrain <- sampleTrainingDataSubsetColumns[inTrain,]
validTrainDataTest <- sampleTrainingDataSubsetColumns[-inTrain,]

library(randomForest)
#validTrainDataTrain[,-13]
modFitRf <- train(outcome~ .,data=sampleTrainingDataSubsetColumns,method="rf",prox=TRUE)
modFitRpart <- train(outcome~ .,data=sampleTrainingDataSubsetColumns,method="rpart")

#plot(modFit$finalModel, uniform=TRUE, main="Classification Tree")

library(rattle)
fancyRpartPlot(modFitRpart$finalModel)

predict(modFitRpart,newdata=validTrainDataTest)


