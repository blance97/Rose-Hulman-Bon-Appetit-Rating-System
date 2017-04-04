import urllib2
import json
from datetime import date
import calendar
wiki = "http://rose-hulman.cafebonappetit.com/"
FOODLIST = 30
BREAKFAST = 31
MOENCH = 32
LUNCH = 33
DINNER = 34
#Query the website and return the html to the variable 'page'
page = urllib2.urlopen(wiki)

#import the Beautiful soup functions to parse the data returned from the website
from bs4 import BeautifulSoup

breakfastData = {}
moenchData= {}
lunchData= {}
dinnerData= {}
#Parse the html in the 'page' variable, and store it in Beautiful Soup format
soup =  BeautifulSoup(page, "html.parser")
s = soup.find_all("script")
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

# Double 
def getMatch(mealOfDay):
    global breakfastData
    global moenchData
    global lunchData
    global dinnerData
    if(mealOfDay == BREAKFAST):
        print("\n BREAKFAST: \n ")
        for x in range(len(data)):
            for y in range(len(breakfastData['stations'][0]['items'])):
                if(breakfastData['stations'][0]['items'][y] == data.keys()[x]):
                    print(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
    elif(mealOfDay == MOENCH):
        print("\n MOENCH: \n")
        for x in range(len(data)):
            for y in range(len(moenchData['stations'][0]['items'])):
                if(moenchData['stations'][0]['items'][y] == data.keys()[x]):
                    print(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
    elif(mealOfDay == LUNCH):
        print("\n LUNCH: \n")
        for x in range(len(data)):
            for y in range(len(lunchData['stations'][0]['items'])):
                if(lunchData['stations'][0]['items'][y] == data.keys()[x]):
                      print(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
    elif(mealOfDay == DINNER):
        print("\n DINNER: \n")
        for x in range(len(data)):
            for y in range(len(dinnerData['stations'][0]['items'])):
                if(dinnerData['stations'][0]['items'][y] == data.keys()[x]):
                    print(str(data.keys()[x] + " = " + str(data[data.keys()[x]]['label'])))
findStartAndEnd(BREAKFAST)
findStartAndEnd(MOENCH)
findStartAndEnd(LUNCH)
findStartAndEnd(DINNER)

getMatch(BREAKFAST)
getMatch(MOENCH)
getMatch(LUNCH)
getMatch(DINNER)