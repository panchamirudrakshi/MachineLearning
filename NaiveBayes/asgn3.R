#@authors: Panchami Rudrakshi, Ranjani Suresh
nb_test<-function(trainingsetdata,testingsetdata){
  train <- read.table(trainingsetdata,header = TRUE)
  test<-read.table(testingsetdata,header = TRUE)
 
  #install.packages("mice")
  library(mice)
  
  #install.packages("VIM")
  library(VIM)
  
  #install.packages("corrplot")
  library(corrplot)
  
  #install.packages("e1071",dependencies = TRUE)
  library(e1071)
  
  #Plotting
  plot_aggr <- aggr(train, col=c('blue','red'), numbers=TRUE, sortVars=TRUE, labels=names(train), cex.axis=.9, gap=1, ylab=c("Missing data","Pattern"))
  
  
  #Separation of training set and target 
  target<-train$class
  train<-subset(train, select=-class)
  train$class<-target
  
  f<-class~.
  
  testAttr_test<- test[ ,!(names(test) %in% c("class"))]
  testAttr_train<-train[ ,!(names(train) %in% c("class"))]
  testlabel<-test[,c("class")]
  trainlabel<-train[,c("class")]
  
  
  #naive Bayes
  model <- naiveBayes(as.factor(class)~., train, laplace=0, threshold=0.0001)
  pred.te <- predict(model,testAttr_test)
  pred.tr <- predict(model,testAttr_train)
  accuracytrain=(sum(pred.tr == trainlabel)/length(pred.tr))*100
  accuracytest=(sum(pred.te == testlabel)/length(pred.te))*100
  cat("Training set accuracy:",accuracytrain,"\n")
  cat("Testing set accuracy:",accuracytest,"\n")
  
  names(model)
  cat("Conditional Probabilities:","\n")
  print(model$tables)
  cat("Class Probabilites:","\n")
  
  prior <- data.frame(model$apriori)
  tab <-  data.frame(model$tables[1])
  
  noOfColumns = ncol(train);
  
  #Printing the Prior and conditional probabilities of the model
  for (i in 0:1) 
  {
    class_prob=prior[i+1,"Freq"]/(prior[1,"Freq"]+prior[2,"Freq"])
    cat("\n")
    cat(paste("P(C=", i, ") : ", class_prob,"\n"))
    for (x in 2:noOfColumns-1) 
    {
      tab_sub <-  data.frame(model$tables[x])
      colname <-names(model$tables[x])
      cat(paste("P(",colname,"=",0,"|C=", i, "): ", tab_sub[i+1,1],"\n" ))
      cat(paste("P(",colname,"=",1,"|C=", i, "): ", tab_sub[i+1,2],"\n" ))
      
    }
  }
  # Data Distribution
  hist(train$class, breaks=12, col="green") 
  
  
  #correlation plot
  M <- cor(train)
  corrplot(M, method="number")
  
}