library(twitteR)
library(syuzhet)
library(plyr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)

# Declare Twitter API Credentials
api_key <- "" # Get this credential from dev.twitter.com and enter it here
api_secret <- "" # Get this credential from dev.twitter.com and enter it here
token <- "" # Get this credential from dev.twitter.com and enter it here
token_secret <- "" # Get this credential from dev.twitter.com and enter it here

# Create Twitter Connection
setup_twitter_oauth(api_key, api_secret, token, token_secret)

# search some tweets
some_tweets = searchTwitter("demonetisation", n=1500, lang="en")

# get the tweets text
tweetsText = sapply(some_tweets, function(x) x$getText())

# remove retweet entities - retweet and via so that they don't interfere
tweetsText = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweetsText)
# remove at people
tweetsText = gsub("@\\w+", "", tweetsText)
# remove punctuation
tweetsText = gsub("[[:punct:]]", "", tweetsText)
# remove numbers
tweetsText = gsub("[[:digit:]]", "", tweetsText)
# remove html links
tweetsText = gsub("http\\w+", "", tweetsText)
# remove unnecessary spaces
tweetsText = gsub("[ \t]{2,}", "", tweetsText)
tweetsText = gsub("^\\s+|\\s+$", "", tweetsText)

# define "tolower error handling" function
try.error = function(x)
{
   # create missing value
   y = NA
   # tryCatch error
   try_error = tryCatch(tolower(x), error=function(e) e)
   # if not an error
   if (!inherits(try_error, "error"))
   y = tolower(x)
   # result
   return(y)
}
# lower case using try.error with sapply
tweetsText = sapply(tweetsText, try.error)

# remove NAs in tweetsText
tweetsText = tweetsText[!is.na(tweetsText)]
names(tweetsText) = NULL

Sentiment <- get_nrc_sentiment(tweetsText)
head(Sentiment)

print("Sentiment analysis done!")

tweets <- cbind(tweetsText, Sentiment)
print ("binding to sentiment done")
sentimentTotals <- data.frame(colSums(tweetsText[,c(11:18)]))
print("data frame column done")
names(sentimentTotals) <- "count"
sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
rownames(sentimentTotals) <- NULL
ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
        geom_bar(aes(fill = sentiment), stat = "identity") +
        theme(legend.position = "none") +
        xlab("Sentiment") + ylab("Total Count") + ggtitle("Total Sentiment Score for All Tweets")
