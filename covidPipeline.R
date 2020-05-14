library("tidyverse")
library("RODBC")
library("sqldf")
library("readr")
# library("stringr")

################################################################################################

# Need these libraries, install if not found #
if(!require(tidyverse)){install.packages("tidyverse")
	library(tidyverse)}
if(!require(RODBC)){install.packages("RODBC")
	library(RODBC)}
if(!require(sqldf)){install.packages("sqldf")
	library(sqldf)}
if(!require(stringr)){install.packages("stringr")
	library(stringr)}

setwd <- "Z:/covidData"

################################################################################################


### NYT Covid github dataset url ###

dataset_counties_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

# datset_states_url <- "https://github.com/nytimes/covid-19-data/raw/master/us-states.csv"


counties_csv <- read_csv(url(dataset_counties_url))

# states_csv <- read_csv(url(dataset_states_url))

################################################################################################


### Use environmental variables for authentication ### 
u <- Sys.getenv("A_SSMS_Login")
p <- Sys.getenv("A_SSMS_PWD")

con <- odbcConnect("covidSQLPipe", uid = u, pwd = p)

# test  <- sqlQuery(con, "SELECT * FROM [COVID].[counties]")


qMaxDate <- sqlQuery(con, "SELECT max(date) as maxDate FROM [COVID].[counties]")
qMaxDate <- qMaxDate$maxDate

newRecords <- filter(counties_csv, counties_csv$date > qMaxDate)
head(newRecords)


# Send it up  
sqlSave(con, newRecords, tablename = "COVID.counties", rownames = F, append = T)


## CLEAN UP AFTER YOURSELF ##
odbcCloseAll() 
