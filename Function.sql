USE LibraryManagement;
GO

-- FUNCTION: Kiểm tra số lượng sách có sẵn
CREATE FUNCTION fn_GetAvailableBookQuantity (@BookID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT AvailableQuantity FROM Books WHERE BookID = @BookID);
END;
GO