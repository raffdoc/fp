# get data
cat("getting data ...")
set.seed(12345678)
# import data
suppressPackageStartupMessages(library(googledrive))
suppressPackageStartupMessages(library(googlesheets4))
suppressPackageStartupMessages(library(mice))
suppressPackageStartupMessages(library(Hmisc))
suppressPackageStartupMessages(library(visdat))
suppressPackageStartupMessages(library(DataExplorer))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(ggplot2))
#options(gargle_oob_default = TRUE)
# Google sheets authentification -----------------------------------------------
googlesheets4::gs4_auth(path = app_sys("flightplan.json"))
# url_old <- "https://docs.google.com/spreadsheets/d/1m59-jaxfnW1TQuWhUpTZpkVTewbQlqsdZZmNf6NTX3E/edit#gid=0"
url <- "https://docs.google.com/spreadsheets/d/1qYa-fR-t-GYrdLDabexe-FNUSMzxJyl09mv3bSz_-O8/edit?usp=sharing"
fp.df.web <- read_sheet(ss = url,
                        sheet = "new_fp", range = "new_fp!A1:AA1000", na = "NA")
fp <- fp.df.web %>%
  select(ID:Admission_end) %>%
  gather( key = Position,
          value = Date,
          Admission_start:Admission_end
  ) %>%
  mutate(Level_of_Risk = if_else(str_detect(Position, "OR"), "5",
                                 if_else(str_detect(Position, "Intubated"), "4",
                                         if_else(str_detect(Position, "ICU"), "3",
                                                 if_else(str_detect(Position, "WARD"), "2",
                                                         if_else(str_detect(Position, "Admission"), "1",
                                                                 Position
                                                         )
                                                 )
                                         )
                                 )
  )
  ) %>%
  mutate(Date = as.POSIXct(Date, format = "%d/%m/%Y %H:%M"),
  Level_of_Risk = as.integer(Level_of_Risk))
#save(fp, fp.df.web, file = "../fp.RData")
