CREATE DATABASE titanic_db 
USE titanic_db

CREATE TABLE survived (
    PassengerId INT PRIMARY KEY,
    Survived TINYINT,
    Pclass TINYINT,
    Name VARCHAR(50),
    Sex VARCHAR(10),
    Age INT,
    SibSp INT,
    Parch INT,
    Ticket VARCHAR(20),
    Fare FLOAT,
    Cabin VARCHAR(20),
    Embarked VARCHAR(5)
);

CREATE TABLE data (
    PassengerId INT PRIMARY KEY,
    Pclass TINYINT,
    Name VARCHAR(50),
    Sex VARCHAR(10),
    Age INT,
    SibSp INT,
    Parch INT,
    Ticket VARCHAR(20),
    Fare FLOAT,
    Cabin VARCHAR(20),
    Embarked VARCHAR(5)
);

SELECT * FROM survived LIMIT 10;
SELECT COUNT(*) FROM survived
SELECT COUNT(*) FROM survived WHERE Survived = 1

SELECT COUNT(*) AS missing_ages FROM survived 
WHERE Age IS NULL

ALTER TABLE data
RENAME TO titanic_data

SELECT * FROM survived WHERE Age = '';
UPDATE survived SET Age = NULL WHERE Age = '';

DESC survived -- ( checks column definitions )

SELECT * FROM survived 
WHERE Age = 0 OR Age = '';

SELECT COUNT(*) AS missing_ages FROM survived 
WHERE Age = 0 OR Age = ' ';




-- Survival Rate Analysis
SELECT Sex, AVG(Survived) * 100 AS Survival_Rate
FROM Survived
GROUP BY Sex;

-- Class-wise survival rate
SELECT Pclass, COUNT(*) AS Total, SUM(Survived) AS Survived, 
       SUM(Survived)*100/COUNT(*) AS Survival_Rate
FROM survived
GROUP BY Pclass
ORDER BY Pclass


SELECT 
    CASE 
        WHEN Age < 12 THEN 'Child (0-11)'
        WHEN Age BETWEEN 12 AND 19 THEN 'Teen (12-19)'
        WHEN Age BETWEEN 20 AND 35 THEN 'Young Adult (20-35)'
        WHEN Age BETWEEN 36 AND 60 THEN 'Adult (36-60)'
        ELSE 'Senior (60+)'
    END AS Age_Group,
    COUNT(*) AS Total_Passengers,
    SUM(Survived) AS Survived_Passengers,
    ROUND((SUM(Survived) * 100.0) / COUNT(*), 2) AS Survival_Rate
FROM survived
WHERE Age IS NOT NULL
GROUP BY Age_Group
ORDER BY Age_Group;

SELECT Pclass, Sex, 
       COUNT(*) AS Total_Passengers, 
       SUM(Survived) AS Survived_Passengers, 
       ROUND((SUM(Survived) * 100.0) / COUNT(*), 2) AS Survival_Rate
FROM survived
GROUP BY Pclass, Sex
ORDER BY Pclass, Sex;

SELECT 
    CASE 
        WHEN (SibSp + Parch) = 0 THEN 'Solo Traveler'
        WHEN (SibSp + Parch) BETWEEN 1 AND 3 THEN 'Small Family'
        ELSE 'Large Family'
    END AS Family_Size,
    COUNT(*) AS Total_Passengers,
    SUM(Survived) AS Survived_Passengers,
    ROUND((SUM(Survived) * 100.0) / COUNT(*), 2) AS Survival_Rate
FROM survived
GROUP BY Family_Size
ORDER BY Survival_Rate DESC;

-- Survivors vs Non-survivors
SELECT Survived, AVG(Age) AS Average_Age
FROM survived
WHERE Age IS NOT NULL
GROUP BY Survived;


DELIMITER $$

CREATE PROCEDURE GetPassengers(IN age_limit INT)
BEGIN
    SELECT * FROM survived WHERE Age > age_limit;
END $$

DELIMITER ;
 
CALL GetPassengers(30);





CREATE VIEW TitanicSurvivors AS 
SELECT PassengerId, Name, Age, Sex 
FROM survived 
WHERE Survived = 1;

SELECT * FROM TitanicSurvivors;

CREATE VIEW survival_stats AS
SELECT Pclass, Sex, AVG(Survived) AS Avg_Survival_Rate
FROM survived
GROUP BY Pclass, Sex;

SELECT * FROM survival_stats;

