-- Đảm bảo sử dụng đúng cơ sở dữ liệu
USE LibraryManagement;
GO

-- Chèn dữ liệu vào bảng Publishers
INSERT INTO Publishers (PublisherName, Address, Phone, Email) VALUES
(N'NXB Giáo Dục', N'81 Trần Hưng Đạo, Hà Nội', N'02438220801', N'giaoduc@nxb.vn'),
(N'NXB Kim Đồng', N'55 Quang Trung, Hà Nội', N'02439434720', N'kimdong@nxb.vn'),
(N'NXB Trẻ', N'161B Lý Chính Thắng, TP.HCM', N'02839316289', N'tre@nxb.vn'),
(N'NXB Văn Học', N'18 Nguyễn Du, Hà Nội', N'02438221814', N'vanhoc@nxb.vn'),
(N'NXB Khoa Học và Kỹ Thuật', N'70 Trần Hưng Đạo, Hà Nội', N'02438220901', N'khoahoc@nxb.vn'),
(N'NXB Phụ Nữ', N'39 Hàng Chuối, Hà Nội', N'02439714710', N'phunu@nxb.vn'),
(N'NXB Đại Học Quốc Gia', N'16 Hàng Chuối, Hà Nội', N'02439715001', N'dhqg@nxb.vn'),
(N'NXB Thanh Niên', N'64 Bà Triệu, Hà Nội', N'02439411472', N'thanhnien@nxb.vn'),
(N'NXB Thế Giới', N'46 Trần Hưng Đạo, Hà Nội', N'02438253460', N'thegioi@nxb.vn'),
(N'NXB Hội Nhà Văn', N'65 Nguyễn Du, Hà Nội', N'02438222135', N'hoinhavan@nxb.vn');
GO

-- Chèn dữ liệu vào bảng Authors
INSERT INTO Authors (AuthorName, DateOfBirth, Nationality) VALUES
(N'Nguyễn Nhật Ánh', '1955-05-07', N'Việt Nam'),
(N'Tô Hoài', '1920-09-27', N'Việt Nam'),
(N'Nam Cao', '1915-10-29', N'Việt Nam'),
(N'Ngô Tất Tố', '1894-09-03', N'Việt Nam'),
(N'Nguyễn Đình Thi', '1924-12-20', N'Việt Nam'),
(N'Paulo Coelho', '1947-08-24', N'Brazil'),
(N'J.K. Rowling', '1965-07-31', N'Anh'),
(N'Haruki Murakami', '1949-01-12', N'Nhật Bản'),
(N'Nguyễn Huy Thiệp', '1950-04-29', N'Việt Nam'),
(N'Trần Đăng Khoa', '1958-04-26', N'Việt Nam'),
(N'Vũ Trọng Phụng', '1912-10-20', N'Việt Nam'),
(N'Nguyễn Tuân', '1910-07-10', N'Việt Nam'),
(N'Kim Lân', '1922-08-01', N'Việt Nam'),
(N'Hồ Anh Thái', '1960-03-15', N'Việt Nam'),
(N'Nguyễn Khắc Trường', '1946-09-10', N'Việt Nam');
GO

-- Chèn dữ liệu vào bảng Genres
INSERT INTO Genres (GenreName) VALUES
(N'Văn học thiếu nhi'),
(N'Tiểu thuyết'),
(N'Truyện ngắn'),
(N'Khoa học viễn tưởng'),
(N'Lịch sử'),
(N'Tự truyện'),
(N'Khoa học'),
(N'Thơ'),
(N'Trinh thám'),
(N'Kinh tế'),
(N'Văn học hiện thực'),
(N'Văn học lãng mạn'),
(N'Tâm lý học'),
(N'Văn học dân gian'),
(N'Kỹ năng sống');
GO

-- Chèn dữ liệu vào bảng Books
INSERT INTO Books (Title, PublisherID, AuthorID, GenreID, Quantity, AvailableQuantity) VALUES
(N'Cho tôi xin một vé đi tuổi thơ', 2, 1, 1, 20, 18),
(N'Dế mèn phiêu lưu ký', 2, 2, 1, 15, 12),
(N'Chí Phèo', 4, 3, 11, 10, 8),
(N'Tắt đèn', 4, 4, 11, 12, 10),
(N'Đất rừng phương Nam', 3, 5, 2, 8, 7),
(N'Nhà giả kim', 9, 6, 2, 25, 20),
(N'Harry Potter và Hòn đá Phù thủy', 3, 7, 4, 30, 25),
(N'Rừng Na Uy', 9, 8, 12, 15, 13),
(N'Truyện ngắn Nguyễn Huy Thiệp', 4, 9, 3, 10, 9),
(N'Tôi thấy hoa vàng trên cỏ xanh', 2, 1, 1, 18, 15),
(N'Số đỏ', 4, 11, 11, 12, 10),
(N'Vang bóng một thời', 4, 12, 3, 10, 8),
(N'Lão Hạc', 4, 3, 11, 15, 14),
(N'Tình yêu và thù hận', 3, 7, 12, 20, 18),
(N'Kỹ năng giao tiếp', 8, 14, 15, 10, 10),
(N'Lịch sử Việt Nam', 7, 15, 5, 8, 7),
(N'Thơ Trần Đăng Khoa', 1, 10, 8, 12, 11),
(N'Tâm lý học đám đông', 6, 14, 13, 10, 9),
(N'Truyện Kiều', 4, 12, 8, 15, 13),
(N'Kinh tế học cơ bản', 5, 15, 10, 10, 8);
GO

