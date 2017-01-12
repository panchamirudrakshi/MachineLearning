doInstall <- TRUE

install.packages('ROAuth')
install.packages('RCurl')
install.packages('twitteR')
install.packages('rjson')
install.packages('RJSONIO')
install.packages('streamR')
library(ROAuth)
library(twitteR)
library(RCurl)
library(rjson)
library(RJSONIO)
library(streamR)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "zA1VLlxd1xBWpfDPsGr4ApYpg"
consumerSecret <- "gfKZI82id6sdtiR6D0txPJksMNIc0R4K0EabN8wRIx8iBEHVlg"
my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file="K:/GDrive/MS-CS/3rdSem/SocialMedia/Project/oauth_token.Rdata")
accessToken <- "4850809766-KwnoYzV6nWGRG53u8jsaGLSabfI2D11PmCq3PoN"
accessSecret <- "zhEXpRUTmYKyJatAF2QirjAG9O5JujzOA6GbTjgTCL1PN"
setup_twitter_oauth(consumer_key=consumerKey, consumer_secret=consumerSecret,
                    access_token=accessToken, access_secret=accessSecret)
searchTwitter('obama', n=1)


# profile information
user <- getUser('barackobama')
user$toDataFrame()
# followers
user$getFollowers(n=10)# (10 most recent followers)
# friends (who they follow)
user$getFriends(n=10)

#SEARCH RECENT TWEETS
# basic searches by keywords
tweets <- searchTwitter("obama", n=20)
# convert to data frame
tweets <- twListToDF(tweets)

tweets <- searchTwitter("#Trump",n=20)
tweets <- twListToDF(tweets)
tweets
tweets <- searchTwitter("#PoliSciNSF")
tweets <- twListToDF(tweets)
tweets$created

#DOWNLOADING RECENT TWEETS FROM A USER
## you can do this with twitteR
timeline <- userTimeline('nytimes', n=20)
timeline <- twListToDF(timeline)

source("K:/GDrive/MS-CS/3rdSem/SocialMedia/Project/function.r")
#options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
getTimeline(filename="K:/GDrive/MS-CS/3rdSem/SocialMedia/Project/tweets_nytimes.json", screen_name="nytimes", 
            n=1000, oauth=my_oauth, trim_user="false")

tweets <- parseTweets("tweets_nytimes.json")

#COLLECTING TWEETS FILTERING BY KEYWORDS 

filterStream(file.name="obama_tweets.json", track="obama", 
             timeout=60, oauth=my_oauth)

tweets <- parseTweets("obama_tweets.json")
tweets

## This is how we would capture tweets mentioning multiple keywords:
filterStream(file.name="political_tweets.json", 
             track=c("obama", "bush", "clinton"),
             tweets=100, oauth=my_oauth)
#COLLECTING TWEETS FILTERING BY LOCATION
##collect tweets filtering by location
## instead. In other words, set a geographical box and collect
## only the tweets that are coming from that area.
filterStream(file.name="tweets_geo.json", locations=c(-125, 25, -66, 50), 
             timeout=60, oauth=my_oauth)

tweets <- parseTweets("tweets_geo.json")

#COLLECTING A RANDOM SAMPLE OF TWEETS
sampleStream(file.name="tweets_random.json", timeout=30, oauth=my_oauth)

tweets <- parseTweets("tweets_random.json")

#get most common hashtags 
getCommonHashtags(tweets$text)

#most retweeted tweet
tweets[which.max(tweets$retweet_count),]



