from flask_login import current_user

class CheckRights:
    def __init__(self, record):
        self.record = record

    def delete_book(self):
        return current_user.is_administrator()

    def create_book(self):
        return current_user.is_administrator()

    def edit_book(self):
        return current_user.is_administrator() or current_user.is_moderator()
