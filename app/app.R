#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# 
# And a demonstration of how to create a URL-based, multi-page Shiny web site here:
#
#   https://github.com/open-meta/uiStub
#

library(shiny)
library(dplyr)
library(ggplot2)
remotes::install_github("weecology/portalr")
library(portalr)
library(stats)
library(lubridate)
library(forecast)




cat("portal-explorer started...\n")

ui <- uiOutput("uiStub")                                

server <- function(input, output, session) {
    cat("Session started.\n")                               
    onSessionEnded(function() {cat("Session ended.\n\n")})  
    
    # build menu; same on all pages
    output$uiStub <- renderUI(tagList( 
        fluidPage(                                  
            fluidRow(
                column(12,
                       HTML("<h3><a href='?time-series'>Time Series</a> | ",
                            "<a href='?covariates'>Covariates</a> |",
                            "<a href='?population-dynamics'>Population Dynamics</a> |",
                            "<a href='?seasonal-dynamics'>Seasonal Dynamics</a></h3>")
                )
            ),
            uiOutput("pageStub")
        )                                          
    ))
    
    # load server code for page specified in URL
    validFiles = c("time-series.R",                         
                   "covariates.R", 
                   "population-dynamics.R",
                   "seasonal-dynamics.R")                     
    
    fname = isolate(session$clientData$url_search)       
    if(nchar(fname)==0) { fname = "?time-series" }              
    fname = paste0(substr(fname, 2, nchar(fname)), ".R") 
    
    cat(paste0("Session filename: ", fname, ".\n"))      
    
    if(!fname %in% validFiles){                         
        output$pageStub <- renderUI(tagList(              
            fluidRow(
                column(5,
                       HTML("<h2>404 Not Found Error:</h2><p>That URL doesn't exist. Use the",
                            "menu above to navigate to the page you were looking for.</p>")
                )
            )
        ))
        return()
    }
    source(fname, local=TRUE)
}

# Run the application
shinyApp(ui = ui, server = server)

