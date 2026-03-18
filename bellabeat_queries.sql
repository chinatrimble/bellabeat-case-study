-- Bellabeat Case Study 
-- Author: China Trimble 
-- Project: Smart Device Usage Analysis 
-- Tool: CSVFiddle SQL 
-- Date: 2026 


-- =============================================
-- Query 1: Combined both daily activity datasets
-- Purpose: Create one unified dataset 
-- =============================================

SELECT *
FROM daily_activity_1  

UNION ALL

SELECT * 
FROM daily_activity_2;


-- =============================================
-- Query 2: Average steps per user 
-- Purpose: Identify most active users 
-- =============================================

SELECT 
Id,
AVG(TotalSteps) AS avg_steps
FROM 
(
SELECT * FROM daily_activity_1 UNION ALL

SELECT * FROM daily_activity_2 
)
GROUP BY Id
ORDER BY avg_steps DESC;


-- =============================================
-- Query 3: Average steps per day 
-- Purpose: Identify activity trends over time 
-- =============================================

SELECT 
ActivityDate,
AVG(TotalSteps) AS avg_daily_steps
FROM 
(
SELECT * FROM daily_activity_1
UNION ALL 
SELECT * FROM daily_activity_2
)
GROUP BY ActivityDate
ORDER BY ActivityDate;

-- =============================================
-- Query 4: Activity minutes breakdown 
-- Purpose: Analyze user activity intensity levels 
-- ============================================= 

SELECT 
Id,

AVG(VeryActiveMinutes) AS avg_very_active,

AVG(FairlyActiveMinutes) AS avg_fairly_active,

AVG(LightlyActiveMinutes) AS avg_lightly_active,

AVG(SedentaryMinutes) AS avg_sedentary

FROM
(
SELECT * FROM daily_activity_1
UNION all
SELECT * FROM daily_activity_2
)

GROUP BY Id

ORDER BY avg_sedentary DESC;

-- ============================================= 
-- Query 5: User Activity level classification
-- Purpose: Categorize users based on average daily steps 
-- ============================================= 

SELECT 
Id, 

AVG(TotalSteps) avg_steps,

CASE 

WHEN AVG(TotalSteps) < 5000 THEN 'Sedentary'

WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Low Active'

WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Moderately Active'

WHEN AVG(TotalSteps) >= 10000 THEN 'Highly Active' 

END AS activity_level

FROM 
(
SELECT * FROM daily_activity_1
UNION ALL 
SELECT * FROM daily_activity_2
)

GROUP BY Id

ORDER BY avg_steps desc;

-- ============================================= 
-- Query 6: Most active day of the week 
-- Purpose: Identify which days users are most active 


SELECT 

CASE strftime('%w', ActivityDate)

WHEN '0' THEN 'Sunday'
WHEN '1' THEN 'Monday'
WHEN '2' THEN 'Tuesday'
WHEN '3' THEN 'Wednesday'
WHEN '4' THEN 'Thursday'
WHEN '5' THEN 'Friday'
WHEN '6' THEN 'Saturday'

END AS day_of_week,

AVG(TotalSteps) AS avg_steps

FROM 
(
SELECT * FROM daily_activity_1
UNION ALL 
SELECT * FROM daily_activity_2
)

GROUP BY day_of_week

ORDER BY avg_steps desc; 