-- Chèn dữ liệu vào bảng Employees
INSERT INTO Employees (FullName, DateOfBirth, Phone, Email, Address, HireDate, IsActive) VALUES
(N'Nguyễn Thị Hồng', '1985-03-15', N'0987654321', N'hong.nt@library.vn', N'123 Lê Lợi, Hà Nội', '2020-01-10', 1),
(N'Trần Văn Minh', '1990-07-22', N'0912345678', N'minh.tv@library.vn', N'45 Nguyễn Huệ, TP.HCM', '2021-06-01', 1),
(N'Phạm Thị Lan', '1988-11-30', N'0933456789', N'lan.pt@library.vn', N'67 Trần Phú, Đà Nẵng', '2019-09-15', 1),
(N'Lê Văn Hùng', '1983-05-05', N'0904567890', N'hung.lv@library.vn', N'89 Phạm Văn Đồng, Hà Nội', '2018-03-20', 1),
(N'Hoàng Thị Mai', '1992-09-10', N'0975678901', N'mai.ht@library.vn', N'12 Nguyễn Trãi, TP.HCM', '2022-02-14', 1),
(N'Đỗ Văn Nam', '1987-12-25', N'0946789012', N'nam.dv@library.vn', N'34 Hùng Vương, Huế', '2020-11-01', 1),
(N'Vũ Thị Thanh', '1995-04-18', N'0967890123', N'thanh.vt@library.vn', N'56 Lý Thường Kiệt, Hà Nội', '2023-01-05', 1),
(N'Bùi Văn Tâm', '1980-08-08', N'0928901234', N'tam.bv@library.vn', N'78 Nguyễn Văn Cừ, TP.HCM', '2017-07-10', 0),
(N'Ngô Thị Hà', '1993-06-12', N'0959012345', N'ha.nt@library.vn', N'90 Trần Hưng Đạo, Đà Nẵng', '2021-12-20', 1),
(N'Mai Văn Long', '1989-02-28', N'0990123456', N'long.mv@library.vn', N'102 Lê Duẩn, Hà Nội', '2019-04-15', 1);
GO

-- Chèn dữ liệu vào bảng Students
INSERT INTO Students (StudentCode, FullName, DateOfBirth, Phone, Email, Address) VALUES
(N'SV001', N'Nguyễn Văn An', '2002-01-10', N'0911111111', N'an.nv@student.vn', N'15 Nguyễn Thị Minh Khai, TP.HCM'),
(N'SV002', N'Trần Thị Bình', '2001-05-22', N'0922222222', N'binh.tt@student.vn', N'27 Lê Văn Sỹ, Hà Nội'),
(N'SV003', N'Phạm Văn Cường', '2003-03-15', N'0933333333', N'cuong.pv@student.vn', N'39 Trần Phú, Đà Nẵng'),
(N'SV004', N'Lê Thị Dung', '2002-07-30', N'0944444444', N'dung.lt@student.vn', N'51 Nguyễn Huệ, Huế'),
(N'SV005', N'Hoàng Văn Em', '2001-11-05', N'0955555555', N'em.hv@student.vn', N'63 Lý Thường Kiệt, Hà Nội'),
(N'SV006', N'Đỗ Thị Phượng', '2003-09-18', N'0966666666', N'phuong.dt@student.vn', N'75 Hùng Vương, TP.HCM'),
(N'SV007', N'Vũ Văn Giang', '2002-04-25', N'0977777777', N'giang.vv@student.vn', N'87 Phạm Văn Đồng, Đà Nẵng'),
(N'SV008', N'Bùi Thị Hà', '2001-12-12', N'0988888888', N'ha.bt@student.vn', N'99 Nguyễn Trãi, Hà Nội'),
(N'SV009', N'Ngô Văn Hùng', '2003-06-08', N'0999999999', N'hung.nv@student.vn', N'111 Lê Lợi, TP.HCM'),
(N'SV010', N'Mai Thị Lan', '2002-08-20', N'0900000000', N'lan.mt@student.vn', N'123 Trần Hưng Đạo, Huế'),
(N'SV011', N'Nguyễn Văn Khôi', '2001-02-14', N'0911234567', N'khoi.nv@student.vn', N'135 Nguyễn Văn Cừ, Hà Nội'),
(N'SV012', N'Trần Thị Mai', '2003-10-01', N'0922345678', N'mai.tt@student.vn', N'147 Lê Duẩn, TP.HCM'),
(N'SV013', N'Phạm Văn Nam', '2002-05-17', N'0933456789', N'nam.pv@student.vn', N'159 Lý Thường Kiệt, Đà Nẵng'),
(N'SV014', N'Lê Thị Oanh', '2001-09-09', N'0944567890', N'oanh.lt@student.vn', N'171 Hùng Vương, Hà Nội'),
(N'SV015', N'Hoàng Văn Phát', '2003-07-23', N'0955678901', N'phat.hv@student.vn', N'183 Phạm Văn Đồng, TP.HCM');
GO

