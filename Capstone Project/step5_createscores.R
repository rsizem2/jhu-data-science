
## Load Libraries
library(tidytext)
library(tidyr)
library(data.table)
library(dplyr)
library(dtplyr)

## Set project directories

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
loaddir <- paste(main_directory, "ngrams/", sep = "")
savedir <- paste(main_directory, "scores/", sep = "")

if(!dir.exists(savedir)){
  dir.create(savedir)
}


## Unigrams

filepath <- paste(loaddir, "unigrams.RData", sep = "")
load(file = filepath)
print("Loaded Unigrams")

unigrams <- lazy_dt(unigrams) %>% 
  mutate(score = count/sum(count)) %>% 
  as.data.table()

filepath <- paste(savedir, "unigrams_score.RData", sep = "")
save(unigrams, file = filepath)
print("Unigram Scores Saved")


## Bigrams 

filepath <- paste(loaddir, "bigrams.RData", sep = "")
load(file = filepath)
print("Loaded Bigrams")

# vectors used for computing backoff scores
strings <- as.character(unigrams$word)
counts <- as.integer(unigrams$count)
rm(unigrams)

bigrams <- lazy_dt(bigrams) %>% 
  mutate(denom = plyr::mapvalues(x = word1,
                                 from = strings,
                                 to = counts,
                                 warn_missing = FALSE)) %>%
  mutate(denom = as.integer(denom)) %>%
  mutate(score = count/denom) %>%
  select(word1, word2, count, score) %>% 
  arrange(desc(score)) %>%
  as.data.table()
print("Bigram Scores Computed")

filepath <- paste(savedir, "bigrams_score.RData", sep = "")
save(bigrams, file = filepath)
print("Bigrams Saved")


## Trigrams

filepath <- paste(loaddir, "trigrams.RData", sep = "")
load(file = filepath)
print("Trigrams Loaded")

# vectors used for computing backoff scores
strings <- paste(bigrams$word1, bigrams$word2)
counts <- as.integer(bigrams$count)
rm(bigrams)

trigrams <- lazy_dt(trigrams) %>% 
  mutate(denom = plyr::mapvalues(paste(word1, word2),
                                 from = strings,
                                 to = counts,
                                 warn_missing = FALSE)) %>%
  mutate(denom = as.integer(denom)) %>%
  mutate(score = count/denom) %>%
  select(word1, word2, word3, count, score) %>% 
  arrange(desc(score)) %>%
  as.data.table()
print("Trigram Scores Computed")

filepath <- paste(savedir, "trigrams_score.RData", sep = "")
save(trigrams, file = filepath)
print("Trigrams Saved")

## Fourgrams

filepath <- paste(loaddir,"fourgrams.RData", sep = "")
load(file = filepath)
print("Loaded Fourgrams")

# vectors used for computing backoff scores
strings <- as.character(paste(trigrams$word1, trigrams$word2, trigrams$word3))
counts <- as.integer(trigrams$count)
rm(trigrams)

fourgrams <- lazy_dt(fourgrams) %>% 
  mutate(denom = plyr::mapvalues(paste(word1, word2, word3),
                                 from = strings,
                                 to = counts, 
                                 warn_missing = FALSE)) %>%
  mutate(denom = as.integer(denom)) %>%
  mutate(score = count/denom) %>%
  select(word1, word2, word3, word4, count, score) %>%
  arrange(desc(score)) %>%
  as.data.table()
rm(strings,counts)
print("Fourgram Scores Computed")

filepath <- paste(savedir, "fourgrams_score.RData", sep = "")
save(fourgrams, file = filepath)
print("Fourgrams Saved.")
rm(list = ls())