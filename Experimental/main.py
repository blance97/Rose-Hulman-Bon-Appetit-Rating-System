import urllib2
import json
from datetime import date
import calendar
import sys
from flask import Flask, jsonify, current_app, request,abort
from bs4 import BeautifulSoup
import logging
import schedule
import time
import psycopg2
import ConfigParser
from Database import myDB

""" Initial setup of imports and stuff"""

app = Flask(__name__)
app.secret_key = "any random string"
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.DEBUG)
Config = ConfigParser.ConfigParser()
Config.read("dev.conf")
wiki = sys.argv[2] #"http://rose-hulman.cafebonappetit.com/"
print str(wiki) + " link "
page = urllib2.urlopen(wiki)
soup =  BeautifulSoup(page, "html.parser")
s = soup.find_all("script")
breakfastData = {}
moenchData= {}
lunchData= {}
dinnerData= {}
Users = ["127.0.0.1"]



#Database credentials
databaseName = Config.get('Development', 'databaseName')
databaseUser = Config.get('Development', 'user')
databasePasswd = Config.get('Development', 'password')
databaseHost = Config.get('Development', 'host')
port = Config.get('Development', 'port')

DB = myDB(databaseName,databaseUser,  databasePasswd, databaseHost, port)



""" contants """
FOODLIST = 30
BREAKFAST = 31
MOENCH = 32
LUNCH = 33
DINNER = 34



def setup():
    global page 
    global soup 
    app.logger.debug("UPDATE AT 7")
    soup =  BeautifulSoup(page, "html.parser")
    page = urllib2.urlopen(wiki)
    getMatch(BREAKFAST)
    getMatch(LUNCH)
    getMatch(DINNER)

my_date = date.today()
print(calendar.day_name[my_date.weekday()])
start = str(s[30]).find("Bamco.menu_items")
end = str(s[30]).find("Bamco.cor_icons")
foods = str(s[30])[start+19:end-6]
try:
    data = json.loads(foods)
    print("\n" + str(len(data)))
except:
    print("getting data failed.  Either the html structure changed or day/meal isn't correct")


#returns first and end character for certain food meals
def findStartAndEnd(mealOfDay):
    global breakfastData
    global moenchData
    global lunchData
    global dinnerData
    start = str(s[mealOfDay]).find("Bamco.dayparts[")
    end = str(s[mealOfDay]).find("</script>")
    if(mealOfDay == BREAKFAST):
        try:
            breakfastData = json.loads(str(s[BREAKFAST])[start+22:end-11])
        except:
            print("Data Cannot be loaded")
    elif(mealOfDay == MOENCH):
        try:
            moenchData = json.loads(str(s[MOENCH])[start+22:end-11])
        except:
            print("Data Cannot be loaded")
    elif(mealOfDay == LUNCH):
        try:
            lunchData = json.loads(str(s[LUNCH])[start+22:end-11])
        except:
            print("Data Cannot be loaded")
    elif(mealOfDay == DINNER):
        try:
            dinnerData = json.loads(str(s[DINNER])[start+22:end-11])
        except:
            print("Data cannot be loaded")

@app.route("/")
def index():
    ip = request.remote_addr
    app.logger.debug(len(Users))
    for x in range (len(Users)):
        if(Users[x] != ip):
            Users.append(ip)
            app.logger.debug("\n NEW USER: " +  str(ip) + "\n")
    app.logger.debug("Current Users: \n")
    curUsers = set(Users)
    app.logger.debug(curUsers)
    app.logger.debug("\n")
    return current_app.send_static_file('index.html')
@app.route("/ratings")
def renderRatings():
    return current_app.send_static_file('rating.html')
@app.route("/register")
def renderRegister():
    return current_app.send_static_file('register.html')

@app.route("/signup",  methods=['GET', 'POST'])
def register(): 
    username=request.form['username']
    email=request.form['email']
    password1=request.form['password']
    password2=request.form['cpassword']

    app.logger.debug("email: " + email + "\n" + "Username: " + username + "\nPassword1: " + str(password1) + " Password2: " + str(password2))
    if password1 != password2:
        abort(400, '<Passwords do not match>')
    if DB.registerUser(str(email), str(username), str(password1)) != 1:
        app.logger.debug("ITS ZERO!")
        abort(401, "USERNAME ALREADY EXISTS")
    app.logger.debug("NOT ZERO!")
    return current_app.send_static_file('index.html')
@app.route("/getBreakfast")
def breakfast():
    return jsonify(getMatch(BREAKFAST))
@app.route("/getLunch")
def lunch():
    return jsonify(getMatch(LUNCH))
@app.route("/getDinner")
def dinner():
    return jsonify(getMatch(DINNER))
@app.route("/getMoench")
def moench():
    return jsonify(getMatch(MOENCH))
@app.route("/getHours")
def getHours():
    return jsonify(DB.getHours())
@app.route("/login")
def login():
    return current_app.send_static_file('rating.html')


def getMatch(mealOfDay):
    global breakfastData
    global moenchData
    global lunchData
    global dinnerData
    findStartAndEnd(BREAKFAST)
    findStartAndEnd(MOENCH)
    findStartAndEnd(LUNCH)
    findStartAndEnd(DINNER)
    toReturn = []
    if(mealOfDay == BREAKFAST):
        print("\n BREAKFAST: \n ")
        for x in range(len(data)):
            for y in range(len(breakfastData['stations'][0]['items'])):
                if(breakfastData['stations'][0]['items'][y] == data.keys()[x]):
                    #app.logger.debug(int(data.keys()[x]))
                    DB.insertFood(int(data.keys()[x]), 't', 't', 'f', 'f',str(data[data.keys()[x]]['label']), 'good', 2.3)
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
    elif(mealOfDay == MOENCH):
        print("\n MOENCH: \n")
        for x in range(len(data)):
            for y in range(len(moenchData['stations'][0]['items'])):
                if(moenchData['stations'][0]['items'][y] == data.keys()[x]):
                    DB.insertFood(int(data.keys()[x]), 't', 't', 'f', 'f',str(data[data.keys()[x]]['label']), 'good', 2.3)
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
    elif(mealOfDay == LUNCH):
        print("\n LUNCH: \n")
        for x in range(len(data)):
            for y in range(len(lunchData['stations'][0]['items'])):
                if(lunchData['stations'][0]['items'][y] == data.keys()[x]):
                    DB.insertFood(int(data.keys()[x]), 't', 't', 'f', 'f',str(data[data.keys()[x]]['label']), 'good', 2.3)
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
    elif(mealOfDay == DINNER):
        print("\n DINNER: \n")
        for x in range(len(data)):
            for y in range(len(dinnerData['stations'][0]['items'])):
                if(dinnerData['stations'][0]['items'][y] == data.keys()[x]):
                    DB.insertFood(int(data.keys()[x]), 't', 't', 'f', 'f',str(data[data.keys()[x]]['label']), 'good', 2.3)  
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
if __name__ == "__main__":
    setup()
    app.run(host='0.0.0.0')
