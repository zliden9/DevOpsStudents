# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```bash
ad@ad-VirtualBox:~$ sudo docker run -it --name post -e POSTGRES_PASSWORD=123 -d postgres:13-alpine
ad@ad-VirtualBox:~$ sudo docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS         PORTS      NAMES
55dbcea61159   postgres:13-alpine   "docker-entrypoint.s…"   11 seconds ago   Up 5 seconds   5432/tcp   post
ad@ad-VirtualBox:~$ sudo docker cp git/virt-homeworks/06-db-04-postgresql/test_data/test_dump.sql post:/var/lib/postgresql/data/test_dump.sql
ad@ad-VirtualBox:~$ sudo docker exec -it post bash
bash-5.1# ls /var/lib/postgresql/data/test_dump.sql 
/var/lib/postgresql/data/test_dump.sql
```
Подключитесь к БД PostgreSQL используя `psql`.
```bash
d@ad-VirtualBox:~$ sudo docker exec -it post bash
bash-5.1# ls
bin                         etc                         media                       proc                        sbin                        tmp
dev                         home                        mnt                         root                        srv                         usr
docker-entrypoint-initdb.d  lib                         opt                         run                         sys                         var
bash-5.1# pwd
/
bash-5.1# pos
posixtz     postgres    postmaster  
bash-5.1# su postgres
/ $ psql
psql (13.7)
Type "help" for help.

postgres=# 
```
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
```bash
postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
```
**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
\l[+]   [PATTERN]      list databases
```
- подключения к БД
```
 \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
- вывода списка таблиц
```
 \dt[S+] [PATTERN]      list tables
```
- вывода описания содержимого таблиц
```
\d[S+]                 list tables, views, and sequences
```
- выхода из psql
```
\q                     quit psql
```
## Задача 2

Используя `psql` создайте БД `test_database`.
```bash
CREATE DATABASE test_database;
CREATE DATABASE
postgres=# 
```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).
Восстановите бэкап БД в `test_database`.
```bash
/ $ psql  test_database < /var/lib/postgresql/data/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
/ $ 
```
Перейдите в управляющую консоль `psql` внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```bash
/ $ psql -d test_database
psql (13.7)
Type "help" for help.

test_database=# ANALYZE;
ANALYZE
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```bash
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=# select max(avg_width) from pg_stats where tablename='orders';
 max 
-----
  16
(1 row)
SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders';
 attname | avg_width 
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```bash
#Переименовываем осносную таблицу и проверяем целостность.
test_database=# alter table public.orders rename to orders_old;
ALTER TABLE
test_database=# \d public.orders_old
                                 Table "public.orders_old"
 Column |         Type          | Collation | Nullable |              Default               
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null | 
 price  | integer 
 test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders_old';
 attname | avg_width 
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
#Создаём новую и копируем данные из старой таблицы.
test_database=# create table public.orders (like public.orders_old including all);
CREATE TABLE
#Создаём связанные таблицы в которые будут складываться сортированные данные.
test_database=# create table public.orders_1_more499 (check (price>499)) inherits (public.orders);
CREATE TABLE
test_database=# create table public.orders_2_less499 (check (price<499)) inherits (public.orders);
CREATE TABLE
#Добавляем правила сортировки по числовому значению.
test_database=# create rule orders_2_less499 as on insert to public.orders where (price<499) do instead insert into public.orders_2_less499 values(NEW.*);
CREATE RULE
test_database=# create rule orders_1_more499 as on insert to public.orders where (price>499) do instead insert into public.orders_1_more499 values(NEW.*);
CREATE RULE
#Проверяем.
test_database=# SELECT * FROM orders_1_more499;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(6 rows)

test_database=# SELECT * FROM orders_2_less499;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(8 rows)
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
```
Если при создании основной таблицы прикрутить подтаблицы с указанными выше правилами сортировки, то ручное разбиение можно было исключить.
```
## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```bash
/ $ pg_dump -U postgres -W test_database > /var/lib/postgresql/data/test_new_dump_.sql
Password: 
/ $ ls -li /var/lib/postgresql/data/test_new_dump_.sql 
1089727 -rw-r--r--    1 postgres postgres      5743 Jun  3 16:36 /var/lib/postgresql/data/test_new_dump_.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```bash
#Можно в CREATE TABLE добавить тэг UNIQUE.
/ $ vi /var/lib/postgresql/data/test_new_dump_.sql
-- PostgreSQL database dump                                                                                    
--                                                                                                             
                                                                                                               
-- Dumped from database version 13.7                                                                           
-- Dumped by pg_dump version 13.7                                                                              
                                                                                                               
SET statement_timeout = 0;                                                                                     
SET lock_timeout = 0;                                                                                          
SET idle_in_transaction_session_timeout = 0;                                                                   
SET client_encoding = 'UTF8';                                                                                  
SET standard_conforming_strings = on;                                                                          
SELECT pg_catalog.set_config('search_path', '', false);                                                        
SET check_function_bodies = false;                                                                             
SET xmloption = content;                                                                                       
SET client_min_messages = warning;                                                                             
SET row_security = off;                                                                                        
                                                                                                               
SET default_tablespace = '';                                                                                   
                                                                                                               
SET default_table_access_method = heap;                                                                        
                                                                                                               
--                                                                                                             
-- Name: orders_old; Type: TABLE; Schema: public; Owner: postgres                                              
--                                                                                                             
                                                                                                               
CREATE TABLE public.orders_old (                                                                               
    id integer NOT NULL,                                                                                       
    title character varying(80) NOT NULL,                                                                      
    price integer DEFAULT 0                                                                                    
    CONSTRAINT title_unique UNIQUE(title)                                                                      
); 
```
---
