shinyUI(
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
        )
      ),
      mainPanel(
        plotOutput("forecastPlot")
      )
    )
  )
)
