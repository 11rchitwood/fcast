library(forecast)

shinyServer(function(input, output) {
    observeEvent(input$dataset, {
        obj <- get(input$dataset)

        new_h <- ifelse(frequency(obj) > 1, 2 * frequency(obj), 10)
        updateNumericInput(inputId = "h", value = new_h)

        output$forecastPlot <- renderPlot({
            obj |>
                forecast(h = input$h, lambda = if (input$box_cox) "auto") |>
                plot()
        })
    })
})
