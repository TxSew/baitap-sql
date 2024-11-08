-- Bài 1: Liệt kê tất cả các sách trong cửa hàng
--Viết truy vấn để liệt kê danh sách tất cả các sách có trong bảng Books, bao gồm tên sách, giá, và tên tác giả.
SELECT 
    b.Title AS BookTitle,
    b.Price,
    a.Name AS AuthorName
FROM 
    Books b
JOIN 
    Authors a ON b.AuthorID = a.AuthorID;


--Bài 2: Liệt kê các sách theo thể loại
--Yêu cầu: Liệt kê tất cả các sách theo từng thể loại. Kết quả cần bao gồm tên sách, tên thể loại, và giá sách.
SELECT 
    b.Title AS BookTitle,
    g.GenreName,
    b.Price
FROM 
    Books b
JOIN 
    Genres g ON b.GenreID = g.GenreID
ORDER BY 
    g.GenreName, b.Title;
--Bài 3 Liệt kê các khách hàng có đơn hàng vượt quá 1 triệu VND
--Yêu cầu: Tìm các khách hàng đã thực hiện đơn hàng có tổng giá trị lớn hơn 1 triệu VND.

SELECT 
    c.Name AS CustomerName,
    o.OrderID,
    SUM(od.Quantity * od.UnitPrice) AS TotalOrderAmount
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    c.Name, o.OrderID
HAVING 
    SUM(od.Quantity * od.UnitPrice) > 1000000;

--Bài 4: Tìm sách được đánh giá cao nhất
--Yêu cầu: Tìm tên sách có điểm đánh giá cao nhất từ bảng Reviews.
SELECT 
    b.Title AS BookTitle,
    AVG(r.Rating) AS AverageRating
FROM 
    Books b
JOIN 
    Reviews r ON b.BookID = r.BookID
GROUP BY 
    b.Title
ORDER BY 
    AverageRating DESC
LIMIT 1;

--Bài 5: Tính tổng doanh thu theo tháng
--Yêu cầu: Tính tổng doanh thu của shop theo từng tháng, dựa trên bảng Orders và OrderDetails.
SELECT 
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY 
    OrderYear, OrderMonth;

-- bai 6: Thống kê số lượng sách theo từng nhà xuất bản
--Yêu cầu: Đếm số lượng sách mà mỗi nhà xuất bản đã phát hành.
SELECT 
    p.PublisherName,
    COUNT(bp.BookID) AS BookCount
FROM 
    Publishers p
JOIN 
    BookPublishers bp ON p.PublisherID = bp.PublisherID
GROUP BY 
    p.PublisherName
ORDER BY 
    BookCount DESC;

--bai 7:  Liệt kê tất cả sách chưa có đánh giá
--Yêu cầu: Tìm danh sách tất cả các sách chưa có bất kỳ đánh giá nào trong bảng Reviews.
SELECT 
    b.Title AS BookTitle
FROM 
    Books b
LEFT JOIN 
    Reviews r ON b.BookID = r.BookID
WHERE 
    r.ReviewID IS NULL;




