--Tạo Trigger tự động cập nhật số lượng sách trong kho khi có đơn hàng

CREATE TRIGGER trg_UpdateStockAfterOrder
ON OrderDetails
AFTER INSERT
AS
BEGIN
    DECLARE @BookID INT, @Quantity INT;
    
    SELECT @BookID = BookID, @Quantity = Quantity FROM inserted;
    
    UPDATE Books
    SET Stock = Stock - @Quantity
    WHERE BookID = @BookID;
END;
---Tạo Trigger để ngăn việc xóa nhà xuất bản có sách đang xuất bản
CREATE TRIGGER trg_PreventDeletePublisherWithBooks
ON Publishers
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @PublisherID INT;
    
    SELECT @PublisherID = PublisherID FROM deleted;
    
    IF EXISTS (
        SELECT 1
        FROM BookPublishers
        WHERE PublisherID = @PublisherID
    )
    BEGIN
        RAISERROR ('Không thể xóa nhà xuất bản vì vẫn còn sách liên kết.', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        DELETE FROM Publishers WHERE PublisherID = @PublisherID;
    END;
END;
--Tạo Trigger tự động cập nhật trạng thái đơn hàng

CREATE TRIGGER trg_UpdateOrderStatus
ON OrderDetails
AFTER UPDATE
AS
BEGIN
    DECLARE @OrderID INT;
    
    SELECT @OrderID = OrderID FROM inserted;
    
    IF NOT EXISTS (
        SELECT 1
        FROM OrderDetails OD
        JOIN Orders O ON OD.OrderID = O.OrderID
        WHERE O.OrderID = @OrderID AND O.Status = 'Shipped'
    )
    BEGIN
        UPDATE Orders
        SET Status = 'Delivered'
        WHERE OrderID = @OrderID;
    END;
END;
