USE HR;

-- ##### - Q1 - #####
SELECT FirstName,LastName,DepartmentId,Salary, RANK() OVER (PARTITION BY DepartmentId 
ORDER BY Salary DESC) AS empRank, DENSE_RANK() OVER (PARTITION BY DepartmentId 
ORDER BY Salary DESC) AS empDenseRank
FROM Employees;

-- ##### - Q2 - #####
CREATE TABLE trainSchedule(
TrainId INT,
Station VARCHAR(50),
ArrivalTime TIME)

-- ##### - Q3 - #####
INSERT INTO trainSchedule (TrainId,Station,ArrivalTime) 
VALUES(110,'Dallas','10:00:00'),
(110,'Frisco','10:54:00'),
(110,'Irving','11:02:00'),
(110,'FortWorth','12:35:00'),
(120,'Dallas','11:00:00'),
(120,'Irving','12:49:00'),
(120,'FortWorth','13:30:00')

-- ##### - Q4 - #####
SELECT TrainId,Station,ArrivalTime as station_time, 
DATEDIFF(MINUTE, ArrivalTime, LEAD(ArrivalTime) OVER(PARTITION BY TrainId ORDER BY ArrivalTime)) AS  time_to_next_station
FROM trainSchedule;

-- ##### - Q5 - #####
-- Ans) A. LAG

-- ##### - Q6 - #####
-- Ans) A. LAG

-- ##### - Q7 - #####
-- Ans) B. OVER

-- ##### - Q8 - #####
-- Ans) D. All the above

-- ##### - Q9 - #####
-- Ans) C. No