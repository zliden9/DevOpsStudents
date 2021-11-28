# DevOpsStudents
-Netology
-HelloNetology
-
-------------------------------------------------------------------
Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"
-------------------------------------------------------------------
- 1)Работа c HTTP через телнет.
Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
отправьте HTTP запрос
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
В ответе укажите полученный HTTP код, что он означает?
```
vagrant@vagrant:~$ sudo telnet stackoverflow.com 80
Trying 151.101.65.69...
Connected to stackoverflow.com.
Escape character is '^]'.
 

GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 4dfb3659-f601-4635-ba21-a298d13f2d5c
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Sun, 28 Nov 2021 12:01:38 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19161-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1638100899.850800,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=a5dcad0b-d747-8b98-4fd9-86366239ae93; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.

Мы запросили сореджимое страцицы и получили ответ с указанием того что страница переехала 301 Moved Permanently.
Также в ответе видны некоторые найстройки страницы
```
- 2)Повторите задание 1 в браузере, используя консоль разработчика F12.
откройте вкладку Network
отправьте запрос http://stackoverflow.com
найдите первый ответ HTTP сервера, откройте вкладку Headers
укажите в ответе полученный HTTP код.
```
Request URL: http://stackoverflow.com/
Request Method: GET
Status Code: 307 Internal Redirect
Referrer Policy: strict-origin-when-cross-origin
Location: https://stackoverflow.com/
Non-Authoritative-Reason: HSTS
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36 OPR/81.0.4196.52
```
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
```
Дольше всего обрабатывался http запрос на сам сайт с получением документа
Request URL: https://stackoverflow.com/
Request Method: GET
Status Code: 200 OK
Remote Address: 151.101.65.69:443
Referrer Policy: strict-origin-when-cross-origin
Accept-Ranges: bytes
cache-control: private
Connection: keep-alive
Content-Security-Policy: upgrade-insecure-requests ; frame-ancestors 'self' https://stackexchange.com
content-type: text/html; charset=utf-8
Date: Sun, 28 Nov 2021 12:54:07 GMT
feature-policy: microphone 'none'; speaker 'none'
strict-transport-security: max-age=15552000
Transfer-Encoding: chunked
Vary: Accept-Encoding,Fastly-SSL
Via: 1.1 varnish
X-Adguard-Filtered: AdGuard for Windows; version=6.4.1814.4903
X-Cache: MISS
X-Cache-Hits: 0
X-DNS-Prefetch-Control: off
x-frame-options: SAMEORIGIN
x-request-guid: 9edf6934-6f2d-4e64-a363-9f8b06f18e42
X-Served-By: cache-fra19129-FRA
X-Timer: S1638104047.427225,VS0,VE96
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate, br
Accept-Language: en-GB,en-US;q=0.9,en;q=0.8
Connection: keep-alive
Cookie: prov=4767eb95-caf4-a6d5-0d84-ff91c61ad629; _ga=GA1.2.1274100008.1636822456; _gid=GA1.2.718111629.1638100973; OptanonAlertBoxClosed=2021-11-28T12:03:04.878Z; OptanonConsent=isIABGlobal=false&datestamp=Sun+Nov+28+2021+15%3A03%3A04+GMT%2B0300+(Moscow+Standard+Time)&version=6.10.0&hosts=&landingPath=NotLandingPage&groups=C0003%3A1%2CC0004%3A1%2CC0002%3A1%2CC0001%3A1; _gat=1
Host: stackoverflow.com
sec-ch-ua: "Opera GX";v="81", " Not;A Brand";v="99", "Chromium";v="95"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: none
Sec-Fetch-User: ?1
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36 OPR/81.0.4196.52
```
- приложите скриншот консоли браузера в ответ.
```
(СКРИН)
![Http](https://user-images.githubusercontent.com/92779046/143771759-ca27eaac-116a-4a62-8050-725c44c25910.PNG)
```
- 3)Какой IP адрес у вас в интернете?
```
37.204.205.149
```
- 4)Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
```
vagrant@vagrant:~$ whois -h whois.radb.net 37.204.205.149
route:          37.204.0.0/16
descr:          NCNET
origin:         AS42610
mnt-by:         NCNET-MNT
mnt-lower:      NCNET-MNT
created:        2012-03-27T13:32:15Z
last-modified:  2012-03-27T13:32:15Z
source:         RIPE
remarks:        ****************************
remarks:        * THIS OBJECT IS MODIFIED
remarks:        * Please note that all data that is generally regarded as personal
remarks:        * data has been removed from this object.
remarks:        * To view the original object, please query the RIPE Database at:
remarks:        * http://www.ripe.net/whois
remarks:        ****************************
```
- 5)Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? 
Воспользуйтесь утилитой traceroute
```
vagrant@vagrant:~$ sudo traceroute -IA 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (10.0.2.2) [*]  0.245 ms  0.216 ms  0.207 ms
 2  www.routerlogin.com (192.168.199.1) [*]  2.154 ms  2.147 ms  2.134 ms
 3  * * *
 4  * * *
 5  72.14.209.81 (72.14.209.81) [AS15169]  37.155 ms  37.135 ms  37.186 ms
 6  209.85.250.163 (209.85.250.163) [AS15169]  4.897 ms  2.358 ms  2.458 ms
 7  108.170.250.66 (108.170.250.66) [AS15169]  3.348 ms  2.932 ms  2.907 ms
 8  209.85.255.136 (209.85.255.136) [AS15169]  18.213 ms  20.924 ms  20.907 ms
 9  72.14.238.168 (72.14.238.168) [AS15169]  20.838 ms  20.807 ms  20.797 ms
10  172.253.70.51 (172.253.70.51) [AS15169]  21.218 ms  21.352 ms  22.362 ms
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  dns.google (8.8.8.8) [AS15169]  20.522 ms  23.366 ms  23.259 ms
```
- 6)Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
```
vagrant@vagrant:~$ mtr -rn 8.8.8.8
Start: 2021-11-28T13:34:10+0000
HOST: vagrant                     Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- 10.0.2.2                   0.0%    10    0.1   0.1   0.1   0.2   0.0
  2.|-- 192.168.199.1              0.0%    10    1.0   1.0   0.8   1.3   0.2
  3.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
  4.|-- 77.37.250.210             60.0%    10    2.9   2.4   2.2   2.9   0.3
  5.|-- 72.14.209.81               0.0%    10    3.4   3.4   3.0   3.7   0.2
  6.|-- 209.85.250.163             0.0%    10    2.9   2.6   2.3   3.2   0.3
  7.|-- 108.170.250.66             0.0%    10    3.7   3.1   2.9   3.7   0.2
  8.|-- 209.85.255.136             0.0%    10   17.3  17.5  17.3  17.8   0.2
  9.|-- 72.14.238.168              0.0%    10   17.5  19.7  17.3  32.8   5.1
 10.|-- 172.253.70.51              0.0%    10   20.2  20.8  20.1  22.5   0.7
 11.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 12.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 13.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 14.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 15.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 16.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 17.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 18.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 19.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 20.|-- 8.8.8.8                   10.0%    10   19.5  19.3  17.7  19.7   0.6
```
- Наибольшая задержка на 9 хопе.
- 
- 7)Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig
```
vagrant@vagrant:~$ dig dns.google NS +noall +answer
dns.google.             6726    IN      NS      ns1.zdns.google.
dns.google.             6726    IN      NS      ns3.zdns.google.
dns.google.             6726    IN      NS      ns4.zdns.google.
dns.google.             6726    IN      NS      ns2.zdns.google.

vagrant@vagrant:~$ dig dns.google A +noall +answer
dns.google.             121     IN      A       8.8.8.8
dns.google.             121     IN      A       8.8.4.4

8)Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig

vagrant@vagrant:~$ dig -x 8.8.8.8 +noall +answer
8.8.8.8.in-addr.arpa.   7065    IN      PTR     dns.google.
vagrant@vagrant:~$ dig -x 8.8.4.4 +noall +answer
4.4.8.8.in-addr.arpa.   7069    IN      PTR     dns.google.
```
