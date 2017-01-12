#ANALYSIS OF THE DATA COLLECTED IN twitter.r
#DONE WITH COLLECTION OF DATA; LET US BEGIN WITH THE ANALYSIS
install.packages('streamR')
install.packages('ggplot2')
install.packages('grid')
install.packages('maps')
install.packages('Rstem')
install.packages('tm')
library(streamR)
library(ggplot2)
library(grid)
library(maps)
library(Rstem)
library(tm)

#WORKING WITH GEOLOCATED TWEETS
#read the geolocated tweets collected in tweets_geo.json
tweets <- parseTweets("tweets_geo.json")

tweets <- tweets[!is.na(tweets$lon),]

#create a data frame with the map data 
map.data <- map_data("state")
#map.data <- head("state")

#use ggplot2 to draw the map:
# 1) map base
ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "grey90",color = "grey50", size = 0.25) + expand_limits(x = map.data$long, y = map.data$lat)+
scale_x_continuous(limits=c(-125,-66)) + scale_y_continuous(limits=c(25,50))+

geom_point(data = tweets, 
             aes(x = lon, y = lat), size = 1, alpha = 1/5, color = "darkblue")+

theme(axis.line = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(), 
        panel.background = element_blank(), 
        panel.border = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        plot.background = element_blank()) 

#number of tweets coming from each state
states <- map.where(database="state", x=tweets$lon, y=tweets$lat)
head(sort(table(states), decreasing=TRUE))

#SENTIMENT ANALYSIS

# Loading tweets that will be used
tweets <- parseTweets("obama_tweets.json")

# loading lexicon of positive and negative words (from Neal Caren)
lexicon <- read.csv("K:/GDrive/MS-CS/3rdSem/SocialMedia/Project/lexicon.csv", stringsAsFactors=F)
pos.words <- lexicon$word[lexicon$polarity=="positive"]
pos.words
neg.words <- lexicon$word[lexicon$polarity=="negative"]
neg.words
# a look at a random sample of positive and negative words
sample(pos.words, 10)
sample(neg.words, 10)

# function to clean the text
clean_tweets <- function(text){
  # loading required packages
  lapply(c("tm", "Rstem", "stringr"), require, c=T, q=T)
  # avoid encoding issues by dropping non-unicode characters
  utf8text <- iconv(text, to='UTF-8', sub = "byte")
  # remove punctuation and convert to lower case
  words <- removePunctuation(utf8text)
  words <- tolower(words)
  # spliting in words
  words <- str_split(words, " ")
  return(words)
}

# clean the text
tweets$text[1]
tweets$text[7]

text <- clean_tweets(tweets$text)
text[[1]]
text[[7]]

# function to classify individual tweets
classify <- function(words, pos.words, neg.words){
  # count number of positive and negative word matches
  pos.matches <- sum(words %in% pos.words)
  #pos.matches
  neg.matches <- sum(words %in% neg.words)
  #neg.matches
  return(pos.matches - neg.matches)
}

# applying the function
classify(text[[1]], pos.words, neg.words)
classify(text[[7]], pos.words, neg.words)

#to aggregate over many tweets...
classifier <- function(text, pos.words, neg.words){
  # classifier
  scores <- unlist(lapply(text, classify, pos.words, neg.words))
  n <- length(scores)
  positive <- as.integer(length(which(scores>0))/n*100)
  negative <- as.integer(length(which(scores<0))/n*100)
  neutral <- 100 - positive - negative
  cat(n, "tweets:", positive, "% positive,",
      negative, "% negative,", neutral, "% neutral")
}

# applying classifier function
#output: 234 tweets: 27 % positive, 18 % negative, 55 % neutral<-fINAL Output
classifier(text, pos.words, neg.words)
