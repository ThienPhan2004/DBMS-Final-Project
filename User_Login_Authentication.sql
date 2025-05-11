-- Đảm bảo sử dụng đúng cơ sở dữ liệu
USE LibraryManagement;
GO

-- Tạo login cho Quản lý và Nhân viên (tài khoản chung)
CREATE LOGIN ManagerLogin WITH PASSWORD = 'Manager@123';
CREATE LOGIN EmployeeLogin WITH PASSWORD = 'Employee@123';
GO

-- Tạo login cho Sinh viên (dựa trên dữ liệu trong LibraryUsers)
CREATE LOGIN [an.nv] WITH PASSWORD = 'Student@123';
CREATE LOGIN [binh.tt] WITH PASSWORD = 'Student@123';
CREATE LOGIN [cuong.pv] WITH PASSWORD = 'Student@123';
CREATE LOGIN [dung.lt] WITH PASSWORD = 'Student@123';
CREATE LOGIN [em.hv] WITH PASSWORD = 'Student@123';
CREATE LOGIN [phuong.dt] WITH PASSWORD = 'Student@123';
CREATE LOGIN [giang.vv] WITH PASSWORD = 'Student@123';
CREATE LOGIN [ha.bt] WITH PASSWORD = 'Student@123';
CREATE LOGIN [hung.nv] WITH PASSWORD = 'Student@123';
CREATE LOGIN [lan.mt] WITH PASSWORD = 'Student@123';
CREATE LOGIN [hong.nt] WITH PASSWORD = 'Manager@123';
CREATE LOGIN [minh.tv] WITH PASSWORD = 'Employee@123';
GO

-- Tạo user cho Quản lý và Nhân viên
CREATE USER ManagerUser FOR LOGIN ManagerLogin;
CREATE USER EmployeeUser FOR LOGIN EmployeeLogin;
GO

-- Tạo user cho Sinh viên và Nhân viên riêng
CREATE USER [an.nv] FOR LOGIN [an.nv];
CREATE USER [binh.tt] FOR LOGIN [binh.tt];
CREATE USER [cuong.pv] FOR LOGIN [cuong.pv];
CREATE USER [dung.lt] FOR LOGIN [dung.lt];
CREATE USER [em.hv] FOR LOGIN [em.hv];
CREATE USER [phuong.dt] FOR LOGIN [phuong.dt];
CREATE USER [giang.vv] FOR LOGIN [giang.vv];
CREATE USER [ha.bt] FOR LOGIN [ha.bt];
CREATE USER [hung.nv] FOR LOGIN [hung.nv];
CREATE USER [lan.mt] FOR LOGIN [lan.mt];
CREATE USER [hong.nt] FOR LOGIN [hong.nt];
CREATE USER [minh.tv] FOR LOGIN [minh.tv];
GO

-- Tạo role cho các vai trò
CREATE ROLE ManagerRole;
CREATE ROLE EmployeeRole;
CREATE ROLE StudentRole;
GO

-- Gán user vào role
EXEC sp_addrolemember 'ManagerRole', 'ManagerUser';
EXEC sp_addrolemember 'ManagerRole', 'hong.nt';
EXEC sp_addrolemember 'EmployeeRole', 'EmployeeUser';
EXEC sp_addrolemember 'EmployeeRole', 'minh.tv';
EXEC sp_addrolemember 'StudentRole', 'an.nv';
EXEC sp_addrolemember 'StudentRole', 'binh.tt';
EXEC sp_addrolemember 'StudentRole', 'cuong.pv';
EXEC sp_addrolemember 'StudentRole', 'dung.lt';
EXEC sp_addrolemember 'StudentRole', 'em.hv';
EXEC sp_addrolemember 'StudentRole', 'phuong.dt';
EXEC sp_addrolemember 'StudentRole', 'giang.vv';
EXEC sp_addrolemember 'StudentRole', 'ha.bt';
EXEC sp_addrolemember 'StudentRole', 'hung.nv';
EXEC sp_addrolemember 'StudentRole', 'lan.mt';
GO

