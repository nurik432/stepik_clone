from sqlalchemy import ForeignKey, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base
from app.models._mixins import TimestampMixin, UUIDPrimaryKeyMixin


class LessonContent(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "lesson_content"

    lesson_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("lessons.id"), nullable=False, unique=True, index=True
    )
    lesson = relationship("Lesson", back_populates="content")

    # video
    video_s3_key: Mapped[str | None] = mapped_column(Text, nullable=True)

    # text (rich text сохраняем как JSON)
    rich_text: Mapped[dict | None] = mapped_column(JSONB, nullable=True)

    # code task
    code_prompt: Mapped[str | None] = mapped_column(Text, nullable=True)
    expected_output: Mapped[str | None] = mapped_column(Text, nullable=True)

