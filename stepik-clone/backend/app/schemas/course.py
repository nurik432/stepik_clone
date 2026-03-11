# backend/app/schemas/course.py
from typing import Optional, List
from pydantic import BaseModel

class CategoryBase(BaseModel):
    name: str
    description: Optional[str] = None

class CategoryResponse(CategoryBase):
    id: int
    class Config:
        from_attributes = True

class ModuleBase(BaseModel):
    title: str
    order: int

class ModuleCreate(ModuleBase):
    pass

class ModuleResponse(ModuleBase):
    id: int
    course_id: int
    class Config:
        from_attributes = True

class CourseBase(BaseModel):
    title: str
    description: Optional[str] = None
    cover_image_url: Optional[str] = None
    category_id: Optional[int] = None
    is_paid: bool = False
    price: float = 0.0
    is_published: bool = False

class CourseCreate(CourseBase):
    pass

class CourseUpdate(CourseBase):
    pass

class CourseResponse(CourseBase):
    id: int
    teacher_id: int
    modules: List[ModuleResponse] = []
    class Config:
        from_attributes = True
