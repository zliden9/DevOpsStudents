# DevOpsStudents
Netology
HelloNetology

1) какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
	HISTFILE строка 619
	HISTSIZE строка 630
	history-size (unset) строка 1799

2) что делает директива ignoreboth в bash?
	Не сохраняет записи в истории аналогичные предыдущим.

3)В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
	используется в coproc do done elif else esac if строка 143

4)С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов?
	touch file{1..100000}
Получится ли аналогичным образом создать 300000? Если нет, то почему?
	При вводе 300000 компьютер ругается Argument list too long

5)В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
	выполняет проверку директории /tmp на её наличие и являетсяли она директорией

6)Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных;
командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды,
которые позволили вам добиться указанного вывода или соответствующие скриншоты.

	mkdir /tmp/new_path_directory/
	cp /bin/bash /tmp/new_path_directory/
	PATH=/tmp/new_path_directory/:$PATH
	type -a bash
	/tmp/new_path_directory/bash
	/usr/bin/bash
	/bin/bash

7)Чем отличается планирование команд с помощью batch и at?

	batch - планировщик разовых задач исполняемых когда средняя загрузка системы ниже 1.5
	at - планировщик разовых задач в назначенное время

8)Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
	sudo shutdown
	vagrant halt
