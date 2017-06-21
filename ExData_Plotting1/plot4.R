# Reading data
data <-
  read.table(
    "household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE
  )

# Retrieving subset from data
data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")

# Save current Drawing parameter
.pardefault <- par(no.readonly = T)

# Set multiple chars to 2x2
par(mfcol = c(2, 2), mar = c(4, 4, 2, 1))

# Draw first chart
with(
  data, plot(
    Global_active_power, type = "l", xaxt = "n", xlab = "", ylab = "Global Active Power"
  )
)
axis(1, at = seq(1, nrow(data), by = (nrow(data) - 1) / 2), labels = c("Thu", "Fri", "Sat"))

# Draw second chart
with(data, plot(
  Sub_metering_1, type = "l", xaxt = "n", xlab = "", ylab = "Energy sub metering"
))
with(data, lines(Sub_metering_2, col = "red"))
with(data, lines(Sub_metering_3, col = "blue"))
axis(1, at = seq(1, nrow(data), by = (nrow(data) - 1) / 2), labels = c("Thu", "Fri", "Sat"))
legend(
  "topright",
  lty = c(1, 1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
)

# Draw third chart
with(data, plot(
  Voltage, type = "l", xaxt = "n", xlab = "datetime", ylab = "Voltage"
))
axis(1, at = seq(1, nrow(data), by = (nrow(data) - 1) / 2), labels = c("Thu", "Fri", "Sat"))

# Draw fourth chart
with(
  data, plot(
    Global_reactive_power, type = "l", xaxt = "n", yaxt = "n", xlab = "datetime", ylab = "Global_reactive_power"
  )
)
axis(1, at = seq(1, nrow(data), by = (nrow(data) - 1) / 2), labels = c("Thu", "Fri", "Sat"))
axis(2, at = seq(0.0, 0.5, by = 0.1))

# Save plot to PNG file
if (Sys.info()['sysname'] == "Windows") {
  dev.copy(png, '.\\figure\\plot4.png')
} else {
  dev.copy(png, './figure/plot4.png')
}
dev.off()

# Reset Drawing parameter to previous setting
par(.pardefault)