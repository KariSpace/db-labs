from flask import Flask, render_template, request
import json
from pymongo import MongoClient

from main import Psql

app = Flask(__name__)

psql  = Psql('postgres',
                dbname='lab',
                user='postgres1',
                host='localhost')

client = MongoClient("Connect link here")


@app.route("/", methods=['post', 'get'])
def mongo_display():
    data = {}
    for collection in ("books", "customers", "library", "librarybooks"):
        d = client["db"][collection].find({})
        data[collection] = list(d)

    return render_template("main.html", data=data)


@app.route("/p", methods=['post', 'get'])
def postgre_display():
    if request.method == 'POST':
        command = request.form.get('command')
        message = psql.execute_fetch(command)
        return render_template("response.html", command=command, message=message)

    table_list = psql.execute_fetch(
        "SELECT table_name FROM information_schema.tables WHERE (table_schema = 'public') ORDER BY table_name;")
    data = {}
    for table in table_list:
        table_data = psql.get_table_contents(table[0])
        data.update({table[0]: table_data})

    return render_template("main.html", data=data)


@app.route("/c", methods=['post', 'get'])
def convert():
    data = {}
    for collection in ("books", "customers", "library", "librarybooks"):
        d = client["db"][collection].find({})
        data[collection] = [rm_id(i) for i in list(d)]

    tables = ("librarybooks", "books", "customers", "library",)
    for collection in tables:
        table = data[collection]
        for row in table:
            k = [str(i) for i in row.keys()]
            v = [stringy(i) for i in row.values()]
            fields = "(" + ",".join(k) + ")"
            values = "(" + ",".join(v) + ")"
            sql_quer = f"INSERT INTO {str(collection)} {fields} VALUES {values};"
            psql.cursor.execute(sql_quer)

    return render_template("main.html", data=data)


def stringy(i):
    if isinstance(i, int):
        return str(i)
    else:
        return "'" + str(i) + "'"


def rm_id(dictoin):
    res = {}
    for key in dictoin:
        if key != "_id":
            res[key] = dictoin[key]
        else:
            continue
    return res


def init():
    psql.execute_file("./sql_files/CREATE_TABLE.sql")
    print("Success")



init()

app.run()
