rankhospital <- function(state, outcome, rank = "best") {
    ## Read outcome data
    validoutcomes <- c("heart attack", "heart failure", "pneumonia")
    data1 <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
    ## Check that state and outcome are valid
    if (!is.element(state,data1$State)){
        stop("invalid state")
    } else if (!is.element(outcome, validoutcomes)) {
        stop("invalid outcome")
    } 
    ## Return hospital name in that state with lowest 30-day death
    ## split data by state
    data1 <- split(data1, data1$State)
    ## choose subset based on user provided state
    statedata <- data.frame(data1[state])
    if (outcome == "heart attack"){
        label <- names(statedata)[11]
        completedata <- statedata[!(statedata[label] == "Not Available"),]
        rankeddata <- completedata[order(sapply(completedata[label],as.numeric),completedata[,2]),]
        rankednames <- cbind(rankeddata[,2],rankeddata[,11])
    } else if (outcome == "heart failure"){
        label <- names(statedata)[17]
        completedata <- statedata[!(statedata[label] == "Not Available"),]
        rankeddata <- completedata[order(sapply(completedata[label],as.numeric),completedata[,2]),]
        rankednames <- cbind(rankeddata[,2],rankeddata[,17])
    } else {
        label <- names(statedata)[23]
        completedata <- statedata[!(statedata[label] == "Not Available"),]
        rankeddata <- completedata[order(sapply(completedata[label],as.numeric),completedata[,2]),]
        rankednames <- cbind(rankeddata[,2],rankeddata[,23])
    }
    max <- dim(rankednames)[1]
    ## rate
    if (rank == "best"){
        rankednames[1,1]
    } else if (rank == "worst"){
        rankednames[max,1]
    } else if (rank >= 1 & rank <= max){
        rankednames[rank,1]
    } else {
        NA
    }
    
}