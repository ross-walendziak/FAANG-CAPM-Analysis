# Wipe the environment clean
rm(list = ls())
# Clean the console
cat("\f") 


# Prepare needed libraries
packages <- c("tidyverse",
              "lubridate",
              "quantmod",
              "tidyr",
              "dplyr",
              "broom",
              "ggplot2",
              "tibbletime",
              "fpp2",
              "stargazer"
              )

for (i in 1:length(packages)) {
  if (!packages[i] %in% rownames(installed.packages())) {
    install.packages(packages[i], dependencies = TRUE)
  }
  library(packages[i], character.only = TRUE)
}



#################         FAMA FRENCH FACTORS


################# loading the factors to R from the local drive; formatting the date; throwing out observation with missing date

setwd("/Users/Ross Walendziak/Documents/Financial Economics/Week 9 Assignment")

FF <- read_csv("F-F_Research_Data_Factors_2021.csv") %>% 
    rename(date = date) %>% mutate(date = ymd(parse_date_time(date, "%Y%m")))  %>% na.omit(date)

FF


################# transforming FF into a long format for ggplot
FF_long <- 
  FF %>% 
  select(-RF) %>%
  gather(factor, returns, -date)

################# histograms in separate pictures
FF_long %>% 
  ggplot(aes(x = returns, fill = factor)) + 
  geom_histogram(alpha = 1, binwidth = 1) +
  facet_wrap(~factor)

################# density plots in one pictures
FF_long %>% 
  ggplot(aes(x = returns, colour = factor, fill = factor)) +
  stat_density(geom = "line", alpha = 1) +
  xlab("monthly returns") +
  ylab("distribution") 


#################         STOCKS


