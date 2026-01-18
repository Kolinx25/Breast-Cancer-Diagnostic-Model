Bridging the Gap: Transforming Clinical Data into Actionable Insights

As an MSc student in Data Management and Analytics at the University of Cape Coast, my role as an incoming Data Analyst/Data Scientist is to transform raw 
data into a useful tool that helps businesses and organizations make impactful, informed decisions.

To put this into practice, I developed this predictive modeling project (for educational purposes only) to bridge the gap between clinical pathology and data-driven insights.

Project: Breast Cancer Diagnostic Classification
1. Objective
The objective was to develop a machine learning solution to assist in the classification of breast tumors as Malignant or Benign. By leveraging a clinical dataset of 699 biopsies,
I built a Decision Tree model that translates complex cytological measurements into a transparent diagnostic flowchart.

3. Dataset & Quality Control
Using the Wisconsin Breast Cancer Dataset, I performed a rigorous quality check:

Feature Set: 9 cytological descriptors (Clump thickness, cell size, etc.).

Data Cleaning: Utilized the visdat package to identify missingness. Approximately 2.3% of the data was missing in the Bare.nuclei column, 
which was handled via listwise deletion to ensure model integrity.

3. Methodology
I employed the CART (Classification and Regression Trees) algorithm, which is the R implementation equivalent to the J48 algorithm.

Splitting: Used the tidymodels framework for an 80/20 train-test split with stratified sampling.

Logic: The model uses Gini Impurity to determine optimal splits, ensuring the output is highly interpretable for clinical use.

4. Key Results (Evaluation)
The model demonstrated strong diagnostic reliability on unseen test data:

Balanced Accuracy: 94.63%

Sensitivity (Recall): 95.51% (Crucial for high detection rates).

Specificity: 93.75% (Reliability in identifying benign cases).

5. Deployment: The Shiny Assistant
To demonstrate practical utility, I developed an interactive Shiny Dashboard. This allows professionals to input biopsy results via a user interface and receive an instantaneous
classification (including probability/confidence levels), transforming a static model into a functional Decision Support System.

Conclusion
This project demonstrates the power of Decision Trees in healthcare. While the model shows high predictive power, the presence of false negatives underscores that AI should serve as an augmentation to clinical expertise, not a replacement.
