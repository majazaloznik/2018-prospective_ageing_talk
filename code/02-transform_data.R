##=============================================================================
## 00. preliminaries ==========================================================
## 01. data import ============================================================
## 02. data interpolation =====================================================
## 03. data transformation ====================================================
##=============================================================================

## 00. preliminaries ==========================================================
library(readr)
library(dplyr)
library(tidyr)

## 01. data import  =========================================================
# import population data 
pop <- readRDS(here::here("data/interim/pop.rds"))

# import prospective age data 
prospective_age <- readRDS(here::here("data/interim/prosp.age.rds"))

## 02. data transformation===================================================
# turn into percent instead of proportions
pop %>% 
  rename(location = Location,
         time = Time) %>% 
  group_by(location, time) %>% 
  mutate(prop_male = 100*PopMale/sum(PopTotal),
         prop_female = 100*PopFemale/sum(PopTotal)) %>% 
  select(-starts_with("Pop")) -> pop

# get threshold data ready for plotting 
prospective_age %>% 
  select(location, time, threshold_total, threshold_female, threshold_male) -> thresholds

# get proportion data ready for plotting
prospective_age %>%  
  select(location, time, starts_with("prop")) -> prop.over


## 03. save data for plotting  ================================================
saveRDS(pop, here::here("data/processed/pop.rds"))
saveRDS(prop.over, here::here("data/processed/prop.over.rds"))
saveRDS(thresholds, here::here("data/processed/threshold.1y.rds"))


