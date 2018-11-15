#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinythemes)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("superhero"),
  tags$h1("Level 1 header"),
  h1(em("Level 1 header part 2")),
  HTML("<h1>Level 1 header Part 3</h1>"),
  tags$blockquote("Tidy data sets are all the same. Each messy data set is messy in its own way.", cite = "Hadley Wickham"),
  tags$code("This text will be displayed as computer code."),
  tags$hr(),
  titlePanel("BC Liquor price app", 
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", h3("Select your desired price range."),
                  min = 0, max = 100, value = c(15, 30), pre="$"),
      radioButtons("typeInput", "Select your type of beverage",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE")
      ),
    mainPanel(
      plotOutput("price_hist"),  
      tableOutput("bcl_data")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  bcl_filtered <- reactive( 
    bcl %>% 
      filter(Price < input$priceInput[2], 
             Price > input$priceInput[1], 
             Type == input$typeInput)
  )
  output$price_hist <- renderPlot({
    bcl_filtered() %>% 
      ggplot(aes(Price)) + 
      geom_histogram()
  })
  output$bcl_data <- renderTable(bcl)
}

# Run the application 
shinyApp(ui = ui, server = server)
