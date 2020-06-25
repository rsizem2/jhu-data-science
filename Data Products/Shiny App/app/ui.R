library(shiny)
shinyUI(fluidPage(
    titlePanel("Visualizing Linear Regression with Knot Points"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("knot", "Pick the Knot Point",
                        -25, 25, value = c(0)),
            actionButton("clear", "Clear Points"),
            actionButton("toggle", "Toggle Knot")
        ),
        mainPanel(
            plotOutput("plot1", click = "plot_click")
        )
    )
))