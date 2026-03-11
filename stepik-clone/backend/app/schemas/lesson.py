# backend/app/schemas/lesson.py
from typing import Optional, List
from pydantic import BaseModel
from app.models.lesson import LessonTypeEnum, QuestionTypeEnum

# Lesson
class LessonBase(BaseModel):
    title: str
    order: int
    type: LessonTypeEnum

class LessonCreate(LessonBase):
    pass

class LessonResponse(LessonBase):
    id: int
    module_id: int
    class Config:
        from_attributes = True

# Content
class LessonContentBase(BaseModel):
    video_url: Optional[str] = None
    content_text: Optional[str] = None

class LessonContentCreate(LessonContentBase):
    pass

class LessonContentResponse(LessonContentBase):
    id: int
    lesson_id: int
    class Config:
        from_attributes = True

# Quiz
class QuizOptionBase(BaseModel):
    text: str
    is_correct: bool = False

class QuizOptionCreate(QuizOptionBase):
    pass

class QuizOptionResponse(QuizOptionBase):
    id: int
    class Config:
        from_attributes = True

class QuizQuestionBase(BaseModel):
    text: str
    type: QuestionTypeEnum

class QuizQuestionCreate(QuizQuestionBase):
    options: List[QuizOptionCreate]

class QuizQuestionResponse(QuizQuestionBase):
    id: int
    options: List[QuizOptionResponse] = []
    class Config:
        from_attributes = True

class QuizBase(BaseModel):
    pass

class QuizCreate(QuizBase):
    questions: List[QuizQuestionCreate]

class QuizResponse(QuizBase):
    id: int
    lesson_id: int
    questions: List[QuizQuestionResponse] = []
    class Config:
        from_attributes = True
