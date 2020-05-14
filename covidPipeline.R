library("tidyverse")
library("RODBC")
library("sqldf")
library("stringr")
library("readr")


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

datset_states_url <- "https://github.com/nytimes/covid-19-data/raw/master/us-states.csv"


counties_csv <- read_csv(url(dataset_counties_url))

states _csv <- read_csv(url(dataset_states_url))

################################################################################################


### Use environmental variables for authentication ### 
u <- Sys.getenv("A_SSMS_Login")
p <- Sys.getenv("A_SSMS_PWD")

con <- odbcConnect("covidSQLPipe", uid = u, pwd = p)


# test  <- sqlQuery(con, "SELECT * FROM [COVID].[counties]")


qMaxDate <- 





## CLEAN UP AFTER YOURSELF ##
odbcCloseAll() 
