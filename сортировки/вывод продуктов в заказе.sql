use Pizza
-- Assuming user2 has id = 2, you may need to adjust the condition based on your actual data
DECLARE @UserId INT;
SET @UserId = (SELECT id FROM _client WHERE login = 'user2');

-- Output the result
SELECT
    po.id_order AS id_order,
    po.id_product AS id_product,
    p.name AS product_name,
    po.quantity AS quantity
FROM
    _product_order po
    LEFT JOIN _product p ON po.id_product = p.id
    LEFT JOIN _order o ON po.id_order = o.id
WHERE
    o.id_client = @UserId
ORDER BY
    po.id_order,
    po.id_product;