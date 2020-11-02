function(input, output) {
  
  output$ex1 <- DT::renderDataTable(
    DT::datatable(df, options = list(pageLength = 15))
  )
 }
 