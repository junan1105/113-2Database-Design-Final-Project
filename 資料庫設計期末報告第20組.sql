USE finally_0623;


CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Address TEXT
) ENGINE=InnoDB;


CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Contact VARCHAR(100),
    Phone VARCHAR(20)
) ENGINE=InnoDB;


CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Unit VARCHAR(20),
    Stock INT DEFAULT 0,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;


CREATE TABLE Purchases (
    PurchaseID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT,
    PurchaseDate DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
) ENGINE=InnoDB;


CREATE TABLE PurchaseDetails (
    PurchaseDetailID INT AUTO_INCREMENT PRIMARY KEY,
    PurchaseID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitCost DECIMAL(10,2),
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID)
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;


CREATE TABLE InventoryRecords (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    ChangeType VARCHAR(10) CHECK (ChangeType IN ('IN', 'OUT')),
    Quantity INT NOT NULL,
    ChangeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;


INSERT INTO Customers (Name, Phone, Address) VALUES
('王小明', '0912345678', '台北市中正區'),
('李小美', '0922333444', '新北市板橋區');

INSERT INTO Suppliers (Name, Contact, Phone) VALUES
('全方位文具供應', '張經理', '0223456789'),
('三商行', '陳小姐', '0222334455');

INSERT INTO Products (Name, Price, Unit, Stock, SupplierID) VALUES
('A4影印紙', 120, '包', 50, 1),
('原子筆', 10, '支', 100, 1),
('記事本', 45, '本', 80, 2);

INSERT INTO Orders (CustomerID, OrderDate) VALUES (1, '2025-06-10');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 5, 120),
(1, 2, 10, 10);

INSERT INTO Purchases (SupplierID, PurchaseDate) VALUES (1, '2025-06-01');

INSERT INTO PurchaseDetails (PurchaseID, ProductID, Quantity, UnitCost) VALUES
(1, 1, 100, 100),
(1, 2, 200, 8);

INSERT INTO InventoryRecords (ProductID, ChangeType, Quantity) VALUES
(1, 'IN', 100),
(2, 'IN', 200),
(1, 'OUT', 5),
(2, 'OUT', 10);


CREATE VIEW TopSellingProducts AS
SELECT p.Name, SUM(od.Quantity) AS TotalSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalSold DESC;


SELECT * FROM TopSellingProducts;
