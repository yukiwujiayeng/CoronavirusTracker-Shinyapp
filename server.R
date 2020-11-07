function(input, output) {
  #Outbreak Comparison
  selectedData <- reactive({
    df %>%
      filter(Country %in% input$Country,
        Date == input$date
        )
    })
  
  
  output$plot <- reactivePlot(
    
    function() {
      # check for the input variable
      if (input$type == "Confirmed") {
        
        newData <- data.frame(Country = selectedData()$Country,
                              Date = selectedData()$Date,
                              type = selectedData()$Cases)
      }
      else {
       
        newData <- data.frame(Country = selectedData()$Country,
                              Date = selectedData()$Date,
                              type = selectedData()$Deaths)
      }
      
    p <-ggplot(newData, aes(x=Country,y=type,fill=Country)) + 
      geom_bar(stat = "identity") +
      coord_flip() + scale_y_continuous(name="Cases") +
      scale_x_discrete(name="Country")+
      labs(title=paste("Number of",input$type,"case on",input$date))
    print(p)

    })
  #for datatable
  #filter dataset for chosen country
  selectedData2 <- reactive({
    df %>%
      filter(Country %in% input$Country_data) %>%
      filter(Date >= input$Date_datatable[1] & Date <= input$Date_datatable[2])%>%
      select(,-"Cumulative_number_for_14_days_of_COVID19_cases_per_100000")
  })
  
  
  output$ex1 <- DT::renderDataTable(
    
    DT::datatable(selectedData2() , options = list(pageLength = 15))
  )
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("Covid-19_data", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(selectedData2(), file, row.names = FALSE)
    }
  )
  
  }
 