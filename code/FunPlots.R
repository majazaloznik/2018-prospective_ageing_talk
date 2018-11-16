##=============================================================================
## FunPlotThreshod  ===========================================================
## FunPlotProportions  ========================================================
# FunPyramidPlotNoAxes =======================================================
# FunPlotThresholdLedge #######################################################
# FunPlotProportionLedge ######################################################
# fFunPyramidPlotLedge#########################################################

##=============================================================================


## FunPlotThreshod  ===========================================================

#' FunPlotThreshod - Plot old-age threshold estimates and projections for 
#' individual countries
#' 
#' Using a preformated dataframe `threshold.1y` which has data on the 
#' following variables: 
#' location = country 
#' time = year
#' female, Male and total are the thresholds for women, men and both
#' This function plots for a single country the three trends - men, women and 
#' both, while also in gray printing the trends for the other 20 countries
#' for total only. 
#'
#' @param country - country of interest
#' @param col.bg - colour of background
#' @param col.20- colour for the 20 grayed out countries underlayed 
#' @param col.total - main colour for old age threshold of whole population
#' @param col.male - colour for men
#' @param col.female - colour for women
#' @param write - logical whether to write to postscript
#' @param height - height of postscript file
#' @param width - width of postscript file
#'
#' @return - plot to device or written to .eps into the 'figures/` folder
#' @export
#'
#' @examples
#' 
#' 
FunPlotThreshold <- function(country = "Algeria", 
                             col.bg = "steelblue4",
                             col.20 = "gray85",
                             col.total = "palevioletred4",
                             col.male = "palevioletred3",
                             col.female = "palevioletred3",
                             write = TRUE, 
                             height = 4,
                             width = 6,
                             col.grid = "lightcyan3",
                             lty.grid = 1,
                             lwd.grid = 1){
  
  if(write) {
    postscript(file=here::here(paste0("figures/","threshold-",gsub(" ", "_",country),".eps")),
               horiz=FALSE,onefile=FALSE,
               width=width,
               height=height,
               paper="special") }
  threshold.1y %>% 
    filter(time > 1980, time < 2050) -> threshold.1y
  par(bg = col.bg )
  par(mar = c(3,2,2.5,0))
  plot(2000, 50, 
       xlim = c(1980, 2050), 
       ylim = c(55, 80),
       bty = "n",
       type = "n",
       ylab = "", xlab = "",
       axes = FALSE)
  mtext("m", side = 3, line = .5)
  
  for (i in seq(55, 80, 5)){
    lines(c(1980, 2050), c(i,i), col = col.grid, lty = lty.grid,
          lwd = lwd.grid)
  }
  
  # background lines
  threshold.1y %>% 
    split(., .$location) %>% 
    lapply( function(x) lines(x$time, x$threshold_total, lwd = 3, col = col.20))
  lines(c(1980, 2050), c(65,65), col = "gray50", lty = 3, lwd = 2)
  
  # total
  threshold.1y %>% 
    filter(location == country) %>% 
    lines(threshold_total ~ time, . ,
          lwd = 3, col = col.total )
  
  # men
  threshold.1y %>% 
    filter(location == country) %>% 
    lines(threshold_male ~ time, . ,
          lwd = 3, col = col.male, lty = "63")
  
  #women
  threshold.1y %>% 
    filter(location == country) %>% 
    lines(threshold_female ~ time, . ,
          lwd = 3, col = col.female, lty = "63")
  
  
  abline(v = 2015, lty = 2, lwd = 2, col = "gray50")
  text(2016, 79.2, "P", adj = c(0,1))
  text(2012, 79.2, "E", adj = c(0,1))
  
  axis(2, pos = 1980, las = 2)
  axis(1)
  
  if(write) {
    dev.off() }
}



## FunPlotProportions  ========================================================

