--Number of Referrals to each department
SELECT department_referral, COUNT(*) AS 'Number of Referrals'
FROM [Portfolio Project].dbo.Hospital_ER_CSV
GROUP BY department_referral
ORDER BY 'Number of Referrals'



--Number of patients being admitted
SELECT patient_admin_flag, COUNT(patient_admin_flag) AS "Number of Patients"
FROM [Portfolio Project].dbo.Hospital_ER_CSV
GROUP BY patient_admin_flag



--Average wait time based on patient race
SELECT patient_race, COUNT(patient_race) AS 'Number of Patients', AVG(patient_waittime) AS 'Average Wait Time (Minutes)'
FROM [Portfolio Project].dbo.Hospital_ER_CSV
GROUP BY patient_race
ORDER BY 'Average Wait Time (Minutes)' DESC



--Average wait time based on patient gender
SELECT patient_gender, COUNT(patient_gender) AS 'Number of Patients', AVG(patient_waittime) AS 'Average Wait Time (Minutes)'
FROM [Portfolio Project].dbo.Hospital_ER_CSV
GROUP BY patient_gender
ORDER BY 'Average Wait Time (Minutes)' DESC



--Average wait time based on patient race & gender
SELECT patient_race, patient_gender, COUNT(patient_race) AS 'Number of Patients', AVG(patient_waittime) AS 'Average Wait Time (Minutes)'
FROM [Portfolio Project].dbo.Hospital_ER_CSV
GROUP BY patient_race,patient_gender
ORDER BY 4, 1 DESC



--Average wait time based on department referral 
SELECT department_referral, COUNT(*) AS 'Number of Referrals', AVG(patient_waittime) AS 'Average Referral Wait Time (Minutes)'
FROM [Portfolio Project].dbo.Hospital_ER_CSV
GROUP BY department_referral 