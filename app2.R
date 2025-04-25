library(shiny)
library(tidyverse)

name_basics <- read_rds("data/name_basics_sample.rda")
title_principals <- read_rds("data/title_principals_sample.rda")
uniq_categories = unique(title_principals$category)

big_df = inner_join(name_basics, title_principals, by = "nconst")
print(big_df)

ui <- fluidPage(

    # Application title
    titlePanel("Template"),

    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("categories_selected", "Select Category:", 
                             choices = uniq_categories, 
                             selected = uniq_categories)
        ),

        mainPanel(
          plotOutput("plot")
        )
    )
)

server <- function(input, output, session) {
  my_df = reactive({
    filter(big_df, big_df$category %in% input$categories_selected)
    })

  
  output$plot <- renderPlot({
    temp_df = my_df()
    temp_df |>
    ggplot(aes(x = birthYear)) + 
      geom_bar() +
      labs(title = "Count of birth years based off selected categories") +
      theme_minimal()
  }, res = 96)
  

  
}

shinyApp(ui = ui, server = server)
