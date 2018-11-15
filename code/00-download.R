
# 01. download prospective age data from figshare =============================

# preliminaires
library(rfigshare)

# get info on all files in deposit
x <- fs_details(6974414)

# extract ids of the file called 2017_prospective-ages.csv
file.number <- grep("2017_prospective-ages.csv", x$files)

file.url <- x$files[[file.number]]$download_url

# download file to /data/01_raw
download.file(file.url, "data/raw/2017_prospective-ages.csv")


# 02. download  WPP 2017 population data ======================================

file.url <- "https://esa.un.org/unpd/wpp/DVD/Files/1_Indicators%20(Standard)/CSV_FILES/WPP2017_PopulationBySingleAgeSex.csv"
download.file(file.url, "data/raw/WPP2017_PBSAS.csv")

