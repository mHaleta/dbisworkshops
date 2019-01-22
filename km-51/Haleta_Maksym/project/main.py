from datetime import datetime, timedelta

from flask import Flask, request, render_template, session, redirect, url_for, make_response, flash

from dao.user_helper import *
from dao.advertisement_helper import *
from forms.login import LoginForm
from forms.registration import RegistrationForm
from forms.search import SearchProductForm, SearchVendorForm
from forms.edit import *

app = Flask(__name__)
app.secret_key = 'development key'


@app.route('/')
def index():
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm(request.form)

    if request.method == 'GET':
        if 'user_name' not in session:
            return render_template('login.html', form=form)

        login = request.cookies.get('username')
        if login is None:
            return render_template('login.html', form=form)
        return redirect(url_for('main'))

    if request.method == 'POST':
        if form.validate():
            res = login_user(request.form['login'], request.form['password'])
            if res == '0':
                response = make_response(redirect('/main'))
                expires = datetime.now()
                expires += timedelta(days=60)
                response.set_cookie('username', request.form['login'], expires=expires)
                session['user_name'] = request.form['login']
                return response
            else:
                flash({'unreg': ["Даний користувач не зареєстрований"]})
                render_template('login.html', form=form)
        else:
            flash(form.errors)
    return render_template('login.html', form=form)


@app.route('/registration', methods=['GET', 'POST'])
def registration():
    form = RegistrationForm(request.form)

    if request.method == 'POST':
        if not form.validate():
            flash(form.errors)
        else:

            name = request.form['first_name']
            surname = request.form['last_name']
            email = request.form['email']
            login = request.form['login']
            password = request.form['password']

            if is_user_exist(login) == 'false':
                user_registration(name, surname, email, login, password)
                return redirect(url_for('login'))
            else:
                flash({'login_exists': ["Такий логін вже існує"]})

        return render_template('registration.html', form=form)

    return render_template('registration.html', form=form)


@app.route('/main', methods=['GET', 'POST'])
def main():
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']

    rows = show_advertisements()
    for i in range(len(rows)):
        rows[i] = list(rows[i])
        rows[i].pop(-1)
    length = len(rows)
    zipped = zip(rows, range(length))

    if request.method == 'POST':
        chosen = None
        for i in range(length):
            if str(i) in request.form:
                chosen = i
                break
        if is_in_price_tracking_list(str(rows[chosen][0]), login) == 'false':
            add_to_price_tracking_list(str(rows[chosen][0]), login)

    return render_template('index.html', zipped=zipped, length=length, login=login)


@app.route('/price_tracking', methods=['GET', 'POST'])
def price_tracking():
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']

    rows = show_price_tracking_list(login)
    length = len(rows)
    zipped = zip(rows, range(length))
    make_not_changed(login)

    if request.method == 'POST':
        chosen = None
        for i in range(length):
            if str(i) in request.form:
                chosen = i
                break

        ad_id = get_ad_id(rows[chosen][1], rows[chosen][2])
        delete_from_price_tracking(ad_id, login)
        rows.pop(chosen)
        length = len(rows)
        zipped = zip(rows, range(length))
        return render_template('price_tracking.html', zipped=zipped, length=length)

    return render_template('price_tracking.html', zipped=zipped, length=length)


@app.route('/search', methods=['GET', 'POST'])
def search():
    if 'user_name' not in session:
        return redirect(url_for('login'))

    form_1 = SearchProductForm(request.form)
    form_2 = SearchVendorForm(request.form)

    if request.method == 'POST':
        if 'search_prod' in request.form:
            if not form_1.validate():
                pass
            else:
                prod_name = request.form['search_prod']
                return redirect('/search/prod=' + prod_name)
        else:
            if not form_2.validate():
                pass
            else:
                vendor_name = request.form['search_vendor']
                return redirect('/search/vend=' + vendor_name)

    return render_template('search.html', form_1=form_1, form_2=form_2)


@app.route('/search/prod=<string:prod_name>', methods=['GET', 'POST'])
def find_product(prod_name):
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']
    rows = find_adverts_by_product(prod_name)
    for i in range(len(rows)):
        rows[i] = list(rows[i])
        rows[i].pop(-1)
    length = len(rows)
    zipped = zip(rows, range(length))

    if request.method == 'POST':
        chosen = None
        for i in range(length):
            if str(i) in request.form:
                chosen = i
                break

        if is_in_price_tracking_list(str(rows[chosen][0]), login) == 'false':
            add_to_price_tracking_list(str(rows[chosen][0]), login)

    return render_template('find_product.html', zipped=zipped, rows=rows, name=prod_name, login=login)


@app.route('/search/vend=<string:vend_name>', methods=['GET', 'POST'])
def find_vendor(vend_name):
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']
    rows = find_adverts_by_vendor(vend_name)
    for i in range(len(rows)):
        rows[i] = list(rows[i])
        rows[i].pop(-1)
    length = len(rows)
    zipped = zip(rows, range(length))

    if request.method == 'POST':
        chosen = None
        for i in range(length):
            if str(i) in request.form:
                chosen = i
                break

        if is_in_price_tracking_list(str(rows[chosen][0]), login) == 'false':
            add_to_price_tracking_list(str(rows[chosen][0]), login)

    return render_template('find_vendor.html', zipped=zipped, rows=rows, name=vend_name, login=login)


