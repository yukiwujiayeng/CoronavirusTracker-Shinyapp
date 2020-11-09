function(input, output, session) {
  
  # Anything that calls autoInvalidate will automatically update every hour
  timer <- reactiveTimer(3600000)
  
  #Outbreak Comparison------
  selectedData <- reactive({
    
    #SelectData update everyhour
    timer()
    
    #Observe if refresh button is pressed
    input$refresh

    #Add filter on the selected input
    df %>%
      filter(Country %in% input$Country,
        Date == input$date
        )
    })
  
  #function Filter type of data wanted for bar chart
  newData <- reactive({
    
    timer()
    input$refresh
    
    if (input$type == "Confirmed") {
      
     u <- data.frame(Country = selectedData()$Country,
                            Date = selectedData()$Date,
                            type = selectedData()$Cases)
    }
    else {
      
      u <- data.frame(Country = selectedData()$Country,
                            Date = selectedData()$Date,
                            type = selectedData()$Deaths)
    }
    
    return(u)
    
  })
  
  output$plot <- renderPlotly({
    p <-ggplot(newData(), aes(x=Country,y=type,fill=Country)) + 
      geom_bar(stat = "identity") +
      coord_flip() + scale_y_continuous(name="Cases") +
      scale_x_discrete(name="Country")+
      labs(title=paste("Number of",input$type,"case on",input$date))
    ggplotly(p)

    })
  
  
  #datatable Page-----
  #filter dataset for chosen country
  selectedData2 <- reactive({
    
    #update cselectedData2 every hour
    timer()
    input$refresh
    
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
  country_plot_db <-reactive({
    
    #update country_plot_db every hour
    timer()
    input$refresh

    df%>%
      filter(Country %in% input$Country_regionplots) %>%
      filter(Date >= input$Date_regionplots[1] & Date <= input$Date_regionplots[2])
  })
  
  #Create Global data set with date filter
  Global_plot_db <-reactive({
    
    #update Global_plot_db every hour
    timer()
    input$refresh

    as.data.frame(Global_data2)%>%
      filter(Date >= input$Date_regionplots[1] & Date <= input$Date_regionplots[2])
  })
  
  #Function of switching dataset for different level
  datasetInput_cumulative <- reactive({
    
    timer()
    input$refresh

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
    
    timer()
    input$refresh

    
    if (input$outcome_select == "Confirmed Cases") {
      a <- data.frame(Country = datasetInput_cumulative()$Country,
                             typenumber = datasetInput_cumulative()$Cumulative_cases,
                             Date=datasetInput_cumulative()$Date)
    }
    else {
      a <- data.frame(Country =datasetInput_cumulative()$Country,
                             typenumber = datasetInput_cumulative()$Cumulative_deaths,
                             Date=datasetInput_cumulative()$Date)
    }
    return(a)
  })
  
  ##function Filter type of data wanted for daily new cases plot
  newData3 <- reactive({
    
    timer()
    input$refresh

    
    if (input$outcome_select == "Confirmed Cases") {
      a <- data.frame(Country =datasetInput_cumulative()$Country,
                      typenumber = datasetInput_cumulative()$Cases,
                      Date=datasetInput_cumulative()$Date)
    }
    else {
      a <- data.frame(Country =datasetInput_cumulative()$Country,
                      typenumber = datasetInput_cumulative()$Deaths,
                      Date=datasetInput_cumulative()$Date)
    }
    return(a)
  })
  
  #cumulative line plot
  output$country_plot_cumulative <-renderPlotly({
    p <-ggplot(newData2(), aes(x=Date,y=typenumber,col=Country))+
        geom_line()+
        labs(y=input$outcome_select)
    ggplotly(p)
      })
  #Cumulative log plot
  output$country_plot_cumulative_log <-renderPlotly({
    p <-ggplot(newData2(), aes(x=Date,y=log10(typenumber),col=Country))+
      geom_line()+
      labs(y=input$outcome_select)
    ggplotly(p)
  })
  
  #Daily Cases line plot
  output$country_plot_new <-renderPlotly({
    p <-ggplot(newData3(), aes(x=Date,y=typenumber,col=Country))+
      geom_line()+
      labs(y=input$outcome_select)
    ggplotly(p)
  })
 
 #Prevent the log plot get to negative infinite or NaNs so 
  #change all cases number<=0 to 1 so that ln(1)=0
 newData4<-reactive({
   newData3() %>%
     mutate(typenumber=replace(typenumber, typenumber<=0, 1)) %>%
     as.data.frame()
 })
  #Daily Cases log plot
  output$country_plot_new_log <-renderPlotly({
    p <-ggplot(newData4(), aes(x=Date,y=log10(typenumber),col=Country))+
      geom_line()+
      labs(y=input$outcome_select)
      
    ggplotly(p)
  })
  
  
  }
 