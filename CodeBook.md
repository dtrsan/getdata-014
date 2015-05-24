# CodeBook

run_analysis tides and calculates mean and standard deviation for each
measurement. Then calculates average of each variable for each activity and
each subject.

The following colums are the result of the executing run_analysis on Samsung
- data.
- subject
- activity
- body_acc_x.mean
- body_acc_x.std
- body_acc_y.mean
- body_acc_y.std
- body_acc_z.mean
- body_acc_z.std
- body_gyro_x.mean
- body_gyro_x.std
- body_gyro_y.mean
- body_gyro_y.std
- body_gyro_z.mean
- body_gyro_z.std
- total_acc_x.mean
- total_acc_x.std
- total_acc_y.mea
- total_acc_y.std
- total_acc_z.mean
- total_acc_z.std

## The following step are done to tidy data

1. read test and train subject data and merge them
2. read test and train activity data and merge them
3. apply descriptive activity names
4. label subject and activity column
5. process all measurements and extract mean and standard deviation
6. label columns for measurements in the format: measurement.mean and measurement.std
7. after all measurement are processed, first group data by activity
8. then group data by subject
9. calculate means grouped by (activity, subject)

