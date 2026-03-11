from fastapi import APIRouter


router = APIRouter(prefix="/users")


@router.get("/health", summary="Проверка модуля users")
def users_health():
    # На Step 7 здесь будут admin-операции с пользователями
    return {"status": "ok", "module": "users"}

