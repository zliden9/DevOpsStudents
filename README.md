# DevOpsStudents
-Netology
-HelloNetology
-
---
# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

# Ответ

```python

В строчке с ip не хватает " для определения строковых значенией.
Также в конце первого блока не хватает ,

    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. 
К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. 
Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. 
Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
# !/usr/bin/env python3

import socket as soc
import json
import yaml

filePython = "/home/vagrant/filePython.py"

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

while True :
  for host in web_ser:
    ip = soc.gethostbyname(host)
    if ip != web_ser[host]:
      if i==1 and init !=1:
        with open(filePython, 'a') as file1:
          print(' [ERROR] ' + str(host) +' IP mistmatch: '+ip,file=file1)
        with open(filePython+host+".json", 'w') as jsonFormFile:
            jsonForm = json.dumps({host: ip})
            jsonFormFile.write(jsonForm)
            print(jsonForm)
        with open(filePython+host+".yaml", 'w') as yamlFormFile:
            yamlForm = yaml.dump([{host: ip}])
            yamlFormFile.write(yamlForm)
            print(yamlForm)
        web_ser[host]=ip
```

### Вывод скрипта при запуске при тестировании:
```
('wide-docs.l.google.com', ['drive.google.com'], ['74.125.205.194'])
('googlemail.l.google.com', ['mail.google.com'], ['64.233.165.83', '64.233.165.17', '64.233.165.18', '64.233.165.19'])
('googlemail.l.google.com', ['mail.google.com'], ['64.233.165.83', '64.233.165.17', '64.233.165.18', '64.233.165.19'])
{"drive.google.com": "74.125.205.194"}
- drive.google.com: 74.125.205.194

{"mail.google.com": "64.233.165.83"}
- mail.google.com: 64.233.165.83

{"google.com": "173.194.73.138"}
- google.com: 173.194.73.138
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
vagrant@vagrant:~$ cat *.json
{"drive.google.com": "74.125.205.194"}{"google.com": "173.194.73.138"}{"mail.google.com": "64.233.165.83"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
vagrant@vagrant:~$ cat *.yaml
- drive.google.com: 74.125.205.194
- google.com: 173.194.73.138
- mail.google.com: 64.233.165.83
```
### Общий вывод:
```
$ ls filePython.py*
filePython.py                       filePython.pygoogle.com.json       filePython.pymail.google.com.yaml
filePython.pydrive.google.com.json  filePython.pygoogle.com.yaml
filePython.pydrive.google.com.yaml  filePython.pymail.google.com.json

$ cat filePython.py*
 [ERROR] drive.google.com IP mistmatch: 74.125.131.194
 [ERROR] mail.google.com IP mistmatch: 64.233.162.19
 [ERROR] google.com IP mistmatch: 173.194.220.101
 [ERROR] drive.google.com IP mistmatch: 64.233.165.194
 [ERROR] mail.google.com IP mistmatch: 173.194.222.18
 [ERROR] google.com IP mistmatch: 173.194.220.101
 [ERROR] drive.google.com IP mistmatch: 64.233.165.194
 [ERROR] mail.google.com IP mistmatch: 64.233.162.17
 [ERROR] google.com IP mistmatch: 173.194.222.102
 [ERROR] drive.google.com IP mistmatch: 64.233.161.194
 [ERROR] drive.google.com IP mistmatch: 64.233.165.194
 [ERROR] drive.google.com IP mistmatch: 74.125.205.194
 [ERROR] mail.google.com IP mistmatch: 64.233.165.83
 [ERROR] google.com IP mistmatch: 173.194.73.138
{"drive.google.com": "74.125.205.194"}- drive.google.com: 74.125.205.194
{"google.com": "173.194.73.138"}- google.com: 173.194.73.138
{"mail.google.com": "64.233.165.83"}- mail.google.com: 64.233.165.83
```
