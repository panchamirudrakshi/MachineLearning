# Installing the package to work with Facebook data
install.packages("Rfacebook")
install.packages("Rook")
install.packages("tm")
install.packages("NLP")
install.packages("RColorBrewer")
install.packages('wordcloud')
library("Rfacebook")
library("Rook")
library("tm")
library("wordcloud")

# get access token
token="EAACEdEose0cBAAmhtPPRgkdrRNMYOoZB6sgcItjapysoDez144apTkfKYtAvBvAD80SeZCEKt3redbzHZAjZBZCZAPz08F8vRPiY27nGVPfdVIns1ADTwnRZBpV4ssbkoz7uDSAdtJ95uvzQdoRvGuIhJZBkWiZB13l66qLAZAATC9vQZDZD"
token

#Extract information about one or more Facebook users
user_info = getUsers("me",token=token)
user_info

#Extract list of posts from a public Facebook page
page = getPage(page="msbapm",token=token,n=5,feed=T)
page

totallikes = sum(page$likes_count,na.rm=TRUE)
totallikes

averagelikes = totallikes/5 
averagelikes

totalcomments = sum(page$comments_count,na.rm=TRUE)
totalcomments

totalshares = sum(page$shares_count,na.rm=TRUE)
totalshares

#build word cloud for the posts based on popularity
tm = c("tm","wordcloud")
posts = Corpus(DataframeSource(data.frame(as.character(page$message))))
posts = tm_map(posts,function(x)removeWords(x,stopwords()))
posts = tm_map(posts,removePunctuation)
tdm = TermDocumentMatrix(posts)
m = as.matrix(tdm)
v = sort(rowSums(m),decreasing=T)
d= data.frame(word=names(v),freq=v)
wordcloud(d$word,d$freq,min.freq=10)

# get a list of users who liked a specific post for the first page related to barakobama
page <- getPage("barackobama", token=token, n=5,since='2012/10/01', until='2012/10/30') 
post = getPost(page$id[1], token=token, n.likes=1000, likes = TRUE, comments=FALSE)
likes = post$likes
head(likes)

# get top 10 most common names of the facebook users for gender distribution analysis
users <- getUsers(likes$from_id, token=token)
head(sort(table(users$first_name), decreasing=TRUE), n=10)

# get comments on a specific post and the comment that has maximum likes
post <- getPost(page$id[1], token=token, n.comments=1000, likes=FALSE)
comments <- post$comments
head(comments)
comments[which.max(comments$likes_count),]