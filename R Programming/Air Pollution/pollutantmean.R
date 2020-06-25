pollutantmean <- function(directory, pollutant, id = 1:332){
    #vector of filenames for each relevant dataset
    filenames <-lapply(id,function(x){
        if(x < 10){
            paste(directory,paste(paste("00",x,sep=""),"csv",sep="."),sep="/")
        }else if(x < 100){
            paste(directory,paste(paste("0",x,sep=""),"csv",sep="."),sep="/")
        }else{
            paste(directory,paste(x,"csv",sep="."),sep="/")
        }
    })
    #vector of non-NA counts for each relevant dataset
    num_measurements <-sapply(filenames,function(x){
        tempdata <- read.csv(x)
        column <- tempdata[pollutant]
        sum(!is.na(column))
    })
    #vector of mean values for each relevant dataset
    mean_values <- sapply(filenames, function(x){
        tempdata <- read.csv(x)
        column <- tempdata[pollutant]
        colSums(column,na.rm=TRUE)
    })
    sum(mean_values)/sum(num_measurements)
}