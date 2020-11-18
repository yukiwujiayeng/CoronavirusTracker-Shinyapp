navbarPage("World Coronavirus Tracker",
           
           #--------------------------Daily Outbreak page------------------------------
           tabPanel("Daily Outbreak",fluidPage(theme = shinytheme("flatly")),
                    pageWithSidebar(
                      headerPanel('Apply Filters'),
                      
                      sidebarPanel(width = 4,
                                   h6("Reported cases are subject to significant variation in testing policy and capacity between countries."),
                                   
                                   #Country filter
                                   selectInput("Country", 
                                               label = "Country",
                                               multiple = TRUE, 
                                               choices  = unique(df$Country),
                                               selected = c("United_States_of_America","India","United_Kingdom","France")
                                               ),
                                   
                                   # Data type filter (Confimed  or Deaths Cases)
                                   selectInput(
                                     "type", 
                                     label    = "Type", 
                                     choices  = c("Confirmed", "Deaths")
                                    ),
                                   
                                   #Date filter
                                   selectInput(
                                     "date", 
                                     label    = "Date", 
                                     choices  = unique(df$Date)
                                     ),
                                   
                                   #refresh button
                                   actionButton(inputId = "refresh", 
                                                label = "Refresh",
                                                icon = icon("sync")),
                                   
                                   ),
                      
                      mainPanel( withSpinner(plotlyOutput("plot")),
                                h5("Note:"),
                                h5("If negative deaths or confirmed case number occurs in this plot, this is due the recorrection of the data or removal of cases detected from rapid tests of that country. ")
                                
                                 )
                    )
           ),
           
           #-----------------------------datatable page----------------------------------
           tabPanel(
             title = " Data",fluidPage(theme = shinytheme("flatly")),
             pageWithSidebar(
               headerPanel('Apply Filters'),
               sidebarPanel(width = 4,
                            
                            #Country filter
                            selectInput("Country_data", 
                                        label = "Country",
                                        multiple = TRUE, 
                                        choices  = unique(df$Country),
                                        selected = c("United_Kingdom","United_States_of_America","France" ,"Italy" )
                            ),
                            
                            #Date range filter
                            dateRangeInput(
                              "Date_datatable", 
                              label    = "Date", 
                              start    = "2020-01-01"
                            ),
                           
                            #Download button
                            downloadButton("downloadData", "Download"),
                            h6("Download data in CSV file"),
                            
                            #Refresh button
                            actionButton(inputId = "refresh02", 
                                         label = "Refresh",
                                         icon = icon("sync")),
                            h5("Note:"),
                            h5("The negative value for deaths or confirmed case number on this data table is due the recorrection of the data or removal of cases detected from rapid tests of that country."),
               
                          ),
             #data table output       
             mainPanel(DT::dataTableOutput('ex1'))
                    
             )
           ),
           
           #--------------------------Outbreak comparisons----------------------------------------
           
           tabPanel(
             title = "Outbreak comparisons",fluidPage(theme = shinytheme("flatly")),
             pageWithSidebar(
               headerPanel('Apply Filters'),
               sidebarPanel(width = 4,
                            span(tags$i(h6("Reported cases are subject to significant variation in testing policy and capacity between countries.")), style="color:#045a8d"),
                            
                            #Data level filter
                            pickerInput("Level", 
                                        label = "Level",
                                        multiple = FALSE, 
                                        choices  = c("Global","Country"),
                                        selected = c("Country" )
                            ),
                            
                            #Country filter
                            pickerInput("Country_regionplots", 
                                        label = "Country",
                                        multiple = TRUE, 
                                        choices  = unique(df$Country),
                                        selected = c("United_Kingdom","United_States_of_America","Germany","Italy","India" )
                            ),
                            
                            # Data type filter (Confimed  or Deaths Cases)
                            pickerInput("outcome_select", 
                                        label = "Data Type:",   
                                        choices = c("Confirmed Cases", "Deaths Cases"), 
                                        selected = c("Confirmed Cases"),
                                        multiple = FALSE),
                            
                            #Date range filter
                            dateRangeInput(
                              "Date_regionplots", 
                              label    = "Date", 
                              start    = "2020-01-01"
                            ),
                            
                            span(tags$i(h6("Select Data types, Country, and plotting date range from filter menues to update plots.\n\n")), style="color:#045a8d"),
        
                            #Refresh button
                            actionButton(inputId = "refresh03", 
                                         label = "Refresh",
                                         icon = icon("sync")),
                            
               ),
               
              
               mainPanel(
                 tabsetPanel(
                   navbarMenu("Daily Cases",
                              
                              #2 drop down choices in this tab
                              tabPanel("Linear", withSpinner(plotlyOutput("country_plot_new"))),
                              tabPanel("3 Day Rolling Log" , withSpinner(plotlyOutput("country_plot_new_log")))),
                   
                   navbarMenu("Cumulative Data",
                              
                              #2 drop down choices in this tab
                              tabPanel("Linear", withSpinner(plotlyOutput("country_plot_cumulative"))),
                              tabPanel("Log" , withSpinner(plotlyOutput("country_plot_cumulative_log")))),
                   
                   h5("Note:"),
                   h5("The negative deaths or confirmed case number occurs in this plot,is due the recorrection of the data or removal of cases detected from rapid tests of that country. ")
                   
                 )
               )
             )
           )
           
           
           
       
)        