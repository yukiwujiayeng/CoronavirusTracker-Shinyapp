navbarPage("World Coronavirus Tracker",
           tabPanel("Outbreak comparisons",fluidPage(theme = shinytheme("flatly")),
                    #tags$head(
                     # tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar(
                      headerPanel('Outbreak comparisons'),
                      sidebarPanel(width = 4,
                                   selectInput("Country", 
                                               label = "Country",
                                               multiple = TRUE, 
                                               choices  = unique(df$Country),
                                               selected = c("United_States_of_America","India","United_Kingdom","France")
                                               ),
                                   selectInput(
                                     "type", 
                                     label    = "type", 
                                     choices  = c("confirmed", "deaths")
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
                            downloadButton("downloadData", "Download")
                          ),
                    
             mainPanel(DT::dataTableOutput('ex1'))
             )
           )
           
           
       
)        