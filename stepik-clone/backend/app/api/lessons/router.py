from fastapi import APIRouter


router = APIRouter(prefix="/lessons")


@router.get("/health", summary="Проверка модуля lessons")
def lessons_health():
    # На Step 5 здесь появится конструктор уроков и контент
    return {"status": "ok", "module": "lessons"}

