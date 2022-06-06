library(forecast)

shinyServer(function(input, output) {
  output$forecastPlot <- renderPlot({
    get(input$dataset) |>
      forecast(h = input$h) |>
      plot()
  })
})
