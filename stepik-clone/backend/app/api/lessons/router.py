# backend/app/api/lessons/router.py
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from app.database import get_db
from app.api import deps
from app.models.user import User, RoleEnum
from app.models.course import Course, Module, Lesson
from app.models.lesson import LessonContent, Quiz, QuizQuestion, QuizOption
from app.schemas.lesson import (
    LessonCreate, LessonResponse, 
    LessonContentCreate, LessonContentResponse,
    QuizCreate, QuizResponse, QuizQuestionResponse, QuizOptionResponse
)
from app.services.s3_service import MockS3Service

router = APIRouter()

def check_teacher_access(db: Session, current_user: User, course_id: int):
    if current_user.role == RoleEnum.admin:
        return True
    if current_user.role != RoleEnum.teacher:
        raise HTTPException(status_code=403, detail="Not a teacher")
    course = db.query(Course).filter(Course.id == course_id).first()
    if not course or course.teacher_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not your course")
    return True

@router.post("/module/{module_id}/lessons", response_model=LessonResponse, status_code=status.HTTP_201_CREATED)
def create_lesson(
    module_id: int,
    lesson_in: LessonCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    module = db.query(Module).filter(Module.id == module_id).first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")
    
    check_teacher_access(db, current_user, module.course_id)
    
    db_lesson = Lesson(**lesson_in.model_dump(), module_id=module_id)
    db.add(db_lesson)
    db.commit()
    db.refresh(db_lesson)
    return db_lesson

@router.post("/{lesson_id}/content", response_model=LessonContentResponse, status_code=status.HTTP_201_CREATED)
def create_lesson_content(
    lesson_id: int,
    content_in: LessonContentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
        
    check_teacher_access(db, current_user, lesson.module.course_id)
    
    db_content = LessonContent(**content_in.model_dump(), lesson_id=lesson_id)
    db.add(db_content)
    db.commit()
    db.refresh(db_content)
    return db_content

@router.post("/{lesson_id}/video", response_model=LessonContentResponse)
async def upload_lesson_video(
    lesson_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
        
    check_teacher_access(db, current_user, lesson.module.course_id)
    
    # Имитация загрузки в S3
    video_url = await MockS3Service.upload_video(file)
    
    # Обновляем или создаем контент
    db_content = db.query(LessonContent).filter(LessonContent.lesson_id == lesson_id).first()
    if db_content:
        db_content.video_url = video_url
    else:
        db_content = LessonContent(lesson_id=lesson_id, video_url=video_url)
        db.add(db_content)
        
    db.commit()
    db.refresh(db_content)
    return db_content

@router.post("/{lesson_id}/quiz", response_model=QuizResponse, status_code=status.HTTP_201_CREATED)
def create_quiz(
    lesson_id: int,
    quiz_in: QuizCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
        
    check_teacher_access(db, current_user, lesson.module.course_id)
    
    # Создаем Quiz
    db_quiz = Quiz(lesson_id=lesson_id)
    db.add(db_quiz)
    db.commit()
    db.refresh(db_quiz)
    
    # Добавляем вопросы и опции
    for q_in in quiz_in.questions:
        db_q = QuizQuestion(quiz_id=db_quiz.id, text=q_in.text, type=q_in.type)
        db.add(db_q)
        db.commit()
        db.refresh(db_q)
        
        for opt_in in q_in.options:
            db_opt = QuizOption(question_id=db_q.id, text=opt_in.text, is_correct=opt_in.is_correct)
            db.add(db_opt)
    
    db.commit()
    
    # Возвращаем обновленный Quiz с relationship
    db.refresh(db_quiz)
    return db_quiz
