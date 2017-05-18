import psycopg2
import sys
from datetime import datetime
from flask import current_app
import json
from datetime import datetime
import calendar

class myDB(object):

    def __init__(self, databaseName, user, password, host, port):
        global conn
        global cur
        conn = psycopg2.connect(database=databaseName, user=user, password=password, host=host, port=port)
        cur = conn.cursor()
        self.insertFoodsFunctions()
        self.registerUserFunction()
        self.AddCommentorRatingFunction()

    def insertFood(self, FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating, meal):
        query = "SELECT insertFoods(%s, %s, %s,%s,%s,%s, %s, %s, %s)"
        data = (FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, FoodDescription, AvgRating, meal)
        cur.execute(query, data)
        conn.commit()

    def getRatingValue(self, FoodID):
        query = "SELECT RATING FROM food WHERE foodid = %s"
        data = (FoodID,)
        cur.execute(query, data)
        return cur.fetchall()

    def getComments(self, FoodID): #TODO: GET USERNAME INSTEAD
        query = "SELECT comment,time,username FROM RATING WHERE RATING.foodid = %s AND comment IS NOT NULL ORDER BY time DESC"
        data = (FoodID,)
        cur.execute(query, data)
        return cur.fetchall()

    def addCommentOrRate(self, foodID, ratings, Comment, uname):
        print ' called'
        d = datetime.utcnow()
        unixtime = calendar.timegm(d.utctimetuple())
        print unixtime
        # try:
        current_app.logger.debug("COMMENT: %s,%s,%s,%s",str(foodID),str(ratings),str(Comment),str(uname))
        print "FOOD ID: " + str(foodID)
        print "ratings: " + str(ratings)
        print "Comment: " + str(Comment)
        print "uname: " + str(uname)

        query = "SELECT ratefood(%s,%s,%s,%s,%s)"
        data = (foodID, ratings, Comment, uname, unixtime)
        cur.execute(query, data)
        conn.commit()
        #(fid integer, ratings integer, comment text, uname text, ratetime integer)

        # except:
        #     print Exception
        #     conn.rollback()
        
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
        query = "SELECT addemployee (%s, %s, %s, %s, %s);"
        data = (eid,fname,lname,password,worksat)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        current_app.logger.debug(rowcount)
        if rowcount == 0:
            return 0
        return 1

    def deleteEmployee(self, eid):
        query = "select deleteEmployee (%s);"
        data = (eid,)
        cur.execute(query, data)
        conn.commit()
        rowcount = cur.rowcount
        if rowcount == 0:
            return 0
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
        query = "SELECT employee.fname, employee.lname, employee.employeeid,worksat.cafename FROM (employee JOIN worksat ON employee.employeeid = worksat.employeeid);"
        cur.execute(query)
        return cur.fetchall()

    def getCustomers(self):
        query = "SELECT customer.username, customer.email, customer.favorite FROM customer;"
        cur.execute(query)
        return cur.fetchall()

    #def getFoodInfo() :
        #call the top and bottom ranked foods here
    def getTopFood(self):
        query = "SELECT foodname, description, rating FRom food ORDER BY rating DESC limit 20"
        cur.execute(query)
        return cur.fetchall()

    def getBotFood(self):
        query = "SELECT foodname, description, rating FRom food ORDER BY rating limit 20"
        cur.execute(query)
        return cur.fetchall()
    
    def AddCommentorRatingFunction(self):
        query = """CREATE OR REPLACE FUNCTION ratefood(fid integer, ratings integer, newComment text, uname text, ratetime integer)
                    RETURNS integer
                    LANGUAGE plpgsql
                    AS $function$
                        declare
                        rowCount integer;
                        originalRating integer;
                        totalRating integer;
                        BEGIN
                            SELECT count(*) into rowCount FROM customer WHERE username = uname;
                            if rowCount = 0 THEN
                                return 0;
                            END IF;
                            SELECT count(*) into rowCount FROM food WHERE foodid = fid;
                            if rowCount = 0 THEN
                                return 0;
                            END IF;
                            if ratings = 2 THEN
                                Select rating into originalRating From rating where foodid = fid and username = uname;
                                SELECT count(*) into rowCount From rating Where foodid = fid AND username = uname;
                                if rowCount = 0 THEN
                                    INSERT INTO rating (foodid,time,rating,comment,username) Values (fid, ratetime, originalRating, newComment,uname);
                                    RETURN 1;
                                ELSE
                                    Update rating Set comment = newComment Where foodid = fid AND username = uname;
                                    Return 1;
                                END IF;
                            END IF;
                            SELECT count(*) into rowCount From rating Where foodid = fid AND username = uname;
                            if rowCount = 0 THEN
                                INSERT INTO rating (foodid,time,rating,username) Values (fid, ratetime, ratings,uname);
                            ELSE
                                Update rating Set rating = Ratings Where foodid = fid AND username = uname;
                            END IF;
                            SELECT SUM(rating) INTO totalRating FROM rating WHERE foodid = fid AND rating != 2;
                            UPDATE food SET rating = totalRating WHERE foodid = fid; 
                            RETURN 1;
                        END;
                    $function$"""
        cur.execute(query)
        conn.commit()

    def insertFoodsFunctions(self):
        query = """CREATE OR REPLACE FUNCTION insertFoods(fid integer, Vegetarian boolean,GlutenFree boolean, Vegan boolean, Kosher boolean, FoodName TEXT, Description text, Rating integer, mealType INTEGER)
                    RETURNS integer AS $$
	                declare
	                getmenuID integer;
                    inContains integer := 0;
                    BEGIN
                        SELECT COUNT(*) INTO inContains FROM (contains JOIN menu ON contains.menuid = menu.menuid) WHERE contains.foodid = fid AND menu.meal = mealType AND menu.date = CURRENT_DATE;
                        IF inContains = 0 THEN
                            INSERT INTO Food ( FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, Description, Rating) Values (fid,Vegetarian,Vegan, GlutenFree, Kosher,FoodName,Description,Rating) ON CONFLICT DO NOTHING;
                            INSERT INTO menu (meal, date) Values (mealType, CURRENT_DATE);
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
                RAISE EXCEPTION 'cannot have duplicate users'; 
                RETURN FALSE;
            END IF;
        END;
        $$ LANGUAGE plpgsql;"""
        cur.execute(query)
        conn.commit()