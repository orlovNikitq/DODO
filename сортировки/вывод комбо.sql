use Pizza
-- Assuming user2 has id = 2, you may need to adjust the condition based on your actual data
DECLARE @UserId INT;
SET @UserId = (SELECT id FROM _client WHERE login = 'user2');

-- Output the result for combo
SELECT
    co.id_order AS id_order,
    co.id_combo AS id_combo,
    c.name AS name_combo,
    co.quantity AS quantity
FROM
    _combo_order co
    LEFT JOIN _combo c ON co.id_combo = c.id
    LEFT JOIN _order o ON co.id_order = o.id
WHERE
    o.id_client = @UserId
ORDER BY
    co.id_order,
    co.id_combo;