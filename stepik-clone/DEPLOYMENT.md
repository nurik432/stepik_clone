# Deployment Guide - Stepik Clone

This guide explains how to deploy the `stepik-clone` project to a Linux VPS using Docker and GitHub Actions.

## Prerequisites

1.  **Linux VPS**: A server running Ubuntu 22.04 or 24.04 (recommended: 2GB+ RAM).
2.  **Docker & Docker Compose**: Installed on the server.
3.  **GitHub Repository**: Your project must be pushed to GitHub.

## Step 1: Server Setup

Connect to your VPS via SSH and run:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo apt install -y docker-compose-plugin
```

## Step 2: GHCR Package Visibility (FIX for "denied" error)

По умолчанию GitHub делает ваши пакеты (образы) приватными. Чтобы сервер мог их скачать:
1. Зайдите в ваш профиль GitHub -> вкладка **Packages**.
2. Найдите `stepik-backend` и `stepik-frontend`.
3. Зайдите в каждый: **Package Settings** -> прокрутите вниз до **Danger Zone**.
4. Нажмите **Change visibility** и выберите **Public**.

*Это решит проблему с ошибкой "denied" при выполнении pull.*

## Step 2: GitHub Secrets & Security

You don't need to manually clone the repository on the VPS. GitHub Actions will handle everything once you set up these secrets in your GitHub repository (**Settings** -> **Secrets and variables** -> **Actions**).

### 1. SERVER_IP
This is the public IP address of your VPS. You can find it in your hosting provider's dashboard (e.g., DigitalOcean, Hetzner, AWS).

### 2. SSH_PRIVATE_KEY
This allows GitHub to securely log into your server.

**How to generate:**
1.  Open terminal on your computer and run:
    ```bash
    ssh-keygen -t rsa -b 4096 -f ./deploy_key -N ""
    ```
2.  This creates two files: `deploy_key` (private) and `deploy_key.pub` (public).
3.  **On the VPS**: Copy the content of `deploy_key.pub` and add it to the server's authorized list:
    ```bash
    mkdir -p ~/.ssh
    echo "PASTE_CONTENT_OF_DEPLOY_KEY_PUB_HERE" >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    ```
4.  **On GitHub**: Create a secret named `SSH_PRIVATE_KEY` and paste the **entire** content of the private `deploy_key` file.
    Чтобы увидеть содержимое ключа, выполните:
    ```bash
    cat ./deploy_key
    ```
    (Скопируйте всё, включая `-----BEGIN...` и `-----END...`)

5.  **На сервере**: Покажите публичный ключ, чтобы добавить его:
    ```bash
    cat ./deploy_key.pub
    ```
    Скопируйте результат и добавьте в `~/.ssh/authorized_keys` на VPS.

> [!IMPORTANT]
> Строка вида `SHA256:H+1es...` — это **отпечаток** (fingerprint), а не сам ключ. Для настройки вам нужен именно текст из файлов `deploy_key` и `deploy_key.pub`.

### 3. DB_PASSWORD & JWT_SECRET
- `DB_PASSWORD`: Any strong password for your database.
- `JWT_SECRET`: A long random string (e.g., 32+ characters). You can generate one with:
  ```bash
  openssl rand -hex 32
  ```

## Step 3: Initial Setup on VPS

Before the first deployment, run this on your VPS to create the target directory:
```bash
mkdir -p ~/stepik-clone
```

## Step 4: Run Deployment

1.  Push your code to the `main` branch on GitHub.
2.  Go to the **Actions** tab in your GitHub repository.
3.  You will see the "Build and Deploy" workflow running. 
4.  Once it finishes (green checkmark), your app is live!

## Step 4: Maintenance

To view logs on the server:
```bash
cd ~/stepik-clone
docker compose -f docker-compose.prod.yml logs -f
```

To stop the services:
```bash
cd ~/stepik-clone
docker compose -f docker-compose.prod.yml down
```
