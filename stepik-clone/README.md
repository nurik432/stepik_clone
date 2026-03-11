## Stepik Clone (Flutter + FastAPI)

Монорепозиторий для кроссплатформенного образовательного приложения (iOS/Android/Web) и backend API.

### Структура

- `frontend/` — Flutter приложение (Riverpod, Material 3, l10n RU/EN)
- `backend/` — FastAPI (Swagger включён)
- `database/` — миграции (будут добавлены на Step 2)

### Быстрый старт (backend)

```bash
cd backend
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Swagger: `http://127.0.0.1:8000/docs`

### Быстрый старт (frontend)

```bash
cd frontend
flutter pub get
flutter run
```

