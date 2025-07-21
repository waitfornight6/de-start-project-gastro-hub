/*добавьте сюда запрос для решения задания 4*/
WITH pizza_count AS (
SELECT 
r.name AS "Название заведения",
(SELECT COUNT(*) FROM jsonb_each_text(r.menu->'Пицца')) AS "Количество пицц в меню"
FROM 
cafe.restaurants r
WHERE 
r.type = 'pizzeria'::cafe.restaurant_type
AND r.menu ? 'Пицца'
),
ranked_pizzerias AS (
SELECT 
*,
DENSE_RANK() OVER (ORDER BY "Количество пицц в меню" DESC) AS rank
FROM 
pizza_count
)
SELECT 
"Название заведения",
"Количество пицц в меню"
FROM 
ranked_pizzerias
WHERE 
rank = 1
ORDER BY 
"Название заведения";
