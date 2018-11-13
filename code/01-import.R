##=============================================================================
## 00. preliminaries ==========================================================
## 01. data import ============================================================
## 02. data subset  ===========================================================
## 03. save output ============================================================
##=============================================================================

## 00. preliminaries ==========================================================
library(readr)
library(dplyr)

## 01. data import  ===========================================================
# manual data frame of countries used in the analysis
cntryz <- c("Georgia", "Belarus", "Slovenia", "Japan", "Italy",
            "China", "Korea","United States", "Spain", "United Kingdom")

# import prospective age data
propsective_age <- read_csv(here::here("data/raw/2017_prospective-ages.csv"))


## 02. data subset  ===========================================================
# select only cases and variables needed
pop %>% 
  filter(Location %in% cntryz) %>% 
  select(Location, Time, AgeGrp, starts_with("Pop")) -> pop

propsective_age %>% 
  filter(location %in% cntryz) -> prosp_age

## 03. save output ============================================================
# save population data for mena countires
saveRDS(pop, here::here("data/interim/pop.rds"))
saveRDS(prosp_age, here::here("data/interim/prosp.age.rds"))

