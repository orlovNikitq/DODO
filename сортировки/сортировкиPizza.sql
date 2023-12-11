use Pizza
--���������� �� prefix(���, �� 2����� � �.�.)
SELECT p.*
FROM _product p
JOIN _prefix pr ON p.id_prefix = pr.id
WHERE pr.name = '���';

SELECT p.*
FROM _combo p
JOIN _prefix pr ON p.id_prefix = pr.id
WHERE pr.name = '���';

SELECT p.*
FROM _pizza p
JOIN _prefix pr ON p.id_prefix = pr.id
WHERE pr.name = '���';

--------------------------------------------------------------------------------------------

--���������� �� ���� ���� (�������, ������ , ���������)


	SELECT p.*
FROM _pizza p
JOIN _pizza_type_menu ptm ON p.id = ptm.id_pizza
JOIN _type_menu tm ON ptm.id_type_menu = tm.id
WHERE tm.name = '�������';

	SELECT pr.*
FROM _product pr
JOIN _product_type_menu ptm ON pr.id = ptm.id_product
JOIN _type_menu tm ON ptm.id_type_menu = tm.id
WHERE tm.name = '������';


--------------------------------------------------------------------------------------------

--���������� ���� �� �����������
-- ��� ���������
SELECT * FROM _product
ORDER BY cost ASC;

-- ��� �����
SELECT * FROM _combo
ORDER BY cost ASC;

---- ��� ����
SELECT * FROM _pizza
ORDER BY cost ASC;


--------------------------------------------------------------------------------------------

--���������� ���� �� ��������
-- ��� ���������
SELECT * FROM _product
ORDER BY cost DESC;

-- ��� �����
SELECT * FROM _combo
ORDER BY cost DESC;

-- ��� ����
SELECT * FROM _pizza
ORDER BY cost DESC;

--------------------------------------------------------------------------------------------

--���������� ���� � ���������


-- ��� ���������
SELECT * FROM _product
WHERE cost BETWEEN 100 AND 300
ORDER BY cost;

-- ��� �����
SELECT * FROM _combo
WHERE cost BETWEEN 100 AND 300
ORDER BY cost;

-- ��� ����
SELECT * FROM _pizza
WHERE cost BETWEEN 100 AND 300
ORDER BY cost;




--------------------------------------------------------------------------------------------

-- ��� ������������ �� ���������� 
SELECT 
    SUM(o.finalcost) AS TotalRevenue,
    c.login AS _name
FROM 
    _order o
JOIN 
    _client c ON o.id_client = c.id
WHERE 
    o.date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    c.login;

-- ��� �������

SELECT 
    A.name AS AreaName,
    COUNT(O.id) AS OrderCount
FROM _order O
    JOIN _area A ON O.id_aria = A.id
GROUP BY A.name
ORDER BY OrderCount DESC;

-- ����� ������� �� ���������� 

select
SUM(finalcost) AS TotalRevenue
FROM _order
WHERE date BETWEEN '2023-01-01' AND '2023-12-31';






