# Information about this Repo

The R script in this repository was tested on R version 3.5.2 (2018-12-20) -- "Eggshell Igloo" using Debian GNU/Linux 10 (buster) 64-bit

## Contents

* "run_analysis.R" - R script that downloads a raw dataset, then converts a subset of this raw data into a tidy summary dataset.
* "CodeBook.md" - detailed document explaining the data created by the script
* "README.md"

## What the script does

Note: This script will download the raw data file "UCIdata.zip" and extract it into a folder "UCI HAR Dataset" as well as create the summary dataset "tidydata.csv", so make sure to set your working directory accordingly.

1. Downloads original dataset (UCIData.zip)
2. Unzips file and loads relevant data into R
3. Combines training and test data and matches activity labels
4. Extract only the mean() and std() feature vector estimates.
5. Create second dataset averaging these estimates over each subject and activity
6. Write this dataset to a file 'tidydata.csv'
