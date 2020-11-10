navbarPage("World Coronavirus Tracker",
           
           #Outbreak comparisons page
           tabPanel("Daily Outbreak",fluidPage(theme = shinytheme("flatly")),
                    pageWithSidebar(
                      headerPanel('Apply Filters'),
                      
                      sidebarPanel(width = 4,
                                   h6("Reported cases are subject to significant variation in testing policy and capacity between countries."),
                                   selectInput("Country", 
                                               label = "Country",
                                               multiple = TRUE, 
                                               choices  = unique(df$Country),
                                               selected = c("United_States_of_America","India","United_Kingdom","France")
                                               ),
                                   selectInput(
                                     "type", 
                                     label    = "Type", 
                                     choices  = c("Confirmed", "Deaths")
                                    ),
                                   
                                   selectInput(
                                     "date", 
                                     label    = "Date", 
                                     choices  = unique(df$Date)
                                     ),
                                   
                                   actionButton(inputId = "refresh", 
                                                label = "Refresh",
                                                icon = icon("sync"))
                                   
                                   ),
                      mainPanel(plotlyOutput("plot"),
                                h5("Note:"),
                                h5("If negative deaths or confirmed case number occurs in this plot, this is due the recorrection of the data or removal of cases detected from rapid tests of that country. ")
                                
                                 )
                    )
           ),
           
           #datatable page
           tabPanel(
             title = " Data",fluidPage(theme = shinytheme("flatly")),
             pageWithSidebar(
               headerPanel('Apply Filters'),
               sidebarPanel(width = 4,
                            selectInput("Country_data", 
                                        label = "Country",
                                        multiple = TRUE, 
                                        choices  = unique(df$Country),
                                        selected = c("United_Kingdom","United_States_of_America","France" ,"Italy" )
                            ),
                            dateRangeInput(
                              "Date_datatable", 
                              label    = "Date", 
                              start    = "2020-01-01"
                            ),
                           
                            downloadButton("downloadData", "Download"),
                            h6("Download data in CSV file"),
                            
                            actionButton(inputId = "refresh", 
                                         label = "Refresh",
                                         icon = icon("sync")),
                            h5("Note:"),
                            h5("The negative value for deaths or confirmed case number on this data table is due the recorrection of the data or removal of cases detected from rapid tests of that country."),
               
                          ),
                    
             mainPanel(DT::dataTableOutput('ex1'))
                    
             )
           ),
           
           #Region plot page
           tabPanel(
             title = "Outbreak comparisons",fluidPage(theme = shinytheme("flatly")),
             pageWithSidebar(
               headerPanel('Apply Filters'),
               sidebarPanel(width = 4,
                            span(tags$i(h6("Reported cases are subject to significant variation in testing policy and capacity between countries.")), style="color:#045a8d"),
                            pickerInput("Level", 
                                        label = "Level",
                                        multiple = FALSE, 
                                        choices  = c("Global","Country"),
                                        selected = c("Country" )
                            ),
                            
                            pickerInput("Country_regionplots", 
                                        label = "Country",
                                        multiple = TRUE, 
                                        choices  = unique(df$Country),
                                        selected = c("United_Kingdom","United_States_of_America","France" ,"Italy","India" )
                            ),
                            pickerInput("outcome_select", 
                                        label = "Data Type:",   
                                        choices = c("Confirmed Cases", "Deaths Cases"), 
                                        selected = c("Confirmed Cases"),
                                        multiple = FALSE),
                            dateRangeInput(
                              "Date_regionplots", 
                              label    = "Date", 
                              start    = "2020-01-01"
                            ),
                            
                            span(tags$i(h6("Select Data types, Country, and plotting date range from filter menues to update plots.\n\n")), style="color:#045a8d"),
        
                            actionButton(inputId = "refresh", 
                                         label = "Refresh",
                                         icon = icon("sync")),
                            
               ),
               
               mainPanel(
                 tabsetPanel(
                   navbarMenu("Daily Cases",
                              tabPanel("Linear", plotlyOutput("country_plot_new")),
                              tabPanel("Log" , plotlyOutput("country_plot_new_log"))),
                   
                   navbarMenu("Cumulative Data",
                              tabPanel("Linear", plotlyOutput("country_plot_cumulative")),
                              tabPanel("Log" , plotlyOutput("country_plot_cumulative_log"))),
                   
                   h5("Note:"),
                   h5("The negative deaths or confirmed case number occurs in this plot, this is due the recorrection of the data or removal of cases detected from rapid tests of that country. ")
                   
                 )
               )
             )
           )
           
           
           
       
)        