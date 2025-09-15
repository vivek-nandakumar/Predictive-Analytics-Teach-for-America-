# Load required libraries
library(dplyr)
library(ggplot2)
library(caret)
library(e1071)
library(C50)
library(neuralnet)
library(fastDummies)
library(kernlab)
library(ggdendro)
library(tidyverse)
library(class)
library(randomForest)

#Load and Inspect the Dataset
people <- read.csv("People.csv")  str(people)
summary(people)

#Data Cleaning
# Fill missing values in 'schoolsel' and ‘essay1length’ with 0
pa.df <- people %>%
  mutate(schoolsel = ifelse(is.na(schoolsel), 0, schoolsel)) %>%
  mutate(essay1length = ifelse(is.na(essay1length), 0, essay1length))

# Remove irrelevant columns
pa.df <- pa.df %>%
  select(-c(personid, appyear, schoolsel_chr, major1, major2, minor, major1group, major2group, minorgroup, undergrad_uni))

#Data Preprocessing
# Correlation Analysis and Feature Selection
data_no <- select(pa.df, c(gpa, stem, schoolsel, essay1length,
                           essay2length, essay3length, essayuniquewords,
                           essayssentiment, signupdate, starteddate,
                           submitteddate, attendedevent))
str(data_no)
data_cor <- as.data.frame(round(cor(data_no), 2))
data_cor

# Retain relevant predictors by removing highly correlated variables
pa.df <- pa.df %>%
  select(-c(essay1length, essay2length, essay3length))  # Retain essayuniquewords

# Convert categorical variables to factors
pa.df <- pa.df %>%
  mutate(across(c(stem, schoolsel, attendedevent, completedadm), as.factor))

# Scale numeric variables
num_vars <- names(select_if(pa.df, is.numeric))
pa.df[num_vars] <- scale(pa.df[num_vars])

#Data Partitioning
set.seed(1947)
idx <- createDataPartition(pa.df$completedadm, p = 0.8, list = FALSE)
train_data <- pa.df[idx, ]
test_data <- pa.df[-idx, ]

str(pa.df)


##KNN##
knn_model <- train(
  completedadm ~ .,                # Formula specifying the target and predictors
  data = train_data,                # Training data
  method = "knn",                  # Specify KNN as the model
  tuneGrid = data.frame(k = 3:10),  # Grid search over k = 3 to k = 10
  trControl = trainControl(method = "cv", number = 5)  # 5-fold cross-validation
)

# View model performance during training
print(knn_model)

# Make predictions on the test data
knn_predictions <- predict(knn_model, newdata = test_data)

# Evaluate the model performance
confusionMatrix(knn_predictions, test_data$completedadm)

##Naive_Bayes##
# Train the Naive Bayes model
nb_model <- naiveBayes(completedadm ~ ., data = train_data)

# Make predictions on the test set
nb_predictions <- predict(nb_model,newdata= test_data)

# Evaluate the Naive Bayes model
confusionMatrix(nb_predictions, test_data$completedadm)

#Support Vector Machine (SVM)##

svm_model <- ksvm(completedadm ~ ., data = train_data, kernel = "vanilladot")
svm_pred <- predict(svm_model, test_data)
confusionMatrix(svm_pred, test_data$completedadm)


## Improving model performance ----
# change to a RBF kernel
# Train SVM with a linear kernel
svm_model_rbf <- ksvm(completedadm ~ ., data = train_data, kernel = "rbfdot")
svm_pred <- predict(svm_model_rbf, test_data)
confusionMatrix(svm_pred, test_data$completedadm)


##Decision Trees##

tree_model <- C5.0(completedadm ~ ., data = train_data)
tree_pred <- predict(tree_model, test_data)
confusionMatrix(tree_pred, test_data$completedadm)
plot(tree_model)

#RANDOM FOREST MODEL
# set weight
class_weights <- c("0" = 10, "1" = 1)

# train randomforest
rf_model <- randomForest(
  completedadm ~ ., 
  data = train_data, 
  classwt = class_weights)

# predict & caculate
rf_predictions <- predict(rf_model, test_data)
confusionMatrix(rf_predictions, test_data$completedadm)
importance(rf_model)
varImpPlot(rf_model, main = "Feature Importance")

###ANN  MODEL##
people_cleaned <- pa.df %>%
  dummy_cols(select_columns = c("stem", "schoolsel", "appdeadline"), remove_first_dummy = TRUE) %>%
  dummy_cols(select_columns = "completedadm", remove_first_dummy = FALSE)

# Split data into training (80%) and testing (20%) set
set.seed(1947)
idx <- createDataPartition(people_cleaned$completedadm, p = 0.8, list = FALSE)
ann_train <- people_cleaned[idx, ]
ann_test <- people_cleaned[-idx, ]

# Build ANN model with the most important features
ann_model <- neuralnet(completedadm_0 + completedadm_1 ~ 
                         gpa + essayuniquewords + essayssentiment + signupdate +  stem_1 + schoolsel_2 + schoolsel_3 + 
                         appdeadline_January + appdeadline_March, 
                       data = ann_train, 
                       stepmax = 1e5)  # Lower the stepmax for faster convergence

# Plot ANN
plot(ann_model)

# Generate predictions on the test dataset
ann_predictions <- predict(ann_model, ann_test)

# Convert probabilities to class labels (0 or 1)
class.test <- apply(ann_predictions, 1, which.max) - 1  # Subtract 1 to match original labels

#ConfusionMatrix for ANN
class.test <- factor(class.test, levels = unique(c(class.test, ann_test$completedadm)))
ann_test$completedadm <- factor(ann_test$completedadm, levels = unique(c(class.test, ann_test$completedadm)))
confusionMatrix(class.test, ann_test$completedadm)

