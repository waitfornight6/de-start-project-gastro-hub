/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/
create schema IF NOT EXISTS cafe;

CREATE TYPE cafe.restaurant_type AS ENUM (
'coffee_shop',
'restaurant',
'bar',
'pizzeria'
);


CREATE TABLE IF NOT EXISTS cafe.restaurants (
restaurant_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
name TEXT NOT NULL,
type cafe.restaurant_type NOT NULL,
menu JSONB
);


CREATE TABLE IF NOT EXISTS cafe.managers (
    manager_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
    name TEXT,
    phone VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates (
restaurant_uuid UUID NOT NULL,
manager_uuid UUID NOT NULL,
start_date DATE,
end_date DATE,
PRIMARY KEY (restaurant_uuid, manager_uuid),
FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid)
);


CREATE TABLE IF NOT EXISTS cafe.sales (
date DATE NOT NULL,
restaurant_uuid UUID NOT NULL,
avg_check DECIMAL(10, 2),
PRIMARY KEY (date, restaurant_uuid),
FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid)
);
