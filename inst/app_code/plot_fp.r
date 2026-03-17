library(ggplot2)
library(dplyr)
library(ggthemes)
library(lubridate)

# Load custom axis function
source(system.file("app_code/custom_ggplot_axis.R", package = "fp"))

#' Create Flight Plan Plot
#'
#' @param id Patient ID (string or numeric)
#' @param data Long format risk data (defaults to fp)
#' @param id_data Wide format patient metadata (defaults to fp.df.web)
#'
#' @return A ggplot object, or a blank plot with a message if ID is not found.
create_plot <- function(id = 5, data = fp, id_data = fp.df.web) {
  # 1. Validation and Handling of Missing/Invalid ID
  if (is.null(id) || length(id) == 0 || id == "") {
    return(ggplot() +
             annotate("text", x = 0.5, y = 0.5, label = "Please select a valid ID") +
             theme_void())
  }

  # Ensure ID types match (converting to character as seen in data inspection)
  id <- as.character(id)

  # 2. Extract Patient-Specific Data Once
  patient_meta <- id_data %>% filter(as.character(ID) == !!id)
  patient_risk <- data %>% filter(as.character(ID) == !!id)

  if (nrow(patient_meta) == 0 || nrow(patient_risk) == 0) {
    return(ggplot() +
             annotate("text", x = 0.5, y = 0.5, label = paste("ID", id, "not found in data")) +
             theme_void())
  }

  # Helper to safely parse dates
  parse_dt <- function(x) as.POSIXct(x, format = "%d/%m/%Y %H:%M")

  # 3. Create the Plot
  g1 <- patient_risk %>%
    ggplot(aes(x = Date, y = Level_of_Risk, color = Level_of_Risk)) +
    geom_line(linewidth = 1) +
    theme_tufte() +
    labs(
      title = paste("Patient: ",
                    substring(patient_meta$FirstName[1], 1, 1),
                    substring(patient_meta$Name[1], 1, 1)),
      subtitle = paste("First Operation Date", patient_meta$OR_start[1])
    ) +
    theme(
      panel.grid.major.x = element_line(linewidth = .15, colour = "darkgray", linetype = 5),
      axis.line.x = axis_custom(),
      axis.ticks.y = element_blank(),
      panel.grid.major.y = element_line(
        linewidth = .15,
        color = c("darkgray", "darkgray", "darkgray", "red", "red", "darkgray"),
        linetype = 5
      )
    ) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%d/%m") +
    scale_y_continuous(
      name = "",
      breaks = 1:5,
      labels = c("Admission\nDischarge", "Ward", "ICU", "Extubated \nIntubated", "OR")
    ) +
    scale_color_gradient2(
      name = "Risk Level",
      low = "green",
      mid = "orange",
      high = "purple",
      midpoint = 3
    )

  # 4. Add Annotations Safely
  inotrope_stop <- parse_dt(patient_meta$INOTROPS_stop[1])
  if (!is.na(inotrope_stop)) {
    g1 <- g1 +
      geom_vline(xintercept = inotrope_stop, linetype = "dashed", color = 'blue', linewidth = 1) +
      annotate("text", x = inotrope_stop, y = 6.2, label = "Stop Inotropes", color = "blue")
  }

  drain_out <- parse_dt(patient_meta$DRAIN_out[1])
  if (!is.na(drain_out)) {
    g1 <- g1 +
      geom_vline(xintercept = drain_out, linetype = "dashed", color = 'orange', linewidth = 1) +
      annotate("text", x = drain_out, y = median(patient_risk$Level_of_Risk, na.rm = TRUE),
               label = "Drains Out", color = "orange")
  }

  ward_end <- parse_dt(patient_meta$WARD_end[1])
  if (!is.na(ward_end)) {
    g1 <- g1 +
      annotate("text", x = ward_end, y = 5.2, label = paste0("CPB: ", patient_meta$CPB[1], " m"), color = "black") +
      annotate("text", x = ward_end, y = 4.7, label = paste0("XC: ", patient_meta$XC[1], " m"), color = "black")

    # Mechanical Ventilation calculation
    mv_start <- parse_dt(patient_meta$Intubated_start[1])
    mv_end   <- parse_dt(patient_meta$Intubated_end[1])
    if (!is.na(mv_start) && !is.na(mv_end)) {
      mv_diff <- mv_end - mv_start
      g1 <- g1 + annotate("text", x = ward_end, y = 4.2,
                          label = paste0("Mec V: ", formatC(mv_diff, digits = 2), " ", units(mv_diff)),
                          color = "black")
    }

    # LOS calculation
    adm_start <- parse_dt(patient_meta$Admission_start[1])
    if (!is.na(adm_start)) {
      los_diff <- ward_end - adm_start
      g1 <- g1 + annotate("text", x = ward_end, y = 3.7,
                          label = paste0("LOS: ", formatC(los_diff, digits = 2), " ", units(los_diff)),
                          color = "black")
    }
  }

  return(g1)
}