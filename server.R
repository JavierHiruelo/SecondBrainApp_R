
caloriesData <- read.csv(file = "R/calories.csv")
caloriesDataAddDay(caloriesDataFrame = caloriesData)

server <- function(input,output,session){
  
  #####################################
  ### READING OF THE REACTIVE FILES ###
  #####################################
  caloriesData <- reactiveFileReader(100, session = session,
                                     "R/calories.csv",read.csv)
  exerciseData <- reactiveFileReader(100, session = session,
                                     "R/exercise.csv",read.csv)
  messageData <- reactiveFileReader(100, session = session,
                                    "R/messageData.csv", read.csv)
  # Kanban messages - 50 ms seems to be the best to skip errors
  todoMessages <- reactiveFileReader(60, session = session,
                                     "R/Kanban/todoMessages.csv", read.csv)
  inProgressMessages <- reactiveFileReader(60, session = session,
                                           "R/Kanban/inProgressMessages.csv", read.csv)
  completedMessages <- reactiveFileReader(60, session = session,
                                          "R/Kanban/completedMessages.csv", read.csv)
  
  ##############################
  ### FOOD TRACKER FUNCTIONS ###
  ##############################
  
  ### Show the MyFitness Pal link 
  output$foodUrl <- renderUI({
    tagList("",a("MyFitnessPal", href = "https://www.myfitnesspal.com/es"))
  })
  
  ### Render Calories Data Table
  observe({
    copia <<- caloriesData()
    caloriesDataCopy <- copia[order(as.Date(copia$Día, format = "%d/%m/%Y"),
                                    decreasing = TRUE),]
    output$caloriesTable <- renderTrackerDT(caloriesDataCopy, paging = TRUE)
  })
  
  ### Saves changes when editing Food Data Base
  observeEvent(input$caloriesTable_cell_edit,{
    
    copia <<- caloriesData()
    copia[rev(order(as.Date(copia$Día, format = "%d/%m/%Y"))),][input$caloriesTable_cell_edit$row,input$caloriesTable_cell_edit$col+1] <<- 
      input$caloriesTable_cell_edit$value
    
    write.csv(copia,"R/calories.csv",row.names = FALSE)
    
  }) # observeEvent - caloriesTable_cell_edit
  
  ### Adds a row for a new day
  observeEvent(input$calendar,{
    
    copia <<- caloriesData()
    caloriesDataAddDay(caloriesDataFrame = copia, dayToAdd = input$calendar)

  },ignoreInit = TRUE)
  
  ##################################
  ### EXERCISE TRACKER FUNCTIONS ###
  ##################################
  
  ### Render Exercise Tracker Table
  observe({
    
    exerciseCopy <<- exerciseData()
    
    numberOfDays <- length(unique(exerciseCopy$Día))
    
    lapply(1:numberOfDays, function(i){
      outputTextId <- paste0("OUT",i)
      outputTableId <- paste0("OUTTable",i)
      exerciseCopyDF <- exerciseCopy[exerciseCopy$Día == unique(exerciseCopy$Día)[numberOfDays - i + 1],]
      exerciseCopyDF$Día = NULL
      
      output[[outputTextId]] <- renderText(unique(exerciseCopy$Día)[numberOfDays - i + 1])
      output[[outputTableId]] <- renderTrackerDT(exerciseCopyDF)
    })
    
  })
  
  ### Saves changes when editing Exercise Data Base
  ### TODO NO FUNCIONA, NO PUEDES GUARDAR LOS DATOS
  observeEvent(input$exerciseTable_cell_edit,{
    exerciseCopy <<- exerciseData()
    exerciseCopy[rev(order(as.Date(exerciseCopy$Día, format = "%d/%m/%Y"))),][input$exerciseTable_cell_edit$row,input$exerciseTable_cell_edit$col+1] <<- 
      input$exerciseTable_cell_edit$value
    
    write.csv(exerciseCopy,"R/exercise.csv",row.names = FALSE)
  }) # cell editing
  
  ### Add a row to Exercisedataframe
  observeEvent(input$addExercise,{
    exerciseCopy <<- exerciseData()
    
    exerciseCopy[nrow(exerciseCopy)+1,] <<- c(format(input$exerciseCalendar,"%d/%m/%Y"),
                                              input$exerciseName,
                                              input$setsNumber,
                                              input$repsNumber,
                                              input$exerciseTime,
                                              input$weight,
                                              input$excersiceSensation,
                                              input$exerciseType)
    
    write.csv(exerciseCopy,"R/exercise.csv",row.names = FALSE)
    
    updateTextInput(session, "exerciseName", value = "")
  })
  
  #######################
  ### NOTES FUNCTIONS ###
  #######################
  
  ### Generate HTML
  values <- reactiveValues(a = NULL)
  
  observe({
    editorText(session, editorid = 'textcontent', outputid = 'mytext')
    req(input$mytext)
    values$a <- enc2utf8(input$mytext)
  })
  
  output$rawText <- renderText({
    req(values$a)
    values$a
  })
  
  ### Save the file in a html format
  observeEvent(input$saveButton, {
    req(values$a)
    shinyalert::shinyalert(title = "Nombra al archivo",
                           type = "input",
                           callbackR = function(value) {
                             write(values$a,file = paste0("www/HTML Notes/",value,".html"))
                           }) # shinyalert
  })
  
  #######################
  ### TASKS FUNCTIONS ###
  #######################

  ### Function to add a task
  # TODO HACER QUE NO SE PUEDAN AÑADIR TASKS CON NOMBRES REPETIDOS
  observeEvent(input$addTask, {
    
    messageDataCopy <<- messageData()
    
    messageDataCopy[nrow(messageDataCopy)+1,] <<- 
      c("Tasks" , input$taskName, format(input$fromToTask[1],"%d/%m/%Y"),
        format(input$fromToTask[2],"%d/%m/%Y"), input$taskDescription)
    
    write.csv(messageDataCopy,"R/messageData.csv",row.names = FALSE)
    
    updateDateInput(session, "taskName", value = "")
    updateTextInput(session, "taskDescription", value = "")
    
  }) # observeEvent
  
  ### Function to render the messages of the tasks
  observe({
    
    messageDataCopy <<- messageData()
    
    output$messageMenu <- renderMenu({
      if(nrow(messageDataCopy)!=0){
        msgs <- apply(messageDataCopy, 1, function(row) {
          messageItem( from = row[["from"]], message = row[["name"]] )
        }) # apply
      } else {
        msgs <- NULL
      }
      dropdownMenu( type = "messages", .list = msgs, icon = icon("list-check") ) # dropdownMenu
    }) # renderMenu
  })
    

  ##################################
  ### KANBAN DASHBOARD FUNCTIONS ###
  ##################################
  
  # Add a new task on todoMessages
  observeEvent(input$addTask, {
    
    todoMessagesCopy <<- todoMessages()
    
    todoMessagesCopy[nrow(todoMessagesCopy)+1,] <<-
      c("Tasks" , input$taskName, format(input$fromToTask[1],"%d/%m/%Y"),
        format(input$fromToTask[2],"%d/%m/%Y"), input$taskDescription)
    
    write.csv(todoMessagesCopy,"R/Kanban/todoMessages.csv",row.names = FALSE)
    
  }) # observeEvent

  # Update todoMessages
  observeEvent(input$todoList,{
    
    messageDataCopy <<- messageData()

    # To Do
    if(!is.na(input$todoList[1])) {
      todoList <- input$todoList
      splitedNames <- str_split_fixed(todoList," -", 2)
      todoMessagesCopy <- messageDataCopy[messageDataCopy$name %in% splitedNames[,1],]
    } else {
      todoMessagesCopy <- data.frame(matrix(ncol = 5,nrow = 0))
      colnames(todoMessagesCopy) <- c("from","name","start","end","description")
    }
    
    write.csv(todoMessagesCopy, "R/Kanban/todoMessages.csv", row.names = F)
    
  })
  
  # Update inProgressMessages
  observeEvent(input$inProgressList,{
    
    messageDataCopy <<- messageData()
    
    # In Process
    if(!is.na(input$inProgressList[1])) {
      inProgressList <- input$inProgressList
      splitedNames <- str_split_fixed(inProgressList," -", 2)
      inProgressMessagesCopy <- messageDataCopy[messageDataCopy$name %in% splitedNames[,1],]
    } else {
      inProgressMessagesCopy <- data.frame(matrix(ncol = 5,nrow = 0))
      colnames(inProgressMessagesCopy) <- c("from","name","start","end","description")
    }
    
    write.csv(inProgressMessagesCopy, "R/Kanban/inProgressMessages.csv", row.names = F)
    
  })
  
  # Update completedMessages
  observeEvent(input$completedList,{
    
    messageDataCopy <<- messageData()
    
    # Completed
    if(!is.na(input$completedList[1])) {
      completedList <- input$completedList
      splitedNames <- str_split_fixed(completedList," -", 2)
      completedMessagesCopy <- messageDataCopy[messageDataCopy$name %in% splitedNames[,1],]
    } else {
      completedMessagesCopy <- data.frame(matrix(ncol = 5,nrow = 0))
      colnames(completedMessagesCopy) <- c("from","name","start","end","description")
    }
    
    write.csv(completedMessagesCopy, "R/Kanban/completedMessages.csv", row.names = F)

  })
  
  ### Rendering of the kanban board
  observe({
    
    # Create the labels lists for the rendering of the kanban
    todo <- kanbanTagList(todoMessages())
    inProgress <- kanbanTagList(inProgressMessages())
    completed <- kanbanTagList(completedMessages())
    
    # We render the kanban
    output$kanbanBoard <- renderKanban(todoLabels = todo,
                                       inProgressLabels = inProgress,
                                       completedLabels = completed)
  })
  
  ### Delete the messages that are on complete
  # First we delete the completed tasks from messagesData
  observeEvent(input$achiveTasks, {
    messageDataCopy <<- messageData()
    messageDataCopy <<- messageDataCopy[!(messageDataCopy$name  %in% completedMessages()$name),]
    write.csv(messageDataCopy,"R/messageData.csv",row.names = FALSE)
  })
  
  # Then we reset the completedMessages
  observeEvent(input$achiveTasks, {
    completedMessagesCopy <- data.frame(matrix(ncol = 5,nrow = 0))
    colnames(completedMessagesCopy) <- c("from","name","start","end","description")
    write.csv(completedMessagesCopy, "R/Kanban/completedMessages.csv", row.names = F)
  })
  
  ############################
  ### STATISTICS FUNCTIONS ###
  ############################
  
  # Create the graphs for the calories
  output$foodGraph <- renderUI({
    switch (input$selectFoodGraphs,
            Total = {
              renderPlot(
                ggplot(copia, 
                       aes(x = as.Date(Día,
                                       format = "%d/%m/%Y"), 
                           y = Desayuno+Comida+Cena+Aperitivos)) +
                  labs(x = "Months", 
                       y = "Total Calories (kcal)", 
                       title = "Diary of Consumption of Calories") +
                  theme(axis.text = element_text(color = "slateblue",
                                                 size = 12)) +
                  geom_area(fill = "slateblue", alpha = 0.6)+
                  geom_line(colour = "slateblue") +
                  geom_point() +
                  geom_hline(yintercept = 1800,
                             linetype = 2,
                             color = 2,
                             linewidth = 1)
              )
            }, # Total
            {
              yData <- copia[[input$selectFoodGraphs]]
              renderPlot(
                ggplot(copia, 
                       aes(x = as.Date(Día,
                                       format = "%d/%m/%Y"), 
                           y = yData)) +
                  labs(x = "Months", 
                       y = paste0("Calories of ",input$selectFoodGraphs, " (kcal)"), 
                       title = "Calories") +
                  theme(axis.text = element_text(color = "slateblue",
                                                 size = 12)) +
                  geom_area(fill = "slateblue", alpha = 0.6)+
                  geom_line(colour = "slateblue") +
                  geom_point() +
                  geom_hline(yintercept = 450,
                             linetype = 2,
                             color = 2,
                             linewidth = 1)
              ) # renderPlot
            } # Default Case
    )
  }) # output$foodGraph
  
  # Create the graphs of exercise
  output$exerciseGraph <- renderUI({
    plotData <- aggregate(exerciseCopy$Tiempo,
                          by = list(day=exerciseCopy$Día),
                          FUN = sum)
    renderPlot(
      ggplot(plotData, 
             aes(x = as.Date(day,
                             format = "%d/%m/%Y"), 
                 y = x)) +
        labs(x = "Days of Training", 
             y = "Total Minutes of Training", 
             title = "Total Minutes of Training") +
        theme(axis.text = element_text(color = "slateblue",
                                       size = 12)) +
        geom_area(fill = "slateblue", alpha = 0.6)+
        geom_line(colour = "slateblue") +
        geom_point() +
        geom_hline(yintercept = 20,
                   linetype = 2,
                   color = 2,
                   linewidth = 1)
    )
  })
  
}