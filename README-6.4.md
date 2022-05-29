# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```bash
ad@ad-VirtualBox:~$ sudo docker pull postgres:13
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13
ad@ad-VirtualBox:~$ sudo mkdir -p /opt/postgres13/backup
ad@ad-VirtualBox:~$ sudo mkdir -p /opt/postgres13/data
ad@ad-VirtualBox:~$ sudo docker run --rm --name postgr -ti -e POSTGRES_PASSWORD=123 -d -p 5432:5432 -v /opt/postgres13/data/:/var/lib/postgresql/data -v /opt/postgres13/backup:/var/lib/postgresql/backup -d postgres:13 /bin/bash
a682dc00e202f7eb3beffaad2aa53970b6f934326e41a0be2226bbb5b02ee606
ad@ad-VirtualBox:~$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
a682dc00e202   postgres:13   "docker-entrypoint.s…"   7 seconds ago   Up 5 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgr
ad@ad-VirtualBox:~$ sudo docker cp git/virt-homeworks/06-db-04-postgresql/test_data/test_dump.sql postgr:/var/lib/postgresql/data/test_dump.sql
```
Подключитесь к БД PostgreSQL используя `psql`.
```bash
ad@ad-VirtualBox:~$ sudo docker exec -ti postgr /bin/bash
root@a682dc00e202:/# su postgres
```
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
```bash

```
**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---
