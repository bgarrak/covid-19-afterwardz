library("tidyverse")
library("RODBC")
library("sqldf")
library("readr")

################################################################################################

# Need these libraries, install if not found #
if(!require(tidyverse)){install.packages("tidyverse")
	library(tidyverse)}
if(!require(RODBC)){install.packages("RODBC")
	library(RODBC)}
if(!require(sqldf)){install.packages("sqldf")
	library(sqldf)}
if(!require(readr)){install.packages("readr")
	library(readr)}

################################################################################################




################################################################################################


setwd <- "Z:/covidData"

### NYT Covid github dataset url ###

dataset_counties_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

dataset_states_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"

### Assign csvs to a variable ###

counties_csv <- read_csv(url(dataset_counties_url))

states_csv <- read_csv(url(dataset_states_url))

################################################################################################


### Use environmental variables for authentication ### 
u <- Sys.getenv("A_SSMS_Login")
p <- Sys.getenv("A_SSMS_PWD")

con <- odbcConnect("covidSQLPipe", uid = u, pwd = p)

# test  <- sqlQuery(con, "SELECT * FROM [COVID].[counties]")

# How many records are in the databases?
#qCountyRecCnt

#qStateRecCnt

################################################################################################

# How up to date is the counties table?
qCountyMaxDate <- sqlQuery(con, "SELECT max(date) as maxDate FROM [COVID].[counties]")
qCountyMaxDate <- qCountyMaxDate$maxDate


# Select only the new records from the github data
newRecords <- filter(counties_csv, counties_csv$date > qCountyMaxDate)
head(newRecords)


# Update to the counties table
sqlSave(con, newRecords, tablename = "COVID.counties", rownames = F, append = T)

################################################################################################

# How up to date is the states table?
qStateMaxDate <- sqlQuery(con, "SELECT max(date) as maxDate FROM [COVID].[states]")
qStateMaxDate <- qStateMaxDate$maxDate


# Select only the new records from the github data
newStateRecords <- filter(states_csv, states_csv$date > qStateMaxDate)
head(newStateRecords)


# Update to the state table
sqlSave(con, newStateRecords, tablename = "COVID.states", rownames = F, append = T)

################################################################################################

## CLEAN UP AFTER YOURSELF ##
odbcCloseAll() 
