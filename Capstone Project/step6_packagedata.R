
# Load Libraries
library(tidytext)
library(tidyr)
library(data.table)
library(dplyr)
library(dtplyr)

## Set project directories

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
loaddir <- paste(main_directory, "scores/", sep = "")
savedir <- paste(main_directory, "final_data/", sep = "")

if(!dir.exists(savedir)){
  dir.create(savedir)
}

## Set cutoff, delete N-grams with fewer than x counts

cutoff = 2


## Load Unigrams

filepath <- paste(loaddir, "unigrams_score.RData", sep = "")
load(file = filepath)
print("Loaded Unigrams")

unigrams <- lazy_dt(unigrams) %>%
  filter(count > cutoff) %>%
  mutate(stopwords = (word %in% stop_words$word)) %>%
  arrange(desc(score)) %>%
  as_tibble()
print("Converted Unigrams")


## Load Bigrams

filepath <- paste(loaddir, "bigrams_score.RData", sep = "")
load(file = filepath)
print("Loaded Bigrams")

bigrams <- lazy_dt(bigrams) %>%
  filter(count > cutoff) %>%
  mutate(stopwords = (word2 %in% stop_words$word)) %>%
  arrange(desc(score)) %>%
  as_tibble()
print("Converted Bigrams")

## Load Trigrams

filepath <- paste(loaddir, "trigrams_score.RData", sep = "")
load(file = filepath)
print("Loaded Trigrams")

trigrams <- lazy_dt(trigrams) %>%
  filter(count > cutoff)%>%
  mutate(stopwords = (word3 %in% stop_words$word)) %>%
  arrange(desc(score)) %>%
  as_tibble()
print("Converted Trigrams")

## Load Fourgrams

filepath <- paste(loaddir, "fourgrams_score.RData", sep = "")
load(file = filepath)
print("Loaded Quadgrams.")

fourgrams <- lazy_dt(fourgrams) %>%
  filter(count > cutoff)%>%
  mutate(stopwords = (word4 %in% stop_words$word)) %>%
  arrange(desc(score)) %>%
  as_tibble()

## Save Data

if(cutoff > 0){
  filepath <- paste(savedir, "data", as.character(cutoff), ".RData", sep = "")
  save(unigrams, bigrams, trigrams, fourgrams, file = filepath)
  print("Data Saved")
} else {
  filepath <- paste(savedir, "data.RData", sep = "")
  save(unigrams, bigrams, trigrams, fourgrams, file = filepath)
  print("Data Saved")
}

rm(list = ls())