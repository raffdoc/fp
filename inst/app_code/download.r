# download data
# download data from google drive.
set.seed(12345678)
# import data
library("googlesheets4")
library(mice)
library(Hmisc)
library(visdat)
library(DataExplorer)
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(lubridate))
#####
fp.df.web <- read_sheet(ss = "https://docs.google.com/spreadsheets/d/1m59-jaxfnW1TQuWhUpTZpkVTewbQlqsdZZmNf6NTX3E/edit#gid=0", 
                        sheet = "fp", range = "fp!D2:Y7", na = "NA")
fp.df <- fp.df.web %>% 
  select(ID:Discharge) %>% 
  gather( key = Position, value = Date, Admission:Discharge)

fp <- fp.df %>%
  mutate(Level_of_Risk = if_else(str_detect(Position, "OR"), "6", 
                                 if_else(str_detect(Position, "Intubated"), "5", 
                                         if_else(str_detect(Position, "Extubated"), "4", 
                                                 if_else(str_detect(Position, "ICU"), "3", 
                                                         if_else(str_detect(Position, "WARD"), "2", 
                                                                 if_else(str_detect(Position, "Discharge|Admission"), "1", Position))
                                                 )
                                         )
                                 )
  )
  ) %>% 
  mutate(Date = as.POSIXct(Date, format = "%d/%m/%Y %H:%M"))
######
g1<- fp %>% 
  filter(ID == 4, ) %>% 
  ggplot(aes(x= Date, y = Level_of_Risk, group = ID, color = factor(Level_of_Risk))) + geom_line() + geom_point() +
  theme_tufte() +theme( # remove the vertical grid lines
    panel.grid.major.x = element_blank() ,
    # explicitly set the horizontal lines (or they will disappear too)
    panel.grid.major.y = element_line( size=.1, color=c("darkgray","darkgray","darkgray","red", "red","darkgray"),
                                       linetype = 5) 
  ) + scale_x_datetime(date_breaks = "1 day", date_labels = "%d/%m"
                         ) +
  scale_y_discrete(name = "Position/State", labels = c("Admission \n Discharge" ,"Ward", "ICU", "Extubated","Intubated", "OR")) +
  annotate("pointrange", x = as.POSIXct(fp.df.web$StopInotrops_ICU[fp.df.web$ID == 4],  format = "%d/%m/%Y %H:%M"), y = 3, ymin = 3, ymax = 3,colour = "blue", size = 1, alpha=0.4) +
  annotate("text", x = as.POSIXct(fp.df.web$StopInotrops_ICU[fp.df.web$ID == 4],  format = "%d/%m/%Y %H:%M"), y = 3.2, label = "Stop inotropes", color = "blue") +
  annotate("pointrange", x = as.POSIXct(fp.df.web$DrainOut[fp.df.web$ID == 4],  format = "%d/%m/%Y %H:%M"), y = 3.5, ymin = 3, ymax = 3,colour = "orange", size = 1.5, alpha=0.4) +
  annotate("text", x = as.POSIXct(fp.df.web$DrainOut[fp.df.web$ID == 4],  format = "%d/%m/%Y %H:%M"), y = 3.8, label = "Drains PD \n and LAP out", color = "orange")
ggsave("figs/case_Francesco_Cravotta.png", width = 12, height = 4)
