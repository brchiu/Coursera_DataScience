# Reading data
data <-
  read.table(
    "household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE
  )

# Retrieving subset from data
data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")

# Save current Drawing parameter
.pardefault <- par(no.readonly = T)

# Draw histogram chart
with(
  data, hist(
    as.numeric(Global_active_power),
    freq = TRUE, col = "red", xlim = c(0, 6), ylim = c(0, 1200),
    xaxt = "n", yaxt = "n",
    main = "Global Active Power", ylab = "Frequency", xlab = "Global Active Power (kilowatts)"
  )
)
axis(1, at = seq(0, 6, by = 2))
axis(2, at = seq(0, 1200, by = 200))

# Save plot to PNG file
if (Sys.info()['sysname'] == "Windows") {
  dev.copy(png, '.\\figure\\plot1.png')
} else {
  dev.copy(png, './figure/plot1.png')
}

dev.off()

# Reset Drawing parameter to previous setting
par(.pardefault)