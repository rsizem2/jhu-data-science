rankall <- function(outcome, num = "best") {
    ## Read outcome data
    validoutcomes <- c("heart attack", "heart failure", "pneumonia")
    data1 <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
    ## Check that state and outcome are valid
    if (!is.element(outcome, validoutcomes)) {
        stop("invalid outcome")
    }
    ## Return hospital name in that state with lowest 30-day death
    data1 <- split(data1, data1$State)
    states <- names(data1)
    ## apply function to all states in the state list using sapply
    list1 <- sapply(states,function(state){
        statedata <- data.frame(data1[state])
        if (outcome == "heart attack") {
            label <- names(statedata)[11]
            completedata <- statedata[!(statedata[label] == "Not Available"),]
            rankeddata <- completedata[order(sapply(completedata[label], as.numeric), completedata[, 2]),]
            rankednames <- cbind(rankeddata[, 2], rankeddata[, 11])
        } else if (outcome == "heart failure") {
            label <- names(statedata)[17]
            completedata <- statedata[!(statedata[label] == "Not Available"),]
            rankeddata <- completedata[order(sapply(completedata[label], as.numeric), completedata[, 2]),]
            rankednames <- cbind(rankeddata[, 2], rankeddata[, 17])
        } else {
            label <- names(statedata)[23]
            completedata <- statedata[!(statedata[label] == "Not Available"),]
            rankeddata <- completedata[order(sapply(completedata[label], as.numeric), completedata[, 2]),]
            rankednames <- cbind(rankeddata[, 2], rankeddata[, 23])
        }
        max <- dim(rankednames)[1]
        ## rate
        if (num == "best") {
            rankednames[1, 1]
        } else if (num == "worst") {
            rankednames[max, 1]
        } else if (num >= 1 & num <= max) {
            rankednames[num, 1]
        } else {
            NA
        }
    })
    list1 <- data.frame(cbind(list1,states))
    print(dim(list1))
    names(list1) <- c("hospital","state")
    list1
}