#@authors: Panchami Rudrakshi, Ranjani Suresh
install.packages("class")
install.packages("ROCR")
library(ROCR)
library(class)

# Read Data 
data_set<-read.csv('https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data',header = FALSE)

nrFolds <- 10
data_set[,35]<-as.numeric(data_set[,35])

# generate array containing fold-number for each row
folds <- rep_len(1:nrFolds, nrow(data_set))

# actual cross validation
for(k in 1:nrFolds) {
  # actual split of the data
  fold <- which(folds == k)
  data.train <- data_set[-fold,]
  data.test <- data_set[fold,]
  
  Class<-data.train[,35]
  
  class_value<-data.test[,35]
  
  # train and test model with data.train and data.test
  pred<-knn(data.train, data.test, Class, k = 9, l = 0, prob = FALSE, use.all = TRUE)
  data<-data.frame('predict'=pred, 'actual'=class_value)
  count<-nrow(data[data$predict==data$actual,])
  total<-nrow(data.test)
  average = (count*100)/total
  average =format(round(average, 2), nsmall = 2)
  cat("Accuracy = ", average,"\n")
}

#plotting ROC for KNN
knn_prediction <- prediction(class_value,pred)
knn_performance <- performance(knn_prediction, "tpr", "fpr")
plot(knn_performance, colorize=T, main="ROC for KNN")
abline(0,1)
