corr <- function(directory, threshold = 0){
    filenames <- lapply(dir(path=directory),function(x){
        paste(directory,x,sep="/")
    })
    #Vector of number of complete cases for each file in filenames
    total_complete <- sapply(filenames, function(x){
        temp <- read.csv(x)
        sum(complete.cases(temp))
    })
    filenames <- filenames[total_complete > threshold]
    if(length(filenames) > 0){
        sapply(filenames,function(x){
            temp <- read.csv(x)
            temp <- temp[complete.cases(temp),]
            cor(temp["sulfate"],temp["nitrate"])
        })
    }else{
        vector(mode="numeric")
    }
    
}