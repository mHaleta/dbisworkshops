import cx_Oracle
from dao.credentials import *


def login_user(login, u_password):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("LOGIN.LOGIN", cx_Oracle.STRING, [login, u_password])

    cursor.close()
    connection.close()
    return result

def is_user_exist(login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("INSERT_INTO_TABLES.IS_USER_EXISTS", cx_Oracle.STRING, [login])

    cursor.close()
    connection.close()
    return result

def user_registration(name, surname, email, login, u_password):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    args = [login, u_password, name, surname, email]

    cursor.callproc("INSERT_INTO_TABLES.ADD_USER", args)

    cursor.close()
    connection.close()

def user_profile(login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(show.show_user(\'{}\'))'.format(login)
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result

def update_user(name, surname, email, login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    cursor.callproc('UPDATE_TABLES.update_user', [name, surname, email, login])
    cursor.close()
    connection.close()

def delete_from_user(login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    cursor.callproc('DELETE_FROM_TABLES.delete_from_user', [login])
    cursor.close()
    connection.close()

def show_all_users():
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(show.show_all_users())'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def make_not_changed(login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'update Price_tracking_list set status = \'not changed\' where user_login = \'{}\''.format(login)
    cursor.execute(query)
    query = 'commit'
    cursor.execute(query)
    cursor.close()
    connection.close()
