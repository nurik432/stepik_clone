# Create script to setup admin user
import sys
import os

# Добавляем корневую папку в пути поиска модулей
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.models.user import User, RoleEnum
from app.core import security

def create_admin(email, password):
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.email == email).first()
        if user:
            print(f"User {email} already exists. Updating role to admin.")
            user.role = RoleEnum.admin
            user.hashed_password = security.get_password_hash(password)
        else:
            print(f"Creating new admin user: {email}")
            hashed_password = security.get_password_hash(password)
            user = User(
                email=email,
                hashed_password=hashed_password,
                role=RoleEnum.admin
            )
            db.add(user)
        db.commit()
        print("Success!")
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python scripts/init_admin.py <email> <password>")
    else:
        create_admin(sys.argv[1], sys.argv[2])
