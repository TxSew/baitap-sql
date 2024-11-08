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
