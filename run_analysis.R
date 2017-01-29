if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")

# Unzip file to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## read and save files
X_train <- read.table('data/UCI HAR Dataset/train/X_train.txt',
                      col.names = features$Feature,check.names = FALSE)
y_train <- read.table('data/UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('data/UCI HAR Dataset/train/subject_train.txt')

X_test <- read.table('data/UCI HAR Dataset/test/X_test.txt',
                     col.names = features$Feature,check.names = FALSE)
y_test <- read.table('data/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('data/UCI HAR Dataset/test/subject_test.txt')

features <- read.table('data/UCI HAR Dataset/features.txt',
                       col.names = c('Index_Feature','Feature'))
activity_labels <- read.table('data/UCI HAR Dataset/activity_labels.txt',
                              col.names = c('Index_Activity','Activity'))

## add IDs and activity labels to train and test data
X_train_full = cbind(y_train, subject_train,X_train)
X_test_full = cbind(y_test, subject_test,X_test)

## rename columns
names(X_train_full)[c(1,2)] <- c('Activity','Subject')
names(X_test_full)[c(1,2)] <- c('Activity','Subject')

##write.csv(x=X_train_full,file = 'X_train.csv',sep = ',',row.names = F)
##write.csv(x=X_test_full,file = 'X_test.csv',sep = ',',row.names = F)

## combine train and test data
X_all <- rbind(X_train,X_test)
Y_all <- rbind(y_train,y_test)
subject_data <- rbind(subject_train,subject_test)

## extract mean and standard deviation columns
col_names <- colnames(X_all)
means  <- grep('mean\\(\\)',col_names)
stdev   <- grep('std\\(\\)',col_names)

X_mean_std <- X_all[,c(means,stdev)]

## add activity labels
X_clean <- cbind(Y_all,X_mean_std)
colnames(X_clean)[1] <- 'Index_Activity'
X_clean <- cbind(subject_data,X_clean)
colnames(X_clean)[1] <- 'Subject'

X_clean <- merge(activity_labels,X_clean)
X_clean$Index_Activity <- NULL

## rename columns for legibility
col_names <- colnames(X_clean)

col_names <- sub(x = col_names,pattern = '^t',replacement = 'Time domain signal: ')
col_names <- sub(x = col_names,pattern = '^f',replacement = 'Frequency domain signal: ')
col_names <- sub(x = col_names,pattern = '-',replacement = ', ')
col_names <- sub(x = col_names,pattern = 'mean\\(\\)',replacement = ' mean value ')
col_names <- sub(x = col_names,pattern = 'std\\(\\)',replacement = ' standard deviation ')
col_names <- sub(x = col_names,pattern = '-X',replacement = 'in X direction')
col_names <- sub(x = col_names,pattern = '-Y',replacement = 'in Y direction')
col_names <- sub(x = col_names,pattern = '-Z',replacement = 'in Z direction')
col_names <- sub(x = col_names,pattern = 'AccJerk',replacement = ' acceleration jerk')
col_names <- sub(x = col_names,pattern = 'Acc',replacement = ' acceleration')
col_names <- sub(x = col_names,pattern = 'GyroJerk',replacement = ' angular velocity jerk')
col_names <- sub(x = col_names,pattern = 'Gyro',replacement = ' angular velocity')
col_names <- sub(x = col_names,pattern = 'Mag',replacement = ' magnitude')

colnames(X_clean) <- col_names

# create tidy data set with averages for each subject and activity
X_tidy <- aggregate(X_clean[,3:68],by=list(X_clean$Activity,X_clean$Subject),FUN=mean)
colnames(X_tidy)[1] <- 'Activity'
colnames(X_tidy)[2] <- 'Subject'

# write tidy data set
write.table(X_tidy,file = 'tidY_data.txt',row.names = F)