#' Title
#'
#' @param country 
#' @param col.bg 
#' @param col.20 
#' @param col.65 
#' @param col.threshold 
#' @param write 
#' @param height 
#' @param width 
#' @param col.grid 
#' @param lty.grid 
#' @param lwd.grid 
#'
#' @return
#' @export
#'
#' @examples
FunPlotProportions <- function(country = "Algeria", 
                               col.bg = "steelblue4",
                               col.20 = "gray85",
                               col.65 = "slateblue1",
                               col.threshold = "slateblue1",
                               write = TRUE, 
                               height = 4,
                               width = 6,
                               col.grid = "lightcyan3",
                               lty.grid = 1,
                               lwd.grid = 1){
  
  if(write) {
    postscript(file=here::here(paste0("figures/","proportion-",substr(country, 1,4),".eps")),
               horiz=FALSE,onefile=FALSE,
               width=width,
               height=height,
               paper="special") }
  par(bg = col.bg )
  prop.over %>% 
    filter(time > 1980, time < 2050) -> prop.over
  par(bg = col.bg)
  par(mar = c(3,2,2.5,0))
  plot(2000, 50, 
       xlim = c(1980, 2050), 
       ylim = c(0, .2),
       bty = "n",
       type = "n",
       ylab = "", xlab = "",
       axes = FALSE)
  mtext("n", side = 3, line = .5)
  for (i in seq(0, .2, .05)){
    lines(c(1980, 2050), c(i,i), col = col.grid, lty = lty.grid,
          lwd = lwd.grid)
  }
  
  
  prop.over%>% 
    filter(location == country) %>% 
    lines(prop_over_65_total ~ time, . ,
          lwd = 3, col = col.65)
  
  prop.over%>% 
    filter(location == country) %>% 
    lines(prop_over_65_female ~ time, . ,
          lwd = 3, col = col.65, lty = "63")
  
  prop.over%>% 
    filter(location == country) %>% 
    lines(prop_over_65_male ~ time, . ,
          lwd = 3, col = col.65, lty = "63")
  
  prop.over%>% 
    filter(location== country) %>% 
    lines(prop_over_threshold_total ~ time, . ,
          lwd = 3, col = col.threshold)
  
  prop.over%>% 
    filter(location== country) %>% 
    lines(prop_over_threshold_female ~ time, . ,
          lwd = 3, col = col.threshold, lty = "63")
  
  prop.over%>% 
    filter(location== country) %>% 
    lines(prop_over_threshold_male ~ time, . ,
          lwd = 3, col = col.threshold, lty = "63")
  
  abline(v = 2015, lty = 2, lwd = 2, col = "gray50")
  text(2016, .19, "P", adj = c(0,1))
  text(2012, .19, "E", adj = c(0,1))
  axis(2, pos = 1980, las = 2)
  axis(1)
  
  
  if(write) {
    dev.off() }
}



