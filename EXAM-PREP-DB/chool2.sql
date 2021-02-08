
USE [School]
USE School
-- CREATING TABLES
CREATE TABLE Subjects
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(20) NOT NULL,
Lessons INT NOT NULL,
)

CREATE TABLE Exams
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Date DATE,
SubjectId INT FOREIGN KEY REFERENCES Subjects(Id)
)

CREATE TABLE Students
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(20) NOT NULL,
MiddleName NVARCHAR(20),
LastName NVARCHAR(20) NOT NULL,
Age INT NOT NULL CHECK (Age > 0),
Address NVARCHAR(30),
Phone NVARCHAR(10)
)

CREATE TABLE Teachers
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Address NVARCHAR(20) NOT NULL,
Phone NVARCHAR(10),
SubjectId INT FOREIGN KEY REFERENCES Subjects(Id)
)
--Creating table STUDENTSSUBJECT
CREATE TABLE StudentsSubject(
Id INT PRIMARY KEY IDENTITY,
StudentsId INT  NOT NULL,
SubjectId INT NOT NULL,
Grade DECIMAL(16,2) CHECK (Grade>= 2 AND  Grade <=6) NOT NULL,
CONSTRAINT FK_StudentsSubjects_Students FOREIGN KEY (StudentsId) REFERENCES Students(Id),
CONSTRAINT FK_StudentsSubjects_Subjects FOREIGN KEY (SubjectId) REFERENCES Subjects(Id))


--Creating table STUDENTSEXAMS
CREATE TABLE StudentsExams(
StudentId INT NOT NULL,
ExamId INT NOT NULL,
Grade DECIMAL(16,2) CHECK (Grade >= 2 AND GRADE <=6) NOT NULL,
CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentId,ExamId),
CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentId) REFERENCES Students(Id),
CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamId) REFERENCES Exams(Id))


--Creating table StudentsTeacher
CREATE TABLE StudentsTeachers(
StudentsId INT NOT NULL,
TeacherId INT NOT NULL,
CONSTRAINT PK_StudentsTeachers PRIMARY KEY (StudentsId,TeacherId),
CONSTRAINT FK_StudentsTeachers_Students FOREIGN KEY (StudentsId) REFERENCES Students(Id),
CONSTRAINT FK_StudentsTeachers_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id))


--QUERYING

--Teen Students
 SELECT FirstName,LastName,Age FROM Students
 WHERE Age>=12 
 ORDER BY FirstName ,LastName

 --Cool Address
 SELECT 
	FirstName +' ' + MiddleName +' ' +LastName AS [Full Name],[Address] 
		FROM Students
WHERE Address LIKE ('%road%')
ORDER BY FirstName,LastName,[Address]

--42 Phones
SELECT FirstName,[Address],Phone FROM Students
WHERE Phone LIKE '42%' AND MiddleName IS NOT NULL
ORDER BY FirstName,Address,Phone

--Students Teachers
SELECT s.FirstName,s.LastName,COUNT(st.TeacherId) AS [TeachersCount]
FROM Students As s
JOIN StudentsTeachers AS st ON st.StudentsId=s.Id
GROUP BY s.FirstName,s.LastName

--Subjects with Students
SELECT 
	t.FirstName + ' ' + t.LastName				  AS [FullName],
	s.[Name] + '-' + CAST(s.Lessons AS NVARCHAR(5)) AS [Subjects],
	COUNT(st.StudentsId)						  AS [Students]
FROM Teachers AS t
	JOIN Subjects AS s ON s.Id = t.SubjectId
	JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
GROUP BY t.FirstName, t.LastName, s.[Name],s.Lessons
ORDER BY COUNT(st.StudentsId) DESC

--Students to GO
SELECT 
	FirstName+' '+ LastName AS [FullName]
	FROM Students AS s
FULL JOIN StudentsExams AS se ON se.StudentId=s.Id
	WHERE se.Grade IS NULL
ORDER BY [FullName]

--Busiest Teachers
SELECT TOP(10) t.FirstName,t.LastName ,COUNT(*) AS StudentsCount 
FROM Students AS s
	JOIN StudentsTeachers As st ON st.StudentsId=s.Id
	JOIN Teachers AS t ON t.Id=st.TeacherId
GROUP BY t.FirstName,t.LastName
ORDER BY StudentsCount DESC,FirstName,LastName

--Top Students
SELECT TOP (10) 
			FirstName,
			LastName ,
			FORMAT(AVG(Grade),'N2') AS Grade 
FROM Students AS s
JOIN StudentsExams AS st ON st.StudentId=s.Id
GROUP BY FirstName,LastName
ORDER BY  Grade DESC,FirstName,LastName

--Second Highest Grade
SELECT k.FirstName, k.LastName, k.Grade
FROM (
		SELECT FirstName,
			LastName,
			Grade, 
			ROW_NUMBER() OVER 
			(PARTITION BY FirstName, LastName ORDER BY Grade DESC) AS RowNumber
	    FROM Students AS s
		JOIN StudentsSubject AS ss ON ss.StudentsId = s.Id ) AS k
		WHERE k.RowNumber = 2
 ORDER BY FirstName, LastName

