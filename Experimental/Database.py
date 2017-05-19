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
        
    def searchFood(self, searchString, meal):
        query = "SELECT food.foodname, food.description, food.vegetarian, food.vegan, food.glutenfree, food.rating FROM  (food join contains ON food.foodid = contains.foodid JOIN menu ON contains.menuid = menu.menuid) WHERE menu.meal = %s AND foodname LIKE %s"
        data = (str(meal), '%' + str(searchString) + '%')
        cur.execute(query, data)
        return cur.fetchall()

    def getFoodID(self, foodName):
        query = "SELECT foodid FROM food WHERE foodname = %s"
        data = (foodName,)
        cur.execute(query, data)
        return cur.fetchall()

    def getFoodName(self, foodid):
        try:
            query = "SELECT foodname FROM food WHERE foodid = %s"
            data = (foodid,)
            cur.execute(query, data)
            return cur.fetchall()
        except:
            print 'COULD NOT COMPLETE QUERY'
            conn.rollback()

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
        query = "SELECT * FROM allCafeHours"
        cur.execute(query)
        # retrieve the records from the database
        records = cur.fetchall()
        return records
    
    def getServingLocations(self):
        query = "SELECT * FROM servinglocation"
        cur.execute(query)
        current_app.logger.debug("GETSERVING LICATOIN")
        return cur.fetchall()

    def getEmployeeHours(self, sessiontoken):
        query = "Select c.cafename, c.location, c.hours from (employee e join worksat w on e.employeeid = w.employeeid) join cafe c on w.cafename = c.cafename where e.sessiontoken = %s"
        current_app.logger.debug("QUERY: " +str(query))
        data = (sessiontoken,)
        cur.execute(query,data)
        return cur.fetchall()

    def getCoworkers(self, sessiontoken):
        query2 = "select em.fname, em.lname from employee em join worksat wa on em.employeeid = wa.employeeid where wa.cafename = (Select w.cafename from employee e join worksat w on e.employeeid = w.employeeid where e.sessiontoken = %s)"
        current_app.logger.debug("QUERY: " +str(query2))
        data = (sessiontoken,)
        cur.execute(query2,data)
        return cur.fetchall()

    def checkUser(self, email, password):
        query = "SELECT username FROM Customer WHERE email = %s AND password = %s"
        data = (email, password)

    def getUserPassword(self, email):
        query = "SELECT password FROM Customer WHERE email = %s"
        data = (email,)
        cur.execute(query, data)
        return cur.fetchall()
        
            
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

    def updateSessionTokenEmployee(self,login,sessionToken,eid):
        # try:
        if(login == True):
            query = "UPDATE employee SET sessiontoken = %s WHERE employeeid = %s"
            data = (sessionToken,eid)
            cur.execute(query, data)
            conn.commit()
        else:
            query = "UPDATE employee SET sessionToken = 0 WHERE sessiontoken = %s"
            data = (sessionToken,)
            cur.execute(query, data)
            conn.commit()
        # except:
        #     conn.rollback()

    def getEmployeeID(self,eid):
        query = "SELECT password FROM Employee WHERE employeeid = %s"
        data = (eid,)
        cur.execute(query, data)
        return cur.fetchall()
        
    def getEmployees(self):
        query = "SELECT * FROM employeeview;"
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

    def getBreakfast(self):
        query ="select f.foodname from (menu m join contains c on m.menuid = c.menuid) join food f on c.foodid = f.foodid where m.date = current_date and m.meal = 0;"
        cur.execute(query)
        return cur.fetchall()
    
    def getLunch(self):
        query ="select f.foodname from (menu m join contains c on m.menuid = c.menuid) join food f on c.foodid = f.foodid where m.date = current_date and m.meal = 1;"
        cur.execute(query)
        return cur.fetchall()

    def getDinner(self):
        query ="select f.foodname from (menu m join contains c on m.menuid = c.menuid) join food f on c.foodid = f.foodid where m.date = current_date and m.meal = 2;"
        cur.execute(query)
        return cur.fetchall()