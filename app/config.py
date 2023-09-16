import os

SECRET_KEY = 'secret-key'

SQLALCHEMY_DATABASE_URI = 'mysql+mysqlconnector://std_2060_exam:@std-mysql.ist.mospolytech.ru/std_2060_exam'
SQLALCHEMY_TRACK_MODIFICATIONS = False
SQLALCHEMY_ECHO = True

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'images')
