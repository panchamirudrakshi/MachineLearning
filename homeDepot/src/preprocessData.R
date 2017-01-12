#### PreProcessing
require(tm)
require(hunspell)
require(data.table)

#Load the data 
hdTrain<-data.table::fread("train.csv",header=TRUE,encoding="Latin-1") 
hdTest<-data.table::fread("test.csv",header=TRUE) 

# loading training Set into local variables
# Training DataSet
P <- hdTrain$product_title
Q <- hdTrain$search_term
R <- hdTrain$relevance
# Test DataSet
testP <- hdTest$product_title
testQ <- hdTest$search_term



# helper fucntion; Spell Correction gets an array of words and returns it fixed
correctSpelling <- function(words) {
  for (i in 1:length(words)) {
    if (!hunspell_check(words[i])) {
      #cat(paste("wrong word: ", words[i], " at index: ", i))
      words[i] = hunspell_suggest(words[i])[[1]][1]
      #cat(paste(" replaced by: ", words[i], "\n"))
    }
  }
  return (tolower(words));
}
# preprocess Text 
# input: an text string of any length
# output: an array of unique STEMs corresponding to the original text
# note: repetition of STEMs are ignored in this implementation
# Further improvement: considering repetition of STEMs as a measure of importance of
# that STEM can be considered.
#
# Steps; 
# make all lower case
# remove punctuation
# remove whitespace
# split the string to words
# remove stopwords
# clean empty spaces (spaceholders for stopwords)
# make the list unique (remove duplicates)***
# fix the spellings
# convert all to STEMs
# remove duplicate STEMs ***

preprocessText <- function (myText)
{
  myText = tolower(myText);
  myText = gsub("[[:punct:]]", " ",myText);
  myText = removeWords(unlist(strsplit(stripWhitespace(removePunctuation(myText))," ")), stopwords("en"))
  myText = myText[myText!=""];
  if (length(myText) > 0) {
    mytext = correctSpelling(myText);
    myText = unique(stemDocument(myText));
  }
  return(myText);
}

# preprocessing the training data 
cat("\n\n\n\nProcessing Product Titles...;");
preProcessedP = lapply(P, preprocessText);
cat("Completed Processing Product Titles...;");
cat("\n\n\n\nProcessing Search Queries...;");
preProcessedQ = lapply(Q, preprocessText);
cat("Completed Processing Search Queries...;");



#encoding problem in Product Title so they have been converted to UTF-8
testP = iconv(testP, from="ISO-8859-1", to="UTF-8");

# preprocessing the test data 
cat("\n\n\n\nProcessing Product Titles...;");
preProcessedTestP = lapply(testP, preprocessText);
cat("Completed Processing Product Titles...;");
cat("\n\n\n\nProcessing Search Queries...;");
preProcessedTestQ = lapply(testQ, preprocessText);
cat("Completed Processing Search Queries...;");

# Experiment 1
# x1 = count of elements of intersect(P[i],Q[i])
# x2 = x1 / (count of elements of union(P[i], Q[i]))
# x3 = x1 / count of elements of P[i]
# x4 = x1 / count of elements of Q[i]

X1 = NULL
X2 = NULL
U1 = NULL
X3 = NULL
X4 = NULL

# extractFeatures is a function that extracts features from preprocessed product titles and 
# search queries, results are stored in X1,X2,X3 & X4.

extractFeatures <- function(processedProductTitle, processedSearchQuery)
{
  endIndex = length(processedProductTitle);
  for (i in 1:endIndex)
  {
    X1[i] = length(intersect(processedProductTitle[i][[1]], processedSearchQuery[i][[1]]))
    U1[i] = length(union(processedProductTitle[i][[1]], processedSearchQuery[i][[1]]))
    X2[i] = X1[i] / U1[i]
    X3[i] = X1[i] / length(processedProductTitle[i][[1]])
    X4[i] = X1[i] / length(processedSearchQuery[i][[1]])
  }
  output <- list(X1,X2,X3,X4);
  names(output) <- c("X1","X2","X3","X4");
  output <-as.data.frame(output);
  return(output)
}

# fixing and saving Trainig Dataset's features
features <- extractFeatures(preProcessedP,preProcessedQ)
features[,5] = R
names(features)[5] = "Relevance"
summary(features)
features$X4[is.na(features$X4)] = 0
dim(features)
write.csv(features, file = "trainFeatures-all.csv", col.names = TRUE, row.names = FALSE)

# fixing and saving Test Dataset's features
# in Test Dataset there is no Relevance information (Target Value)
features <- extractFeatures(preProcessedTestP,preProcessedTestQ)
summary(features)
features$X4[is.na(features$X4)] = 0
dim(features)
write.csv(features, file = "testFeatures-all.csv", col.names = TRUE, row.names = FALSE)