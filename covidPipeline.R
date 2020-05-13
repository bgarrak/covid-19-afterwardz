library("tidyverse")
library("RODBC")
library("sqldf")
library("stringr")


# Need these libraries, install if not found #
if(!require(tidyverse)){install.packages("tidyverse")
	library(tidyverse)}
if(!require(RODBC)){install.packages("RODBC")
	library(RODBC)}
if(!require(sqldf)){install.packages("sqldf")
	library(sqldf)}
if(!require(stringr)){install.packages("stringr")
	library(stringr)}


setwd <- "Z:/covidData/"


### Use environmental variables for authentication ### 
u <- Sys.getenv("A_SSMS_Login")
p <- Sys.getenv("A_SSMS_PWD")


ch <- odbcConnect("wardzwall.database.windows.net", uid = u, pwd = p)

