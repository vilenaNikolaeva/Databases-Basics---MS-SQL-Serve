--Creating table SUBJECT
CREATE TABLE [Subjects](
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(20) NOT NULL,
Lessons INT NOT NULL)


--Creating table Exams
CREATE TABLE Exams(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Data] DATETIME,
SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL)

--Creating table STUDENTS
CREATE TABLE Students(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(30) NOT NULL,
MiddleName VARCHAR(25),
LastName VARCHAR(30) NOT NULL,
Age INT CHECK ( Age>=5 AND Age <=100),
[Address]  VARCHAR(50),
Phone VARCHAR(10))

--Creating table Teachers
CREATE TABLE Teachers(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
[Address] VARCHAR(20) NOT NULL,
Phone VARCHAR(10),
SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL)


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


--INSERT INTO TABLES
