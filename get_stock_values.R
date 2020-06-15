#get stock data:
library(quantmod)
library(dplyr)

a <- read.csv('bmw_tweets.csv')
a$date <- as.Date(a$date)

# download Open, High, Low, Close, Volume from each stock:
getSymbols('TSLA', from = '2019-11-12')

# clean up data:
bmw <- data.frame(as.Date(index(TSLA)), TSLA$TSLA.Close, scale(TSLA$TSLA.Close), TSLA$TSLA.Volume)
colnames(bmw) <- c('date', 'close', 'zclose', 'volume')
a_join <- left_join(a[a$car=='bmw',], bmw, by=c('date'))
write.csv(a_join, file = 'bmw_tweetstock.csv', row.names = F)
