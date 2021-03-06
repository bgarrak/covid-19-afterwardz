library("tidyverse")
library("RODBC")
library("sqldf")
library("readr")
library("lubridate")
# library("mailr")

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
if(!require(lubridate)){install.packages("lubridate")
	library(lubridate)}
# if(!require(mailR)){install.packages("mailR")
#	library(mailR)}
################################################################################################


### This code will run on a daily basis at 10:01 AM and 1:01 PM PST, IF THE USER IS LOGGED IN ###


################################################################################################


setwd <- Sys.getenv("A_WkD")

### NYT Covid github dataset url ###

dataset_counties_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

dataset_states_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"

### Assign csvs to a variable ###

counties_csv <- read_csv(url(dataset_counties_url))

states_csv <- read_csv(url(dataset_states_url))

################################################################################################

######################################################
### Use environmental variables for authentication ### 
u <- Sys.getenv("A_SSMS_Login")
p <- Sys.getenv("A_SSMS_PWD")

### Environmental variables ###
#gmail <- Sys.getenv("A_OAuth")
#notifyMe <- Sys.getenv("A_School")
from <- Sys.getenv("A_Service_From")
errorEnv <- Sys.getenv("A_D_ERROR")
logEnv <- Sys.getenv("A_D_Log")

######################################################

con <- odbcConnect("covidSQLPipe", uid = u, pwd = p)


### Tests ### 
#	test <- sqlQuery(con, "SELECT * FROM [COVID].[counties]")

#	How many records are in the databases?
#	qCountyRecCnt

#	qStateRecCnt

################################################################################################

# How up to date is the counties table?
qCountyMaxDate <- sqlQuery(con, "SELECT max(date) as maxDate FROM [COVID].[counties]")
qCountyMaxDate <- qCountyMaxDate$maxDate


################################################################################################
	# "SELECT * FROM [COVID].[counties]"

dupChk <- sqlQuery(con, "SELECT * FROM [COVID].[counties]")
count(dupChk)
dup <- distinct(dupChk)
count(dup)

	#duplicated <- sqlQuery(con, "select max(date) as date, count(date) as recct from [COVID].[counties] group by date order by date desc")
################################################################################################


# Select only the new records from the github data
newRecords <- filter(counties_csv, counties_csv$date > qCountyMaxDate)
head(newRecords)

############ ADD A SPECIFIC DATE WITH THIS ############
# newRecords <- filter(counties_csv, counties_csv$date == '2020-05-23')


# How many new records are there?
rec <- count(newRecords)
rec <- as.numeric(rec)

### Sorting for log
if(rec > 0) {
	# Update to the COUNTIES table and update the log with the date and 
	sqlSave(con, newRecords, tablename = "COVID.counties", rownames = F, append = T)
	time <- as.character(now())
	str <- "New COUNTY records were ADDED on:" 
	newData <- as.character(paste(str, time))

	write.table(newData, file = logEnv, append = TRUE, row.names = FALSE, col.names = FALSE)
} else if (rec == 0) {
	# Print the date and time that the found no new data but operated successfully
	time <- as.character(now())
	str <- "No new COUNTY records to add." 
	none <- paste(str, time)

	write.table(none, file = logEnv, append = TRUE, row.names = FALSE, col.names = FALSE)
} else {
	### Serious ERROR has occured if this is activated ###
	time <- as.character(now())
	str <- "A serious ERROR has occured in the COUNTIES COVID pipeline." 
	none <- paste(str, time)

	write.table(none, file = errorEnv, append = TRUE, row.names = FALSE, col.names = FALSE)
}


################################################################################################

# How up to date is the states table?
qStateMaxDate <- sqlQuery(con, "SELECT max(date) as maxDate FROM [COVID].[states]")
qStateMaxDate <- qStateMaxDate$maxDate


# Select only the new records from the github data
newStateRecords <- filter(states_csv, states_csv$date > qStateMaxDate)
head(newStateRecords)

stateRec <- count(newStateRecords)
stateRec <- as.numeric(stateRec)

if(stateRec > 0) {

	# Update to the STATE table and update the log with the date and 
	sqlSave(con, newStateRecords, tablename = "COVID.states", rownames = F, append = T)

	time <- as.character(now())
	str <- "New STATE records were ADDED on:" 
	newData <- as.character(paste(str, time))

	write.table(newData, file = logEnv, append = TRUE, row.names = FALSE, col.names = FALSE)
} else if (stateRec == 0) {
	# Print the date and time that the found no new data but operated successfully
	time <- as.character(now())
	str <- "No new STATE records to add." 
	none <- paste(str, time)

	write.table(none, file = logEnv, append = TRUE, row.names = FALSE, col.names = FALSE)
} else {
	### Serious ERROR has occured if this is activated ###
	time <- as.character(now())
	str <- "A serious ERROR has occured in the STATE COVID pipeline." 
	none <- paste(str, time)

	write.table(none, file = errorEnv, append = TRUE, row.names = FALSE, col.names = FALSE)
}

# Pull all STATE data from the database
stateDupChk <- sqlQuery(con, "SELECT * FROM [COVID].[states]")


################################################################################################

## CLEAN UP AFTER YOURSELF ##
odbcCloseAll() 

################################################################################################













################

# count <- sqlQuery(con, "SELECT max(date) as maxdate, count(distinct date) as recct FROM [COVID].[V_DailyCounty] group by date order by date desc")

#########
