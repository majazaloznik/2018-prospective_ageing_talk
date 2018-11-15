##=============================================================================
## 00. preliminaries ==========================================================
## 01. plotting thresholds ====================================================
## 02. plotting proportions over 65 ===========================================
##=============================================================================


## 00. preliminaries ==========================================================
library(dplyr)
library(magrittr)
source(here::here("code/FunPlots.R"))

# threshold for each country/age/gender combination
threshold.1y <-readRDS(here::here("data/processed/threshold.1y.rds"))
# prop over threshold and over 65 for each country/age/gender combination
prop.over <- readRDS(here::here("data/processed/prop.over.rds"))
# single age populations for each each country/age/gender combination
pop <- readRDS(here::here("data/processed/pop.rds"))

col.threshold <- rgb(109, 37, 111, maxColorValue = 255)
col.total <- col.threshold
col.male <- col.threshold
col.female <- col.threshold

col.65 <- "darkgoldenrod1"
col.20 <- "gray85"
col.bg <- NA
col.pyramid <- "gray65"
col.overlay <- rgb(184, 68, 188, maxColorValue = 255)
width <- 10 # 5.74
height.1 <- .45* width * 6.218 / 5.74
height.2 <- .50 * width * 6.218 / 5.74
lty.grid <- 1
lwd.grid <- 1
col.grid <- "gray85"


## 01. plotting thresholds ====================================================

lapply(unique(threshold.1y$location),
       function(x)  FunPlotThreshold(x,
                                     height = height.1, width = 5,
                                     col.bg = col.bg,
                                     col.total = col.total,
                                     col.male = col.male,
                                     col.female = col.female,
                                     col.20 = col.20))

## 02. plotting proportions over 65 ===========================================

lapply(unique(threshold.1y$location), 
       function(x) FunPlotProportions(x, 
                                      write = TRUE, 
                                      height = height.1,
                                      width = 5,
                                      col.threshold = col.threshold,
                                      col.65 = col.65,
                                      col.bg = col.bg))


##  03. plotting the pyramid  =================================================

lapply(unique(threshold.1y$location), 
       function(x) FunPyramidPlotNoAxes(
         country = x, lwd = 3,
         height = height.2, width = 10,
         gap = 0, xlim = c(3,1.5),
         col.bg = col.bg, 
         col.overlay = col.overlay))

## 04. plot legned -threshold  ================================================
FunPlotThresholdLedge()

## 05. plot legned -proportion  ===============================================

FunPlotProportionLedge()

## 06. plot pyramid legend  ===================================================

FunPyramidPlotLedge(col.overlay = col.overlay)