# FunPyramidPlotNoAxes =======================================================
#' FunPyramidPlotNoAxes
#' 
#' @param lx 
#' @param rx 
#' @param labels 
#' @param top.labels 
#' @param main 
#' @param laxlab 
#' @param raxlab 
#' @param unit 
#' @param lxcol 
#' @param rxcol 
#' @param gap 
#' @param space 
#' @param ppmar 
#' @param labelcex 
#' @param add 
#' @param xlim 
#' @param show.values 
#' @param ndig 
#' @param do.first 
#' @param axes 
#' @param density 
#' @param angle 
#' @param lwd 
#' @param border 
#' @param ylab 
#' @param col.overlay 
#' @param lx.50 
#' @param rx.50 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' 
FunPyramidPlotNoAxes <- function(country,
                                 labels = NA, 
                                 top.labels = NULL, 
                                 main = "", 
                                 laxlab = NULL, raxlab = NULL, unit = "", 
                                 gap = 1, space = 0.2, 
                                 ppmar = c(2.5, 0, 0, 0), 
                                 labelcex = 1, add = FALSE, 
                                 xlim, show.values = FALSE, ndig = 1, 
                                 do.first = NULL, 
                                 axes=FALSE, 
                                 density=NULL, 
                                 angle=45, 
                                 lwd = 2, 
                                 ylab="",
                                 col.overlay = "red",
                                 lxcol = col.pyramid, 
                                 rxcol = col.pyramid, 
                                 border = col.pyramid,
                                 col.bg = NA,
                                 write = TRUE,
                                 width = 8,
                                 height = 5,
                                 year = 2018) {
  # get data
  pop %>% 
    filter(location == country,
           time == year) -> pyramid
  pop %>% 
    filter(location == country,
           time == 2050) -> pyramid.50
  lx <- pyramid$prop_male
  rx <- pyramid$prop_female
  lx.50 <- pyramid.50$prop_male
  rx.50 <- pyramid.50$prop_female
  # get thresholds and pop at that age
  lx.t <- threshold.1y %>% 
    filter(location == country,
           time == year) %>% 
    pull(male)
  lx.t.pop <- lx[floor(lx.t )]
  rx.t <- threshold.1y %>% 
    filter(location == country,
           time == year) %>% 
    pull(female)
  rx.t.pop <- rx[floor(rx.t )]
  # get thresholds and pop at that age in 2050
  lx.t.50 <- threshold.1y %>% 
    filter(location == country,
           time == 2050) %>% 
    pull(male)
  lx.t.50.pop <- lx.50[floor(lx.t.50)]
  rx.t.50 <- threshold.1y %>% 
    filter(location == country,
           time == 2050) %>% 
    pull(female)
  rx.t.50.pop <- rx.50[floor(rx.t.50 )]
  if(write) {
    postscript(file=here::here(paste0("figures/","pyramid-",substr(country, 1,4),".eps")),
               horiz=FALSE,onefile=FALSE,
               width=width,
               height=height,
               paper="special") }
  par(bg = col.bg )
  if (axes==FALSE) show.values <- FALSE
  
  ncats <- length(lx)
  if (length(labels) == 1) 
    labels <- 1:ncats
  nlabels <- ifelse(length(dim(labels)), length(labels[, 1]), length(labels))
  
  if (missing(xlim)) 
    xlim <- c(1.7, 1.7)
  
  if (!is.null(laxlab) && xlim[1] < max(laxlab)) 
    xlim[1] <- max(laxlab)
  if (!is.null(raxlab) && xlim[2] < max(raxlab)) 
    xlim[2] <- max(raxlab)
  
  oldmar <- par("mar")
  if (!add) {
    par(mar = ppmar, cex.axis = labelcex)
    plot(0, xlim = c(-(xlim[1] + gap), xlim[2] + gap), 
         ylim = c(0, ncats + 2), type = "n", axes = FALSE, xlab = "", 
         ylab = ylab, xaxs = "r", yaxs = "i", main = main)
    if (!is.null(do.first)) 
    {eval(parse(text = do.first))} else {
      lines(c(1,1), c(0,90), col = lxcol)
      lines(c(-1,-1), c(0,90), col = lxcol)
      lines(c(.5,.5), c(0,95), col = lxcol, lty = "62")
      lines(c(-.5,-.5), c(0,95), col = lxcol, lty = "62")
      lines(c(-2,-2), c(0,70), col = lxcol)
      lines(c(1.5,1.5), c(0,80), col = lxcol, lty = "62")
      lines(c(-1.5,-1.5), c(0,80), col = lxcol, lty = "62")
      lines(c(-3,-3), c(0,50), col = lxcol)
      lines(c(2.5,2.5), c(0,55), col = lxcol, lty = "62")
      lines(c(-2.5,-2.5), c(0,55), col = lxcol, lty = "62")
      #grid(ny = NA, col = lxcol, lty = 1, lwd = 1)
    }
    if (is.null(laxlab)) {
      laxlab <- seq(xlim[1] - gap, 0, by = -1)
      if (axes==TRUE) axis(1, at = -xlim[1]:-gap, labels = laxlab)
    }
    else {if (axes==TRUE) axis(1, at = -(laxlab + gap), labels = laxlab)}
    if (is.null(raxlab)) {
      raxlab <- 0:(xlim[2] - gap)
      if (axes==TRUE) axis(1, at = gap:xlim[2], labels = raxlab)
    }
    else {if (axes==TRUE) axis(1, at = raxlab + gap, labels = raxlab)}
    if (gap > 0) {
      if (axes==TRUE) {
        axis(2, at = 1:ncats, 
             labels = rep("", ncats), pos = gap, tcl = -0.25)
        axis(4, at = 1:ncats, 
             labels = rep("", ncats), pos = gap, tcl = -0.25)
      }}
    if (is.null(dim(labels)) & axes==TRUE) {
      if (gap) 
        text(0, 1:ncats, labels, cex = labelcex)
      else {
        text(xlim[1], 1:ncats, labels, cex = labelcex, 
             adj = 0)
        text(xlim[2], 1:ncats, labels, cex = labelcex, 
             adj = 1)
      }
    }
    else { if ( axes==TRUE) {
      if (gap) {
        lpos <- -gap
        rpos <- gap
      }
      else {
        lpos <- -xlim[1]
        rpos <- xlim[2]
      }
      text(lpos, 1:ncats, labels[, 1], pos = 4, cex = labelcex, 
           adj = 0)
      text(rpos, 1:ncats, labels[, 2], pos = 2, cex = labelcex, 
           adj = 1)
    }}
    mtext(top.labels, 3, 0, at = c(-1, 0, 1), 
          adj = c(0.5,0.5), cex = labelcex)
  }
  
  halfwidth <- 0.5 
  
  # main plotting of pyramid
  rect(-(lx + gap), 1:ncats - halfwidth, rep(-gap, ncats), 
       1:ncats + halfwidth, col = lxcol, density=density, angle=angle, lwd=lwd, border=border)
  
  rect(rep(gap, ncats), 1:ncats - halfwidth, (rx + gap), 
       1:ncats + halfwidth, col = rxcol, density=density, angle=angle, lwd=lwd, border=border)
  lines(x = c(-2.2, 1.6), y = c(65, 65), lty = "11", col = border, lwd = lwd)
  
  lines(x = c(-lx.t.pop, 0), y = c(lx.t, lx.t), lty = 1, col = col.male, lwd = lwd)
  lines(x = c(rx.t.pop, 0), y = c(rx.t, rx.t), lty = 1, col = col.male, lwd = lwd)
  lines(x = c(0,0), y = c(0,100), col = "white")
  
  # plotting of 2050 overlay
  lines(x = c(-lx.t.50.pop, 0), y = c(lx.t.50, lx.t.50), lty = 1, col = col.male, lwd = lwd)
  lines(x = c(rx.t.50.pop, 0), y = c(rx.t.50, rx.t.50), lty = 1, col = col.female, lwd = lwd)
  
  lines(x = c(-gap, rep(rev(-(lx.50 + gap)), each = 2), -gap), 
        y = c(rep((ncats):0 + halfwidth, each = 2) ), 
        col = col.overlay, lwd = 3)
  
  lines(x = c(-gap, rep(rev((rx.50 + gap)), each = 2), -gap), 
        y = c(rep((ncats):0 + halfwidth, each = 2) ), 
        col = col.overlay, lwd = 3 )
  
  
  lines(x = c(0,0), y = c(0,100), col = "white")
  axis(1, at = seq(-3, 1.5, .5), labels = c(3,2.5,2,1.5,1,.5,0,.5,1,1.5)) 
  
  # country name
  if (country == "Iran") {
    text(-3, 80, "X", cex = 1.7, adj = c(0, 0))}
  else{  
    if (country == "Iraq") {
      text(-3, 80, "Z", cex = 1.7, adj = c(0, 0))}
    else {
      if (country == "Kuwait") {
        text(-3, 80, "K", cex = 1.7, adj = c(0, 0))}
      else{
        if (country == "Palestine") {
          text(-3, 80, "Q", cex = 1.7, adj = c(0, 0))}
        else{
          if (country == "Turkey") {
            text(-3, 80, "W", cex = 1.7, adj = c(0, 0))}
          else{
            if(country == "UAE") {
              text(-3, 80, "U", cex = 1.7, adj = c(0, 0))}
            else{
              if(country == "Yemen") {
                text(-3, 80, "Y", cex = 1.7, adj = c(0, 0))}
              else{
                if(country == "Tunisia") {
                  text(-3, 80, "t", cex = 1.7, adj = c(0, 0))}
                else {text(-3, 80, substr(country,1,2), cex = 1.7, adj = c(0, 0))}}}}}}}}
  
  if (show.values) {
    par(xpd = TRUE)
    text(-(gap + lx), 1:ncats, round(lx, ndig), pos = 2, 
         cex = labelcex)
    text(gap + rx, 1:ncats, round(rx, ndig), pos = 4, 
         cex = labelcex)
    par(xpd = FALSE)
  }
  if(write) dev.off()
  
}


