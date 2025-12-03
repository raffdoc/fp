create_plot_old <- function(id = 5, data = fp_old, id_data = fp.df.web_old){
g1 <- data %>% 
  filter(ID == id) %>% 
  ggplot(aes(x = Date, y = Level_of_Risk, color = Level_of_Risk)) + 
  geom_line( size = 1
  ) +
  theme_tufte() +
  ggtitle(paste("Patient: ",
                substring(id_data$FirstName[id_data$ID == id], 1, 1),
                substring(id_data$Name[id_data$ID == id], 1, 1)
  ), 
  subtitle = paste("First Operation Date", id_data$OR_in[id_data$ID == id])) +
  theme( # remove the vertical grid lines
    panel.grid.major.x = element_line(size = .15, colour = "darkgray", linetype = 5) ,
    axis.line.x = axis_custom(),
    axis.ticks.y=element_blank(),
    #legend.position = "bottom",
    panel.grid.major.y = element_line(size =.15, 
                                      color=c("darkgray","darkgray","darkgray","red", "red","darkgray"),
                                      linetype = 5)) + 
  scale_x_datetime(date_breaks = "1 day", date_labels = "%d/%m") +
  scale_y_continuous(name = "",
                     breaks = 1:6 ,
                     labels = c("Admission\nDischarge" ,"Ward", "ICU", "Extubated","Intubated", "OR")) +
  scale_color_gradient2(name = "Risk Level", 
                        low="green", 
                        mid = "orange", 
                        high="purple", 
                        midpoint = 3) +
  # annotate("pointrange", 
  #          x = as.POSIXct(id_data$Drain_out[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), 
  #          y = 3, ymin = 3, ymax = 3,colour = "blue", size = 1, alpha=0.4) +
  geom_vline(xintercept = as.POSIXct(id_data$Inotrops_stop[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
             linetype = "dashed", color = 'blue', size = 1) + 
  annotate("text", x = as.POSIXct(id_data$Inotrops_stop[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), y = 6.2, label = "Stop Inotropes", color = "blue") +
  # annotate("pointrange", x = as.POSIXct(id_data$Drain_out[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), y = 3.5, ymin = 3, ymax = 3,colour = "orange", size = 1.5, alpha=0.4) + 
  geom_vline(xintercept = as.POSIXct(id_data$Drain_out[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),
             linetype = "dashed", color = 'orange', size = 1) + 
  annotate("text", x = as.POSIXct(id_data$Drain_out[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), 
           y = median(data$Level_of_Risk[data$ID == id], na.rm = T), label = "Drains Out", color = "orange") +
  annotate("text", x = as.POSIXct(id_data$Discharge[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), 
           y = 5.2, label = paste0("CPB 1st: ", id_data$CPB[id_data$ID == id], " m"), color = "black") +
  annotate("text", x = as.POSIXct(id_data$Discharge[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), 
           y = 4.7, label = paste0("XC 1st: ", id_data$XC[id_data$ID == id], " m"), color = "black") + 
  annotate("text", x = as.POSIXct(id_data$Discharge[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), 
           y = 4.2, label = paste0("Mec Vent: ", 
                                   formatC(as.POSIXct(id_data$Extubated[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Intubated[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),digits = 2), 
                                   " ",
                                   units(as.POSIXct(id_data$Extubated[id_data$ID == 56],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Intubated[id_data$ID == 56],  format = "%d/%m/%Y %H:%M"))), 
           color = "black") + 
  annotate("text", x = as.POSIXct(id_data$Discharge[id_data$ID == id],  format = "%d/%m/%Y %H:%M"), 
           y = 3.7, label = paste0("LOS: ", 
                                   formatC(as.POSIXct(id_data$Discharge[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Admission[id_data$ID == id],  format = "%d/%m/%Y %H:%M"),digits = 2), 
                                   " ",
                                   units(as.POSIXct(id_data$Discharge[id_data$ID == id],  format = "%d/%m/%Y %H:%M") - as.POSIXct(id_data$Admission[id_data$ID == id],  format = "%d/%m/%Y %H:%M"))), 
           color = "black")
}
