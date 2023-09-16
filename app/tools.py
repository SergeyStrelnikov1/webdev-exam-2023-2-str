import hashlib
import os
from werkzeug.utils import secure_filename
from models import Cover
from app import db, app

class CoverSaver:
    def __init__(self, file):
        self.file = file

    def save(self):
        self.img = self.__find_by_md5_hash()
        if self.img is not None:
            return self.img
        file = secure_filename(self.file.filename)
        self.id = self.MD5
        file = self.id + os.path.splitext(file)[1]
        self.img = Cover(
            id = self.id,
            file = file,
            MIME = self.file.mimetype,
            MD5 = self.MD5)
        self.file.save(
            os.path.join(app.config['UPLOAD_FOLDER'],
                         self.img.storage_filename))
        db.session.add(self.img)
        db.session.commit()
        return self.img

    def __find_by_md5_hash(self):
        self.MD5 = hashlib.md5(self.file.read()).hexdigest()
        self.file.seek(0)
        return db.session.execute(db.select(Cover).filter(Cover.MD5 == self.MD5)).scalar()