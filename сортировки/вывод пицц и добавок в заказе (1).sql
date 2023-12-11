use Pizza
-- Assuming user2 has id = 2, you may need to adjust the condition based on your actual data
DECLARE @UserId INT;
SET @UserId = (SELECT id FROM _client WHERE login = 'user2');

-- Retrieve orders for the user
WITH UserOrders AS (
    SELECT
        o.id AS order_id,
        o.finalcost,
        po.id_pizza,
        po.size_pizza,
        po.size_testo,
        pc.id_combo,
        pc.quantity AS combo_quantity,
        pp.id AS pizza_id,
        pp.name AS pizza_name,
        c.name AS combo_name,
        pac.id_addon_product,
        pac.quantity AS addon_quantity,
        pap.name AS addon_name
    FROM
        _order o
        INNER JOIN _pizza_order po ON o.id = po.id_order
        LEFT JOIN _combo_order pc ON o.id = pc.id_order
        LEFT JOIN _pizza pp ON po.id_pizza = pp.id
        LEFT JOIN _combo c ON pc.id_combo = c.id
        LEFT JOIN _addon_collection pac ON po.id_pizza = pac.id_pizza AND o.id = pac.id_order
        LEFT JOIN _addon_product pap ON pac.id_addon_product = pap.id
    WHERE
        o.id_client = @UserId
)

-- Output the result
SELECT DISTINCT
    uo.order_id,
    uo.finalcost,
    CASE
        WHEN uo.pizza_id IS NOT NULL THEN 'pizza'
        WHEN uo.id_combo IS NOT NULL THEN 'combo'
        WHEN uo.id_addon_product IS NOT NULL THEN 'addon'
    END AS table_type,
    CASE
        WHEN uo.pizza_id IS NOT NULL THEN uo.pizza_id
        WHEN uo.id_combo IS NOT NULL THEN uo.id_combo
        WHEN uo.id_addon_product IS NOT NULL THEN uo.id_addon_product
    END AS id,
    CASE
        WHEN uo.pizza_id IS NOT NULL THEN uo.pizza_name
        WHEN uo.id_combo IS NOT NULL THEN uo.combo_name
        WHEN uo.id_addon_product IS NOT NULL THEN uo.addon_name
    END AS name,
    CASE
        WHEN uo.pizza_id IS NOT NULL THEN uo.size_pizza
        WHEN uo.id_combo IS NOT NULL THEN NULL
        WHEN uo.id_addon_product IS NOT NULL THEN NULL
    END AS size_pizza,
    uo.size_testo,
    pap.id AS addon_id,
    pap.name AS addon_name,
    CASE
        WHEN uo.id_addon_product IS NOT NULL THEN uo.addon_quantity
        WHEN uo.id_combo IS NOT NULL THEN uo.combo_quantity
        WHEN uo.pizza_id IS NOT NULL THEN 1 -- Quantity for pizza (assuming 1 pizza)
    END AS quantity
FROM
    UserOrders uo
LEFT JOIN _addon_product pap ON uo.id_addon_product = pap.id
ORDER BY
    uo.order_id,
    table_type,
    id;