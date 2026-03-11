# backend/tests/test_auth.py
import pytest
from fastapi.testclient import TestClient
from app.core.config import settings

def test_register_user(client: TestClient):
    response = client.post(
        "/api/auth/register",
        json={"email": "test@example.com", "password": "password123"}
    )
    assert response.status_code == 201
    assert response.json()["email"] == "test@example.com"

def test_register_duplicate_email(client: TestClient):
    client.post(
        "/api/auth/register",
        json={"email": "dup@example.com", "password": "password123"}
    )
    response = client.post(
        "/api/auth/register",
        json={"email": "dup@example.com", "password": "password123"}
    )
    assert response.status_code == 400
    assert "уже существует" in response.json()["detail"]

def test_login_success(client: TestClient):
    # Register
    client.post(
        "/api/auth/register",
        json={"email": "login@example.com", "password": "password123"}
    )
    # Login
    response = client.post(
        "/api/auth/login",
        json={"email": "login@example.com", "password": "password123"}
    )
    assert response.status_code == 200
    assert "access_token" in response.json()
    assert response.json()["token_type"] == "bearer"

def test_login_wrong_password(client: TestClient):
    client.post(
        "/api/auth/register",
        json={"email": "wrong@example.com", "password": "password123"}
    )
    response = client.post(
        "/api/auth/login",
        json={"email": "wrong@example.com", "password": "wrongpassword"}
    )
    assert response.status_code == 400
    assert "Неверный email или пароль" in response.json()["detail"]
