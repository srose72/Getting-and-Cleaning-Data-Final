# Getting-and-Cleaning-Data-Final    Sophia Rose

 Uses libraries dtplyr (or seperately data.table and dplyr), tidyr, and memisc

 run_analysis.R cleans the data from the UC Irvine Human Activity Recognition Using Smartphones Data Set.
 Download the dataset at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 Original source at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

 The program will automatically download and unzip the data folder into a folder called "data" in the working directory.
 A tidy dataset that has the averages of all variables by subject and activity will be written into a .txt file and saved in the working directory.

 In summary, this program:
 Merges the training and test sets into one dataset and saves to "data_full.txt".
 Extracts the mean and standard deviation for each measurement, and uses descriptive activity names to name the activities in the dataset.
 Creates a second tidy data set with the average of each variable for each activity and subject and saves to "tidy_data.txt".

 The datasets each have one column per variable and one row for each kind of observation.

 The codebook is generated from the function codebook {memisc} and saved as "Codebook.txt"
