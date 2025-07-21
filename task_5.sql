/*добавьте сюда запрос для решения задания 5*/
WITH menu_cte AS (
SELECT 
r.name AS "Название заведения",
'Пицца' AS "Тип блюда",
pizza.key AS "Название пиццы",
(pizza.value::text)::integer AS "Цена"
FROM 
cafe.restaurants r,
jsonb_each_text(r.menu->'Пицца') AS pizza
WHERE 
r.type = 'pizzeria'::cafe.restaurant_type
AND r.menu ? 'Пицца'
),
menu_with_rank AS (
SELECT 
*,
ROW_NUMBER() OVER (
PARTITION BY "Название заведения"
ORDER BY "Цена" DESC
) AS price_rank
FROM 
menu_cte
)
SELECT 
"Название заведения",
"Тип блюда",
"Название пиццы",
"Цена"
FROM 
menu_with_rank
WHERE 
price_rank = 1
ORDER BY 
"Название заведения" ASC;