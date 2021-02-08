USE SoftUni
--1.
SELECT FirstName,LastName FROM Employees
 WHERE FirstName LIKE ('SA%')

 --2.
 SELECT FirstName,LastName FROM Employees
 WHERE LastName LIKE ('%ei%')
 
 --3.
 SELECT FirstName FROM Employees
 WHERE(DepartmentID=3 OR DepartmentID=10)
 AND DATEPART(YEAR,HireDate) BETWEEN 1995 and 2005

 --4.
 SELECT FirstName,LastName FROM Employees
 WHERE JobTitle NOT LIKE '%Engineer%'

 --5.
 SELECT [Name] FROM Towns
 WHERE LEN([Name])=5 OR LEN([Name])=6
 ORDER BY [Name] ASC

 --6.
 SELECT TownID,[Name] FROM Towns
WHERE LEFT ([Name],1)='M'
	OR LEFT([Name],1)='K'
	OR LEFT([Name],1)='B'
	OR LEFT([Name],1)='E'
ORDER BY [Name] ASC

--7.
 SELECT TownID,[Name] FROM Towns
WHERE LEFT ([Name],1) NOT LIKE '[RBD]'
ORDER BY [Name] ASC

--8.
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE DATEPART(Year,HireDate)>2000

SELECT *FROM V_EmployeesHiredAfter2000

--9.
SELECT FirstName,LastName FROM Employees
WHERE LEN([LastName])=5

--10.
--SELECT *FROM (
--       SELECT EmployeeID,
--              FirstName,
--              LastName,
--              Salary,
--              DENSE_RANK() over (partition by Salary ORDER BY EmployeeID) AS Rank
--       FROM Employees
--       WHERE Salary >= 10000 AND  Salary <= 50000) AS MyTable
--ORDER BY Salary DESC


----11.
--SELECT *FROM(
--	    SELECT EmployeeID,
--              FirstName,
--              LastName,
--              Salary,
--              DENSE_RANK() over (partition by Salary ORDER BY EmployeeID) AS Rank
--       FROM Employees
--       WHERE Salary BETWEEN 10000 AND 50000) AS MyTable
--WHERE RANK=2
--ORDER BY Salary DESC

--12.
USE Geography
SELECT CountryName,ISOCode FROM Countries
WHERE CountryName LIKE'%a%a%a%'
ORDER BY IsoCode

--13.
SELECT Peaks.PeakName,Rivers.RiverName ,
LOWER(
CONCAT(LEFT(Peaks.PeakName, LEN(Peaks.PeakName)-1), Rivers.RiverName))
AS MIX
FROM Peaks,Rivers
WHERE RIGHT(PeakName,1)=LEFT(RiverName,1)
ORDER BY MIX

--14.
USE Diablo
SELECT TOP(50) [Name],
FORMAT (CAST(Start as DATE), 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE DATEPART(Year,Start) BETWEEN 2011 AND 2012
ORDER BY Start,[Name];

--15.
SELECT UserName,
RIGHT(Email,LEN(Email)-CHARINDEX('@',Email)) AS [Email Provider]
FROM Users
ORDER BY [Email Provider],Username;

--16.
SELECT UserName, 
	IpAddress AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username

--17.
SELECT [Name] As [Game],
CASE
	WHEN DATEPART(HOUR,Start) BETWEEN 0 AND 11
	THEN 'Morning'
	WHEN DATEPART(HOUR,Start) BETWEEN 12 AND 17
	THEN 'Afternoon'
	WHEN DATEPART(HOUR,Start) BETWEEN 18 AND 23
	THEN 'Evening'
	ELSE 'N/A'
	END AS [Part of the day],
CASE
	WHEN Duration<=3
	THEN 'Extra Short'
	WHEN Duration BETWEEN 4 AND 6
	THEN 'Short'
	WHEN Duration >6
	THEN 'Long'
	WHEN Duration IS NULL
	THEN 'Extra Long'
	ELSE 'Error-must be unreachable case'
	END AS [Duration]

FROM Games
ORDER BY[Name],[Duration],[Part of the day];

