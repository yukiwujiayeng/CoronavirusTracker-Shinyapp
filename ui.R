navbarPage("World Coronavirus Tracker",
           tabPanel("Outbreak comparisons",fluidPage(theme = shinytheme("flatly")),
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar(
                      headerPanel('Outbreak comparisons'),
                      sidebarPanel(width = 4,
                                   selectInput("Country", 
                                               label = "Country",
                                               multiple = TRUE, 
                                               choices  = unique(df$Country),
                                               selected = c("United_Kingdom","United_States_of_America")
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
             title = " Data",
                    
             mainPanel(DT::dataTableOutput('ex1'),
                       downloadButton('download_trend', 'Download data', class = "down"))
             )
           
           
       
)        