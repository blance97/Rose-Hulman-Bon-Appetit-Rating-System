--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Name: addemployee(integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addemployee(eid integer, f_name character varying, l_name character varying, pass character varying, works character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
getId INTEGER;
BEGIN
    SELECT Count(*) INTO getId FROM employee WHERE employeeid=eid;
    if getID = 0 THEN
        INSERT INTO Employee (employeeid, fname, lname, password) Values(eid,f_name, l_name, pass);
        INSERT INTO WorksAt (employeeid, cafename) Values (eid,works);
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$;


ALTER FUNCTION public.addemployee(eid integer, f_name character varying, l_name character varying, pass character varying, works character varying) OWNER TO postgres;

--
-- Name: changeworkplace(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION changeworkplace(eid integer, works character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
containTrue INTEGER;
BEGIN
    SELECT Count(*) INTO containTrue FROM cafe WHERE cafename=works;
    if containTrue = 0 THEN
        RETURN FALSE;
    END IF;
    SELECT Count(*) INTO containTrue FROM employee WHERE employeeid=eid;
    if containTrue = 0 THEN
        RETURN FALSE;
    END IF;
    SELECT Count(*) INTO containTrue FROM worksat WHERE employeeid=eid;
    if containsTrue = 0 THEN
        INSERT INTO worksat (employeeid, cafename) VALUES(eid,works);
        RETURN TRUE;
    END IF;
    UPDATE WorksAts SET cafename = works WHERE employeeid =eid;
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.changeworkplace(eid integer, works character varying) OWNER TO postgres;

--
-- Name: deleteemployee(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION deleteemployee(eid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
containTrue INTEGER;
BEGIN
    SELECT Count(*) INTO containTrue FROM employee WHERE employeeid=eid;
    if containTrue = 0 THEN
        RETURN FALSE;
    END IF;
    DELETE FROM employee WHERE employeeid = eid;
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.deleteemployee(eid integer) OWNER TO postgres;

--
-- Name: insertfoods(integer, boolean, boolean, boolean, boolean, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertfoods(fid integer, vegetarian boolean, glutenfree boolean, vegan boolean, kosher boolean, foodname text, description text, rating integer, mealtype integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
getmenuID integer;
inContains integer;
inFood Integer;
menuExists integer;
BEGIN
    SELECT count(*) into inFood From food where foodid = fid;
    if inFood = 0 then
        iNSERT INTO Food ( FoodID, Vegetarian, Vegan, GlutenFree, Kosher, FoodName, Description, Rating) Values (fid,Vegetarian,Vegan, GlutenFree, Kosher,FoodName,Description,Rating) ON CONFLICT DO NOTHING;
    end if;
    select count(*) into menuExists from menu where date = current_date and meal = mealtype;
    if menuExists = 0 then
        INSERT INTO menu (meal, date) Values (mealType, CURRENT_DATE);
    end if;
    SELECT menuid into getmenuID FROM menu where date = current_date and meal = mealtype ;
    SELECT COUNT(*) INTO inContains FROM (contains JOIN menu ON contains.menuid = menu.menuid) WHERE contains.foodid = fid AND menu.menuid = getMenuID;
    IF inContains = 0 THEN
        INSERT INTO contains(foodid,menuid) VALUES(fid, getmenuID);
    END IF;
    RETURN inContains;
END;
$$;


ALTER FUNCTION public.insertfoods(fid integer, vegetarian boolean, glutenfree boolean, vegan boolean, kosher boolean, foodname text, description text, rating integer, mealtype integer) OWNER TO postgres;

--
-- Name: ratefood(integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ratefood(fid integer, ratings integer, comment text, uname text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
                        declare
                        rowCount integer;
                        originalRating integer;
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
                                    INSERT INTO rating (foodid,time,rating,comment,username) Values (fid, CURRENT_TIMESTAMP, originalRating, COMMENT,uname);
                                    RETURN 1;
                                ELSE
                                    Update rating Set rating = originalRating Where foodid = fid AND username = uname;
                                    Return 1;
                                END IF;
                            END IF;
                            SELECT count(*) into rowCount From rating Where foodid = fid AND username = uname;
                            if rowCount = 0 THEN
                                INSERT INTO rating (foodid,"time",rating,"comment") Values (fid, CURRENT_TIMESTAMP, Ratings, COMMENT);
                                RETURN 1;
                            ELSE
                                Update rating Set rating = Ratings Where foodid = fid AND username = uname;
                            END IF;
                            RETURN 1;
                        END;
                    $$;


ALTER FUNCTION public.ratefood(fid integer, ratings integer, comment text, uname text) OWNER TO postgres;

--
-- Name: ratefood(integer, integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ratefood(fid integer, ratings integer, newcomment text, uname text, ratetime integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
                    $$;


ALTER FUNCTION public.ratefood(fid integer, ratings integer, newcomment text, uname text, ratetime integer) OWNER TO postgres;

--
-- Name: registeruser(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registeruser(inputemail text, uname text, pword text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
        $$;


ALTER FUNCTION public.registeruser(inputemail text, uname text, pword text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cafe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cafe (
    cafename character varying(30) NOT NULL,
    location character varying(30) NOT NULL,
    hours text
);


ALTER TABLE cafe OWNER TO postgres;

--
-- Name: allcafehours; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW allcafehours AS
 SELECT cafe.cafename,
    cafe.location,
    cafe.hours
   FROM cafe;


ALTER TABLE allcafehours OWNER TO postgres;

--
-- Name: contains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE contains (
    menuid integer NOT NULL,
    foodid integer NOT NULL
);


ALTER TABLE contains OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customer (
    username character varying(20) NOT NULL,
    email character varying(30) NOT NULL,
    password text NOT NULL,
    favorite integer,
    sessiontoken character varying(2044),
    CONSTRAINT "check username length" CHECK ((length((username)::text) >= 6))
);


ALTER TABLE customer OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE employee (
    employeeid integer NOT NULL,
    password text NOT NULL,
    fname character varying(20) NOT NULL,
    lname character varying(20) NOT NULL,
    sessiontoken text,
    CONSTRAINT "Check password length" CHECK ((char_length(password) >= 8))
);


ALTER TABLE employee OWNER TO postgres;

--
-- Name: worksat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE worksat (
    employeeid integer NOT NULL,
    cafename character varying(30) NOT NULL
);


ALTER TABLE worksat OWNER TO postgres;

--
-- Name: employeeview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW employeeview AS
 SELECT employee.employeeid,
    employee.fname,
    employee.lname,
    worksat.cafename
   FROM employee,
    worksat
  WHERE (employee.employeeid = worksat.employeeid);


ALTER TABLE employeeview OWNER TO postgres;

--
-- Name: VIEW employeeview; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW employeeview IS 'Shows employee id, first and last name of employees, and where the employee works.';


--
-- Name: food; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE food (
    foodid integer NOT NULL,
    vegetarian boolean,
    vegan boolean,
    glutenfree boolean,
    kosher boolean,
    foodname text NOT NULL,
    description text NOT NULL,
    rating integer NOT NULL
);


ALTER TABLE food OWNER TO postgres;

--
-- Name: menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE menu (
    menuid integer NOT NULL,
    meal smallint NOT NULL,
    date date,
    CONSTRAINT "check meal validation" CHECK (((meal = 0) OR (meal = 1) OR (meal = 2)))
);


ALTER TABLE menu OWNER TO postgres;

--
-- Name: menu_menuid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE menu_menuid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE menu_menuid_seq OWNER TO postgres;

--
-- Name: menu_menuid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE menu_menuid_seq OWNED BY menu.menuid;


--
-- Name: menuexists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE menuexists (
    count bigint
);


ALTER TABLE menuexists OWNER TO postgres;

--
-- Name: rating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE rating (
    foodid integer NOT NULL,
    rating integer NOT NULL,
    comment text,
    username character varying(2044) NOT NULL,
    "time" bigint NOT NULL,
    CONSTRAINT "check rating valid" CHECK (((rating >= '-1'::integer) AND (rating <= 1)))
);


ALTER TABLE rating OWNER TO postgres;

--
-- Name: serves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE serves (
    servingname character varying(30) NOT NULL,
    menuid integer NOT NULL
);


ALTER TABLE serves OWNER TO postgres;

--
-- Name: servinglocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE servinglocation (
    servingname character varying(30) NOT NULL,
    cafename character varying(30)
);


ALTER TABLE servinglocation OWNER TO postgres;

--
-- Name: menu menuid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY menu ALTER COLUMN menuid SET DEFAULT nextval('menu_menuid_seq'::regclass);


--
-- Data for Name: cafe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO cafe VALUES ('Faculty Dining Room', 'Union', 'CLOSED');
INSERT INTO cafe VALUES ('C-Store', 'Apartments', 'GRAB ''N'' GOSERVED FROM 2:00 PM - 9:00 PM');
INSERT INTO cafe VALUES ('Logans', 'Library', 'GRAB ''N'' GO SERVED FROM 10:00 AM - 11:00 PM');
INSERT INTO cafe VALUES ('Moench Cafe', 'Moench', 'GRAB ''N'' GO SERVED FROM 7:45 AM - 3:00 PM');
INSERT INTO cafe VALUES ('Union Cafe', 'Union', 'BREAKFAST 7:00 AM - 10:00 AM<br>
LUNCH 10:45 AM - 2:00 PM<br>
DINNER 5:00 PM - 8:00 PM<br>
LATE NIGHT 9:00 PM - 11:00 PM<br>');
INSERT INTO cafe VALUES ('Subway', 'Apartments', 'LUNCH 10:45 AM - 5:00 PM<br>
DINNER 5:00 PM - 11:00 PM');


--
-- Data for Name: contains; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO contains VALUES (344, 7170680);
INSERT INTO contains VALUES (344, 7170681);
INSERT INTO contains VALUES (344, 7170684);
INSERT INTO contains VALUES (344, 7170678);
INSERT INTO contains VALUES (344, 7170677);
INSERT INTO contains VALUES (345, 7106047);
INSERT INTO contains VALUES (345, 7106052);
INSERT INTO contains VALUES (345, 7106058);
INSERT INTO contains VALUES (345, 7100302);
INSERT INTO contains VALUES (345, 7170705);
INSERT INTO contains VALUES (345, 7170704);
INSERT INTO contains VALUES (345, 7100298);
INSERT INTO contains VALUES (345, 7100292);
INSERT INTO contains VALUES (345, 7106063);
INSERT INTO contains VALUES (345, 7134716);
INSERT INTO contains VALUES (345, 5769477);
INSERT INTO contains VALUES (345, 5769476);
INSERT INTO contains VALUES (345, 5769473);
INSERT INTO contains VALUES (345, 5725286);
INSERT INTO contains VALUES (345, 5725125);
INSERT INTO contains VALUES (345, 5725124);
INSERT INTO contains VALUES (345, 5547941);
INSERT INTO contains VALUES (345, 5547940);
INSERT INTO contains VALUES (345, 5547943);
INSERT INTO contains VALUES (345, 5547942);
INSERT INTO contains VALUES (345, 5547945);
INSERT INTO contains VALUES (345, 5547944);
INSERT INTO contains VALUES (345, 5547947);
INSERT INTO contains VALUES (345, 5547946);
INSERT INTO contains VALUES (345, 5547948);
INSERT INTO contains VALUES (345, 5547897);
INSERT INTO contains VALUES (345, 5547896);
INSERT INTO contains VALUES (345, 5547895);
INSERT INTO contains VALUES (345, 5547894);
INSERT INTO contains VALUES (345, 5547893);
INSERT INTO contains VALUES (345, 5547892);
INSERT INTO contains VALUES (345, 5547891);
INSERT INTO contains VALUES (345, 5547890);
INSERT INTO contains VALUES (345, 5725123);
INSERT INTO contains VALUES (345, 5547950);
INSERT INTO contains VALUES (345, 5547951);
INSERT INTO contains VALUES (345, 5601542);
INSERT INTO contains VALUES (345, 5769456);
INSERT INTO contains VALUES (345, 5769459);
INSERT INTO contains VALUES (345, 5737771);
INSERT INTO contains VALUES (345, 5547929);
INSERT INTO contains VALUES (345, 5547887);
INSERT INTO contains VALUES (345, 5547923);
INSERT INTO contains VALUES (345, 5547921);
INSERT INTO contains VALUES (345, 5547920);
INSERT INTO contains VALUES (345, 5547888);
INSERT INTO contains VALUES (345, 5547889);
INSERT INTO contains VALUES (345, 5547925);
INSERT INTO contains VALUES (345, 5547924);
INSERT INTO contains VALUES (345, 5737149);
INSERT INTO contains VALUES (345, 5601530);
INSERT INTO contains VALUES (345, 5769448);
INSERT INTO contains VALUES (345, 5769447);
INSERT INTO contains VALUES (345, 5769444);
INSERT INTO contains VALUES (345, 5547938);
INSERT INTO contains VALUES (345, 5547939);
INSERT INTO contains VALUES (345, 5547930);
INSERT INTO contains VALUES (345, 5547931);
INSERT INTO contains VALUES (345, 5547932);
INSERT INTO contains VALUES (345, 5547933);
INSERT INTO contains VALUES (345, 5547934);
INSERT INTO contains VALUES (345, 5547935);
INSERT INTO contains VALUES (345, 5547936);
INSERT INTO contains VALUES (345, 5547937);
INSERT INTO contains VALUES (345, 5737759);
INSERT INTO contains VALUES (345, 5601524);
INSERT INTO contains VALUES (345, 5601525);
INSERT INTO contains VALUES (345, 5601526);
INSERT INTO contains VALUES (345, 5601527);
INSERT INTO contains VALUES (345, 5769432);
INSERT INTO contains VALUES (345, 5547905);
INSERT INTO contains VALUES (345, 5547904);
INSERT INTO contains VALUES (345, 5547907);
INSERT INTO contains VALUES (345, 5547906);
INSERT INTO contains VALUES (345, 5547903);
INSERT INTO contains VALUES (345, 5547909);
INSERT INTO contains VALUES (345, 5547908);
INSERT INTO contains VALUES (345, 5769428);
INSERT INTO contains VALUES (345, 5769421);
INSERT INTO contains VALUES (345, 5547912);
INSERT INTO contains VALUES (345, 5547913);
INSERT INTO contains VALUES (345, 5547910);
INSERT INTO contains VALUES (345, 5547911);
INSERT INTO contains VALUES (345, 5547916);
INSERT INTO contains VALUES (345, 5547917);
INSERT INTO contains VALUES (345, 5547914);
INSERT INTO contains VALUES (345, 5547915);
INSERT INTO contains VALUES (345, 5547918);
INSERT INTO contains VALUES (345, 5547919);
INSERT INTO contains VALUES (345, 5737401);
INSERT INTO contains VALUES (346, 7164957);
INSERT INTO contains VALUES (346, 7106052);
INSERT INTO contains VALUES (346, 7100302);
INSERT INTO contains VALUES (346, 7170705);
INSERT INTO contains VALUES (346, 7170704);
INSERT INTO contains VALUES (346, 7100298);
INSERT INTO contains VALUES (346, 7100292);
INSERT INTO contains VALUES (346, 7106068);


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO customer VALUES ('lancedinh7', 'lancedinh7@gmail.com', '$2b$12$kBpRH1g9DGx9m7TJauEeduN31owV7uJbvddJwDm6VSlw9Grvj20jq', NULL, '6417c0d4-bed5-4b04-abdb-a5fd98794340');


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO employee VALUES (12345678, '$2b$12$A5LLLVNWXHWjWZpgu6.MTOjZqxBdqDp8QCgJDO236bphDNrTjB2Fy', 'Lance', 'Dinh', '0');
INSERT INTO employee VALUES (12345677, '$2b$12$tcU6BfCl8aOf0MKjLh8ML.rfoGnZc/Rc5d1jnOX3OUy1A6pOrduie', 'Batman', 'Robin', NULL);


--
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO food VALUES (7170681, false, true, false, false, 'breakfast potato''s', 'good', 0);
INSERT INTO food VALUES (7170684, false, true, false, false, 'banana coconut smoothie', 'good', 0);
INSERT INTO food VALUES (7170678, false, true, true, false, 'vegan tofu spinach scramble', 'good', 0);
INSERT INTO food VALUES (7170677, false, true, true, false, 'buttermilk biscuits', 'good', 0);
INSERT INTO food VALUES (7106047, false, true, false, false, 'Fischer Farms beef burger', 'good', 0);
INSERT INTO food VALUES (7106052, false, true, true, false, 'house-made bean burger', 'good', 0);
INSERT INTO food VALUES (7106058, false, true, false, false, 'grilled all beef hot dog', 'good', 0);
INSERT INTO food VALUES (7100302, false, true, false, false, 'breakfast pizza', 'good', 0);
INSERT INTO food VALUES (7170705, true, true, false, false, 'cream of cauliflower soup', 'good', 0);
INSERT INTO food VALUES (7170704, false, true, false, false, 'ham and bean soup with sun dried tomato', 'good', 0);
INSERT INTO food VALUES (7100298, false, true, false, false, 'chicken bacon pizza', 'good', 0);
INSERT INTO food VALUES (7100292, true, true, false, false, 'cheese pizza', 'good', 0);
INSERT INTO food VALUES (7106063, true, true, false, false, 'grilled cheese', 'good', 0);
INSERT INTO food VALUES (7134716, false, true, false, false, 'herb turkey meatballs', 'good', 0);
INSERT INTO food VALUES (5769477, false, true, true, false, 'Iced caffe americano 20 oz', 'good', 0);
INSERT INTO food VALUES (5769476, false, true, true, false, 'iced caffe americano 16 oz', 'good', 0);
INSERT INTO food VALUES (5769473, false, true, true, false, 'iced caffe americano 12 oz', 'good', 0);
INSERT INTO food VALUES (5725286, false, true, true, false, 'flavored iced tea | unsweetened', 'good', 0);
INSERT INTO food VALUES (5725125, true, true, false, false, 'caffe misto 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5725124, true, true, false, false, 'caffe misto 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547941, true, true, false, false, 'coconut coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547940, true, true, false, false, 'cinnamon coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547943, true, true, false, false, 'hazelnut coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547942, true, true, false, false, 'dark chocolate coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547945, true, true, false, false, 'peppermint coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547944, true, true, false, false, 'Irish creme coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547947, true, true, false, false, 'strawberry coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547946, true, true, false, false, 'raspberry coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547948, true, true, false, false, 'toffee nut coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547897, true, true, false, false, 'iced caramel macchiato 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547896, true, true, false, false, 'iced caramel macchiato 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547895, true, true, false, false, 'iced caramel macchiato 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547894, true, true, false, false, 'caramel macchiato 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547893, true, true, false, false, 'caramel macchiato 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547892, true, true, false, false, 'caramel macchiato 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547891, false, true, true, false, 'iced coffee', 'good', 0);
INSERT INTO food VALUES (5547890, true, true, false, false, 'caffe Americano', 'good', 0);
INSERT INTO food VALUES (5725123, true, true, false, false, 'caffe misto 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547950, true, true, false, false, 'vanilla sugar free coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547951, true, true, false, false, 'white chocolate coffee syrup', 'good', 0);
INSERT INTO food VALUES (5601542, false, true, true, false, 'espresso dupio', 'good', 0);
INSERT INTO food VALUES (5769456, true, true, false, false, 'espresso con panna solo', 'good', 0);
INSERT INTO food VALUES (5769459, true, true, false, false, 'espresso con panna dupio', 'good', 0);
INSERT INTO food VALUES (5737771, true, true, false, false, 'iced caffe mocha 2% milk 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547929, true, true, false, false, 'granulated sugar', 'good', 0);
INSERT INTO food VALUES (5547887, false, true, true, false, 'iced tea | unsweetened', 'good', 0);
INSERT INTO food VALUES (5547923, true, true, false, false, 'hot chocolate 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547921, true, true, false, false, 'espresso macchiato single 2%', 'good', 0);
INSERT INTO food VALUES (5547920, true, true, false, false, 'white chocolate mocha 2% milk 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547888, false, true, true, false, 'black coffee', 'good', 0);
INSERT INTO food VALUES (5547889, false, true, true, false, 'espresso solo', 'good', 0);
INSERT INTO food VALUES (5547925, true, true, false, false, 'hot chocolate 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547924, true, true, false, false, 'hot chocolate 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5737149, true, true, false, false, 'lemonade', 'good', 0);
INSERT INTO food VALUES (5601530, false, true, true, false, 'hot tea', 'good', 0);
INSERT INTO food VALUES (5769448, true, true, false, false, 'vanilla steamer 20 oz', 'good', 0);
INSERT INTO food VALUES (5769447, true, true, false, false, 'vanilla steamer 16 oz', 'good', 0);
INSERT INTO food VALUES (5769444, true, true, false, false, 'vanilla steamer 12 oz', 'good', 0);
INSERT INTO food VALUES (5547938, true, true, false, false, 'caramel coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547939, true, true, false, false, 'caramel sugar free coffee syrup', 'good', 0);
INSERT INTO food VALUES (5547930, true, true, false, false, 'honey', 'good', 0);
INSERT INTO food VALUES (5547931, false, true, true, false, 'agave nectar', 'good', 0);
INSERT INTO food VALUES (5547932, false, true, true, false, 'Splenda', 'good', 0);
INSERT INTO food VALUES (5547933, true, true, false, false, '2% milk', 'good', 0);
INSERT INTO food VALUES (5547934, true, true, false, false, 'skim milk', 'good', 0);
INSERT INTO food VALUES (5547935, true, true, false, false, 'half & half', 'good', 0);
INSERT INTO food VALUES (5547936, true, true, false, false, 'almond milk', 'good', 0);
INSERT INTO food VALUES (5547937, true, true, false, false, 'soy milk', 'good', 0);
INSERT INTO food VALUES (5737759, true, true, false, false, 'iced white chocolate mocha 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5601524, false, true, false, false, 'iced caffe latte 2% milk 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5601525, true, true, false, false, 'iced caffe mocha 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5601526, true, true, false, false, 'iced white chocolate mocha 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5601527, true, true, false, false, 'espresso macchiato double 2%', 'good', 0);
INSERT INTO food VALUES (5769432, true, true, false, false, 'white hot chocolate 20 oz', 'good', 0);
INSERT INTO food VALUES (5547905, true, true, false, false, 'caffe latte 2% milk 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547904, true, true, false, false, 'caffe latte 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547907, true, true, false, false, 'caffe mocha 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547906, true, true, false, false, 'caffe mocha 2% milk 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547903, true, true, false, false, 'caffe latte 2% milk 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547909, true, true, false, false, 'cappuccino 2% milk 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547908, true, true, false, false, 'caffe mocha 2% milk 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5769428, true, true, false, false, 'white hot chocolate 16 oz', 'good', 0);
INSERT INTO food VALUES (5769421, true, true, false, false, 'white hot chocolate 12 oz', 'good', 0);
INSERT INTO food VALUES (5547912, false, true, false, false, 'iced caffe latte 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547913, true, true, false, false, 'iced caffe latte 2% milk 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547910, true, true, false, false, 'cappuccino 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547911, true, true, false, false, 'cappuccino 2% milk 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547916, true, true, false, false, 'iced white chocolate mocha 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547917, true, true, false, false, 'iced white chocolate mocha 2% milk 20 fl oz', 'good', 0);
INSERT INTO food VALUES (5547914, true, true, false, false, 'iced caffe mocha 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5547915, true, true, false, false, 'iced caffe mocha 2% milk 20fl oz', 'good', 0);
INSERT INTO food VALUES (5547918, true, true, false, false, 'white chocolate mocha 2% milk 12 fl oz', 'good', 0);
INSERT INTO food VALUES (5547919, true, true, false, false, 'white chocolate mocha 2% milk 16 fl oz', 'good', 0);
INSERT INTO food VALUES (5737401, true, true, false, false, 'vanilla coffee syrup', 'good', 0);
INSERT INTO food VALUES (7170680, false, true, false, false, 'applewood bacon', 'good', 2);
INSERT INTO food VALUES (7164957, false, true, false, false, 'baked potato bar', 'good', 0);
INSERT INTO food VALUES (7106068, false, false, false, false, 'crispy chicken tenders', 'good', 0);


--
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO menu VALUES (344, 0, '2017-05-19');
INSERT INTO menu VALUES (345, 1, '2017-05-19');
INSERT INTO menu VALUES (346, 2, '2017-05-19');


--
-- Name: menu_menuid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('menu_menuid_seq', 346, true);


--
-- Data for Name: menuexists; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO rating VALUES (7170680, 1, 'dsa', 'lancedinh7', 1495181290);


--
-- Data for Name: serves; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: servinglocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO servinglocation VALUES ('World Foods', 'Union Cafe');
INSERT INTO servinglocation VALUES ('Home Foods', 'Union Cafe');
INSERT INTO servinglocation VALUES ('Grill', 'Union Cafe');
INSERT INTO servinglocation VALUES ('Moench Cafe', 'Moench Cafe');


--
-- Data for Name: worksat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO worksat VALUES (12345678, 'Union Cafe');
INSERT INTO worksat VALUES (12345677, 'Union Cafe');


--
-- Name: cafe cafe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cafe
    ADD CONSTRAINT cafe_pkey PRIMARY KEY (cafename);


--
-- Name: contains contains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_pkey PRIMARY KEY (menuid, foodid);


--
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (username);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employeeid);


--
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY food
    ADD CONSTRAINT food_pkey PRIMARY KEY (foodid);


--
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (menuid);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (username, foodid);


--
-- Name: serves serves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY serves
    ADD CONSTRAINT serves_pkey PRIMARY KEY (servingname, menuid);


--
-- Name: servinglocation servinglocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY servinglocation
    ADD CONSTRAINT servinglocation_pkey PRIMARY KEY (servingname);


--
-- Name: customer unique_sessiontoken; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT unique_sessiontoken UNIQUE (sessiontoken);


--
-- Name: worksat worksat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY worksat
    ADD CONSTRAINT worksat_pkey PRIMARY KEY (employeeid, cafename);


--
-- Name: index_sessiontoken; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_sessiontoken ON employee USING btree (sessiontoken);


--
-- Name: contains contains_foodid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_foodid_fkey FOREIGN KEY (foodid) REFERENCES food(foodid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains contains_menuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_menuid_fkey FOREIGN KEY (menuid) REFERENCES menu(menuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer favorite_foods; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT favorite_foods FOREIGN KEY (favorite) REFERENCES food(foodid);


--
-- Name: rating lnk_customer_rating; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT lnk_customer_rating FOREIGN KEY (username) REFERENCES customer(username) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: worksat lnk_employee_worksat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY worksat
    ADD CONSTRAINT lnk_employee_worksat FOREIGN KEY (employeeid) REFERENCES employee(employeeid) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rating rating_foodid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_foodid_fkey FOREIGN KEY (foodid) REFERENCES food(foodid);


--
-- Name: serves serves_menuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY serves
    ADD CONSTRAINT serves_menuid_fkey FOREIGN KEY (menuid) REFERENCES menu(menuid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: serves serves_servingname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY serves
    ADD CONSTRAINT serves_servingname_fkey FOREIGN KEY (servingname) REFERENCES servinglocation(servingname) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: servinglocation servinglocation_cafename_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY servinglocation
    ADD CONSTRAINT servinglocation_cafename_fkey FOREIGN KEY (cafename) REFERENCES cafe(cafename) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: worksat worksat_cafename_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY worksat
    ADD CONSTRAINT worksat_cafename_fkey FOREIGN KEY (cafename) REFERENCES cafe(cafename) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

