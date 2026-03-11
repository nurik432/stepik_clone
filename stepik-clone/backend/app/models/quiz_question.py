import enum

from sqlalchemy import Enum, ForeignKey, Integer, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base
from app.models._mixins import TimestampMixin, UUIDPrimaryKeyMixin


class QuizQuestionType(str, enum.Enum):
    multiple_choice = "multiple_choice"
    single_choice = "single_choice"
    true_false = "true_false"


class QuizQuestion(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "quiz_questions"

    quiz_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("quizzes.id"), nullable=False, index=True)
    quiz = relationship("Quiz", back_populates="questions")

    order_index: Mapped[int] = mapped_column(Integer, nullable=False, server_default="0", index=True)
    question_type: Mapped[QuizQuestionType] = mapped_column(
        Enum(QuizQuestionType, name="quiz_question_type"), nullable=False, index=True
    )

    prompt: Mapped[str] = mapped_column(Text, nullable=False)

    # Варианты/правильные ответы: JSON (на Step 5 добавим строгую валидацию в схемах)
    options: Mapped[list[dict] | None] = mapped_column(JSONB, nullable=True)
    correct_answer: Mapped[dict | None] = mapped_column(JSONB, nullable=True)

