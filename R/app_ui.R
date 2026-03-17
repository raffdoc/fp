#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  #Your application server logic
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(
      # theme = "cerulean",  # <--- To use a theme, uncomment this
      "Flight Plan",
      tabPanel("New",
               sidebarPanel(actionButton("go", "Get Data"),
                            selectInput(inputId = "id", label = "Patient ID", choices = NULL),
                            downloadButton("report", "Generate report"),
                            width = 2),
               mainPanel(
                 plotOutput("fpPlot", width = 1000, height = 400), width = 9
               )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "fp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
