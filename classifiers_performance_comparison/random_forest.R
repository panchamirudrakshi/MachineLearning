#@authors: Panchami Rudrakshi, Ranjani Suresh
install.packages("randomForest")
install.packages("ggplot2")
install.packages("gplots")
install.packages("ROCR")
library(randomForest)
library(ROCR)

#read data
data_set<-read.csv('http://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data',header = FALSE)

ClassCol<-as.integer(35) 
#class column index
data_set[,ClassCol]<-as.numeric(data_set[,ClassCol])

nrFolds <- 10
data_set[,35]<-as.numeric(data_set[,35])

# generate array containing fold-number for each row
folds <- rep_len(1:nrFolds, nrow(data_set))

for(k in 1:nrFolds) {
  # actual split of the data
  fold <- which(folds == k)
  data.train <- data_set[-fold,]
  data.test <- data_set[fold,]
  
  Class<-data.train[,35]
  class_value<-data.test[,35]
  ClassName<- names(data.train[ClassCol])
  f <- as.formula(paste(ClassName," ~."))
  class_value<-data.test[,ClassCol]
  
  # accuracy values :
  model <- randomForest(formula=f,data=data.train,ntree=100,mtry=10, 
                        keep.forest=TRUE, importance=TRUE,test=class_value) #function
  pred<-predict(model,data.test,type="class")
  pred<-round(pred)
  data<-data.frame('predict'=pred, 'actual'=class_value)
  count<-nrow(data[data$predict==data$actual,])
  total<-nrow(data.test)
  avg = (count*100)/total
  avg =format(round(avg, 2), nsmall = 2)
  cat("Accuracy = ", avg,"\n")
  
}

#plotting ROC for Random forest
rf_prediction <- prediction(class_value,pred)
rf_performance <- performance(rf_prediction, "tpr", "fpr")
plot(rf_performance, colorize=T, main="ROC for Random Forest")
abline(0,1)