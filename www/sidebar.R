### File that contains all the objects from the 
### Second Brain Shiny App
### Author: Javier Hiruelo Pérez
### javier.hiruelo@gmail.com

#####################################################
### OBJECT OF THE FOOD TACKER TAB ON THE SIDE BAR ###
#####################################################

foodTrackerTab <- menuItem("Food Tracker", 
                           tabName = "foodTracker",
                           icon = icon("utensils"))

#########################################################
### OBJECT OF THE EXERCISE TACKER TAB ON THE SIDE BAR ###
#########################################################

exerciseTrackerTab <- menuItem("Exercise Tracker", 
                               tabName = "exerciseTracker", 
                               icon = icon("dumbbell"))

#####################################################
### OBJECT OF THE NOTE TAKING TAB ON THE SIDE BAR ###
#####################################################

noteTakingTab <- menuItem("Note Taking", 
                          tabName = "noteTaking", 
                          icon = icon("note-sticky"))

###############################################
### OBJECT OF THE KANBA TAB ON THE SIDE BAR ###
###############################################

kanbanTab <- menuItem("Kanban", 
                      tabName = "kanbanTab", 
                      icon = icon("check"), 
                      badgeColor = "green", 
                      badgeLabel = textOutput(outputId = "newTask"))

####################################################
### OBJECT OF THE STATISTICS TAB ON THE SIDE BAR ###
####################################################

statisticsTab <- menuItem("Statistics", 
                          tabName = "statisticsTab", 
                          icon = icon("chart-line"))

###############################################
### OBJECT OF THE ABOUT TAB ON THE SIDE BAR ###
###############################################

aboutTab <- menuItem("About", 
                     tabName = "aboutTab", 
                     icon = icon("circle-info"))
