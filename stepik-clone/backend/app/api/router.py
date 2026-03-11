from fastapi import APIRouter

from app.api.auth.router import router as auth_router
from app.api.courses.router import router as courses_router
from app.api.lessons.router import router as lessons_router
from app.api.users.router import router as users_router


api_router = APIRouter(prefix="/api")

# На следующих шагах здесь появятся реальные endpoints из ТЗ.
api_router.include_router(auth_router, tags=["auth"])
api_router.include_router(users_router, tags=["users"])
api_router.include_router(courses_router, tags=["courses"])
api_router.include_router(lessons_router, tags=["lessons"])

