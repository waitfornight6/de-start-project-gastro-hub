/*добавьте сюда запросы для решения задания 6*/
BEGIN TRANSACTION;

WITH cafes_with_cappuccino AS (
SELECT 
r.restaurant_uuid,
r.menu
FROM 
cafe.restaurants r
WHERE 
r.menu::text LIKE '%капучино%'
FOR UPDATE OF r
),
updated_menu AS (
SELECT 
restaurant_uuid,
jsonb_set(
menu,
'{Напитки,капучино,цена}',
jsonb_build_object('value', ROUND((menu->'Напитки'->'капучино'->>'цена')::numeric * 1.2, 2))->'value'
) AS new_menu
FROM 
cafes_with_cappuccino
)
UPDATE cafe.restaurants r
SET menu = u.new_menu
FROM updated_menu u
WHERE r.restaurant_uuid = u.restaurant_uuid;

COMMIT;