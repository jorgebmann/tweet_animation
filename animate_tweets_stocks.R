library(gapminder)
library(gganimate)
library(ggthemes)

a <- read.csv('bmw_tweetstock.csv', header = T)
a <- a[order(a$date),]
a <- na.omit(a)
a$date <- as.Date(a$date)

p <- ggplot(a[a$car=='bmw',], aes(close, tweets, colour = emotion, label = emotion)) +
  theme_gdocs() +
  scale_colour_gdocs() +
  xlim((round(min(a$close[a$car=='bmw']),0) - .5), (round(max(a$close[a$car=='bmw']),0) + .5)) +
  geom_label(label.size = .5, show.legend = F, size = 6, position = position_dodge(width=.9)) +
  # Here comes the gganimate specific bits
  labs(title = "Tweet emotions for a brand and it's relation to stock price\n #BMW \nDate: {frame_time}", x = 'BMW stock price (€)', y = 'Number of Tweets') +
  theme(plot.title = element_text(color="black", size=14, face="bold.italic"))  +
  transition_time(date) +
  ease_aes('linear') +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14,face="bold"))

#save as video
animate(p, renderer = av_renderer('bmw.mp4'), width = 1080, height = 1080, res = 104, fps = 25, duration = 25,
        end_pause = 1, rewind = F)

anim_save(filename = 'bmw.gif')

