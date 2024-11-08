-- Tìm tác giả có sách được đánh giá cao nhất

--Yêu cầu: Tìm tác giả có sách được đánh giá cao nhất (dựa trên điểm đánh giá trung bình của các sách của họ). Trả về tên tác giả và điểm đánh giá trung bình.
SELECT 
    A.Name AS AuthorName,
    AVG(R.Rating) AS AverageRating
FROM 
    Authors A
JOIN 
    Books B ON A.AuthorID = B.AuthorID
JOIN 
    Reviews R ON B.BookID = R.BookID
GROUP BY 
    A.AuthorID, A.Name
ORDER BY 
    AverageRating DESC
LIMIT 1;
--Tìm sách có doanh thu cao nhất và nhà xuất bản của sách đó
--Yêu cầu: Tìm sách có doanh thu cao nhất, bao gồm cả tên sách và nhà xuất bản. Trả về tên sách, nhà xuất bản và tổng doanh thu.
SELECT 
    B.Title AS BookTitle,
    P.PublisherName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalRevenue
FROM 
    Books B
JOIN 
    OrderDetails OD ON B.BookID = OD.BookID
JOIN 
    BookPublishers BP ON B.BookID = BP.BookID
JOIN 
    Publishers P ON BP.PublisherID = P.PublisherID
GROUP BY 
    B.BookID, B.Title, P.PublisherName
ORDER BY 
    TotalRevenue DESC
LIMIT 1;
--Tìm sách được mua nhiều nhất theo từng thành phố của khách hàng
--Yêu cầu: Tìm sách được mua nhiều nhất theo từng thành phố của khách hàng, trả về tên sách, tên thành phố, và số lượng mua.
WITH CityTopBooks AS (
    SELECT 
        B.Title,
        CU.City,
        SUM(OD.Quantity) AS TotalSold,
        ROW_NUMBER() OVER (PARTITION BY CU.City ORDER BY SUM(OD.Quantity) DESC) AS rn
    FROM 
        Books B
    JOIN 
        OrderDetails OD ON B.BookID = OD.BookID
    JOIN 
        Orders O ON OD.OrderID = O.OrderID
    JOIN 
        Customers CU ON O.CustomerID = CU.CustomerID
    GROUP BY 
        B.Title, CU.City
)
SELECT 
    Title, City, TotalSold
FROM 
    CityTopBooks
WHERE 
    rn = 1;
