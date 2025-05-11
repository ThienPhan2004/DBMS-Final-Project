USE LibraryManagement;
GO

-- TRIGGER: Kiểm tra số lượng sách khi cập nhật
CREATE TRIGGER tr_Books_UpdateQuantity
ON Books
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.AvailableQuantity > i.Quantity OR i.AvailableQuantity < 0
    )
    BEGIN
        THROW 50001, 'Số lượng sách có sẵn không hợp lệ.', 1;
        ROLLBACK;
    END;
END;
GO

-- TRIGGER: Kiểm tra tài khoản hết hạn khi mượn sách
CREATE TRIGGER tr_CheckUserExpiration
ON BorrowingTransactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN LibraryUsers lu ON i.UserID = lu.UserID
        WHERE lu.ExpirationDate IS NOT NULL AND lu.ExpirationDate < GETDATE()
    )
    BEGIN
        THROW 50001, 'Tài khoản người dùng đã hết hạn.', 1;
        ROLLBACK;
    END;
END;
GO