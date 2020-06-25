
## Load Libraries
library(stringr)
library(tidytext)
library(textclean)
library(tidyr)
library(data.table)
library(dplyr)
library(dtplyr)


## Set project directories

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
processed_path <- paste(main_directory, "processed_text/", sep = "")
ngrams_path <- paste(main_directory, "ngrams/", sep = "")


## Function to split input corpus into thirds

split_text <- function(input_text){
  m = nrow(input_text)
  n = m %/% 3
  
  input_text <- lazy_dt(input_text)
  
  slice1 <- input_text %>% 
    slice(1:n) %>%
    as.data.table()
  
  slice2 <- input_text %>% 
    slice((n+1):(m-n)) %>%
    as.data.table()
  
  slice3 <- input_text %>% 
    slice((m-n+1):m) %>%
    as.data.table()
  
  return(list(slice1,slice2,slice3))
}


## Functions to computer bigrams, trigrams and quadgrams

compute_bigrams <- function(input_text, wordlist){
  raw_bigrams <- unnest_tokens(input_text, bigram, sentences, token = "ngrams", n = 2) %>% 
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    lazy_dt() %>% 
    filter(word1 %in% wordlist,
           word2 %in% wordlist) %>% 
    as.data.table()
  print("1/3 of the Bigrams Computed")
  return(raw_bigrams)
}

compute_trigrams <- function (input_text, wordlist){
  raw_trigrams <- unnest_tokens(input_text, trigram, sentences, token = "ngrams", n = 3) %>% 
    separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
    lazy_dt() %>%
    filter(word1 %in% wordlist,
           word2 %in% wordlist,
           word3 %in% wordlist) %>% 
    as.data.table()
  print("1/3 of the Trigrams Computed")
  return(raw_trigrams)
}

compute_quadgrams <- function(input_text, wordlist){
  raw_fourgrams <- unnest_tokens(input_text, fourgram, sentences, token = "ngrams", n = 4) %>% 
    separate(fourgram, c("word1", "word2", "word3", "word4"), sep = " ") %>% 
    lazy_dt() %>%
    filter(word1 %in% wordlist,
           word2 %in% wordlist,
           word3 %in% wordlist,
           word4 %in% wordlist) %>% 
    as.data.table()
  print("1/3 of the Fourgrams Computed")
  return(raw_fourgrams)
}


## Load Unigram Data

filepath <- paste(ngrams_path, "unigrams.RData", sep = "")
load(file = filepath)
print("Unigrams Loaded")


## Compute Blog N-grams

filepath <- paste(processed_path, "blogs.RData", sep = "")
load(file = filepath)
print("Blog Text Loaded")

blogs_text <- split_text(blogs_text)
blogs_bigrams <- lapply(blogs_text, compute_bigrams, wordlist = unigrams$word)
blogs_bigrams <- rbindlist(blogs_bigrams)

filepath <- paste(ngrams_path, "blogs_bigrams.RData", sep = "")
save(blogs_bigrams, file = filepath)
rm(blogs_bigrams)
print("Bigrams Saved")

blogs_trigrams <- lapply(blogs_text, compute_trigrams, wordlist = unigrams$word)
blogs_trigrams <- rbindlist(blogs_trigrams)

filepath <- paste(ngrams_path, "blogs_trigrams.RData", sep = "") 
save(blogs_trigrams, file = filepath)
rm(blogs_trigrams)
print("Trigrams Saved")

blogs_quadgrams <- lapply(blogs_text, compute_quadgrams, wordlist = unigrams$word)
blogs_quadgrams <- rbindlist(blogs_quadgrams)

filepath <- paste(ngrams_path, "blogs_quadgrams.RData", sep = "")
save(blogs_quadgrams, file = filepath)
rm(blogs_quadgrams, blogs_text)
print("Blog Ngrams Done!")

## Compute News N-grams

filepath <- paste(processed_path, "news.RData", sep = "")
load(file = filepath)
print("News Text Loaded")

news_text <- split_text(news_text)
news_bigrams <- lapply(news_text, compute_bigrams, wordlist = unigrams$word)
news_bigrams <- rbindlist(news_bigrams)

filepath <- paste(ngrams_path, "news_bigrams.RData", sep = "")
save(news_bigrams, file = filepath)
rm(news_bigrams)
print("Bigrams Saved")

news_trigrams <- lapply(news_text, compute_trigrams, wordlist = unigrams$word)
news_trigrams <- rbindlist(news_trigrams)

filepath <- paste(ngrams_path, "news_trigrams.RData", sep = "") 
save(news_trigrams, file = filepath)
rm(news_trigrams)
print("Trigrams Saved")

news_quadgrams <- lapply(news_text, compute_quadgrams, wordlist = unigrams$word)
news_quadgrams <- rbindlist(news_quadgrams)

filepath <- paste(ngrams_path, "news_quadgrams.RData", sep = "")
save(news_quadgrams, file = filepath)
rm(news_quadgrams, news_text)
print("News Ngrams Done!")


## Compute Twitter N-grams

filepath <- paste(processed_path, "twitter.RData", sep = "")
load(file = filepath)
print("TWitter Text Loaded")

twitter_text <- split_text(twitter_text)
twitter_bigrams <- lapply(twitter_text, compute_bigrams, wordlist = unigrams$word)
twitter_bigrams <- rbindlist(twitter_bigrams)

filepath <- paste(ngrams_path, "twitter_bigrams.RData", sep = "")
save(twitter_bigrams, file = filepath)
rm(twitter_bigrams)
print("Bigrams Saved")

twitter_trigrams <- lapply(twitter_text, compute_trigrams, wordlist = unigrams$word)
twitter_trigrams <- rbindlist(twitter_trigrams)

filepath <- paste(ngrams_path, "twitter_trigrams.RData", sep = "") 
save(twitter_trigrams, file = filepath)
rm(twitter_trigrams)
print("Trigrams Saved")

twitter_quadgrams <- lapply(twitter_text, compute_quadgrams, wordlist = unigrams$word)
twitter_quadgrams <- rbindlist(twitter_quadgrams)

filepath <- paste(ngrams_path, "twitter_quadgrams.RData", sep = "")
save(twitter_quadgrams, file = filepath)
rm(twitter_quadgrams, twitter_text)
print("Twitter Ngrams Done!")
rm(list = ls())