-- Chèn dữ liệu vào bảng LibraryUsers
-- Mật khẩu là chuỗi BCrypt giả lập
INSERT INTO LibraryUsers (StudentID, Username, Password, ExpirationDate) VALUES
(1, N'an.nv', N'$2a$12$abc123hashedpassword1', '2026-12-31'),
(2, N'binh.tt', N'$2a$12$abc123hashedpassword2', '2026-12-31'),
(3, N'cuong.pv', N'$2a$12$abc123hashedpassword3', '2026-12-31'),
(4, N'dung.lt', N'$2a$12$abc123hashedpassword4', '2026-12-31'),
(5, N'em.hv', N'$2a$12$abc123hashedpassword5', '2026-12-31'),
(6, N'phuong.dt', N'$2a$12$abc123hashedpassword6', '2026-12-31'),
(7, N'giang.vv', N'$2a$12$abc123hashedpassword7', '2026-12-31'),
(8, N'ha.bt', N'$2a$12$abc123hashedpassword8', '2026-12-31'),
(9, N'hung.nv', N'$2a$12$abc123hashedpassword9', '2026-12-31'),
(10, N'lan.mt', N'$2a$12$abc123hashedpassword10', '2026-12-31');
GO

-- Chèn dữ liệu vào bảng EmployeeAccounts
-- Mật khẩu là chuỗi BCrypt giả lập
INSERT INTO EmployeeAccounts (EmployeeID, Username, Password, IsManager) VALUES
(1, N'hong.nt', N'$2a$12$abc123hashedpassword11', 1), -- Quản lý
(2, N'minh.tv', N'$2a$12$abc123hashedpassword12', 0); -- Nhân viên
GO

-- Chèn dữ liệu vào bảng BorrowingTransactions
INSERT INTO BorrowingTransactions (BookID, UserID, EmployeeID, BorrowDate, DueDate, ReturnDate, FineAmount, Status) VALUES
(1, 1, 1, '2025-04-01', '2025-04-08', NULL, 0, 'Borrowed'),
(2, 2, 2, '2025-04-02', '2025-04-09', '2025-04-10', 1000, 'Returned'),
(3, 3, 3, '2025-04-03', '2025-04-10', NULL, 0, 'Borrowed'),
(4, 4, 4, '2025-04-04', '2025-04-11', '2025-04-12', 0, 'Returned'),
(5, 5, 5, '2025-04-05', '2025-04-12', NULL, 0, 'Borrowed'),
(6, 6, 6, '2025-04-06', '2025-04-13', '2025-04-14', 0, 'Returned'),
(7, 7, 7, '2025-04-07', '2025-04-14', NULL, 0, 'Borrowed'),
(8, 8, 1, '2025-04-08', '2025-04-15', '2025-04-16', 0, 'Returned'),
(9, 9, 2, '2025-04-09', '2025-04-16', NULL, 0, 'Borrowed'),
(10, 10, 3, '2025-04-10', '2025-04-17', NULL, 0, 'Borrowed'),
(11, 1, 4, '2025-04-11', '2025-04-18', '2025-04-19', 0, 'Returned'),
(12, 2, 5, '2025-04-12', '2025-04-19', NULL, 0, 'Borrowed'),
(13, 3, 6, '2025-04-13', '2025-04-20', '2025-04-21', 0, 'Returned'),
(14, 4, 7, '2025-04-14', '2025-04-21', NULL, 0, 'Borrowed'),
(15, 5, 1, '2025-04-15', '2025-04-22', NULL, 0, 'Borrowed');
GO