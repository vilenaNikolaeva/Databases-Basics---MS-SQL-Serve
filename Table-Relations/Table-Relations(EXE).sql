 USE [Table-Relations]
 --1.
CREATE TABLE Persons(
 PersonID INT NOT NULL,
 FirstName VARCHAR(50),
 Salary DECIMAL(15,2),
 PassportID INT
)

CREATE TABLE Passports(
 PassportsId INT NOT NULL,
 PassportNumber VARCHAR(50)
)

INSERT INTO Persons VALUES
(1,'Roberto',43300.00,102),
(2,'Tom',56100.00,103),
(3,'Yana',60200.00,101)

INSERT INTO Passports VALUES 
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')	

ALTER TABLE Persons
ADD CONSTRAINT PK_PersonID
PRIMARY KEY (PersonId) 

ALTER TABLE Passports
ADD CONSTRAINT PK_PassportsId
PRIMARY KEY (PassportsId) 

ALTER TABLE Persons
ADD CONSTRAINT FK_PersonsPasspord
FOREIGN KEY (PassportId) REFERENCES Passports(PassportsId) 

--2.
CREATE TABLE Models(
ModelID INT NOT NULL,
[Name] NVARCHAR(50),
ManufacturerID INT)

CREATE TABLE Manufacturers(
ManufacturerID INT NOT NULL,
[Name] NVARCHAR (50),
EstablishedON DATE)

INSERT INTO Models VALUES
(101,'X1',1),
(102,'i6',1),
(103,'Model S',2),
(104,'Model X',2),
(105,'Model 3',2),
(106,'Nova',3)

INSERT INTO Manufacturers VALUES
(1, 'BMW','07/03/1916'),
(2, 'Tesla','01/01/2003'),
(3, 'Lada','01/05/1966')

ALTER TABLE Models
ADD CONSTRAINT PK_ModelsId
PRIMARY KEY (ModelId)

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_ManufacturerId
PRIMARY KEY (ManufacturerId)

ALTER TABLE Models
ADD CONSTRAINT FK_ModelsManufacturers
FOREIGN KEY (ManufacturerId) REFERENCES Manufacturers(ManufacturerId)

--3.
CREATE TABLE Students (
StudentsID INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL)

CREATE TABLE Exams(
ExamID INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL)

CREATE TABLE StudentsExam(
StudentsID INT FOREIGN KEY REFERENCES Students(StudentsID),
ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
CONSTRAINT PK_CompositeStudentIdExamiD
PRIMARY KEY (StudentsID,ExamID))

INSERT INTO Students([Name]) VALUES
('Mila'),('Toni'),('Ron')

INSERT INTO  Exams(ExamID,[Name]) VALUES
(101,'SpringMVC'),
(102,'Neo4j'),
(103,'Oracle11g')

INSERT INTO StudentsExam(StudentsID,ExamID) VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103)

--4.
CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY,
[Name] NVARCHAR(50),
ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID))

INSERT INTO Teachers VALUES
(101,'John',NULL),
(102,'Maya',106),
(103,'Silvia',106),
(104,'Ted',105),
(105,'Mark',101),
(106,'Greta',101)

SELECT *FROM Teachers

--5.

CREATE TABLE Cities(
CityID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50))


CREATE TABLE Custumers(
CustumerID INT PRIMARY KEY,
[Name] VARCHAR(50),
Birthday DATE,
CityID INT FOREIGN KEY REFERENCES Cities(CityID))

CREATE TABLE Orders(
OrderID INT PRIMARY KEY NOT NULL,
CustumerID INT FOREIGN KEY REFERENCES Custumers(CustumerID))

CREATE TABLE ItemTypes(
ItemTypeID INT PRIMARY KEY,
[Name] VARCHAR(30))

CREATE TABLE Items(
ItemID INT PRIMARY KEY,
[Name] VARCHAR(30),
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID))

CREATE TABLE OrderItems(
OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
ItemID INT FOREIGN KEY REFERENCES Items(ItemID) NOT NULL,
CONSTRAINT PK_CompositeOrderIDItemID
PRIMARY KEY(OrderID,ItemID))

--6.
CREATE TABLE Majors(
MajorID INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL)

CREATE TABLE Studentss(
StudentID INT PRIMARY KEY ,
StudentNumber NVARCHAR(15) NOT NULL,
StudentName NVARCHAR(60) NOT NULL,
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID) NOT NULL)

CREATE TABLE Payments(
PaymentID INT PRIMARY KEY,
PaymentDate SMALLDATETIME NOT NULL,
PaymentAmount DECIMAL(10,2) NOT NULL,
StudentID INT FOREIGN KEY REFERENCES Studentss(StudentID) NOT NULL)

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY ,
SubjectName NVARCHAR(30) NOT NULL)

CREATE TABLE Agenda(
StudentID INT FOREIGN KEY REFERENCES Studentss(StudentID),
SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
CONSTRAINT PK_CompositeStudentIDSUbjectID 
PRIMARY KEY (StudentID,SubjectID))


--7. DIAGRAMS
--8. DIAGRAMS
--9.
USE Geography

SELECT (SELECT MountainRange
		FROM Mountains 
		WHERE MountainRange='Rila')
		AS [MountainRange],PeakName,Elevation
FROM Peaks
WHERE MountainId=(SELECT Id 
				  FROM Mountains 
				  WHERE MountainRange='Rila')
ORDER BY Elevation DESC

--SELECT MountainRange,PeakName,Elevation FROM Mountains
--JOIN Peaks ON Mountains.Id = Peaks.MountainId
--WHERE MountainRange='Rila'
--ORDER BY Elevation DESC





