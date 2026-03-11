# frontend/Dockerfile
# Multi-stage build for Flutter Web
FROM ubuntu:22.04 AS build

# Prerequisites
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils libglu1-mesa ca-certificates wget \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter (Stable channel)
RUN git clone -b stable https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-download artifacts
RUN flutter config --enable-web
RUN flutter precache --web
RUN flutter doctor -v

# Build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Production server: Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
