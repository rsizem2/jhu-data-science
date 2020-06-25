
# Load Libraries
library(stringr)
library(tidytext)
library(tidyr)
library(data.table)
library(dplyr)
library(dtplyr)


## Set project directories

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
processed_path <- paste(main_directory, "processed_text/", sep = "")
ngrams_path <- paste(main_directory, "ngrams/", sep = "")
profanity_path <- paste(ngrams_path, "profanity.txt", sep = "")
savefile <- paste(ngrams_path, "unigrams.RData", sep = "")

if(!dir.exists(ngrams_path)){
  dir.create(ngrams_path)
}


## Create Profanity Filter

if(!file.exists(profanity_path)){
  profanity_url <- "https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt"
  download.file(profanity_url,profanity_path)
}

filtered_words <- readLines(profanity_path, warn=FALSE, encoding="UTF-8")
filtered_words <- sapply(filtered_words, str_trim, USE.NAMES = FALSE)

filtered_words <- tibble(word = filtered_words) %>%
  union(tibble(word = c(letters[-c(1,9)],"xjunkx")))
print("Created Filters")


## Blog Unigrams

filepath <- paste(processed_path, "blogs.RData", sep = "")
load(file = filepath)

blogs_words <- unnest_tokens(blogs_text, word, sentences, token = "words") %>% 
  lazy_dt() %>%
  anti_join(filtered_words) %>%
  filter(str_detect(word, pattern = "^[[:alpha:]]+['-]?[[:alpha:]]+$"),
         !str_detect(word, pattern = "(.)\\1{2,}"))  %>%
  as.data.table()
rm(blogs_text)
print("Tokenized Blog Text")


## News Unigrams

filepath <- paste(processed_path, "news.RData", sep = "")
load(file = filepath)

news_words <- unnest_tokens(news_text, word, sentences, token = "words") %>% 
  lazy_dt() %>%
  anti_join(filtered_words) %>%
  filter(str_detect(word, pattern = "^[[:alpha:]]+['-]?[[:alpha:]]+$"),
         !str_detect(word, pattern = "(.)\\1{2,}")) %>%
  as.data.table()
rm(news_text)
print("Tokenized News Text")


## Twitter Unigrams

filepath <- paste(processed_path, "twitter.RData", sep = "")
load(file = filepath)

twitter_words <- unnest_tokens(twitter_text, word, sentences, token = "words") %>% 
  lazy_dt() %>%
  anti_join(filtered_words) %>%
  filter(str_detect(word, pattern = "^[[:alpha:]]+['-]?[[:alpha:]]+$"),
         !str_detect(word, pattern = "(.)\\1{2,}")) %>%
  as.data.table()
rm(twitter_text)
print("Tokenized Twitter Text")


## Create Word Counts and Save

raw_words <- rbindlist(list(blogs_words, news_words, twitter_words))
rm(blogs_words, news_words, twitter_words)
print("Combined Raw Word Data")

unigrams <- raw_words %>%
  lazy_dt() %>%
  count(word, name = "count", sort = TRUE)%>%
  filter(count > 2) %>%
  as.data.table()
print("Counted All Unigrams.")

save(unigrams, file = savefile)
print("Saved Unigram Data.")
rm(list = ls())