# backend/app/api/courses/router.py
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.api import deps
from app.models.user import User, RoleEnum
from app.models.course import Course, Module
from app.schemas.course import CourseCreate, CourseUpdate, CourseResponse, ModuleCreate, ModuleResponse

router = APIRouter()

@router.get(
    "/", 
    response_model=List[CourseResponse],
    summary="Список опубликованных курсов",
    description="Возвращает список всех курсов, которые были опубликованы преподавателями."
)
def get_courses(db: Session = Depends(get_db), skip: int = 0, limit: int = 100):
    # Public endpoint to view published courses
    courses = db.query(Course).filter(Course.is_published == True).offset(skip).limit(limit).all()
    return courses

@router.get(
    "/teacher", 
    response_model=List[CourseResponse],
    summary="Мои курсы (для преподавателя)",
    description="Возвращает список курсов, созданных текущим пользователем."
)
def get_teacher_courses(
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    if current_user.role not in [RoleEnum.teacher, RoleEnum.admin]:
        raise HTTPException(status_code=403, detail="Not enough privileges")
    courses = db.query(Course).filter(Course.teacher_id == current_user.id).all()
    return courses

@router.post(
    "/", 
    response_model=CourseResponse, 
    status_code=status.HTTP_201_CREATED,
    summary="Создать новый курс",
    description="Создает новый курс. Только для пользователей с ролями 'teacher' или 'admin'."
)
def create_course(
    course_in: CourseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    if current_user.role not in [RoleEnum.teacher, RoleEnum.admin]:
        raise HTTPException(status_code=403, detail="Not enough privileges")
    
    db_course = Course(**course_in.model_dump(), teacher_id=current_user.id)
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course

@router.put("/{course_id}", response_model=CourseResponse)
def update_course(
    course_id: int,
    course_in: CourseUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    db_course = db.query(Course).filter(Course.id == course_id).first()
    if not db_course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    if db_course.teacher_id != current_user.id and current_user.role != RoleEnum.admin:
        raise HTTPException(status_code=403, detail="Not enough privileges")
        
    for var, value in course_in.model_dump(exclude_unset=True).items():
        setattr(db_course, var, value)
        
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course

@router.post("/{course_id}/modules", response_model=ModuleResponse, status_code=status.HTTP_201_CREATED)
def create_module(
    course_id: int,
    module_in: ModuleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    db_course = db.query(Course).filter(Course.id == course_id).first()
    if not db_course:
        raise HTTPException(status_code=404, detail="Course not found")
        
    if db_course.teacher_id != current_user.id and current_user.role != RoleEnum.admin:
        raise HTTPException(status_code=403, detail="Not enough privileges")
        
    db_module = Module(**module_in.model_dump(), course_id=course_id)
    db.add(db_module)
    db.commit()
    db.refresh(db_module)
    return db_module
