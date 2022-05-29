# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```bash
ad@ad-VirtualBox:~$ sudo docker pull mysql:8
ad@ad-VirtualBox:~$ sudo docker image ls | grep mysql
mysql                      8         65b636d5542b   29 hours ago   524MB
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.
```bash
ad@ad-VirtualBox:~$ sudo docker cp git/virt-homeworks/06-db-03-mysql/test_data/test_dump.sql mysql-hw:/etc/mysql/backup

ad@ad-VirtualBox:~$ sudo docker run --name mysql -e MYSQL_ROOT_PASSWORD=123 -d mysql:8.0
5f698fd136d930a241ea6c2de71339509c1497465dc8108cf8bfd143702500e3
ad@ad-VirtualBox:~$ sudo docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                 NAMES
5f698fd136d9   mysql:8.0   "docker-entrypoint.s…"   6 seconds ago   Up 4 seconds   3306/tcp, 33060/tcp   mysql
```
Перейдите в управляющую консоль `mysql` внутри контейнера.
```bash
ad@ad-VirtualBox:~$ sudo docker exec -it mysql bash
root@5f698fd136d9:/# mysql -u root -p
```
Используя команду `\h` получите список управляющих команд.
```bash
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

mysql> 
```
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```bash
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		14
Current database:	test_db
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.29 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			19 min 21 sec

Threads: 2  Questions: 79  Slow queries: 0  Opens: 161  Flush tables: 3  Open tables: 79  Queries per second avg: 0.068
--------------

```
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```bash
ad@ad-VirtualBox:~$ sudo docker cp git/virt-homeworks/06-db-03-mysql/test_data/test_dump.sql mysql:/etc/mysql/test_dump.sql

root@5f698fd136d9:/# mysql -u root -p test_db < /etc/mysql/test_dump.sql
root@5f698fd136d9:/# mysql -u root -p
use test_db
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

mysql> 
mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> 

```
**Приведите в ответе** количество записей с `price` > 300.
```bash
mysql> select count(*) from orders where price>300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```bash
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    ->  PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```bash
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

mysql> 
```
## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

```bash
mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

```
Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```bash
mysql> SELECT table_name, engine FROM information_schema.TABLES WHERE table_schema = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> 
```
Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
```bash
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.12 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.18 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> 
mysql> SHOW PROFILES;
+----------+------------+----------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                |
+----------+------------+----------------------------------------------------------------------+
|        1 | 0.00072525 | SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user = 'test' |
|        2 | 0.00563075 | GRANT SELECT ON test_db.* TO 'test'@'localhost'                      |
|        3 | 0.00018225 | SET profiling = 1                                                    |
|        4 | 0.04384425 | ALTER TABLE orders ENGINE = MyISAM                                   |
|        5 | 0.04904225 | ALTER TABLE orders ENGINE = InnoDB                                   |
+----------+------------+----------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)
```
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---
