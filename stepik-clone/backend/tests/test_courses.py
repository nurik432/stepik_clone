# backend/tests/test_courses.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from app.models.user import User, RoleEnum

def test_get_courses_empty(client: TestClient):
    response = client.get("/api/courses/")
    assert response.status_code == 200
    assert response.json() == []

def test_create_course_unauthorized(client: TestClient):
    response = client.post(
        "/api/courses/",
        json={"title": "Test Course", "description": "Description"}
    )
    # No token provided
    assert response.status_code == 401

def test_create_course_success(client: TestClient, db: Session):
    # 1. Register
    client.post(
        "/api/auth/register",
        json={"email": "teacher@example.com", "password": "password123"}
    )
    
    # 2. Grant teacher role manually in DB
    user = db.query(User).filter(User.email == "teacher@example.com").first()
    user.role = RoleEnum.teacher
    db.commit()

    # 3. Login
    login_res = client.post(
        "/api/auth/login",
        json={"email": "teacher@example.com", "password": "password123"}
    )
    token = login_res.json()["access_token"]
    
    # 4. Create course
    response = client.post(
        "/api/courses/",
        json={"title": "Test Course", "description": "Description", "is_published": True},
        headers={"Authorization": f"Bearer {token}"}
    )
    assert response.status_code == 201
    assert response.json()["title"] == "Test Course"
    
    # 3. Check list
    list_res = client.get("/api/courses/")
    assert list_res.status_code == 200
    assert len(list_res.json()) == 1
    assert list_res.json()[0]["title"] == "Test Course"
