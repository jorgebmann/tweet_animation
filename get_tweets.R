library(rtweet)
library(ggplot2)
library(tm)
library(syuzhet)
library(dplyr)
library(reshape2)
library(rlist)
library(ggraph)

# authenticate via web browser
# insert your app name, key, token:
token <- create_token(
  app = "xxx",
  consumer_key = 'xxx',
  consumer_secret = 'xxx',
  access_token = 'xxx',
  access_secret = 'xxx')


get_token()

bmw <- search_tweets("bmw", n = 100000, language = 'en', retryonratelimit = T, token = token, include_rts = F)

# clean tweets: 
mk_clean <- function(x) {
  for (i in seq(nrow(x))){ 
    x$clean_text[i] <- gsub("&amp", "", x$text[i]) 
    x$clean_text[i] <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "",  
                            x$clean_text[i]) 
    x$clean_text[i] <- gsub("@\\w+", "", x$clean_text[i]) 
    x$clean_text[i] <- gsub("[[:punct:]]", "", x$clean_text[i]) 
    x$clean_text[i] <- gsub("[[:digit:]]", "", x$clean_text[i]) 
    x$clean_text[i] <- gsub("http\\w+", "", x$clean_text[i]) 
    x$clean_text[i] <- gsub("[ \t]{2,}", "", x$clean_text[i]) 
    x$clean_text[i] <- gsub("^\\s+|\\s+$", "", x$clean_text[i]) 
    x$clean_text[i] <- gsub("\n", "", x$clean_text[i])
    x$clean_text[i] <- tolower(x$clean_text[i])
  } 
  x$clean_text <- sapply(x$clean_text,  
                         function(y) iconv(y, "latin1", "ASCII", sub="")) 
  
  return(x)
}

bmw <- mk_clean(bmw)
bmw$clean_text[1]

# get emotions and valence of each tweet for each car:
bmw_sentiment <- get_nrc_sentiment(bmw$clean_text)
bmw_sentiment$date <- as.Date(bmw$created_at)
bmw <- split(bmw_sentiment[,1:8], bmw_sentiment$date)
N_bmw <- lapply(bmw, function(x) data.frame(cbind(colnames(x)[1:8], colSums(x[,1:8])), stringsAsFactors = F))
for (i in 1:length(N_bmw)) {colnames(N_bmw[[i]]) <- c('emotion', 'tweets')}
n_bmw <- do.call(rbind, N_Telsa)
n_bmw$date <- as.Date(names(N_bmw))
n_bmw$car <- 'bmw'
n_bmw <- n_bmw[c('date', 'car',  'emotion', 'sentiment', 'tweets')]
write.csv(n_bmw, file = 'bmw_tweets.csv', row.names = F)
