/*добавьте сюда запрос для решения задания 2*/
CREATE MATERIALIZED VIEW cafe.year_avg_changes AS
WITH year_avg AS (
SELECT 
EXTRACT(YEAR FROM s.date)::integer AS year,
s.restaurant_uuid,
ROUND(AVG(s.avg_check)::numeric, 2) AS cur_year_avg
FROM 
cafe.sales s
WHERE 
EXTRACT(YEAR FROM s.date) != 2023
GROUP BY 
EXTRACT(YEAR FROM s.date), s.restaurant_uuid
),
prev_year AS (
SELECT 
y.year,
r.name AS "Название заведения",
r.type AS "Тип заведения",
y.cur_year_avg AS "Средний чек в текущем году",
LAG(y.cur_year_avg) OVER (
PARTITION BY y.restaurant_uuid 
ORDER BY y.year
) AS "Средний чек в предыдущем году",
ROUND(
(y.cur_year_avg - LAG(y.cur_year_avg) OVER (
PARTITION BY y.restaurant_uuid 
ORDER BY y.year
)) / LAG(y.cur_year_avg) OVER (
PARTITION BY y.restaurant_uuid 
ORDER BY y.year
) * 100, 2
) AS "Изменение среднего чека в %"
FROM 
year_avg y
JOIN 
cafe.restaurants r ON y.restaurant_uuid = r.restaurant_uuid
)
SELECT 
year AS "Год",
"Название заведения",
"Тип заведения",
"Средний чек в текущем году",
"Средний чек в предыдущем году",
"Изменение среднего чека в %"
FROM 
prev_year
ORDER BY 
"Название заведения",
"Год"
;
