## Create one R script called run_analysis.R that does the following:
## This assumes that the raw data has been downloaded from 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## and unzipped into the working directory.

## Merges the training and the test sets to create one data set.
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject_train, subject_test)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y <- rbind(y_train, y_test)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X <- rbind(X_train, X_test)

features <- read.table("./UCI HAR Dataset/features.txt")

## Appropriately labels the data set with descriptive feature/variable names.
names(X) <- features[,2]
names(y) <- "Activity"
names(subject) <- "Subject_Id"


## Extracts only the measurements on the mean and standard deviation for each measurement.
getmeanandstd <- grep("mean\\(\\)|std\\(\\)", as.character(features[,2]))
subX <- X[,getmeanandstd]

## Puts everything together in one data frame
tidydata1 <- cbind(subject,y, subX)

## Uses descriptive activity names to name the activities in the data set
tidydata1$Activity <- as.character(tidydata1$Activity)
tidydata1$Activity[tidydata1$Activity == "1"] <- "WALKING"
tidydata1$Activity[tidydata1$Activity == "2"] <- "WALKING_UPSTAIRS"
tidydata1$Activity[tidydata1$Activity == "3"] <- "WALKING_DOWNSTAIRS"
tidydata1$Activity[tidydata1$Activity == "4"] <- "SITTING"
tidydata1$Activity[tidydata1$Activity == "5"] <- "STANDING"
tidydata1$Activity[tidydata1$Activity == "6"] <- "LAYING"
tidydata1$Activity <- as.factor(tidydata1$Activity)


## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
meltdata = melt(data=tidydata1,id=c("Subject_Id","Activity"))
tidydata2 = dcast(meltdata, Subject_Id + Activity ~ variable, mean)


## Outputs the second tidy data set to a txt file
write.table(tidydata2, "tidydata2.txt", row.names=FALSE)

