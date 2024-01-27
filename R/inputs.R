
#######################################
### INPUTS OF THE FOOD TRACKER BODY ###
#######################################

calendar <- dateInput( label = "Fecha", value = Sys.Date(),
                       inputId = "calendar",  format = "dd/mm/yyyy")

###########################################
### INPUTS OF THE EXERCISE TRACKER BODY ###
###########################################

exerciseCalendar <- dateInput( label = "Fecha", inputId = "exerciseCalendar", 
                               format = "dd/mm/yyyy")

exerciseName <- textInput( label = "Ejercicio", inputId = "exerciseName")

setsNumber <- numericInput( label = "Sets", inputId = "setsNumber", 
                            value = 1, min = 1)

repsNumber <- numericInput( label = "Repeticiones", inputId = "repsNumber", 
                            value = 1,min = 1)

exerciseTime <- numericInput( label = "Tiempo en Minutos", inputId = "exerciseTime", 
                              value = 0, min = 0)

weight <- numericInput( label = "Peso en Kg", inputId = "weight", 
                        value = 0, min = 0)

excersiceSensation <- selectInput( label = "Sensación", 
                                   inputId = "excersiceSensation", 
                                   choices = c("Muy Fácil","Bien",
                                               "Difícil","No más"), 
                                   selected = "Bien")

exerciseType <- selectInput( label = "Tipo", inputId = "exerciseType",
                             choices = c("Calentamiento","Ejercicios","Postentreno"),
                             selected = "Ejercicios")

addExercise <- actionButton( label = "Añadir Ejercicio", inputId = "addExercise")

######################################
### INPUTS OF THE NOTE TAKING BODY ###
######################################

noteTakingEditorInput <- editor('textcontent', options = "branding: false, height: 600,
               plugins: ['lists', 'table', 'link', 'image', 'code'],
               toolbar1: 'bold italic forecolor backcolor | formatselect fontselect fontsizeselect | alignleft aligncenter alignright alignjustify',
               toolbar2: 'undo redo removeformat bullist numlist table blockquote code superscript  subscript strikethrough link image'")

saveButton <- actionButton( label = "Save", inputId = "saveButton",
                            icon = icon("floppy-disk") ) # actionButton

#################################
### INPUTS OF THE KANBAN BODY ###
#################################

taskName <- textInput( inputId = "taskName", label = NULL )

fromToTask <- dateRangeInput( inputId = "fromToTask", label = NULL, 
                              format = "dd/mm/yyyy" )

taskDescription <- textInput( inputId = "taskDescription", label = NULL )

addTask <- actionButton(inputId = "addTask", label = "ADD TASK",
                        icon = icon("plus"))

#####################################
### INPUTS OF THE STATISTICS BODY ###
#####################################

selectFoodGraphs <- selectInput( label = "Food Tracker Graphs",
                                 inputId = "selectFoodGraphs", 
                                 choices = c("Total","Desayuno",
                                             "Comida","Cena",
                                             "Aperitivos") ) # selectInput

