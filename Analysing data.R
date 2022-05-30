
#Download the csv data from: https://dappradar.com/ethereum/games/the-sandbox
file_path <- "D:/Gabri/Download chrome/be8j9ok4.csv"  #I have uploaded the file in the src folder. Save it and substitute this line of code with your path
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

##### Now we want the "in-platform" market Cap ####
#download the prices 
library(quantmod)
SAND_USD <- getSymbols("SAND-USD", from = "2019-01-01", to = "2022-05-27", 
                       auto.assign = T) %>% 
  purrr::map(~Ad(get(.))) %>% purrr::reduce(merge)
rm("SAND-USD")

#amount of token in-platform 
tot_supply <- 3e9
float <- 1.23e9
company_treasury <- 3e9*0.3032
token_inp <- tot_supply - float - company_treasury

#time series of the market cap (in-platform)
mkt_cap_inp <- token_inp * SAND_USD 

#view the data
#in app market cap
library(dygraphs)
mkt_cap_inp %>%  dygraph( , xlab = "Date" , ylab = "MKT CAP (in-platform)" ) %>% 
  dySeries(label = "MKT CAP (in-platform)") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()

#active users 
active_users %>% dygraph( , xlab = "Date" , ylab = "Active users") %>% 
  dySeries(label = "Active_users") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()

#together
mkt_cap_inp_2 <- as.data.frame(mkt_cap_inp)
mkt_cap_inp_2 <-  cbind( rownames(mkt_cap_inp_2), mkt_cap_inp_2)  
active_users_2 <- cbind( rownames(active_users), active_users)
colnames(mkt_cap_inp_2) <- c("Date", "In app MKT CAP" )
colnames(active_users_2) <-  c("Date",  "Active Users")


data <- merge(mkt_cap_inp_2, active_users_2, by.x = "Date", all.x = T)
temp <- data[,1]
data <- data[ ,-1]
rownames(data) <- temp


data %>% dygraph( , xlab = "Date" ,ylab=  "Active users" ) %>% 
  dySeries( axis = "y2") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()

##################################################################à
#while with the total market cap 
file2 <- "D:/Gabri/Download chrome/sand-usd-max.csv"
mkt_cap_tot <- read.csv(file2)
mkt_cap_tot[,1] <- str_sub(mkt_cap_tot[,1], start=1, end=-13) #remove the time
mkt_cap_tot[ ,1] <- as.Date(mkt_cap_tot[,1], tryFormats = "%Y-%m-%d") #set date format
mkt_cap_tot <- mkt_cap_tot[,-2]   #take only the market cap adn date column
mkt_cap_tot <- mkt_cap_tot[,-3]   #'' 

#merge the data with active users
colnames(mkt_cap_tot)[1] <- "Date"
mkt_cap_tot[,1] <- as.character(mkt_cap_tot[,1])
data2 <- merge(mkt_cap_tot , active_users_2, by.x= "Date", all.x = T)

#set the data frame in a way in which can be plotted
temp <- data2[,1]
data2 <- data2[,-1]
rownames(data2) <- temp
rm(temp)

#plot
data2 %>% dygraph( , xlab = "Date" , ylab = "Active Users" ) %>% 
  dySeries( axis = "y2") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()


#mkt cap vs in app makret cap
data3 = merge(mkt_cap_inp_2, mkt_cap_tot, by.x = "Date")
temp = data3[,1]
data3 <- data3[,-1]
rownames(data3) <- temp 
rm(temp)
data3 %>% dygraph( , xlab = "Date", ylab = "In app mkt cap" ) %>% 
  dySeries( axis = "y2") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()
###########################################let's try only with the price 
#prepare to merge
SAND_USD <- as.data.frame(SAND_USD)
temp <- SAND_USD[,1]
SAND_USD <- cbind(temp, SAND_USD[,1])
colnames(SAND_USD) <- c("Date", "SAND_USD")
data4 <- merge(active_users_2, SAND_USD, by.x = "Date", all.y = T)

#prepare to plot
temp <- data4[,1]
data4 <- data4[,-1]
rownames(data4) <- temp
rm(temp)

#plot
data4 %>% dygraph( , xlab = "Date", ylab = "active users" ) %>% 
  dySeries( axis = "y2") %>% dyLegend(show = "always") %>% 
  dyRangeSelector()
