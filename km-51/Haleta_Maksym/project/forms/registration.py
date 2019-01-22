from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, validators

class RegistrationForm(FlaskForm):

    first_name = StringField("First name", [validators.Regexp('^[A-Z][a-z]{1,29}$',
                                                              message="Invalid first name")])

    last_name = StringField("Last name", [validators.Regexp('^[A-Z][a-z]{1,29}$',
                                                            message="Invalid last name")])

    email = StringField("Email", [validators.Regexp('^[a-zA-Z0-9_.+-]{1,20}@[a-zA-Z0-9-]{1,15}\.[a-zA-Z0-9-.]{1,5}$')])

    login = StringField("Login",[validators.Regexp('^[A-Z0-9a-z_]{1,30}$',
                                                   message="Invalid login")])

    password = PasswordField("Password", [validators.Regexp('^[A-Z0-9a-z_]{8,25}$',
                                                            message="Invalid password"),
                                          validators.EqualTo('confirm_password',
                                                             message="Passwords not equal")])

    confirm_password = PasswordField("Password", [validators.Regexp('^[A-Z0-9a-z_]{8,25}$',
                                                                    message="Invalid confirm password")])

    submit = SubmitField("Sign up")