USE LibraryManagement;
GO

-- STORED PROCEDURE: Xác thực đăng nhập sinh viên
CREATE PROCEDURE sp_LoginStudent
    @Username NVARCHAR(50),
    @Password NVARCHAR(100),
    @IsValid BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StoredPassword NVARCHAR(100);

    SELECT @StoredPassword = Password
    FROM LibraryUsers
    WHERE Username = @Username;

    IF @StoredPassword IS NULL
        SET @IsValid = 0;
    ELSE
        SET @IsValid = 1; -- Kiểm tra BCrypt thực hiện ở WinForms
END;
GO

-- STORED PROCEDURE: Đổi mật khẩu
CREATE PROCEDURE sp_ChangePassword
    @Username NVARCHAR(50),
    @OldPassword NVARCHAR(100),
    @NewPassword NVARCHAR(100),
    @NewPlainPassword NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StoredPassword NVARCHAR(100);
    DECLARE @Sql NVARCHAR(MAX);

    SELECT @StoredPassword = Password
    FROM LibraryUsers
    WHERE Username = @Username;

    IF @StoredPassword IS NULL
        THROW 50001, 'Tài khoản không tồn tại.', 1;

    -- Kiểm tra mật khẩu cũ (thực tế kiểm tra BCrypt ở WinForms)
    IF @StoredPassword != @OldPassword
        THROW 50002, 'Mật khẩu cũ không đúng.', 1;

    IF LEN(@NewPassword) < 6 OR LEN(@NewPlainPassword) < 6
        THROW 50003, 'Mật khẩu mới không hợp lệ.', 1;

    BEGIN TRY
        UPDATE LibraryUsers
        SET Password = @NewPassword
        WHERE Username = @Username;

        SET @Sql = N'ALTER LOGIN [' + QUOTENAME(@Username) + N'] WITH PASSWORD = @NewPlainPassword';
        EXEC sp_executesql @Sql, N'@NewPlainPassword NVARCHAR(100)', @NewPlainPassword;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

-- STORED PROCEDURE: Tạo tài khoản sinh viên
CREATE PROCEDURE sp_CreateStudentAccount
    @StudentCode NVARCHAR(20),
    @Username NVARCHAR(50),
    @Password NVARCHAR(100), -- Mật khẩu mã hóa
    @PlainPassword NVARCHAR(100) -- Mật khẩu gốc
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StudentID INT;
    DECLARE @Sql NVARCHAR(MAX);

    IF LEN(@StudentCode) = 0 OR LEN(@Username) < 3 OR LEN(@Password) < 6 OR LEN(@PlainPassword) < 6
        THROW 50001, 'Mã sinh viên, tên người dùng hoặc mật khẩu không hợp lệ.', 1;

    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentCode = @StudentCode)
        THROW 50002, 'Mã sinh viên không tồn tại.', 1;

    SET @StudentID = (SELECT StudentID FROM Students WHERE StudentCode = @StudentCode);

    IF EXISTS (SELECT 1 FROM LibraryUsers WHERE StudentID = @StudentID)
        THROW 50003, 'Sinh viên đã có tài khoản.', 1;

    IF EXISTS (SELECT 1 FROM LibraryUsers WHERE Username = @Username)
        THROW 50004, 'Tên người dùng đã được sử dụng.', 1;

    BEGIN TRY
        INSERT INTO LibraryUsers (StudentID, Username, Password, ExpirationDate)
        VALUES (@StudentID, @Username, @Password, DATEADD(YEAR, 4, GETDATE()));

        SET @Sql = N'CREATE LOGIN [' + QUOTENAME(@Username) + N'] WITH PASSWORD = @PlainPassword';
        EXEC sp_executesql @Sql, N'@PlainPassword NVARCHAR(100)', @PlainPassword;

        SET @Sql = N'CREATE USER [' + QUOTENAME(@Username) + N'] FOR LOGIN [' + QUOTENAME(@Username) + N']';
        EXEC sp_executesql @Sql;

        EXEC sp_addrolemember 'StudentRole', @Username;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

