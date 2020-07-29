#functions
library(dplyr)
library(ggplot2)

#Load data
load_raw<-function(){
  # Data setup
  portal_data <- load_rodent_data()
  abundances <- abundance(shape = "long", time = "period", clean = FALSE) %>% 
    inner_join(portal_data$species_table, by = "species") %>%
    left_join(portal_data$newmoons_table, by = "period") %>%
    mutate(censusdate = as.Date(censusdate))
  species_list <- unique(abundances$scientificname)
  species_list <- sort(species_list)
  min_date <- min(abundances$censusdate)
  max_date <- max(abundances$censusdate)
  
  ndvi_dat <- ndvi(level = "monthly", fill = FALSE) %>%
    mutate(year = year(date), month = month(date)) 
  
  weath_dat <- weather(level = "monthly", fill = FALSE) %>%
    full_join(ndvi_dat, by = c("year", "month")) %>%
    select(year, month, mintemp, maxtemp, meantemp, precipitation, ndvi) %>%
    mutate(date = ymd(paste(year,month,01)))
  
  full_dat <- abundances %>%
    mutate(censusdate = ymd(censusdate)) %>%
    mutate(year = year(censusdate), month = month(censusdate)) %>%
    left_join(weath_dat, by = c("year", "month")) %>%
    select(-"date") %>%
    rename(date = censusdate)
  return(full_dat)
}


