import urllib2
import json
from datetime import date
import calendar
import sys
from flask import Flask, jsonify, current_app, request
from bs4 import BeautifulSoup
import logging

app = Flask(__name__)
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.DEBUG)


wiki = "http://rose-hulman.cafebonappetit.com/"
FOODLIST = 30
BREAKFAST = 31
MOENCH = 32
LUNCH = 33
DINNER = 34
page = urllib2.urlopen(wiki)
soup =  BeautifulSoup(page, "html.parser")
s = soup.find_all("script")

breakfastData = {}
moenchData= {}
lunchData= {}
dinnerData= {}
Users = ["127.0.0.1"]

my_date = date.today()
print(calendar.day_name[my_date.weekday()])
start = str(s[30]).find("Bamco.menu_items")
end = str(s[30]).find("Bamco.cor_icons")
foods = str(s[30])[start+19:end-6]
data = json.loads(foods)
print("\n" + str(len(data)))

#returns first and end character for certain food meals
# TODO: I DONT ACTUALLY NEED THIS FUNCTION
def findStartAndEnd(mealOfDay):
    global breakfastData
    global moenchData
    global lunchData
    global dinnerData
    start = str(s[mealOfDay]).find("Bamco.dayparts[")
    end = str(s[mealOfDay]).find("</script>")
    if(mealOfDay == BREAKFAST):
        breakfastData = json.loads(str(s[BREAKFAST])[start+22:end-11])
    elif(mealOfDay == MOENCH):
        moenchData = json.loads(str(s[MOENCH])[start+22:end-11])
    elif(mealOfDay == LUNCH):
        lunchData = json.loads(str(s[LUNCH])[start+22:end-11])
    elif(mealOfDay == DINNER):
        dinnerData = json.loads(str(s[DINNER])[start+22:end-11])

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
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
                    # print(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
    elif(mealOfDay == MOENCH):
        print("\n MOENCH: \n")
        for x in range(len(data)):
            for y in range(len(moenchData['stations'][0]['items'])):
                if(moenchData['stations'][0]['items'][y] == data.keys()[x]):
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
    elif(mealOfDay == LUNCH):
        print("\n LUNCH: \n")
        for x in range(len(data)):
            for y in range(len(lunchData['stations'][0]['items'])):
                if(lunchData['stations'][0]['items'][y] == data.keys()[x]):
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
    elif(mealOfDay == DINNER):
        print("\n DINNER: \n")
        for x in range(len(data)):
            for y in range(len(dinnerData['stations'][0]['items'])):
                if(dinnerData['stations'][0]['items'][y] == data.keys()[x]):
                    toReturn.append(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
        return toReturn 
if __name__ == "__main__":
    app.run(host='137.112.136.75', port= 3333)



# getMatch(BREAKFAST)
# getMatch(MOENCH)
# getMatch(LUNCH)
# getMatch(DINNER)