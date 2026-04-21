# NHIS 2024 Analysis: Obesity and Hypertension

## 📊 Overview

This project analyzes the association between obesity and hypertension using NHIS 2024 data, applying survey-weighted methods to generate nationally representative estimates.

---

## 🎯 Research Question

Is obesity associated with higher prevalence of hypertension among U.S. adults?

---

## 🧠 Data Source

* National Health Interview Survey (NHIS) 2024
* Cross-sectional, nationally representative dataset
* Sample size: 31,957 adults
* Survey design features:

  * Sampling weights (`WTFA_A`)
  * Strata (`PSTRAT`)
  * Clusters / PSU (`PPSU`)

---

## ⚙️ Methods

### Data Preparation

* Outcome: Hypertension (self-reported diagnosis)
* Exposure: Obesity (BMI category)
* Covariates:

  * Age (continuous)
  * Sex (male vs female)
  * Race (White vs Non-White)

---

### Statistical Analysis

#### 1. Descriptive Analysis

* Survey-weighted prevalence estimates using `PROC SURVEYFREQ`
* Weighted means using `PROC SURVEYMEANS`

#### 2. Main Model

* Survey-weighted logistic regression (`PROC SURVEYLOGISTIC`)
* Adjusted for age, sex, and race
* Accounted for NHIS complex survey design (weights, strata, PSU)

#### 3. Effect Modification

* Tested interaction between obesity and sex
* Conducted stratified analyses by sex

#### 4. Sensitivity Analysis

* Poisson regression with robust variance (`PROC GENMOD`)
* Estimated prevalence ratios (PR) to compare with odds ratios (OR)

All analyses accounte for the complex survey design of NHIS using sampling weights, strata, and primary sampling units.

---

## 📈 Key Findings

* **Hypertension prevalence:** 31.9% (weighted)
* **Obesity prevalence:** 33.4% (weighted)
* Hypertension was a common outcome in this population (~32%), supporting the use of prevalence-based interpretation

### Main Results (Adjusted Model)

* Obesity was associated with higher prevalence of hypertension

  * OR: **2.67** (95% CI: 2.50–2.85)
* Age was a strong predictor

  * OR per year: **1.068**
* Males had higher odds compared to females

  * OR: **1.38**
* Non-White individuals had higher odds compared to White individuals

  * OR: **1.30**

### Effect Modification

* No significant interaction between obesity and sex (p = 0.35)
* Stratified analyses showed similar effect sizes across males and females

### Sensitivity Analysis

* Poisson regression produced a lower estimate:

  * PR ≈ **1.71**
* This demonstrates that odds ratios may overestimate associations when outcomes are common

---

## ⚠️ Interpretation

* Findings reflect **associations with prevalent hypertension**, not causal effects
* The cross-sectional design limits conclusions about temporality
* Given the high prevalence of hypertension (~32%), odds ratios should be interpreted cautiously

---

## ⚠️ Limitations

* Cross-sectional data → cannot infer causality
* Self-reported measures may introduce misclassification
* Race categorized as White vs Non-White may mask heterogeneity
* Logistic regression may overestimate effect size for common outcomes

---

## 🔄 Updates Based on Feedback

This project was refined to improve methodological rigor and interpretation:

* Implemented survey-weighted models using `PROC SURVEYLOGISTIC`
* Accounted for NHIS complex sampling design (weights, strata, PSU)
* Reframed findings to focus on prevalence rather than risk
* Tested effect modification (obesity × sex)
* Conducted Poisson regression sensitivity analysis to estimate prevalence ratios

---

## 🛠️ Tools Used

* SAS (PROC SURVEYLOGISTIC, PROC SURVEYFREQ, PROC GENMOD)
* Epidemiologic methods for cross-sectional analysis
* Survey data analysis techniques

---

## 🚀 Key Takeaways

* Demonstrates ability to work with **nationally representative health data**
* Applies **advanced survey-weighted statistical methods**
* Incorporates **effect modification and sensitivity analyses**
* Shows **iterative improvement based on methodological feedback**

---

## 📁 Repository Structure

/code

* proj3_original_logistic.sas
* proj3_final_survey_analysis.sas

/output

## 📊 Output

### Population Characteristics (Weighted)

* **Hypertension prevalence:** 31.9%
* **Obesity prevalence:** 33.4%
* **Male:** 49.1%
* **Non-White:** 29.1%
* **Mean age:** 48.3 years (SE: 0.16)

---

### Main Model: Survey-Weighted Logistic Regression

Adjusted for age, sex, and race:

* **Obesity:** OR = 2.67 (95% CI: 2.50–2.85)
* **Age:** OR = 1.068 per year (95% CI: 1.066–1.070)
* **Male:** OR = 1.38 (95% CI: 1.29–1.48)
* **Non-White:** OR = 1.30 (95% CI: 1.20–1.41)

Model performance:

* **c-statistic = 0.787** (good discrimination)

---

### Effect Modification (Obesity × Sex)

* Interaction term not statistically significant (p = 0.35) 
* Suggests the association between obesity and hypertension does not differ meaningfully by sex

---

### Stratified Analysis

**Females:**

* Obesity OR = 2.56 (95% CI: 2.33–2.83)

**Males:**

* Obesity OR = 2.74 (95% CI: 2.50–3.01)

→ Results are consistent across groups

---

### Sensitivity Analysis (Poisson Regression)

Using robust variance estimation:

* **Obesity:** PR ≈ 1.71
* **Age:** PR ≈ 1.04 per year
* **Male:** PR ≈ 1.19
* **Non-White:** PR ≈ 1.16

---

### Key Insight

The Poisson model produced lower estimates than logistic regression (PR ≈ 1.71 vs OR ≈ 2.67), demonstrating that **odds ratios can overestimate associations when outcomes are common**, as is the case with hypertension (~32% prevalence).


<img width="1536" height="1024" alt="3094d465-9a13-4547-a0c4-8d5d3c190087" src="https://github.com/user-attachments/assets/ffc4fc5e-aafc-4b0d-ab8d-49530debc3d8" />

### Visual Summary: OR vs. PR Comparison

| Measure | Obesity Estimate |
|---|---:|
| Odds Ratio (survey-weighted logistic regression) | 2.67 |
| Prevalence Ratio (Poisson sensitivity analysis) | 1.71 |

This comparison shows that when the outcome is common, odds ratios can overstate the magnitude of association relative to prevalence ratios.


This project demonstrates the application of epidemiologic methods to real-world data, including survey-weighted analysis, effect modification assessment, and sensitivity modeling.

---

