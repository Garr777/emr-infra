# emr-infra

Инфраструктура системы электронной медкарты (EMR): БД, бэкенд, фронтенд и мониторинг,
разворачиваемые одним стеком `docker-compose` через GitLab CI.

## Состав стека

| Сервис | Образ | Порт | Назначение |
|---|---|---|---|
| postgres | `postgres:16-alpine` | `5432` | База данных |
| backend | `emr-backend:latest` | `8080` | API (alembic, JWT), экспорт метрик `/metrics` |
| frontend | `emr-frontend:latest` | `5173` | Веб-интерфейс (nginx) |
| prometheus | `prom/prometheus:v3.5.4` | `9090` | Сбор метрик и alert-правила |
| grafana | `grafana/grafana:12.4.4` | `3000` | Визуализация (анонимный просмотр) |

Образы prometheus/grafana собираются с «запечёнными» конфигами (см. `*.Dockerfile`),
поэтому переживают пересоздание контейнеров.

## Запуск

```
cp .env.example .env   # заполнить значения
docker compose up -d --build
```

## Переменные окружения

Перечислены в `.env.example`: пароль БД, JWT-секрет, пароль администратора Grafana, CORS и URL фронтенда.

## Деплой

Push в `master` запускает пайплайн (`.gitlab-ci.yml`):

1. **validate** — проверка `docker compose config` и конфигурации Prometheus (`promtool`).
2. **deploy** — пересборка prometheus/grafana, поднятие стека, ожидание готовности бэкенда,
   миграции `alembic` (с повтором) и `seed.py` только при пустой таблице `users`.

## Мониторинг

Подробно — в [grafana/README.md](grafana/README.md). Alert-правила под SLA (доступность,
доля 5xx ≤ 1%, p95 ≤ 3s) — в `alerts.yml`.
