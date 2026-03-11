# Используем официальный образ с уже установленным Flutter
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Копируем все файлы репозитория в контейнер
COPY . .

# Переходим в папку с Flutter-проектом
WORKDIR /app/stepik-clone

# Активируем web-платформу и подтягиваем зависимости
RUN flutter create --platforms=web .
RUN flutter pub get

# Раскомментируйте строку ниже, если в проекте используется кодогенерация (freezed, json_serializable)
# RUN dart run build_runner build --delete-conflicting-outputs

# Собираем веб-версию
RUN flutter build web --release

# Поднимаем легкий Nginx сервер для раздачи собранного приложения
FROM nginx:alpine
# Копируем собранные файлы (убедитесь, что путь соответствует WORKDIR)
COPY --from=build /app/stepik-clone/build/web /usr/share/nginx/html

EXPOSE 80
CMD["nginx", "-g", "daemon off;"]