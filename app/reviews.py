from flask import Blueprint, render_template, request, flash, redirect, url_for
from app import db
from models import Book, Review
from flask_login import login_required, current_user

import bleach

bp = Blueprint('reviews', __name__, url_prefix='/reviews')

REVIEW_PARAMS = [
    'score', 'text'
]

def params():
    return { p: request.form.get(p) for p in REVIEW_PARAMS }

@bp.route('/create/<int:book_id>', methods=['GET', 'POST'])
@login_required
def create(book_id):
    if request.method == 'GET':
        try:
            if Review.query.filter_by(book_id=book_id, user_id = current_user.id).count() == 0:
                book = Book.query.filter_by(id=book_id).scalar()
                return render_template('reviews/add.html', book=book)
            else:
                flash('Вы уже писали рецензию', 'warning')
                return redirect(url_for('index'))
        except:
            flash('Что-то пошло не так', 'danger')
            return redirect(url_for('index'))
    if request.method == 'POST':
        try:
            params_from_form = params()
            for a in params_from_form:
                a = bleach.clean(a)
            print(params_from_form)
            review = Review(
                book_id = book_id,
                user_id = current_user.id,
                score = params_from_form['score'],
                text = params_from_form['text']
            )
            db.session.add(review)
            db.session.commit()
            flash('Рецензия добавлена', 'success')
            return redirect(url_for('books.show_book', book_id=book_id))
        except:
            flash('Что-то пошло не так', 'danger')
            return redirect(url_for('index'))
        


