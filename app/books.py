from flask import Blueprint, render_template, request, flash, redirect, url_for
from app import db, app
from models import Book, Genre, Book_Genre, Cover, Review
from tools import CoverSaver
from flask_login import login_required, current_user
from auth import check_rights
import os, markdown, bleach

bp = Blueprint('books', __name__, url_prefix='/books')

BOOK_PARAMS = [
    'id', 'name', 'brief', 'year', 'publisher', 'author', 'page_number', 'cover_id'
]

def params():
    return { p: request.form.get(p) for p in BOOK_PARAMS }

@bp.route('/show_book/<int:book_id>')
def show_book(book_id):
    try:
        book = db.session.execute(db.select(Book).filter(Book.id == book_id)).scalar()
        book_markdown = book
        book_markdown.brief = markdown.markdown(book_markdown.brief)

        reviews = db.session.execute(db.select(Review).filter_by(book_id = book_id)).scalars()
        reviews_markdown = []
        for review in reviews:
            review.text = markdown.markdown(review.text)
            reviews_markdown.append(review)

        can_write = False
        if current_user.is_authenticated:
            can_write = Review.query.filter_by(book_id=book_id, user_id = current_user.id).count() == 0

        return render_template('books/show.html', book=book_markdown, reviews=reviews_markdown, can_write=can_write)
    except:
        flash('Что-то пошло не так', 'danger')
        return redirect(url_for('index'))

@bp.route('/edit/<int:book_id>', methods=['GET','POST'])
@login_required
@check_rights('edit_book')
def edit(book_id):
    try:
        book = db.session.execute(db.select(Book).filter(Book.id == book_id)).scalar()

        if request.method == 'GET':
            try:
                genres = db.session.execute(db.select(Genre)).scalars()
                return render_template('books/edit.html', book = book, genres=genres)
            except:
                flash('Что-то пошло не так', 'danger')
                return redirect(url_for('index'))
        if request.method == 'POST':
            try:
                params_from_form = params()
                for a in params_from_form:
                    a = bleach.clean(a)
                    
                new_book_data = Book(**params_from_form)

                db.session.query(Book).filter_by(id = book_id).update({
                    'name': new_book_data.name,
                    'brief': new_book_data.brief,
                    'year': new_book_data.year,
                    'publisher': new_book_data.publisher,
                    'author': new_book_data.author,
                    'page_number': new_book_data.page_number,
                })

                db.session.query(Book_Genre).filter_by(book_id = book_id).delete()
                
                db.session.commit()
                
                genres_form = request.form.getlist("genre")
                
                for genre in genres_form:
                    db.session.add(Book_Genre(book_id = book.id,genre_id = genre))
                db.session.commit()

                
                flash('Запись успешно изменена','success')
                return redirect(url_for('index'))
            except:
                db.session.rollback()
                flash('Что-то пошло не так', 'danger')
                return redirect(url_for('index'))
    except:
        flash('Что-то пошло не так', 'danger')
        return redirect(url_for('index'))
          
@bp.route('/delete/<int:book_id>', methods=['POST'])
@login_required
@check_rights('delete_book')
def delete(book_id):
    try:
        book = db.session.execute(db.select(Book).filter_by(id = book_id)).scalar()
        if Book.query.filter_by(cover_id=book.cover_id).count() < 2:
            cover = db.session.execute(db.select(Cover).filter_by(id = book.cover_id)).scalar()
            os.remove(
            os.path.join(app.config['UPLOAD_FOLDER'],
                            cover.storage_filename))
            db.session.query(Cover).filter_by(id = book.cover_id).delete()
                        
        db.session.query(Book).filter_by(id = book_id).delete()
        db.session.commit()
        flash('Книга удалена', 'success')
        return redirect(url_for('index'))
    except:
        db.session.rollback()
        flash('Что-то пошло не так', 'danger')
        return redirect(url_for('index'))

@bp.route('/create', methods=['GET','POST'])
@login_required
@check_rights('create_book')
def create():
        if request.method == 'POST':
            try:
                f = request.files.get('cover')
                if f and f.filename:
                    cover = CoverSaver(f).save()
                
                params_from_form = params()
                for a in params_from_form:
                    a = bleach.clean(a)

                    
                book = Book(**params_from_form)
                if f:
                    book.cover_id = cover.id


                db.session.add(book)
                db.session.commit()

                genres_form = request.form.getlist("genre")

                for genre in genres_form:
                    db.session.add(Book_Genre(book_id = book.id,genre_id = genre))
                db.session.commit()

                flash(f'Книга "{book.name}" добавлена', 'success')
                return redirect(url_for('index'))
            except:
                db.session.rollback()
                flash('ЧТо-то пошло не так', 'danger')
                return redirect(url_for('index'))

        if request.method == 'GET':
            try:
                genres = db.session.execute(db.select(Genre)).scalars()
                return render_template('books/add.html',genres=genres)
            except:
                db.session.rollback()
                flash('ЧТо-то пошло не так', 'danger')
                return redirect(url_for('index'))
        



