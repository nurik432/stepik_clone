from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Базовые настройки проекта. На Step 2 добавим БД/Redis/S3 и Alembic.
    app_name: str = "stepik-clone"
    debug: bool = True

    # База данных (PostgreSQL)
    database_url: str = "postgresql+psycopg://postgres:postgres@localhost:5432/stepik_clone"

    # JWT (на Step 3 будет полноценный auth + refresh flow)
    jwt_secret: str = "dev-secret-change-me"
    jwt_algorithm: str = "HS256"

    model_config = SettingsConfigDict(env_file=".env", env_prefix="APP_", extra="ignore")


settings = Settings()

