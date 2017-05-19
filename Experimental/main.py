import urllib2
import json
from datetime import date
import calendar
import sys
from flask import Flask, jsonify, current_app, request,abort,redirect, url_for, make_response
from bs4 import BeautifulSoup
import logging
import schedule
import time
import psycopg2
import ConfigParser
from uuid import uuid4
from Database import myDB
from flask_bcrypt import Bcrypt

""" Initial setup of imports and stuff"""

app = Flask(__name__)
bcrypt = Bcrypt(app)
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

#Generate session token for users when they log in.  Need to check for uniqueness
def generate_session_id():
    return uuid4()

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

@app.route("/rating")
def renderRatings():
    return current_app.send_static_file('rating.html')

@app.route("/getFoodName/")
def getFoodName():
    foodid = request.args.get('food')
    app.logger.debug(foodid)
    return jsonify(DB.getFoodName(foodid)[0][0])

@app.route("/ratings/")
def comments():
    comment = request.args.get('food')
    if request.method == 'GET':
        #app.logger.debug(request.url)
        json = request.args.to_dict()
        app.logger.debug("Comment: " + str(json))
    return current_app.send_static_file('comments.html')

@app.route("/getComments/")
def getComments():
    foodid = request.args.get('food')
    return jsonify(DB.getComments(foodid))

@app.route("/addComment", methods=['POST'])
def addComment():
    comment = request.form['comment']
    foodid = request.form['foodid']
    username = request.form['userID']
    app.logger.debug("FOODID " + foodid)
    app.logger.debug("comment " + comment)
    app.logger.debug("username " + username)
    DB.addCommentOrRate(int(foodid), 2 ,str(comment), str(username))
    return redirect('/ratings/?food=' + foodid)
    #return ('', 204)
    #
    # addComment()

@app.route("/search/")
def search():
    query = request.args.get('query')
    meal = request.args.get('meal')
    app.logger.debug("query " + query)
    app.logger.debug("meal " + meal)
    return jsonify(DB.searchFood( str(query),int(meal)))

@app.route("/upvote/")
def upvoteFood():
    foodid = request.args.get('food')
    Username = request.args.get('username')
    app.logger.debug("FOODID " + foodid)
    app.logger.debug("username " + Username)
    DB.addCommentOrRate(int(foodid),1,"None",str(Username))
    return ('', 204)

@app.route("/downvote/")
def downvoteFood():
    foodid = request.args.get('food')
    Username = request.args.get('username')
    app.logger.debug("FOODID " + foodid)
    app.logger.debug("username " + Username)
    DB.addCommentOrRate(int(foodid),-1,"None",str(Username))
    return ('', 204)


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
    else:
        DB.registerUser(str(email), str(username), bcrypt.generate_password_hash(str(password1)))
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

@app.route("/checkLogin")
def checkLogin():
    sid = request.cookies.get('SessionID')
    if(sid == 0):
        return current_app.send_static_file('index.html')
    return ('',204)

@app.route("/getUser")
def getUsername():
    sid = request.cookies.get('SessionID')
    app.logger.debug("SID: " + str(sid))
    if(sid != 0):
        return jsonify(DB.getUser(sid))
    else:
        return current_app.send_static_file('index.html')

@app.route("/getServingLocation")
def getServingLocations():
    return jsonify(DB.getServingLocations())

@app.route("/login",  methods=['GET','POST'])
def Renderlogin():
    app.logger.debug("in the login method")
    email = request.form['email']
    password = request.form['password']
    adminEmail = Config.get('Development', 'adminEmail')
    adminPass = Config.get('Development', 'adminPass')
    if(email == adminEmail and password == adminPass):
        app.logger.debug("admin success")
        return redirect('/admin')
    try:
        dbPass = DB.getUserPassword(email)[0][0]
    except:
        app.logger.debug("username/pass dne")
        abort(401, "USERNAME DOES NOT EXIST")
    app.logger.debug(dbPass)
    if bcrypt.check_password_hash(dbPass, password) != 1:
        app.logger.debug("username/pass dne")
        abort(401, "USERNAME DOES NOT EXIST")
    app.logger.debug("not zero")
    sid = generate_session_id()
    DB.updateSessionTokenCustomer(True, str(sid), email) 
    resp = make_response(redirect('/rating'))
    resp.set_cookie('SessionID', str(sid),max_age=900)
    return resp

@app.route("/logout",  methods=['GET','POST'])
def logout():
    sid = request.cookies.get('SessionID')
    DB.updateSessionTokenCustomer(False, sid, "N/A") 
    resp = make_response()
    resp.set_cookie('SessionID', "0")
    return resp

