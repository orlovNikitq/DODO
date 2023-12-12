use Pizza
-- Ïðåäïîëàãàåì, ÷òî 2 - ýòî èäåíòèôèêàòîð ñòàòóñà "íîâûé çàêàç"
DECLARE @newOrderStatusId INT
SET @newOrderStatusId = 2

-- Ñîçäàíèå íîâîãî çàêàçà äëÿ ïîëüçîâàòåëÿ "user2"
DECLARE @clientId INT
SELECT @clientId = id FROM _client WHERE login = 'user10'

-- Âñòàâêà íîâîãî çàêàçà
INSERT INTO _order (id_client, id_status, finalcost)
VALUES (@clientId, @newOrderStatusId, 0) -- Óñòàíàâëèâàåì íà÷àëüíîå çíà÷åíèå äëÿ finalcost

-- Ïîëó÷åíèå èäåíòèôèêàòîðà òîëüêî ÷òî âñòàâëåííîãî çàêàçà
DECLARE @orderId INT
SET @orderId = SCOPE_IDENTITY()

-- Äîáàâëåíèå ïèööû id 1
INSERT INTO _pizza_order (id_order, id_pizza, size_pizza, size_testo)
VALUES (@orderId, 1, 1, 1)

-- Äîáàâëåíèå äîáàâîê ê ïèööå id 1
INSERT INTO _addon_collection (id_order, id_pizza, id_addon_product, quantity)
VALUES
    (@orderId, 1, 1, 2),
    (@orderId, 1, 3, 1)

-- Äîáàâëåíèå ïèööû id 4
INSERT INTO _pizza_order (id_order, id_pizza, size_pizza, size_testo)
VALUES (@orderId, 4, 1, 1)

-- Äîáàâëåíèå äîáàâîê ê ïèööå id 4
INSERT INTO _addon_collection (id_order, id_pizza, id_addon_product, quantity)
VALUES
    (@orderId, 4, 4, 1),
    (@orderId, 4, 2, 1)

-- Äîáàâëåíèå ïðîäóêòà id 2
INSERT INTO _product_order (id_order, id_product, quantity)
VALUES (@orderId, 2, 5)

-- Äîáàâëåíèå ïðîäóêòà id 4
INSERT INTO _product_order (id_order, id_product, quantity)
VALUES (@orderId, 4, 2)

-- Äîáàâëåíèå êîìáî id 1
INSERT INTO _combo_order (id_order, id_combo, quantity)
VALUES (@orderId, 1, 1)

-- Äîáàâëåíèå êîìáî id 2
INSERT INTO _combo_order (id_order, id_combo, quantity)
VALUES (@orderId, 2, 1)

-- Äîáàâëåíèå êîìáî id 3
INSERT INTO _combo_order (id_order, id_combo, quantity)
VALUES (@orderId, 3, 1)

-- Ðàññ÷èòûâàåì final_price
;WITH PizzaTotals AS (
    SELECT
        po.id_order,
        po.id_pizza,
        po.size_pizza,
        po.size_testo,
        pizza.cost AS pizza_cost,
        COALESCE(SUM(ap.cost * ac.quantity), 0) AS addon_cost
    FROM
        _pizza_order po
        JOIN _pizza pizza ON po.id_pizza = pizza.id
        LEFT JOIN _addon_collection ac ON po.id_order = ac.id_order AND po.id_pizza = ac.id_pizza
        LEFT JOIN _addon_product ap ON ac.id_addon_product = ap.id
    WHERE
        po.id_order = @orderId
    GROUP BY
        po.id_order,
        po.id_pizza,
        po.size_pizza,
        po.size_testo,
        pizza.cost
),
ComboTotals AS (
    SELECT
        co.id_order,
        co.id_combo,
        co.quantity,
        combo.cost AS combo_cost
    FROM
        _combo_order co
        JOIN _combo combo ON co.id_combo = combo.id
    WHERE
        co.id_order = @orderId
)
UPDATE _order
    SET date = GETDATE();
SET finalcost = 
    COALESCE(
        (SELECT SUM(p.cost * po.quantity) FROM _product_order po JOIN _product p ON po.id_product = p.id WHERE po.id_order = @orderId), 0) +
    COALESCE(
        (SELECT SUM(pt.addon_cost * ac.quantity) FROM PizzaTotals pt JOIN _addon_collection ac ON pt.id_order = ac.id_order AND pt.id_pizza = ac.id_pizza WHERE pt.id_order = @orderId), 0) +
    COALESCE(
        (SELECT SUM((pt.pizza_cost + pt.addon_cost) * pizza_multiplier.size_multiplier * testo_multiplier.size_multiplier)
         FROM PizzaTotals pt
         JOIN (VALUES (1, 1.15), (2, 1.25), (3, 1.35)) AS pizza_multiplier(id, size_multiplier) ON pt.size_pizza = pizza_multiplier.id
         JOIN (VALUES (1, 1.15), (2, 1.25), (3, 1.35)) AS testo_multiplier(id, size_multiplier) ON pt.size_testo = testo_multiplier.id
         WHERE pt.id_order = @orderId), 0) +
    COALESCE(
        (SELECT SUM(ct.combo_cost * ct.quantity) FROM ComboTotals ct WHERE ct.id_order = @orderId), 0)
WHERE
    id = @orderId;

-- Âûâîäèì èäåíòèôèêàòîð çàêàçà è èòîãîâóþ ñóììó
SELECT id, finalcost
FROM _order
WHERE id = @orderId;
