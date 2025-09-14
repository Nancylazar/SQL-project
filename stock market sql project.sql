create database market;
use market;
CREATE TABLE Company (
    company_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sector VARCHAR(100),
    market_cap DECIMAL(15,2)
);
CREATE TABLE StockPrice (
    price_id INT PRIMARY KEY,
    company_id INT,
    price_date DATE,
    open_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
);
CREATE TABLE Investor (
    investor_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE Transaction (
    transaction_id INT PRIMARY KEY,
    investor_id INT,
    company_id INT,
    transaction_date DATE,
    quantity INT,
    price DECIMAL(10,2),
    type VARCHAR(10) CHECK (type IN ('BUY', 'SELL')),
    FOREIGN KEY (investor_id) REFERENCES Investor(investor_id),
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
);
CREATE TABLE Portfolio (
    portfolio_id INT PRIMARY KEY,
    investor_id INT,
    company_id INT,
    quantity INT,
    FOREIGN KEY (investor_id) REFERENCES Investor(investor_id),
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
);
INSERT INTO Company(company_id,name,sector,market_cap ) VALUES 
(1, 'Reliance Industries', 'Energy', 1500000.00),
(2, 'Infosys', 'IT', 800000.00),
(3, 'HDFC Bank', 'Finance', 1200000.00),
(4, 'Tata Motors', 'Automobile', 600000.00),
(5, 'Wipro', 'IT', 500000.00),
(6, 'ICICI Bank', 'Finance', 1100000.00),
(7, 'TCS', 'IT', 1300000.00),
(8, 'ONGC', 'Energy', 300000.00),
(9, 'L&T', 'Construction', 700000.00),
(10, 'Axis Bank', 'Finance', 850000.00);
INSERT INTO StockPrice( price_id,company_id,price_date,open_price,close_price) VALUES
(1, 1, '2025-07-01', 2500, 2550),
(2, 2, '2025-07-01', 1600, 1620),
(3, 3, '2025-07-01', 1400, 1380),
(4, 4, '2025-07-01', 800, 850),
(5, 5, '2025-07-01', 400, 410),
(6, 6, '2025-07-01', 1100, 1090),
(7, 7, '2025-07-01', 3000, 3050),
(8, 8, '2025-07-01', 170, 180),
(9, 9, '2025-07-01', 2100, 2200),
(10, 10, '2025-07-01', 700, 690);
INSERT INTO Investor(investor_id,name,email) VALUES
(1, 'Rahul Sharma', 'rahul@example.com'),
(2, 'Anita Kapoor', 'anita@example.com'),
(3, 'Vikram Joshi', 'vikram@example.com'),
(4, 'Neha Agarwal', 'neha@example.com'),
(5, 'Suresh Rao', 'suresh@example.com'),
(6, 'Kavita Nair', 'kavita@example.com'),
(7, 'Arjun Mehta', 'arjun@example.com'),
(8, 'Priya Das', 'priya@example.com'),
(9, 'Rohan Patel', 'rohan@example.com'),
(10, 'Divya Iyer', 'divya@example.com');
INSERT INTO Transaction( transaction_id,investor_id,company_id,transaction_date,quantity,price,type) VALUES
(1, 1, 1, '2025-07-01', 10, 2500, 'BUY'),
(2, 2, 2, '2025-07-01', 5, 1600, 'BUY'),
(3, 3, 3, '2025-07-01', 15, 1400, 'BUY'),
(4, 4, 4, '2025-07-01', 20, 800, 'BUY'),
(5, 5, 5, '2025-07-01', 25, 400, 'BUY'),
(6, 6, 6, '2025-07-01', 10, 1100, 'BUY'),
(7, 7, 7, '2025-07-01', 8, 3000, 'BUY'),
(8, 8, 8, '2025-07-01', 12, 170, 'BUY'),
(9, 9, 9, '2025-07-01', 9, 2100, 'BUY'),
(10, 10, 10, '2025-07-01', 14, 700, 'BUY');
INSERT INTO Portfolio(portfolio_id,investor_id,company_id,quantity) VALUES
(1, 1, 1, 10),
(2, 2, 2, 5),
(3, 3, 3, 15),
(4, 4, 4, 20),
(5, 5, 5, 25),
(6, 6, 6, 10),
(7, 7, 7, 8),
(8, 8, 8, 12),
(9, 9, 9, 9),
(10, 10, 10, 14);
SELECT name, sector, market_cap FROM Company;
SELECT c.name, sp.price_date, sp.close_price
FROM StockPrice sp
JOIN Company c ON c.company_id = sp.company_id
WHERE sp.price_date = '2025-07-01';
SELECT t.*, c.name AS company_name
FROM Transaction t
JOIN Investor i ON i.investor_id = t.investor_id
JOIN Company c ON c.company_id = t.company_id
WHERE i.name = 'Rahul Sharma';
SELECT i.name, c.name AS company, p.quantity, sp.close_price,
       (p.quantity * sp.close_price) AS total_value
FROM Portfolio p
JOIN Investor i ON i.investor_id = p.investor_id
JOIN Company c ON c.company_id = p.company_id
JOIN StockPrice sp ON sp.company_id = c.company_id
WHERE i.name = 'Rahul Sharma' AND sp.price_date = '2025-07-01';
SELECT name, market_cap
FROM Company
ORDER BY market_cap DESC
LIMIT 1;
CREATE VIEW InvestorPortfolio AS
SELECT i.name AS investor, c.name AS company, p.quantity
FROM Portfolio p
JOIN Investor i ON i.investor_id = p.investor_id
JOIN Company c ON c.company_id = p.company_id;
SELECT company_id,name,sector,market_cap,
RANK() OVER (ORDER BY market_cap DESC) AS rank_by_market_cap
FROM Company;
SELECT name, sector, market_cap
FROM Company
WHERE market_cap > (SELECT AVG(market_cap) FROM Company);
WITH TotalShares AS (
    SELECT investor_id, SUM(quantity) AS total_quantity
    FROM Portfolio
    GROUP BY investor_id
)
SELECT i.name, t.total_quantity
FROM Investor i
JOIN TotalShares t ON i.investor_id = t.investor_id;








