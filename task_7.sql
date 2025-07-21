/*добавьте сюда запросы для решения задания 6*/
BEGIN TRANSACTION;
LOCK TABLE cafe.managers IN ACCESS EXCLUSIVE MODE;

ALTER TABLE cafe.managers 
ADD COLUMN IF NOT EXISTS phone_numbers TEXT[];

WITH numbered_managers AS (
SELECT 
manager_uuid,
phone,
ROW_NUMBER() OVER (ORDER BY name) + 99 AS manager_number
FROM 
cafe.managers
)
UPDATE cafe.managers m
SET 
phone_numbers = ARRAY[
CONCAT('8-800-2500-', nm.manager_number::text),
nm.phone
]
FROM 
numbered_managers nm
WHERE 
m.manager_uuid = nm.manager_uuid;

ALTER TABLE cafe.managers DROP COLUMN IF EXISTS phone;

COMMIT;
