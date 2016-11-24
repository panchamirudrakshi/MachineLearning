#@authors: Panchami rudrakshi, Ranjani sureshinstall
install.packages("rpart", dependencies = TRUE)
install.packages("rJava", dependencies = TRUE)
install.packages("neuralnet", dependencies=TRUE)
install.packages("party",dependencies = TRUE)
install.packages("e1071",dependencies = TRUE)
install.packages("plyr",dependencies = TRUE)
install.packages("corrplot", dependencies = TRUE)

library(party)
library(neuralnet)
library(e1071)
library(rpart)
#library(xlsx)
library(neuralnet)
library(plyr)
library(corrplot)

fileConn<-"output.txt"
inputConn<-file.choose()

mydata <- read.csv(inputConn,header = FALSE)
mydata<-Filter(function(x) sd(x) != 0, mydata)

colnames(mydata)[colnames(mydata)=="V3"] <- "V2"
colnames(mydata)[colnames(mydata)=="V4"] <- "V3"
colnames(mydata)[colnames(mydata)=="V5"] <- "V4"
colnames(mydata)[colnames(mydata)=="V6"] <- "V5"
colnames(mydata)[colnames(mydata)=="V7"] <- "V6"
colnames(mydata)[colnames(mydata)=="V8"] <- "V7"
colnames(mydata)[colnames(mydata)=="V9"] <- "V8"
colnames(mydata)[colnames(mydata)=="V10"] <- "V9"
colnames(mydata)[colnames(mydata)=="V11"] <- "V10"
colnames(mydata)[colnames(mydata)=="V12"] <- "V11"
colnames(mydata)[colnames(mydata)=="V13"] <- "V12"
colnames(mydata)[colnames(mydata)=="V14"] <- "V13"
colnames(mydata)[colnames(mydata)=="V15"] <- "V14"
colnames(mydata)[colnames(mydata)=="V16"] <- "V15"
colnames(mydata)[colnames(mydata)=="V17"] <- "V16"
colnames(mydata)[colnames(mydata)=="V18"] <- "V17"
colnames(mydata)[colnames(mydata)=="V19"] <- "V18"
colnames(mydata)[colnames(mydata)=="V20"] <- "V19"
colnames(mydata)[colnames(mydata)=="V21"] <- "V20"
colnames(mydata)[colnames(mydata)=="V22"] <- "V21"
colnames(mydata)[colnames(mydata)=="V23"] <- "V22"
colnames(mydata)[colnames(mydata)=="V24"] <- "V23"
colnames(mydata)[colnames(mydata)=="V25"] <- "V24"
colnames(mydata)[colnames(mydata)=="V26"] <- "V25"
colnames(mydata)[colnames(mydata)=="V27"] <- "V26"
colnames(mydata)[colnames(mydata)=="V28"] <- "V27"
colnames(mydata)[colnames(mydata)=="V29"] <- "V28"
colnames(mydata)[colnames(mydata)=="V30"] <- "V29"
colnames(mydata)[colnames(mydata)=="V31"] <- "V30"
colnames(mydata)[colnames(mydata)=="V32"] <- "V31"
colnames(mydata)[colnames(mydata)=="V33"] <- "V32"
colnames(mydata)[colnames(mydata)=="V34"] <- "V33"
colnames(mydata)[colnames(mydata)=="V35"] <- "V34"

colnames(mydata)[colnames(mydata)=="V34"] <- "myclass"
mydata$myclass <- mapvalues(mydata$myclass,from = c("b","g"),to = c(0,1))
str(mydata)


