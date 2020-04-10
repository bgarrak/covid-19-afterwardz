library(tidyverse)
library(dplyr)
library(readxl)
library(plyr)
library(anytime)
library(lubridate)
library(writexl)

setwd("Z:/covidData")

masterState <- read_excel("Z:/covidData/COVIDDev.xlsx", sheet = "state data")
#masterCounty <- read_excel("Z:/covidData/COVID.xlsx", sheet = "county data")

#sortS <- with(masterState, masterState[order(state) , ])
# sortC <- with(masterCounty, masterCounty[order(county) , ])
# State and county needed

newState <- read.csv( "Z:/covidData/covid-19-data-master/us-states.csv", header = TRUE)
# newCounty <- read.csv("Z:/covidData/covid-19-data-master/us-counties.csv")
newState$date <- anytime(newState$date)
#newState$state %>% mutate_if(is.factor, as.character) -> newState$state
newState$state <- as.character(newState$state, stringsAsFactors = FALSE)


maxDate <- max(masterState$date)

maxNewDate <- max(newState$date)

if(maxNewDate > maxDate) {

	addTheseRows <- newState %>%
		select(date, state, fips, cases, deaths) %>%
		filter(between(date, maxDate, maxNewDate))

	addTheseRows <- add_column(addTheseRows, Key = "" , .before = "date")
	addTheseRows <- add_column(addTheseRows, NewCases = "", NewDeaths = "", nine = "", ten = "", eleven = "", twelve = "", .after = "deaths")

	addTheseRows$NewCases <- as.numeric(addTheseRows$NewCases)
	addTheseRows$NewDeaths <- as.numeric(addTheseRows$NewDeaths)
	addTheseRows$nine <- as.numeric(addTheseRows$nine)
	addTheseRows$ten <- as.numeric(addTheseRows$ten)
	addTheseRows$eleven <- as.numeric(addTheseRows$eleven)
	addTheseRows$twelve <- as.numeric(addTheseRows$twelve)

	addTheseRows <- with(addTheseRows, addTheseRows[order(state) , ])

	end <- bind_rows(masterState, addTheseRows)
	end

	write_xlsx(end, path = "devTest.xlsx")

}

