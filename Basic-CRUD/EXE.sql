--2.
USE Softuni
SELECT * FROM Departments

--3.
SELECT [Name] FROM Departments

--4.
 SELECT FirstName,LastName,Salary FROM Employees
 
 --5.
 SELECT FirstName,MiddleName,LastName FROM Employees

 --6.
 SELECT FirstName +'.'+ LastName + '@softuni.bg'
 AS [Full Email Addres]
 FROM Employees

 --7.
 SELECT DISTINCT [Salary] FROM Employees

 --8.
 SELECT * FROM Employees
 WHERE JobTitle='Sales Representative'

 --9.
 SELECT FirstName,LastName,JobTitle FROM Employees
 WHERE Salary >=20000 AND Salary<=30000
 
 --10.
 SELECT FirstName+ MiddleName+LastName 
 AS FullName
 FROM Employees
 WHERE Salary IN (25000, 14000, 12500, 23600 )

 --11.
 SELECT FirstName,LastName
 FROM Employees
 WHERE ManagerID IS NULL

 --12.
 SELECT FirstName,LastName,Salary FROM Employees
 WHERE Salary >=50000 
 ORDER BY Salary  DESC

 --13.
 SELECT TOP(5)FirstName,LastName 
 FROM Employees
 ORDER BY Salary DESC

 --14.
 SELECT FirstName,LastName FROM Employees
 WHERE DepartmentID !=4

 --15.
 SELECT *FROM Employees
 ORDER BY Salary  DESC,
  FirstName ASC,
  LastName DESC,
  MiddleName ASC
 
 --16.
 CREATE VIEW V_EmployeeSalaries 
 AS
 SELECT Firstname,LastName,Salary
 FROM Employees

 SELECT * FROM V_EmployeeSalaries

 --17.
CREATE VIEW V_EmployeeNameJobTitle
 AS
 SELECT FirstName +' '+ ISNULL(MiddleName,'')+ LastName 
 AS [Full Name], JobTitle
 AS [Job Title]
 from Employees
 
 
 SELECT * FROM V_EmployeeNameJobTitle

 --18.
 SELECT JobTitle FROM Employees
 ORDER BY JobTitle  ASC

 --19.
 SELECT Top(10) [ProjectID],[Name],[Description],StartDate,EndDate 
     FROM Projects
 ORDER BY [StartDate] ASC,
		  [Name] DESC

--20.
SELECT TOP (7) FirstName,LastName,HireDate
FROM Employees
ORDER BY HireDate DESC

--21.
UPdATE Employees
SET Salary=Salary*0.12
WHERE DepartmentID IN(SELECT DepartmentID FROM Departments
WHERE [Name] IN ('Engineering','Tool Design','Marketing','Information Services'))

SELECT Salary FROM Employees

--22.
USE  Geography
SELECT PeakName FROM Peaks 
ORDER BY PeakName ASC
		 
--23.
Select TOP(30) CountryName,[Population] FROM Countries
WHERE ContinentCode=(SELECT ContinentCode FROM Continents
WHERE ContinentName='Europe')
ORDER BY [Population] DESC,CountryName 

--24.
SELECT CountryName,CountryCode,
CASE
	WHEN CurrencyCode ='EUR' THEN 'Euro'
	ELSE 'Not Euro'
END AS CurrencyCode
FROM Countries
ORDER BY CountryName ASC

--25.
USE Diablo
SELECT [Name] FROM Characters
ORDER BY [Name] ASC





