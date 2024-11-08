USE BookStoreDB;
GO

CREATE PROCEDURE GetBookStatisticsReport
AS
BEGIN
    -- Chọn sách cùng với tổng số lượng bán, tổng doanh thu và đánh giá trung bình
    SELECT 
        B.BookID,
        B.Title,
        B.Price,
        G.GenreName,
        A.Name AS AuthorName,
        P.PublisherName,
        
        -- Tổng số lượng bán từ OrderDetails
        ISNULL(SUM(OD.Quantity), 0) AS TotalQuantitySold,

        -- Tổng doanh thu từ các đơn hàng
        ISNULL(SUM(OD.Quantity * OD.UnitPrice), 0) AS TotalRevenue,

        -- Đánh giá trung bình từ Reviews
        ISNULL(AVG(R.Rating), 0) AS AverageRating

    FROM Books B
    LEFT JOIN Genres G ON B.GenreID = G.GenreID
    LEFT JOIN Authors A ON B.AuthorID = A.AuthorID
    LEFT JOIN BookPublishers BP ON B.BookID = BP.BookID
    LEFT JOIN Publishers P ON BP.PublisherID = P.PublisherID
    LEFT JOIN OrderDetails OD ON B.BookID = OD.BookID
    LEFT JOIN Reviews R ON B.BookID = R.BookID

    GROUP BY 
        B.BookID, B.Title, B.Price, G.GenreName, A.Name, P.PublisherName

    ORDER BY 
        TotalQuantitySold DESC, -- Xếp sách theo tổng số lượng bán
        TotalRevenue DESC       -- và theo tổng doanh thu
END;
GO


--- Procedure Thêm Đơn Hàng Mới

CREATE PROCEDURE AddNewOrder
    @CustomerID INT,
    @OrderDate DATE,
    @Status NVARCHAR(50),
    @OrderDetails TABLE (BookID INT, Quantity INT, UnitPrice DECIMAL(10, 2))
AS
BEGIN
    DECLARE @OrderID INT;
    
    -- Thêm đơn hàng vào bảng Orders
    INSERT INTO Orders (CustomerID, OrderDate, Status, TotalAmount)
    VALUES (@CustomerID, @OrderDate, @Status, 0);

    SET @OrderID = SCOPE_IDENTITY();  -- Lấy OrderID vừa tạo
    
    -- Thêm từng chi tiết đơn hàng
    DECLARE @TotalAmount DECIMAL(10, 2) = 0;
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice)
    SELECT @OrderID, BookID, Quantity, UnitPrice FROM @OrderDetails;

    -- Cập nhật tổng tiền đơn hàng
    SELECT @TotalAmount = SUM(Quantity * UnitPrice) FROM @OrderDetails;
    UPDATE Orders SET TotalAmount = @TotalAmount WHERE OrderID = @OrderID;
END;
GO


-- Procedure Lấy Danh Sách Sách Theo Thể Loại Hoặc Tác Giả

CREATE PROCEDURE GetBooksByGenreOrAuthor
    @GenreID INT = NULL,
    @AuthorID INT = NULL
AS
BEGIN
    -- Lấy danh sách sách theo thể loại hoặc tác giả
    SELECT 
        Books.BookID, 
        Books.Title, 
        Books.Description, 
        Books.Price, 
        Books.Stock,
        Genres.GenreName,
        Authors.Name AS AuthorName
    FROM Books
    LEFT JOIN Genres ON Books.GenreID = Genres.GenreID
    LEFT JOIN Authors ON Books.AuthorID = Authors.AuthorID
    WHERE 
        (Books.GenreID = @GenreID OR @GenreID IS NULL) AND
        (Books.AuthorID = @AuthorID OR @AuthorID IS NULL);
END;
GO

