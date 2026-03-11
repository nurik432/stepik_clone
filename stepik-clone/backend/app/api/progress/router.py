# backend/app/api/progress/router.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.api import deps
from app.models.user import User
from app.models.course import Lesson
from app.models.enrollment import Progress, QuizAttempt
from app.models.lesson import Quiz
from app.schemas.enrollment import ProgressResponse, QuizAttemptResponse, QuizAttemptCreate

router = APIRouter()

@router.post("/lesson/{lesson_id}", response_model=ProgressResponse)
def mark_lesson_completed(
    lesson_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    # Check if already marked as completed
    existing_progress = db.query(Progress).filter(
        Progress.lesson_id == lesson_id,
        Progress.user_id == current_user.id
    ).first()
    
    if existing_progress:
        return existing_progress
    
    db_progress = Progress(user_id=current_user.id, lesson_id=lesson_id, is_completed=True)
    db.add(db_progress)
    db.commit()
    db.refresh(db_progress)
    return db_progress

@router.post("/quiz/{quiz_id}", response_model=QuizAttemptResponse)
def submit_quiz_attempt(
    quiz_id: int,
    attempt_in: QuizAttemptCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(deps.get_current_active_user)
):
    quiz = db.query(Quiz).filter(Quiz.id == quiz_id).first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    
    db_attempt = QuizAttempt(
        user_id=current_user.id,
        quiz_id=quiz_id,
        score=attempt_in.score
    )
    db.add(db_attempt)
    db.commit()
    db.refresh(db_attempt)
    return db_attempt
