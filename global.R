library(shiny)
library(shiny.fluent)
library(DT)
library(knitr)
library(shinythemes)
library(shinyalert)
library(bslib)
library(ShinyEditor)
library(shinydashboard)
library(ggplot2)
library(sortable)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
library(stringr)
library(shinyMonacoEditor)

source(file = "R/inputs.R")
source(file = "R/functions.R")

if(interactive()){
  shinyAppDir(getwd(), options = list())
}

