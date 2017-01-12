# install.packages("neuralnet", dependencies = TRUE)
require(neuralnet)
require(data.table)
require(plyr)       # this is used to illustrate a progress bar
# loading the dataset
hdTrain<-data.table::fread("trainingFeatures-all.csv",header=TRUE) 
tt <- data.frame(hdTrain)
# observing the dataset
summary (tt)
# fixing NA values in X4
tt$X4[is.na(tt$X4)] = 0
summary (tt)
# removing instances with all features = 0 and Relevance != 1 (irrelavant)
# this has to be improved, only the ones with all features = 0 and Relevance != 1 shall be removed
# i need the ML to learn to assign Relevance = 1 in case all features end up being equal to 0
inconsistentList<-which(tt$X1 == 0 & tt$Relevance != 1)
tt<-tt[-inconsistentList,]

# scaling / normalizing the dataset, the only feature which need be centered is the X1
# other features are normalized by definition and Relevance shall not be normalized since
# in this regression problem we want to work with relevance in range of one to three

maxX1 = max(tt$X1)
minX1 = min(tt$X1)
newX1 <- (tt$X1 - minX1)/(maxX1 - minX1)
summary(newX1)
myData = tt
myData[,1] = newX1
summary(myData)

# Cross Validation k-fold with k = 5
set.seed(27)
k = 5
n = nrow(myData)
randomIndices = sample(n, n, replace = FALSE)
testIndices <- function(iteration)
{
  return (randomIndices[(1+(iteration-1)*n/k):(iteration*n/k)])
}

myRMSE = NULL

pbar <- create_progress_bar('text')
pbar$init(k)

for (iteration in c(1:k)){
  testData = myData[testIndices(iteration),]
  trainData = myData[-testIndices(iteration),]
  myModel <- neuralnet(Relevance ~ X1+X2+X3+X4 , data = trainData, hidden = 2,
                       linear.output = TRUE, algorithm = "rprop+", stepmax = 1e8,
                       threshold = 0.01)
  myPred = compute(myModel, testData[,1:4])
  myRMSE[iteration] <- sqrt(mean(testData$Relevance - myPred$net.result)^2)
  pbar$step()
}
cat(paste("Average Root Mean Squared Error on ", k,"-Fold CV: ", mean(myRMSE), sep=""))
cat("\n\n\n RMSE of each iteration: ")
print(myRMSE);

plot(myModel)
###Results 
# Average Root Mean Squared Error on 5-Fold CV: 0.00814682654187679
# RMSE of each iteration:
# [1] 0.0098348079515 0.0013240595257 0.0006317040866 0.0090597745138 0.0198837866317
###################