@app.route("/logoutEmployee",  methods=['GET','POST'])
def logoutEmployee():
    sid = request.cookies.get('EmployeeSessionID')
    DB.updateSessionTokenEmployee(False, sid, "N/A") 
    resp = make_response()
    resp.set_cookie('EmployeeSessionID', "0")
    return resp

@app.route("/employeeLogin",  methods=['GET','POST'])
def employeeLogin():
    eid = request.form['employeeid']
    password = request.form['epassword']
    try:
        eid = DB.getEmployeeID(eid)
    except:
        app.logger.debug("username/pass dne")
        abort(401, "USERNAME DOES NOT EXIST")
    if bcrypt.check_password_hash(eid, password) != 1:
        app.logger.debug("employee id/pass dne")
        abort(401, "employee id/pass DOES NOT EXIST")
    app.logger.debug("not zero")
    sid = generate_session_id()
    DB.updateSessionTokenEmployee(True,str(sid),eid)
    resp = make_response(redirect('/employee'))
    resp.set_cookie('EmployeeSessionID',str(sid),max_age=900)
    return resp

@app.route("/employee")
def RenderEmployee():
    return current_app.send_static_file('employee.html')

@app.route("/getEmployeeHours")
def getEmployeeHours():
    sid = request.cookies.get('EmployeeSessionID')
    coWorker = DB.getCoworkers(str(sid))
    EmpHours = DB.getEmployeeHours(str(sid))
    app.logger.debug("COWORKIER: %s, EMP HOURS %s", str(coWorker), str(EmpHours))
    toReturn = {
        "Coworker":coWorker,
        "EmpHours":EmpHours
        }
    return jsonify(toReturn)

@app.route("/getMenuEmployee")
def getCoworkers():
    sid = request.cookies.get('EmployeeSessionID')
    breakfast = DB.getBreakfast()
    lunch = DB.getLunch()
    dinner = DB.getDinner()
    toReturn = {
        "Breakfast":breakfast,
        "Lunch":lunch,
        "Dinner":dinner
    }
    return jsonify(toReturn)

@app.route("/admin")
def RenderAdmin():
    return current_app.send_static_file('admin.html')

@app.route("/foodRating/")
def getFoods():
    foodid = request.args.get('foodid')
    app.logger.debug("FOODID " + foodid)
    return jsonify(DB.getRatingValue(foodid)[0][0])

@app.route("/getTopFood")
def getTopFood():
    return jsonify(DB.getTopFood())

@app.route("/getBotFood")
def getBotFood():
    return jsonify(DB.getBotFood())

@app.route("/getEmployees")
def getEmployees():
    return jsonify(DB.getEmployees())

@app.route("/getCustomers")
def getCustomers():
    return jsonify(DB.getCustomers())

@app.route("/admin/addEmployee", methods=['GET','POST'])
def addEmployee(): 
    app.logger.debug("calling addEmployee")
    eid=request.form['employeeid']
    fname=request.form['fname']
    lname=request.form['lname']
    work=request.form['worksat']
    password1=request.form['password']
    password2=request.form['password2']
    app.logger.debug("employeeid: " + eid + "\n" + "fname: " + fname + "\nlname: " + str(lname) + "\nPassword: " + str(password1) + "\nPassword2: " + str(password2))
    if password1 != password2:
        abort(400, '<Passwords do not match>')
    if DB.registerEmployee(str(eid), str(fname), str(lname), bcrypt.generate_password_hash(str(password1)), str(work)) != 1:
        app.logger.debug("employee id already there")
        abort(401, "EMPLOYEE ALREADY EXISTS")
    app.logger.debug("added successfully")
    return current_app.send_static_file('admin.html')

@app.route("/admin/deleteEmployee", methods=['GET','POST'])
def deleteEmployee():
    eid=request.form['eid']
    if DB.deleteEmployee(str(eid)) != 1:
        app.logger.debug("there is no person with that id")
        abort(401, "EMPLOYEE DOES NOT EXIST")
    app.logger.debug("deleted successfully")
    return current_app.send_static_file('admin.html')

