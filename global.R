library(httr)
library(rjson)
library(jsonlite)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(maps)
library(lubridate)
library(plotly)
library(ggplot2)
library(tidyverse)
library(datasets)

URL <-"https://opendata.ecdc.europa.eu/covid19/casedistribution/json"

# Send http request
response <- httr::GET(URL)
dtaJSON <- readBin(response$content, "text")
dta <- jsonlite::fromJSON(dtaJSON)

# Extract the relevant bits of data into a data frame
df <- data.frame(Country= dta$records$countriesAndTerritories, 
                 Cases  = dta$records$cases,
                 Deaths = dta$records$deaths,
                 Date   = dta$records$dateRep,
                 year   = dta$records$year,
                 Cumulative_number_for_14_days_of_COVID19_cases_per_100000 =dta$records$`Cumulative_number_for_14_days_of_COVID-19_cases_per_100000`,
                 Continent = dta$records$continentExp,
                 Geo_Id = dta$records$geoId )

# convert factor to numeric 
df$year <- as.numeric(as.character(df$year))
df$Cumulative_number_for_14_days_of_COVID19_cases_per_100000<- as.numeric(as.character(df$Cumulative_number_for_14_days_of_COVID19_cases_per_100000))

# convert factor to string
df$Date <- as.character(df$Date)
df$Country <- as.character(df$Country)
df$Continent <- as.character(df$Continent)
df$Geo_Id <- as.character(df$Geo_Id)

# convert to Date
df$Date <- as_date(df$Date, format= "%d/%m/%Y" ) # convert to Date



