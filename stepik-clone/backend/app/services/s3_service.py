# backend/app/services/s3_service.py
import uuid
import asyncio
from fastapi import UploadFile

class MockS3Service:
    @staticmethod
    async def upload_video(file: UploadFile) -> str:
        """
        Мок-метод для загрузки видео.
        В реальном приложении здесь должен быть boto3 s3 client.upload_fileobj.
        """
        # Имитируем задержку сети
        await asyncio.sleep(1.5)
        
        # Генерируем фейковый URL
        file_ext = file.filename.split('.')[-1] if '.' in file.filename else 'mp4'
        fake_s3_url = f"https://cdn.stepik-clone.local/videos/{uuid.uuid4()}.{file_ext}"
        return fake_s3_url
