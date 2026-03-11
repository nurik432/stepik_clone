from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.settings import settings

engine = create_engine(settings.database_url, pool_pre_ping=True)

SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False, class_=Session)


def get_db():
    # Dependency для FastAPI. Используем yield, чтобы гарантированно закрывать сессию.
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

