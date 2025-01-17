# Overview 
## ("SQLQueriesForAnalytics.sql"):
- These queries cover a variety of use cases that mimic real-world scenarios and illustrate the practical application of SQL in a business environment using Adventure Works 2016. 
- They also showcase best practices like the use of error handling, views for abstraction, and modular approaches for complex logic.
---

## ("Hospital Dataset Analysis"):
The dataset used  was sourced from Kaggle and represents healthcare-related information about patients, including their demographics, medical conditions, admission details, and billing information.

### Key Insights and Queries Performed:

1. **Categorizing Patients by Age Groups**  
   - Grouped patients into the categories: `Child`, `Young Adult`, `Adult`, and `Senior`.
   - Analyzed patient count and average billing for each age group and gender.

2. **Yearly Admission Trend**  
   - Analyzed yearly trends based on `Admission_Type` to identify patterns in emergency, urgent, and elective admissions.

3. **Test Results Distribution**  
   - Calculated the distribution of test outcomes (Normal, Abnormal, Inconclusive) and their percentages.

4. **Total Patients Handled per Hospital**  
   - Identified the total number of patients treated at each hospital, ranked by patient count.

5. **Billing Analysis**  
   - Computed the average and total billing amounts for each hospital.
   - Ranked hospitals based on total billing.

6. **Insurance Provider Distribution**  
   - Counted the number of patients for each insurance provider and calculated their market share percentages.

7. **Cumulative Admissions Over Time**  
   - Used window functions to compute running totals of patient admissions for trend analysis.

8. **Ranking Hospitals by Total Billing**  
   - Ranked hospitals based on total billing amounts using the `RANK()` function.

---

## Highlights of SQL Techniques

- **Common Table Expressions (CTEs):**  
  Used to simplify queries, such as categorizing patients into age groups and summarizing demographic data.
  
- **Window Functions:**  
  Applied for calculating running totals, cumulative percentages, and ranking hospitals.
  
- **Group By and Aggregation:**  
  Employed to compute metrics like patient count, average billing, and total billing by various categories.
  
- **Date Formatting:**  
  Extracted yearly trends using `FORMAT(Date_of_Admission, 'yyyy')`.
