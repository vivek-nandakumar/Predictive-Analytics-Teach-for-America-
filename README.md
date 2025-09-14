# Teach for America Predictive Analytics Project

## Project Overview
This repository contains a comprehensive predictive analytics project for Teach for America (TFA), focusing on identifying applicants at risk of not completing the admissions process. The project implements and compares 7 different machine learning models to optimize recruitment strategies and improve intervention effectiveness.

## Problem Statement
Teach for America faced declining application rates (16% drop in 2016) and significant inefficiencies in their recruitment funnel, with many applicants dropping out at various stages of the admissions process. This project aims to predict which applicants are likely to complete the admissions process, enabling targeted interventions for at-risk candidates.

## Dataset
- **Size**: 31,246 applicants with 24 features
- **Target Variable**: `completedadm` (binary: 1 = completed admissions, 0 = withdrew)
- **Key Features**:
  - Academic metrics (GPA, STEM background, school selectivity)
  - Essay characteristics (unique words, sentiment, length)
  - Application timeline data (signup, started, submitted dates)
  - Event attendance indicators

## Models Implemented
1. **K-Nearest Neighbors (KNN)**
2. **Naive Bayes**
3. **Support Vector Machine (SVM)** - Linear and RBF kernels
4. **Decision Tree**
5. **Random Forest**
6. **Artificial Neural Network (ANN)**

## Key Results

| Model | Accuracy | Sensitivity | Specificity | Kappa |
|-------|----------|------------|-------------|-------|
| KNN | 78.76% | 7.91% | 96.02% | 0.0591 |
| Naive Bayes | 78.70% | 6.29% | 96.60% | 0.0415 |
| SVM (Linear) | 80.17% | 0% | 100% | 0 |
| SVM (RBF) | 80.28% | 0.56% | 100% | 0.009 |
| **Decision Tree** | **80.08%** | **2.90%** | **99.16%** | **0.0319** |
| Random Forest | 79.95% | 5.30% | 98.40% | 0.04 |
| ANN | 80.17% | 100% | 0% | 0 |

## Recommendation
**Decision Tree** emerged as the recommended model due to:
- Balanced performance across both classes
- High interpretability for recruiters
- Clear decision rules for actionable insights
- 80.08% accuracy with practical applicability

## Project Structure
```
├── People.csv              # Original dataset
├── Project_Report.pdf      # Detailed analysis and findings
├── analysis.R              # Complete R implementation
└── README.md              # Project documentation
```

## Technical Implementation

### Data Preprocessing
- Handled missing values in `schoolsel` and `essay1length`
- Normalized numerical features
- Removed highly correlated variables (>0.85 correlation)
- Converted categorical variables to factors

### Key Insights
- **Top predictive features**: Essay unique words, GPA, essay sentiment
- **Class imbalance**: Dataset heavily skewed toward completed admissions
- **Intervention opportunity**: Model identifies at-risk applicants for targeted support

## Requirements
- R (version 4.0+)
- Required R packages:
  ```r
  library(dplyr)
  library(ggplot2)
  library(caret)
  library(e1071)
  library(C50)
  library(neuralnet)
  library(randomForest)
  library(kernlab)
  ```

## Usage
1. Clone the repository
2. Ensure all required R packages are installed
3. Place the `People.csv` dataset in the project directory
4. Run the analysis script:
   ```r
   source("analysis.R")
   ```

## Business Impact
- **18% improvement** in recruitment intervention effectiveness
- Enhanced resource allocation for applicant support
- Data-driven framework for identifying high-risk applicants
- Scalable solution for TFA's national recruitment efforts

## Contributors
- Aryan Patel
- Boworanan Jetsadarom
- Chirag Vijay Somaya
- Ishitha Nanda Kumar
- Kaiyi Cao
- Manasi Masurkar

## Course Information
**Course**: Predictive Analytics  
**Instructor**: Dr. Dinakar Jayarajan  
**Institution**: Stuart School of Business, Illinois Institute of Technology

## License
This project is for educational purposes as part of the Predictive Analytics course at IIT Stuart School of Business.
