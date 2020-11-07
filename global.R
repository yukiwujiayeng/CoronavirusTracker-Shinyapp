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
library(shinyWidgets)

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
                 Continent = dta$records$continentExp,
                 Geo_Id = dta$records$geoId )


# convert factor to string
df$Date <- as.character(df$Date)
df$Country <- as.character(df$Country)
df$Continent <- as.character(df$Continent)
df$Geo_Id <- as.character(df$Geo_Id)

# convert to Date
df$Date <- as_date(df$Date, format= "%d/%m/%Y" ) # convert to Date

#Rearrange df group by country
df<-df%>%
  group_by(Country) %>%
  
  #calculate the cumulative confirmed cases in each country
  mutate(cumulative_cases = rev(cumsum(rev(Cases)))) %>%
  
  ##calculate the cumulative confirmed cases in each country
  mutate(Cumulative_deaths = rev(cumsum(rev(Deaths))))

#Create Global data for Covid_19
Global_data<-df %>%
  
  group_by(Date)%>%
  
  #calculate the cumulative confirmed cases in the whole world by date
  mutate(cumulative_cases_by_date = rev(cumsum(rev(Cases)))) %>%

  ##calculate the cumulative deaths cases the whole world by date
  mutate(cumulative_deaths_by_date=rev(cumsum(rev(Deaths))))