# FunPlotThresholdLedge #######################################################

FunPlotThresholdLedge <- function() {
  
  postscript(file=here::here(paste0("figures/","threshold-legend.eps")),
             horiz=FALSE,onefile=FALSE,
             width=4,
             height=4,
             paper="special") 
  
  threshold.1y %>% 
    filter(time > 1980, time < 2050) -> threshold.1y
  par(mar = c(2,2,2.5,0))
  plot(2000, 50, 
       xlim = c(1990, 2040), 
       ylim = c(60, 75),
       bty = "n",
       type = "n",
       ylab = "", xlab = "",
       axes = FALSE)
  mtext("m", side = 3, line = .5)
  
  for (i in seq(55, 80, 5)){
    lines(c(2000, 2030), c(i,i), col = "lightcyan3", lty = 1,
          lwd = 1)
  }
  
  # background lines
  threshold.1y %>% 
    filter(time > 2005, time < 2025) %>% 
    split(., .$location) %>% 
    lapply( function(x) lines(x$time, x$total, lwd = 3, col = col.20))
  lines(c(2000, 2030), c(65,65), col = "gray50", lty = 3, lwd = 2)
  
  # total
  threshold.1y %>% 
    filter(location == "Bahrain") %>% 
    filter(time > 2005, time < 2025) %>% 
    lines(total ~ time, . ,
          lwd = 3, col = col.total )
  
  # men
  threshold.1y %>% 
    filter(location == "Bahrain") %>% 
    filter(time > 2005, time < 2025) %>% 
    lines(male ~ time, . ,
          lwd = 3, col = col.male, lty = "63")
  
  #women
  threshold.1y %>% 
    filter(location == "Bahrain") %>% 
    filter(time > 2005, time < 2025) %>% 
    lines(female ~ time, . ,
          lwd = 3, col = col.female, lty = "63")
  
  
  text(2029, 67, "a")
  text(2029, 73, "g")
  text(2029, 61, "b")
  
  dev.off()
}


