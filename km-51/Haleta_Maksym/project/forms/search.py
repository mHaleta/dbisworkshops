from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, validators

class SearchProductForm(FlaskForm):

   search_prod = StringField("Enter product to search",
                             [validators.Length(min=1, max=199, message="Invalid input")])

   submit = SubmitField("Search")


class SearchVendorForm(FlaskForm):
    search_vendor = StringField("Enter vendor to search his products",
                                  [validators.Regexp('^[A-Z0-9a-z_]{1,30}$', message="Wrong input")])

    submit = SubmitField("Search")