--1: Most common admission_type per medical condition
--2: 30-day readmission rate; Discharge_date -> next Date_of_admission being < 30 days apart
--3: Readmissions by medical condition



--1: Number of Admissions by condition and admission type
SELECT Medical_Condition,
	   Admission_Type,
	   COUNT(admission_type) AS 'Number of Admissions'
FROM dbo.Hospital_Dataset
GROUP BY Medical_Condition,
		 Admission_Type
ORDER BY Medical_Condition,
		 Admission_Type


--2: Readmission rate
SELECT
	SUM(CASE
			WHEN Admission_Class = 'Readmitted' THEN 1 
			ELSE 0 END) AS '30-Day_Readmits', 
	SUM(CASE WHEN Admission_Class = 'NotReadmitted' THEN 1
			ELSE 0 END) AS 'NonReadmits',
	COUNT(Admission_Class) AS 'TotalAdmits'
FROM Discharges
WHERE '30-Day_Readmits' NOT LIKE 'Elective'


--3: Readmissions by medical condition
--Need to account for a patient being electively admitted, discharged, then non-electively readmitted (Exclude elective readmissions, but INCLUDE "elective" discharges)
SELECT medical_condition,
	   COUNT(medical_condition) AS 'Number of Readmissions'
FROM Discharges
WHERE Admission_Class LIKE 'Readmitted' AND 'Readmitted' NOT LIKE 'Elective'
GROUP BY Medical_Condition
ORDER BY COUNT(medical_condition) DESC, medical_condition



--Creating tables to produce queries 2 and 3;
--General CTE showing readmission cases within 30 days
WITH CTE_Disc AS
	(SELECT Name,
			Medical_Condition,
			Date_of_Admission,
			Discharge_Date,
			Admission_Type,
			DATEDIFF(DAY, LAG(Discharge_Date) OVER(PARTITION BY name ORDER BY Discharge_date), Date_of_Admission) AS 'DC'
FROM dbo.Hospital_Dataset)
SELECT *
FROM CTE_Disc
WHERE DC BETWEEN 1 AND 30
ORDER BY Name, Date_of_Admission, Discharge_Date


--Query with CASE WHEN statement to categorize readmission cases
WITH CTE_Disc AS
	(SELECT Name,
			Medical_Condition,
			Date_of_Admission,
			Discharge_Date,
			Admission_Type,
			DATEDIFF(DAY, LAG(Discharge_Date) OVER(PARTITION BY name ORDER BY Discharge_date), Date_of_Admission) AS 'DC'
FROM dbo.Hospital_Dataset)
SELECT *, CASE
			WHEN DC BETWEEN 1 AND 30 THEN 'Readmitted within 30 Days'
			ELSE 'NotReadmitted'
			END AS 'Admit Class'
FROM CTE_Disc


--Creating new table (Discharges) from the CTE
CREATE TABLE Discharges
	(Name varchar(50),
	Medical_Condition varchar(50),
	Date_of_Admission Date,
	Discharge_Date Date,
	Admission_Type varchar(50),
	Readmission_Days INT,
	Admission_Class varchar(50))


--Inserting data into new Discharges table
WITH CTE_Disc AS
	(SELECT Name,
			Medical_Condition,
			Date_of_Admission,
			Discharge_Date,
			Admission_Type, DATEDIFF(DAY, LAG(Discharge_Date) OVER(PARTITION BY name ORDER BY Discharge_date), Date_of_Admission) AS 'Readmission_Days'
	FROM dbo.Hospital_Dataset)
INSERT INTO dbo.Discharges (Name,
							Medical_Condition,
							Date_of_Admission,
							Discharge_Date,
							Admission_Type,
							Readmission_Days)
SELECT *
FROM CTE_Disc


--Inserting Admission_Class Data into Discharges table
UPDATE Discharges
SET Admission_Class = 'NotReadmitted' WHERE Readmission_Days IS NULL
UPDATE Discharges
SET Admission_Class = 'NotReadmitted' WHERE Readmission_Days < 1 
UPDATE Discharges
SET Admission_Class = 'NotReadmitted' WHERE Readmission_Days > 30
UPDATE Discharges
SET Admission_Class = 'Readmitted' WHERE Readmission_Days BETWEEN 1 AND 30