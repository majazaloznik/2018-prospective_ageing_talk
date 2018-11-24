##=============================================================================
## 00. preliminaries ==========================================================
## 01. plotting thresholds ====================================================
## 02. plotting proportions over 65 ===========================================
##=============================================================================

## 00. preliminaries ==========================================================
library(readr)
library(dplyr)
library(tidyr)
## 01. data import  ===========================================================
# manual data frame of countries used in the analysis
cntryz <- c("Ukraine", "Belarus", "United Kingdom", "Japan")

# import prospective age data
prospective_age <- read_csv(here::here("data/raw/2017_prospective-ages.csv"))

# import population counts
pop <- read_csv(here::here("data/raw/WPP2017_PBSAS.csv"))

## 02. data subset  ===========================================================
# select only cases and variables needed
pop %>% 
  filter(Location %in% cntryz) %>% 
  select(Location, Time, AgeGrp, starts_with("Pop")) -> pop

prospective_age %>% 
  filter(location %in% cntryz) -> prosp_age

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
prosp_age %>% 
  select(location, time, threshold_total, threshold_female, threshold_male) -> threshold.1y

# get proportion data ready for plotting
prosp_age %>%  
  select(location, time, starts_with("prop")) -> prop.over


library(dplyr)
library(magrittr)
library(tidyr)
library(ggplot2)
library(gganimate)
source(here::here("code/FunPlots.R"))



# age group is character and has 80+ as an option, fix it:
pop %>% 
  mutate(AgeGrp = ifelse(AgeGrp == "80+", 80, AgeGrp),
         AgeGrp = as.numeric(AgeGrp)) -> pop


## 04. plots for Katia

FunPlotThreshold(country = "Ukraine",
                 col.bkg = "black",
                 col.main = "black",
                 lwd.bkg = 0.5,
                 loop = TRUE,
                 prezi = FALSE)

FunPlotPyramid65(country = "Ukraine",
                 col.bkg = "black",
                 col.65 = "cadetblue",
                 col.main = "darkgoldenrod1",
                 lwd.bkg = 1,
                 time.start = 1980,
                 time.end = 2050,
                 prezi = FALSE,
                 loop = TRUE)

FunPlotProportions("Ukraine",
                   col.bkg = "black",
                   col.65 = "black",
                   col.main = "red",
                   lwd.bkg = 0.5,
                   prezi = FALSE,
                   loop = TRUE)
