# Reading data
data <-
  read.table(
    "household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE
  )

# Retrieving subset from data
data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")

# Save current Drawing parameter
.pardefault <- par(no.readonly = T)

# Draw line chart
with(
  data, plot(
    Global_active_power, type = "l", xaxt = "n", xlab = "", ylab = "Global Active Power (kilowatts)"
  )
)
axis(1, at = seq(1, nrow(data), by = (nrow(data) - 1) / 2), labels = c("Thu", "Fri", "Sat"))

# Save plot to PNG file
if (Sys.info()['sysname'] == "Windows") {
  dev.copy(png, '.\\figure\\plot2.png')
} else {
  dev.copy(png, './figure/plot2.png')
}

dev.off()

# Reset Drawing parameter to previous setting
par(.pardefault)
