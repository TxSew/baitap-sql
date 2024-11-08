--Kết hợp dữ liệu từ các bảng khác nhau với UNION để tạo danh sách tổng hợp thông tin sách

SELECT Title, Price, PublisherName FROM Books
JOIN BookPublishers ON Books.BookID = BookPublishers.BookID
JOIN Publishers ON BookPublishers.PublisherID = Publishers.PublisherID
UNION
SELECT Title, Price, NULL AS PublisherName FROM Books
WHERE BookID NOT IN (SELECT BookID FROM BookPublishers);


