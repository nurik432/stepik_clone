import enum

from sqlalchemy import Boolean, Enum, ForeignKey, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base
from app.models._mixins import TimestampMixin, UUIDPrimaryKeyMixin


class ProgressStatus(str, enum.Enum):
    not_started = "not_started"
    in_progress = "in_progress"
    completed = "completed"


class Progress(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "progress"
    __table_args__ = (
        UniqueConstraint("student_id", "lesson_id", name="uq_progress_student_lesson"),
    )

    student_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, index=True)
    student = relationship("User", back_populates="progress_rows")

    lesson_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("lessons.id"), nullable=False, index=True)
    lesson = relationship("Lesson", back_populates="progress_rows")

    status: Mapped[ProgressStatus] = mapped_column(
        Enum(ProgressStatus, name="progress_status"), nullable=False, server_default=ProgressStatus.not_started.value
    )

    # быстрый флаг для подсчётов
    is_completed: Mapped[bool] = mapped_column(Boolean, nullable=False, server_default="false", index=True)

