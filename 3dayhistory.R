ThreeDayHist <- function(){

URL<- 'http://w1.weather.gov/data/obhistory/KLIT.html'
timezoneDaylight<- -5
timezoneStandard<- -6
#URL1<- 'http://www.timeanddate.com/time/change/usa/chicago'

web<- function(URL){
  web<- read_html(url(URL))
  data<- readHTMLTable(htmlParse(web, asText= TRUE))
  Temp<- data[4]
  Tempdata<- as.data.frame(Temp)
  Tempdata
  
}

daylight<-{}
daylight$year<- c(2013,2014,2015,2016,2017,2018,2019)
daylight$start<- c("March 10" , "March 09", "March 08", "March 13", "March 12", "March 11", "March 10")
daylight$end<- c("November 03","November 02","November 01","November 06","November 05","November 04","November 03")

daylight<-as.data.frame(daylight)%>% 
  mutate(StartDate = paste(daylight$year,daylight$start,"01:59",sep=" ")) %>%
  mutate(StopDate = paste(daylight$year,daylight$end,"01:59",sep=" "))

daylight$StartDate<- as.POSIXct(strptime(daylight$StartDate, format = "%Y %B %d %H:%M", tz="UTC")) +6*60*60

daylight$StopDate<- as.POSIXct(strptime(daylight$StopDate, format = "%Y %B %d %H:%M", tz="UTC")) +6*60*60
  
Tempdata<-web(URL)
column.names<- Tempdata[c(75),] %>% droplevels() %>% sapply(as.character)
Tempdata<-  Tempdata[-c(1,2,75,76,77),]
colnames(Tempdata)<- column.names

UTC.datetime<- now(tz='UTC')
DST<- daylight[daylight$year %in% year(now(tz= 'UTC')),]

if (UTC.datetime > DST$StartDate | UTC.datetime < DST$StopDate){
  currtime<- now(tz='UTC')-5*60*60
} else {
  currtime<- now(tz='UTC')-6*60*60
}

Tempdata$Date<- as.numeric(levels(Tempdata$Date))[Tempdata$Date]

for (ii in 1:nrow(Tempdata)){
  
  
  Tempdata$month[ii]<- month(currtime - (min(Tempdata$Date[1]-Tempdata$Date[ii],3)*24*60*60))
  Tempdata$year[ii]<- year(currtime- (min(Tempdata$Date[1]-Tempdata$Date[ii],3)*24*60*60))

 
}

return(Tempdata)
}