################# pulling stock data straight from Yahoo Finance
symbols <- c("FB", "AAPL", "AMZN", "NFLX", "GOOGL")
prices <- 
  getSymbols(symbols, src = 'yahoo', 
             from = "2015-09-01", to = "2021-09-30",
             auto.assign = TRUE, 
             warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`(symbols)

################# converting the price date into monthly returns
returns <- 
  prices %>% 
  to.monthly(indexAt = "firstof", OHLC = FALSE) %>%
  # convert the index to a date
  data.frame(date = index(.)) %>%
  # now remove the index because it got converted to row names
  remove_rownames() %>%
  # convert from wide to long creating new variable asset that will assign ticker, conversion needed to create returns using lagged variables
  gather(asset,prices,-date) %>%
  # compute returns using the usual way
  group_by(asset) %>%  
  mutate(returns=(prices/lag(prices))-1) %>%
  # remove prices
  select(-prices) %>% 
  # convert back to wide by asset
  spread(asset, returns) %>% 
  # remove missings
  na.omit()

returns

head(prices,10)
head(returns,10)

returns_df <- as.data.frame(returns)

head(returns_df,10)
autoplot(ts(returns$AMZN))

stargazer(returns_df,
          type = "html", # Type of output - text, HTML or LaTeX
          summary = TRUE,   # summary only
          title = "Descriptive Stats for FAANG stocks", #Title of my output
          digits = 3,
          out = "FAANG Descriptive Statisitcs.html" #Drops HTML File to Current Working Directory
          )

################# visualizing the returns
################# back to long from wide
asset_returns_long <- 
  returns %>% 
  gather(asset, returns, -date)

################# returns over time
asset_returns_long %>%
  ggplot(aes(x = date, y = returns)) +
  geom_point(aes(colour=factor(asset))) +
  facet_wrap(~asset)


################# histograms
asset_returns_long %>% 
  # pipe to ggplot, aes is a function for aestethics of a plot, returns on x axis, fill means different colors for different assets, alpha describes the intensity of colors, binwidth is selfexplanatory
  ggplot(aes(x = returns, fill = asset)) + 
  geom_histogram(alpha = 1, binwidth = .01)

################# separate histograms
asset_returns_long %>% 
  # pipe to ggplot, aes is a function for aestethics of a plot, returns on x axis, fill means different colors for different assets, alpha describes the intensity of colors, binwidth is selfexplanatory
  ggplot(aes(x = returns, fill = asset)) + 
  geom_histogram(alpha = 1, binwidth = .01) +
  facet_wrap(~asset)

################# densities
asset_returns_long %>% 
  ggplot(aes(x = returns, colour = asset, fill = asset)) +
  stat_density(geom = "line", alpha = 1) +
  xlab("monthly returns") +
  ylab("distribution") 



#################         CAPM

##################### merging asset returns with factors, and converting returns to excess returns
ff_assets <-
  returns %>% 
  left_join(FF, by = "date") %>%
  mutate(MKT_RF = `Mkt-RF`/100,
         SMB = SMB/100, #Small Premium
         HML = HML/100, #Value Premium
         RF = RF/100,
         FB = FB - RF,
         AAPL = AAPL - RF,
         AMZN = AMZN - RF,
         NFLX = NFLX - RF,
         GOOGL = GOOGL - RF) %>%
  select(-RF,-`Mkt-RF`) %>%
  na.omit()

##################### modelling


######## AMAZON

## estimating CAPM models

#Facebook (aka "Meta")
capm_facebook <- lm(FB ~ MKT_RF, data = ff_assets)
summary(capm_facebook)
## plotting realized returns vs predicted from the CAPM and the 3-factor model
facebook <- data.frame(ff_assets$FB, predict(capm_facebook))
ggplot(facebook)  + geom_point(aes(x = ff_assets$FB, y = predict(capm_facebook)))  + geom_abline(intercept = 0)


#Apple
capm_apple <- lm(AAPL ~ MKT_RF, data = ff_assets)
summary(capm_apple)
## plotting realized returns vs predicted from the CAPM and the 3-factor model
apple <- data.frame(ff_assets$AAPL, predict(capm_apple))
ggplot(apple)  + geom_point(aes(x = ff_assets$AAPL, y = predict(capm_apple)))  + geom_abline(intercept = 0)


#Amazon
capm_amazon <- lm(AMZN ~ MKT_RF, data = ff_assets)
summary(capm_amazon)
## plotting realized returns vs predicted from the CAPM and the 3-factor model
amazon <- data.frame(ff_assets$AMZN, predict(capm_amazon))
ggplot(amazon)  + geom_point(aes(x = ff_assets$AMZN, y = predict(capm_amazon)))  + geom_abline(intercept = 0)


#Netflix
capm_netflix <- lm(NFLX ~ MKT_RF, data = ff_assets)
summary(capm_netflix)
## plotting realized returns vs predicted from the CAPM model
netflix <- data.frame(ff_assets$NFLX, predict(capm_netflix))
ggplot(netflix) + geom_point(aes(x = ff_assets$NFLX, y = predict(capm_netflix))) + geom_abline(intercept = 0)


#Google
capm_google <- lm(GOOGL ~ MKT_RF, data = ff_assets)
summary(capm_google)
## plotting realized returns vs predicted from the CAPM model
google <- data.frame(ff_assets$GOOGL, predict(capm_google))
ggplot(google)  + geom_point(aes(x = ff_assets$GOOGL, y = predict(capm_google))) + geom_abline(intercept = 0)


###### gather results form all capm models for assembly into one data frame (alpha, beta and adj r^2)
alpha = round(c(capm_facebook$coefficients[1], 
                capm_apple$coefficients[1], 
                capm_amazon$coefficients[1], 
                capm_netflix$coefficients[1], 
                capm_google$coefficients[1]
                ), 4)

beta = round(c(capm_facebook$coefficients[2], 
               capm_apple$coefficients[2], 
               capm_amazon$coefficients[2], 
               capm_netflix$coefficients[2], 
               capm_google$coefficients[2]
                ), 4)

adj_r_squared = round(c(summary(capm_facebook)$adj.r.squared, 
                        summary(capm_apple)$adj.r.squared,
                        summary(capm_amazon)$adj.r.squared,
                        summary(capm_netflix)$adj.r.squared,
                        summary(capm_google)$adj.r.squared
                        ), 4)


results = data.frame(t(rbind(symbols, alpha, beta, adj_r_squared)))
rownames(results) = results$symbols
results = results %>% select(-symbols)

results