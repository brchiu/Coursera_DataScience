# Auto install dplyr & tidyr packages

if ("dplyr" %in% rownames(installed.packages()) == FALSE) {
  install.packages("dplyr")
}

if ("tidyr" %in% rownames(installed.packages()) == FALSE) {
  install.packages("tidyr")
}
library("tidyr")
library("dplyr")

# Check existence of data files
chkf <- function (...) {
  args <- list(...)
  for (f in args) {
    if (file.exists(f) == FALSE) {
      return(FALSE)
    }
  }
  TRUE
}

if (chkf(
  file.path("train", "subject_train.txt"),
  file.path("train", "X_train.txt"),
  file.path("train", "y_train.txt"),
  file.path("test", "subject_test.txt"),
  file.path("test", "X_test.txt"),
  file.path("test", "y_test.txt"),
  file.path("features.txt")
) == FALSE) {
  stop("Some files not exist, perhaps in wrong working directory !!")
}

# An variable to determine whether 'spreading' of 'mean(); and 'std()' of
# an 'observed' signal is performed or not.
apply_spread <- FALSE

## Step 1   : Merges the training and the test sets to create one data set.

all_data <-
  rbind(
    read.table(file.path("train", "X_train.txt"), stringsAsFactors = FALSE),
    read.table(file.path("test", "X_test.txt"), stringsAsFactors = FALSE)
  )

## Step 2   : Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt", stringsAsFactors = FALSE)

# extract features name having 'mean()' and 'std()'
features <- features[grep("(mean|std)\\(\\)", features[,2]),]
features[,2] <- gsub("\\(\\)", "", features[,2])

# modify feature name, ex : fBodyAccJerk-mean-X to  fBodyAccJerkX-mean
# it is for easier manipulation in tidyr::separate function

if (apply_spread == TRUE) {
  features[,2] <- sapply(features[,2],
                         function(x) {
                           t <- strsplit(x, "-")[[1]]
                           if (length(t) == 3) {
                             t[c(2,3)] <- t[c(3,2)]
                             paste(paste(t[1], t[2], sep = '', collapse = ''), t[3], sep = '-', collapse = '-')
                           } else {
                             paste(as.list(t), collapse = '-')
                           }
                         })
}

# extract only these features from all_data
all_data <- all_data[,features[,1]]

## Step 3   : Uses descriptive activity names to name the activities in the data set

all_y <-
  rbind(
    read.table(file.path("train", "y_train.txt"), stringsAsFactors = FALSE),
    read.table(file.path("test", "y_test.txt"), stringsAsFactors = FALSE)
  )

all_subject <-
  rbind(
    read.table(file.path("train", "subject_train.txt"), stringsAsFactors = FALSE),
    read.table(file.path("test", "subject_test.txt"), stringsAsFactors = FALSE)
  )

activity_labels <-
  read.table("activity_labels.txt", stringsAsFactors = FALSE)

all_data <-
  cbind(all_subject, activity_labels[all_y[,1], 2], all_data)

## Step 4   : Appropriately labels the data set with descriptive variable names.

colnames(all_data) <- c("Subject", "Activity", features[,2])

## Step 5   : From the data set in step 4, creates a second, independent tidy
##            data set with the average of each variable for each activity and each subject.

tidy_data <- all_data %>%
  gather(Features, Value,-c(Subject, Activity)) %>%
  group_by(Subject, Activity, Features) %>%
  summarise(Average = mean(Value)) %>%
  arrange(Subject, Activity, Features)

# An optional step to separate mean() and std() of a signal to two columns.
# This is because mean() and std() are both 'derived' from the same 'observed' signal.
#
if (apply_spread == TRUE) {
  tidy_data <- tidy_data %>%
    separate(Features, c("Features", "Type")) %>%
    spread(Type, Average) %>% arrange(Subject, Activity, Features)
}

write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)