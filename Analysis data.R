
#Download the csv data from: https://dappradar.com/ethereum/games/the-sandbox
file_path <- "D:/Gabri/Download chrome/be8j9ok4.csv" #I have uploaded the file in the src folder. Save it and substitute this line of code with your path
active_users <- read.csv(file_path)
is.character(active_users[,1]) #they should be date

#try to turn them into date
#remove the days of the week 
library(stringr)
active_users[,1] <- str_sub(active_users[,1], start=5, end=-1)

#convert character column into date
library(lubridate)
active_users[,1] <- parse_date_time2(active_users[,1]
                                     , orders = "m d Y")
#we take only the column of active users
active_users <- active_users[ ,1:2]

#set the Dates as row names (we'll need it for the plot)
rownames(active_users) <- as.character(active_users[,1] )
temp <- active_users[,1]
active_users <- active_users[,2]
active_users <- as.data.frame(active_users)
rownames(active_users) <- temp
rm(temp)



#Total market cap
file2 <- "D:/Gabri/Download chrome/sand-usd-max.csv"
mkt_cap_tot <- read.csv(file2)
mkt_cap_tot[,1] <- str_sub(mkt_cap_tot[,1], start=1, end=-13) #remove the time
mkt_cap_tot[ ,1] <- as.Date(mkt_cap_tot[,1], tryFormats = "%Y-%m-%d") #set date format
mkt_cap_tot <- mkt_cap_tot[,-2]   #take only the market cap adn date column
mkt_cap_tot <- mkt_cap_tot[,-3]   #'' 


#plot 
active_users %>% dygraph( , xlab = "Date" , ylab = "Active users") %>% 
  dySeries(label = "Active_users") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()


#merge the data with active users
colnames(mkt_cap_tot) <- c("Date" ,"Market Cap" )
mkt_cap_tot[,1] <- as.character(mkt_cap_tot[,1])
data <- merge(mkt_cap_tot , active_users_2, by.x= "Date", all.x = T)

#set the data frame in a way in which can be plotted
temp <- data[,1]
data <- data[,-1]
rownames(data) <- temp
rm(temp)

#plot
data %>% dygraph( , xlab = "Date" , ylab = "Active Users" ) %>% 
  dySeries( axis = "y2") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()





