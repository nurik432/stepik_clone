# backend/app/api/auth/router.py
from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.core import security
from app.core.config import settings
from app.models.user import User, Waitlist
from app.schemas.user import UserCreate, UserLogin, UserResponse, Token

router = APIRouter()

@router.post(
    "/register", 
    response_model=UserResponse, 
    status_code=status.HTTP_201_CREATED,
    summary="Регистрация нового пользователя",
    description="Регистрирует нового студента. Если достигнут лимит в 3000 пользователей, email добавляется в лист ожидания."
)
def register(user_in: UserCreate, db: Session = Depends(get_db)):
    # Проверка лимита в 3000 пользователей
    user_count = db.query(User).count()
    if user_count >= settings.MAX_USERS_LIMIT:
        # Проверяем, есть ли уже в вейтлисте
        in_waitlist = db.query(Waitlist).filter(Waitlist.email == user_in.email).first()
        if not in_waitlist:
            waitlist_entry = Waitlist(email=user_in.email)
            db.add(waitlist_entry)
            db.commit()
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="Регистрация закрыта (достигнут лимит 3000 пользователей). Ваш email добавлен в лист ожидания."
        )

    # Проверка уникальности email
    user = db.query(User).filter(User.email == user_in.email).first()
    if user:
        raise HTTPException(status_code=400, detail="Пользователь с таким email уже существует")
    
    # Создание пользователя
    hashed_password = security.get_password_hash(user_in.password)
    db_user = User(
        email=user_in.email,
        hashed_password=hashed_password,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@router.post(
    "/login", 
    response_model=Token,
    summary="Вход в систему",
    description="Аутентификация пользователя по email и паролю. Возвращает JWT токен доступа."
)
def login(user_in: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == user_in.email).first()
    if not user:
        raise HTTPException(status_code=400, detail="Неверный email или пароль")
    
    if not security.verify_password(user_in.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Неверный email или пароль")
    
    if not user.is_active:
        raise HTTPException(status_code=400, detail="Аккаунт заблокирован")
        
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(
        subject=user.id, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
    }
