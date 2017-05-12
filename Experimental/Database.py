import psycopg2
import sys


class myDB(object):

    def __init__(self, databaseName, user, password, host, port):
        global conn
        global cur
        conn = psycopg2.connect(database=databaseName, user=user, password=password, host=host, port=port)
        cur = conn.cursor()

    def insertFood(self, FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating):
        query = "INSERT INTO Food ( FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, Description, Rating) Values (%s,%s,%s,%s,%s,%s,%s,%s) ON CONFLICT(FoodID) DO NOTHING"
        data = (FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating)
        cur.execute(query, data)
        conn.commit()

    def getComments(self, FoodID):
        query = "SELECT comment FROM RATING WHERE foodid = %s"
        data = (FoodID,)
        cur.execute(query, data)
        return cur.fetchall()
    
    def addComment(self, FoodID, Comment): # make stored procedure
        query = "SELECT comment FROM rating WHERE foodid= %s"
        data = (FoodID,)
        cur.execute(query, data)
        conn.commit()
        origComment = cur.fetchall()
        addedComment = origComment + comment
        query1 = "UPDATE comment WHERE foodid = %s SET comment = %s"
        data1 = (FoodID,Comment)
        cur.execute(query1, data1)
        conn.commit()
    def registerUser(self, email, Username, Password):
        #Check uniqueness
        query = "SELECT username FROM Customer WHERE username = %s"
        data = (Username,)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        print str(rowcount)
        if rowcount >= 1: # if username already exists
            return 0
        else:
            print "INSERTING: Email: " + email + " password: " + Password + " Username: " + Username
            query1 = "INSERT INTO Customer ( email,favorite, password, Username) Values (%s,%s,%s,%s)"
            data1 = (email,5547887, Password, Username)
            cur.execute(query1, data1)
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
    def checkUser(self, email, password):
        query = "SELECT username FROM Customer WHERE email = %s AND password = %s"
        data = (email, password)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        if rowcount == 1: #email and password are valid
            return 1
        else:
            return 0
    def getEmployees(self):
        query = "SELECT employee.fname, employee.lname, employee.employeeid,worksat.cafename FROM (employee JOIN worksat ON ((employee.employeeid = worksat.employeeid)));"
        cur.execute(query)
        return cur.fetchall()
    def getCustomers(self):
        query = "SELECT customer.username, customer.email, customer.favorite FROM customer;"
        cur.execute(query)
        return cur.fetchall()
    
    #def getFoodInfo() :
        #call the top and bottom ranked foods here
