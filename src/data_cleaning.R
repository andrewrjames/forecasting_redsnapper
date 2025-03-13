library(dplyr)
library(fpp)
library(forecast)
library(tidyverse)


getwd()
landing = read.csv('Red Snapper 2007 - 2023 - landing.csv')
allocation = read.csv('Red Snapper 2007 - 2023 - allocation price.csv')
vessel = read.csv('Red Snapper 2007 - 2023 - ex-vessel price.csv')

landing_df = landing %>% pivot_longer(col = - Month, names_to = 'Months', values_to = 'landings') %>% 
  rename(year = Month, month = Months) %>% 
  mutate(landings = as.numeric(gsub(",", "", landings)), 
         month = ifelse(is.na(match(month, month.abb)), 9, match(month, month.abb)))


month_levels <- c("January", "February", "March", "April", "May", "June",
                  "July", "August", "September", "October", "November", "December")

allocation_df <- allocation %>% pivot_longer(col = -Month, names_to = 'Year', values_to = 'allocation_price') %>%
  mutate(Year = as.numeric(str_remove(Year, "X")), 
         Month = factor(Month, levels = month_levels)) %>%
  select(Year, Month, allocation_price) %>%
  rename(year_alloc = Year, month_alloc = Month) %>%
  arrange(year_alloc, month_alloc) 


month_level <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sept", "Oct", "Nov", "Dec")

vessel_df = 
  vessel %>% pivot_longer(cols = -Month, names_to = 'year', values_to = 'vessel_price') %>%
  mutate(year = as.numeric(str_remove(year, "X")), Month = factor(Month, levels = month_level)) %>%
  rename(year_vessel = year, month_vessel = Month) %>%
  select(year_vessel, month_vessel, vessel_price) %>%
  arrange(year_vessel, month_vessel)


red_snapper = cbind(landing_df, allocation_df, vessel_df) %>% select(year, month, landings, allocation_price, vessel_price)

save(red_snapper, file = "red_snapper.rda")
