# backend/app/core/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Stepik Clone"
    API_V1_STR: str = "/api"
    
    SECRET_KEY: str = "a_very_secret_key_for_development_only_change_in_production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7 # 7 days
    
    MAX_USERS_LIMIT: int = 3000

    class Config:
        case_sensitive = True

settings = Settings()
