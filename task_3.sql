/*добавьте сюда запрос для решения задания 3*/
CREATE OR REPLACE VIEW cafe.top_rest_by_manager_change AS
WITH manager_change AS (
SELECT 
r.name AS "Название заведения",
COUNT(DISTINCT w.manager_uuid) - 1 AS "Сколько раз менялся менеджер"
FROM 
cafe.restaurant_manager_work_dates w
JOIN 
cafe.restaurants r ON w.restaurant_uuid = r.restaurant_uuid
GROUP BY 
r.name
HAVING 
COUNT(DISTINCT w.manager_uuid) > 1
)
SELECT 
"Название заведения",
"Сколько раз менялся менеджер"
FROM 
manager_change
ORDER BY 
"Сколько раз менялся менеджер" DESC,
"Название заведения"
LIMIT 3
;
