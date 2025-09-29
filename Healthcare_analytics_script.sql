Create database if not exists Healthcare_Analytics;

Select *
From healthcare_dataset;


-- List all patients along with their age, gender, and medical condition.
Select Name, Age, Gender, Medical_Condition
From healthcare_dataset;

-- Get the count of patients by gender.
Select Gender, count(*)
From healthcare_dataset
Group By Gender;

-- Find patients older than 60 years.
Select Name, Age
From healthcare_dataset
Where Age > 60;

-- Retrieve patients with 'Asthma'.
Select Name, Medical_Condition
From healthcare_dataset
Where Medical_Condition Like 'Asthma';


-- Count the number of patients admitted per hospital.
Select Count(*) As num_patients, Hospital
From healthcare_dataset
Group By Hospital;

-- Find the average billing amount by admission type (e.g., Elective, Emergency, Urgent).
Select Admission_Type, Round(Avg(Billing_Amount), 2) As avg_billing_amount
From healthcare_dataset
Group By Admission_Type
Order By avg_billing_amount DESC;


-- Retrieve the total billing amount per insurance provider.
Select Insurance_Provider , Round(Sum(Billing_Amount), 0) As total_billing_amount
From healthcare_dataset
Group By Insurance_Provider
Order By total_billing_amount;


-- List patients with abnormal test results, along with the medication prescribed
Select Name, Test_Results, Medication
From healthcare_dataset
Where Test_Results = 'Abnormal';

-- Find the most common medical condition for patients over the age of 50.
Select Medical_Condition, Count(*) As count
From healthcare_dataset
Where Age > 50
Group By Medical_Condition
Order By count DESC ;

-- Calculate the percentage of patients with diabetes who were admitted for an emergency
Select (Count(*) * 100) / 
(Select Count(*) From healthcare_dataset Where Medical_Condition = 'Diabetes') As Diabetes_Emergency_Percent
From healthcare_dataset
Where Medical_Condition = 'Diabetes' And Admission_Type = 'Emergency';

-- Find the doctor with the highest number of patients treated in 'Emergency' admissions
Select Doctor, Count(*) AS highest_num_patients
From healthcare_dataset
Where Admission_Type = 'Emergency'
Group bY Doctor
Order By highest_num_patients DESC
Limit 1  ;

-- Find the average length of stay (in days) for each medical condition, grouped by admission type (e.g., Elective, Emergency, Urgent).
Select Medical_Condition, Admission_Type, Avg(datediff(Discharge_Date, Date_of_Admission)) As Avg_length_of_stay
From healthcare_dataset
Group by 1,2
Order By 3 ;

-- Identify doctors with patients who have the highest average billing amount for "Emergency" admissions.
-- This query identifies doctors with the highest average billing for emergency cases.

Select Doctor, Round(AVG(Billing_Amount), 2) As Avg_Billing
From healthcare_dataset
Where Admission_Type = 'Emergency'
Group bY Doctor
Having AVG(Billing_Amount) > (Select AVG(Billing_Amount) From healthcare_dataset Where Admission_Type = 'Emergency')
Order By Avg_Billing DESC;

-- Determine the top 3 insurance providers by total billing amount, and the average billing per patient for each provider.
-- This query provides insights into which insurance providers are handling the largest billing amounts,
-- with an additional breakdown of the average billing per patient.
Select Insurance_Provider, Round(Sum(Billing_Amount), 2) As Total_Billing_amt, Round(Avg(Billing_Amount), 2) As avg_billing
From healthcare_dataset
Group By Insurance_Provider
Order by Total_Billing_amt
Limit 3 ;

-- Find the most frequent combination of medical conditions in patients over 60
Select Medical_Condition, Count(*) As Frequency
From healthcare_dataset
Where Age > 60
Group bY Medical_Condition
Order By Frequency DESC ;

-- Identify which age group generates the highest revenue for hospitals.
-- This query calculates which age group of patients brings in the highest average billing.
Select
	Case
		When Age < 18 Then 'Children'
        When Age between 18 and 35 Then 'Young adults'
        When Age between 36 and 60 Then  'Adults'
        Else 'Senior Citizens'
	End As Age_Group, Avg(Billing_Amount) AS Avg_Billing
From healthcare_dataset
Group By Age_Group
Order BY Avg_Billing DESC;

-- Count of Patients by ICD-10 Diagnosis
Select ICD10_Code, ICD10_Description, Count(*) As patient_count
From healthcare_with_icd10_cpt
Group By 1, 2
Order By 3 DESC;

--  List of Patients with a Specific ICD-10 Code (e.g., Type 2 Diabetes)
 Select *
 From healthcare_with_icd10_cpt
 Where ICD10_Description = 'Type 2 diabetes mellitus without complications' ;
 
--  Top 5 Most Common Diagnoses for Patients Aged Over 60
Select a.ICD10_Code, a.ICD10_Description, Count(*) As Count
From healthcare_with_icd10_cpt a
Join healthcare_dataset b
On a.Name = b.Name
Where Age > 60 
Group By 1, 2
Order By 3 DESC
Limit 5;

-- Average Length of Stay for Each Diagnosis
Select a.ICD10_Description, Avg(datediff(Discharge_Date, Date_of_Admission)) AS Avg_length_of_stay
From healthcare_with_icd10_cpt a
Join healthcare_dataset b
On a.Name = b.Name
Group by 1
Order By 2 DESC;

-- Doctors with Highest Patient Load for a Specific Diagnosis
Select a.ICD10_Description, b.Doctor, Count(*) patient_count
From healthcare_with_icd10_cpt a
Join healthcare_dataset b
On a.Name = b.Name
Where ICD10_Description =  'Essential (primary) hypertension'
Group By 1, 2
Order By patient_count DESC;