# FunPlotProportionLedge ######################################################


FunPlotProportionLedge <- function() {
  
  
  postscript(file=here::here(paste0("figures/","proportion-legend.eps")),
             horiz=FALSE,onefile=FALSE,
             width=4,
             height=4,
             paper="special") 
  
  par(bg = col.bg )
  prop.over %>% 
    filter(time > 1980, time < 2050) -> prop.over
  par(bg = col.bg)
  par(mar = c(3,2,2.5,0))
  plot(2000, 50, 
       xlim = c(2010, 2080), 
       ylim = c(0, .2),
       bty = "n",
       type = "n",
       ylab = "", xlab = "",
       axes = FALSE)
  mtext("n", side = 3, line = .5)
  for (i in seq(0, .2, .05)){
    lines(c(2020, 2050), c(i,i), col = col.grid, lty = lty.grid,
          lwd = lwd.grid)
  }
  
  
  prop.over%>% 
    filter(location== "Syrian Arab Republic") %>% 
    filter(time > 2020) %>% 
    lines(prop_over_65_total + .04 ~ time, . ,
          lwd = 3, col = col.65) 
  
  prop.over%>% 
    filter(location== "Syrian Arab Republic") %>% 
    filter(time > 2020) %>% 
    lines(prop_over_65_female + .05 ~ time, . ,
          lwd = 3, col = col.65, lty = "63")
  
  prop.over%>% 
    filter(location== "Syrian Arab Republic") %>% 
    filter(time > 2020) %>% 
    lines(prop_over_65_male + .03 ~ time, . ,
          lwd = 3, col = col.65, lty = "63")
  
  prop.over%>% 
    filter(location== "Syrian Arab Republic") %>% 
    filter(time > 2020) %>% 
    lines(prop_over_threshold_total ~ time, . ,
          lwd = 3, col = col.threshold)
  
  prop.over%>% 
    filter(location== "Syrian Arab Republic") %>% 
    filter(time > 2020) %>% 
    lines(prop_over_threshold_female + .01~ time, . ,
          lwd = 3, col = col.threshold, lty = "63")
  
  prop.over%>% 
    filter(location== "Syrian Arab Republic") %>% 
    filter(time > 2020) %>% 
    lines(prop_over_threshold_male -.01 ~ time, . ,
          lwd = 3, col = col.threshold, lty = "63")
  
  
  text(2053, .16, "h")
  text(2053, .08, "i")
  
  dev.off() 
  
}


