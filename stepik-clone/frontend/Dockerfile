# frontend/Dockerfile
# Multi-stage build for Flutter Web
FROM ubuntu:22.04 AS build

# Prerequisites
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor
RUN flutter config --enable-web

# Build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web

# Production server: Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
