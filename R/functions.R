
##################################
### CALORIES TRACKER FUNCTIONS ###
##################################

## Function to add dates to the calories data
caloriesDataAddDay <- function(caloriesDataFrame, dayToAdd = Sys.Date()){
  if(!(format(dayToAdd,"%d/%m/%Y") %in% caloriesDataFrame$Día)) {
    caloriesDataFrame[nrow(caloriesDataFrame)+1,] <-
      c(format(dayToAdd,"%d/%m/%Y"),0,0,0,0)
  }
  write.csv(caloriesDataFrame,"R/calories.csv",row.names = FALSE)
}

## Function to render datatables (USED FOR CALORIES AND EXERCISE TRACKER)
renderTrackerDT <- function(tackerDataFrame, paging = FALSE) {
  
  dataTable <- DT::renderDataTable(
    tackerDataFrame, editable = TRUE, rownames = FALSE, extensions = "Buttons",
    options = list(paging = paging, searching = FALSE, fixedColumns = TRUE,
                   autoWidth = FALSE, dom = 'Bfrtip', buttons = c("csv","copy","pdf")
    ), class = "display" 
  ) 
  
  return(dataTable)
  
}

##################################
### EXERCISE TRACKER FUNCTIONS ###
##################################



########################
### KANBAN FUNCTIONS ###
########################

## Function to create the lists of tasks to be added on the Kanban
kanbanTagList <- function(messagesDataFrame) {
  
  if(nrow(messagesDataFrame)!=0){
    kanbanTagList <- apply(messagesDataFrame, 1, function(row){
      tagList( 
        if(!is.na(row[["description"]])){
          div( h3(paste(row[["name"]],"-",row[["end"]])),
               h5(row[["description"]]) ) 
        } else { div( h3(paste(row[["name"]],"-",row[["end"]])) ) } ) 
    }) 
  } else { kanbanTagList <- NULL }
  
  return(kanbanTagList)
  
}

## Function to render the kanban with its three packs of tasks
renderKanban <- function(todoLabels = NULL,
                         inProgressLabels = NULL,
                         completedLabels = NULL) {
  
  renderUI({ fluidRow( column( width = 12,
    bucket_list( header = NULL,
      group_name = "kanbanListGroup", orientation = "horizontal",
      add_rank_list( text = "To Do", input_id = "todoList", labels = todoLabels),
      add_rank_list(text = "In Progress", labels = inProgressLabels, input_id = "inProgressList"),
      add_rank_list(text = "Completed", labels = completedLabels, input_id = "completedList"))))
    })
}