# backend/app/schemas/admin.py
from datetime import datetime
from typing import List
from pydantic import BaseModel
from app.schemas.user import UserResponse

class PlatformStats(BaseModel):
    total_users: int
    user_limit: int
    total_courses: int
    total_enrollments: int
    waitlist_count: int

class WaitlistEntryResponse(BaseModel):
    id: int
    email: str
    added_at: datetime

    class Config:
        from_attributes = True