#data_matrix<-mydata[1:33]
#data_matrix
#scale_data<-scale(data_matrix,center=TRUE,scale=FALSE)
#scale_data
#to do add 53th col to scale_data



  
for(i in 1:5) {
cat(c("expreriment",as.numeric(i),":","\n"),file=fileConn,append=TRUE,sep=" ")
  
#sampling the data into test and train sets
indexes <- sample(1:nrow(mydata), size=0.8*nrow(mydata))
train <- mydata[indexes,]
test <- mydata[-indexes,]


#DECISION TREE
model <- ctree(myclass ~ ., data=train)
result <- predict(model, test)
count<-0
count
for(x in 0:nrow(test)-1)
{
  if(identical(test$myclass[x],result[x])) {
    count<-count+1
    count
  }
}
accuracy1<-count*100/nrow(test)
#output to file
cat(c("Accuracy in Decision Tree ", accuracy1,"\n"), file=fileConn, append=TRUE,sep="") 


#PERCEPTRON
train1<-sapply(train,as.numeric)
test1<-sapply(test,as.numeric)
training_data<-as.data.frame(train1)
test_data<-as.data.frame(test1)
cl<-training_data["myclass"]
names(cl)<-'myclass'
training_subset1<-training_data[ , !(names(training_data) %in% c("myclass"))]
n<-names(training_subset1)
f <- as.formula(paste("myclass ~", paste(n[!n %in% "myclass"], collapse = " + ")))
model <- neuralnet(f , training_data, hidden = 0, learningrate = 0.5, algorithm="sag", linear.output=FALSE)
temp <- subset(test_data, select = c(n))
predictedModel <- compute(model, temp)
results <- data.frame(actual = test_data["myclass"], prediction = predictedModel$net.result)
results$prediction <- round(results$prediction)
#accuracy
accuracy2<-(sum(results$myclass==results$prediction)/length(results$myclass))*100.0
#output to file
cat(c("Accuracy in perceptron", accuracy2,"\n"), file=fileConn, append=TRUE,sep=" ")


#NEURAL NET
train1<-sapply(train,as.numeric)
test1<-sapply(test,as.numeric)
training_data1<-as.data.frame(train1)
test_data<-as.data.frame(test1)
cl<-training_data1["myclass"]
names(cl)<-'myclass'
training_subset1<-training_data1[ , !(names(training_data1) %in% c("myclass"))]
n<-names(training_subset1)
f <- as.formula(paste("myclass ~", paste(n[!n %in% "myclass"], collapse = " + ")))
model <- neuralnet(f , training_data1, hidden = c(5, 3), threshold=0.1, linear.output=FALSE)
temp <- subset(test_data, select = c(n))
predictedModel <- compute(model, temp)
results <- data.frame(actual = test_data["myclass"], prediction = predictedModel$net.result)
results$prediction <- round(results$prediction)
#accuracy
accuracy3<-(sum(results$myclass==results$prediction)/length(results$myclass))*100.0
#output to file
cat(c("Accuracy in NeuralNet ", accuracy3,"\n"), file=fileConn, append=TRUE, sep=" ")


#SVM
model <- svm(myclass ~ ., data=train, kernel="linear",scale = FALSE)
result <- predict(model, test)
#accuracy
accuracy4<-(sum(diag(table(result, test[["myclass"]])))/nrow(test))*100
#output to file
cat(c("Accuracy in SVM", accuracy4,"\n"), file=fileConn, append=TRUE, sep=" ")


#NAIVE BAYES
formula <- as.formula(paste("myclass"," ~ ."))
model <- naiveBayes(formula, data=train)
result <- predict(model, test)
#accuracy
accuracy5<-(sum(diag(table(result, test[["myclass"]])))/nrow(test))*100
#output to file
cat(c("Accuracy in Naive Bayes", accuracy5,"\n"), file=fileConn, append=TRUE, sep=" ")    

cat(c("\n"), file=fileConn, append=TRUE, sep="\n")    
  }


#Correlation
for(i in 1:33){
  for(j in i:33){
    y=cor(mydata[i],mydata[j])
    cat(c("Corelation between variables",i," ",j," ",is," ",y,"\n"),file=fileConn,append=TRUE,sep="")
  }
}

for(i in 1:33){
  y=cor(mydata[i],as.numeric(levels(mydata$myclass)[mydata$myclass]))
  cat(c("Corelation between variables",i," ","ClassLabel"," ","is",y,"\n"),file=fileConn,append=TRUE,sep="")
}
#cat(c("Corelation matrix is",cor(mydata[,unlist(lapply(mydata, is.numeric))])),file=fileConn,append=TRUE)
y=cor(mydata[1:33])
corrplot(y,method="circle")
hist(y)
