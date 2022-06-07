library(shiny)
library(forecast)

ui <- shinyUI(
    fluidPage(
        titlePanel("fcast"),
        sidebarLayout(
            sidebarPanel(
                selectInput(
                    inputId = "dataset",
                    label = "Dataset:",
                    choices = c("AirPassengers", "WWWusage")
                ),
                numericInput(
                    inputId = "h",
                    label = "Forecast horizon:",
                    value = 10
                ),
                checkboxInput(
                    inputId = "box_cox",
                    label = "Box-Cox",
                )
            ),
            mainPanel(
                plotOutput("forecastPlot")
            )
        )
    )
)

server <- shinyServer(function(input, output) {
    output$forecastPlot <- renderPlot({
        get(input$dataset) |>
            forecast(h = input$h, lambda = if (input$box_cox) "auto") |>
            plot()
    })
})

shinyApp(ui = ui, server = server)
