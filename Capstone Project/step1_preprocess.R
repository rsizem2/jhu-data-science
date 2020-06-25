
## Load Libraries
library(stringr)
library(tidytext)
library(textclean)
library(tidyr)
library(data.table)
library(dplyr)
library(dtplyr)
library(cld2)

## Set project directory

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
rawdata_path <- paste(main_directory, "/raw_text/", sep = "")
processed_path <- paste(main_directory, "/processed_text/", sep = "")

if(!dir.exists(processed_path)){
  dir.create(processed_path)
}

## Cleaning Function

cleantext <- function(input_text){
  text <- unnest_tokens(input_text, sentences, text, token = "sentences")
  print("Tokenized into Words")
  text <- lazy_dt(text, immutable = FALSE) %>%
    mutate(lang = detect_language(sentences)) %>%
    filter(lang == "en") %>% 
    select(sentences) %>%
    mutate(sentences = replace_non_ascii(sentences)) %>%
    mutate(sentences = replace_email(sentences, replacement = "xjunkx")) %>%
    mutate(sentences = replace_hash(sentences, replacement = "xjunkx")) %>%
    mutate(sentences = replace_url(sentences, replacement = "xjunkx")) %>%
    mutate(sentences = replace_tag(sentences, replacement = "xjunkx")) %>%
    mutate(sentences = replace_ordinal(sentences)) %>%
    mutate(sentences = replace_number(sentences, remove = TRUE)) %>%
    mutate(sentences = str_squish(sentences)) %>%
    as.data.table()
  return(text)
}


## Pre-Process Blogs File

filepath <- paste(rawdata_path, "blogs.txt", sep = "")
savefile <- paste(processed_path, "blogs.RData", sep = "")

blogs_text <- readLines(filepath, warn=FALSE, encoding="UTF-8", skipNul = TRUE)
blogs_text <- data.table(text = blogs_text)
print("Load Blog Text")

blogs_text <- cleantext(blogs_text)
print("Text Cleaning Methods Done")

save(blogs_text, file = savefile)
rm(blogs_text)
print("Processed Blog Text Saved")


## Pre-Process News File

filepath <- paste(rawdata_path, "news.txt", sep = "")
savefile <- paste(processed_path, "news.RData", sep = "")

filecon <- file(filepath, open = "rb")
news_text <- readLines(filecon, warn=FALSE, encoding="UTF-8", skipNul = TRUE)
close.connection(filecon)
news_text <- data.table(text = news_text)
print("News Data Loaded")

news_text <- cleantext(news_text)
print("Text Cleaning Methods Done")

save(news_text, file = savefile)
rm(news_text)
print("Processed News Data Saved")


## Pre-Process TWitter File

filepath <- paste(rawdata_path, "twitter.txt", sep = "")
savefile <- paste(processed_path, "twitter.RData", sep = "")

twitter_text <- readLines(filepath, warn=FALSE, encoding="UTF-8", skipNul = TRUE)
twitter_text <- data.table(text = twitter_text)
print("Twitter Data Loaded")

twitter_text <- cleantext(twitter_text)
print("Text Cleaning Methods Done")

save(twitter_text, file = savefile)
print("Twitter Data Saved")
rm(list = ls())