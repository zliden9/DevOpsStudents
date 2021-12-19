# DevOpsStudents
-Netology
-HelloNetology
-
---
# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | ???  |
| Как получить для переменной `c` значение 12?  | ???  |
| Как получить для переменной `c` значение 3?  | ???  |

```
1) Будет ошибка TypeError: unsupported operand type(s) for +: 'int' and 'str', что означает что разность типа переменных не позволяет выполнить арифметичесское произведение.
2) Нужно переменную а превратить в stp: a = '1'
3) Нужно переменную b превратить в int: b = 2
```

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, 
какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, 
потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 
Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```
Переменная is_change в данном случае лишняя
break в рамках обработки запроса прерывает вывод после первого прохода и в результате мы не получает выод со всеми изменениями.
```
```python
#!/usr/bin/env python3

import os

bash_command = ["cd /home/vagrant/DevOpsStudents", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~/DevOpsStudents$ git status
On branch circleci-project-setup
Your branch is ahead of 'origin/circleci-project-setup' by 3 commits.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   nanana.txt
        modified:   pyTest.py

no changes added to commit (use "git add" and/or "git commit -a")
vagrant@vagrant:~/DevOpsStudents$ cd ../
vagrant@vagrant:~$ python3.8 pythonTest.py
nanana.txt
pyTest.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, 
а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. 
Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
```
Для приёма входящих аргументо добавил модуль sys. Далее для обработки запроса исползовал метод .argv[1]
```
### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

pwd = sys.argv[1]
bash_command = ["cd "+pwd, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified: ', '')
        print(pwd)
	print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/DevOpsStudents# python3.8 pyTest.py /home/vagrant/DevOpsStudents/
/home/vagrant/DevOpsStudents/
  nanana.txt
/home/vagrant/DevOpsStudents/
  pyTest.py
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http.
 Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, 
за DNS прячется конкретный IP сервера, где установлен сервис. 
Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, 
поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. 
Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, 
который недоступен для разработчиков. 
Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, 
выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, 
должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. 
Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. 
Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.
```
С помощью подгруженного модуля socket собераем пул доступных адресов для их послудущего мониторинга.
```
### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket as soc

wait = 3
soc1 = soc.gethostbyname_ex('drive.google.com')
soc2 = soc.gethostbyname_ex('mail.google.com')
soc3 = soc.gethostbyname_ex('google.com')

web_ser = {'drive.google.com':soc1, 'mail.google.com':soc2, 'google.com':soc3}
print(str(web_ser['drive.google.com']))
print(str(web_ser['mail.google.com']))
print(str(web_ser['mail.google.com']))

i = 1
init = 0

while 1==1 :
  for host in web_ser:
    ip = soc.gethostbyname(host)
    if ip != web_ser[host]:
      if i==1 and init !=1:
        print(' [ERROR] ' + str(host) +' IP mistmatch: '+ip)
      web_ser[host]=ip
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant# vim TestIPsousese.py
root@vagrant:/home/vagrant# python3.8 TestIPsousese.py
('wide-docs.l.google.com', ['drive.google.com'], ['142.251.1.194'])
('googlemail.l.google.com', ['mail.google.com'], ['74.125.131.83', '74.125.131.18', '74.125.131.19', '74.125.131.17'])
('googlemail.l.google.com', ['mail.google.com'], ['74.125.131.83', '74.125.131.18', '74.125.131.19', '74.125.131.17'])
 [ERROR] drive.google.com IP mistmatch: 142.251.1.194
 [ERROR] mail.google.com IP mistmatch: 74.125.131.83
 [ERROR] google.com IP mistmatch: 209.85.233.102
```
