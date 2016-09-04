#first create a link to the dataset and download the zipped file

zipfileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(zipfileurl, "./smartphoneactivity.zip")

#unzip it, it will create a directory

unzip("./smartphoneactivity.zip")

# create trainingdata and testdata

trainingXdata <- read.table ("./UCI HAR Dataset/train/X_train.txt")

trainingYdata <- read.table ("./UCI HAR Dataset/train/y_train.txt")

trainingSubject <- read.table ("./UCI HAR Dataset/train/subject_train.txt")

trainingdata=cbind(trainingSubject, trainingYdata, trainingXdata)


#now for the same for the test data set

testXdata <- read.table ("./UCI HAR Dataset/test/X_test.txt")

testYdata <- read.table ("./UCI HAR Dataset/test/y_test.txt")

testSubject <- read.table ("./UCI HAR Dataset/test/subject_test.txt")

testdata=cbind(testSubject, testYdata, testXdata)

#now i append the training and test data sets into one: alldata

alldata <- rbind(trainingdata, testdata)

#now to add the column names to the data

features <- read.table("./UCI HAR Dataset/features.txt")
#the column names are found inthe second column
column_names <- as.character(features[,2])

colnames(alldata) <- c("subjectid", "activity", column_names)

# I only want columns that indicate mean and std

skinnydata <- alldata[,grep(".*std*.|.*mean*.|subjectid|activity", colnames(alldata))]

# use descriptive names for the activities

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

skinnydata$activity_desc <- ifelse(skinnydata$activity=="1", "Walking",
                                   ifelse(skinnydata$activity=="2", "Walking_Upstairs",
                                          ifelse(skinnydata$activity=="3", "Walking_Downstairs",
                                                 ifelse(skinnydata$activity=="4", "Sitting",
                                                        ifelse(skinnydata$activity=="5", "Standing",
                                                               ifelse(skinnydata$activity=="6", "Laying", "NA"))))))

skinnydata$activity_desc

#creating labels for activity

skinnydata$activity <- factor(skinnydata$activity, levels=activity_labels[,1], labels=activity_labels[,2] )


# create a dataset that calculates means of all variables by subjectid and activity
# melt the data and summarise it

library(dplyr)

library(reshape2)

melted_skinnydata <- melt(skinnydata, id=c("subjectid", "activity", "activity_desc"))

unmelted_skinnydata <- dcast(melted_skinnydata, subjectid + activity + activity_desc ~ variable, mean)




