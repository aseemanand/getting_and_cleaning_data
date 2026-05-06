# getting_and_cleaning_data

R code for merging and summarizing the [UCI HAR](https://archive.ics.uci.edu/ml/datasets/human+activity+recognition+using+smartphones) smartphone activity dataset.

## Contents

- `UCI HAR Dataset/` — unzipped data from UCI  
- `run_analysis.R` — reads train/test files, merges them, subsets mean/std features, attaches activity names, aggregates by subject and activity  
- `CodeBook.md` — describes variables and what the script changed  
- `tidy_averages_by_subject_and_activity.txt` — created when you run the script  

## Requirements

Install [R](https://www.r-project.org/) and the `dplyr` package.

## Running

Put the repo folder on disk so `run_analysis.R` and `UCI HAR Dataset` sit in the same directory. Start R in that directory and run:

```bash
Rscript run_analysis.R
```

or inside R:

```r
source("run_analysis.R")
```

The summary file has 180 rows (30 volunteers × 6 activities) plus the averaged measurement columns described in `CodeBook.md`.

## Data citation

See `UCI HAR Dataset/README.txt` for how to cite the original study.
