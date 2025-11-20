use SupplierPartsDB;
-- Q3. Find the pnames of parts for which there is some supplier.
Select distinct pname
from parts p
where pid in (
	select pid from catalog
    );
-- Q4. Find the snames of suppliers who supply every part.
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);
-- Q5. Find the snames of suppliers who supply every red part.
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red'
    AND p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

-- Q6. Find the pnames of parts supplied by Acme Widget Suppliers and by no one else.
SELECT p.pname
FROM Parts p
WHERE p.pid IN (
    SELECT c.pid
    FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname = 'Acme Widget'
)
AND p.pid NOT IN (
    SELECT c.pid
    FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname <> 'Acme Widget'
);

-- Q7. Find the sids of suppliers who charge more for some part than the average cost of that part.
SELECT DISTINCT c1.sid
FROM Catalog c1
WHERE c1.cost > (
    SELECT AVG(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c1.pid
);

-- Q8. For each part, find the sname of the supplier who charges the most for that part.
SELECT c.pid, s.sname
FROM Catalog
JOIN Supplier s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
)
ORDER BY c.pid;	
