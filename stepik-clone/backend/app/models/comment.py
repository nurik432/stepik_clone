from sqlalchemy import ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base
from app.models._mixins import TimestampMixin, UUIDPrimaryKeyMixin


class Comment(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "comments"

    lesson_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("lessons.id"), nullable=False, index=True)
    lesson = relationship("Lesson", back_populates="comments")

    author_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, index=True)
    author = relationship("User", back_populates="comments")

    body: Mapped[str] = mapped_column(Text, nullable=False)

