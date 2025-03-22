-- Optimize Ad Campaign Budget Allocation

-- Problem: Determine which platforms, content types, or target demographics yield the highest ROI (Return on Investment) to optimize budget allocation.
-- Analysis: Analyze the relationship between budget, conversions, and CTR (Click-Through Rate) across different platforms, 
-- content types, and target demographics.

UPDATE ad_campaign_performance_3
SET Content_type = 'Story'
WHERE Content_type = 'Reel';

SELECT *
FROM ad_campaign_performance_3;

-- ROI by plataforms
WITH ROI_By_Platforms AS
(
SELECT Platform, AVG(ROI) AS ROI_By_Platfrom
FROM ad_campaign_performance_3
GROUP BY Platform
), ROI_BY_Content_type AS
(
SELECT Content_Type, AVG(ROI) AS ROI_By_Content_Type
FROM ad_campaign_performance_3
GROUP BY Content_Type
)

SELECT p.platform,c.Content_type, 
p.ROI_By_Platfrom, 
c.ROI_By_Content_Type, ROI_By_Platfrom + ROI_By_Content_Type / 2 AS ROI
FROM ROI_By_Platforms AS p
JOIN ROI_BY_Content_type AS c
ORDER BY ROI DESC;


-- analyzing target demographics


WITH ROI_Gender AS 
(
    SELECT Target_Gender, AVG(ROI) AS ROI
    FROM ad_campaign_performance_3
    GROUP BY Target_Gender
), 
ROI_Age AS
(
    SELECT Target_Age, AVG(ROI) AS ROI
    FROM ad_campaign_performance_3
    GROUP BY Target_Age
), 
ROI_Region AS
(
    SELECT Region, AVG(ROI) AS ROI
    FROM ad_campaign_performance_3
    GROUP BY Region
)
SELECT 
    r.Region, g.Target_Gender,
    a.Target_Age,
    g.ROI AS Avg_ROI_Gender,
    a.ROI AS Avg_ROI_Age,
    r.ROI AS Avg_ROI_Region,
    (g.ROI + a.ROI + r.ROI) / 3 AS AVG_Demographics
FROM 
    ROI_Gender AS g
JOIN 
    ROI_Age AS a
JOIN 
    ROI_Region AS r;

WITH Budget_Range AS
(
SELECT Budget, 'Low_buget' AS `range`
FROM ad_campaign_performance_3
WHERE Budget <= 10000 
UNION ALL
SELECT Budget, 'Mid_buget' AS `range`
FROM ad_campaign_performance_3
WHERE Budget > 10000 AND Budget <= 20000 
UNION ALL
SELECT Budget, 'High_buget' AS `range`
FROM ad_campaign_performance_3
WHERE Budget > 20000
)

SELECT d.Budget, r.`range`, d.ROI
FROM Budget_Range AS r
JOIN ad_campaign_performance_3 AS d
ON d.Budget = r.Budget;

-- you cant put select statement in between the cte and the join



