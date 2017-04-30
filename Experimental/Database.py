import psycopg2
import sys


class myDB(object):

    def __init__(self, databaseName, user, password, host, port):
        global conn
        global cur
        conn = psycopg2.connect(database=databaseName, user=user, password=password, host=host, port=port)
        cur = conn.cursor()

    def insertFood(self, FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating):
        query = "INSERT INTO food ( FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating) Values (%s,%s,%s,%s,%s,%s,%s,%s) ON CONFLICT(FoodID) DO NOTHING"
        data = (FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating)
        cur.execute(query, data)
        conn.commit()

    def registerUser(self, email, Fname, LName, Username, Password):
        #Check uniqueness
        query = "SELECT username FROM Customer WHERE username = %s"
        data = (Username,)
        cur.execute(query, data)
        rowcount = cur.rowcount
        if rowcount > 1: # if username already exists
            return 0
        else:
            query1 = "INSERT INTO Customer ( email, fname, lname, password, Username) Values (%s,%s,%s,%s,%s)"
            data = (email,Fname, Fname, LName, Username)
            conn.commit()
        return 1
    def getFoods(self, Meal):
        query = "SELECT * FROM FOOD"
        cur.execute(query)
        return cur.fetchall()
    def getHours(self):
        query = "SELECT * FROM CAFE"
        cur.execute(query)
        # retrieve the records from the database
        records = cur.fetchall()
        return records
        