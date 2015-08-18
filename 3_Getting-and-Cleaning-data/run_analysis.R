# setwd("C://Users/ocsuser/Desktop/Coursera work/UCI HAR Dataset")

# 1. Merges the training and the test sets to create one data set.
train <- read.table("./train/X_train.txt")
train.label <- read.table("./train/y_train.txt")
train.subject <- read.table("./train/subject_train.txt")
test <- read.table("./test/X_test.txt")
test.label <- read.table("./test/y_test.txt")
test.subject <- read.table("./test/subject_test.txt")

dt <- rbind(train, test)
dt.label <- rbind(train.label, test.label)
dt.subject <- rbind(train.subject, test.subject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
ft <- read.table("features.txt")
colnames(dt) <- ft[,2]
MandSD.index <- grep("mean\\(\\)|std\\(\\)", colnames(dt))
MandSD.index
dt.MandSD <- dt[, MandSD.index]

#3. Uses descriptive activity names to name the activities in the dataset
activity <- read.table("activity_labels.txt")
dt.label[,1] <- activity[dt.label[,1], 2]
str(dt.label)

#4. Appropriately labels the dataset with descriptive variable names
names(dt.subject) <- "Subject"
names(dt.label) <- "Activity"

dt.final <- cbind(dt.subject, dt.label, dt.MandSD)
write.table(dt.final, "tidy data.txt", row.names=FALSE)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
dt.final_avrByGr <- aggregate(dt.final[, 3:68], by=list(Activity=dt.final$Activity, Subject=dt.final$Subject), mean)
write.table(dt.final_avrByGr, "tidy data_avr.txt", row.names=FALSE)
