function(input, output, session) {
  #Outbreak Comparison------
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
  
  #datatable Page-----
  #filter dataset for chosen country
  selectedData2 <- reactive({
    df %>%
      filter(Country %in% input$Country_data) %>%
      filter(Date >= input$Date_datatable[1] & Date <= input$Date_datatable[2])%>%
      select(,-"Geo_Id")
  })
  
  
  output$ex1 <- DT::renderDataTable(
    
    DT::datatable(selectedData2() , options = list(pageLength = 15))
  )
  
  # Downloadable csv of selected dataset 
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("Covid-19_data", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(selectedData2(), file, row.names = FALSE)
    }
  )
  
  #Region Plot Page-----
  # update region selections
  observeEvent(input$Level, {
    if (input$Level=="Global") {
      updatePickerInput(session = session, inputId = "Country_regionplots", 
                        choices = "Global", selected = "Global")
      
    }
    
    if (input$Level=="Country") {
      updatePickerInput(session = session, inputId = "Country_regionplots", 
                        choices = unique(df$Country),
                        selected =  c("United_Kingdom","United_States_of_America","France" ,"Italy") )
    }
  }, ignoreInit = TRUE)
  
  #Create Country data set for region plot page with filter
  country_plot_db <-reactive(
    df%>%
      filter(Country %in% input$Country_regionplots) %>%
      filter(Date >= input$Date_regionplots[1] & Date <= input$Date_regionplots[2])
  )
  
  #Create Global data set with date filter
  Global_plot_db <-reactive(
    as.data.frame(Global_data2)%>%
      filter(Date >= input$Date_regionplots[1] & Date <= input$Date_regionplots[2])
  )
  
  #Function of switching dataset for different level
  datasetInput_cumulative <- reactive({
    if (input$Level == "Country"){
      dataset <- country_plot_db()
    }
    else {
      dataset <- Global_plot_db()
    }
    return(dataset)
  })
  
  #function Filter type of data wanted for cumulative plot
  newData2 <- reactive({
    if (input$outcome_select == "Confirmed Cases") {
      a <- data.frame(Country = datasetInput_cumulative()$Country,
                             type = datasetInput_cumulative()$Cumulative_cases,
                             Date=datasetInput_cumulative()$Date)
    }
    else {
      a <- data.frame(Country =datasetInput_cumulative()$Country,
                             type = datasetInput_cumulative()$Cumulative_deaths,
                             Date=datasetInput_cumulative()$Date)
    }
    return(a)
  })
  
  ##function Filter type of data wanted for daily new cases plot
  newData3 <- reactive({
    if (input$outcome_select == "Confirmed Cases") {
      a <- data.frame(Country =datasetInput_cumulative()$Country,
                      type = datasetInput_cumulative()$Cases,
                      Date=datasetInput_cumulative()$Date)
    }
    else {
      a <- data.frame(Country =datasetInput_cumulative()$Country,
                      type = datasetInput_cumulative()$Deaths,
                      Date=datasetInput_cumulative()$Date)
    }
    return(a)
  })
  
  
  output$country_plot_cumulative <-renderPlotly({
    p <-ggplot(newData2(), aes(x=Date,y=type,col=Country))+
        geom_line()+
        labs(y=input$outcome_select)
    ggplotly(p)
      })
  
  
  output$country_plot_new <-renderPlotly({
    p <-ggplot(newData3(), aes(x=Date,y=type,col=Country))+
      geom_line()+
      labs(y=input$outcome_select)
    ggplotly(p)
  })
  
  
  }
 