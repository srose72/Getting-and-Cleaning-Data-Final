library(dplyr)
library(tidyr)
library(reshape2)
library(data.table)

## save X test and training data as a data table
X_train <- read.table("~/UCI HAR Dataset/train/X_train.txt",
                      quote = "\"", stringsAsFactors = FALSE)
X_test <- read.table("~/UCI HAR Dataset/test/X_test.txt",
                     quote = "\"", stringsAsFactors = FALSE)

## combine test and training data
X_all <- bind_rows(X_train, X_test)

## do the same for Y data
y_train <- read.table("~/UCI HAR Dataset/train/y_train.txt",
                       quote = "\"", stringsAsFactors = FALSE)
y_test <- read.table("~/UCI HAR Dataset/test/y_test.txt",
                      quote = "\"", stringsAsFactors = FALSE)
y_all <- bind_rows(y_train, y_test)

## get and save the features of the data
features <- read.table("~/R/UCI HAR Dataset/features.txt",
                       quote = "\"", stringsAsFactors = FALSE)

## rename the conlumns in the combined data table to the features
names(X_all) = features$V2

## get and save the subject activity data
subject_train <- read.table("~/R/UCI HAR Dataset/train/subject_train.txt", 
                            quote = "\"", stringsAsFactors = FALSE)
subject_test <- read.table("~/R/UCI HAR Dataset/test/subject_test.txt", 
                           quote = "\"", stringsAsFactors = FALSE)

## combine the subject data
subject_ID <- bind_rows(subject_train, subject_test)

## get and save the activity names
activity_labels <- read.table("~/R/UCI HAR Dataset/activity_labels.txt",
                              quote = "\"", stringsAsFactors = FALSE)

## combine data tables to add activity descriptions
subject_activity <- full_join(y_all, activity_labels)

## isolate activity labels in order
activity <- subject_activity$V2

## create dataframe with subject activity by ID and label
subject_act_df <- data.frame(subject_ID, activity)

## create dataframe of all X data and subject activity data
all_data <- cbind(as.data.table(X_all), (subject_activity))

## fix duplicate column names
unique_colname <- make.names(names = names(all_data),
                                           unique = TRUE,
                                           allow_ = TRUE)
names(all_data) <- unique_colname

## extract mean and standard deviation values
means <- select(all_data, contains("mean"))
stdev <- select(all_data, contains("std"))

## combine mean, standard dev columns, and activity data
means_stdev <- cbind(as.data.table(means), (stdev))
means_stdev_act <- cbind(as.data.table(means_stdev), (subject_act_df))

## remove NA values
tidy_data <- na.omit(means_stdev_act)

## write to csv

write.table(tidy_data, "tidy_data.txt", row.names = FALSE)