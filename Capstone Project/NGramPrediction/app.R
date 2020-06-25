#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidytext)
library(data.table)
library(dplyr)
library(dtplyr)

load(file = "data/data2.RData")

# Define UI for application that predicts the next word
ui <- fluidPage(

    # Application title
    titlePanel('Word Prediction Using "Stupid Backoff"'),

    # Sidebar Layout 
    sidebarLayout(
        sidebarPanel(
            textInput("string", "Enter Text"),
            sliderInput("lambda", "Backoff Parameter", min = 0, max = 1, value = 0.4),
            checkboxInput("checkbox", "Suggest Stop Words?", value = TRUE),
            actionButton("action", "Generate Prediction"),
            helpText("How to use:"),
            helpText("1. Enter partial English phrase."),
            helpText("2. Adjust backoff parameter."),
            helpText("3. Click 'Generate Prediction' button."),
            helpText("Tips:"),
            helpText("Use well-formed English phrases"),
            helpText("Large parameter values favor words"),
            helpText("Small values favor trigrams/bigrams")
        ),

        # Main Panel Layout
        mainPanel(
            #titlePanel("Prediction:"),
            textOutput("testtext"),
            tableOutput("predicted"),
            tableOutput("alternatives")
        )
    )
)

# Define server logic for splitting input and displaying  table output
server <- function(input, output) {
    
    
    # Default Reactive Values 
    values <- reactiveValues(first = NULL,
                             middle = NULL, 
                             last = NULL,
                             data = list(),
                             word = data.table(),
                             alts = data.table()
                             )
    
        
    # Execute after user presses Action Button
    observeEvent(input$action,{
        
        # Trim and split input string
        temp_string <- tolower(input$string)
        temp_string <- gsub("[.,]","",temp_string)
        temp_string <- trimws(temp_string)
        temp_string <- strsplit(temp_string, split = " ")[[1]]
        
        # Extract last three words, if they exist
        values$first <- nth(temp_string, n = -3L, default = NULL)
        values$middle <- nth(temp_string, n = -2L, default = NULL)
        values$last <- nth(temp_string, n = -1L, default = NULL)
        
        # Determine if N-grams formed from input exist in our data 
        one_match <- !is.null(values$last) && (values$last %in% bigrams$word1)
        two_matches <- !is.null(values$middle) && one_match && (values$middle %in% trigrams$word2)
        three_matches <- !is.null(values$first) && two_matches && (values$first %in% fourgrams$word3)
        
        # Temp variable for storing data
        temp <- list()
        
        # Filter data and adjust scores appropriately
        if(!one_match){
            # word not found
            temp$unigrams <- unigrams %>%
                mutate(stopword = stopwords)
            
        } else if(three_matches){
            #Trigram Found
            
            # filter bigrams and adjust score
            temp$bigrams <- bigrams %>%
                filter(word1 == values$last) %>%
                mutate(score = score*(input$lambda)^2) %>%
                transmute(word = word2,
                          score = score,
                          stopword = stopwords)
            
            # filter trigrams and adjust score
            temp$trigrams <- trigrams %>%
                filter(word1 == values$middle,
                       word2 == values$last) %>%
                mutate(score = input$lambda*score) %>%
                transmute(word = word3,
                          score = score,
                          stopword = stopwords)
            
            #filter fourgrams
            temp$fourgrams <- fourgrams %>%
                filter(word1 == values$first,
                       word2 == values$middle,
                       word3 == values$last) %>%
                transmute(word = word4,
                          score = score,
                          stopword = stopwords)
            
        } else if (two_matches) {
            #Only Bigram Found
            
            # filter bigrams and adjust score
            temp$bigrams <- bigrams %>%
                filter(word1 == values$last) %>%
                mutate(score = input$lambda*score) %>%
                transmute(word = word2,
                          score = score,
                          stopword = stopwords)
            
            # filter trigrams
            temp$trigrams <- trigrams %>%
                filter(word1 == values$middle,
                       word2 == values$last) %>%
                transmute(word = word3,
                          score = score,
                          stopword = stopwords)
            
        } else {
            #Only Word Found
            
            # list to store unigram, bigram, trigram tables
            values$data <- list()
            
            # filter bigrams 
            temp$bigrams <- bigrams %>%
                filter(word1 == values$last) %>%
                transmute(word = word2,
                          score = score,
                          stopword = stopwords)
        }
        
        # Bind Data Tables
        temp <- rbindlist(temp)
        
        # Manage stop words
        if(input$checkbox == TRUE){
            values$data <- temp %>%
                transmute(word = word,
                          score = score) %>%
                arrange(desc(score)) %>%
                distinct(word, .keep_all = TRUE) %>%
                head()
        } else {
            values$data <- temp %>%
                filter(stopword == FALSE) %>%
                transmute(word = word,
                          score = score) %>%
                arrange(desc(score)) %>%
                distinct(word, .keep_all = TRUE) %>%
                head()
        }
        
        values$word <- values$data[1,] %>%
            transmute(suggestion = word,
                      score = score)
        values$alts <- values$data[-1,] %>%
            transmute(alternatives = word,
                      score = score)
        
        })
    
    output$predicted <- renderTable({
        return(values$word)
    }, digits = 5)
    
    output$alternatives <- renderTable({
        return(values$alts)
    }, digits = 5)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
