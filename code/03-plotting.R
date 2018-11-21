##=============================================================================
## 00. preliminaries ==========================================================
## 01. plotting thresholds ====================================================
## 02. plotting proportions over 65 ===========================================
##=============================================================================


## 00. preliminaries ==========================================================
library(dplyr)
library(magrittr)
library(tidyr)
library(ggplot2)
library(gganimate)
source(here::here("code/FunPlots.R"))

# threshold for each country/age/gender combination
threshold.1y <-readRDS(here::here("data/processed/threshold.1y.rds"))
# prop over threshold and over 65 for each country/age/gender combination
prop.over <- readRDS(here::here("data/processed/prop.over.rds"))
# single age populations for each each country/age/gender combination
pop <- readRDS(here::here("data/processed/pop.rds"))
# age group is character and has 80+ as an option, fix it:
pop %>% 
  mutate(AgeGrp = ifelse(AgeGrp == "80+", 80, AgeGrp),
         AgeGrp = as.numeric(AgeGrp)) -> pop


## 01. plotting thresholds ====================================================

lapply(unique(threshold.1y$location),
       function(x)  
         FunPlotThreshold(x,
                          col.bkg = "black",
                          col.main = "red",
                          lwd.bkg = 0.5))

## 02. plotting proportions over 65 ===========================================


lapply(unique(prop.over$location),
       function(x)  
         FunPlotProportions(x,
                          col.bkg = "black",
                          col.65 = "black",
                          col.main = "red",
                          lwd.bkg = 0.5))

##  03. plotting the pyramid  =================================================



lapply(unique(prop.over$location),
       function(x)  
         FunPlotPyramid65(country = x,
                          col.bkg = "black",
                          col.65 = "cadetblue",
                          col.main = "darkgoldenrod1",
                          lwd.bkg = 1,
                          time.start = 1980,
                          time.end = 2015))

lapply(unique(prop.over$location),
       function(x)  
         FunPlotPyramid65(country = x,
                          col.bkg = "black",
                          col.65 = "cadetblue",
                          col.main = "darkgoldenrod1",
                          lwd.bkg = 1,
                          time.start = 2015,
                          time.end = 2050))


## 04. plots for readme

FunPlotThreshold(country = "Belarus",
         col.bkg = "black",
         col.main = "black",
         lwd.bkg = 0.5,
         loop = TRUE,
         prezi = FALSE)

FunPlotPyramid65(country = "Belarus",
                 col.bkg = "black",
                 col.65 = "cadetblue",
                 col.main = "darkgoldenrod1",
                 lwd.bkg = 1,
                 time.start = 1980,
                 time.end = 2050,
                 prezi = FALSE,
                 loop = TRUE)

FunPlotProportions("Japan",
                   col.bkg = "black",
                   col.65 = "black",
                   col.main = "red",
                   lwd.bkg = 0.5,
                   prezi = FALSE,
                   loop = TRUE)
