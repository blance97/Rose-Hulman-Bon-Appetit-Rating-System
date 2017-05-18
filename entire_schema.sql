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
    password character varying(32) NOT NULL,
    fname character varying(20) NOT NULL,
    lname character varying(20) NOT NULL,
    CONSTRAINT "Check password length" CHECK ((char_length((password)::text) >= 8))
);


ALTER TABLE employee OWNER TO postgres;

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
-- Name: worksat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE worksat (
    employeeid integer NOT NULL,
    cafename character varying(30) NOT NULL
);


ALTER TABLE worksat OWNER TO postgres;

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
INSERT INTO cafe VALUES ('Union Cafe', 'Union', 'BREAKFAST SERVED FROM 7:00 AM - 10:00 AM
LUNCH		10:45 AM - 2:00 PM
DINNER		5:00 PM - 8:00 PM
LATE NIGHT		9:00 PM - 11:00 PM');
INSERT INTO cafe VALUES ('Subway', 'Apartments', 'LUNCH SERVED FROM 10:45 AM - 5:00 PM
DINNER	             5:00 PM - 11:00 PM');


--
-- Data for Name: contains; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO contains VALUES (28, 5769477);
INSERT INTO contains VALUES (29, 5769476);
INSERT INTO contains VALUES (30, 5769473);
INSERT INTO contains VALUES (31, 5725286);
INSERT INTO contains VALUES (32, 5725124);
INSERT INTO contains VALUES (33, 5547941);
INSERT INTO contains VALUES (34, 5547940);
INSERT INTO contains VALUES (35, 5547943);
INSERT INTO contains VALUES (36, 5547942);
INSERT INTO contains VALUES (37, 5547945);
INSERT INTO contains VALUES (38, 5547944);
INSERT INTO contains VALUES (39, 5547947);
INSERT INTO contains VALUES (40, 5547946);
INSERT INTO contains VALUES (41, 5547948);
INSERT INTO contains VALUES (42, 5547897);
INSERT INTO contains VALUES (43, 5547896);
INSERT INTO contains VALUES (44, 5547895);
INSERT INTO contains VALUES (45, 5547894);
INSERT INTO contains VALUES (46, 5547893);
INSERT INTO contains VALUES (47, 5547892);
INSERT INTO contains VALUES (48, 5547891);
INSERT INTO contains VALUES (49, 5547890);
INSERT INTO contains VALUES (50, 5725123);
INSERT INTO contains VALUES (51, 5547950);
INSERT INTO contains VALUES (52, 5547951);
INSERT INTO contains VALUES (53, 5725125);
INSERT INTO contains VALUES (54, 5601542);
INSERT INTO contains VALUES (55, 5769456);
INSERT INTO contains VALUES (56, 5769459);
INSERT INTO contains VALUES (57, 5737771);
INSERT INTO contains VALUES (58, 5547929);
INSERT INTO contains VALUES (59, 5547887);
INSERT INTO contains VALUES (60, 5547923);
INSERT INTO contains VALUES (61, 5547921);
INSERT INTO contains VALUES (62, 5547920);
INSERT INTO contains VALUES (63, 5547888);
INSERT INTO contains VALUES (64, 5547889);
INSERT INTO contains VALUES (65, 5547925);
INSERT INTO contains VALUES (66, 5547924);
INSERT INTO contains VALUES (67, 5737149);
INSERT INTO contains VALUES (68, 5601530);
INSERT INTO contains VALUES (69, 5769448);
INSERT INTO contains VALUES (70, 5769447);
INSERT INTO contains VALUES (71, 5769444);
INSERT INTO contains VALUES (72, 5547938);
INSERT INTO contains VALUES (73, 5547939);
INSERT INTO contains VALUES (74, 5547931);
INSERT INTO contains VALUES (75, 5547932);
INSERT INTO contains VALUES (76, 5547933);
INSERT INTO contains VALUES (77, 5547934);
INSERT INTO contains VALUES (78, 5547935);
INSERT INTO contains VALUES (79, 5547936);
INSERT INTO contains VALUES (80, 5547937);
INSERT INTO contains VALUES (81, 5737759);
INSERT INTO contains VALUES (82, 5601524);
INSERT INTO contains VALUES (83, 5601525);
INSERT INTO contains VALUES (84, 5601526);
INSERT INTO contains VALUES (85, 5601527);
INSERT INTO contains VALUES (86, 5769432);
INSERT INTO contains VALUES (87, 5547905);
INSERT INTO contains VALUES (88, 5547904);
INSERT INTO contains VALUES (89, 5547907);
INSERT INTO contains VALUES (90, 5547906);
INSERT INTO contains VALUES (91, 5547903);
INSERT INTO contains VALUES (92, 5547909);
INSERT INTO contains VALUES (93, 5547908);
INSERT INTO contains VALUES (94, 5769428);
INSERT INTO contains VALUES (95, 5769421);
INSERT INTO contains VALUES (96, 5547912);
INSERT INTO contains VALUES (97, 5547913);
INSERT INTO contains VALUES (98, 5547910);
INSERT INTO contains VALUES (99, 5547911);
INSERT INTO contains VALUES (100, 5547916);
INSERT INTO contains VALUES (101, 5547917);
INSERT INTO contains VALUES (102, 5547914);
INSERT INTO contains VALUES (103, 5547915);
INSERT INTO contains VALUES (104, 5547918);
INSERT INTO contains VALUES (105, 5547919);
INSERT INTO contains VALUES (106, 5547930);
INSERT INTO contains VALUES (107, 5737401);
INSERT INTO contains VALUES (108, 7079982);
INSERT INTO contains VALUES (109, 7079978);
INSERT INTO contains VALUES (110, 7079973);
INSERT INTO contains VALUES (111, 7079954);
INSERT INTO contains VALUES (112, 7079959);
INSERT INTO contains VALUES (113, 7106029);
INSERT INTO contains VALUES (114, 7080069);
INSERT INTO contains VALUES (115, 7117323);
INSERT INTO contains VALUES (116, 7117198);
INSERT INTO contains VALUES (117, 7079969);
INSERT INTO contains VALUES (118, 7117197);
INSERT INTO contains VALUES (119, 7080082);
INSERT INTO contains VALUES (120, 7114778);
INSERT INTO contains VALUES (121, 7106040);
INSERT INTO contains VALUES (122, 7079978);
INSERT INTO contains VALUES (123, 7079973);
INSERT INTO contains VALUES (124, 7082745);
INSERT INTO contains VALUES (125, 7079954);
INSERT INTO contains VALUES (126, 7079959);
INSERT INTO contains VALUES (127, 7080069);
INSERT INTO contains VALUES (128, 7119646);
INSERT INTO contains VALUES (129, 7117323);
INSERT INTO contains VALUES (130, 7117198);
INSERT INTO contains VALUES (131, 7117197);
INSERT INTO contains VALUES (132, 5769477);
INSERT INTO contains VALUES (133, 5769476);
INSERT INTO contains VALUES (134, 5769473);
INSERT INTO contains VALUES (135, 5725286);
INSERT INTO contains VALUES (136, 5725124);
INSERT INTO contains VALUES (137, 5547941);
INSERT INTO contains VALUES (138, 5547940);
INSERT INTO contains VALUES (139, 5547943);
INSERT INTO contains VALUES (140, 5547942);
INSERT INTO contains VALUES (141, 5547945);
INSERT INTO contains VALUES (142, 5547944);
INSERT INTO contains VALUES (143, 5547947);
INSERT INTO contains VALUES (144, 5547946);
INSERT INTO contains VALUES (145, 5547948);
INSERT INTO contains VALUES (146, 5547897);
INSERT INTO contains VALUES (147, 5547896);
INSERT INTO contains VALUES (148, 5547895);
INSERT INTO contains VALUES (149, 5547894);
INSERT INTO contains VALUES (150, 5547893);
INSERT INTO contains VALUES (151, 5547892);
INSERT INTO contains VALUES (152, 5547891);
INSERT INTO contains VALUES (153, 5547890);
INSERT INTO contains VALUES (154, 5725123);
INSERT INTO contains VALUES (155, 5547950);
INSERT INTO contains VALUES (156, 5547951);
INSERT INTO contains VALUES (157, 5725125);
INSERT INTO contains VALUES (158, 5601542);
INSERT INTO contains VALUES (159, 5769456);
INSERT INTO contains VALUES (160, 5769459);
INSERT INTO contains VALUES (161, 5737771);
INSERT INTO contains VALUES (162, 5547929);
INSERT INTO contains VALUES (163, 5547887);
INSERT INTO contains VALUES (164, 5547923);
INSERT INTO contains VALUES (165, 5547921);
INSERT INTO contains VALUES (166, 5547920);
INSERT INTO contains VALUES (167, 5547888);
INSERT INTO contains VALUES (168, 5547889);
INSERT INTO contains VALUES (169, 5547925);
INSERT INTO contains VALUES (170, 5547924);
INSERT INTO contains VALUES (171, 5737149);
INSERT INTO contains VALUES (172, 5601530);
INSERT INTO contains VALUES (173, 5769448);
INSERT INTO contains VALUES (174, 5769447);
INSERT INTO contains VALUES (175, 5769444);
INSERT INTO contains VALUES (176, 5547938);
INSERT INTO contains VALUES (177, 5547939);
INSERT INTO contains VALUES (178, 5547931);
INSERT INTO contains VALUES (179, 5547932);
INSERT INTO contains VALUES (180, 5547933);
INSERT INTO contains VALUES (181, 5547934);
INSERT INTO contains VALUES (182, 5547935);
INSERT INTO contains VALUES (183, 5547936);
INSERT INTO contains VALUES (184, 5547937);
INSERT INTO contains VALUES (185, 5737759);
INSERT INTO contains VALUES (186, 5601524);
INSERT INTO contains VALUES (187, 5601525);
INSERT INTO contains VALUES (188, 5601526);
INSERT INTO contains VALUES (189, 5601527);
INSERT INTO contains VALUES (190, 5769432);
INSERT INTO contains VALUES (191, 5547905);
INSERT INTO contains VALUES (192, 5547904);
INSERT INTO contains VALUES (193, 5547907);
INSERT INTO contains VALUES (194, 5547906);
INSERT INTO contains VALUES (195, 5547903);
INSERT INTO contains VALUES (196, 5547909);
INSERT INTO contains VALUES (197, 5547908);
INSERT INTO contains VALUES (198, 5769428);
INSERT INTO contains VALUES (199, 5769421);
INSERT INTO contains VALUES (200, 5547912);
INSERT INTO contains VALUES (201, 5547913);
INSERT INTO contains VALUES (202, 5547910);
INSERT INTO contains VALUES (203, 5547911);
INSERT INTO contains VALUES (204, 5547916);
INSERT INTO contains VALUES (205, 5547917);
INSERT INTO contains VALUES (206, 5547914);
INSERT INTO contains VALUES (207, 5547915);
INSERT INTO contains VALUES (208, 5547918);
INSERT INTO contains VALUES (209, 5547919);
INSERT INTO contains VALUES (210, 5547930);
INSERT INTO contains VALUES (211, 5737401);
INSERT INTO contains VALUES (212, 7079982);
INSERT INTO contains VALUES (213, 7079978);
INSERT INTO contains VALUES (214, 7079973);
INSERT INTO contains VALUES (215, 7079954);
INSERT INTO contains VALUES (216, 7079959);
INSERT INTO contains VALUES (217, 7106029);
INSERT INTO contains VALUES (218, 7080069);
INSERT INTO contains VALUES (219, 7117323);
INSERT INTO contains VALUES (220, 7117198);
INSERT INTO contains VALUES (221, 7079969);
INSERT INTO contains VALUES (222, 7117197);
INSERT INTO contains VALUES (223, 7080082);
INSERT INTO contains VALUES (224, 7114778);
INSERT INTO contains VALUES (225, 7106040);
INSERT INTO contains VALUES (226, 7079978);
INSERT INTO contains VALUES (227, 7079973);
INSERT INTO contains VALUES (228, 7082745);
INSERT INTO contains VALUES (229, 7079954);
INSERT INTO contains VALUES (230, 7079959);
INSERT INTO contains VALUES (231, 7080069);
INSERT INTO contains VALUES (232, 7119646);
INSERT INTO contains VALUES (233, 7117323);
INSERT INTO contains VALUES (234, 7117198);
INSERT INTO contains VALUES (235, 7117197);


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO customer VALUES ('username', 'username@username.com', 'password', NULL, '0555ba7b-1eaf-41cb-a3ff-3fa2204255c6');
INSERT INTO customer VALUES ('newUser', 'test@gmail.com', 'asdasd', NULL, 'dfa50bbe-100b-41df-aecf-a64a91fc6834');
INSERT INTO customer VALUES ('lancedinh7', 'lancedinh7@gmail.com', 'asdasd', NULL, 'bcb3f7a7-ebd9-4d28-b031-879f0b48d795');


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO employee VALUES (12345678, 'password', 'Maya', 'Holeman');
INSERT INTO employee VALUES (11223344, 'password', 'Lance', 'Dinh');


--
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO food VALUES (7279200, false, true, true, false, 'spring salad with shallot and herb vinaigrette', 'good', 0);
INSERT INTO food VALUES (7279189, false, true, false, false, 'white bean and ham soup', 'good', 0);
INSERT INTO food VALUES (7279188, true, true, false, false, 'sweet potato bisque', 'good', 0);
INSERT INTO food VALUES (7254461, false, true, false, false, 'loaded veggie pizza', 'good', 0);
INSERT INTO food VALUES (7254540, false, true, false, false, 'Fischer Farms beef burger', 'good', 0);
INSERT INTO food VALUES (7265247, false, true, false, false, 'roasted chicken with sweet onion mustard glaze', 'good', 0);
INSERT INTO food VALUES (7256159, false, true, false, false, 'shrimp scampi pasta with tomatoes and parsley', 'good', 0);
INSERT INTO food VALUES (7282611, false, true, false, false, 'grilled club sandwich with onion rings', 'good', 0);
INSERT INTO food VALUES (7279187, false, true, true, false, 'vegan tofu and spinach scramble', 'good', 0);
INSERT INTO food VALUES (7277358, false, true, false, false, 'triple berry smoothie', 'good', 0);
INSERT INTO food VALUES (7255772, false, true, true, false, 'breakfast potatoes', 'good', 0);
INSERT INTO food VALUES (7255758, false, true, false, false, 'scrambled eggs', 'good', 0);
INSERT INTO food VALUES (7255759, true, true, false, false, 'buttermilk biscuits', 'good', 0);
INSERT INTO food VALUES (7255770, false, true, false, false, 'turkey sausage links', 'good', 0);
INSERT INTO food VALUES (7277361, false, true, false, false, 'red berry peach smoothie', 'good', 0);
INSERT INTO food VALUES (7255747, false, false, false, false, 'double bacon cheeseburger', 'good', 0);
INSERT INTO food VALUES (7232799, true, true, false, false, 'scrambled eggs', 'good', 0);
INSERT INTO food VALUES (7199298, false, true, false, false, 'turkey meatloaf', 'good', 0);
INSERT INTO food VALUES (7232802, false, true, true, false, 'tater tots', 'good', 0);
INSERT INTO food VALUES (7232819, false, true, false, false, 'applewood bacon', 'good', 0);
INSERT INTO food VALUES (5769477, false, true, true, false, 'Iced caffe americano 20 oz', 'good', 0);
INSERT INTO food VALUES (5769476, false, true, true, false, 'iced caffe americano 16 oz', 'good', 0);
INSERT INTO food VALUES (5769473, false, true, true, false, 'iced caffe americano 12 oz', 'good', 0);
INSERT INTO food VALUES (5725286, false, true, true, false, 'flavored iced tea | unsweetened', 'good', 0);
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
INSERT INTO food VALUES (5725125, true, true, false, false, 'caffe misto 20 fl oz', 'good', 0);
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
INSERT INTO food VALUES (5547930, true, true, false, false, 'honey', 'good', 0);
INSERT INTO food VALUES (5737401, true, true, false, false, 'vanilla coffee syrup', 'good', 0);
INSERT INTO food VALUES (7079959, false, true, false, false, 'pepperoni pizza', 'good', 0);
INSERT INTO food VALUES (7254456, false, true, false, false, 'pepperoni pizza', 'good', 1);
INSERT INTO food VALUES (7079978, true, true, false, false, 'grilled cheese', 'good', -1);
INSERT INTO food VALUES (7254545, false, true, true, false, 'house-made bean burger', 'good', 1);
INSERT INTO food VALUES (7257506, false, true, true, false, 'old-fashioned oatmeal', 'good', 1);
INSERT INTO food VALUES (7079973, false, true, true, false, 'house-made bean burger', 'good', -1);
INSERT INTO food VALUES (7254450, true, true, false, false, 'cheese pizza', 'good', -1);
INSERT INTO food VALUES (7079954, true, true, false, false, 'cheese pizza', 'good', -1);
INSERT INTO food VALUES (7255829, true, true, false, false, 'grilled cheese', 'good', 1);
INSERT INTO food VALUES (7232820, false, true, true, false, 'old-fashioned oatmeal', 'good', 1);
INSERT INTO food VALUES (7106029, false, true, false, false, 'chicken parmesan- Gluten free option upon request', 'good', 0);
INSERT INTO food VALUES (7080069, false, true, false, false, 'loaded supreme pizza', 'good', 0);
INSERT INTO food VALUES (7117323, true, true, false, false, 'antipasto salad', 'good', 0);
INSERT INTO food VALUES (7117198, false, true, true, false, 'roasted tofu & vegetable soup', 'good', 0);
INSERT INTO food VALUES (7079969, false, true, false, false, 'Fischer Farms beef burger', 'good', 0);
INSERT INTO food VALUES (7117197, false, true, false, false, 'loaded baked potato soup', 'good', 0);
INSERT INTO food VALUES (7114778, false, true, true, false, 'old-fashioned oatmeal', 'good', 0);
INSERT INTO food VALUES (7106040, false, false, false, false, 'creamy beef stroganoff', 'good', 0);
INSERT INTO food VALUES (7082745, true, false, false, false, 'roasted vegetable flatbread', 'good', 0);
INSERT INTO food VALUES (7119646, false, false, false, false, 'italian beef and pepperjack flatbread', 'good', 0);
INSERT INTO food VALUES (7254551, false, true, false, false, 'grilled all beef hot dog', 'good', -2);
INSERT INTO food VALUES (7079982, false, true, false, false, 'grilled all beef hot dog', 'good', -2);
INSERT INTO food VALUES (7080082, false, true, true, false, 'spinach tofu scramble', 'good', 1);


--
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO menu VALUES (28, 1, '2017-05-16');
INSERT INTO menu VALUES (29, 1, '2017-05-16');
INSERT INTO menu VALUES (30, 1, '2017-05-16');
INSERT INTO menu VALUES (31, 1, '2017-05-16');
INSERT INTO menu VALUES (32, 1, '2017-05-16');
INSERT INTO menu VALUES (33, 1, '2017-05-16');
INSERT INTO menu VALUES (34, 1, '2017-05-16');
INSERT INTO menu VALUES (35, 1, '2017-05-16');
INSERT INTO menu VALUES (36, 1, '2017-05-16');
INSERT INTO menu VALUES (37, 1, '2017-05-16');
INSERT INTO menu VALUES (38, 1, '2017-05-16');
INSERT INTO menu VALUES (39, 1, '2017-05-16');
INSERT INTO menu VALUES (40, 1, '2017-05-16');
INSERT INTO menu VALUES (41, 1, '2017-05-16');
INSERT INTO menu VALUES (42, 1, '2017-05-16');
INSERT INTO menu VALUES (43, 1, '2017-05-16');
INSERT INTO menu VALUES (44, 1, '2017-05-16');
INSERT INTO menu VALUES (45, 1, '2017-05-16');
INSERT INTO menu VALUES (46, 1, '2017-05-16');
INSERT INTO menu VALUES (47, 1, '2017-05-16');
INSERT INTO menu VALUES (48, 1, '2017-05-16');
INSERT INTO menu VALUES (49, 1, '2017-05-16');
INSERT INTO menu VALUES (50, 1, '2017-05-16');
INSERT INTO menu VALUES (51, 1, '2017-05-16');
INSERT INTO menu VALUES (52, 1, '2017-05-16');
INSERT INTO menu VALUES (53, 1, '2017-05-16');
INSERT INTO menu VALUES (54, 1, '2017-05-16');
INSERT INTO menu VALUES (55, 1, '2017-05-16');
INSERT INTO menu VALUES (56, 1, '2017-05-16');
INSERT INTO menu VALUES (57, 1, '2017-05-16');
INSERT INTO menu VALUES (58, 1, '2017-05-16');
INSERT INTO menu VALUES (59, 1, '2017-05-16');
INSERT INTO menu VALUES (60, 1, '2017-05-16');
INSERT INTO menu VALUES (61, 1, '2017-05-16');
INSERT INTO menu VALUES (62, 1, '2017-05-16');
INSERT INTO menu VALUES (63, 1, '2017-05-16');
INSERT INTO menu VALUES (64, 1, '2017-05-16');
INSERT INTO menu VALUES (65, 1, '2017-05-16');
INSERT INTO menu VALUES (66, 1, '2017-05-16');
INSERT INTO menu VALUES (67, 1, '2017-05-16');
INSERT INTO menu VALUES (68, 1, '2017-05-16');
INSERT INTO menu VALUES (69, 1, '2017-05-16');
INSERT INTO menu VALUES (70, 1, '2017-05-16');
INSERT INTO menu VALUES (71, 1, '2017-05-16');
INSERT INTO menu VALUES (72, 1, '2017-05-16');
INSERT INTO menu VALUES (73, 1, '2017-05-16');
INSERT INTO menu VALUES (74, 1, '2017-05-16');
INSERT INTO menu VALUES (75, 1, '2017-05-16');
INSERT INTO menu VALUES (76, 1, '2017-05-16');
INSERT INTO menu VALUES (77, 1, '2017-05-16');
INSERT INTO menu VALUES (78, 1, '2017-05-16');
INSERT INTO menu VALUES (79, 1, '2017-05-16');
INSERT INTO menu VALUES (80, 1, '2017-05-16');
INSERT INTO menu VALUES (81, 1, '2017-05-16');
INSERT INTO menu VALUES (82, 1, '2017-05-16');
INSERT INTO menu VALUES (83, 1, '2017-05-16');
INSERT INTO menu VALUES (84, 1, '2017-05-16');
INSERT INTO menu VALUES (85, 1, '2017-05-16');
INSERT INTO menu VALUES (86, 1, '2017-05-16');
INSERT INTO menu VALUES (87, 1, '2017-05-16');
INSERT INTO menu VALUES (88, 1, '2017-05-16');
INSERT INTO menu VALUES (89, 1, '2017-05-16');
INSERT INTO menu VALUES (90, 1, '2017-05-16');
INSERT INTO menu VALUES (91, 1, '2017-05-16');
INSERT INTO menu VALUES (92, 1, '2017-05-16');
INSERT INTO menu VALUES (93, 1, '2017-05-16');
INSERT INTO menu VALUES (94, 1, '2017-05-16');
INSERT INTO menu VALUES (95, 1, '2017-05-16');
INSERT INTO menu VALUES (96, 1, '2017-05-16');
INSERT INTO menu VALUES (97, 1, '2017-05-16');
INSERT INTO menu VALUES (98, 1, '2017-05-16');
INSERT INTO menu VALUES (99, 1, '2017-05-16');
INSERT INTO menu VALUES (100, 1, '2017-05-16');
INSERT INTO menu VALUES (101, 1, '2017-05-16');
INSERT INTO menu VALUES (102, 1, '2017-05-16');
INSERT INTO menu VALUES (103, 1, '2017-05-16');
INSERT INTO menu VALUES (104, 1, '2017-05-16');
INSERT INTO menu VALUES (105, 1, '2017-05-16');
INSERT INTO menu VALUES (106, 1, '2017-05-16');
INSERT INTO menu VALUES (107, 1, '2017-05-16');
INSERT INTO menu VALUES (108, 1, '2017-05-16');
INSERT INTO menu VALUES (109, 1, '2017-05-16');
INSERT INTO menu VALUES (110, 1, '2017-05-16');
INSERT INTO menu VALUES (111, 1, '2017-05-16');
INSERT INTO menu VALUES (112, 1, '2017-05-16');
INSERT INTO menu VALUES (113, 1, '2017-05-16');
INSERT INTO menu VALUES (114, 1, '2017-05-16');
INSERT INTO menu VALUES (115, 1, '2017-05-16');
INSERT INTO menu VALUES (116, 1, '2017-05-16');
INSERT INTO menu VALUES (117, 1, '2017-05-16');
INSERT INTO menu VALUES (118, 1, '2017-05-16');
INSERT INTO menu VALUES (119, 0, '2017-05-16');
INSERT INTO menu VALUES (120, 0, '2017-05-16');
INSERT INTO menu VALUES (121, 2, '2017-05-16');
INSERT INTO menu VALUES (122, 2, '2017-05-16');
INSERT INTO menu VALUES (123, 2, '2017-05-16');
INSERT INTO menu VALUES (124, 2, '2017-05-16');
INSERT INTO menu VALUES (125, 2, '2017-05-16');
INSERT INTO menu VALUES (126, 2, '2017-05-16');
INSERT INTO menu VALUES (127, 2, '2017-05-16');
INSERT INTO menu VALUES (128, 2, '2017-05-16');
INSERT INTO menu VALUES (129, 2, '2017-05-16');
INSERT INTO menu VALUES (130, 2, '2017-05-16');
INSERT INTO menu VALUES (131, 2, '2017-05-16');
INSERT INTO menu VALUES (132, 1, '2017-05-17');
INSERT INTO menu VALUES (133, 1, '2017-05-17');
INSERT INTO menu VALUES (134, 1, '2017-05-17');
INSERT INTO menu VALUES (135, 1, '2017-05-17');
INSERT INTO menu VALUES (136, 1, '2017-05-17');
INSERT INTO menu VALUES (137, 1, '2017-05-17');
INSERT INTO menu VALUES (138, 1, '2017-05-17');
INSERT INTO menu VALUES (139, 1, '2017-05-17');
INSERT INTO menu VALUES (140, 1, '2017-05-17');
INSERT INTO menu VALUES (141, 1, '2017-05-17');
INSERT INTO menu VALUES (142, 1, '2017-05-17');
INSERT INTO menu VALUES (143, 1, '2017-05-17');
INSERT INTO menu VALUES (144, 1, '2017-05-17');
INSERT INTO menu VALUES (145, 1, '2017-05-17');
INSERT INTO menu VALUES (146, 1, '2017-05-17');
INSERT INTO menu VALUES (147, 1, '2017-05-17');
INSERT INTO menu VALUES (148, 1, '2017-05-17');
INSERT INTO menu VALUES (149, 1, '2017-05-17');
INSERT INTO menu VALUES (150, 1, '2017-05-17');
INSERT INTO menu VALUES (151, 1, '2017-05-17');
INSERT INTO menu VALUES (152, 1, '2017-05-17');
INSERT INTO menu VALUES (153, 1, '2017-05-17');
INSERT INTO menu VALUES (154, 1, '2017-05-17');
INSERT INTO menu VALUES (155, 1, '2017-05-17');
INSERT INTO menu VALUES (156, 1, '2017-05-17');
INSERT INTO menu VALUES (157, 1, '2017-05-17');
INSERT INTO menu VALUES (158, 1, '2017-05-17');
INSERT INTO menu VALUES (159, 1, '2017-05-17');
INSERT INTO menu VALUES (160, 1, '2017-05-17');
INSERT INTO menu VALUES (161, 1, '2017-05-17');
INSERT INTO menu VALUES (162, 1, '2017-05-17');
INSERT INTO menu VALUES (163, 1, '2017-05-17');
INSERT INTO menu VALUES (164, 1, '2017-05-17');
INSERT INTO menu VALUES (165, 1, '2017-05-17');
INSERT INTO menu VALUES (166, 1, '2017-05-17');
INSERT INTO menu VALUES (167, 1, '2017-05-17');
INSERT INTO menu VALUES (168, 1, '2017-05-17');
INSERT INTO menu VALUES (169, 1, '2017-05-17');
INSERT INTO menu VALUES (170, 1, '2017-05-17');
INSERT INTO menu VALUES (171, 1, '2017-05-17');
INSERT INTO menu VALUES (172, 1, '2017-05-17');
INSERT INTO menu VALUES (173, 1, '2017-05-17');
INSERT INTO menu VALUES (174, 1, '2017-05-17');
INSERT INTO menu VALUES (175, 1, '2017-05-17');
INSERT INTO menu VALUES (176, 1, '2017-05-17');
INSERT INTO menu VALUES (177, 1, '2017-05-17');
INSERT INTO menu VALUES (178, 1, '2017-05-17');
INSERT INTO menu VALUES (179, 1, '2017-05-17');
INSERT INTO menu VALUES (180, 1, '2017-05-17');
INSERT INTO menu VALUES (181, 1, '2017-05-17');
INSERT INTO menu VALUES (182, 1, '2017-05-17');
INSERT INTO menu VALUES (183, 1, '2017-05-17');
INSERT INTO menu VALUES (184, 1, '2017-05-17');
INSERT INTO menu VALUES (185, 1, '2017-05-17');
INSERT INTO menu VALUES (186, 1, '2017-05-17');
INSERT INTO menu VALUES (187, 1, '2017-05-17');
INSERT INTO menu VALUES (188, 1, '2017-05-17');
INSERT INTO menu VALUES (189, 1, '2017-05-17');
INSERT INTO menu VALUES (190, 1, '2017-05-17');
INSERT INTO menu VALUES (191, 1, '2017-05-17');
INSERT INTO menu VALUES (192, 1, '2017-05-17');
INSERT INTO menu VALUES (193, 1, '2017-05-17');
INSERT INTO menu VALUES (194, 1, '2017-05-17');
INSERT INTO menu VALUES (195, 1, '2017-05-17');
INSERT INTO menu VALUES (196, 1, '2017-05-17');
INSERT INTO menu VALUES (197, 1, '2017-05-17');
INSERT INTO menu VALUES (198, 1, '2017-05-17');
INSERT INTO menu VALUES (199, 1, '2017-05-17');
INSERT INTO menu VALUES (200, 1, '2017-05-17');
INSERT INTO menu VALUES (201, 1, '2017-05-17');
INSERT INTO menu VALUES (202, 1, '2017-05-17');
INSERT INTO menu VALUES (203, 1, '2017-05-17');
INSERT INTO menu VALUES (204, 1, '2017-05-17');
INSERT INTO menu VALUES (205, 1, '2017-05-17');
INSERT INTO menu VALUES (206, 1, '2017-05-17');
INSERT INTO menu VALUES (207, 1, '2017-05-17');
INSERT INTO menu VALUES (208, 1, '2017-05-17');
INSERT INTO menu VALUES (209, 1, '2017-05-17');
INSERT INTO menu VALUES (210, 1, '2017-05-17');
INSERT INTO menu VALUES (211, 1, '2017-05-17');
INSERT INTO menu VALUES (212, 1, '2017-05-17');
INSERT INTO menu VALUES (213, 1, '2017-05-17');
INSERT INTO menu VALUES (214, 1, '2017-05-17');
INSERT INTO menu VALUES (215, 1, '2017-05-17');
INSERT INTO menu VALUES (216, 1, '2017-05-17');
INSERT INTO menu VALUES (217, 1, '2017-05-17');
INSERT INTO menu VALUES (218, 1, '2017-05-17');
INSERT INTO menu VALUES (219, 1, '2017-05-17');
INSERT INTO menu VALUES (220, 1, '2017-05-17');
INSERT INTO menu VALUES (221, 1, '2017-05-17');
INSERT INTO menu VALUES (222, 1, '2017-05-17');
INSERT INTO menu VALUES (223, 0, '2017-05-17');
INSERT INTO menu VALUES (224, 0, '2017-05-17');
INSERT INTO menu VALUES (225, 2, '2017-05-17');
INSERT INTO menu VALUES (226, 2, '2017-05-17');
INSERT INTO menu VALUES (227, 2, '2017-05-17');
INSERT INTO menu VALUES (228, 2, '2017-05-17');
INSERT INTO menu VALUES (229, 2, '2017-05-17');
INSERT INTO menu VALUES (230, 2, '2017-05-17');
INSERT INTO menu VALUES (231, 2, '2017-05-17');
INSERT INTO menu VALUES (232, 2, '2017-05-17');
INSERT INTO menu VALUES (233, 2, '2017-05-17');
INSERT INTO menu VALUES (234, 2, '2017-05-17');
INSERT INTO menu VALUES (235, 2, '2017-05-17');


--
-- Name: menu_menuid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('menu_menuid_seq', 235, true);


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO rating VALUES (7255829, 1, NULL, 'lancedinh7', 1495006997);
INSERT INTO rating VALUES (5547887, 1, NULL, 'lancedinh7', 1494998176);
INSERT INTO rating VALUES (7254456, 1, NULL, 'lancedinh7', 1495005580);
INSERT INTO rating VALUES (7079978, -1, NULL, 'lancedinh7', 1495007030);
INSERT INTO rating VALUES (7254551, -1, 'dsadsa', 'lancedinh7', 1494999302);
INSERT INTO rating VALUES (7079982, -1, 'dasdsa', 'lancedinh7', 1495005996);
INSERT INTO rating VALUES (7079973, -1, NULL, 'lancedinh7', 1495007039);
INSERT INTO rating VALUES (7254450, -1, NULL, 'lancedinh7', 1494999418);
INSERT INTO rating VALUES (7079954, -1, NULL, 'lancedinh7', 1495007048);
INSERT INTO rating VALUES (7254545, 1, NULL, 'lancedinh7', 1494999414);
INSERT INTO rating VALUES (7079982, -1, NULL, 'newUser', 1495007851);
INSERT INTO rating VALUES (7254551, -1, 'Y no work', 'newUser', 1495006385);
INSERT INTO rating VALUES (7232820, 1, NULL, 'lancedinh7', 1495008655);
INSERT INTO rating VALUES (7257506, 1, 'nice foods', 'lancedinh7', 1495008654);
INSERT INTO rating VALUES (7080082, 1, NULL, 'lancedinh7', 1495008652);


--
-- Data for Name: serves; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: servinglocation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: worksat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO worksat VALUES (12345678, 'Union Cafe');
INSERT INTO worksat VALUES (11223344, 'Moench Cafe');


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
-- Name: contains contains_foodid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_foodid_fkey FOREIGN KEY (foodid) REFERENCES food(foodid);


--
-- Name: contains contains_menuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_menuid_fkey FOREIGN KEY (menuid) REFERENCES menu(menuid);


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
-- Name: contains lnk_food_contains; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT lnk_food_contains FOREIGN KEY (foodid) REFERENCES food(foodid) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rating rating_foodid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_foodid_fkey FOREIGN KEY (foodid) REFERENCES food(foodid);


--
-- Name: serves serves_menuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY serves
    ADD CONSTRAINT serves_menuid_fkey FOREIGN KEY (menuid) REFERENCES menu(menuid);


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

