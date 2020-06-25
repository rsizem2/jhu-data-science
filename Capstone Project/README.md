# README

This repository contains the various R scripts used for my capstone project in the JHU Data Science MOOC.

## Contents

* "README.md" - this document
* "NGramPrediction" - folder containing the Shiny application
* "Slides" - folder containing the RMarkdown Slides
* "step0_download.R" - R script that downloads the text corpus
* "step1_preprocess.R" - R script which cleans and prepares data for tokenization.
* "step2_profanityfilter.R" - R script which creates a profanity filter and also counts the words that appear in the text corpus
* "step3_compute_ngrams.R" - R script which tokenizes each of the text sources separately
* "step4_combine_ngrams.R" - R script which combines n-grams from all three sources and computes counts for each n-gram
* "step5_createscores.R" - R script that uses n-gram counts to compute back-off scores which will be used by the model
* "step6_packagedata.R" - R script that combines our data into a form usable by the shiny app

## How to Use

1. Run the seven scripts in order. By default, the scripts will create a directory "~/textpredict" which will contain all the intermediate data as you run each script.
2. Move the data created in "~/textpredict/final_data" to the folder "NGramPrediction/data" included in this repository.
3. Edit "NGramPrediction/app.R" so that it loads the appropriate .Rdata file (if necessary)
4. Run the app.R file in RStudio.
