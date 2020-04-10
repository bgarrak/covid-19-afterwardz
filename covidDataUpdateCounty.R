library(tidyverse)
library(dplyr)
library(readxl)
library(plyr)
library(anytime)
library(lubridate)
library(writexl)

# So many packages

#####################################################################################

#	NEED DUP CHECKS

#####################################################################################

setwd("Z:/covidData")

# This will be the most current public spreadsheet
masterCounty <- read_excel("Z:/covidData/COVIDDev.xlsx", sheet = "county data")
#masterCounty <- read_excel("Z:/covidData/COVID.xlsx", sheet = "county data")


# This is the New York Times most current data 
newCounty <- read.csv( "Z:/covidData/covid-19-data-master/us-counties.csv", header = TRUE)

newCounty$date <- anytime(newCounty$date)

newCounty$county <- as.character(newCounty$county, stringsAsFactors = FALSE)
newCounty$state <- as.character(newCounty$state, stringsAsFactors = FALSE)

maxDate <- max(masterCounty$Date)
maxNewDate <- max(newCounty$date)

if(maxNewDate > maxDate) {

	#addTheseRows <- newCounty %>%
	#	select(date, county, state, fips, cases, deaths) %>%
	#	filter(between(date, maxDate, maxNewDate))

	addTheseRows <- newCounty %>%
		#select(date, county, state, fips, cases, deaths) %>%
		filter(between(date, maxDate, maxNewDate))

	addTheseRows <- add_column(addTheseRows, Key = "", .before = "date")
	#addTheseRows <- add_column(addTheseRows, NewCases = "", NewDeaths = "", ten = "", eleven = "", twelve = "", thirteen = "", .after = "deaths")

	#addTheseRows$NewCases <- as.numeric(addTheseRows$NewCases)
	#addTheseRows$NewDeaths <- as.numeric(addTheseRows$NewDeaths)
	#addTheseRows$ten <- as.numeric(addTheseRows$ten)
	#addTheseRows$eleven <- as.numeric(addTheseRows$eleven)
	#addTheseRows$twelve <- as.numeric(addTheseRows$twelve)
	#addTheseRows$thirteen <- as.numeric(addTheseRows$thirteen)

	addTheseRows <- with(addTheseRows, addTheseRows[order(county) , ])

	addTheseRows %>% rename(
		Key = Key, date =  Date, county = County, state = State, 
		)

	end <- bind_rows(masterCounty, addTheseRows)
	end

	write_xlsx(end, path = "devTestCounty.xlsx")

}











