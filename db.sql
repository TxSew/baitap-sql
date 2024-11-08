-- Tạo cơ sở dữ liệu
CREATE DATABASE BookStoreDB;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE BookStoreDB;
GO

-- Tạo bảng Authors (Tác giả)
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    Biography NVARCHAR(MAX),
    BirthDate DATE,
    Nationality NVARCHAR(100)
);

-- Tạo bảng Genres (Thể loại)
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY IDENTITY,
    GenreName NVARCHAR(100) NOT NULL
);

-- Tạo bảng Publishers (Nhà xuất bản)
CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY IDENTITY,
    PublisherName NVARCHAR(255) NOT NULL,
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Country NVARCHAR(100)
);

-- Tạo bảng Books (Sách)
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    GenreID INT,
    AuthorID INT,
    PublishedDate DATE,
    ISBN NVARCHAR(13) UNIQUE,
    CoverImage NVARCHAR(255),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Tạo bảng Customers (Khách hàng)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    Phone NVARCHAR(15),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Country NVARCHAR(100)
);

-- Tạo bảng Orders (Đơn hàng)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Tạo bảng OrderDetails (Chi tiết đơn hàng)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    BookID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Tạo bảng Reviews (Đánh giá)
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY,
    BookID INT,
    CustomerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    ReviewDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Tạo bảng Promotions (Khuyến mãi)
CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY,
    PromotionName NVARCHAR(255) NOT NULL,
    DiscountPercentage DECIMAL(5, 2) CHECK (DiscountPercentage BETWEEN 0 AND 100),
    StartDate DATE NOT NULL,
    EndDate DATE
);

-- Tạo bảng BookPromotions (Khuyến mãi cho Sách)
CREATE TABLE BookPromotions (
    BookID INT,
    PromotionID INT,
    PRIMARY KEY (BookID, PromotionID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
);

-- Tạo bảng BookPublishers (Sách - Nhà xuất bản)
CREATE TABLE BookPublishers (
    BookID INT,
    PublisherID INT,
    PRIMARY KEY (BookID, PublisherID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

-- Thêm dữ liệu giả vào bảng Authors
INSERT INTO Authors (Name, Biography, BirthDate, Nationality) VALUES
('J.K. Rowling', 'Author of Harry Potter series', '1965-07-31', 'British'),
('George R.R. Martin', 'Author of A Song of Ice and Fire', '1948-09-20', 'American'),
('Haruki Murakami', 'Japanese writer', '1949-01-12', 'Japanese'),
('Stephen King', 'American author of horror, supernatural fiction', '1947-09-21', 'American');

-- Thêm dữ liệu giả vào bảng Genres
INSERT INTO Genres (GenreName) VALUES
('Fantasy'),
('Science Fiction'),
('Mystery'),
('Romance'),
('Horror');

-- Thêm dữ liệu giả vào bảng Publishers
INSERT INTO Publishers (PublisherName, Address, City, Country) VALUES
('Penguin Random House', '1745 Broadway', 'New York', 'USA'),
('HarperCollins', '195 Broadway', 'New York', 'USA'),
('Macmillan Publishers', '75 Varick St', 'New York', 'USA'),
('Simon & Schuster', '1230 Avenue of the Americas', 'New York', 'USA');

-- Thêm dữ liệu giả vào bảng Books
INSERT INTO Books (Title, Description, Price, Stock, GenreID, AuthorID, PublishedDate, ISBN, CoverImage) VALUES
('Harry Potter and the Philosopher''s Stone', 'First book of Harry Potter series', 19.99, 100, 1, 1, '1997-06-26', '9780747532743', 'harry_potter_1.jpg'),
('A Game of Thrones', 'First book of A Song of Ice and Fire', 25.99, 80, 1, 2, '1996-08-06', '9780553103540', 'game_of_thrones.jpg'),
('Norwegian Wood', 'Popular novel by Haruki Murakami', 15.99, 50, 4, 3, '1987-09-04', '9780375704024', 'norwegian_wood.jpg'),
('It', 'Horror novel by Stephen King', 18.99, 120, 5, 4, '1986-09-15', '9780450411434', 'it.jpg');

-- Thêm dữ liệu giả vào bảng Customers
INSERT INTO Customers (Name, Email, Phone, Address, City, Country) VALUES
('Alice Johnson', 'alice@example.com', '123-456-7890', '123 Main St', 'New York', 'USA'),
('Bob Smith', 'bob@example.com', '098-765-4321', '456 Elm St', 'Chicago', 'USA'),
('Charlie Brown', 'charlie@example.com', '111-222-3333', '789 Maple Ave', 'San Francisco', 'USA'),
('Diana Prince', 'diana@example.com', '444-555-6666', '321 Oak St', 'Los Angeles', 'USA');

-- Thêm dữ liệu giả vào bảng Orders
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalAmount) VALUES
(1, '2023-11-01', 'Shipped', 39.98),
(2, '2023-11-02', 'Delivered', 25.99),
(3, '2023-11-03', 'Pending', 15.99),
(4, '2023-11-04', 'Cancelled', 0);

-- Thêm dữ liệu giả vào bảng OrderDetails
INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice) VALUES
(1, 1, 2, 19.99),
(2, 2, 1, 25.99),
(3, 3, 1, 15.99),
(4, 4, 1, 18.99);

-- Thêm dữ liệu giả vào bảng Reviews
INSERT INTO Reviews (BookID, CustomerID, Rating, Comment, ReviewDate) VALUES
(1, 1, 5, 'Amazing book, loved it!', '2023-11-01'),
(2, 2, 4, 'Great read, highly recommend', '2023-11-02'),
(3, 3, 3, 'Good, but not my favorite', '2023-11-03'),
(4, 4, 4, 'Scary but enjoyable', '2023-11-04');

-- Thêm dữ liệu giả vào bảng Promotions
INSERT INTO Promotions (PromotionName, DiscountPercentage, StartDate, EndDate) VALUES
('Black Friday Sale', 20, '2023-11-24', '2023-11-26'),
('Holiday Discount', 15, '2023-12-01', '2023-12-31');

-- Thêm dữ liệu giả vào bảng BookPromotions
INSERT INTO BookPromotions (BookID, PromotionID) VALUES
(1, 1),
(2, 2);

-- Thêm dữ liệu giả vào bảng BookPublishers
INSERT INTO BookPublishers (BookID, PublisherID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

GO


GO
