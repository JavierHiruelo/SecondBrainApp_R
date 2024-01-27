
source(file = "R/sidebar.R")
source(file = "R/body.R")

########################
### SHINY APP HEADER ###
########################

header <- dashboardHeader(
  title = "Second Brain App",
  dropdownMenuOutput("messageMenu")
) # dashboardHeader

#########################
### SHINY APP SIDEBAR ###
#########################

sidebar <- dashboardSidebar(
  
  sidebarMenu( id = "sidebar", 
               foodTrackerTab, exerciseTrackerTab, noteTakingTab,
               kanbanTab, statisticsTab, aboutTab
  ) # sidebarMenu
  
) # dashboardSideBar

######################
### SHINY APP BODY ###
######################

body <- dashboardBody(
  
  tabItems( foodTackerBody, exerciseTrackerBody, noteTakingBody,
            kanbanBody, statisticsBody, aboutBody
  ) # tabItems
  
) # dashboardBody

######################
### UI DECLARATION ###
######################

ui <- dashboardPage( skin = "purple",
                     header = header,
                     sidebar = sidebar,
                     body = body
) # dashboardPage
