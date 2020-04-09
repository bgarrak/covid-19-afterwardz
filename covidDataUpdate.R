library(tidyverse)
library(dplyr)
library(readxl)
library(plyr)
library(anytime)
# library(lubridate)


masterState <- read_excel("Z:/covidData/COVIDDev.xlsx", sheet = "state data")
#masterCounty <- read_excel("Z:/covidData/COVID.xlsx", sheet = "county data")

#sortS <- with(masterState, masterState[order(state) , ])
# sortC <- with(masterCounty, masterCounty[order(county) , ])
# State and county needed

newState <- read.csv( "Z:/covidData/covid-19-data-master/us-states.csv", header = TRUE)
# newCounty <- read.csv("Z:/covidData/covid-19-data-master/us-counties.csv")
newState$date <- anytime(newState$date)

maxDate <- max(masterState$date)

maxNewDate <- max(newState$date)

if(maxNewDate > maxDate) {

	addTheseRows <- newState %>%
		select(date, state, fips, cases, deaths) %>%
		filter(between(date, maxDate, maxNewDate))

	bind_rows(masterState[2], newState)

}



