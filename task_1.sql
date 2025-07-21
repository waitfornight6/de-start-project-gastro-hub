/*добавьте сюда запрос для решения задания 1*/
CREATE OR REPLACE VIEW cafe.top_restaurants AS
WITH restaurant_avg AS (
SELECT 
r.restaurant_uuid,
r.name AS "Название заведения",
r.type AS "Тип заведения",
ROUND(AVG(s.avg_check)::numeric, 2) AS "Средний чек"
FROM 
cafe.sales s
INNER JOIN 
cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
GROUP BY 
r.restaurant_uuid, r.name, r.type
),
ranked_restaurants AS (
SELECT 
*,
ROW_NUMBER() OVER (
PARTITION BY "Тип заведения"
ORDER BY "Средний чек" DESC
) AS rank
FROM 
restaurant_avg
)
SELECT 
"Название заведения",
"Тип заведения", 
"Средний чек"
FROM 
ranked_restaurants
WHERE 
rank <= 3
ORDER BY 
"Тип заведения",
rank;
