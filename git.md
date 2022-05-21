```zsh
git init
```

```zsh
git config --global user.name 'first_name second_name'
git config --global user.email 'user@email.com'
```

```zsh
git status
```

```zsh
git add .
```

```zsh
git commit -m 'commit descreption'
git commit --amend
```

```zsh
git remote add origin http://github.com/.../
git remote add origin git@github.com:GeorgiySapunov/notes.git
git push -u origin master
```

```zsh
git push
```

```zsh
git clone
```

```zsh
git checkout
```

```zsh
git log
git log --graph
```

```zsh
git reset
```

```zsh
git stash
git stash apply
```

## Update

1) Указываем в своей локальной копии (на компьютере), что откуда она
должна получать обновления. Это делается один раз для каждой локальной
копии.

`git remote add upstream https://github.com/user/repository`

2) Теперь в любой момент можно обновить свою локальную копию и свою
копию на сайте GitHub следующим набором команд.

Переключаемся в master ветку: `git checkout master`

Синхронизируем локальную копию с своей копией на сайте: `git pull`

Получаем актуальные обновления: `git fetch upstream`

Смотрим что поменялось: `git diff upstream/master`

Сливаем изменения в свою локальную копию: `git merge upstream/master`

Отправляем их в свою копию на сайте: `git push`

3) Не сложно подтянуть обновления уже непосредственно в свою ветку. Для этого
(подставлено имя моей ветки):

`git checkout branch_name`

по желанию: `git diff master`

`git merge master`

Если изменения были не очень конфликтующие (кто-то подправил файлы
шаблона, которые вы и не трогали, например Readme или какие-то
внутренние опции) всё тоже пройдёт без дополнительных вопросов, а
состояние репозитория сразу перемотается вперёд через все новые коммиты
(fast-forward).

```bash
Updating 22ca047..112b54a
Fast-forward
 Dissertation/disstyles.tex                |  16 +++++++++-
 README.md                                 |   8 +++--
 Bibliography.md => Readme/Bibliography.md |   0
 Installation.md => Readme/Installation.md |   6 ++--
 Links.md => Readme/Links.md               |   0
 Readme/github.md                          | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Synopsis/synstyles.tex                    |  19 ++++++++---
 Synopsis/title.tex                        |  77 ++++++++++++++++++++++-----------------------
 Synopsis/userstyles.tex                   |   1 +
 biblio/biblatex.tex                       |   8 ++---
 common/data.tex                           |  18 ++++++-----
 common/styles.tex                         |   6 ----
 synopsis.tex                              |  33 ++++++++++++++++++--
 13 files changed, 284 insertions(+), 71 deletions(-)
 rename Bibliography.md => Readme/Bibliography.md (100%)
 rename Installation.md => Readme/Installation.md (96%)
 rename Links.md => Readme/Links.md (100%)
 create mode 100644 Readme/github.md
```

4) В противном случае может потребоваться ручное разрешение конфликтов. Например,

```bash
$ git merge master
Auto-merging dissertation.tex
Auto-merging common/styles.tex
CONFLICT (content): Merge conflict in common/styles.tex
Auto-merging common/packages.tex
CONFLICT (content): Merge conflict in common/packages.tex
Auto-merging Dissertation/userstyles.tex
Auto-merging Dissertation/userpackages.tex
Auto-merging Dissertation/part3.tex
CONFLICT (content): Merge conflict in Dissertation/part3.tex
Auto-merging Dissertation/part2.tex
CONFLICT (content): Merge conflict in Dissertation/part2.tex
Auto-merging Dissertation/appendix.tex
CONFLICT (content): Merge conflict in Dissertation/appendix.tex
Automatic merge failed; fix conflicts and then commit the result.
```

Тогда надо каждый файл с конфликтом открыть и исправить конфликт вручную.

После того как все конфликты разрешены — не забудьте сделать финальный
коммит, который я обычно называю merge.

Собственно всё, ничего другого, чтобы поддерживать уже частично написанный диссер в соответствии с усилиями авторов шаблона достичь идеала не требуется.

### Если что-то пошло не так

Ничего страшного, всегда есть возможность откатиться к коммиту прямо
перед тем, как вы начали делать merge!

### Синхронизация с upstream (для продвинутых пользователей)

Шаблон время от времени обновляется, и может возникнуть желание
добавить полезные изменения к себе в работу.
Однако делать это при помощи `merge` может быть проблематично.
Для таких случаев удобно использовать команду  `git rebase`.

Рассмотрим ситуацию -- вы начали писать свою работу после коммита номер 3 в ветке `master`.
После этого шаблон был обновлён в ветке `upstream`.
Эта ситуация проиллюстрирована на рисунке ниже.

```
+--------+     +--------+     +--------+     +--------+     +--------+
|commit 1+----->commit 2+----->commit 3+--+-->commit 4+----->commit 5|   upstream
+--------+     +--------+     +--------+  |  +--------+     +--------+
                                          |
                                          |
                                          |  +--------+     +--------+
                                          +-->commit 6+----->commit 7|   master*
                                             +--------+     +--------+
```

Для `merge` в данном случае наверняка понадобится разрешать множество конфликтов.
`git` предоставляет более лёгкий способ синхронизации изменений -- `rebase`.

Для слияния веток введите команду:

```bash
git rebase upstream
```

После этого `git` применит Ваши изменения начиная с последнего коммита ветки `upstream`.
Результат этой операции будет выглядеть так:

```
                                                             upstream
+--------+     +--------+     +--------+     +--------+     +--------+     +---------+     +---------+
|commit 1+----->commit 2+----->commit 3+----->commit 4+----->commit 5+----->commit 6*+----->commit 7*|   master
+--------+     +--------+     +--------+     +--------+     +--------+     +---------+     +---------+
```

Такой подход вызовет минимальное количество конфликтов (если у веток только одно пересечение).

Минусом данного подхода является то, что `hash` всех коммитов ветки `master` будет изменён.
Следствием этого будет то, что ссылки на эти коммиты в issue tracker будут сломаны,
так что данный способ лучше **не использовать при наличии ссылок на коммиты в issue tracker**.

Кроме того, при загрузке изменений на сервер потребуется использовать *силу*:

```bash
git push --force origin master
```

А при последующей синхронизации на *другом* компьютере надо будет использовать:

```bash
git fetch origin
git reset --hard origin/master
```
