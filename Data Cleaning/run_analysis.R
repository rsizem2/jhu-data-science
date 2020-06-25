# R script which creates a tidy dataset for the Data Cleaning Week 4 project.

# Download the data
dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataurl,"UCIdata.zip")
unzip("UCIdata.zip")
remove(dataurl)

# Read files into R
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
testdata <- read.table("UCI HAR Dataset/test/X_test.txt")
testactivity <- read.table("UCI HAR Dataset/test/y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
traindata <- read.table("UCI HAR Dataset/train/X_train.txt")
trainactivity <- read.table("UCI HAR Dataset/train/y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")


# Combine training/testing data into one table
names(activity_labels) <- c("label","activity")
names(testdata) <- features$V2
names(testactivity) <- "Activity"
names(testsubjects) <- "Subject"
testactivity <- sapply(testactivity, function(x){
    activity_labels$activity[x]
})
testdata <- cbind(testsubjects, testactivity, testdata)
remove(testactivity, testsubjects)

names(traindata) <- features$V2
names(trainactivity) <- "Activity"
names(trainsubjects) <- "Subject"
trainactivity <- sapply(trainactivity, function(x){
    activity_labels$activity[x]
})
traindata <- cbind(trainsubjects, trainactivity, traindata)
remove(trainactivity, trainsubjects)
data <- rbind(traindata, testdata)
remove(traindata, testdata)

# Save subject and activity columns for later
temp <- data[,1:2]

# Extract only the mean() and std() measurements from "data"
test <- data[,grep("std[(][)]|mean[(][)]",names(data))]
tidydata <- test[,-grep("BodyBody",names(test))]
remove(data, test)

# Make variable names more readable
oldnames <- names(tidydata)
names(tidydata) <- sapply(names(tidydata),function(x){
    domain <- if (grepl("^[f]", x)){
        "(Frequency Domain)"
    } else if (grepl("^[t]", x)){
        "(Time Domain)"
    }
    x <- sub("^[ft]","", x)

    component <- if(grepl("[-][X]$",x)){
        "X Component of"
    } else if (grepl("[-][Y]$",x)){
        "Y Component of"
    } else if (grepl("[-][Z]$",x)){
        "Z Component of"
    } else {
        "Magnitude of"
        }
    x <- sub("[-][XYZ]$","", x)
    x <- sub("Mag","",x)

    measurement <- if(grepl("std..$",x)){
        "Standard Deviation of the"
    } else if (grepl("mean..$",x)){
        "Mean of the"
    }
    x <- sub("[-]std..$|[-]mean..$","", x)

    force <- if(grepl("^Body",x)){
        "the Subject's"
    } else if (grepl("^Gravity",x)){
        "Gravity's"
    }
    x <- sub("^Body|^Gravity","", x)

    motion <- if(grepl("AccJerk",x)){
        "Linear Jerk"
    } else if (grepl("GyroJerk",x)){
        "Angular Jerk"
    } else if (grepl("Acc",x)){
        "Linear Acceleration"
    } else if (grepl("Gyro",x)){
        "Angular Acceleration"
    }
    paste(measurement, component, force, motion, domain)
},USE.NAMES = FALSE)
tidydata <- cbind(temp,tidydata)
remove(temp)


# Group data by Subject/Activity and average over the columns
groups <- split(tidydata, list(tidydata$Subject,tidydata$Activity))
newdata <- sapply(groups, function(x) {
    colMeans(x[-c(1,2)])
    })
newdata <- t(newdata)
subjects <- sapply(names(groups),function(x){
    sub("[.].*$","",x)
})
activity <- sapply(names(groups),function(x){
    sub("^.*[.]","",x)
})

# Create new dataset where each variable is the average measurement over each subject and activity
newdataset <- cbind(subjects,activity,newdata)
newdataset <- data.frame(newdataset)
names(newdataset) <- names(tidydata)

#Give a descriptive name for each variable
names(newdataset)[-c(1,2)] <- sapply(oldnames,function(x){
    domain <- if (grepl("^[f]", x)){
        "(Freq)"
    } else if (grepl("^[t]", x)){
        "(Time)"
    }
    x <- sub("^[ft]","", x)

    component <- if(grepl("[-][X]$",x)){
        "along X-axis"
    } else if (grepl("[-][Y]$",x)){
        "along Y-axis"
    } else if (grepl("[-][Z]$",x)){
        "along Z-axis"
    } else {
        ""
    }
    x <- sub("[-][XYZ]$","", x)
    x <- sub("Mag","",x)

    measurement <- if(grepl("std..$",x)){
        "Standard Deviation of the"
    } else if (grepl("mean..$",x)){
        "Average of the"
    }
    x <- sub("[-]std..$|[-]mean..$","", x)

    force <- if(grepl("^Body",x)){
        ""
    } else if (grepl("^Gravity",x)){
        "Gravitational"
    }
    x <- sub("^Body|^Gravity","", x)

    motion <- if(grepl("AccJerk",x)){
        "Jerk"
    } else if (grepl("GyroJerk",x)){
        "Angular Jerk"
    } else if (grepl("Acc",x)){
        "Acceleration"
    } else if (grepl("Gyro",x)){
        "Angular Acceleration"
    }
    paste(measurement, force, motion, component, domain)
},USE.NAMES = FALSE)

names(newdataset)[c(1,2)] <- c("Subject", "Activity")
row.names(newdataset) <- NULL
remove(oldnames,subjects,activity,activity_labels,groups,features,newdata)

#Save dataset to a file
write.table(newdataset,"tidydata.csv",row.name=FALSE)