--TOP STUDENT PER TEACHER
SELECT  b.[Teacher Full Name],
		b.SubjectName ,
		b.[Student Full Name],
		FORMAT(b.TopGrade, 'N2')	    AS Grade
FROM (
	 SELECT 
	   a.[Teacher Full Name],
	   a.SubjectName,
	   a.[Student Full Name],
	   a.AverageGrade					AS TopGrade,
	   ROW_NUMBER() OVER (PARTITION BY a.[Teacher Full Name] ORDER BY a.AverageGrade DESC) AS RowNumber
	 FROM (
		 SELECT t.FirstName + ' ' + t.LastName			 AS [Teacher Full Name],
  			 s.FirstName + ' ' + s.LastName				 AS [Student Full Name],
  			 AVG(ss.Grade)								 AS AverageGrade,
  			 su.Name									 AS SubjectName
		 FROM Teachers AS t 
		 JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
		 JOIN Students AS s ON s.Id = st.StudentsId
		 JOIN StudentsSubject AS ss ON ss.StudentsId = s.Id
		 JOIN Subjects AS su ON su.Id = ss.SubjectId AND su.Id = t.SubjectId
		GROUP BY t.FirstName, t.LastName, s.FirstName, s.LastName, su.Name
	) AS a
) AS b
WHERE b.RowNumber = 1 
ORDER BY b.SubjectName,b.[Teacher Full Name], TopGrade DESC

--GRADE PER SUBJECT
SELECT s.[Name],
	   AVG(ss.Grade) AS AverageGrade
FROM Subjects AS s
	JOIN StudentsSubject AS ss ON s.Id=ss.SubjectId
	GROUP BY s.Name,s.Id
	ORDER BY s.Id

--Exams information
SELECT k.Quarter,
	   k.SubjectName,
	   COUNT(k.StudentId) AS [StudentsCount]
FROM (
		SELECT s.[Name]	AS [SubjectName],
			   se.StudentId,
				CASE	
					WHEN DATEPART (MONTH, DATE) BETWEEN 1 AND 3 THEN 'Q1'
					WHEN DATEPART(MONTH, DATE) BETWEEN 4 AND 6 THEN 'Q2'
					WHEN DATEPART(MONTH, DATE) BETWEEN 7 AND 9 THEN 'Q3'
					WHEN DATEPART(MONTH, DATE) BETWEEN 10 AND 12 THEN 'Q4'
					WHEN DATE IS NULL THEN 'TBA'
					END AS [Quarter]
		FROM Exams AS e
			JOIN Subjects AS s ON s.Id= e.SubjectId
			JOIN StudentsExams AS se ON se.ExamId =e.Id
			WHERE se.Grade >=4
	) AS k
GROUP BY k.Quarter,k.SubjectName
ORDER BY k.Quarter

--Exam Grades
CREATE FUNCTION  udf_ExamGradesToUpdate (@studentId INT, @grade DECIMAL(16,2))
RETURNS NVARCHAR(MAX) 
	AS
		BEGIN
		DECLARE @studentExist INT = (
		SELECT TOP (1) studentId FROM StudentsExams 
		WHERE StudentId=@studentId);
			IF 
				@studentExist IS NULL
				BEGIN
					RETURN ('The student with provided id is not exist in the school!')
			END
			IF @grade>6.00
				BEGIN	
					RETURN ('Grade cannot be above 6.00')
			END
	DECLARE @studentName NVARCHAR(50) = (
		SELECT TOP (1) FirstName FROM Students WHERE Id=@studentId);
	DECLARE @topGrade DECIMAL(16,2) = @grade +0.50;
	DECLARE @count INT=(
		SELECT COUNT(Grade) FROM StudentsExams
		WHERE StudentId=@studentId AND Grade>=@grade AND Grade<=@topGrade)
	RETURN ('You have to update'+CAST(@count AS NVARCHAR(10))+'grades for the student'+
	@studentName)
END
GO

SELECT dbo.udf_ExamGradesToUpdate (3, 3.50)

--Exclude from school
CREATE PROC usp_ExcludeFromSchool (@studentId INT)
AS	
	DECLARE @student INT = (
	SELECT TOP(1) Id FROM Students
	WHERE id=@studentId);
		IF @student IS NULL
			BEGIN
				RAISERROR ('This school has no student with the provided id!',16,2)
				RETURN
		END
DELETE FROM StudentsExams		WHERE StudentId=5
DELETE FROM StudentsSubject		WHERE StudentsId=5
DELETE FROM StudentsTeachers	WHERE StudentsId=5
DELETE FROM Students			WHERE Id =5

EXEC usp_ExcludeFromSchool 5
SELECT COUNT(*)FROM Students

GO
--Deleted Student
CREATE TABLE ExcludedStudents(
StudentId INT,
StudentName VARCHAR(30))

GO
CREATE TRIGGER tr_StudentsDelete ON Students
INSTEAD OF DELETE 
	AS
		INSERT INTO ExcludedStudents(StudentId,StudentName)
		SELECT Id,FirstName+' '+LastName FROM deleted

DELETE FROM StudentsExams	 WHERE StudentId=1
DELETE FROM StudentsSubject  WHERE StudentsId=1
DELETE FROM StudentsTeachers WHERE StudentsId=1
DELETE FROM Students		 WHERE Id=1

SELECT * FROM ExcludedStudents


---END
