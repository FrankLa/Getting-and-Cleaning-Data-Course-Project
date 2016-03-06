##  run_analysis.R 
##  Author: FrankLa
##  Date: Mar 06, 2016

## 0. Assuming data already downloaded, proceed to read!  ---------------------------

setwd("C:/Users/User/Desktop/Coursera/Coursera - Getting & Cleaning Data/RDir/Project")

features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Retrieve the features and activities first
features <- features[,2]
features <- as.vector(features) 

activity <- activity[,2]
activity <- as.vector(activity)
activity[6] <- "LYING" # correct original naming mistake


## 1. Merge training and test sets into one.  --------------------------------------
## We merge the large tables on the fly to avoid creating multiple large variables
whole.data <- read.table("./UCI HAR Dataset/train/X_train.txt")
whole.data <- rbind(whole.data, read.table("./UCI HAR Dataset/test/X_test.txt"))


y <- read.table("./UCI HAR Dataset/train/y_train.txt")
y <- rbind(y, read.table("./UCI HAR Dataset/test/y_test.txt"))

subj <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subj <- rbind(subj, read.table("./UCI HAR Dataset/test/subject_test.txt"))

whole.data <- cbind(subj, y, whole.data) # put subject and activity to the front
names(whole.data) <- c("Subject","Activity",features) 

## 2. For each measurement, extract mean and stdev ---------------------------------

## In doing so, we extract features whose names contain "mean", "Mean" and "std"

features = gsub('mean', 'Mean', features) ## substitute lowercase with uppercase Mean

desiredCol <- grep(".*Mean.*|.*std.*", features)
features <- features[desiredCol]

desiredCol <- c(1,2,desiredCol+2)

whole.data <- whole.data[, desiredCol]


## 3. Descriptively name the activities in data set --------------------------------

whole.data$Activity <- sapply(whole.data$Activity, function(x) {
  activity[x]
})


## 4. Label variables in data set descriptively -------------------------------------

## 't' prefix --> 'time' for time domain signal
features <- gsub("^t", "time", features)
features <- gsub("\\(t", "\\(time", features)

## 'f' prefix --> 'freq' for frequency domain signal
features <- gsub("^f", "freq", features)

## '()' is removed
features <- gsub("\\(\\)", "", features)

## 'std' --> 'StdDev' for better clarity
features <- gsub("std", "StdDev", features)

## 'BodyBody' typo --> 'Body'
features <- gsub("BodyBody", "Body", features)

## one redundant ')' is removed 
features <- gsub("\\),", ",", features)

## Finally, we rename the variables
names(whole.data) <- c("Subject","Activity",features) 

## 5. Create a 2nd tidy data set with the averages ----------------------------------
library(reshape2)

whole.data.melted <- melt(whole.data, id = c("Subject", "Activity"))
tidy.data <- dcast(whole.data.melted, Subject + Activity ~ variable, mean)

## rename the columns for the new tidy data
tidy.names <- paste0("Avg[", features, "]")
names(tidy.data) <- c("Subject","Activity",tidy.names)

## 6. Finally, output tidy.data to a .txt file --------------------------------------
write.table(tidy.data, "tidyDataAvg.txt", row.name = FALSE)

