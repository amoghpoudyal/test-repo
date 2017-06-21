WUforecast<- function(){
library(httr)
library(lubridate)
sample2 <- GET("http://api.wunderground.com/api/c1573ea4b389aefb/hourly10day/q/AR/Little_Rock.json")
result2 <- content(sample2)


data<- {}
for (ii in 1:240){
data$day[ii]<-  result2$hourly_forecast[[ii]]$FCTTIME$mday
data$month[ii]<-  result2$hourly_forecast[[ii]]$FCTTIME$mon_padded
data$hour[ii]<-  result2$hourly_forecast[[ii]]$FCTTIME$hour_padded
data$year[ii]<-  result2$hourly_forecast[[ii]]$FCTTIME$year
data$date[ii]<-  result2$hourly_forecast[[ii]]$FCTTIME$pretty

data$temp[ii]<-  result2$hourly_forecast[[ii]]$temp$english
data$humidity[ii]<-  result2$hourly_forecast[[ii]]$humidity

}

WUforecast<- as.data.frame(data)
WUforecast$datef<- as.Date(as.POSIXct(paste(WUforecast$day,"-", data$month,"-", data$year, sep= ""), format = "%d-%m-%Y"))
WUforecast$numday<- yday(WUforecast$datef)

return(WUforecast)
}
