# DevOpsStudents
Netology
HelloNetology

В игнор попадают следующие каталоги и файлы: 
**/.terraform/*
*.tfstate
*.tfstate.*
crash.log
*.tfvars
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
      * - указание на любой символьный набор находящийся в начале или конце названия
      ** - указание на вложенные каталоги


1) Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

$ git show -s aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

2) Какому тегу соответствует коммит 85024d3?

$ git show -s 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23

3) Сколько родителей у коммита b8d720? Напишите их хеши.

$ git log b8d720f8340221f2146e4e4870bf2ee0bc48f2d5^@ --pretty=%H --no-walk
9ea88f22fc6269854151c571162c5bcf958bee2b
56cd7859e05c36c06b56d013b55a252d0bb7e158

4) Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

$ git log -s v0.12.23..v0.12.24 --pretty=%H%S%s --decorate
33ff1c03bb960b332be3af2e333462dde88b279ev0.12.24v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89v0.12.24[Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26ev0.12.24Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bfv0.12.24registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353v0.12.24website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5v0.12.24Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80v0.12.24command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066edv0.12.24Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35v0.12.24Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525ev0.12.24Cleanup after v0.12.23 release

5) Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) 
(вместо троеточего перечислены аргументы).

$ git log -S 'func providerSource(' --oneline --pretty=format"%s, %cn, %cd, %H"
formatmain: Consult local directories as potential mirrors of providers, Martin Atkins, Mon Apr 6 09:24:23 2020 -0700, 8c928e83589d90a031f811fae52a81be7153e82f

6) Найдите все коммиты в которых была изменена функция globalPluginDirs.

$ git log --oneline -S'globalPluginDirs' --pretty=format"%s, %cn, %cd, %H"
formatmain: configure credentials from the CLI config file, Martin Atkins, Sat Oct 21 09:37:05 2017 -0700, 35a058fb3ddfae9cfee0b3893822c9a95b920f4c
formatprevent log output during init, James Bardin, Mon Jun 12 15:05:59 2017 -0400, c0b17610965450a89598da491ce9b6b5cbd6393f
formatPush plugin discovery down into command package, Martin Atkins, Fri Jun 9 14:03:59 2017 -0700, 8364383c359a6b738a436d1b7745ccdce178df47

7) Кто автор функции synchronizedWriters?

$ git log -S"synchronizedWriters(" --pretty=format:'%ad, %aN, %cN, %h, %s,'
Mon Nov 30 18:02:04 2020 -0500, James Bardin, James Bardin, bdfea50cc, remove unused,
Wed Oct 21 13:06:23 2020 -0400, James Bardin, James Bardin, fd4f7eb0b, remove prefixed io,
Wed May 3 16:25:41 2017 -0700, Martin Atkins, Martin Atkins, 5ac311e2a, main: synchronize writes to VT100-faker on Windows,
