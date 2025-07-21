/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/

INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT 
s.manager AS name,
s.manager_phone AS phone
FROM 
raw_data.sales s
LEFT JOIN 
cafe.managers m ON s.manager = m.name AND s.manager_phone = m.phone
WHERE 
s.manager IS NOT NULL
AND s.manager_phone IS NOT NULL
AND m.manager_uuid IS NULL;


INSERT INTO cafe.restaurants (name, type, menu)
SELECT DISTINCT
s.cafe_name AS name,
s.type::cafe.restaurant_type AS type,
m.menu AS menu
FROM
raw_data.sales s
JOIN
raw_data.menu m ON s.cafe_name = m.cafe_name
WHERE
NOT EXISTS (
SELECT 1
FROM cafe.restaurants r
WHERE r.name = s.cafe_name
);


INSERT INTO cafe.restaurant_manager_work_dates (
restaurant_uuid,
manager_uuid,
start_date,
end_date
)
SELECT 
r.restaurant_uuid,
m.manager_uuid,
MIN(s.report_date) AS start_date,
MAX(s.report_date) AS end_date
FROM 
raw_data.sales s
JOIN 
cafe.restaurants r ON s.cafe_name = r.name
JOIN 
cafe.managers m ON s.manager = m.name AND s.manager_phone = m.phone
GROUP BY 
r.restaurant_uuid, m.manager_uuid;


INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT 
s.report_date AS date,
r.restaurant_uuid,
s.avg_check
FROM 
raw_data.sales s
JOIN 
cafe.restaurants r ON s.cafe_name = r.name
WHERE 
NOT EXISTS (
SELECT 1 
FROM cafe.sales сs 
WHERE сs.date = s.report_date 
AND сs.restaurant_uuid = r.restaurant_uuid
);
