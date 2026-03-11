from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base
from app.models._mixins import TimestampMixin, UUIDPrimaryKeyMixin


class Role(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "roles"

    # student | teacher | admin
    name: Mapped[str] = mapped_column(String(32), unique=True, nullable=False, index=True)

    users = relationship("User", back_populates="role")

