# Code Book
***************************

## Understand the Raw Data Set
***************************

The raw data set contains measurement data for a machine learning experiment [1].

The data are divided into a training set and a test set. 

* The "X" files (`X_train.txt, X_test.txt`) contain the data samples. In total, each sample has 561 features.
    + The entire list of features is contained in `features.txt`
    + The definition of each feature can be found in `features_info.txt`

* The "y" files (`y_train.txt, y_test.txt`) contain the labels for the data. 
    + Each label 1, ..., 6 corresponds to an activity (e.g., walking, sitting, etc.). 
    + The file `activity_labels.txt` gives the list of activities.

* In addition, the "subject" files (`subject_train.txt, subject_test.txt`) contain the IDs (1, ..., 30) of the person that performed an activity in each sample.

* The rest of the files are not needed for this exercise.


## Procedures
***************************

To clean this data set, `run_analysis.R` needs to do the following:  
-	Merge the training and the test sets to create one data set.  
-	Extract only the measurements on the mean and standard deviation for each measurement.  
-	Use descriptive activity names to name the activities in the data set.  
-	Appropriately label the data set with descriptive variable names.   
-	From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.  


#### 1. Merging

Data from `X_train.txt, X_test.txt, y_train.txt, y_test.txt, subject_train.txt`, and `subject_test.txt` will be read and merged into a single data frame `whole.data`.

Also, the feature and activity labels are retrieved from `features.txt` and `activity_labels.txt`.

#### 2. Extracting

To extract the features of means and standard deviations, we select columns of `whole.data` whose names contain keywords such as `Mean`, `mean` and `std`. These selections result in 86 features being selected, including

  - Features with `mean()` and `std()` which are straightforward measures of mean and standard deviation.
  - Features with `meanFreq()` which measure "mean frequency"
  - In addition, features of the types `angle(...Mean)` are also selected as they average the signals in a signal window sample.


#### 3. Renaming activities

In the activity variable, the numeric values are replaced by their actual names.


#### 4. Renaming labels

The features are renamed through a series of operations, including typo correction, special character removal, substitution of mathematical variables (`t`, `f`) for their names, etc. 


#### 5. Creating a new tidy data set

`tidy.data` is the newly created data set. It contains the average of every measurement (feature) for each subject and each of this subject's activity.

Finally, `tidy.data` is output into a file `tidyDataAvg.txt`.


## Data and Variables
***************************

The tidy data set contains the averages of all measurements (features) for each subject and each activity. 
There are 30 subjects and 6 activities so the data set has 180 rows.

The variables are:

#### 1. Subject: 
   - IDs of person who performed an activity that was measured.
   - Integer 1, ..., 30.

#### 2. Activity:
   - Characters of the following 6 values: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LYING".

#### 3. The measurement averages (3rd column to end):
   - Floating point numbers, normalized in [-1,1].
   - Naming format: `avg[x]` where `x` is the original feature name after filtering and naming, e.g., "timeBodyAcc-Mean-X", "timeBodyAcc-Mean-Y", "timeBodyAcc-Mean-Z", and so on. The name signifies that their values are obtained by averaging over the original variables.
   - For a complete list, see `ListofFeatures.md`.




## References
***************************

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. *21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013*. Bruges, Belgium 24-26, April 2013. 