-- STORED PROCEDURE: Tạo tài khoản nhân viên
CREATE PROCEDURE sp_CreateEmployeeAccount
    @EmployeeID INT,
    @Username NVARCHAR(50),
    @Password NVARCHAR(100),
    @PlainPassword NVARCHAR(100),
    @IsManager BIT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Sql NVARCHAR(MAX);

    IF LEN(@Username) < 3 OR LEN(@Password) < 6 OR LEN(@PlainPassword) < 6
        THROW 50001, 'Tên người dùng hoặc mật khẩu không hợp lệ.', 1;

    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID AND IsActive = 1)
        THROW 50002, 'Nhân viên không tồn tại hoặc không hoạt động.', 1;

    IF EXISTS (SELECT 1 FROM EmployeeAccounts WHERE EmployeeID = @EmployeeID)
        THROW 50003, 'Nhân viên đã có tài khoản.', 1;

    IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Username)
        THROW 50004, 'Tên người dùng đã được sử dụng.', 1;

    BEGIN TRY
        INSERT INTO EmployeeAccounts (EmployeeID, Username, Password, IsManager)
        VALUES (@EmployeeID, @Username, @Password, @IsManager);

        SET @Sql = N'CREATE LOGIN [' + QUOTENAME(@Username) + N'] WITH PASSWORD = @PlainPassword';
        EXEC sp_executesql @Sql, N'@PlainPassword NVARCHAR(100)', @PlainPassword;

        SET @Sql = N'CREATE USER [' + QUOTENAME(@Username) + N'] FOR LOGIN [' + QUOTENAME(@Username) + N']';
        EXEC sp_executesql @Sql;

        IF @IsManager = 1
            EXEC sp_addrolemember 'ManagerRole', @Username;
        ELSE
            EXEC sp_addrolemember 'EmployeeRole', @Username;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

-- STORED PROCEDURE: Tìm kiếm sách
CREATE PROCEDURE sp_SearchBooks
    @SearchTerm NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        b.BookID,
        b.Title,
        p.PublisherName,
        a.AuthorName,
        g.GenreName,
        b.Quantity,
        b.AvailableQuantity
    FROM Books b
    LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID
    LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
    LEFT JOIN Genres g ON b.GenreID = g.GenreID
    WHERE b.BookID = TRY_CAST(@SearchTerm AS INT) OR b.Title LIKE '%' + @SearchTerm + '%';
END;
GO

-- STORED PROCEDURE: Tìm kiếm nhân viên
CREATE PROCEDURE sp_SearchEmployees
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        EmployeeID,
        FullName,
        DateOfBirth,
        Phone,
        Email,
        Address,
        HireDate,
        IsActive
    FROM Employees
    WHERE EmployeeID = TRY_CAST(@SearchTerm AS INT) OR FullName LIKE '%' + @SearchTerm + '%';
END;
GO

-- STORED PROCEDURE: Tìm kiếm sinh viên
CREATE PROCEDURE sp_SearchStudents
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        StudentID,
        StudentCode,
        FullName,
        DateOfBirth,
        Phone,
        Email,
        Address
    FROM Students
    WHERE StudentID = TRY_CAST(@SearchTerm AS INT) OR StudentCode = @SearchTerm;
END;
GO

