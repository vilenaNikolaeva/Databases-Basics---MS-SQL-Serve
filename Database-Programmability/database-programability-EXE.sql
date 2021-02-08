USE SoftUni

--1.
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS 
SELECT FirstName,LastName
FROM Employees
WHERE Salary>35000

EXEC dbo.usp_GetEmployeesSalaryAbove35000

--2.
CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber(@value DECIMAL(18,4))
AS 
	SELECT FirstName,LastName
	FROM Employees
	Where Salary>= @value

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 3500;

--3.
CREATE PROC usp_GetTownsStartingWith (@result NVARCHAR(50))
AS 
	SELECT Towns.Name
	FROM Towns
	WHERE LEFT ([Name],LEN(@result))=@result
	
EXEC dbo.usp_GetTownsStartingWith 'b';

--4.
CREATE PROC usp_GetEmployeeFromTown (@townName NVARCHAR(50))
AS
	SELECT FirstName AS FirstName ,LastName AS LastName
	FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID=a.AddressID
	JOIN Towns AS t ON t.TownID=a.TownID
	WHERE t.Name=@townName

EXEC dbo.usp_GetEmployeeFromTown 'Sofia';

--5.
CREATE FUNCTION usp_GetSalaryLevel (@salary DECIMAL(18,4))
RETURNS VARCHAR (10)
AS 
	BEGIN
	DECLARE @salaryLevel VARCHAR(10)
	IF (@salary<30000)
	BEGIN
		SET @salaryLevel='Low'
	END
	ELSE IF (@salary>=3000 AND @salary<=5000)
	BEGIN
		SET @salaryLevel='Avarage'
    END
	ELSE
	BEGIN
		SET @salaryLevel='High'
    END
RETURN @salaryLevel
END

--6.
CREATE PROCEDURE usp_EmployeesBySalaryLevel (@salaryLevel VARCHAR(10))
AS
	SELECT FirstName,LastName
FROM Employees
	WHERE dbo.usp_GetSalaryLevel(Salary)=@salaryLevel

--7.
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50)) 
RETURNS BIT
AS
BEGIN
DECLARE @currentIndex int = 1;

WHILE(@currentIndex <= LEN(@word))
	BEGIN

	DECLARE @currentLetter varchar(1) = SUBSTRING(@word, @currentIndex, 1);

	IF(CHARINDEX(@currentLetter, @setOfLetters)) = 0
	BEGIN
	RETURN 0;
	END

	SET @currentIndex += 1;
	END

RETURN 1;
END

--8.
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS
	ALTER TABLE Departments
	ALTER COLUMN ManegerID INT NULL

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN
	(
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID=@departmentId
	)

	UPDATE Employees
	SET ManagerID=NULL
	WHERE ManagerID IN
	(
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID=@departmentId
	)

	UPDATE Departments
	SET ManagerID=NULL
	WHERE ManagerID IN
	(
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID=@departmentId
	)

	DELETE FROM Departments
	WHERE DepartmentID=@departmentId

SELECT COUNT(*) AS [Employee Count]
FROM Employees As e
JOIN Departments AS d
	ON d.DepartmentID=e.DepartmentID
WHERE e.DepartmentID=@departmentId


--09.
USE Bank

CREATE PROC usp_GetHoldersFullName
AS
	SELECT FirstName+' '+LastName 
	AS [Full Name]
	FROM AccountHolders
	

--10.
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@totalMoney DECIMAL(16,2))
AS
	SELECT ah.FirstName as [First Name],
		   ah.LastName as [LastName]
    FROM AccountHolders AS ah
	JOIN Accountss As a
	ON ah.Id=a.AccountHolderId
GROUP BY ah.FirstName,ah.LastName
HAVING SUM(a.Balance)>=@totalMoney

--11.
CREATE FUNCTION ufn_CalculateFutureValue
(@sum MONEY ,@yearlyInterestRate FLOAT,@numYears INT)
RETURNS  MONEY
	AS
		BEGIN
			RETURN @sum * POWER(1+ @yearlyInterestRate,@numYears)
        END
SELECT dbo.ufn_CalculateFutureValue (1000,0.1,5)

--12.
CREATE PROC usp_CalculateFutureValueForAccount (@accountId INT,@interestRate FLOAT)
AS
	BEGIN
		DECLARE @years INT=5;
	SELECT
		a.Id		AS [Account ID],
		ah.FirstName AS[First Name],
		ah.LastName  AS[Last Name],
		a.Balance	 AS[Current Balance],
		dbo.ufn_CalculateFutureValue(a.Balance,@interestRate,@years) AS [Balance in 5 years]
    FROM AccountHolders As ah
	JOIN Accountss AS a
	ON ah.id=a.AccountHolderId
	WHERE a.Id=@AccountId
	END

EXEC usp_CalculateFutureValueForAccount 1,0.10

--13.
USE Diablo

CREATE FUNCTION  ufn_CashUsersGames ( @gameName VARCHAR(MAX) )
RETURNS  @output TABLE (sumcash DECIMAL (18,2))
AS	
BEGIN 
	INSERT INTO @output SELECT( SELECT SUM(Cash)AS [SumCash] FROM (SELECT * ,ROW_NUMBER() OVER (ORDER BY Cash DESC) AS [RowNum] 
	FROM UsersGames
	WHERE GameId IN (
					SELECT Id FROM Games
					WHERE [Name]=@gameName
					))
	AS [RowNumTable]
	WHERE [RowNum] %2 <>0)
	RETURN;
END

SELECT * FROM dbo.ufn_CashUsersGames('Love in a mist')

--14.
USE Bank

CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccointId INT,
OldSum MONEY,
NewSum MONEY)

CREATE TRIGGER InsertNewEntryIntoLogs On Accountss AFTER UPDATE
AS 
	INSERT INTO Logs
		VALUES( 
			(SELECT Id FROM inserted),
			(SELECT Balance FROM deleted),
			(SELECT Balance FROM inserted)
			  )


--15.
CREATE TABLE NotificationEmails (
Id INT PRIMARY KEY,
Recipient NVARCHAR(50),
[Subject] NVARCHAR(50),
Body NvARCHAR(500))

CREATE TRIGGER CreateNewNotificationEmail
  ON Logs
  AFTER INSERT
AS
  BEGIN
    INSERT INTO NotificationEmails
    VALUES (
      (SELECT AccountId
       FROM inserted),
      (CONCAT('Balance change for account: ', (SELECT AccountId
                                               FROM inserted))),
      (CONCAT('On ', (SELECT GETDATE()
                      FROM inserted), 'your balance was changed from ', (SELECT OldSum
                                                                         FROM inserted), 'to ', (SELECT NewSum
                                                                                                 FROM inserted), '.'))
    )
  END

 --16.
 --17.
 --18.
 --19.
 --20.
 DECLARE @gameName NVARCHAR(30)='Safflower'
 DECLARE @userName NVARCHAR(30)='Stamat'

 DECLARE @userGameId INT= (
		SELECT ug.Id FROM UsersGames AS ug
			JOIN Users AS u ON ug.UserId=u.Id
			JOIN Games AS g ON ug.GameId=g.Id
			WHERE u.Username=@userName AND g.Name=@gameName)

DECLARE @userGameLavel INT =(SELECT [Level] FROM UsersGames
							WHERE Id=@userGameId)

DECLARE @itemsCost MONEY,
		@availableCash MONEY,	
		@minLevel INT,
		@maxLevel INT

SET @minLevel=11
SET @maxLevel=12
SET @availableCash =(SELECT Cash FROM UsersGames
					WHERE Id=@userGameId)
SET @itemsCost=(SELECT SUM(Price) FROM Items
				WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

IF (@availableCash>=@itemsCost AND @userGameLavel>=@maxLevel)
BEGIN 
	BEGIN TRANSACTION UPDATE UsersGames
	SET Cash-=@itemsCost
	WHERE id=@userGameId
		IF(@@ROWCOUNT<>1)
			BEGIN ROLLBACK
			 RAISERROR ('Could not make payment',16,1)
			END
		  ELSE
			BEGIN
			  INSERT INTO UserGameItems(ItemId,UserGameId)
			   (SELECT id,@userGameId FROM Items
			    WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

         IF((SELECT COUNT (*)
			FROM Items
			WHERE MinLevel BETWEEN @minLevel AND @maxLevel)<>@@ROWCOUNT)
		   BEGIN
		   ROLLBACK;
		    RAISERROR ('Could not bue items',16,1)
           END
		   ELSE COMMIT;
		END
	END
SET @minLevel = 19
SET @maxLevel = 21
SET @availableCash = (SELECT Cash
                      FROM UsersGames
                      WHERE Id = @userGameId)
SET @itemsCost = (SELECT SUM(Price)
                  FROM Items
                  WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

IF (@availableCash >= @itemsCost AND @userGameLavel >= @maxLevel)

  BEGIN
    BEGIN TRANSACTION
    UPDATE UsersGames
    SET Cash -= @itemsCost
    WHERE Id = @userGameId

    IF (@@ROWCOUNT <> 1)
      BEGIN
        ROLLBACK
        RAISERROR ('Could not make payment', 16, 1)
      END
    ELSE
      BEGIN
        INSERT INTO UserGameItems (ItemId, UserGameId)
          (SELECT
             Id,
             @userGameId
           FROM Items
           WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

        IF ((SELECT COUNT(*)
             FROM Items
             WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
          BEGIN
            ROLLBACK
            RAISERROR ('Could not buy items', 16, 1)
          END
        ELSE COMMIT;
      END
  END

SELECT i.Name AS [Item Name]
FROM UserGameItems AS ugi
  JOIN Items AS i
    ON i.Id = ugi.ItemId
  JOIN UsersGames AS ug
    ON ug.Id = ugi.UserGameId
  JOIN Games AS g
    ON g.Id = ug.GameId
WHERE g.Name = @gameName
ORDER BY [Item Name]


--21.
CREATE PROC usp_AssignProject (@employeeID INT,
							   @projectID INT)
AS
	BEGIN
	BEGIN TRANSACTION
	INSERT INTO EmployeesProjects 
	VALUES (@employeeID,@projectID)
		IF (SELECT COUNT(@projectID)
			FROM EmployeesProjects
			WHERE EmployeeID=@employeeID) > 3
		BEGIN
			RAISERROR ('The employee has to many projects!',16,1)
			ROLLBACK
			RETURN
		END
	COMMIT
END

EXEC dbo.usp_AssignProject 16,1

--22.
CREATE TABLE Delete_Employees(
EmployeeID INT PRIMARY KEY,
FirstName VARCHAR(30),
LastName VARCHAR(30),
MiddleName VARCHAR(30),
JobTitle VARCHAR (50),
DepartmentID INT,
SALARY MONEY)

CREATE TRIGGER DeleteEmployees ON Employees AFTER DELETE
AS
	BEGIN
		INSERT INTO Delete_Employees
			SELECT
				   FirstName,
				   LastName,
				   MiddleName,
				   JobTitle,
				   DepartmentID,
				   Salary
		    FROM deleted
     END
