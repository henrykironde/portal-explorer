#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
library(shiny)
library(rgl)
library(shinythemes)
library(dplyr)
library(ggplot2)
remotes::install_github("weecology/portalr")
library(portalr)
library(stats)
library(lubridate)
library(forecast)

#Define thumbnail dir
#Source additional pages

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("readable"),
                  
                  #Navbar to each page
                  navbarPage("Portal Explorer",
                             tabPanel("Time Series",uiOutput('time')),
                             tabPanel("Population Dynamics",uiOutput('population')),
                             tabPanel("Covariates",uiOutput('covariates')),
                             tabPanel("Seasonal Dynamics",uiOutput('seasonal'))
                  )))
