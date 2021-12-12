# DevOpsStudents
-Netology
-HelloNetology
-
-------------------------------------------------------------------
Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
-------------------------------------------------------------------
- 1)Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

- ![bitwarden](https://user-images.githubusercontent.com/92779046/145690764-a46730a7-5f49-4ed6-85bb-b8e0441d0a26.PNG)

- 2)Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
``` 
Пользуюсь YandexKey, установил на него.
```
- 3)Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
```
sudo apt install apache2
vagrant@vagrant:~$ pstree
systemd─┬─VBoxService───8*[{VBoxService}]
        ├─accounts-daemon───2*[{accounts-daemon}]
        ├─agetty
        ├─apache2───2*[apache2───26*[{apache2}]]
vagrant@vagrant:~$ sudo a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Module socache_shmcb already enabled
Module ssl already enabled
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
> -keyout /etc/ssl/private/apache-selfsigned.key \
> -out /etc/ssl/certs/apache-selfsigned.crt \
> -subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=www.example.com"
Generating a RSA private key
.................+++++
........+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
vagrant@vagrant:~$ sudo systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2021-12-11 19:20:35 UTC; 6min ago
       Docs: https://httpd.apache.org/docs/2.4/
    Process: 13962 ExecStart=/usr/sbin/apachectl start (code=exited, status=0/SUCCESS)
    Process: 14140 ExecReload=/usr/sbin/apachectl graceful (code=exited, status=0/SUCCESS)
   Main PID: 13976 (apache2)
      Tasks: 55 (limit: 1071)
     Memory: 6.6M
     CGroup: /system.slice/apache2.service
             ├─13976 /usr/sbin/apache2 -k start
             ├─14144 /usr/sbin/apache2 -k start
             └─14145 /usr/sbin/apache2 -k start
```

- ![apach](https://user-images.githubusercontent.com/92779046/145690786-2b62942d-f9b1-41ef-be70-b471cc2793c3.PNG)

- 4)Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и - - тому подобное).
```
vagrant@vagrant:~$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git
Cloning into 'testssl.sh'...
remote: Enumerating objects: 100, done.
remote: Counting objects: 100% (100/100), done.
remote: Compressing objects: 100% (93/93), done.
remote: Total 100 (delta 14), reused 39 (delta 6), pack-reused 0
Receiving objects: 100% (100/100), 8.55 MiB | 6.17 MiB/s, done.
Resolving deltas: 100% (14/14), done.
vagrant@vagrant:~$ cd testssl.sh

vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://www.google.com/

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (6da72bc 2021-12-10 20:16:28 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


Testing all IPv4 addresses (port 443): 74.125.131.99 74.125.131.106 74.125.131.147 74.125.131.104 74.125.131.105 74.125.131.103
--------------------------------------------------------------------------------
 Start 2021-12-11 19:38:57        -->> 74.125.131.99:443 (www.google.com) <<--

 Further IP addresses:   74.125.131.106 74.125.131.147 74.125.131.104 74.125.131.105 74.125.131.103
                         2a00:1450:4010:c0e::67 2a00:1450:4010:c0e::93 2a00:1450:4010:c0e::68 2a00:1450:4010:c0e::63
 rDNS (74.125.131.99):   lu-in-f99.1e100.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "br gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=7ACD7CE539A67DEFE216110170CE58B3D5400BA8ADF1C31F9FDA2E904340FC89 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA
                                                 ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-11 19:39:34 [  39s] -->> 74.125.131.99:443 (www.google.com) <<--

--------------------------------------------------------------------------------
 Start 2021-12-11 19:39:34        -->> 74.125.131.106:443 (www.google.com) <<--

 Further IP addresses:   74.125.131.99 74.125.131.147 74.125.131.104 74.125.131.105 74.125.131.103
                         2a00:1450:4010:c0e::67 2a00:1450:4010:c0e::93 2a00:1450:4010:c0e::68 2a00:1450:4010:c0e::63
 rDNS (74.125.131.106):  lu-in-f106.1e100.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)

Дальше Очень большая портянка.
```
- 5)Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
```
vagrant@vagrant:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:SUHd5dXOrzihZMUDRUffzaE8b9FdjVBab2j1+LhniLY vagrant@vagrant
The key's randomart image is:
+---[RSA 3072]----+
|       .o. ++=*o*|
|         .o o=oO@|
|        .  o.+=+@|
|       . .  +.o++|
|        S  . ..oo|
|          o ...o.|
|         o .ooo.o|
|          ..o..o |
|            E.   |
+----[SHA256]-----+

vagrant@vagrant:~$ ssh-copy-id vagrant@192.168.199.10
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
The authenticity of host '192.168.199.10 (192.168.199.10)' can't be established.
ECDSA key fingerprint is SHA256:wSHl+h4vAtTT7mbkj2lbGyxWXWTUf6VUliwpncjwLPM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@192.168.199.10's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@192.168.199.10'"
and check to make sure that only the key(s) you wanted were added.

vagrant@vagrant:~$ ssh vagrant@192.168.199.10
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 11 Dec 2021 07:50:00 PM UTC

  System load:           0.0
  Usage of /:            2.5% of 61.31GB
  Memory usage:          19%
  Swap usage:            0%
  Processes:             120
  Users logged in:       1
  IPv4 address for eth0: 192.168.199.10
  IPv6 address for eth0: 2a02:2168:91ba:400:b8c2:2d1:5c86:faea


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sat Dec 11 19:43:39 2021 from 192.168.199.2
```
- 6)Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
```
vagrant@vagrant:~$ cp ~/.ssh/id_rsa ~/.ssh/id_rsa1
vagrant@vagrant:~$ ls -li ~/.ssh/id_rs*
262148 -rw------- 1 vagrant vagrant 2602 Dec 11 19:48 /home/vagrant/.ssh/id_rsa
262152 -rw------- 1 vagrant vagrant 2602 Dec 11 19:57 /home/vagrant/.ssh/id_rsa1

vagrant@vagrant:~$ mkdir -p ~/.ssh && chmod 700 ~/.ssh
vagrant@vagrant:~$ sudo vim ~/.ssh/config && chmod 600 ~/.ssh/config

Host vagrant
 HostName 192.168.199.10
 IdentityFile ~/.ssh/id_rsa1
 User vagrant
 #Port 2222
 #StrictHostKeyChecking no
#Host *
 User vagrant
 IdentityFile ~/.ssh/id_rsa1
 Protocol 2

vagrant@vagrant:~$ ssh vagrant
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 11 Dec 2021 08:07:16 PM UTC

  System load:           0.0
  Usage of /:            2.5% of 61.31GB
  Memory usage:          19%
  Swap usage:            0%
  Processes:             122
  Users logged in:       1
  IPv4 address for eth0: 192.168.199.10
  IPv6 address for eth0: 2a02:2168:91ba:400:b8c2:2d1:5c86:faea


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sat Dec 11 20:06:40 2021 from 192.168.199.10
```
- 7)Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
```
vagrant@vagrant:~$ tcpdump -D
1.eth0 [Up, Running]
2.lo [Up, Running, Loopback]
3.any (Pseudo-device that captures on all interfaces) [Up, Running]
4.bluetooth-monitor (Bluetooth Linux Monitor) [none]
5.nflog (Linux netfilter log (NFLOG) interface) [none]
6.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]

vagrant@vagrant:~$ sudo tcpdump -w test.pcap -c 100 -i eth0
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
103 packets received by filter
0 packets dropped by kernel

vagrant@vagrant:~$ apt show wireshark
Package: wireshark
Version: 3.2.3-1
Priority: optional
Section: universe/net
Origin: Ubuntu
Maintainer: Balint Reczey <rbalint@ubuntu.com>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 59.4 kB
Depends: wireshark-qt (= 3.2.3-1)
Conflicts: ethereal (<< 1.0.0-3)
Replaces: ethereal (<< 1.0.0-3)
Homepage: https://www.wireshark.org/
Download-Size: 5,088 B
APT-Manual-Installed: yes
APT-Sources: http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages
Description: network traffic analyzer - meta-package
 Wireshark is a network "sniffer" - a tool that captures and analyzes
 packets off the wire. Wireshark can decode too many protocols to list
 here.
 .
 This is a meta-package for Wireshark.
```

