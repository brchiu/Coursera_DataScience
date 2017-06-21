# Getting_and_Cleaning_Data
Course project repository for Getting and Cleaning Data class of Data Specialization

Several files included in this repository :
* READ.me : this file
* CodeBook.txt : the code book describing the variables
* run_analysis.R : R script file which tidies Samsung data  
* tidy_data.txt : the result of tidied data.

Steps of tidying data :

0. Loads required R packages and checks file existence of various data files
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
  * Note : Extract features name having 'mean()' and 'std()' using grep function
  * Note : (Optinal) Modify feature name, ex : fBodyAccJerk-mean-X to  fBodyAccJerkX-mean. It is for easier manipulation in tidyr::separate function
  * Note : Extract only these features from all_data by subsetting them
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy
   data set with the average of each variable for each activity and each subject.
  * Note : (Optional) Spreads mean() and std() of a measurement to two separate columns.

