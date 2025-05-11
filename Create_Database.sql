-- Tạo cơ sở dữ liệu LibraryManagement
CREATE DATABASE LibraryManagement;
GO

-- Chuyển đến cơ sở dữ liệu LibraryManagement
USE LibraryManagement;
GO

-- Bảng Publishers: Lưu thông tin nhà xuất bản
CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY IDENTITY(1,1),
    PublisherName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200),
    Phone NVARCHAR(15),
    Email NVARCHAR(100)
);
GO

-- Bảng Authors: Lưu thông tin tác giả
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    AuthorName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Nationality NVARCHAR(50)
);
GO

-- Bảng Genres: Lưu thông tin thể loại sách
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY IDENTITY(1,1),
    GenreName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    PublisherID INT,
    AuthorID INT,
    GenreID INT,
    Quantity INT NOT NULL,
    AvailableQuantity INT NOT NULL
);
GO

ALTER TABLE Books
ADD CONSTRAINT CK_Books_Quantity CHECK (Quantity >= 0);

ALTER TABLE Books
ADD CONSTRAINT CK_Books_AvailableQuantity CHECK (
    AvailableQuantity >= 0 AND AvailableQuantity <= Quantity
);
GO

-- Bảng Employees: Lưu thông tin nhân viên
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    Address NVARCHAR(200),
    HireDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- Bảng Students: Lưu thông tin sinh viên
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    StudentCode NVARCHAR(20) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    Address NVARCHAR(200)
);
GO

-- Bảng LibraryUsers: Lưu thông tin tài khoản thư viện của sinh viên
CREATE TABLE LibraryUsers (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    ExpirationDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
GO

-- Bảng EmployeeAccounts: Lưu thông tin tài khoản nhân viên
CREATE TABLE EmployeeAccounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    IsManager BIT NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- Bảng BorrowingTransactions: Lưu lịch sử mượn sách
CREATE TABLE BorrowingTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT NOT NULL,
    UserID INT NOT NULL,
    EmployeeID INT NOT NULL,
    BorrowDate DATE NOT NULL,
    DueDate DATE,
    ReturnDate DATE,
    FineAmount DECIMAL(10,2) DEFAULT 0,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Borrowed', 'Returned')),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (UserID) REFERENCES LibraryUsers(UserID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- Tạo chỉ mục để tối ưu hóa tìm kiếm
CREATE INDEX IX_Books_Title ON Books(Title);
CREATE INDEX IX_Employees_FullName ON Employees(FullName);
CREATE INDEX IX_Students_StudentCode ON Students(StudentCode);
CREATE INDEX IX_LibraryUsers_Username ON LibraryUsers(Username);
CREATE INDEX IX_EmployeeAccounts_Username ON EmployeeAccounts(Username);
GO