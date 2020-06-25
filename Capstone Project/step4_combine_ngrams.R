
## Load Libraries
library(tidytext)
library(textclean)
library(tidyr)
library(data.table)
library(dplyr)
library(dtplyr)


## Set project directories

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
ngrams_path <- paste(main_directory, "ngrams/", sep = "")


## Fourgrams

filepath <- paste(ngrams_path, "blogs_quadgrams.RData", sep = "")
load(file = filepath)
print("Blogs Fourgrams Loaded")

filepath <- paste(ngrams_path, "news_quadgrams.RData", sep = "")
load(file = filepath)
print("News Fourgrams Loaded")

filepath <- paste(ngrams_path, "twitter_quadgrams.RData", sep = "")
load(file = filepath)
print("Twitter Fourgrams Loaded")

fourgrams <- rbindlist(list(blogs_quadgrams, news_quadgrams, twitter_quadgrams)) %>%
  lazy_dt()
rm(blogs_quadgrams, news_quadgrams, twitter_quadgrams)

fourgrams <- fourgrams %>% 
  count(word1, word2, word3, word4, name = "count", sort = TRUE) %>% 
  as.data.table()
print("Fourgrams Counted")

filepath <- paste(ngrams_path, "fourgrams.RData", sep = "")
save(fourgrams, file = filepath)
rm(fourgrams)
print("Saved Fourgram Counts")


## Trigrams

filepath <- paste(ngrams_path, "blogs_trigrams.RData", sep = "")
load(file = filepath)
print("Loaded Blogs Trigrams")

filepath <- paste(ngrams_path, "news_trigrams.RData", sep = "")
load(file = filepath)
print("Loaded News Trigrams")

filepath <- paste(ngrams_path, "twitter_trigrams.RData", sep = "")
load(file = filepath)
print("Loaded Twitter Trigrams")

trigrams <- rbindlist(list(blogs_trigrams, news_trigrams, twitter_trigrams)) %>%
  lazy_dt()
rm(blogs_trigrams, news_trigrams, twitter_trigrams)

trigrams <- trigrams %>% 
  count(word1,word2, word3, name = "count", sort = TRUE) %>% 
  as.data.table()
print("Computed Trigram Counts")

filepath <- paste(ngrams_path, "trigrams.RData", sep = "")
save(trigrams, file = filepath)
rm(trigrams)
print("Saved Trigram Data")


## Bigrams

filepath <- paste(ngrams_path, "blogs_bigrams.RData", sep = "")
load(file = filepath)
print("Loaded Blogs Bigrams")

filepath <- paste(ngrams_path, "news_bigrams.RData", sep = "")
load(file = filepath)
print("Loaded News Bigrams")

filepath <- paste(ngrams_path, "twitter_bigrams.RData", sep = "")
load(file = filepath)
print("Loaded Twitter Bigrams")

bigrams <- rbindlist(list(blogs_bigrams, news_bigrams, twitter_bigrams)) %>%
  lazy_dt()
rm(blogs_bigrams, news_bigrams, twitter_bigrams)

bigrams <- bigrams %>% 
  count(word1, word2, name = "count", sort = TRUE) %>% 
  as.data.table()
print("Computed Bigram Counts")

filepath <- paste(ngrams_path, "bigrams.RData", sep = "")
save(bigrams, file = filepath)
print("Saved Bigram Data")
rm(list = ls())