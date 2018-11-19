#' Title FunPlotThreshold
#'
#' @param country - exact full country name to be matched in threshold.1y$location
#' @param col.bkg - colour of background lines
#' @param col.main - colour of main lines
#' @param lwd.bkg - width of background lines, nice to be narrow for black
#'
#' @return saves a gif in the presentations/figures folder
#' @export
#'
#' @examples
#' 
#' 
FunPlotThreshold <- function(country = "Slovenia",
                             col.bkg = "gray",
                             col.main = "black",
                             lwd.bkg = 1) {
  # subset data                             
  threshold.1y %>% 
    filter(location == country) %>% 
    filter(time >= 1980 & time <= 2050) %>% 
    gather(key = group, value = threshold, 3:5) %>% 
    separate(group, into = c("delete", "group")) %>% 
    select (-delete) %>% 
    # plot
    ggplot(aes(time, threshold, group = group)) +
    geom_point(size = 3) +
    # plot background lines
    geom_line(data = threshold.1y %>% filter(time >= 1980 & time <= 2050), aes(time, threshold_total, group = location), 
              colour = col.bkg, size = lwd.bkg) +
    geom_vline(xintercept=2015, colour = col.bkg, linetype = "longdash")+
    geom_segment(aes(x=1980,xend=2050,y=65,yend=65), colour = col.bkg, linetype = "longdash") +
    # plot main lines
    geom_line( color = col.main, aes(linetype = group, size = group)) +
    scale_linetype_manual(values=c("longdash",  "longdash","solid"), guide=FALSE) +
    scale_size_manual(values = c(1, 1, 1.4), guide = FALSE) +
    theme_minimal() +
    theme(plot.margin = margin(5.5, 40, 5.5, 5.5),
          text = element_text(size=20)) +
    coord_cartesian(clip = 'off',
                    ylim = c(50,85)) +
    labs( y = "Old-age threshold", x = "Year")+
    geom_text(aes(x = 2055, label = group), size = 6, hjust = 0) +
    geom_text(aes(x = 2055, y = 65, label = "65", vjust = .5), size = 6, hjust = 0, colour = "red") +
    geom_segment(aes(xend = 2052, yend = threshold), linetype = 2, colour = 'grey') +
    transition_reveal(group, time) -> p
  
  animate(p, fps = 10,  renderer = gifski_renderer(loop = FALSE),width = 1000, height = 600)
  anim_save(paste0("docs/presentations/figures/", country, ".gif"))
}



#' FunPlotProportions
#' 

#' @param country - exact full country name to be matched in threshold.1y$location
#' @param col.bkg - colour of background lines
#' @param col.65 - colour of over 65 proportion
#' @param col.main - colour of main lines - over threhsold
#' @param lwd.bkg - width of background lines, nice to be narrow for black
#'
#' @return two gifs, one for the 65 and then over that another one plotting the red
#' threshold lines
#' @export


