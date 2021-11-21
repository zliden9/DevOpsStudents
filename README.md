# DevOpsStudents
-Netology
-HelloNetology
-
-1)Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, 
-что cd не является самостоятельной программой, это shell builtin, 
-поэтому запустить strace непосредственно на cd не получится. 
-Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. 
-В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. 
-Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, 
-что strace выдаёт результат своей работы в поток stderr, а не в stdout.
-
-	strace /bin/bash -c 'cd /tmp' 2>&1 | grep cd >>file1
-	execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffffc9c6ff0 /* 24 vars */) = 0
---------------------------
-2)Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:
-vagrant@netology1:~$ file /dev/tty
-/dev/tty: character special (5/0)
-vagrant@netology1:~$ file /dev/sda
-/dev/sda: block special (8/0)
-vagrant@netology1:~$ file /bin/bash
-/bin/bash: ELF 64-bit LSB shared object, x86-64
-
-Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.
-
-	strace file 2>&1 | grep libmagic
-	openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
-----------------------------------------
-3)Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), 
-однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. 
-Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. 
-Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
-
-	ping ya.ru >file1
-	sudo lsof | grep ping | grep file1
-	ping      1010                       vagrant    1w      REG              253,0     4798     131099 /home/vagrant/file1
-	rm file1
-	sudo lsof | grep ping | grep file1
-	ping      1010                       vagrant    1w      REG              253,0    36590     131099 /home/vagrant/file1 (deleted)
-	sudo cat /proc/1010/fd/1>/home/vagrant/file1
---------------------------------------
-4)Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
-	Зомби процес занимает ресурсы ядра.
----------------------------------------
-5)В iovisor BCC есть утилита opensnoop:
-root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
-/usr/sbin/opensnoop-bpfcc
-На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.
-
-	vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc
-	PID    COMM               FD ERR PATH
-	780    vminfo              4   0 /var/run/utmp
-	593    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
-	593    dbus-daemon        18   0 /usr/share/dbus-1/system-services
-	593    dbus-daemon        -1   2 /lib/dbus-1/system-services
-	593    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
-	378    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
-	378    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
-	780    vminfo              4   0 /var/run/utmp
-----------------------
-6)Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, 
-где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.
-
-	execve("/usr/bin/uname", ["uname", "-a"], 0x7ffcdb267728 /* 24 vars */) = 0
-  	Часть  информации,  возвращаемой  данным  системным  вызовом также доступна через sysctl и
-       через файлы /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
-       (По какойто причине в моей ubuntu этой инфы нет  Ubuntu 20.04.2 LTS)
-------------------------------
-7)Чем отличается последовательность команд через ; и через && в bash? Например:
-root@netology1:~# test -d /tmp/some_dir; echo Hi
-Hi
-root@netology1:~# test -d /tmp/some_dir && echo Hi
-root@netology1:~#
-
-	&& оператор AND
-	; оператор выполнения последовательности команд
-
-Есть ли смысл использовать в bash &&, если применить set -e?
-
-  set -e ну умеет работать с конвеерами, поэтому думаю что да.
-------------------------------------------------
-9)Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
-
-	-e:параметр -e указывает оболочке выйти, если команда дает ненулевой статус выхода. Проще говоря, оболочка завершает работу при сбое команды.
-	-u:опция -u обрабатывает неустановленные или неопределенные переменные, за исключением специальных параметров, таких как подстановочные знаки (*)
-	-x:опция -x печатает аргументы команды во время выполнения
-	-o: опция-имя
-	Если опция pipefail включена — статус выхода из конвейера является значением последней (самой правой) команды, 
-	завершённой с ненулевым статусом, или ноль — если работа всех команд завершена успешно.
-
-	Слудуя описанию, в случае если в сценарие есть ошибки то мы достаточно подробно о них узнаем.
--------------------------
-10)Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе.
-	STAT
-	Ss
-	R+
-	S interruptible sleep (waiting for an event to complete)
-	s    is a session leader
-	R running or runnable (on run queue)
-	+    is in the foreground process group 
-В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. 
-Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
-Остальные дополнительные:
-               <    high-priority (not nice to other users)
-               N    low-priority (nice to other users)
-               L    has pages locked into memory (for real-time and custom IO)
-               s    is a session leader
-               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
-               +    is in the foreground process group
-------------------------------------------------------------------------------------------------------------------------------
Домашнее задание к занятию "3.4. Операционные системы
-----------------------------------------------
1)На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. 
Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. 
Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:
поместите его в автозагрузку,
предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

создание сервиса автозапуска для node_exporter
sudo systemctl edit --full --force prometheus-node-exporter.service

[Unit]
Description=Prometheus exporter for machine metrics
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
Restart=always
User=node_exporter
Group=node_exporter
Type=simple
EnvironmentFile=/etc/default/prometheus-node-exporter
ExecStart=/usr/bin/prometheus-node-exporter $ARGS
ExecReload=/bin/kill -HUP $MAINPID
TimeoutStopSec=20s
SendSIGKILL=no

[Install]
WantedBy=multi-user.target

ps auxh | grep prometheus-node-exporter
node_ex+    2851  0.0  0.5 412320 10732 ?        Ssl  16:40   0:00 /usr/bin/prometheus-node-exporter
vagrant     2876  0.0  0.0   9040   736 pts/0    S+   16:41   0:00 grep --color=auto prometheus-node-exporter

Проверка работы

