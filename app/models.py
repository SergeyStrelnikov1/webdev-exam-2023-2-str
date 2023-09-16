import os
import sqlalchemy as sa
from werkzeug.security import check_password_hash, generate_password_hash
from flask_login import UserMixin
from flask import url_for
from app import db
from check_rights import CheckRights
from sqlalchemy.sql import func

class Role(db.Model):
    __tablename__ = 'roles'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    description = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return '<Role %r>' % self.id % self.title

class User(db.Model, UserMixin):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    last_name = db.Column(db.String(100), nullable=False)
    first_name = db.Column(db.String(100), nullable=False)
    middle_name = db.Column(db.String(100))
    login = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def is_administrator(self):
        return self.role_id == 3
    
    def is_moderator(self):
        return self.role_id == 2
    
    def can(self, action, record=None):
        users_policy = CheckRights(record)
        method = getattr(users_policy, action, None)
        if method:
            return method()
        return False

    @property
    def full_name(self):
        return ' '.join([self.last_name, self.first_name, self.middle_name or ''])

    def __repr__(self):
        return '<User %r>' % self.login

class Book(db.Model):
    __tablename__ = 'books'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    brief = db.Column(db.Text, nullable=False)
    year = db.Column(db.Integer, nullable=False)
    publisher = db.Column(db.String(100), nullable=False)
    author = db.Column(db.String(100), nullable=False)
    page_number = db.Column(db.Integer, nullable=False)
    cover_id = db.Column(db.String(250), db.ForeignKey('covers.id'), nullable=False)

    def __repr__(self):
        return '<Book %r>' % self.id % self.name
    
    @property
    def cover(self):
        return db.session.execute(db.select(Cover).filter_by(id=self.cover_id)).scalar()
    
    @property
    def genres(self):
        books_genres = db.session.execute(db.Select(Book_Genre).filter_by(book_id = self.id)).all()
        genres = []
        for book_genre in books_genres:
            genre = db.session.execute(db.select(Genre).filter_by(id=book_genre[0].genre_id)).scalar()
            genres.append(genre.title)
        return genres
    
    @property
    def score(self):
        column = func.avg(Review.score)
        score = db.session.execute( db.session.query(column).filter(Review.book_id == self.id) ).scalar() or 0
        return round(score, 1)

    
class Genre(db.Model):
    __tablename__ = 'genres'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)

class Book_Genre(db.Model):
    __tablename__ = 'books_genres'

    id = db.Column(db.Integer, primary_key=True)
    book_id = db.Column(db.Integer, db.ForeignKey('books.id'), nullable=False)
    genre_id = db.Column(db.Integer, db.ForeignKey('genres.id'), nullable=False)
    
class Review(db.Model):
    __tablename__ = 'reviews'
    id = db.Column(db.Integer, primary_key=True)
    book_id = db.Column(db.Integer, db.ForeignKey('books.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    score = db.Column(db.Integer, nullable=False)
    text = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False, server_default=sa.sql.func.now())

    def __repr__(self):
        return '<Book %r>' % self.text
    
    @property
    def author(self):
        return db.session.execute(db.Select(User).filter_by(id = self.user_id)).scalar().full_name
    
    
class Cover(db.Model):
    __tablename__ = 'covers'

    id = db.Column(db.String(250), primary_key=True)
    file = db.Column(db.String(250), nullable=False)
    MIME = db.Column(db.String(250), nullable=False)
    MD5 = db.Column(db.String(150), nullable=False)
    

    def __repr__(self):
        return '<Cover %r>' % self.file

    @property
    def storage_filename(self):
        _, ext = os.path.splitext(self.file)
        return self.id + ext

    @property
    def url(self):
        return url_for('cover', cover_id=self.id)