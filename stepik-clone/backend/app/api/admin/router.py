# backend/app/api/admin/router.py
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.api import deps
from app.models.user import User, RoleEnum, Waitlist
from app.models.course import Course
from app.models.enrollment import Enrollment
from app.schemas.admin import PlatformStats, WaitlistEntryResponse
from app.schemas.user import UserResponse
from app.core.config import settings

router = APIRouter()

def check_admin_access(current_user: User = Depends(deps.get_current_active_user)):
    if current_user.role != RoleEnum.admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="The user does not have enough privileges"
        )
    return current_user

@router.get("/stats", response_model=PlatformStats)
def get_platform_stats(
    db: Session = Depends(get_db),
    admin: User = Depends(check_admin_access)
):
    total_users = db.query(User).count()
    total_courses = db.query(Course).count()
    total_enrollments = db.query(Enrollment).count()
    waitlist_count = db.query(Waitlist).count()
    
    return PlatformStats(
        total_users=total_users,
        user_limit=settings.MAX_USERS_LIMIT,
        total_courses=total_courses,
        total_enrollments=total_enrollments,
        waitlist_count=waitlist_count
    )

@router.get("/users", response_model=List[UserResponse])
def list_users(
    db: Session = Depends(get_db),
    admin: User = Depends(check_admin_access),
    skip: int = 0,
    limit: int = 100
):
    users = db.query(User).offset(skip).limit(limit).all()
    return users

@router.get("/waitlist", response_model=List[WaitlistEntryResponse])
def list_waitlist(
    db: Session = Depends(get_db),
    admin: User = Depends(check_admin_access)
):
    waitlist = db.query(Waitlist).all()
    return waitlist
