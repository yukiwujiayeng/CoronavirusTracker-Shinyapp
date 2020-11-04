function(input, output) {
  
  output$ex1 <- DT::renderDataTable(
    DT::datatable(df, options = list(pageLength = 15))
  )
  
  selectedData <- reactive({
    df %>%
      filter(Country %in% input$Country,
        Date == input$date
        )
    })
   
  trialdata<-reactive({
    
  })
  
  output$plot <- reactivePlot(
    
    function() {
      # check for the input variable
      if (input$type == "confirmed") {
        
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
      scale_x_discrete(name="Country")
    print(p)

    })
  
  }
 