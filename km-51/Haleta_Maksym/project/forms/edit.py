from flask_wtf import FlaskForm
from wtforms import SubmitField, TextAreaField, StringField, validators

class EditProfileBtn(FlaskForm):
    submit_profile = SubmitField("Edit Profile")

class AddProductBtn(FlaskForm):
    submit_add = SubmitField("Add Product")

class EditAdvertisementBtn(FlaskForm):
    submit_advert = SubmitField("Delete Ad")

class UpdateAdvertisementBtn(FlaskForm):
    submit_update = SubmitField("Update Ad")

class DeleteUserBtn(FlaskForm):
    submit_del_user = SubmitField("Delete User")

class DeleteUser(FlaskForm):
    login = StringField("User login", [validators.Regexp('^[A-Z0-9a-z_]{1,30}$', message="Invalid user login")])
    submit = SubmitField("Delete User")

class ShowAllUsersBtn(FlaskForm):
    submit_show = SubmitField("Show Users")

class EditUser(FlaskForm):
    name = StringField("First name", [validators.Regexp('^[A-z][a-z]{1,29}$', message="Invalid first name")])
    surname = StringField("Last name", [validators.Regexp('^[A-z][a-z]{1,29}$', message="Invalid last name")])
    email = StringField("Email", [validators.Regexp('^[a-zA-Z0-9_.+-]{1,20}@[a-zA-Z0-9-]{1,15}\.[a-zA-Z0-9-.]{1,5}$',
                                                    message="Invalid email")])

    submit = SubmitField("Edit Profile")

class AddProduct(FlaskForm):
    name = StringField("Product name", [validators.Length(min=1, max=199, message="Invalid input of product name")])
    price = StringField("Product price", [validators.Regexp('^\d{1,10}$', message="Invalid input of price")])
    quantity = StringField("Product quantity", [validators.Regexp('^\d{1,10}$', message="Invalid input of quantity")])
    description = TextAreaField("Product description", [validators.Length(max=2000, message="Too long description")])

    submit = SubmitField("Add Product")

class UpdateAdvertisement(FlaskForm):
    name = StringField("Product name",
                       [validators.Length(min=1, max=199, message="Invalid input of product name")])
    price = StringField("Product price",
                        [validators.Regexp('^\d{1,10}$', message="Invalid input of price")])
    quantity = StringField("Product quantity",
                           [validators.Regexp('^\d{1,10}$', message="Invalid input of quantity")])

    submit = SubmitField("Update Product")

class DeleteAdvertisement(FlaskForm):
    ad_id = StringField("Advertisement id", [validators.Regexp('^\d{1,10}', message="Wrong id")])
    submit = SubmitField("Delete")
