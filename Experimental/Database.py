import psycopg2
import sys
from datetime import datetime
from flask import current_app
import json
class myDB(object):

    def __init__(self, databaseName, user, password, host, port):
        global conn
        global cur
        conn = psycopg2.connect(database=databaseName, user=user, password=password, host=host, port=port)
        cur = conn.cursor()
        self.insertFoodsFunctions()
        self.registerUserFunction()
        self.AddCommentFunction()

    def insertFood(self, FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating, meal):
        query = "SELECT insertFoods(%s, %s, %s,%s,%s,%s, %s, %s, %s)"
        data = (FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating, meal)
        cur.execute(query, data)
        conn.commit()

    def getComments(self, FoodID): #TODO: GET USERNAME INSTEAD
        query = "SELECT comment,time,customeremail FROM (RATING JOIN GIVES ON gives.ratingtime = rating.time) WHERE RATING.foodid = %s ORDER BY time DESC"
        data = (FoodID,)
        cur.execute(query, data)
        return cur.fetchall()
    
    def addComment(self, foodID, ratings, Comment, uname):
        query = "SELECT rateFood(%s,%s,%s,%s)"
        data = (foodID, ratings, Comment, uname)
        cur.execute(query, data)

    def getFoodID(self, foodName):
        query = "SELECT foodid FROM food WHERE foodname = %s"
        data = (foodName,)
        cur.execute(query, data)
        return cur.fetchall()

    def getFoodName(self, foodid):
        query = "SELECT foodname FROM food WHERE foodid = %s"
        data = (foodid,)
        cur.execute(query, data)
        return cur.fetchall()
    

    def registerUser(self, email, username, password):
        try:
            query = "SELECT registerUser(%s,%s,%s);"
            data = (email, username, password)
            cur.execute(query, data)
            conn.commit()
        except:
            conn.rollback()

    def registerEmployee(self, eid, fname, lname, password,worksat):
        query = "SELECT * FROM Employee WHERE employeeid = %s"
        data = (eid,)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        if rowcount >= 1: # if eid already exists                   
            return 0
        else:
            query1 = "INSERT INTO Employee (employeeid,fname,lname,password) Values (%s,%s,%s,%s)"
            data1 = (eid,fname, lname, password)
            cur.execute(query1, data1)
            conn.commit()

            query2 = "INSERT INTO WorksAt (employeeid,cafename) Values (%s,%s)"
            data2 = (eid,worksat)
            cur.execute(query2, data2)
            conn.commit()
        return 1

    def deleteEmployee(self, eid):
        query = "SELECT * FROM Employee WHERE employeeid = %s"
        data = (eid,)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        if rowcount == 0:
            return 0
        else:
            query1 = "DELETE FROM Employee WHERE employeeid = %s"
            data1 = (eid,)
            cur.execute(query1, data1)
            conn.commit()
        return 1
    def deleteCustomer(self, username):
        query = "SELECT * FROM Customer WHERE username = %s"
        data = (username,)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        if rowcount == 0:
            return 0
        else:
            query1 = "DELETE FROM Customer WHERE username = %s"
            data1 = (username,)
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
            
    def getUser(self, sid):
        query = "SELECT username FROM customer WHERE sessiontoken = %s"
        data = (sid,)
        cur.execute(query, data)
        return cur.fetchall()

    def updateSessionTokenCustomer(self,login,sessionToken, email):
        try:
            if(login == True):
                query = "UPDATE customer SET sessionToken = %s WHERE email = %s"
                data = (sessionToken,email)
                cur.execute(query, data)
                conn.commit()
            else:
                query = "UPDATE customer SET sessionToken = 0 WHERE sessiontoken = %s"
                data = (sessionToken,)
                cur.execute(query, data)
                conn.commit()
        except:
            conn.rollback()


    def checkEmployee(self,eid,password):
        query = "SELECT employeeid FROM Employee WHERE employeeid = %s AND password = %s"
        data = (eid, password)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        if rowcount == 1: #eid and password are valid
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
    def getTopFood(self):
        query = "SELECT foodname, description, rating FRom food ORDER BY rating limit 20"
        cur.execute(query)
        return cur.fetchall()
    def getBotFood(self):
        query = "SELECT foodname, description, rating FRom food ORDER BY rating DESC limit 20"
        cur.execute(query)
        return cur.fetchall()
    
    def AddCommentFunction(self):
        query = """CREATE OR REPLACE FUNCTION rateFood(fid integer,Ratings Integer, comment text, uname TEXT)
                    RETURNS integer AS $$
	                declare
	                getmenuID integer;
	                getUsername text;
                    BEGIN
                        SELECT email INTO getUsername FROM customer WHERE username = uname;
                        SELECT menu.menuid INTO getmenuID FROM (contains JOIN menu ON contains.menuid = menu.menuid) where meal = 2;
                        INSERT INTO rating (foodid,time,menuid,rating,comment) Values (fid, CURRENT_TIMESTAMP,getmenuID, Ratings, COMMENT);
                        INSERT INTO Gives ( customeremail, ratingtime, foodid) Values (getUsername,CURRENT_TIMESTAMP,fid) ON CONFLICT DO NOTHING;
                         
                        RETURN getmenuID;
                        END;
                $$ LANGUAGE plpgsql;"""
        cur.execute(query)
        conn.commit()

    def insertFoodsFunctions(self):
        query = """CREATE OR REPLACE FUNCTION insertFoods(fid integer, Vegetarian boolean,GlutenFree boolean, Vegan boolean, Kosher boolean, FoodName TEXT, Description text, Rating integer, mealType INTEGER)
                    RETURNS integer AS $$
	                declare
	                getmenuID integer;
                    inContains integer := 0;
                    BEGIN

                        SELECT COUNT(*) INTO inContains FROM (contains JOIN menu ON contains.menuid = menu.menuid) WHERE contains.foodid = fid AND menu.meal = mealType;
                        IF inContains = 0 THEN
                        INSERT INTO Food ( FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, Description, Rating) Values (fid,Vegetarian,Vegan, GlutenFree, Kosher,FoodName,Description,Rating) ON CONFLICT DO NOTHING;
                         INSERT INTO menu (meal, date) Values (mealType, CURRENT_TIMESTAMP);
                            SELECT MAX(MenuID) into getmenuID FROM menu;
                            INSERT INTO contains(foodid,menuid) VALUES(fid, getmenuID);
                        END IF;
                        RETURN inContains;
                        END;
                $$ LANGUAGE plpgsql;"""
        cur.execute(query)
        conn.commit()

    def registerUserFunction(self):
        #Check uniqueness
        query = """CREATE OR REPLACE FUNCTION registerUser (
            inputEmail TEXT,
            Uname TEXT,
            Pword TEXT
        )
        RETURNS BOOLEAN AS $$
        declare
	        usrExist integer;
        BEGIN
            SELECT count(*) into usrExist FROM Customer WHERE username = Uname;
            IF usrExist = 0 THEN
                INSERT INTO Customer (email, password, Username) Values (inputEmail,Pword,Uname) ON CONFLICT(email) DO NOTHING;
                RETURN TRUE;
            ELSE
                RAISE EXCEPTION 'cannot have a negative salary'; 
                RETURN FALSE;
            END IF;
        END;
        $$ LANGUAGE plpgsql;"""
        cur.execute(query)
        conn.commit()