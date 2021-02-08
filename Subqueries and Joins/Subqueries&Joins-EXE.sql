--1.

SELECT TOP (5) EmployeeID,JobTitle,e.AddressID,AddressText FROM Employees AS e
JOIN Addresses AS a ON e.AddressID=a.AddressID
ORDER BY AddressID

--2.
SELECT TOP(50) FirstName,LastName,t.[Name],[AddressText] FROM Employees AS e
JOIN Addresses AS a ON a.AddressID=e.AddressID
JOIN Towns AS t ON t.TownID=a.TownID
ORDER BY FirstName ASC,LastName

--3.
SELECT EmployeeID,FirstName,LastName,d.[Name] FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
WHERE d.Name='Sales'
ORDER BY EmployeeID

--4
SELECT TOP (5) EmployeeID,FirstName,Salary,d.[Name] FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
WHERE e.Salary>15000
ORDER BY d.DepartmentID 

--5.
SELECT TOP(3) e.EmployeeID,FirstName FROM Employees As e
LEFT JOIN EmployeesProjects AS ep ON ep.EmployeeID=e.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID

--6.
SELECT FirstName,LastName,HireDate,d.[Name] FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
WHERE HireDate > '01.01.1999' AND d.Name IN('Sales','Finance')
ORDER BY HireDate

--7.
SELECT e.EmployeeID,FirstName,p.[Name] FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID=e.EmployeeID
JOIN Projects AS p ON p.ProjectID=ep.ProjectID
WHERE p.StartDate> '08.13.2002' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

--8.
SELECT e.EmployeeID,FirstName,
	CASE 
		WHEN  p.StartDate>'01.01.2005' THEN NULL
		ELSE p.Name
	END
FROM Employees AS e
JOIN EmployeesProjects AS ep ON  e.EmployeeID=ep.EmployeeID
JOIN Projects AS p ON p.ProjectID=ep.ProjectID
WHERE e.EmployeeID=24

--9.
SELECT e.EmployeeID,e.FirstName,e.ManagerID,m.FirstName FROM Employees AS e
JOIN Employees AS m ON e.ManagerID=m.EmployeeID
WHERE e.ManagerID IN (3,7)
ORDER BY e.EmployeeID


--10.
SELECT TOP(50) e.EmployeeID,
		CONCAT(e.FirstName,' ', e.LastName) AS EmployeeName,
		CONCAT (m.FirstName,' ',m.LastName) AS ManegerName,
		d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID=m.EmployeeID
JOIN Departments AS d ON d.DepartmentID=e.DepartmentID
ORDER BY e.EmployeeID

--11.
SELECT TOP (1) (Select AVG(Salary)) AS [MinAVGSalary] FROM Employees
GROUP BY DepartmentID
ORDER BY MinAVGSalary

--12.
USE Geography

SELECT mc.CountryCode,m.MountainRange,p.PeakName,Elevation FROM Mountains AS m
JOIN Peaks AS p ON m.Id=p.MountainId
JOIN MountainsCountries AS mc ON m.Id=mc.MountainId
WHERE p.Elevation> 2835
AND mc.CountryCode='BG'
ORDER BY Elevation DESC

--13.
SELECT mc.CountryCode,m.MountainRange FROM MountainsCountries As mc
JOIN Mountains AS m ON m.Id=mc.MountainId
WHERE mc.CountryCode IN ('US','RU' ,'BG')
ORDER BY mc.CountryCode

--14.
SELECT TOP (5) c.CountryName,r.RiverName FROM Countries AS c
LEFT JOIN CountriesRivers As cr ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId=r.Id
WHERE c.ContinentCode='AF'
ORDER BY c.CountryName

--15.
SELECT r.ContinentCode,
	   r.CurrencyCode,
	   r.CurrencyUsage
FROM (
SELECT c.ContinentCode,
	   c.CurrencyCode,
	   COUNT(c.CurrencyCode) AS [CurrencyUsage],
	   DENSE_RANK() OVER (PARTITION BY c.ContinentCode 
	   ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
FROM Countries AS c

GROUP BY c.ContinentCode, c.CurrencyCode) AS r
WHERE r.rank = 1 and r.CurrencyUsage > 1

--16.
SELECT COUNT(c.CountryCode) AS [CountryCode] FROM Countries AS c
LEFT JOIN MountainsCountries AS m ON c.CountryCode=m.CountryCode
WHERE m.MountainId IS NULL

--17.
SELECT TOP (5) c.CountryName,
MAX(p.Elevation) AS [HighestPeakElevation],
MAX(r.Length) AS [LongestRIverLenght]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode=mc.CountryCode
LEFT JOIN Peaks AS p ON p.MountainId=mc.MountainId
LEFT JOIN CountriesRivers AS cr ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId=r.Id
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC,LongestRIverLenght DESC,c.CountryName

--18.
SELECT TOP (5) WITH TIES c.CountryName,
ISNULL(p.PeakName, '(no highest peak)') AS [HighestPeakName],
ISNULL(MAX(p.Elevation), 0) AS [HighestPeakElevation],
ISNULL(m.MountainRange, '(no mountain)') AS [Mountain]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON m.Id = p.MountainId
GROUP BY c.CountryName, p.PeakName, m.MountainRange
ORDER BY c.CountryName, p.PeakName
--nope