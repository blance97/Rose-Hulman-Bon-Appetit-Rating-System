import psycopg2
import sys


class myDB(object):

    def __init__(self, databaseName, user, password, host, port):
        global conn
        global cur
        #print("DB NAME : " + str(databaseName) + " DBPASSWORD: " + str(password) + " databaseHOST: " + host + " PORT: " + str(port))
        conn = psycopg2.connect(database=databaseName, user=user, password=password, host=host, port=port)
        cur = conn.cursor()

    def insertFood(self, FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating):
        query = "INSERT INTO food ( FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"
        data = (FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating)
        cur.execute(query, data)
        conn.commit()