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

strace -o file1 file | grep lib file1 >file2
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3

3)Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), 
однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. 
Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. 
Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

Нужно найти pid приложения ps auxf
vim file1
ps auxf | grep file1
ps auxf | grep vim


4)Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?



5)В iovisor BCC есть утилита opensnoop:
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.


6)Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, 
где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.


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


