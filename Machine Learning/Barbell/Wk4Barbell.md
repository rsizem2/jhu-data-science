Project: Predicting Weight Lifting Technique
================

In this project, we look at data from 6 weightlifters performing
dumbbell curls. According to the [data
source](http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har):
“Six young health participants were asked to perform one set of 10
repetitions of the Unilateral Dumbbell Biceps Curl in five different
fashions: exactly according to the specification (Class A), throwing the
elbows to the front (Class B), lifting the dumbbell only halfway (Class
C), lowering the dumbbell only halfway (Class D) and throwing the hips
to the front (Class E).” Their movements were recorded using
accelerometers placed on the belt, forearm, arm, and the dumbbell
itself. We want to predict the manner in which a participant performs a
dumbbell curl based on data gathered from various sensors.

## Data Processing

``` r
library(e1071)
library(caret)
library(dplyr)
library(mlbench)
```

We begin by downloading the training and testing sets:

``` r
url1 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
if(!file.exists("data/training.csv")){
    download.file(url1,"data/training.csv")
}
if(!file.exists("testing.csv")){
    download.file(url2,"data/testing.csv")
}
training <- read.csv("data/training.csv",na.strings = c("","NA","#DIV/0!"))
testing <- read.csv("data/testing.csv",na.strings = c("","NA","#DIV/0!"))
#names(training)
```

The data we’re given is recorded from 4 different sensors: one on the
belt, one on the arm, one on the wrist and one mounted on a dumbbell.
Each sensor has a gyroscope, accelerometer, and magnetometer from which
measurements are done along each Cartesian direction, as well as a
magnitude and variance measure of total acceleration. For each sensor,
the the raw pitch, yaw and roll are recorded as well as 8 features that
are calculated on these angles: mean, variance, standard deviation, max,
min, amplitude, kurtosis and skewness.

## Feature Selection

Before we use our data to train the models, we have to address missing
values and redundant features. For some features up to 93% of the values
are missing, and the values that aren’t missing correspond exactly to
those observations with new\_window = “yes”. So, we have to consider
either imputing values or removing these features from consideration.
Since such a high percentage is missing it seems more prudent to remove
than to attempt to estimate over 90% of the values. Furthermore, these
features are missing or NA for the examples we intend to predict, so
there is no harm in removing them

``` r
training <- subset(training, new_window = "no")
tclasses <- training$classe
training <- mutate_all(training[,8:159],
                       function(x) as.numeric(as.character(x)))
testing  <- mutate_all(testing[,8:159],
                       function(x) as.numeric(as.character(x))) 
percentna <- apply(training,2,function(x){sum(is.na(x))/length(x)})
na_any <- names(percentna[percentna > 0])
ind <- names(percentna) %in% na_any
train0 <- training[,!ind]
test0 <- testing[,!ind]
dim(train0)
```

    ## [1] 19622    52

Next, we want to remove highly correlated variables as some of them may
be redundant. We use the findCorrelation function, which returns indices
of features with correlation above a cutoff. Since these variables come
in pairs, the function uses the mean absolute correlation to tie break:

``` r
corMat <- cor(train0)
highcor <- findCorrelation(corMat, cutoff = 0.75)
train0 <- train0[,-highcor]
dim(train0)
```

    ## [1] 19622    31

Hence, we have reduced 160 features down to 31 which should greatly
reduce the training time and hopefully result in good models.

## Training

Our goal is to build a classification model with which we can assign
test examples to one of 5 classes: A,B,C,D,E. Where class A indicates
performing the exercise correctly and B-E represent various ways of
performing them incorrectly.

We will try three different classifiers and pick the best performing
one. The models we consider are:

  - KNN Classifier
  - Linear Discriminant Analysis
  - Random Forest

For the KNN classifier we pass an argument telling the train function to
do a 10-fold cross validation on the training data set:

``` r
x <- train0
y <- factor(tclasses)
set.seed(1530)
ctrl <- trainControl(method = "cv", number = 10)
fit.knn <- train(x,y, method = "knn", trControl = ctrl)
```

Next, we fit an LDA classifier, again telling R to do a 10-fold cross
validation:

``` r
set.seed(1530)
fit.lda <- train(x,y, method = "lda", trControl = ctrl)
```

Finally, we build a random forest model:

``` r
set.seed(1530)
fit.rf <- train(x,y, method = "rf")
```

## Assessment

For each of these models we either explicitly told the train function to
perform 10-fold cross-validation or in the case of random forests,
resampling is inherent to process of fitting the model:

``` r
model.knn <- fit.knn$finalModel
model.lda <- fit.lda$finalModel
model.rf <- fit.rf$finalModel
```

The train function aggregates the confusion matrices for the hold-out
samples of the training data, which we can use for estimating the
accuracy and therefore the out-of-sample error:

``` r
confusionMatrix(fit.knn)
```

    ## Cross-Validated (10 fold) Confusion Matrix 
    ## 
    ## (entries are percentual average cell counts across resamples)
    ##  
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 26.9  0.9  0.1  0.2  0.3
    ##          B  0.5 16.1  0.7  0.3  0.9
    ##          C  0.3  0.9 15.6  1.2  0.7
    ##          D  0.5  0.6  0.7 14.3  0.8
    ##          E  0.2  0.9  0.4  0.4 15.7
    ##                             
    ##  Accuracy (average) : 0.8863

``` r
confusionMatrix(fit.lda)
```

    ## Cross-Validated (10 fold) Confusion Matrix 
    ## 
    ## (entries are percentual average cell counts across resamples)
    ##  
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 19.8  4.4  3.2  1.0  1.5
    ##          B  3.4  9.1  1.6  1.7  3.1
    ##          C  2.8  2.5 10.7  2.3  2.5
    ##          D  2.1  1.8  1.6  9.7  2.4
    ##          E  0.3  1.6  0.3  1.7  8.9
    ##                             
    ##  Accuracy (average) : 0.5823

``` r
confusionMatrix(fit.rf)
```

    ## Bootstrapped (25 reps) Confusion Matrix 
    ## 
    ## (entries are percentual average cell counts across resamples)
    ##  
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 28.4  0.1  0.0  0.0  0.0
    ##          B  0.0 19.1  0.2  0.0  0.0
    ##          C  0.0  0.1 17.1  0.3  0.0
    ##          D  0.0  0.0  0.1 16.1  0.0
    ##          E  0.0  0.0  0.0  0.0 18.4
    ##                             
    ##  Accuracy (average) : 0.9912

The LDA classifier has only about 59% accuracy, which is rather poor
performance. The KNN classifier has about 89% accuracy on the hold-out
samples and the random forest classifier has about 99% accuracy. We
choose the random forest model for our predictions since it is the most
accurate by far. We would expect based on the average accuracy on the
validation sets used during cross validation that this algorithm would
have less than but close to 99% accuracy on new samples. Our estimate
for out-of-sample error rate is around 1% or slightly larger.

## Predictions

We use the random forest model for our predictions since it is the most
accurate:

``` r
predict(fit.rf,test0)
```

    ##  [1] B A B A A E D B A A B C B A E E A B B B
    ## Levels: A B C D E

### References

  - Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H.
    Qualitative Activity Recognition of Weight Lifting Exercises.
    Proceedings of 4th International Conference in Cooperation with
    SIGCHI (Augmented Human ’13) . Stuttgart, Germany: ACM SIGCHI, 2013.

  - Gareth, J.; Witten, D.; Hastie, T. Tibshirani, R. An Introduction to
    Statistical Learning with Applications in R. Springer (2017). 8th
    Printing.
