library(tidyverse)
library(dplyr)
library(readxl)
library(plyr)
library(anytime)
library(lubridate)
library(writexl)

# So many packages


setwd("Z:/covidData")

# This will be the most current public spreadsheet
masterState <- read_excel("Z:/covidData/COVIDDev.xlsx", sheet = "state data")
#masterCounty <- read_excel("Z:/covidData/COVID.xlsx", sheet = "county data")


# This is the New York Times most current data 
newState <- read.csv( "Z:/covidData/covid-19-data-master/us-states.csv", header = TRUE)
# newCounty <- read.csv("Z:/covidData/covid-19-data-master/us-counties.csv")
newState$date <- anytime(newState$date)
#newState$state %>% mutate_if(is.factor, as.character) -> newState$state
newState$state <- as.character(newState$state, stringsAsFactors = FALSE)
# Factors are annoying

maxDate <- max(masterState$date)
maxNewDate <- max(newState$date)

# Determines if there is new data and adds it accordingly
# Entirely too many "as.numeric"s
# Useless columns
if(maxNewDate > maxDate) {

	# Give me only the new rows
	addTheseRows <- newState %>%
		select(date, state, fips, cases, deaths) %>%
		filter(between(date, maxDate, maxNewDate))

	# These are columns that need to be filled in the spreadsheet
	addTheseRows <- add_column(addTheseRows, Key = "" , .before = "date")
	addTheseRows <- add_column(addTheseRows, NewCases = "", NewDeaths = "", nine = "", ten = "", eleven = "", twelve = "", .after = "deaths")

	addTheseRows$NewCases <- as.numeric(addTheseRows$NewCases)
	addTheseRows$NewDeaths <- as.numeric(addTheseRows$NewDeaths)
	addTheseRows$nine <- as.numeric(addTheseRows$nine)
	addTheseRows$ten <- as.numeric(addTheseRows$ten)
	addTheseRows$eleven <- as.numeric(addTheseRows$eleven)
	addTheseRows$twelve <- as.numeric(addTheseRows$twelve)

	addTheseRows <- with(addTheseRows, addTheseRows[order(state) , ])

	# End is the final product for State information - ready for excel
	end <- bind_rows(masterState, addTheseRows)
	end

	write_xlsx(end, path = "devTest.xlsx")

}

