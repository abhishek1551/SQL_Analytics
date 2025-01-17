Use [Hospital]
select * from Healthcare

-- Query: Categorize patients into age groups using CTE
WITH AgeGroups AS (
    SELECT 
        Name,
        Gender,
        Age,
        Billing_Amount,
        CASE 
            WHEN Age < 18 THEN 'Child'
            WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
            WHEN Age BETWEEN 36 AND 55 THEN 'Adult'
            ELSE 'Senior'
        END AS AgeGroup
    FROM Healthcare
),

DemographicSummary AS (
    SELECT 
        AgeGroup,
        Gender,
        COUNT(*) AS PatientCount,
        AVG(Billing_Amount) AS AvgBilling
    FROM AgeGroups
    GROUP BY AgeGroup, Gender
)

SELECT 
    AgeGroup,
    Gender,
    PatientCount,
    AvgBilling
FROM DemographicSummary
ORDER BY AgeGroup, Gender;



-- Total Patients Handled
SELECT Hospital, COUNT(*) AS PatientCount
FROM Healthcare
GROUP BY Hospital
ORDER BY PatientCount DESC;


-- Yearly admission trend
SELECT 
    Admission_Type,
    FORMAT(Date_of_Admission, 'yyyy') AS AdmissionYear,
    COUNT(*) AS PatientCount
FROM Healthcare
GROUP BY Admission_Type, FORMAT(Date_of_Admission, 'yyyy')
ORDER BY AdmissionYear, Admission_Type;

-- Distribution by test results
SELECT 
    Test_Results,
    COUNT(*) AS ResultCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
FROM Healthcare
GROUP BY Test_Results
ORDER BY ResultCount DESC;



-- Average and Total Billing amount per Hospital
SELECT Hospital, AVG(Billing_Amount) AS AvgBilling, SUM(Billing_Amount) AS TotalBilling
FROM Healthcare
GROUP BY Hospital;

-- Rank Hospital by Total Billing
SELECT 
    Hospital, 
    SUM(Billing_Amount) AS TotalBilling,
    RANK() OVER (ORDER BY SUM(Billing_Amount) DESC) AS BillingRank
FROM Healthcare
GROUP BY Hospital;


-- Number of patients per Insurance Provider
SELECT 
    Insurance_Provider,
    COUNT(*) AS PatientCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(10, 2)) AS PercentageShare
FROM Healthcare
GROUP BY Insurance_Provider
ORDER BY PatientCount DESC;













