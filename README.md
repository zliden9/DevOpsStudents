# DevOpsStudents
-Netology
-HelloNetology
-
-------------------------------------------------------------------
Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"
-------------------------------------------------------------------
- 1)Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
```
Для Windows это ipconfig /all, netsh interface show interface
Для Linux это ifconfig,  ip link show
```
- 2)Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
```
Протокол Neighbor Discovery Protocol, NDP
Этот протокол устанавливает пять различных типов пакета ICMPv6 для выполнения функций IPv6, сходных с ARP, ICMP, IRDP и Router Redirect протоколов для IPv4.

LLDP – протокол для обмена информацией между соседними устройствами
apt install lldpd
systemctl enable lldpd && systemctl start lldpd
sudo lldpctl

C пакетом dird2 можно посльзуясь протоколом rip sh rip neighbour
```
- 3)Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
```
Для разделения коммутатора на несколько виртуальных сетей используется VLAN
В Linux также устанавливается пакет VLAN
vagrant@vagrant:~$ sudo apt install vlan
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  vlan
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 11.3 kB of archives.
After this operation, 50.2 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 vlan all 2.0.4ubuntu1.20.04.1 [11.3 kB]
Fetched 11.3 kB in 10s (1,114 B/s)
Selecting previously unselected package vlan.
(Reading database ... 41581 files and directories currently installed.)
Preparing to unpack .../vlan_2.0.4ubuntu1.20.04.1_all.deb ...
Unpacking vlan (2.0.4ubuntu1.20.04.1) ...
Setting up vlan (2.0.4ubuntu1.20.04.1) ...
Processing triggers for man-db (2.9.1-1) ...

vim /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
#source-directory /etc/network/interfaces.d

auto vlan1
iface vlan1 inet static
 address 192.168.56.1
 netmask 255.255.255.0
 vlan_raw_device eth0
auto eth0.1
iface eth0.1 inet static
 address 192.168.56.1
 netmask 255.255.255.0
 vlan_raw_device eth0

vagrant@vagrant:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 82121sec preferred_lft 82121sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: vlan1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.1/24 brd 192.168.56.255 scope global vlan1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
```
- 4)Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
```
Агрегация в Linux возможно с пакетом bonding

mode=0 (balance-rr)
При этом методе объединения трафик распределяется по принципу «карусели»: пакеты по очереди направляются на сетевые карты объединённого интерфейса. 
Например, если у нас есть физические интерфейсы eth0, eth1, and eth2, объединенные в bond0, первый пакет будет отправляться через eth0,
второй — через eth1, третий — через eth2, а четвертый снова через eth0 и т.д.

mode=1 (active-backup)
Когда используется этот метод, активен только один физический интерфейс, 
а остальные работают как резервные на случай отказа основного.

mode=2 (balance-xor)
В данном случае объединенный интерфейс определяет, через какую физическую сетевую карту отправить пакеты, 
в зависимости от MAC-адресов источника и получателя.

mode=3 (broadcast) Широковещательный режим, все пакеты отправляются через каждый интерфейс. 
Имеет ограниченное применение, но обеспечивает значительную отказоустойчивость.

mode=4 (802.3ad)
Особый режим объединения. Для него требуется специально настраивать коммутатор, 
к которому подключен объединенный интерфейс. Реализует стандарты объединения каналов IEEE и обеспечивает как увеличение пропускной способности, 
так и отказоустойчивость.

mode=5 (balance-tlb)
Распределение нагрузки при передаче. Входящий трафик обрабатывается в обычном режиме, 
а при передаче интерфейс определяется на основе данных о загруженности.

mode=6 (balance-alb)
Адаптивное распределение нагрузки. Аналогично предыдущему режиму, 
но с возможностью балансировать также входящую нагрузку.

source-directory /etc/network/interfaces.d

auto eth0
iface eth0 inet manual
        bond-master bond0

auto eth1
        iface eth1 inet manual
        bond-master bond0

auto bond0
iface bond0 inet manual
        ipaddes 10.0.2.15
        gateway 10.0.2.1
        netmask 255.255.255.0
        bond-mode 4
        bond-miimon 100
        bond-lacp-rate 1
        bond-slaves eth0 eth1
```
- 5)Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. 
- Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
```
В сети с маской /29 8 адресор
В сети с маской /24 256 адресов. 256/8=32 подсети можно получить.
vagrant@vagrant:~$ ipcalc 10.10.10.0/24 /29
Address:   10.10.10.0           00001010.00001010.00001010. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
Hosts/Net: 254                   Class A, Private Internet

Subnets after transition from /24 to /29

Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111

 1.
Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
Hosts/Net: 6                     Class A, Private Internet

 2.
Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
HostMin:   10.10.10.9           00001010.00001010.00001010.00001 001
HostMax:   10.10.10.14          00001010.00001010.00001010.00001 110
Broadcast: 10.10.10.15          00001010.00001010.00001010.00001 111
Hosts/Net: 6                     Class A, Private Internet

 3.
Network:   10.10.10.16/29       00001010.00001010.00001010.00010 000
HostMin:   10.10.10.17          00001010.00001010.00001010.00010 001
HostMax:   10.10.10.22          00001010.00001010.00001010.00010 110
Broadcast: 10.10.10.23          00001010.00001010.00001010.00010 111
Hosts/Net: 6                     Class A, Private Internet
```
-6)Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. 
- Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
```
100.64.0.0 — 100.127.255.255 (маска подсети 255.192.0.0 или /10)
Данная подсеть рекомендована согласно RFC 6598 для использования в качестве адресов для CGN (Carrier-Grade NAT).
```
- 7)Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
```
Windows : арп таблица arp -a, очистить кеш netsh interface ip delete arpcache, удалить одну запись arp -d <нужная запись>.
Linux :  арп таблица ip neighbour, очистить кеш ip -s -s neigh flush all, удалить одну запись arp -d <нужная запись>.
```
-
-------------------------------------------------------------------
Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"
-------------------------------------------------------------------
- 1)Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
- telnet route-views.routeviews.org
- Username: rviews
- show ip route x.x.x.x/32
- show bgp x.x.x.x/32
```
vagrant@vagrant:~$ telnet route-views.routeviews.org
Trying 128.223.51.103...
Connected to route-views.routeviews.org.
Escape character is '^]'.
C
**********************************************************************

                    RouteViews BGP Route Viewer
                    route-views.routeviews.org

 route views data is archived on http://archive.routeviews.org

 This hardware is part of a grant by the NSF.
 Please contact help@routeviews.org if you have questions, or
 if you wish to contribute your view.

 This router has views of full routing tables from several ASes.
 The list of peers is located at http://www.routeviews.org/peers
 in route-views.oregon-ix.net.txt

 NOTE: The hardware was upgraded in August 2014.  If you are seeing
 the error message, "no default Kerberos realm", you may want to
 in Mac OS X add "default unset autologin" to your ~/.telnetrc

 To login, use the username "rviews".

 **********************************************************************


User Access Verification

Username: rviews
route-views>show ip route 37.204.205.149
Routing entry for 37.204.0.0/16
  Known via "bgp 6447", distance 20, metric 0
  Tag 3356, type external
  Last update from 4.68.4.46 2w3d ago
  Routing Descriptor Blocks:
  * 4.68.4.46, from 4.68.4.46, 2w3d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 3356
      MPLS label: none
route-views>show bgp 37.204.205.149
BGP routing table entry for 37.204.0.0/16, version 1372692932
Paths: (24 available, best #11, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 1273 12389 42610
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 1273:12276 1273:32090 3303:1004 3303:1006 3303:3056
      path 7FE01D5E17C8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 1299 42610
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin incomplete, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0BDA16600 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 12389 42610
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1050 7660:9003
      path 7FE16E3E4CC8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 1299 42610
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin incomplete, metric 0, localpref 100, valid, external
      path 7FE1133D4BB0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 1299 42610
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1299:30000 57866:100 57866:101 57866:501
      path 7FE157EE1438 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 42610
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin incomplete, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE0E360F6A8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1273 12389 42610
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 1273:12276 1273:32090
      path 7FE14CFB76E0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 12389 12389 12389 12389 12389 12389 42610
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE170A3BFF0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 12389 12389 12389 12389 12389 12389 42610
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:4000 3257:8794 3257:50001 3257:50110 3257:54900 3257:54901 20912:65004
      path 7FE105A7B6C0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 1299 42610
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin incomplete, metric 0, localpref 100, valid, external
      Community: 1299:30000 8283:1 8283:101
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE1840C5208 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 1299 42610
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external, best
      Community: 3356:3 3356:22 3356:86 3356:575 3356:666 3356:903 3356:2012
      path 7FE16DC9E1A8 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  2497 12389 42610
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE12600CFD0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 1273 12389 42610
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE136F01410 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 1299 42610
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE02C0A8C10 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 1273 12389 42610
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE0F5D1B810 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1273 12389 42610
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE170EF0368 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 12389 12389 12389 12389 12389 12389 42610
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:4000 3257:8794 3257:50001 3257:50110 3257:54900 3257:54901
      path 7FE09D9E82B8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 1299 42610
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:3 3356:22 3356:86 3356:575 3356:666 3356:903 3356:2011 3549:2581 3549:30840
      path 7FE12286D838 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 174 1299 42610
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin incomplete, localpref 100, valid, external
      Community: 174:21000 174:22013 53767:5000
      path 7FE118D71E18 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3356 1299 42610
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 3356:3 3356:22 3356:86 3356:575 3356:666 3356:903 3356:2012
      Extended Community: RT:101:22100
      path 7FE184F00868 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 209 3356 1299 42610
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE0C02D4B58 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 1273 12389 42610
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE102B14048 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 1273 12389 42610
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE02FF53290 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  19214 174 1299 42610
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin incomplete, localpref 100, valid, external
      Community: 174:21000 174:22013
      path 7FE0AB775048 RPKI State not found
      rx pathid: 0, tx pathid: 0
```
- 2)Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```
vagrant@vagrant:~$ ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100

vagrant@vagrant:~$ sudo modprobe -v dummy numdummies=2
vagrant@vagrant:~$ lsmod | grep dummy
dummy                  16384  0
vagrant@vagrant:~$ ip addr | grep dummy
vagrant@vagrant:~$ sudo ip link add dummy0 type dummy
vagrant@vagrant:~$ sudo ip link add dummy2 type dummy
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
vagrant@vagrant:~$ sudo ip addr add 192.168.1.1/24 dev dummy0
vagrant@vagrant:~$ sudo ip addr add 192.168.2.1/24 dev dummy2
vagrant@vagrant:~$ ip addr | grep dummy
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    inet 192.168.1.1/24 scope global dummy0
    inet 192.168.2.1/24 scope global dummy2
vagrant@vagrant:~$ sudo ip link set dummy0 up
vagrant@vagrant:~$ sudo ip link set dummy2 up
vagrant@vagrant:~$ ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
192.168.1.0/24 dev dummy0 proto kernel scope link src 192.168.1.1
192.168.2.0/24 dev dummy2 proto kernel scope link src 192.168.2.1

sudo vim /etc/network/interfaces
auto dummy0
iface dummy0 inet static
address 192.168.1.1
netmask 255.255.255.0

auto dummy2
iface dummy2 inet static
address 192.168.2.1
netmask 255.255.255.0
```
- 3)Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
```
vagrant@vagrant:~$ sudo ss -s
Total: 137
TCP:   6 (estab 1, closed 0, orphaned 0, timewait 0)

Transport Total     IP        IPv6
RAW       1         0         1
UDP       4         3         1
TCP       6         4         2
INET      11        7         4
FRAG      0         0         0

vagrant@vagrant:~$ sudo ss -ta
State        Recv-Q       Send-Q               Local Address:Port                 Peer Address:Port       Process
LISTEN       0            4096                       0.0.0.0:sunrpc                    0.0.0.0:*
LISTEN       0            4096                 127.0.0.53%lo:domain                    0.0.0.0:*
LISTEN       0            128                        0.0.0.0:ssh                       0.0.0.0:*
ESTAB        0            0                        10.0.2.15:ssh                      10.0.2.2:1260
LISTEN       0            4096                          [::]:sunrpc                       [::]:*
LISTEN       0            128                           [::]:ssh                          [::]:*

vagrant@vagrant:~$ sudo ss -tarep
State         Recv-Q        Send-Q                Local Address:Port                           Peer Address:Port        Process
LISTEN        0             4096                        0.0.0.0:rpc.portmapper                      0.0.0.0:*
 users:(("rpcbind",pid=620,fd=4),("systemd",pid=1,fd=35)) ino:16030 sk:89 <->
LISTEN        0             4096                   localhost%lo:domain                              0.0.0.0:*
 users:(("systemd-resolve",pid=621,fd=13)) uid:101 ino:22761 sk:8a <->
LISTEN        0             128                         0.0.0.0:ssh                                 0.0.0.0:*
 users:(("sshd",pid=761,fd=3)) ino:24025 sk:8b <->
ESTAB         0             0                           vagrant:ssh                                _gateway:1260         users:(("sshd",pid=921,fd=4),("sshd",pid=881,fd=4)) timer:(keepalive,84min,0) ino:25616 sk:35 <->
LISTEN        0             4096                           [::]:rpc.portmapper                         [::]:*
 users:(("rpcbind",pid=620,fd=6),("systemd",pid=1,fd=37)) ino:16034 sk:8c v6only:1 <->
LISTEN        0             128                            [::]:ssh                                    [::]:*
 users:(("sshd",pid=761,fd=4)) ino:24027 sk:8d v6only:1 <->	
```
- 4)Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```
vagrant@vagrant:~$ sudo ss -ua
State        Recv-Q       Send-Q               Local Address:Port                 Peer Address:Port       Process
UNCONN       0            0                    127.0.0.53%lo:domain                    0.0.0.0:*
UNCONN       0            0                   10.0.2.15%eth0:bootpc                    0.0.0.0:*
UNCONN       0            0                          0.0.0.0:sunrpc                    0.0.0.0:*
UNCONN       0            0                             [::]:sunrpc                       [::]:*

vagrant@vagrant:~$ sudo ss -uarep
State         Recv-Q        Send-Q                Local Address:Port                           Peer Address:Port        Process
UNCONN        0             0                      localhost%lo:domain                              0.0.0.0:*
 users:(("systemd-resolve",pid=621,fd=12)) uid:101 ino:22760 sk:85 <->
UNCONN        0             0                      vagrant%eth0:bootpc                              0.0.0.0:*
 users:(("systemd-network",pid=399,fd=19)) uid:100 ino:17268 sk:86 <->
UNCONN        0             0                           0.0.0.0:rpc.portmapper                      0.0.0.0:*
 users:(("rpcbind",pid=620,fd=5),("systemd",pid=1,fd=36)) ino:16031 sk:87 <->
UNCONN        0             0                              [::]:rpc.portmapper                         [::]:*
 users:(("rpcbind",pid=620,fd=7),("systemd",pid=1,fd=38)) ino:16037 sk:88 v6only:1 <->
```
- 5)Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
```
https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Untitled%20Diagram.drawio#Uhttps%3A%2F%2Fraw.githubusercontent.com%2Fzliden9%2FDevOpsStudents%2Fcircleci-project-setup%2FUntitled%2520Diagram.drawio
---
