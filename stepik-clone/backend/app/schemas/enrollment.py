# backend/app/schemas/enrollment.py
from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class EnrollmentBase(BaseModel):
    course_id: int

class EnrollmentCreate(EnrollmentBase):
    pass

class EnrollmentResponse(EnrollmentBase):
    id: int
    user_id: int
    enrolled_at: datetime

    class Config:
        from_attributes = True

class ProgressBase(BaseModel):
    lesson_id: int
    is_completed: bool = True

class ProgressCreate(ProgressBase):
    pass

class ProgressResponse(ProgressBase):
    id: int
    user_id: int
    completed_at: datetime

    class Config:
        from_attributes = True

class QuizAttemptBase(BaseModel):
    quiz_id: int
    score: float

class QuizAttemptCreate(QuizAttemptBase):
    pass

class QuizAttemptResponse(QuizAttemptBase):
    id: int
    user_id: int
    attempt_at: datetime

    class Config:
        from_attributes = True
