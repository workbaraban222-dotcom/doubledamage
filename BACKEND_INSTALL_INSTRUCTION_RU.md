# DOUBLE DAMAGE: что в архивах и как установить backend

## Архивы

### `DOUBLE_DAMAGE_site_readable_font.zip`

Обычная HTML-версия сайта. Ее можно открыть как статический сайт, но полноценного backend там нет.

Внутри:
- страницы сайта;
- магазин;
- админка старого типа;
- стили;
- скрипты;
- сохранение данных через браузер.

### `DOUBLE_DAMAGE_next_backend_ready.zip`

Новая версия сайта на React/Next с backend.

Внутри:
- сайт на Next;
- API для товаров, категорий, новостей и событий;
- API для заказов;
- API для партнерских заявок;
- админка `/admin`;
- база данных `data/db.json`;
- сохранение изменений через backend.

## Что нужно для запуска backend

На сервере или компьютере должен быть установлен Node.js.

Скачать Node.js:
https://nodejs.org/

Лучше ставить LTS-версию.

## Локальный запуск

1. Распаковать `DOUBLE_DAMAGE_next_backend_ready.zip`.
2. Открыть папку проекта `DOUBLE_DAMAGE_next`.
3. Выполнить:

```bash
npm install
npm run dev
```

После этого сайт будет доступен:

```text
http://localhost:3000
```

Админка:

```text
http://localhost:3000/admin
```

## Запуск на сервере

В папке проекта выполнить:

```bash
npm install
npm run build
npm start
```

По умолчанию Next запускается на порту `3000`.

## Защита админки

На сервере нужно задать переменную:

```bash
ADMIN_TOKEN=твой_пароль
```

Этот же пароль вводится в поле `ADMIN_TOKEN` в админке.

Если `ADMIN_TOKEN` не задан, backend разрешает сохранение без пароля. Для реального сайта обязательно задай токен.

## Где лежит база

Файл базы:

```text
data/db.json
```

Там хранятся:
- категории;
- товары;
- новости;
- события;
- заказы;
- партнерские заявки.

## API

Основные адреса:

```text
GET  /api/site
PUT  /api/site

GET  /api/categories
POST /api/categories
PUT  /api/categories/:id
DELETE /api/categories/:id

GET  /api/products
POST /api/products
PUT  /api/products/:id
DELETE /api/products/:id

GET  /api/news
POST /api/news
PUT  /api/news/:id
DELETE /api/news/:id

GET  /api/events
POST /api/events
PUT  /api/events/:id
DELETE /api/events/:id

GET  /api/orders
POST /api/orders

GET  /api/partner-leads
POST /api/partner-leads
```

## Важно

Это backend на JSON-файле. Для старта и тестов нормально. Для большого боевого проекта лучше потом заменить хранение на PostgreSQL, MySQL или MongoDB.
