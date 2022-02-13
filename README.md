# DevOpsStudents
-Netology
-HelloNetology
-
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

# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
- Склады и автомобильные дороги для логистической компании
- Генеалогические деревья
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
- Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.
```

```

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?
```

```
## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
```

```
## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?
```

```
---


