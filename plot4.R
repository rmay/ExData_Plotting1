# Get the file, unzip it into the data directory
setwd("~/Dropbox/R/ExData_Plotting1")
data_dir <- "./data"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataset_zip <- "data/dataset.zip"
dataset_file <- "data/household_power_consumption.txt"
data_subset_file <- "data/data_subset.csv"

# If there isn't a subset of the data already, create it
if (!file.exists(file.path(getwd(), data_subset_file))) {
  
  if (!file.exists(file.path(getwd(), dataset_zip))) {
    print("Download file")
    download.file(url, dataset_zip, method="curl")
  }
  
  if (!file.exists(file.path(getwd(), dataset_file))) {
    print("Unzip file")
    unzip(file.path(dataset_file), list = FALSE, overwrite = TRUE,
          unzip = "internal",
          exdir = data_dir,
          setTimes = FALSE)
  }
  
  # Open the file, na = ? in this file
  print("Open file")
  data_set <- read.csv(dataset_file, header=T, sep=';', na.strings="?")
  
  print("Transform and select data")
  # Transform the date field from string to date in d/m/Y format
  data_set$Date <- as.Date(data_set$Date, format="%d/%m/%Y")
  
  # Select the date range from 2007-02-01 to 2007-02-02
  data_subset <- subset(data_set, subset=(Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")))
  
  # I did this to save the subset data to a file so I could tinker with the plot without having to load that massive file every time
  print("Save the subset file")
  write.csv(data_subset, file = "./data/data_subset.csv", row.names=FALSE)
  
  # Get rid of the full data set to free up memory
  rm(data_set)
} else {
  print("Load the subset file")
  data_subset <- read.csv("./data/data_subset.csv", header=T, sep=',', na.strings="?")  
}

# This plot, like plot 2 adn 3, needs to use date and time, not just date
data_subset$DateAndTime <- as.POSIXct(paste(as.Date(data_subset$Date), data_subset$Time))

# Living up to the plot's file name, this is four plots
print("Plots 4")
# The margins I took from the slides.
par(mfrow = c(2,2), mar = c(4, 4, 1, 1), oma = c(0, 0, 2, 0), cex.lab=0.80, cex.axis=0.75)
with(data_subset, {
  plot(DateAndTime, Global_active_power, ylab="Global Active Power", type="l", xlab="")
  plot(DateAndTime, Voltage, ylab="Voltage", type="l", xlab="datetime")
  plot(DateAndTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
  lines(DateAndTime, Sub_metering_2, type="l", col="red")
  lines(DateAndTime, Sub_metering_3, type="l", col="blue")
  legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1, 1, 1), cex = 0.70, bty = "n")
  plot(DateAndTime, Global_reactive_power, type="l", xlab="datetime")
  axis(2, at=c(0.1, 0.2, 0.3, 0.4, 0.5), labels=c(0.1, 0.2, 0.3, 0.4, 0.5))
})

print("Save plot 4 to png")
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()