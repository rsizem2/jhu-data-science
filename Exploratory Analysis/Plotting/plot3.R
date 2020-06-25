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

# Create plot3.png and close graphics device
png(filename = "plot3.png", width = 480, height = 480)
with(twodays, plot(datetime,Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(twodays, points(datetime,Sub_metering_2, type = "l", col = "red"))
with(twodays, points(datetime,Sub_metering_3, type = "l", col = "blue"))
legend("topright", col = c("black","red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = c(1,1,1))
dev.off()
