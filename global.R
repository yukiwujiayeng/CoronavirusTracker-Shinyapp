library(httr)
library(rjson)
library(jsonlite)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(lubridate)
library(plotly)
library(ggplot2)
library(tidyverse)
library(datasets)
library(shinyWidgets)
library(zoo)


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
  mutate(Cumulative_cases = rev(cumsum(rev(Cases)))) %>%
  
  ##calculate the cumulative confirmed cases in each country
  mutate(Cumulative_deaths = rev(cumsum(rev(Deaths))))


#Create total Global  data by date for Covid_19
Global_data<-df %>%
  
  group_by(Date)%>%
  
  #calculate the total confirmed cases in the whole world by date
  mutate(total_cases_by_date = rev(cumsum(rev(Cases)))) %>%

  ##calculate the total deaths cases the whole world by date
  mutate(total_deaths_by_date = rev(cumsum(rev(Deaths))))%>%
  
  #extract each date data
  distinct(Date,.keep_all = TRUE)%>%
  
  select(Date,total_cases_by_date,total_deaths_by_date )

#global data with cumulative data of confirmed and seaths cases
Global_data2 <- tibble(Date=Global_data$Date,
             Cases=Global_data$total_cases_by_date,
             Deaths=Global_data$total_deaths_by_date,
             Cumulative_cases=rev(cumsum(rev(Cases))),
             Cumulative_deaths=rev(cumsum(rev(Deaths))),
             Country="Global")
  



