SELECT p.pid, p.pname, c.cost, s.sid, s.sname
FROM Catalog c
JOIN Parts p ON c.pid = p.pid
JOIN Supplier s ON c.sid = s.sid
ORDER BY c.cost DESC
LIMIT 1;

SELECT s.sid, s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT 1
    FROM Catalog c
    JOIN Parts p ON c.pid = p.pid
    WHERE c.sid = s.sid
      AND p.color = 'Red'
);
SELECT s.sid, s.sname, SUM(c.cost) AS total_value
FROM Supplier s
JOIN Catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname;
SELECT s.sid, s.sname
FROM Supplier s
JOIN Catalog c ON s.sid = c.sid
WHERE c.cost < 20
GROUP BY s.sid, s.sname
HAVING COUNT(c.pid) >= 2;

SELECT c.sid, s.sname, c.pid, p.pname, c.cost
FROM Catalog c
JOIN Supplier s ON c.sid = s.sid
JOIN Parts p ON c.pid = p.pid
WHERE c.cost = (
    SELECT MIN(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
);


CREATE VIEW SupplierPartCount AS
SELECT s.sid, s.sname, COUNT(c.pid) AS total_parts
FROM Supplier s
LEFT JOIN Catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname;

CREATE VIEW MaxCostSupplierPerPart AS
SELECT c.sid, s.sname, c.pid, p.pname, c.cost
FROM Catalog c
JOIN Supplier s ON c.sid = s.sid
JOIN Parts p ON c.pid = p.pid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
);

DROP VIEW IF EXISTS MaxCostSupplierPerPart;

DELIMITER $$

CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost cannot be below 1';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER default_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL OR NEW.cost = 0 THEN
        SET NEW.cost = 10;
    END IF;
END$$

DELIMITER ;


