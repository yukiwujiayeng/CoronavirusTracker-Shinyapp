navbarPage("World Coronavirus Tracker",
           tabPanel("Covid-19 mapper",fluidPage(theme = shinytheme("flatly")),
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar(
                      headerPanel('Apply filters'),
                      sidebarPanel(width = 4,
                                   selectInput("Country", 
                                               label = "Country",
                                               multiple = TRUE, 
                                               choices  = unique(df$Country),
                                               selected = "Italy"
                                               ),
                                   selectInput(
                                     "type", 
                                     label    = "type", 
                                     choices  = c("confirmed", "recovered", "deaths")
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
             title = " Data",
                    
             mainPanel(DT::dataTableOutput('ex1'),
                       downloadButton('download_trend', 'Download data', class = "down"))
             )
       
)        