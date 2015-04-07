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

# This plot needs to use date and time, not just date
data_subset$DateAndTime <- as.POSIXct(paste(as.Date(data_subset$Date), data_subset$Time))

# Plot 2
print("Plot 2")
with(data_subset, plot(DateAndTime, Global_active_power, main="Global Active Power", ylab="Global Active Power (kilowatts)", xlab="", type="l" ))

print("Save plot 2 to png")
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()