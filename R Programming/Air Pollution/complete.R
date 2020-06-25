complete <- function(directory, id = 1:332){
    filenames <-lapply(id,function(x){
        if(x < 10){
            paste(directory,paste(paste("00",x,sep=""),"csv",sep="."),sep="/")
        }else if(x < 100){
            paste(directory,paste(paste("0",x,sep=""),"csv",sep="."),sep="/")
        }else{
            paste(directory,paste(x,"csv",sep="."),sep="/")
        }
    })
    nobs <-sapply(filenames,function(x){
        temp <- read.csv(x)
        sum(complete.cases(temp))
    })
    data.frame(id,nobs)
}