@app.route("/admin/deleteCustomer", methods=['GET','POST'])
def deleteCustomer():
    username=request.form['username']
    if DB.deleteCustomer(str(username)) != 1:
        app.logger.debug("there is no person with that id")
        abort(401, "CUSTOMER DOES NOT EXIST")
    app.logger.debug("deleted successfully")
    return current_app.send_static_file('admin.html')

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
                    for i in range (len(data[data.keys()[x]]['cor_icon'])):
                        vegetarian = 'f'
                        vegan = 'f'
                        glutenFree = 't'
                        Kosher = 'f'
                        if (data[data.keys()[x]]['cor_icon'].keys()[i] == "1"):
                            vegetarian = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "4"):
                            vegan = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "9"):
                            glutenFree = 't'
                        else:
                             Kosher = 'f'
                    DB.insertFood(int(data.keys()[x]), vegetarian, vegan, glutenFree, Kosher,str(data[data.keys()[x]]['label']), 'good', 0,0)
                    msg = {
                        'vegetarian': vegetarian,
                        'vegan': vegan,
                        'glutenfree': glutenFree,
                        'Kosher': Kosher,
                        'FoodName': str(data[data.keys()[x]]['label']),
                        'Descrip': 'good',#change
                        'FoodID': DB.getFoodID(data[data.keys()[x]]['label'])[0][0]
                    }
                    toReturn.append(msg)
        return toReturn 
    elif(mealOfDay == MOENCH):
        print("\n MOENCH: \n")
        for x in range(len(data)):
            for y in range(len(moenchData['stations'][0]['items'])):
                if(moenchData['stations'][0]['items'][y] == data.keys()[x]):
                    vegetarian = 'f'
                    vegan = 'f'
                    glutenFree = 't'
                    Kosher = 'f'
                    for i in range (len(data[data.keys()[x]]['cor_icon'])):
                        if (data[data.keys()[x]]['cor_icon'].keys()[i] == "1"):
                            vegetarian = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "4"):
                            vegan = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "9"):
                            glutenFree = 't'
                        else:
                             Kosher = 'f'
                    DB.insertFood(int(data.keys()[x]), vegetarian, vegan, glutenFree, Kosher,str(data[data.keys()[x]]['label']), 'good', 0,1)
                    msg = {
                        'vegetarian': vegetarian,
                        'vegan': vegan,
                        'glutenFree': glutenFree,
                        'Kosher': Kosher,
                        'FoodName': str(data[data.keys()[x]]['label']),
                        'Descrip': 'good',#change
                        'FoodID': DB.getFoodID(data[data.keys()[x]]['label'])[0][0]
                    }
                    toReturn.append(msg)
        return toReturn 
    elif(mealOfDay == LUNCH):
        print("\n LUNCH: \n")
        for x in range(len(data)):
            for y in range(len(lunchData['stations'][0]['items'])):
                if(lunchData['stations'][0]['items'][y] == data.keys()[x]):
                    vegetarian = 'f'
                    vegan = 'f'
                    glutenFree = 't'
                    Kosher = 'f'
                    for i in range (len(data[data.keys()[x]]['cor_icon'])):
                        if (data[data.keys()[x]]['cor_icon'].keys()[i] == "1"):
                            vegetarian = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "4"):
                            vegan = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "9"):
                            glutenFree = 't'
                        else:
                             Kosher = 'f'
                    DB.insertFood(int(data.keys()[x]), vegetarian, vegan, glutenFree, Kosher,str(data[data.keys()[x]]['label']), 'good',0, 1)
                    msg = {
                        'vegetarian': vegetarian,
                        'vegan': vegan,
                        'glutenFree': glutenFree,
                        'Kosher': Kosher,
                        'FoodName': str(data[data.keys()[x]]['label']),
                        'Descrip': 'good',#change
                        'FoodID': DB.getFoodID(data[data.keys()[x]]['label'])[0][0]
                    }
                    toReturn.append(msg)
        return toReturn 
    elif(mealOfDay == DINNER):
        print("\n DINNER: \n")
        for x in range(len(data)):
            for y in range(len(dinnerData['stations'][0]['items'])):
                if(dinnerData['stations'][0]['items'][y] == data.keys()[x]):
                    vegetarian = 'f'
                    vegan = 'f'
                    glutenFree = 'f'
                    Kosher = 'f'
                    for i in range (len(data[data.keys()[x]]['cor_icon'])):
                        print("vegetarian")
                        if (data[data.keys()[x]]['cor_icon'].keys()[i] == "1"):
                            vegetarian = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "4"):
                            vegan = 't'
                        elif(data[data.keys()[x]]['cor_icon'].keys()[i] == "9"):
                            glutenFree = 't'
                        else:
                             Kosher = 'f'
                    DB.insertFood(int(data.keys()[x]), vegetarian, vegan, glutenFree, Kosher,str(data[data.keys()[x]]['label']), 'good',0, 2)
                    msg = {
                        'vegetarian': vegetarian,
                        'vegan': vegan,
                        'glutenFree': glutenFree,
                        'Kosher': Kosher,
                        'FoodName': str(data[data.keys()[x]]['label']),
                        'Descrip': 'good',#change
                        'FoodID': DB.getFoodID(data[data.keys()[x]]['label'])[0][0]
                    }
                    toReturn.append(msg)
        return toReturn 
if __name__ == "__main__":
    app.run(host='0.0.0.0',threaded=True)
    setup()
