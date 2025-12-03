#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.pptx",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      # Set up parameters to pass to Rmd document
      params <- list(n = input$id)
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  updateData <- eventReactive(input$go, {
    #source("R/code/get_data.r")
  })
  # updateData()
  output$fpPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    source(app_sys("app_code/plot_fp.r"))
    g1 <- create_plot(id = input$id, data = fp, id_data = fp.df.web)
    #g2
    g1
  })
}
