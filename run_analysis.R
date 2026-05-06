# UCI Human Activity Recognition (smartphone) tidy summary
# Run with working directory = folder that contains `UCI HAR Dataset`.

library(dplyr)

data_dir <- "UCI HAR Dataset"
if (!dir.exists(data_dir)) stop("Can't find folder: ", data_dir)

features <- read.table(
  file.path(data_dir, "features.txt"),
  col.names = c("index", "name"),
  stringsAsFactors = FALSE
)
activity_labels <- read.table(
  file.path(data_dir, "activity_labels.txt"),
  col.names = c("code", "activity"),
  stringsAsFactors = FALSE
)

# Subscripts for features that are means or SDs only
mean_std_idx <- grep("-mean\\(\\)|-std\\(\\)", features$name)

x_train <- read.table(file.path(data_dir, "train/X_train.txt"))
y_train <- read.table(file.path(data_dir, "train/y_train.txt"), col.names = "activity_code")
subject_train <- read.table(file.path(data_dir, "train/subject_train.txt"), col.names = "subject")

x_test <- read.table(file.path(data_dir, "test/X_test.txt"))
y_test <- read.table(file.path(data_dir, "test/y_test.txt"), col.names = "activity_code")
subject_test <- read.table(file.path(data_dir, "test/subject_test.txt"), col.names = "subject")

x_all <- rbind(x_train, x_test)
subject_all <- rbind(subject_train, subject_test)
y_all <- rbind(y_train, y_test)

x_ms <- x_all[, mean_std_idx]
feat_names <- features$name[mean_std_idx]

readable <- function(nm) {
  nm <- gsub("^t", "time", nm)
  nm <- gsub("^f", "frequency", nm)
  nm <- gsub("Acc", "Accelerometer", nm)
  nm <- gsub("Gyro", "Gyroscope", nm)
  nm <- gsub("Mag", "Magnitude", nm)
  nm <- gsub("BodyBody", "Body", nm)
  nm <- gsub("-mean\\(\\)", "Mean", nm)
  nm <- gsub("-std\\(\\)", "Std", nm)
  nm <- gsub("-", "", nm)
  nm
}
colnames(x_ms) <- readable(feat_names)

activity_labels <- activity_labels[order(activity_labels$code), ]
activity_lbl <- factor(
  y_all$activity_code,
  levels = activity_labels$code,
  labels = activity_labels$activity
)

har <- cbind(
  subject = subject_all$subject,
  activity = as.character(activity_lbl),
  x_ms,
  stringsAsFactors = FALSE
)

by_subj_act <- har %>%
  as_tibble() %>%
  group_by(subject, activity) %>%
  summarise(across(where(is.numeric), mean), .groups = "drop")

write.table(
  by_subj_act,
  "tidy_averages_by_subject_and_activity.txt",
  row.names = FALSE,
  quote = FALSE
)