@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'user_name' not in session:
        return redirect(url_for('login'))
    form1 = ShowAllUsersBtn(request.form)
    form2 = DeleteUserBtn(request.form)
    form3 = EditProfileBtn(request.form)
    form4 = AddProductBtn(request.form)
    form5 = UpdateAdvertisementBtn(request.form)
    form6 = EditAdvertisementBtn(request.form)
    login = session['user_name']
    row = user_profile(login)

    if request.method == 'POST':
        if 'submit_show' in request.form:
            return redirect(url_for('show_users'))
        if 'submit_del_user' in request.form:
            return redirect(url_for('delete_user'))
        if 'submit_profile' in request.form:
            return redirect(url_for('edit_profile'))
        elif 'submit_add' in request.form:
            return redirect(url_for('add_product'))
        elif 'submit_update' in request.form:
            return redirect(url_for('show_ads_for_update'))
        else:
            return redirect(url_for('delete_advert'))

    if login == 'admin_login':
        return render_template('profile.html', user_admin=True, row=row, form1=form1,
                               form2=form2, form3=form3, form4=form4, form5=form5, form6=form6)
    else:
        return render_template('profile.html', user_admin=False, row=row, form1=form1,
                               form2=form2, form3=form3, form4=form4, form5=form5, form6=form6)


@app.route('/profile/update_ad', methods=['GET', 'POST'])
def show_ads_for_update():
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']
    if login == 'admin_login':
        rows = show_advertisements()
        for i in range(len(rows)):
            rows[i] = list(rows[i])
            prod_desc = rows[i].pop(-1)
    else:
        rows = show_ads_by_login(login)
        for i in range(len(rows)):
            rows[i] = list(rows[i])
            prod_desc = rows[i].pop(-1)

    length = len(rows)
    zipped = zip(rows, range(length))

    if request.method == 'POST':
        chosen = None
        for i in range(length):
            if str(i) in request.form:
                chosen = i
                break

        return redirect('/profile/update_ad/id='+str(rows[chosen][0]))

    return render_template('show_ads_for_update.html', length=length, zipped=zipped)


@app.route('/profile/update_ad/id=<int:ad_id>', methods=['GET', 'POST'])
def update_ad(ad_id):
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']
    row = find_ad_by_id(ad_id)
    form = UpdateAdvertisement(request.form)

    if request.method == 'POST':
        if not form.validate():
            flash(form.errors)
        else:
            name = request.form['name']
            price = request.form['price']
            quantity = request.form['quantity']
            desc = request.form['description']
            if is_ad_exists(login, name, ad_id) == 'false':
                update_advertisement(name, price, quantity, desc, ad_id)
                return redirect(url_for('show_ads_for_update'))
            else:
                flash({'failed': ['Such advertisement already exists']})

    return render_template('update_ad.html', row=row, form=form, id=ad_id)


@app.route('/profile/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if 'user_name' not in session:
        return redirect(url_for('login'))
    login = session['user_name']
    row = user_profile(login)

    form = EditUser(request.form)

    if request.method == 'POST':
        if not form.validate():
            flash(form.errors)
        else:
            name = request.form['name']
            surname = request.form['surname']
            email = request.form['email']
            update_user(name, surname, email, login)
            return redirect(url_for('profile'))

    return render_template('edit_profile.html', form=form, row=row)


@app.route('/profile/add_product', methods=['GET', 'POST'])
def add_product():
    if 'user_name' not in session:
        return redirect(url_for('login'))

    login = session['user_name']

    form = AddProduct(request.form)

    if request.method == 'POST':
        if not form.validate():
            flash(form.errors)
        else:
            name = request.form['name']
            price = request.form['price']
            quantity = request.form['quantity']
            description = request.form['description']
            flag = is_advert_exists(login, name)
            if flag == 'true':
                flash({'advert_exists': ['Such advertisement already exists']})
            else:
                add_advertisement(login, name, price, quantity, description)
                return redirect(url_for('main'))

    return render_template('add_product.html', form=form)


@app.route('/profile/delete_advert', methods=['GET', 'POST'])
def delete_advert():
    if 'user_name' not in session:
        return redirect(url_for('login'))

    form = DeleteAdvertisement(request.form)
    login = session['user_name']

    if request.method == 'POST':
        if not form.validate():
            flash(form.errors)
        else:
            ad_id = request.form['ad_id']
            if login == 'admin_login':
                delete_advert_by_id(ad_id)
                return redirect(url_for('profile'))
            else:
                flag = get_advert_by_id(ad_id, login)
                if flag == 'false':
                    flash({'not_found': ['You have not got such advertisement']})
                else:
                    delete_advert_by_id(ad_id)
                    return redirect(url_for('profile'))

    return render_template('delete_advert.html', form=form)


@app.route('/profile/delete_user', methods=['GET', 'POST'])
def delete_user():
    if 'user_name' not in session:
        return redirect(url_for('login'))
    if session['user_name'] != 'admin_login':
        return redirect(url_for('main'))

    form = DeleteUser(request.form)

    if request.method == 'POST':
        if not form.validate():
            flash(form.errors)
        else:
            login = request.form['login']
            if login != 'admin_login':
                if is_user_exist(login) == 'true':
                    delete_from_user(login)
                    return render_template('delete_user.html', form=form)
                else:
                    flash({'not_found': ['Немає такого користувача']})
            else:
                flash({'admin_del': ['Не можна видаляти адміна))']})

    return render_template('delete_user.html', form=form)


@app.route('/show_users')
def show_users():
    if 'user_name' not in session:
        return redirect(url_for('login'))
    if session['user_name'] != 'admin_login':
        return redirect(url_for('main'))

    rows = show_all_users()

    return render_template('show_users.html', rows=rows)


@app.route('/logout')
def delete_cookie():
    response = make_response(redirect('/login'))
    response.set_cookie('username', '', expires=0)
    session.pop('user_name', None)
    return response


if __name__ == '__main__':
    app.run(debug=True)
