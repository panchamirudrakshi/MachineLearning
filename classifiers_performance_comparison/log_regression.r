#@authors: Panchami Rudrakshi, Ranjani Suresh
install.packages("stats")
install.packages("ROCR")
library(stats)
library(ROCR)

# Read Data 
data_set<-read.csv('https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data',header = FALSE)

nrFolds <- 10
ClassCol<-as.integer(35) #class column index
data_set[,ClassCol]<-as.numeric(data_set[,ClassCol])

for(i in 1:nrow(data_set))
{
  if(data_set[i,ClassCol]==1)
  {
    data_set[i,ClassCol]<-0
  }
  else
  {  
    data_set[i,ClassCol]<-1
  }
}

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
  model <- glm(f,family=binomial,data.train) 
  pred<- predict.glm(model,data.test,type="response")
  pred<-round(pred,digits=0)
  data<-data.frame('predict'=pred, 'actual'=class_value)
  count<-nrow(data[data$predict==data$actual,])
  total<-nrow(data.test)
  average = (count*100)/total
  average =format(round(average, 2), nsmall = 2)
  cat("Accuracy = ", average,"\n")
}

#plotting ROC for Logistic Regression
lr_prediction <- prediction(class_value,pred)
lr_performance <- performance(lr_prediction, "tpr", "fpr")
plot(lr_performance, colorize=T, main="ROC for Logistic Regression")
abline(0,1)
