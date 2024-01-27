
source(file = "www/inputs.R")

#######################################
### OBJECT OF THE FOOD TRACKER BODY ###
#######################################

foodTackerBody <- tabItem(tabName = "foodTracker",
                          box(width = 3, collapsible = TRUE, 
                              background = "purple",
                              calendar,
                              uiOutput("foodUrl")
                          ), # box
                          mainPanel(
                            tags$label(h1("Base de Datos de Calorías")),
                            DT::dataTableOutput("caloriesTable"),
                            br()
                          ) # mainPanel
)

###########################################
### OBJECT OF THE EXERCISE TRACKER BODY ###
###########################################

exerciseTrackerBody <- tabItem(
  tabName = "exerciseTracker",
  box(width = 4,
      collapsible = TRUE,
      background = "purple",
      exerciseCalendar, exerciseName, setsNumber, repsNumber, exerciseTime,
      weight, excersiceSensation, exerciseType, addExercise
  ),
  mainPanel(
    tags$label(h1("Base de Datos de Ejercicios")),
    h1(textOutput(outputId="OUT1")),
    DT::dataTableOutput("OUTTable1"),
    h1(textOutput(outputId="OUT2")),
    DT::dataTableOutput("OUTTable2"),
    h1(textOutput(outputId="OUT3")),
    DT::dataTableOutput("OUTTable3"),
    br()
  ) # mainPanel
)

######################################
### OBJECT OF THE NOTE TAKING BODY ###
######################################

noteTakingBody <- tabItem(
  use_editor("ncpxc1qvvp8yv3zsozdr5as3n7qti5j3u7852ef218zy43xv"),
  tabName = "noteTaking",
  column( width = 6, noteTakingEditorInput, br(), saveButton ), # column
  column( width = 6, tags$pre(textOutput("rawText")) ) # column
)

#################################
### OBJECT OF THE KANBAN BODY ###
#################################

kanbanBody <- tabItem(
  tabName = "kanbanTab",
  fluidRow(
    box(
      width = "auto", background = "purple", collapsible = TRUE,
      box( title = "TASK", background = "purple", width = 3, 
           height = "auto", taskName ), # Task Name Box
      box( title = "BEGIN/END", background = "purple", width = 3, 
           height = "auto", fromToTask ), # Begining and End Box
      box( title = "DESCRIPTION", background = "purple", width = 3, 
           height = "auto", taskDescription ), # Description Box
      box( title = "", background = "purple", width = 3, 
           height = "auto", addTask ) # AddTask Box
    ) # Big Box
  ),  # 1st FluidRow
  fluidRow(
    column(width = 4,
           box( title = "TO DO", status = "primary", collapsible = TRUE,
                solidHeader = TRUE, width = 12, height = "auto", 
                uiOutput("todoOutput") ) # box
    ), # column
    column(width = 4,
           box( title = "IN PROGRESS", status = "warning", collapsible = TRUE,
                solidHeader = TRUE, width = 12, height = "auto", 
                uiOutput("inprogressOutput") ) # box
    ), # column
    column(width = 4,
           box( title = "DONE", status = "success", collapsible = TRUE,
                solidHeader = TRUE, width = 12, height = "auto", 
                uiOutput("completeOutput") ) # box
    ) # column
  ) # 2nd FluidRow
)

#####################################
### OBJECT OF THE STATISTICS BODY ###
#####################################

statisticsBody <- tabItem(
  tabName = "statisticsTab",
  column( width = 6, selectFoodGraphs, uiOutput("foodGraph") ), # column
  column( width = 6, uiOutput("exerciseGraph") )
)

################################
### OBJECT OF THE ABOUT BODY ###
################################

aboutBody <- tabItem( tabName = "aboutTab", titlePanel("About"), 
                      div(includeMarkdown("about.md"), align="justify"),
)
