# Этап 1: Сборка Flutter-приложения
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем все файлы вашего репозитория в контейнер
COPY . .

# Мы уже в папке /app, где лежат файлы Flutter из COPY

# Включаем поддержку Web и создаем нужные файлы.
# Флаг --project-name stepik_clone обязателен, чтобы обойти ошибку с дефисом в имени папки!
RUN flutter config --enable-web
# RUN flutter create --platforms=web --project-name stepik_clone .

# Скачиваем зависимости
RUN flutter pub get

# Раскомментируйте строку ниже (уберите #), если вы используете кодогенерацию
# (например, пакеты freezed, json_serializable, auto_route)
# RUN dart run build_runner build --delete-conflicting-outputs

# Генерируем файлы локализации (обязательно перед сборкой!)
RUN flutter gen-l10n

# Собираем релизную веб-версию
RUN flutter build web --release -v

# Этап 2: Раздача статики через Nginx
FROM nginx:alpine

# Копируем собранный проект из первого этапа (/app/build/web)
COPY --from=build /app/build/web /usr/share/nginx/html

# Открываем 80 порт
EXPOSE 80

# Запускаем сервер (пробел после CMD добавлен!)
CMD ["nginx", "-g", "daemon off;"]