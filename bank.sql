CREATE DATABASE IF NOT EXISTS bank;
USE bank;

DROP TABLE IF EXISTS Depositer;
DROP TABLE IF EXISTS BankAccount;
DROP TABLE IF EXISTS BankCustomer;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Branch;

CREATE TABLE Branch (
    branchname VARCHAR(50) PRIMARY KEY,
    branchcity VARCHAR(50),
    assets INT
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branchname VARCHAR(50),
    balance INT,
    FOREIGN KEY (branchname) REFERENCES Branch(branchname)
);

CREATE TABLE BankCustomer (
    customername VARCHAR(50) PRIMARY KEY,
    customerstreet VARCHAR(50),
    customercity VARCHAR(50)
);

CREATE TABLE Depositer (
    customername VARCHAR(50),
    accno INT,
    PRIMARY KEY (customername, accno),
    FOREIGN KEY (customername) REFERENCES BankCustomer(customername),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

CREATE TABLE Loan (
    loannumber INT PRIMARY KEY,
    branchname VARCHAR(50),
    amount INT,
    FOREIGN KEY (branchname) REFERENCES Branch(branchname)
);

INSERT INTO Branch VALUES
('SBI_Chamarajpet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 100000),
('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParlimentRoad', 'Delhi', 100000),
('SBI_Jantarmantar', 'Delhi', 200000);

INSERT INTO BankCustomer VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannerghatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikhil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');

INSERT INTO BankAccount VALUES
(1, 'SBI_Chamarajpet', 2000),
(2, 'SBI_ResidencyRoad', 5000),
(3, 'SBI_ShivajiRoad', 2000),
(4, 'SBI_ParlimentRoad', 4000),
(5, 'SBI_Jantarmantar', 8000),
(6, 'SBI_ShivajiRoad', 4000),
(8, 'SBI_ResidencyRoad', 4000),
(9, 'SBI_ParlimentRoad', 3000),
(10, 'SBI_ResidencyRoad', 5000),
(11, 'SBI_Jantarmantar', 2000);

INSERT INTO Depositer VALUES
('Avinash', 1),
('Dinesh', 2),
('Nikhil', 4),
('Ravi', 5),
('Avinash', 8),
('Nikhil', 9),
('Dinesh', 10),
('Nikhil', 11);

INSERT INTO Loan VALUES
(1, 'SBI_Chamarajpet', 1000),
(2, 'SBI_ResidencyRoad', 2000),
(3, 'SBI_ShivajiRoad', 3000),
(4, 'SBI_ParlimentRoad', 4000),
(5, 'SBI_Jantarmantar', 5000);


SELECT C.customername
FROM BankCustomer C
WHERE EXISTS (
    SELECT D.customername
    FROM Depositer D, BankAccount BA
    WHERE D.accno = BA.accno
      AND C.customername = D.customername
      AND BA.branchname = 'SBI_ResidencyRoad'
    GROUP BY D.customername
    HAVING COUNT(D.customername) >= 2
);


SELECT BC.customername
FROM BankCustomer BC
WHERE NOT EXISTS (
    SELECT branchname
    FROM Branch
    WHERE branchcity = 'Delhi'
    AND branchname NOT IN (
        SELECT BA.branchname
        FROM Depositer D, BankAccount BA
        WHERE D.accno = BA.accno
          AND BC.customername = D.customername
    )
);


DELETE FROM BankAccount
WHERE branchname IN (
    SELECT branchname
    FROM Branch
    WHERE branchcity = 'Bombay'
);
