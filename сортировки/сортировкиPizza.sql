use Pizza
--фильтрация по prefix(хит, на 2двоих и т.д.)
SELECT p.*
FROM _product p
JOIN _prefix pr ON p.id_prefix = pr.id
WHERE pr.name = 'хит';

SELECT p.*
FROM _combo p
JOIN _prefix pr ON p.id_prefix = pr.id
WHERE pr.name = 'хит';

SELECT p.*
FROM _pizza p
JOIN _prefix pr ON p.id_prefix = pr.id
WHERE pr.name = 'хит';

--------------------------------------------------------------------------------------------

--фильтрация по типу меню (детское, острое , веганское)


	SELECT p.*
FROM _pizza p
JOIN _pizza_type_menu ptm ON p.id = ptm.id_pizza
JOIN _type_menu tm ON ptm.id_type_menu = tm.id
WHERE tm.name = 'детское';

	SELECT pr.*
FROM _product pr
JOIN _product_type_menu ptm ON pr.id = ptm.id_product
JOIN _type_menu tm ON ptm.id_type_menu = tm.id
WHERE tm.name = 'острое';


--------------------------------------------------------------------------------------------

--фильтрация цены по возрастанию
-- Для продуктов
SELECT * FROM _product
ORDER BY cost ASC;

-- Для комбо
SELECT * FROM _combo
ORDER BY cost ASC;

---- Для пицц
SELECT * FROM _pizza
ORDER BY cost ASC;


--------------------------------------------------------------------------------------------

--фильтрация цены по убыванию
-- Для продуктов
SELECT * FROM _product
ORDER BY cost DESC;

-- Для комбо
SELECT * FROM _combo
ORDER BY cost DESC;

-- Для пицц
SELECT * FROM _pizza
ORDER BY cost DESC;

--------------------------------------------------------------------------------------------

--фильтрация цены в диапазоне


-- Для продуктов
SELECT * FROM _product
WHERE cost BETWEEN 100 AND 300
ORDER BY cost;

-- Для комбо
SELECT * FROM _combo
WHERE cost BETWEEN 100 AND 300
ORDER BY cost;

-- Для пицц
SELECT * FROM _pizza
WHERE cost BETWEEN 100 AND 300
ORDER BY cost;




--------------------------------------------------------------------------------------------

-- топ пользователь за промежуток 
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

-- топ районов

SELECT 
    A.name AS AreaName,
    COUNT(O.id) AS OrderCount
FROM _order O
    JOIN _area A ON O.id_aria = A.id
GROUP BY A.name
ORDER BY OrderCount DESC;

-- общая выручка за промежуток 

select
SUM(finalcost) AS TotalRevenue
FROM _order
WHERE date BETWEEN '2023-01-01' AND '2023-12-31';






