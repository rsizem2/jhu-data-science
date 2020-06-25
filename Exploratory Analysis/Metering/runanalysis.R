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

# Create plot1.png and close graphics device
png(filename = "plot1.png", width = 480, height = 480)
hist(twodays$Global_active_power, col = "red",main="Global Active Power", xlab = "Global Active Power (kilowatts)" )
dev.off()

#Create plot2.png and close graphics device
png(filename = "plot2.png", width = 480, height = 480)
with(twodays, plot(datetime,Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = ""))
dev.off()

# Create plot3.png and close graphics device
png(filename = "plot3.png", width = 480, height = 480)
with(twodays, plot(datetime,Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(twodays, points(datetime,Sub_metering_2, type = "l", col = "red"))
with(twodays, points(datetime,Sub_metering_3, type = "l", col = "blue"))
legend("topright", col = c("black","red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = c(1,1,1))
dev.off()

# Create plot4.png and close graphics device
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2), mar = c(4,4,2,2), oma = c(0,0,2,0))
with(twodays, {
    plot(datetime,Global_active_power, type = "l", xlab ="", 
         ylab = "Global Active Power")
    plot(datetime, Voltage, type = "l")
    plot(datetime,Sub_metering_1, type = "l", xlab = "", 
         ylab = "Energy sub metering")
    points(datetime,Sub_metering_2, type = "l", col = "red")
    points(datetime,Sub_metering_3, type = "l", col = "blue")
    legend("topright", col = c("black","red", "blue"), 
           legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           lty = c(1,1,1), box.lty = 0)
    plot(datetime, Global_reactive_power, type = "l")
})
dev.off()
