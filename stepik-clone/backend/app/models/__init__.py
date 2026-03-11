# backend/app/models/__init__.py
from app.database import Base
from app.models.user import User, Waitlist
from app.models.course import Category, Course, Module, Lesson
from app.models.lesson import LessonContent, Quiz, QuizQuestion, QuizOption
from app.models.enrollment import Enrollment, Progress, QuizAttempt
from app.models.social import Certificate, Comment

# All models must be imported here for Alembic to auto-discover them
