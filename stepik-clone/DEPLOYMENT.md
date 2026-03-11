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

## Step 2: GitHub Secrets

Navigate to your GitHub repository -> **Settings** -> **Secrets and variables** -> **Actions**. Add the following secrets:

| Secret Name | Description | Example |
| :--- | :--- | :--- |
| `SERVER_IP` | Your VPS public IP address | `123.123.123.123` |
| `SSH_PRIVATE_KEY` | Private SSH key for deployment | `-----BEGIN RSA PRIVATE KEY-----...` |
| `DB_PASSWORD` | PostgreSQL password | `mypassword123` |
| `JWT_SECRET` | Secret key for JWT tokens | `generate-a-long-random-string` |

## Step 3: Deployment Workflow

The project is configured with GitHub Actions (`.github/workflows/deploy.yml`). 

-   **Automatic**: Every push to the `main` branch will build new Docker images and deploy them to your server.
-   **Manual**: You can trigger the workflow from the **Actions** tab in GitHub.

## Step 4: Maintenance

To view logs on the server:
```bash
docker compose -f docker-compose.prod.yml logs -f
```

To stop the services:
```bash
docker compose -f docker-compose.prod.yml down
```
