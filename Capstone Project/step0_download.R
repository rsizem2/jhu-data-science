
# Sets directory where all data will be saved in subsequent scripts
# If you change it here you have to change it in all the scripts

main_directory <- "~/textpredict/"
#main_directory <- dirname(rstudioapi::getSourceEditorContext()$path)

rawdata_path <- paste(main_directory, "raw_text", sep = "")

if(!dir.exists(rawdata_path)){
  dir.create(rawdata_path)
  }

# Paths to individual data files

blogs_path <- paste(rawdata_path, "/blogs.txt", sep = "")
news_path <- paste(rawdata_path, "/news.txt", sep = "")
twitter_path <- paste(rawdata_path, "/twitter.txt", sep = "")
swiftkey_url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
zip_path <- paste(rawdata_path, "/Coursera-SwiftKey.zip", sep = "")


# Downloads and extracts data if needed

if(!file.exists(blogs_path) || !file.exists(news_path) || !file.exists(twitter_path)){
  print("One of the files is missing.")
  download.file(url = swiftkey_url, destfile = zip_path)
  unzip(zip_path, 
        files = c("final/en_US/en_US.twitter.txt",
                  "final/en_US/en_US.news.txt",
                  "final/en_US/en_US.blogs.txt"),
        exdir = rawdata_path)
  temp_path <- paste(rawdata_path, "/final/en_US/en_US.twitter.txt", sep = "")  
  file.copy(from = temp_path, to = twitter_path,overwrite = FALSE)
  
  temp_path <- paste(rawdata_path, "/final/en_US/en_US.news.txt", sep = "")
  file.copy(from = temp_path, to = news_path, overwrite = FALSE)
  
  temp_path <- paste(rawdata_path, "/final/en_US/en_US.blogs.txt", sep = "")
  file.copy(from = temp_path, to = blogs_path, overwrite = FALSE)
  
  temp_path <- paste(rawdata_path, "/final", sep = "")
  unlink(temp_path, recursive = TRUE)
  unlink(zip_path)
}

print(paste("Text download and stored in ", rawdata_path))
rm(list = ls())  
