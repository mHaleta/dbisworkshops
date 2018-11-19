from flask import Flask, render_template, request

app = Flask(__name__)

product = {
    'product_id': '10001',
    'product_name': 'name_of_product',
    'price': '350',
    'quantity': '25'
}

user_add_product = {
    'login_fk': 'user_login',
    'product_id_fk': '10001',
    'date': '19.11.2018'
}

@app.route('/')
def index():
    return '<H1>Hello world!!!</h1>'

@app.route('/api/action/<actionName>')
def action(actionName):
    if actionName == 'product':
        return render_template('product.html', product=product)
    elif actionName == 'user_add_product':
        return render_template('user_add_product.html', user_add_product=user_add_product)
    elif actionName == 'all':
        return render_template('all.html', product=product, user_add_product=user_add_product)
    else:
        return render_template('404.html', action_value = actionName)

@app.route('/api/action/<entityName>/result', methods=['POST', 'GET'])
def result(entityName):
    if request.method == 'POST':
        result = request.form
        if entityName == 'product':
            product.update(result)
        elif entityName == 'user_add_product':
            user_add_product.update(result)
        return render_template("result.html", result=result)


if __name__ == '__main__':
    app.run(debug=True)
