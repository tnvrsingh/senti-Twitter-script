library(twitteR)
library(RCurl)
library(RJSONIO)
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)
library(stringr)
library(tm)
library(purrr)

api_key <- "" # Get this credential from dev.twitter.com and enter it here
api_secret <- "" # Get this credential from dev.twitter.com and enter it here
token <- "" # Get this credential from dev.twitter.com and enter it here
token_secret <- "" # Get this credential from dev.twitter.com and enter it here

tweets <- searchTwitter("trump wall", n=100)

print (tweets)

tweets.df <- twListToDF(tweets)

tweets = tolower(tweets)

tweets_cl <- gsub('\\p{So}|\\p{Cn}', '', tweets, perl = TRUE)

#map_chr converts to Vector
tweetaftermap <- map_chr(tweets, function(x) x $text)

mySentiment <- get_nrc_sentiment(tweetaftermap)

head(mySentiment)

print ("sentiment analysis done!")

# ---------- OPTIONAL CODE for generating a PDF of the sentiment analysis

# tweets <- cbind(tweets_cl, mySentiment)
# print ("binding to sentiment done")
# sentimentTotals <- data.frame(colSums(tweets_cl[,c(11:18)]))
# print("data frame column shit done")
# names(sentimentTotals) <- "count"
# sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
# rownames(sentimentTotals) <- NULL
# ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
#         geom_bar(aes(fill = sentiment), stat = "identity") +
#         theme(legend.position = "none") +
#         xlab("Sentiment") + ylab("Total Count") + ggtitle("Total Sentiment Score for All Tweets")
