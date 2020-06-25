# Code Book

This document briefly describes the variables corresponding to the columns in the dataset created by the script "run_analysis.R" which will be contained in the .csv file called "tidydata.csv".

## The original data

The original dataset, which can be found in the "UCIdata.zip" file contains data collected from experiments where 30 volunteers aged 19-48 performed six activities while wearing a Samsung Galaxy S II on their waist. Using the embedded accelerometer and gyroscope, the researchers recorded the 3-axial linear acceleration and the 3-axial angular velocity at a constant rate of 50Hz. From these raw signals, a vector of features was obtained by calculating variables from the time and frequency domain.

We will not describe all variables from the original dataset, only those that pertain to our particular analysis. For a more detailed explanation of how the original raw data was collected, and which features were estimated, consult the "README.txt" and "features_info.txt" files which can be found in the original folder 'UCI HAR Dataset'. We will summarize the most relevant details for each variable here.

## Changes applied to the data

To obtain our new dataset, our script "run_analysis.R" does the following:

* Combines the training and test data
* Replaces activity label (1-6) with the corresponding activity
* Removes all but the mean() and std() variable estimates from the feature vector
* Renames each estimated variable for added clarity
* Calculates the mean of each estimated variable for a given subject/activity

## Variables

For each axial variable, we provide only the description for the variable corresponding to the X-axis, the corresponding Y-axis and Z-axis variables are defined analogously.

* "Subject"

A number 1-30 indicating which of the 30 subject whose smartphone was used to collect the raw data.

* "Activity"

A character vector indicating the activity that the subject was undertaking as the measurements were made, one of "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING" or "LAYING".

* "Mean of Avg of the Acceleration along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the average acceleration along a given axis (one of either X, Y, or Z) given in standard gravity units "g".

* "Mean of Std. Dev. of the  Acceleration along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the acceleration along a given axis (one of either X, Y, or Z) given in standard gravity units "g".

* "Mean of Avg of the Gravitational Acceleration along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the average acceleration due to gravity along a given axis (one of either X, Y, or Z) given in standard gravity units "g".

* "Mean of Std. Dev. of the Gravitational Acceleration along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the acceleration due to gravity along a given axis (one of either X, Y, or Z) given in standard gravity units "g".

* "Mean of Avg of the  Jerk along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the average jerk (change in acceleration) along a given axis (one of either X, Y, or Z) given in units of g/sec where "g" is the standard gravity unit.

* "Mean of Std. Dev. of the  Jerk along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the jerk (change in acceleration) along a given axis (one of either X, Y, or Z) given in units of g/sec where "g" is the standard gravity unit.

* "Mean of Avg of the Angular Acceleration along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the average angular acceleration along a given axis (one of either X, Y, or Z) given in units of radians per seconds squared (rad/sec^2).

* "Mean of Std. Dev. of the  Angular Acceleration along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the angular acceleration along a given axis (one of either X, Y, or Z) given in units of radians per seconds squared (rad/sec^2).

* "Mean of Avg of the  Angular Jerk along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the average of the angular jerk (change in acceleration) along a given axis (one of either X, Y, or Z) given in units of radians per seconds cubed (rad/sec^3).

* "Mean of Std. Dev. of the Angular Jerk along X-axis (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the angular jerk (change in acceleration) along a given axis (one of either X, Y, or Z) given in units of radians per seconds cubed (rad/sec^3).

* "Mean of Avg of the Acceleration (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average acceleration as determined by the Euclidean 3-norm given in standard gravity units "g".

* "Mean of Std. Dev. of the  Acceleration  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the acceleration as determined by the Euclidean 3-norm given in standard gravity units "g".

* "Mean of Avg of the Gravitational Acceleration  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average acceleration due to gravity as determined by the Euclidean 3-norm given in standard gravity units "g".

* "Mean of Std. Dev. of the Gravitational Acceleration  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the acceleration due to gravity as determined by the Euclidean 3-norm given in standard gravity units "g"

* "Mean of Avg of the  Jerk  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average jerk (change in acceleration) as determined by the Euclidean 3-norm given in units of g/sec where "g" is the standard gravity unit.

* "Mean of Std. Dev. of the  Jerk (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the jerk (change in acceleration) as determined by the Euclidean 3-norm given in units of g/sec where "g" is the standard gravity unit.

* "Mean of Avg of the  Angular Acceleration  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average angular acceleration as given by the Euclidean 3-norm given in units of radians per seconds squared (rad/sec^2).

* "Mean of Std. Dev. of the  Angular Acceleration  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the angular acceleration as given by the Euclidean 3-norm given in units of radians per seconds squared (rad/sec^2).

* "Mean of Avg of the  Angular Jerk  (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average of the angular jerk (change in acceleration) as determined by the Euclidean 3-norm given in units of radians per seconds cubed (rad/sec^3).

* "Mean of Std. Dev. of the Angular Jerk (Time)"

The average of all measurements from the raw time domain signals (Time) for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the angular jerk (change in acceleration) as determined by the Euclidean 3-norm given in units of radians per seconds cubed (rad/sec^3).

* "Mean of Avg of the  Acceleration along X-axis (Freq)"

The average of all measurements from the frequency domain signals (Freq), calculated via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the average acceleration along a given axis (one of either X, Y, or Z) given in standard gravity units "g".

* "Mean of Std. Dev. of the  Acceleration along X-axis (Freq)"

The average of all measurements from the frequency domain signals (Freq), calculated via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the acceleration along a given axis (one of either X, Y, or Z) given in standard gravity units "g".

* "Mean of Avg of the  Jerk along X-axis (Freq)"

The average of all measurements from the frequency domain signals (Freq), calculated via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average jerk (change in acceleration) as determined by the Euclidean 3-norm given in units of g/sec where "g" is the standard gravity unit.

* "Mean of Std. Dev. of the  Jerk along X-axis (Freq)"

The average of all measurements from the frequency domain signals (Freq), calculated via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the jerk (change in acceleration) as determined by the Euclidean 3-norm given in units of g/sec where "g" is the standard gravity unit.

* "Mean of Avg of the  Angular Acceleration along X-axis (Freq)"

The average of all measurements from the frequency domain signals (Freq), derived from the raw time domain signal via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the average angular acceleration along a given axis (one of either X, Y, or Z) given in units of radians per seconds squared (rad/sec^2).

* "Mean of Std. Dev. of the  Angular Acceleration along X-axis (Freq)"

The average of all measurements from the frequency domain signals (Freq), derived from the raw time domain signal via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the standard deviation of the angular acceleration along a given axis (one of either X, Y, or Z) given in units of radians per seconds squared (rad/sec^2).

* "Mean of Avg of the  Acceleration  (Freq)"

The average of all measurements from the frequency domain signals (Freq), derived from the raw time domain signal via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the average acceleration as determined by the Euclidean 3-norm given in standard gravity units "g".

* "Mean of Std. Dev. of the  Acceleration  (Freq)"

The average of all measurements from the frequency domain signals (Freq), derived from the raw time domain signal via Fast Fourier Transform, for the subject given by "Subject" performing the activity given by "Activity" of the magnitude of the standard deviation of the acceleration as determined by the Euclidean 3-norm given in standard gravity units "g".