-- STORED PROCEDURE: Thêm sách mới
CREATE PROCEDURE sp_AddBook
    @Title NVARCHAR(200),
    @PublisherName NVARCHAR(100),
    @AuthorName NVARCHAR(100),
    @GenreName NVARCHAR(50),
    @Quantity INT,
    @PublisherAddress NVARCHAR(200) = NULL,
    @PublisherPhone NVARCHAR(15) = NULL,
    @PublisherEmail NVARCHAR(100) = NULL,
    @AuthorDOB DATE = NULL,
    @AuthorNationality NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PublisherID INT, @AuthorID INT, @GenreID INT;

    IF NOT EXISTS (SELECT 1 FROM Publishers WHERE PublisherName = @PublisherName)
        INSERT INTO Publishers (PublisherName, Address, Phone, Email)
        VALUES (@PublisherName, @PublisherAddress, @PublisherPhone, @PublisherEmail);
    SET @PublisherID = (SELECT PublisherID FROM Publishers WHERE PublisherName = @PublisherName);

    IF NOT EXISTS (SELECT 1 FROM Authors WHERE AuthorName = @AuthorName)
        INSERT INTO Authors (AuthorName, DateOfBirth, Nationality)
        VALUES (@AuthorName, @AuthorDOB, @AuthorNationality);
    SET @AuthorID = (SELECT AuthorID FROM Authors WHERE AuthorName = @AuthorName);

    IF NOT EXISTS (SELECT 1 FROM Genres WHERE GenreName = @GenreName)
        INSERT INTO Genres (GenreName) VALUES (@GenreName);
    SET @GenreID = (SELECT GenreID FROM Genres WHERE GenreName = @GenreName);

    INSERT INTO Books (Title, PublisherID, AuthorID, GenreID, Quantity, AvailableQuantity)
    VALUES (@Title, @PublisherID, @AuthorID, @GenreID, @Quantity, @Quantity);
END;
GO

-- STORED PROCEDURE: Cập nhật sách
CREATE PROCEDURE sp_UpdateBook
    @BookID INT,
    @Title NVARCHAR(200),
    @PublisherName NVARCHAR(100),
    @AuthorName NVARCHAR(100),
    @GenreName NVARCHAR(50),
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PublisherID INT, @AuthorID INT, @GenreID INT;

    IF NOT EXISTS (SELECT 1 FROM Publishers WHERE PublisherName = @PublisherName)
        INSERT INTO Publishers (PublisherName) VALUES (@PublisherName);
    SET @PublisherID = (SELECT PublisherID FROM Publishers WHERE PublisherName = @PublisherName);

    IF NOT EXISTS (SELECT 1 FROM Authors WHERE AuthorName = @AuthorName)
        INSERT INTO Authors (AuthorName) VALUES (@AuthorName);
    SET @AuthorID = (SELECT AuthorID FROM Authors WHERE AuthorName = @AuthorName);

    IF NOT EXISTS (SELECT 1 FROM Genres WHERE GenreName = @GenreName)
        INSERT INTO Genres (GenreName) VALUES (@GenreName);
    SET @GenreID = (SELECT GenreID FROM Genres WHERE GenreName = @GenreName);

    UPDATE Books
    SET Title = @Title,
        PublisherID = @PublisherID,
        AuthorID = @AuthorID,
        GenreID = @GenreID,
        Quantity = @Quantity,
        AvailableQuantity = AvailableQuantity + (@Quantity - Quantity)
    WHERE BookID = @BookID;
END;
GO

-- STORED PROCEDURE: Xóa sách
CREATE PROCEDURE sp_DeleteBook
    @BookID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM BorrowingTransactions WHERE BookID = @BookID AND Status = 'Borrowed')
        THROW 50001, 'Không thể xóa sách đang được mượn.', 1;
    ELSE
        DELETE FROM Books WHERE BookID = @BookID;
END;
GO

-- STORED PROCEDURE: Cập nhật nhân viên
CREATE PROCEDURE sp_UpdateEmployee
    @EmployeeID INT,
    @FullName NVARCHAR(100),
    @DateOfBirth DATE,
    @Phone NVARCHAR(15),
    @Email NVARCHAR(100),
    @Address NVARCHAR(200),
    @HireDate DATE,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Employees
    SET FullName = @FullName,
        DateOfBirth = @DateOfBirth,
        Phone = @Phone,
        Email = @Email,
        Address = @Address,
        HireDate = @HireDate,
        IsActive = @IsActive
    WHERE EmployeeID = @EmployeeID;
