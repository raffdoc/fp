library(readr)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(scales)

fp %>%
  filter(ID == 1) %>% 
  ggplot(aes(x= Date, y = Level_of_Risk, group = 1, color = Level_of_Risk)) + geom_line() +
  theme_tufte() +theme( # remove the vertical grid lines
    panel.grid.major.x = element_line(size = .1, color= "black", linetype = 5) ,
    # explicitly set the horizontal lines (or they will disappear too)
    panel.grid.major.y = element_line( size=.1, color="black",linetype = 5) 
  ) +
  annotate("text", x = as.POSIXct("2019-01-11 09:00:00"), y = 2.2, label = "CPB: 214 min", color = "purple") +
  annotate("text", x = as.POSIXct("2019-01-11 09:00:00"), y = 1.8, label = "CA: 94 min", color = "purple") +
  annotate("text", x = as.POSIXct("2019-01-11 09:00:00"), y = 1.4, label = "ACP: 82 min", color = "purple") +
  annotate("pointrange", x = as.POSIXct("2019-01-14 09:00:00"), y = 3.3, ymin = 3, ymax = 3,colour = "orange", size = 1.5, alpha=0.4) +
  annotate("text", x = as.POSIXct("2019-01-16 12:00:00"), y = 3.8, label = "Drains PD and LAP out", color = "orange") + 
  annotate("pointrange", x = as.POSIXct("2019-01-19 09:00:00"), y = 3, ymin = 3, ymax = 3,colour = "blue", size = 1, alpha=0.4) +
  annotate("text", x = as.POSIXct("2019-01-19 18:00:00"), y = 3.2, label = "Stop inotropes", color = "blue")

#
ct0 <- "14/01/2019 16:00"
sis <-"Stop_Inotrop_support,19/01/2019 09:00,3"


# newer version
  fp %>% 
    filter(ID == 1) %>% 
    ggplot(aes(x= Date, y = Level_of_Risk, color = Level_of_Risk)) + 
    geom_line(#color = factor(fp$Level_of_Risk[fp$ID==1])
    ) +
   # geom_point(color = fp$Level_of_Risk
   # ) +
    theme_tufte() +
    ggtitle(paste("ID of Patients: ",fp.df.web$Surname[fp.df.web$ID==1],fp.df.web$FirstName[fp.df.web$ID==1])) +
    theme( # remove the vertical grid lines
      #title = element_text(paste0(fp.df.web$FirstName)),
      panel.grid.major.x = element_blank() ,
      # explicitly set the horizontal lines (or they will disappear too)
      panel.grid.major.y = element_line( size=.1, color=c("darkgray","darkgray","darkgray","red", "red","darkgray"),
                                         linetype = 5)) + 
    scale_x_datetime(date_breaks = "1 day", date_labels = "%d/%m") +
    scale_y_continuous(name = "Position/State",breaks = 1:6 , labels = c("Admission\nDischarge" ,"Ward", "ICU", "Extubated","Intubated", "OR")) + 
    scale_color_gradient2(low="green", mid = "orange", high="purple", 
                          midpoint = 3)