FunPlotProportions <- function(country = "Slovenia",
                               col.bkg = "black",
                               col.65 = "black",
                               col.main = "red",
                               lwd.bkg = 1) {
    prop.over %>% 
    filter(location == country) %>% 
    filter(time >= 1980 & time <= 2050) %>% 
    gather(key = group, value = prop_over_65, 3:5) %>% 
    separate(group, into = c("d1", "d2", "d3", "group")) %>% 
    select (location, time, group, prop_over_65) %>% 
    # plot 
    ggplot(aes(time, prop_over_65, group = group)) +
    geom_point(size = 3) +
    # plot background lines
    geom_vline(xintercept=2015, colour = col.bkg, linetype = "longdash")+
    # plot main lines
    geom_line( color = col.65, aes(linetype = group, size = group)) +
    scale_linetype_manual(values=c("longdash",  "longdash","solid"), guide=FALSE) +
    scale_size_manual(values = c(1, 1, 1.4), guide = FALSE) +
    theme_minimal() +
    theme(plot.margin = margin(5.5, 40, 5.5, 5.5),
          text = element_text(size=20)) +
    coord_cartesian(clip = 'off',
                    ylim = c(0.05,0.4)) +
    labs( y = "Proportion in old-age group", x = "Year")+
    geom_text(aes(x = 2055, label = group), size = 6, hjust = 0) +
    geom_text(aes(x = 2062, label = rep(c("","Over","65"), each = 71)), size = 6, hjust = 0) +
    geom_segment(aes(xend = 2052, yend = prop_over_65), linetype = 2, colour = 'grey') +
    transition_reveal(group, time) -> p
  animate(p, fps = 10,  renderer = gifski_renderer(loop = FALSE),width = 1000, height = 600)
  anim_save(paste0("docs/presentations/figures/proportions_65_", country, ".gif"))
  
  
  prop.over %>% 
    filter(location == country) %>% 
    filter(time >= 1980 & time <= 2050) %>% 
    gather(key = group, value = prop_over_threshold, 6:8) %>% 
    separate(group, into = c("d1", "d2", "d3", "group")) %>% 
    select (location, time, group, prop_over_threshold) %>% 
    # plot 
    ggplot(aes(time, prop_over_threshold, group = group)) +
    geom_point(size = 3) +
    # plot background lines
    geom_vline(xintercept=2015, colour = col.bkg, linetype = "longdash") +
    geom_line(data = prop.over %>% 
                filter(location == country) %>% 
                filter(time >= 1980 & time <= 2050) %>% 
                gather(key = group, value = prop_over_65, 3:5) %>% 
                separate(group, into = c("d1", "d2", "d3", "group")) %>% 
                select (location, time, group, prop_over_65) %>% 
                rename(group65 = group),
              color = col.65, 
              aes(time, prop_over_65, group = group65, linetype = group65, size = group65)) +
    # plot main lines
    geom_line( color = col.main, aes(linetype = group, size = group)) +
    scale_linetype_manual(values=c("longdash",  "longdash","solid"), guide=FALSE) +
    scale_size_manual(values = c(1, 1, 1.4), guide = FALSE) +
    theme_minimal() +
    theme(plot.margin = margin(5.5, 40, 5.5, 5.5),
          text = element_text(size=20)) +
    coord_cartesian(clip = 'off',
                    ylim = c(0.05,0.4)) +
    labs( y = "Proportion in old-age group", x = "Year")+
    geom_text(aes(x = 2055, label = group), size = 6, hjust = 0) +
    geom_text(aes(x = 2062, label = rep(c("","Over","threshold"), each = 71)), size = 6, hjust = 0) +
    geom_segment(aes(xend = 2052, yend = prop_over_threshold), linetype = 2, colour = 'grey') +
    transition_reveal(group, time) -> p
  
  animate(p, fps = 10,  renderer = gifski_renderer(loop = FALSE),width = 1000, height = 600)
  anim_save(paste0("docs/presentations/figures/proportions_threshold_", country, ".gif"))
}


FunPlotPyramid65 <- function(country = "Slovenia",
                             col.bkg = "black",
                             col.65 = "black",
                             col.main = "red",
                             lwd.bkg = 1) {
  pop %>% 
    filter(location == country) %>% 
    filter(time >= 1980 & time <= 2050) %>% 
    gather(key = group, value = proportion, 4:5) %>% 
    separate(group, into = c("delete", "sex")) %>% 
    select (-delete) %>% 
    mutate(AgeGrp = as.numeric(AgeGrp)) %>% 
    mutate(over_65 = as.factor(ifelse(AgeGrp >= 65, 1, 0))) %>% 
    left_join(threshold.1y %>% 
                filter(location == country) %>% 
                filter(time >= 1980 & time <= 2050) %>% 
                gather(key = group, value = threshold, 3:5) %>% 
                separate(group, into = c("delete", "group")) %>% 
                select (-delete) %>% 
                rename (sex = group)) %>% 
    mutate(over_threshold = as.factor(ifelse(AgeGrp >= threshold, 1, 0))) -> data
  
  
  ggplot(data) +
    geom_bar(aes(AgeGrp, proportion, group = over_threshold, colour = over_threshold, fill = over_threshold),
             stat = "identity",subset(data,data$sex=="female"))+
    geom_bar(aes(AgeGrp,-proportion,group = over_threshold,  colour = over_threshold, fill = over_threshold),
             stat = "identity",subset(data,data$sex=="male"))+
    coord_flip() +
    geom_vline(xintercept=65, colour = "yellow", size = 1.4, linetype = "longdash") +
    geom_hline(yintercept=0, colour = "white", size = 1) +
    
    geom_text(aes(x = 100, y = 1, label = time), size = 6, hjust = 1) +
    scale_fill_manual(values=c("black", "red"), guide = FALSE)+
    scale_colour_manual(values=c("black", "red"), guide = FALSE)+
    theme_minimal() +
    labs( y = "Percent of population", x = "Age") +
    scale_y_continuous(breaks=seq(-1,1,0.5),labels=abs(seq(-1,1,.5)))  +
    transition_states(time, transition_length = 1, state_length = 1) -> p
  
  animate(p, fps = 50,  renderer = gifski_renderer(loop = FALSE),width = 1000, height = 600)
  anim_save(paste0("docs/presentations/figures/pyramid_65_", country, ".gif"))
}

