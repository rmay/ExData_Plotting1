# Get the file, unzip it into the data directory
setwd("~/Dropbox/R/ExData_Plotting1")
data_dir <- "./data"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataset_zip <- "data/dataset.zip"
dataset_file <- "data/household_power_consumption.txt"

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

# Get rid of the full data set to free up memory
rm(data_set)

# Plot 1
print("Plot 1 as hist")
hist(data_subset$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red", ylim=c(0, 1200))


# Save to png
print("Save plot 1 to png")
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()