# Code book

Human Activity Recognition Using Smartphones data from UCI (`UCI HAR Dataset`). This repo only uses the summarized feature tables, not the raw inertial CSV-style files under `Inertial Signals/`.

## Input files used

| File | What it is |
|------|------------|
| `train/X_train.txt`, `test/X_test.txt` | One row per window, 561 features |
| `train/y_train.txt`, `test/y_test.txt` | Activity id 1–6 per row |
| `train/subject_train.txt`, `test/subject_test.txt` | Subject id 1–30 |
| `features.txt` | Names for all 561 features |
| `activity_labels.txt` | Activity id ↔ name |

The dataset README says values are scaled to about **[-1, 1]**; see `features_info.txt` for what each engineer feature means.

## What `run_analysis.R` does

Train and test are stacked with `rbind` so subjects, labels, and `X` lines stay lined up.

Only columns whose names in `features.txt` contain `-mean()` or `-std()` are kept (66 columns). That leaves out things like `-meanFreq()` and entropy bands.

Measurement column names were simplified for readability, e.g. `tBodyAcc-mean()-X` became something like `timeBodyAccelerometerMeanX` (`t`→time, `f`→frequency, `Acc`, `Gyro`, `Mag` spelled out, `BodyBody` shortened to `Body`, parentheses stripped).

Activity numbers are swapped for the text labels in `activity_labels.txt` via a factor so the row order is not scrambled.

Lastly the script averages every numeric measurement for each `(subject, activity)` group with `dplyr` and saves `tidy_averages_by_subject_and_activity.txt` (header row, no row names).

## Output columns

**subject** — integer volunteer id  

**activity** — `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`  

**Other columns (66)** — mean of that feature over all windows for that person and activity. Names encode time vs frequency domain, accel vs gyro, body vs gravity where relevant, jerk/magnitude markers, axis `X/Y/Z` when present, and `Mean` vs `Std` for the underlying UCI statistic.

The full stacked table before aggregation has 7352 + 2947 rows; only the small summary table is written to disk.