END;
GO

-- STORED PROCEDURE: Xóa nhân viên
CREATE PROCEDURE sp_DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM BorrowingTransactions WHERE EmployeeID = @EmployeeID)
        THROW 50001, 'Không thể xóa nhân viên có giao dịch mượn sách.', 1;
    ELSE
        DELETE FROM Employees WHERE EmployeeID = @EmployeeID;
END;
GO

-- STORED PROCEDURE: Tạo giao dịch mượn sách
CREATE PROCEDURE sp_CreateBorrowingTransaction
    @BookID INT,
    @StudentCode NVARCHAR(20),
    @EmployeeID INT,
    @BorrowDate DATE,
    @DueDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserID INT;

    IF NOT EXISTS (SELECT 1 FROM Books WHERE BookID = @BookID AND AvailableQuantity > 0)
        THROW 50001, 'Sách không có sẵn để mượn.', 1;

    IF NOT EXISTS (SELECT 1 FROM LibraryUsers lu JOIN Students s ON lu.StudentID = s.StudentID WHERE s.StudentCode = @StudentCode)
        THROW 50002, 'Sinh viên không có tài khoản thư viện.', 1;

    SET @UserID = (SELECT lu.UserID FROM LibraryUsers lu JOIN Students s ON lu.StudentID = s.StudentID WHERE s.StudentCode = @StudentCode);

    INSERT INTO BorrowingTransactions (BookID, UserID, EmployeeID, BorrowDate, DueDate, Status)
    VALUES (@BookID, @UserID, @EmployeeID, @BorrowDate, @DueDate, 'Borrowed');

    UPDATE Books
    SET AvailableQuantity = AvailableQuantity - 1
    WHERE BookID = @BookID;
END;
GO

-- STORED PROCEDURE: Trả sách
CREATE PROCEDURE sp_ReturnBook
    @TransactionID INT,
    @ReturnDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @BookID INT;

    IF NOT EXISTS (SELECT 1 FROM BorrowingTransactions WHERE TransactionID = @TransactionID AND Status = 'Borrowed')
        THROW 50001, 'Giao dịch không hợp lệ hoặc sách đã được trả.', 1;

    SET @BookID = (SELECT BookID FROM BorrowingTransactions WHERE TransactionID = @TransactionID);

    UPDATE BorrowingTransactions
    SET Status = 'Returned',
        ReturnDate = @ReturnDate
    WHERE TransactionID = @TransactionID;

    UPDATE Books
    SET AvailableQuantity = AvailableQuantity + 1
    WHERE BookID = @BookID;
END;
GO

-- STORED PROCEDURE: Tính phạt trễ hạn
CREATE PROCEDURE sp_CalculateFine
    @TransactionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DueDate DATE, @ReturnDate DATE, @DaysLate INT;

    SELECT @DueDate = DueDate, @ReturnDate = ReturnDate
    FROM BorrowingTransactions
    WHERE TransactionID = @TransactionID;

    SET @DaysLate = DATEDIFF(DAY, @DueDate, ISNULL(@ReturnDate, GETDATE()));
    IF @DaysLate > 0
        UPDATE BorrowingTransactions
        SET FineAmount = @DaysLate * 1000 -- 1000 VNĐ/ngày
        WHERE TransactionID = @TransactionID;
END;
GO

-- STORED PROCEDURE: Thống kê mượn sách
CREATE PROCEDURE sp_GetBorrowingStatistics
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        b.BookID,
        b.Title,
        COUNT(bt.TransactionID) AS BorrowCount
    FROM BorrowingTransactions bt
    JOIN Books b ON bt.BookID = b.BookID
    WHERE bt.BorrowDate BETWEEN @StartDate AND @EndDate
    GROUP BY b.BookID, b.Title
    ORDER BY BorrowCount DESC;
END;
GO