# fFunPyramidPlotLedge#########################################################

FunPyramidPlotLedge <- function(country = "Jordan",
                                labels = NA, 
                                top.labels = NULL, 
                                main = "", 
                                laxlab = NULL, raxlab = NULL, unit = "", 
                                gap = 0, space = 0.2, 
                                ppmar = c(2.5, 0, 0, 0), 
                                labelcex = 1, add = FALSE, 
                                xlim = c(3,1.5), show.values = FALSE, ndig = 1, 
                                do.first = NULL, 
                                axes=FALSE, 
                                density=NULL, 
                                angle=45, 
                                lwd = 3, 
                                ylab="",
                                col.overlay = "red",
                                lxcol = col.pyramid, 
                                rxcol = col.pyramid, 
                                border = col.pyramid,
                                col.bg = NA,
                                write = TRUE,
                                width = 8,
                                height = 5){
  # get data
  
  pop %>% 
    filter(location == country,
           time == 2015) -> pyramid
  pop %>% 
    filter(location == country,
           time == 2050) -> pyramid.50
  lx <- pyramid$prop_male
  rx <- pyramid$prop_female
  lx.50 <- pyramid.50$prop_male
  rx.50 <- pyramid.50$prop_female
  # get thresholds and pop at that age
  lx.t <- threshold.1y %>% 
    filter(location == country,
           time == 2015) %>% 
    pull(male)
  lx.t.pop <- lx[floor(lx.t )]
  rx.t <- threshold.1y %>% 
    filter(location == country,
           time == 2015) %>% 
    pull(female)
  rx.t.pop <- rx[floor(rx.t )]
  # get thresholds and pop at that age in 2050
  lx.t.50 <- threshold.1y %>% 
    filter(location == country,
           time == 2050) %>% 
    pull(male)
  lx.t.50.pop <- lx.50[floor(lx.t.50)]
  rx.t.50 <- threshold.1y %>% 
    filter(location == country,
           time == 2050) %>% 
    pull(female)
  rx.t.50.pop <- rx.50[floor(rx.t.50 )]
  if(write) {
    postscript(file=here::here(paste0("figures/","pyramid-legend.eps")),
               horiz=FALSE,onefile=FALSE,
               width=width,
               height=height,
               paper="special") }
  par(bg = col.bg )
  show.values <- FALSE
  
  ncats <- length(lx)
  if (length(labels) == 1) 
    labels <- 1:ncats
  nlabels <- ifelse(length(dim(labels)), length(labels[, 1]), length(labels))
  
  
  if (!is.null(laxlab) && xlim[1] < max(laxlab)) 
    xlim[1] <- max(laxlab)
  if (!is.null(raxlab) && xlim[2] < max(raxlab)) 
    xlim[2] <- max(raxlab)
  
  oldmar <- par("mar")
  
  par(mar = ppmar, cex.axis = labelcex)
  
  plot(0, xlim = c(-(xlim[1] + gap), xlim[2] + gap), 
       ylim = c(30, ncats + 2+30), type = "n", axes = FALSE, xlab = "", 
       ylab = ylab, xaxs = "r", yaxs = "i", main = main)
  
  
  if (!is.null(do.first)) 
  {eval(parse(text = do.first))} else {
    lines(c(1,1), c(0,70), col = lxcol)
    lines(c(-1,-1), c(0,70), col = lxcol)
    lines(c(.5,.5), c(0,85), col = lxcol, lty = "62")
    lines(c(-.5,-.5), c(0,85), col = lxcol, lty = "62")
  }
  if (is.null(laxlab)) {
    laxlab <- seq(xlim[1] - gap, 0, by = -1)
    if (axes==TRUE) axis(1, at = -xlim[1]:-gap, labels = laxlab)
  }  else {if (axes==TRUE) axis(1, at = -(laxlab + gap), labels = laxlab)}
  if (is.null(raxlab)) {
    raxlab <- 0:(xlim[2] - gap)
    if (axes==TRUE) axis(1, at = gap:xlim[2], labels = raxlab)
  }  else {if (axes==TRUE) axis(1, at = raxlab + gap, labels = raxlab)}
  if (gap > 0) {
    if (axes==TRUE) {
      axis(2, at = 1:ncats, 
           labels = rep("", ncats), pos = gap, tcl = -0.25)
      axis(4, at = 1:ncats, 
           labels = rep("", ncats), pos = gap, tcl = -0.25)
    }}
  if (is.null(dim(labels)) & axes==TRUE) {
    if (gap) 
      text(0, 1:ncats, labels, cex = labelcex)
    else {
      text(xlim[1], 1:ncats, labels, cex = labelcex, 
           adj = 0)
      text(xlim[2], 1:ncats, labels, cex = labelcex, 
           adj = 1)
    }
  }  else { if ( axes==TRUE) {
    if (gap) {
      lpos <- -gap
      rpos <- gap
    }    else {
      lpos <- -xlim[1]
      rpos <- xlim[2]
    }
    text(lpos, 1:ncats, labels[, 1], pos = 4, cex = labelcex, 
         adj = 0)
    text(rpos, 1:ncats, labels[, 2], pos = 2, cex = labelcex, 
         adj = 1)
  }}
  mtext(top.labels, 3, 0, at = c(-1, 0, 1), 
        adj = c(0.5,0.5), cex = labelcex)
  
  
  halfwidth <- 0.5 
  
  # main plotting of pyramid
  rect(-(lx + gap), 1:ncats - halfwidth, rep(-gap, ncats), 
       1:ncats + halfwidth, col = lxcol, density=density, angle=angle, lwd=lwd, border=border)
  
  rect(rep(gap, ncats), 1:ncats - halfwidth, (rx + gap), 
       1:ncats + halfwidth, col = rxcol, density=density, angle=angle, lwd=lwd, border=border)
  lines(x = c(-1.5, 1.1), y = c(65, 65), lty = "11", col = border, lwd = lwd)
  
  lines(x = c(-lx.t.pop, 0), y = c(lx.t, lx.t), lty = 1, col = col.male, lwd = lwd)
  lines(x = c(rx.t.pop, 0), y = c(rx.t, rx.t), lty = 1, col = col.male, lwd = lwd)
  
  # plotting of 2050 overlay
  lines(x = c(-lx.t.50.pop, 0), y = c(lx.t.50, lx.t.50), lty = 1, col = col.male, lwd = lwd)
  lines(x = c(rx.t.50.pop, 0), y = c(rx.t.50, rx.t.50), lty = 1, col = col.female, lwd = lwd)
  
  lines(x = c(-gap, rep(rev(-(lx.50 + gap)), each = 2), -gap), 
        y = c(rep((ncats):0 + halfwidth, each = 2) ), 
        col = col.overlay, lwd = 3)
  
  lines(x = c(-gap, rep(rev((rx.50 + gap)), each = 2), -gap), 
        y = c(rep((ncats):0 + halfwidth, each = 2) ), 
        col = col.overlay, lwd = 3 )
  
  lines(x = c(0,0), y = c(0,100), col = "white")
  text(-0.5, 100, "o")
  
  rect(-3.1,38, -2.9, 42, col = lxcol, border = lxcol)
  rect(-3.1,30, -2.9, 35, border = col.overlay, lwd = 3)
  
  
  dev.off() 
}