---
Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"
---
- 1) Обязательная задача 1
Есть скрипт:

a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
Какие значения переменным c,d,e будут присвоены? Почему?

Переменная	Значение	Обоснование
a	???	???
b	???	???
c	???	???

```
vagrant@vagrant:~$ a=1
vagrant@vagrant:~$ b=2
vagrant@vagrant:~$ c=a+b
vagrant@vagrant:~$ echo $c
a+b
#По умолчанию bash воспринемает все значения как строку
vagrant@vagrant:~$ d=$a+$b
vagrant@vagrant:~$ echo $d
1+2
#Аналогичная ситуация, переменны были объявлены с их значениями но небыло инициализации выражения для int значений
vagrant@vagrant:~$ e=$(($a+$b))
vagrant@vagrant:~$ echo $e
3
#Теперь мы объявили глобальную переменную с экранированием $((_)) по которому bash понимает что мы хотим выполнить арефметичесское вырожение

```
- 2) Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. 
Проверять доступность необходимо пять раз для каждого узла.

Ваш скрипт:
???
```
По какойто причине в моей оболочке bash при объявлении массивов возникала ошибка "script.sh: 1: Syntax error: "(" unexpected"
Поэтому проверить работоспособность полноценно не получилось, в нужных местах объявлял host=87.250.250.24 и использовал как обычную не массив переменную.
Для запуска скриптов с массивами писал bash --posix script.sh, скрипты вроде отработали как должны.
```
```
В объявленном цикле не хватает `)`
Также можно добавить оператор ожидания sleep
При успешном выполнении нужно перейти к проверке следущего адреса, для этого вводим оператор break,
но для непрерывной проверки можно не добавлять
```
```
#!/usr/bin/env bash
host=(192.168.0.1 173.194.222.113 87.250.250.24)
sleep 2
for i in {1..5}
do
date >>curl.log
    for b in ${host[@]}
    do
        curl -Is $b:80 >/dev/null
        echo "$b $? >>curl.log
    done
done
```
- 3) Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. 
Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

Ваш скрипт:
???
```
#!/usr/bin/env bash
host=(192.168.0.1 173.194.222.113 87.250.250.24)
up=0
sleep 2

while (($up == 0))
do
    for b in ${host[@]}
    do
	curl -Is $b:80 >/dev/null
	up=$?
	if (($up != 0))
	then
	    echo $b >>error.log
	fi
    done
done
```
