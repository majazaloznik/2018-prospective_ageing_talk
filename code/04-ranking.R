##=============================================================================
## 00. preliminaries ==========================================================
## 01. ranking  proportions ===================================================
##=============================================================================


## 00. preliminaries ==========================================================
library(dplyr)
library(tidyr)

# prop over threshold and over 65 for each country/age/gender combination
prop.over <- readRDS(here::here("data/processed/prop.over.rds"))

prop.over %>% 
  filter(time %in% c(2018, 2050)) %>% 
  select(-ends_with("female"), - ends_with("male")) %>% 
  gather(key = type, value = proportion, 3:4) %>% 
  unite(var ,type, time) %>% 
  spread(var, proportion) %>% 
  arrange( desc(prop_over_65_total_2018)) %>% 
  mutate(rank_65_2018 = row_number()) %>% 
  arrange( desc(prop_over_65_total_2050)) %>% 
  mutate(rank_65_2050 = row_number()) %>% 
  arrange( desc(prop_over_threshold_total_2018)) %>% 
  mutate(rank_threshold_2018 = row_number()) %>% 
  arrange( desc(prop_over_threshold_total_2050)) %>% 
  mutate(rank_threshold_2050 = row_number()) %>% 
  mutate(location = ifelse(location == "United States of America",
                           "United States", location))-> x

  
data.frame(order_65_2018 = x %>% 
             arrange(rank_65_2018) %>% 
             pull(location),
           prop_65_2018 = x %>% 
             arrange(rank_65_2018) %>% 
             pull(prop_over_65_total_2018),
           order_threshold_2018 = x %>% 
             arrange(rank_threshold_2018) %>% 
             pull(location),
           prop_threshold_2018 = x %>% 
             arrange(rank_threshold_2018) %>% 
             pull(prop_over_threshold_total_2018),
           order_65_2050 = x %>% 
             arrange(rank_65_2050) %>% 
             pull(location),
           prop_65_2050 = x %>% 
             arrange(rank_65_2050) %>% 
             pull(prop_over_65_total_2050),
           order_threshold_2050 = x %>% 
             arrange(rank_threshold_2050) %>% 
             pull(location),
           prop_threshold_2050 = x %>% 
             arrange(rank_threshold_2050) %>% 
             pull(prop_over_threshold_total_2050)) -> final
 
saveRDS( final, "docs/presentations/final.rds")