-- Cấp quyền ALTER ANY LOGIN
USE master;
GRANT ALTER ANY LOGIN TO ManagerLogin;
GRANT ALTER ANY LOGIN TO EmployeeLogin;
GO

USE LibraryManagement;
GO

-- Phân quyền cho ManagerRole
GRANT SELECT, INSERT, UPDATE, DELETE ON Employees TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Books TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Publishers TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Authors TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Genres TO ManagerRole;
GRANT SELECT, INSERT, UPDATE ON BorrowingTransactions TO ManagerRole;
GRANT SELECT, INSERT ON LibraryUsers TO ManagerRole;
GRANT SELECT, INSERT ON EmployeeAccounts TO ManagerRole;
GRANT SELECT ON Students TO ManagerRole;
GRANT EXECUTE ON sp_SearchBooks TO ManagerRole;
GRANT EXECUTE ON sp_SearchEmployees TO ManagerRole;
GRANT EXECUTE ON sp_SearchStudents TO ManagerRole;
GRANT EXECUTE ON sp_AddBook TO ManagerRole;
GRANT EXECUTE ON sp_UpdateBook TO ManagerRole;
GRANT EXECUTE ON sp_DeleteBook TO ManagerRole;
GRANT EXECUTE ON sp_CreateEmployeeAccount TO ManagerRole;
GRANT EXECUTE ON sp_UpdateEmployee TO ManagerRole;
GRANT EXECUTE ON sp_DeleteEmployee TO ManagerRole;
GRANT EXECUTE ON sp_CreateBorrowingTransaction TO ManagerRole;
GRANT EXECUTE ON sp_ReturnBook TO ManagerRole;
GRANT EXECUTE ON sp_CalculateFine TO ManagerRole;
GRANT EXECUTE ON sp_GetBorrowingStatistics TO ManagerRole;
GRANT SELECT ON fn_GetAvailableBookQuantity TO ManagerRole;
GRANT SELECT ON BookCatalog TO ManagerRole;
GRANT SELECT ON ActiveBorrowingTransactions TO ManagerRole;
GRANT SELECT ON AllBorrowingTransactions TO ManagerRole;
GRANT SELECT ON EmployeeList TO ManagerRole;
GRANT SELECT ON StudentList TO ManagerRole;
GRANT SELECT ON BorrowingStatistics TO ManagerRole;
GRANT SELECT ON StudentBorrowingHistory TO ManagerRole;
GO

-- Phân quyền cho EmployeeRole
GRANT SELECT ON BookCatalog TO EmployeeRole;
GRANT SELECT ON ActiveBorrowingTransactions TO EmployeeRole;
GRANT SELECT ON StudentList TO EmployeeRole;
GRANT SELECT, INSERT ON BorrowingTransactions TO EmployeeRole;
GRANT SELECT ON Books TO EmployeeRole;
GRANT SELECT ON Students TO EmployeeRole;
GRANT SELECT ON LibraryUsers TO EmployeeRole;
GRANT EXECUTE ON sp_SearchBooks TO EmployeeRole;
GRANT EXECUTE ON sp_SearchStudents TO EmployeeRole;
GRANT EXECUTE ON sp_CreateBorrowingTransaction TO EmployeeRole;
GRANT EXECUTE ON sp_ReturnBook TO EmployeeRole;
GRANT EXECUTE ON sp_CalculateFine TO EmployeeRole;
GRANT SELECT ON fn_GetAvailableBookQuantity TO EmployeeRole;
GO

-- Phân quyền cho StudentRole
GRANT SELECT ON Books TO StudentRole;
GRANT SELECT ON BookCatalog TO StudentRole;
GRANT SELECT ON StudentBorrowingHistory TO StudentRole;
GRANT INSERT ON LibraryUsers TO StudentRole;
GRANT SELECT ON Students TO StudentRole;
GRANT EXECUTE ON sp_SearchBooks TO StudentRole;
GRANT EXECUTE ON sp_CreateStudentAccount TO StudentRole;
GRANT EXECUTE ON sp_LoginStudent TO StudentRole;
GRANT EXECUTE ON sp_ChangePassword TO StudentRole;
GRANT SELECT ON fn_GetAvailableBookQuantity TO StudentRole;
GO