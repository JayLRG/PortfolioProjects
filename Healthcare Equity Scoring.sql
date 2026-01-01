-- 1: List of facilities with HCHE_F_SCORE of 5
-- 2: Number of high scores for each state (4 or 5)
-- 3: Percentage of each state with a score of 4 or 5


-- 1: List of facilities with HCHE_F_SCORE of 5
SELECT State,
	   zip_code,
	   Facility_Name,
	   Score
FROM dbo.[Hospital.Equity]
WHERE Score like '5'
ORDER BY State 


-- 2: Number of high scores for each state (4 or 5)
SELECT DISTINCT State,
	   score,
	   COUNT(Score) AS 'Number of Facilities'
FROM dbo.[Hospital.Equity]
WHERE Score IN ('4','5')
GROUP BY State, score
ORDER BY State, Score


-- 3: -- Percentage of each score (1-5) by state
SELECT State,
	   HCHE_measure_ID,
	   Score,   
	   SUM(CASE WHEN Score BETWEEN 0 AND 5 then 1 end) AS ScoreCount,
	   COUNT(Score) * 100.0 / SUM(COUNT(Score)) OVER(PARTITION BY State) AS 'Percentage of Total Scores by State'
FROM dbo.[Hospital.Equity]
WHERE HCHE_Measure_ID like 'HCHE_F_SCORE'
GROUP BY state, HCHE_Measure_ID, score
ORDER BY state
