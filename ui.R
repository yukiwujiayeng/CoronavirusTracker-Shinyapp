navbarPage("World Coronavirus Tracker",
           
           #Outbreak comparisons page
           tabPanel("Outbreak comparisons",fluidPage(theme = shinytheme("flatly")),
                    pageWithSidebar(
                      headerPanel('Outbreak comparisons'),
                      
                      sidebarPanel(width = 4,
                                   tags$h6("Reported cases are subject to significant variation in testing policy and capacity between countries."),
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
                                   ),
                      mainPanel( plotOutput("plot"))
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
                            tags$h6("Download data in CSV file")
                          ),
                    
             mainPanel(DT::dataTableOutput('ex1'))
             )
           ),
           
           #Region plot page
           tabPanel(
             title = " Region plot",fluidPage(theme = shinytheme("flatly")),
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
                                        selected = c("United_Kingdom","United_States_of_America","France" ,"Italy" )
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
                            "Select Data types, Country, and plotting date range from filter menues to update plots."
               ),
               
               mainPanel(
                 tabsetPanel(
                   tabPanel("Cumulative Data", plotlyOutput("country_plot_cumulative")),
                   tabPanel("New Cases", plotlyOutput("country_plot"))
                 )
               )
             )
           )
           
           
           
           
       
)        