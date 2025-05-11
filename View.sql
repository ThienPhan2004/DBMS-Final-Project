USE LibraryManagement;
GO

-- VIEW: Danh mục sách
-- Mục đích: Hiển thị danh sách sách để Sinh viên, Nhân viên, Quản lý xem và tìm kiếm
CREATE VIEW BookCatalog
AS
SELECT 
    b.BookID,
    b.Title AS BookTitle,
    p.PublisherName,
    a.AuthorName,
    g.GenreName,
    b.Quantity AS TotalQuantity,
    b.AvailableQuantity
FROM Books b
LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Genres g ON b.GenreID = g.GenreID;
GO

-- VIEW: Giao dịch mượn sách đang hoạt động
-- Mục đích: Hiển thị các giao dịch trạng thái 'Borrowed' cho Nhân viên và Quản lý
CREATE VIEW ActiveBorrowingTransactions
AS
SELECT 
    bt.TransactionID,
    b.BookID,
    b.Title AS BookTitle,
    s.StudentCode,
    s.FullName AS StudentName,
    e.FullName AS EmployeeName,
    bt.BorrowDate,
    bt.DueDate,
    bt.FineAmount,
    bt.Status
FROM BorrowingTransactions bt
JOIN Books b ON bt.BookID = b.BookID
JOIN LibraryUsers lu ON bt.UserID = lu.UserID
JOIN Students s ON lu.StudentID = s.StudentID
JOIN Employees e ON bt.EmployeeID = e.EmployeeID
WHERE bt.Status = 'Borrowed';
GO

-- VIEW: Tất cả giao dịch mượn sách
-- Mục đích: Hiển thị toàn bộ lịch sử mượn sách cho Quản lý
CREATE VIEW AllBorrowingTransactions
AS
SELECT 
    bt.TransactionID,
    b.BookID,
    b.Title AS BookTitle,
    s.StudentCode,
    s.FullName AS StudentName,
    e.FullName AS EmployeeName,
    bt.BorrowDate,
    bt.DueDate,
    bt.ReturnDate,
    bt.FineAmount,
    bt.Status
FROM BorrowingTransactions bt
JOIN Books b ON bt.BookID = b.BookID
JOIN LibraryUsers lu ON bt.UserID = lu.UserID
JOIN Students s ON lu.StudentID = s.StudentID
JOIN Employees e ON bt.EmployeeID = e.EmployeeID;
GO

-- VIEW: Danh sách nhân viên
-- Mục đích: Hiển thị thông tin nhân viên cho Quản lý
CREATE VIEW EmployeeList
AS
SELECT 
    e.EmployeeID,
    e.FullName,
    e.DateOfBirth,
    e.Phone,
    e.Email,
    e.Address,
    e.HireDate,
    e.IsActive,
    ea.Username,
    ea.IsManager
FROM Employees e
LEFT JOIN EmployeeAccounts ea ON e.EmployeeID = ea.EmployeeID;
GO

-- VIEW: Danh sách sinh viên
-- Mục đích: Hiển thị thông tin sinh viên và tài khoản thư viện cho Nhân viên và Quản lý
CREATE VIEW StudentList
AS
SELECT 
    s.StudentID,
    s.StudentCode,
    s.FullName,
    s.DateOfBirth,
    s.Phone,
    s.Email,
    s.Address,
    lu.Username,
    lu.ExpirationDate
FROM Students s
LEFT JOIN LibraryUsers lu ON s.StudentID = lu.StudentID;
GO

-- VIEW: Thống kê mượn sách///
-- Mục đích: Hiển thị số lần mượn sách theo sách cho Quản lý
CREATE VIEW BorrowingStatistics
AS
SELECT 
    b.BookID,
    b.Title AS BookTitle,
    p.PublisherName,
    a.AuthorName,
    g.GenreName,
    COUNT(bt.TransactionID) AS BorrowCount
FROM Books b
LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Genres g ON b.GenreID = g.GenreID
LEFT JOIN BorrowingTransactions bt ON b.BookID = bt.BookID
GROUP BY b.BookID, b.Title, p.PublisherName, a.AuthorName, g.GenreName
ORDER BY BorrowCount DESC;
GO

-- VIEW: Lịch sử mượn sách cho Sinh viên
CREATE VIEW StudentBorrowingHistory
AS
SELECT 
    bt.TransactionID,
    bt.BookID,
    b.Title AS BookTitle,
    bt.BorrowDate,
    bt.DueDate,
    bt.ReturnDate,
    bt.FineAmount,
    bt.Status
FROM BorrowingTransactions bt
JOIN Books b ON bt.BookID = b.BookID
JOIN LibraryUsers lu ON bt.UserID = lu.UserID
WHERE lu.Username = CURRENT_USER;
GO