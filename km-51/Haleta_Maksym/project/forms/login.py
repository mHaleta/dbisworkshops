from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, validators

class LoginForm(FlaskForm):

   login = StringField("Login", [validators.Regexp('^[A-Z0-9a-z_]{1,30}$', message="Invalid login")])

   password = PasswordField("Password", [validators.Regexp('^[A-Z0-9a-z_]{8,25}$',  message="Invalid password")])

   submit = SubmitField("LOGIN")