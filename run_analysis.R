test_files <- c(
    "test/Inertial Signals/body_acc_x_test.txt",
    "test/Inertial Signals/body_acc_y_test.txt",
    "test/Inertial Signals/body_acc_z_test.txt",
    "test/Inertial Signals/body_gyro_x_test.txt",
    "test/Inertial Signals/body_gyro_y_test.txt",
    "test/Inertial Signals/body_gyro_z_test.txt",
    "test/Inertial Signals/total_acc_x_test.txt",
    "test/Inertial Signals/total_acc_y_test.txt",
    "test/Inertial Signals/total_acc_z_test.txt"
)


train_files <- c(
    "train/Inertial Signals/body_acc_x_train.txt",
    "train/Inertial Signals/body_acc_y_train.txt",
    "train/Inertial Signals/body_acc_z_train.txt",
    "train/Inertial Signals/body_gyro_x_train.txt",
    "train/Inertial Signals/body_gyro_y_train.txt",
    "train/Inertial Signals/body_gyro_z_train.txt",
    "train/Inertial Signals/total_acc_x_train.txt",
    "train/Inertial Signals/total_acc_y_train.txt",
    "train/Inertial Signals/total_acc_z_train.txt"
)

labels <- c(
    "body_acc_x",
    "body_acc_y",
    "body_acc_z",
    "body_gyro_x",
    "body_gyro_y",
    "body_gyro_z",
    "total_acc_x",
    "total_acc_y",
    "total_acc_z"
)

run_analysis <- function(path=".") {
    result <- matrix(nrow=2947+7352, ncol=0)

    # read test and train subject data and merge them
    subject_test_data <- read.table(file=file.path(path, "test/subject_test.txt"))
    subject_train_data <- read.table(file=file.path(path, "train/subject_train.txt"))
    subject_data <- rbind(subject_test_data, subject_train_data)
    result <- cbind(result, subject_data)

    # free memory
    rm(subject_test_data)
    rm(subject_train_data)
    rm(subject_data)

    # read test and train activity data and merge them
    activity_test_data <- read.table(file=file.path(path, "test/y_test.txt"))
    activity_train_data <- read.table(file=file.path(path, "train/y_train.txt"))
    activity_data <- rbind(activity_test_data, activity_train_data)
    result <- cbind(result, activity_data)

    # free memory
    rm(activity_test_data)
    rm(activity_train_data)
    rm(activity_data)

    # apply descriptive activity names
    activity_labels <- read.table(file=file.path(path, "activity_labels.txt"))
    result <- merge.data.frame(result, activity_labels, by.x = 2, by.y = 1)
    result <- result[,c(2,3)]

    # label subject and activity column
    colnames(result) <- c("subject", "activity")

    # process all measurements and extract mean and standard deviation
    for (i in 1:length(labels)) {
        # read test and train data
        test_data <- read.table(file=file.path(path, test_files[i]))
        train_data <- read.table(file=file.path(path, train_files[i]))

        # merge test and train data
        data <- rbind(test_data, train_data)

        # calculate mean and standard deviation
        mean_and_sd <- t(sapply(1:nrow(data), function (x) {
            c(mean(as.numeric(data[x,])), sd(as.numeric(data[x,])))
        }))

        # label columns for measurements
        colnames(mean_and_sd) <- c(
            paste(labels[i], ".mean", sep = ""),
            paste(labels[i], ".std", sep = "")
        )

        result <- cbind(result, mean_and_sd)
    }

    step5(result)
}

levels <- factor(c(1, 2, 3, 4, 5, 6),
                 levels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

step5 <- function(data) {

    result <- matrix(nrow=0, ncol=20)

    # first split by activity
    split_by_activity <- split(data, data$activity)
    for (i in 1:length(split_by_activity)) {
        group_act <- split_by_activity[[i]]
        # then split each activity group by subject
        split_by_subject <- split(group_act, group_act$subject)
        for (j in 1:length(split_by_subject)) {
            group_subj <- split_by_subject[[j]]
            # calculate means grouped by (activity, subject)
            means <- colMeans(group_subj[,c(3:ncol(group_subj))])
            subject <- group_subj$subject[[1]]
            activity <- levels(levels)[group_subj$activity[[1]]]
            result <- rbind(result, t(data.frame(c(subject, activity, means))))
        }
    }

    colnames(result) <- colnames(data)
    result
}
