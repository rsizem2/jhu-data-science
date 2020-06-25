library(dplyr)

# Download data and extract .txt if it doesn't exist
if(!file.exists("household_power_consumption.txt")){
    dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(dataurl, "data.zip")
    unzip("data.zip")}

# Read in the data, filter out irrelevant dates/times
data <- read.csv("household_power_consumption.txt",sep=";", 
                 na.strings = "?")
data <- tbl_df(data)
twodays <- filter(data, Date == "1/2/2007" | Date == "2/2/2007")
twodays <- mutate(twodays, datetime = as.POSIXct(strptime(
    paste(Date, Time),"%d/%m/%Y %H:%M:%S")))

#Create plot2.png and close graphics device
png(filename = "plot2.png", width = 480, height = 480)
with(twodays, plot(datetime,Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = ""))
dev.off()
