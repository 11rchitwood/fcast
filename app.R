library(shiny)
library(forecast)
library(tidyverse)

ts_datasets <- data()$results |>
  as_tibble() |>
  transmute(name = str_split(Item, " ")) |>
  mutate(name = map_chr(name, 1)) |>
  mutate(obj = map(name, get)) |>
  mutate(class = map(obj, class)) |>
  mutate(is_ts = map_lgl(class, ~ "ts" %in% .x)) |>
  filter(is_ts) |>
  pull(name)

ui <- shinyUI(
  fluidPage(
    titlePanel("fcast"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "dataset",
          label = "Dataset:",
          choices = ts_datasets
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

shinyApp(ui = ui, server = server)