vagrant@vagrant:~$ sudo systemctl stop prometheus-node-exporter
vagrant@vagrant:~$ ps auxh | grep prometheus-node-exporter
vagrant     2946  0.0  0.0   9040   668 pts/0    S+   16:44   0:00 grep --color=auto prometheus-node-exporter
vagrant@vagrant:~$ sudo systemctl start prometheus-node-exporter
vagrant@vagrant:~$ ps auxh | grep prometheus-node-exporter
node_ex+    2950  0.0  0.5 412320 10680 ?        Ssl  16:44   0:00 /usr/bin/prometheus-node-exporter
vagrant     2967  0.0  0.0   9040   724 pts/0    S+   16:44   0:00 grep --color=auto prometheus-node-exporter
vagrant@vagrant:~$ sudo systemctl status prometheus-node-exporter
● prometheus-node-exporter.service - Prometheus exporter for machine metrics
     Loaded: loaded (/etc/systemd/system/prometheus-node-exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-11-21 16:44:31 UTC; 1min 4s ago

после ребута

More information can be found at https://github.com/chef/bento
Last login: Sun Nov 21 16:29:29 2021 from 10.0.2.2
vagrant@vagrant:~$ sudo systemctl status prometheus-node-exporter
● prometheus-node-exporter.service - Prometheus exporter for machine metrics
     Loaded: loaded (/etc/systemd/system/prometheus-node-exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-11-21 16:46:59 UTC; 17s ago
       Docs: https://github.com/prometheus/node_exporter
   Main PID: 1014 (prometheus-node)
      Tasks: 5 (limit: 2279)
     Memory: 11.0M
     CGroup: /system.slice/prometheus-node-exporter.service
             └─1014 /usr/bin/prometheus-node-exporter

--------------------------------------------------------
2) Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. 
Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
CPU
--collector.cpu
Диски
--collector.qdisc
--collector.qdisc.fixtures
Сеть
--collector.netstat
--collector.netdev.ignored-devices
Память
--collector.meminfo
------------------------------------------------------------
3)Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). После успешной установки:
в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. 
Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

Скрин (https://ibb.co/cv1zQQg)

![netData](https://user-images.githubusercontent.com/92779046/142775208-83758555-d61e-410a-8c6b-96083fb33985.PNG)
vagrant@vagrant:~$ sudo lsof -i | grep 1999
netdata    987         netdata    4u  IPv4  24578      0t0  TCP *:19999 (LISTEN)
netdata    987         netdata   50u  IPv4  30347      0t0  TCP vagrant:19999->_gateway:13748 (ESTABLISHED)

---------------------------------------------------------------
4)Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Судя по выгрузке похоже что понимает

vagrant@vagrant:~$ dmesg
[    0.000000] Linux version 5.4.0-80-generic (buildd@lcy01-amd64-030) (gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)) #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 (Ubuntu 5.4.0-80.90-generic 5.4.124)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.4.0-80-generic root=/dev/mapper/vgvagrant-root ro net.ifnames=0 biosdevname=0 quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] [Firmware Bug]: TSC doesn't count with P0 frequency!
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
------------------------------------------------------
5)Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. 
Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576

Это означает максимальное количество дескрипторов файлов, которые может выделить процесс. Значение по умолчанию 1024*1024 (1048576), 
которого должно быть достаточно для большинства машин. Фактический лимит зависит от лимита ресурсов RLIMIT_NOFILE.

vagrant@vagrant:~$ cat /proc/sys/fs/file-nr
992     0       9223372036854775807

-a        all current limits are reported
vagrant@vagrant:~$ ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 7597
max locked memory       (kbytes, -l) 65536
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 7597
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

      -S        use the `soft' resource limit
	 -p        the pipe buffer size
vagrant@vagrant:~$ ulimit -Sn -p
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
      -H        use the `hard' resource limit
vagrant@vagrant:~$ ulimit -Hn
1048576
----------------------------------------------------
6)Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; 
покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). 
Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

vagrant@vagrant:~$ sleep 4h
vagrant@vagrant:~$ ps -auxh | grep sleep
vagrant     2192  0.0  0.0   8076   520 pts/0    S+   18:17   0:00 sleep 4h
vagrant     2198  0.0  0.0   8900   664 pts/1    S+   18:17   0:00 grep --color=auto sleep

vagrant@vagrant:~$ sudo nsenter --target 2192 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
   2455 pts/1    00:00:00 sudo
   2456 pts/1    00:00:00 nsenter
   2457 pts/1    00:00:00 bash
   2466 pts/1    00:00:00 ps
----------------------------------------------------------
7)Найдите информацию о том, что такое :(){ :|:& };:. 
Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). 
Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. 
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

vagrant@vagrant:~$ :(){ :|:& };:
[1] 2491

-bash: fork: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
[2]-  Done                    : | :

Fork() — системный вызов в Unix-подобных операционных системах, создающий новый процесс (потомок), 
который является практически полной копией процесса-родителя, выполняющего этот вызов.

Она оперирует определением функции с именем ‘:‘, которая вызывает сама себя дважды: один раз на переднем плане и один раз в фоне. 
Она продолжает своё выполнение снова и снова, пока система не зависнет.

[ 2802.538089] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope

Выручает судя по всему он:
Cgroup — это набор процессов, которые связаны с набором ограничений или параметров, определяемых через файловую систему cgroup. 

Также можно ограничить ulimit -u
----------------------------------------------



