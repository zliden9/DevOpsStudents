# DevOpsStudents
-Netology
-HelloNetology
-
---
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"
---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
```
Ускорение процессов разработки, тестирования и масштабирования системы.
Минимизация состояния дрейфа конфигурации при которой не согласованность действий может привести к непредвиденным последствиям в работе системы и состояния проекта в целом.
Быстрота и эффективность за счёт автоматизации процесса развётки новых песочниц.
```
- Какой из принципов IaaC является основополагающим?
```
Идемпоте́нтность: мы получаем среду в которой можно спрогнозировать результат за счёт идентичности конфигураций и песочниц.
```
## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
```
Тем что Ansible в отличее от его аналогов из коробки использует существующую инфраструктуру SSH.
```
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
```
В зависимости от конфигурации системы, но в среднем мне кажется что push для небольших инфраструктур буде более надёжным, а результат более предсказуемым.
```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```cmd
C:\Users\zliden9>vboxmanage -v
6.1.28r147628
PS C:\Users\zliden9> vagrant --version
Vagrant 2.2.19
```
```bash
ad@ad-VirtualBox:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/ad/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 26 2021, 20:14:08) [GCC 9.3.0]
```
---

---
# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
```
replication этим парамнтром мы указываем колличество нужных копий объявленных сервисов в кластере. В вслучае проблем с одной из нод, сервис будет поднят на другой ноде,
но общее колличество работающих сервисов не превысит заданного колличества реплик.
global этим сервисом мы объявляем применение ко всем контейнерам в кластере.
```
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
```
лидер в кластере становится первая попавшая в него машина, далее в случае потери связи с лидером, следующий лидер объявиться 
по результату голосования между оставшимеся контейнерами manager. Алгоритм выбора лидера Raft, даёт возможность смены лидера в любой момент времени автоматически либо вручную.
```
- Что такое Overlay Network?
```
Это внутренняя локальная сеть охватывающая все используемые узлы в рамках созданного кластера Docker Swarm.
```
## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
![5-5 2](https://user-images.githubusercontent.com/92779046/153756402-788fd03c-9f70-40d0-992d-9535ec051ca0.PNG)


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```
![5-5 3](https://user-images.githubusercontent.com/92779046/153756404-26b012c6-4412-4e03-9802-13f0e5b58670.PNG)

----------------------------------------
