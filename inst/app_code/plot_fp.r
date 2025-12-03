library(ggplot2)
library(dplyr)
library(ggthemes)
library(lubridate)

create_plot <- function(id = 5, data = fp, id_data = fp.df.web){
###################
g1 <- data |>
  filter(ID == id) |>
  ggplot(aes(x = Date, y = Level_of_Risk, color = Level_of_Risk)) +
  geom_line( size = 1) +
  theme_tufte() +
  ggtitle(paste("Patient: ",
                substring(id_data$FirstName[id_data$ID == id], 1, 1),
                substring(id_data$Name[id_data$ID == id], 1, 1)),
  subtitle = paste("First Operation Date", id_data$OR_start[id_data$ID == id])) +
  theme( # remove the vertical grid lines
    panel.grid.major.x = element_line(size = .15, colour = "darkgray", linetype = 5) ,
    axis.line.x = axis_custom(),
    axis.ticks.y=element_blank(),
    panel.grid.major.y = element_line(size =.15,
                                      color=c("darkgray","darkgray","darkgray","red", "red","darkgray"),
                                      linetype = 5)) +
  scale_x_datetime(date_breaks = "1 day", date_labels = "%d/%m") +
  scale_y_continuous(name = "",breaks = 1:5 , labels = c("Admission\nDischarge" ,"Ward", "ICU", "Extubated \nIntubated", "OR")) +
  scale_color_gradient2(name = "Risk Level", low="green", mid = "orange",
                        high="purple", midpoint = 3) +
  geom_vline(xintercept = as.POSIXct(id_data$INOTROPS_stop[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
             linetype = "dashed", color = 'blue', size = 1) +
  annotate("text", x = as.POSIXct(id_data$INOTROPS_stop[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), y = 6.2, label = "Stop Inotropes", color = "blue") +
  geom_vline(xintercept = as.POSIXct(id_data$DRAIN_out[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
             linetype = "dashed", color = 'orange', size = 1) +
  annotate("text", x = as.POSIXct(id_data$DRAIN_out[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
           y = median(data$Level_of_Risk[data$ID == id], na.rm = T), label = "Drains Out", color = "orange") +
  annotate("text", x = as.POSIXct(id_data$WARD_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
           y = 5.2, label = paste0("CPB: ", id_data$CPB[id_data$ID == id], " m"), color = "black") +
  annotate("text", x = as.POSIXct(id_data$WARD_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
           y = 4.7, label = paste0("XC: ", id_data$XC[id_data$ID == id], " m"), color = "black") +
  annotate("text", x = as.POSIXct(id_data$WARD_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
           y = 4.2, label = paste0("Mec V: ",
                                   formatC(as.POSIXct(id_data$Intubated_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Intubated_start[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),digits = 2), " ", units(as.POSIXct(id_data$Intubated_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Intubated_start[id_data$ID == id],  format = "%d/%m/%Y %H:%M"))),
           color = "black") +
  annotate("text", x = as.POSIXct(id_data$WARD_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
           y = 3.7, label = paste0("LOS: ",
                                   formatC(as.POSIXct(id_data$Admission_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Admission_start[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),digits = 2),
                                   " ",
                                   units(as.POSIXct(id_data$WARD_end[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Admission_start[id_data$ID == id],  format = "%d/%m/%Y %H:%M"))),
           color = "black")

}
