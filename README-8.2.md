# Домашнее задание к занятию "08.02 Работа с Playbook"
---
# Установка Clickhouse
- name: Install Clickhouse - название Playbook
- hosts: - хосты с которыми будет производиться play
- handlers: - это отдельный вид task которые выполняются один раз и только в случае если она вызывается из task
- name: Start clickhouse service - по этому исени будет инициирован запуск сервиса
- become: true - повышение привилегий до root
- ansible.builtin.service: - запуск модуля service
- name: clickhouse-server - инициируем запуск службы
- state: restarted - ожидается перезапуск
- tasks: - задачи вызываемые play
- block: - инициируем блок выполняемых задач
- name: Install Clickhouse | Download distrib noarch - инициируем скачивание дистрибутива с указанием архитектуры
- ansible.builtin.get_url: - указываем на начало загрузки с использованием url адреса
- url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm" - url адрес и в скобках указываем переменные находящиеся в "group_vars/clickhouse/vars.yml"
- dest: "./{{ item }}-{{ clickhouse_version }}.rpm" - указываем куда скачать
- mode: 0644 - устанавливаем права на скаченный пакет
- with_items: "{{ clickhouse_packages_noarch }}" - инициируем исполнение по всем перечисленным пакетам
- rescue: - если выше были фатальные ошибки то инициируем альтернативный вариант выполнения блока
- ansible.builtin.yum: - инициируем установку пакетов с помощью yum
```
- указание какие пакеты устанавливать:
clickhouse-common-static-{{ clickhouse_version }}.rpm - т.е. clickhouse-common-static-22.3.3.44.rpm
clickhouse-client-{{ clickhouse_version }}.rpm - т.е. clickhouse-client-22.3.3.44.rpm
clickhouse-server-{{ clickhouse_version }}.rpm - т.е. clickhouse-server-22.3.3.44.rpm
```
- notify: Start clickhouse service - уведомление о старте сервиса
- name: Flush handlers - объявляем начало выполнение handler
- ansible.builtin.meta: flush_handlers - исполнение handler
- post_tasks: - task которые выполняются в конце
- name: Install Clickhouse | Wait for clickhouse to be running - скачивание и ожидание старта сервиса
- ansible.builtin.service_facts: - собираем данные о всех запущеных сервисах
- register: actual_services_state - запись результатов работ в переменную actual_services_state
- name: Create database - создание таблицы для БД
- ansible.builtin.command: "clickhouse-client -q 'create database logs;'" - выполнение bash команды
- register: create_db - запись результатов работ в переменную create_db
- failed_when: create_db.rc != 0 and create_db.rc !=82 - падение в случае если поле rc не равно 0 и 82  0 = база создана 82 = таблицы созданы
- changed_when: create_db.rc == 0 - если rc = 0 то статус меняется на changed
---
---
# Установка Vector
- name: Install Vector - название Play
- hosts: vector - хосты с которыми будет производиться play
- tasks: - задачи вызываемые play
- name: Install Vector | Download distrib - скачка дистрибутива
- ansible.builtin.get_url: - указываем на начало загрузки с использованием url адреса
- url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm" - url адрес и в скобках указываем переменные находящиеся в "group_vars/vector/vars.yml"
- dest: "./vector-{{ vector_version }}.rpm" - указываем куда положить пакет
- mode: 0644 - устанавливаем права на скаченный пакет
- name: Install Vector | Install packages - инициируем установку пакета
- become: true - повышение привилегий до root
- ansible.builtin.yum:: - инициируем установку пакетов с помощью yum
- name: "vector-{{ vector_version }}.rpm" - указываем пакет который будем устанавливать
---
