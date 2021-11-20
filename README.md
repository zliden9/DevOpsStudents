# DevOpsStudents
Netology
HelloNetology

1)Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, 
что cd не является самостоятельной программой, это shell builtin, 
поэтому запустить strace непосредственно на cd не получится. 
Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. 
В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. 
Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, 
что strace выдаёт результат своей работы в поток stderr, а не в stdout.

strace /bin/bash -c 'cd /tmp' 2>&1 | grep cd >>file1
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffffc9c6ff0 /* 24 vars */) = 0


2)Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:
vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64

Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

strace file 2>&1 | grep libmagic
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3

3)Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), 
однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. 
Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. 
Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

ping ya.ru >file1
sudo lsof | grep ping | grep file1
ping      1010                       vagrant    1w      REG              253,0     4798     131099 /home/vagrant/file1
rm file1
sudo lsof | grep ping | grep file1
ping      1010                       vagrant    1w      REG              253,0    36590     131099 /home/vagrant/file1 (deleted)
sudo cat /proc/1010/fd/1>/home/vagrant/file1



4)Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
Зомби процес занимает ресурсы ядра.


5)В iovisor BCC есть утилита opensnoop:
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.

vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
780    vminfo              4   0 /var/run/utmp
593    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
593    dbus-daemon        18   0 /usr/share/dbus-1/system-services
593    dbus-daemon        -1   2 /lib/dbus-1/system-services
593    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
378    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
378    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
780    vminfo              4   0 /var/run/utmp

6)Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, 
где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

execve("/usr/bin/uname", ["uname", "-a"], 0x7ffcdb267728 /* 24 vars */) = 0
  Часть  информации,  возвращаемой  данным  системным  вызовом также доступна через sysctl и
       через файлы /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
       (По какойто причине в моей ubuntu этой инфы нет  Ubuntu 20.04.2 LTS)


7)Чем отличается последовательность команд через ; и через && в bash? Например:
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#

Есть ли смысл использовать в bash &&, если применить set -e?


9)Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?


9)Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. 
В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. 
Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).


