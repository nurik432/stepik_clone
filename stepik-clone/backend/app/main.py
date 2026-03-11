from fastapi import FastAPI
from app.api.auth.router import router as auth_router
from app.api.courses.router import router as courses_router
from app.api.lessons.router import router as lessons_router
from app.api.enrollments.router import router as enrollments_router
from app.api.progress.router import router as progress_router
from app.api.admin.router import router as admin_router

# Инициализация FastAPI приложения
app = FastAPI(
    title="Stepik Clone API",
    description="""
Программный интерфейс (API) для образовательной платформы, аналогичной Stepik.
Позволяет пользователям регистрироваться, проходить курсы, а преподавателям — создавать контент.

### Особенности:
* **JWT Авторизация**
* **Лимит 3000 пользователей** с автоматическим листом ожидания
* **Конструктор курсов** (текст, видео, тесты)
* **Панель администратора** для мониторинга статистики
""",
    version="1.0.0",
    terms_of_service="http://example.com/terms/",
    contact={
        "name": "Stepik Clone Team",
        "url": "http://example.com/contact/",
        "email": "support@example.com",
    },
    license_info={
        "name": "Apache 2.0",
        "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
    },
)

@app.get("/")
def read_root():
    # Возвращаем приветственное сообщение
    return {"message": "Добро пожаловать в API Stepik Clone"}

app.include_router(auth_router, prefix="/api/auth", tags=["auth"])
app.include_router(courses_router, prefix="/api/courses", tags=["courses"])
app.include_router(lessons_router, prefix="/api/lessons", tags=["lessons"])
app.include_router(enrollments_router, prefix="/api/enrollments", tags=["enrollments"])
app.include_router(progress_router, prefix="/api/progress", tags=["progress"])
app.include_router(admin_router, prefix="/api/admin", tags=["admin"])
