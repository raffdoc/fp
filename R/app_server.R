#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @import googlesheets4
#' @import ggplot2
#' @import ggthemes
#' @import lubridate
#' @importFrom magrittr %>%
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = function() {
      paste0("report_", input$id, ".pptx")
    },
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      # Set up parameters to pass to Rmd document
      data <- app_data()
      params <- list(n = input$id, data = data$fp, id_data = data$fp.df.web)
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )

  # Reactive to fetch data from Google Sheets.
  # It updates whenever 'Get Data' is clicked.
  app_data <- eventReactive(input$go, {
    source(app_sys("app_code/get_data.r"), local = TRUE)
    list(fp = fp, fp.df.web = fp.df.web)
  }, ignoreNULL = FALSE)

  # Update the patient selection menu when data is refreshed.
  observe({
    data <- app_data()
    updateSelectInput(session, "id", choices = unique(data$fp$ID), selected = input$id)
  })

  output$fpPlot <- renderPlot({
    data <- app_data()
    source(app_sys("app_code/plot_fp.r"))
    create_plot(id = input$id, data = data$fp, id_data = data$fp.df.web)
  })
}
