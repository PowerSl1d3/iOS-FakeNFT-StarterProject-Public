# Реализация экрана профиля

- Андреев Роман
- Когорта: 06
- Группа: 1
- Эпик: Каталог

# Ресурсы

- [Доска](https://www.notion.so/002a21b3720c4c9197fae68409b407b3?pvs=21)

# YP-0. Задача для профиля (Экран профиля) (est: 3 часов fact: ?)
**Экран профиля**

Экран показывает информацию о пользователе. Он содержит:
- фото пользователя;
- имя пользователя;
- описание пользователя;
- таблицу (UITableView) с ячейками Мои NFT (ведет на экран NFT пользователя), Избранные NFT (ведет на экран с избранными NFT), Сайт пользователя (открывает в вебвью сайт пользователя).

В правом верхнем углу экрана находится кнопка редактирования профиля. Нажав на нее, пользователь видит всплывающий экран, на котором может отредактировать имя пользователя, описание, сайт и ссылку на изображение. Загружать само изображение через приложение не нужно, обновляется только ссылка на изображение.

- Отображение веб-страницы. ETA - 2


# YP-1. Задача для профиля (Экран Мои NFT) (est: 14 часов fact: ?)

**Экран Мои NFT**

Представляет собой таблицу (UITableView), каждая ячейка которой содержит:
- иконку NFT;
- название NFT;
- автора NFT;
- цену NFT в ETH.

Сверху на экране есть кнопка сортировки, при нажатии на которую пользователю предлагается выбрать один из доступных способов сортировки. Содержимое таблицы упорядочивается согласно выбранному способу.

В случае отсутствия NFT показывается соответствующая надпись.

- Вёрстка таблицы. ETA - 2
- Вёрстка ячейки таблицы. ETA - 2
- Логика загрузки данных в ячейки таблицы. ETA - 6
- Логика сортировки ячеек таблицы. ETA - 4

# YP-2. Задача для профиля (Экран Избранные NFT)  (est: 14 часов fact: ?)

**Экран Избранные NFT**

Содержит коллекцию (UICollectionView) c NFT, добавленными в избранное (лайкнутыми). Каждая ячейка содержит информацию об NFT:
- иконка;
- сердечко;
- название;
- рейтинг;
- цена в ETH.

Нажатие на сердечко удаляет NFT из избранного, содержимое коллекции при этом обновляется.

В случае отсутствия избранных NFT показывается соответствующая надпись.


- Вёрстка таблицы. ETA - 2
- Вёрстка ячейки таблицы. ETA - 2
- Логика загрузки данных в ячейки таблицы. ETA - 6
- Логика добавления NFT в избранное. ETA - 4


