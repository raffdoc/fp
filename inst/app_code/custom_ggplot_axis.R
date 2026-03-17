element_grob.element_custom <- function(element, ...)  {
  grid::segmentsGrob(0,1,1,1, arrow = arrow())
}
## silly wrapper to fool ggplot2
axis_custom <- function(...){
  structure(
    list(...), # this ... information is not used, btw
    class = c("element_custom","element_blank", "element", "element_line") # inheritance test workaround
  )

}
