from flask import Flask, render_template,request,redirect,url_for # For flask implementation
from bson import ObjectId # For ObjectId to work
from pymongo import MongoClient
import os

app = Flask(__name__)
title = "Library CRM"
heading = "Library CRM"

client = MongoClient("CONNECT LINK") #host uri
db = client.labs    #Select the database
books = db.books #Select the collection name

def redirect_url():
    return request.args.get('next') or \
           request.referrer or \
           url_for('index')

@app.route("/list")
def lists ():
	#Display the all boooks
	books_l = books.find()
	a1="active"
	return render_template('index.html',a1=a1,books=books_l,t=title,h=heading)

@app.route("/")
@app.route("/uncompleted")
def boooks ():
	#Display the Uncompleted boooks
	books_l = books.find({"done":"no"})
	a2="active"
	return render_template('index.html',a2=a2,books=books_l,t=title,h=heading)


@app.route("/completed")
def completed ():
	#Display the Completed boooks
	books_l = books.find({"done":"yes"})
	a3="active"
	return render_template('index.html',a3=a3,books=books_l,t=title,h=heading)

@app.route("/done")
def done ():
	#Done-or-not ICON
	id=request.values.get("_id")
	boook=books.find({"_id":ObjectId(id)})
	if(boook[0]["done"]=="yes"):
		books.update({"_id":ObjectId(id)}, {"$set": {"done":"no"}})
	else:
		books.update({"_id":ObjectId(id)}, {"$set": {"done":"yes"}})
	redir=redirect_url()	

	return redirect(redir)

@app.route("/action", methods=['POST'])
def action ():
	#Adding a boook
	name=request.values.get("name")
	desc=request.values.get("desc")
	date=request.values.get("date")
	pr=request.values.get("pr")
	books.insert({ "name":name, "desc":desc, "date":date, "pr":pr, "done":"no"})
	return redirect("/list")

@app.route("/remove")
def remove ():
	#Deleting a boook with various references
	key=request.values.get("_id")
	books.remove({"_id":ObjectId(key)})
	return redirect("/")

@app.route("/update")
def update ():
	id=request.values.get("_id")
	boook=books.find({"_id":ObjectId(id)})
	return render_template('update.html',boooks=boook,h=heading,t=title)

@app.route("/action3", methods=['POST'])
def action3 ():
	#Updating a boook with various references
	name=request.values.get("name")
	desc=request.values.get("desc")
	date=request.values.get("date")
	pr=request.values.get("pr")
	id=request.values.get("_id")
	books.update({"_id":ObjectId(id)}, {'$set':{ "name":name, "desc":desc, "date":date, "pr":pr }})
	return redirect("/")

@app.route("/search", methods=['GET'])
def search():
	#Searching a boook with various references

	key=request.values.get("key")
	refer=request.values.get("refer")
	if(key=="_id"):
		books_l = books.find({refer:ObjectId(key)})
	else:
		books_l = books.find({refer:key})
	return render_template('searchlist.html',books=books_l,t=title,h=heading)

if __name__ == "__main__":

    app.run()
