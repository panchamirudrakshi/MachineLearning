#@authors: Panchami Rudrakshi, Ranjani Suresh
install.packages("ada")
install.packages("ROCR")
library(ROCR)
library(ada)

# Read Data 
data_set<-read.csv('https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data',header = FALSE)

nrFolds <- 10
ClassCol<-as.integer(35)
#class column index
data_set[,ClassCol]<-as.numeric(data_set[,ClassCol])

Class<-data_set[,ClassCol]

# generate array containing fold-number for each row
folds <- rep_len(1:nrFolds, nrow(data_set))

# actual cross validation
for(k in 1:nrFolds) {
  # actual split of the data
  fold <- which(folds == k)
  data.train <- data_set[-fold,]
  ClassName<- names(data.train[ClassCol])
  f <- as.formula(paste(ClassName," ~."))
  data.test <- data_set[fold,]
  class_value<-data.test[,ClassCol]
  
  # train and test your model with data.train and data.test
  model <- ada(f,data.train, iter=25) 
  pred<-predict(model,data.test) 
  data<-data.frame('predict'=pred, 'actual'=class_value)
  count<-nrow(data[data$predict==data$actual,])
  total<-nrow(data.test)
  average = (count*100)/total
  average =format(round(average, 2), nsmall = 2)
  cat("Accuracy = ", average,"\n")
}

#plotting ROC for Adaboost
ada_prediction <- prediction(class_value,pred)
ada_performance <- performance(ada_prediction, "tpr", "fpr")
plot(ada_performance, colorize=T, main="ROC for Adaboost")
abline(0,1)

