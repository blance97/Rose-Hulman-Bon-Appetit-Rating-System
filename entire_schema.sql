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
    password character varying(32) NOT NULL,
    fname character varying(20) NOT NULL,
    lname character varying(20) NOT NULL,
    sessiontoken text,
    CONSTRAINT "Check password length" CHECK ((char_length((password)::text) >= 8))
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

COPY cafe (cafename, location, hours) FROM stdin;
Faculty Dining Room	Union	CLOSED
C-Store	Apartments	GRAB 'N' GOSERVED FROM 2:00 PM - 9:00 PM
Logans	Library	GRAB 'N' GO SERVED FROM 10:00 AM - 11:00 PM
Moench Cafe	Moench	GRAB 'N' GO SERVED FROM 7:45 AM - 3:00 PM
Union Cafe	Union	BREAKFAST 7:00 AM - 10:00 AM<br>\nLUNCH 10:45 AM - 2:00 PM<br>\nDINNER 5:00 PM - 8:00 PM<br>\nLATE NIGHT 9:00 PM - 11:00 PM<br>
Subway	Apartments	LUNCH 10:45 AM - 5:00 PM<br>\nDINNER 5:00 PM - 11:00 PM
\.


--
-- Data for Name: contains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY contains (menuid, foodid) FROM stdin;
344	7170680
344	7170681
344	7170684
344	7170678
344	7170677
345	7106047
345	7106052
345	7106058
345	7100302
345	7170705
345	7170704
345	7100298
345	7100292
345	7106063
345	7134716
346	7164957
346	7106052
346	7100302
346	7170705
346	7170704
346	7100298
346	7100292
346	7106068
345	5769477
345	5769476
345	5769473
345	5725286
345	5725125
345	5725124
345	5547941
345	5547940
345	5547943
345	5547942
345	5547945
345	5547944
345	5547947
345	5547946
345	5547948
345	5547897
345	5547896
345	5547895
345	5547894
345	5547893
345	5547892
345	5547891
345	5547890
345	5725123
345	5547950
345	5547951
345	5601542
345	5769456
345	5769459
345	5737771
345	5547929
345	5547887
345	5547923
345	5547921
345	5547920
345	5547888
345	5547889
345	5547925
345	5547924
345	5737149
345	5601530
345	5769448
345	5769447
345	5769444
345	5547938
345	5547939
345	5547930
345	5547931
345	5547932
345	5547933
345	5547934
345	5547935
345	5547936
345	5547937
345	5737759
345	5601524
345	5601525
345	5601526
345	5601527
345	5769432
345	5547905
345	5547904
345	5547907
345	5547906
345	5547903
345	5547909
345	5547908
345	5769428
345	5769421
345	5547912
345	5547913
345	5547910
345	5547911
345	5547916
345	5547917
345	5547914
345	5547915
345	5547918
345	5547919
345	5737401
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customer (username, email, password, favorite, sessiontoken) FROM stdin;
newUser	test@gmail.com	asdasd	\N	dfa50bbe-100b-41df-aecf-a64a91fc6834
lancedinh7	lancedinh7@gmail.com	asdasd	\N	bcb3f7a7-ebd9-4d28-b031-879f0b48d795
username	username@username.com	password	\N	5356a558-7034-45a4-8322-898da106807d
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY employee (employeeid, password, fname, lname, sessiontoken) FROM stdin;
11223344	password	Lance	Dinh	\N
12345678	password	Maya	Holeman	7ebd1ac0-41cc-4880-a800-cd41da282996
\.


--
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY food (foodid, vegetarian, vegan, glutenfree, kosher, foodname, description, rating) FROM stdin;
7279200	f	t	t	f	spring salad with shallot and herb vinaigrette	good	0
7279189	f	t	f	f	white bean and ham soup	good	0
7279188	t	t	f	f	sweet potato bisque	good	0
7254461	f	t	f	f	loaded veggie pizza	good	0
7254540	f	t	f	f	Fischer Farms beef burger	good	0
7265247	f	t	f	f	roasted chicken with sweet onion mustard glaze	good	0
7256159	f	t	f	f	shrimp scampi pasta with tomatoes and parsley	good	0
7282611	f	t	f	f	grilled club sandwich with onion rings	good	0
7279187	f	t	t	f	vegan tofu and spinach scramble	good	0
7277358	f	t	f	f	triple berry smoothie	good	0
7255772	f	t	t	f	breakfast potatoes	good	0
7255758	f	t	f	f	scrambled eggs	good	0
7255759	t	t	f	f	buttermilk biscuits	good	0
7255770	f	t	f	f	turkey sausage links	good	0
7277361	f	t	f	f	red berry peach smoothie	good	0
7255747	f	f	f	f	double bacon cheeseburger	good	0
7232799	t	t	f	f	scrambled eggs	good	0
7199298	f	t	f	f	turkey meatloaf	good	0
7232802	f	t	t	f	tater tots	good	0
7232819	f	t	f	f	applewood bacon	good	0
5769477	f	t	t	f	Iced caffe americano 20 oz	good	0
5769476	f	t	t	f	iced caffe americano 16 oz	good	0
5769473	f	t	t	f	iced caffe americano 12 oz	good	0
5725286	f	t	t	f	flavored iced tea | unsweetened	good	0
5725124	t	t	f	f	caffe misto 16 fl oz	good	0
5547941	t	t	f	f	coconut coffee syrup	good	0
5547940	t	t	f	f	cinnamon coffee syrup	good	0
5547943	t	t	f	f	hazelnut coffee syrup	good	0
5547942	t	t	f	f	dark chocolate coffee syrup	good	0
5547945	t	t	f	f	peppermint coffee syrup	good	0
5547944	t	t	f	f	Irish creme coffee syrup	good	0
5547947	t	t	f	f	strawberry coffee syrup	good	0
5547946	t	t	f	f	raspberry coffee syrup	good	0
5547948	t	t	f	f	toffee nut coffee syrup	good	0
5547897	t	t	f	f	iced caramel macchiato 20 fl oz	good	0
5547896	t	t	f	f	iced caramel macchiato 16 fl oz	good	0
5547895	t	t	f	f	iced caramel macchiato 12 fl oz	good	0
5547894	t	t	f	f	caramel macchiato 20 fl oz	good	0
5547893	t	t	f	f	caramel macchiato 16 fl oz	good	0
5547892	t	t	f	f	caramel macchiato 12 fl oz	good	0
5547891	f	t	t	f	iced coffee	good	0
5547890	t	t	f	f	caffe Americano	good	0
5725123	t	t	f	f	caffe misto 12 fl oz	good	0
5547950	t	t	f	f	vanilla sugar free coffee syrup	good	0
5547951	t	t	f	f	white chocolate coffee syrup	good	0
5725125	t	t	f	f	caffe misto 20 fl oz	good	0
5601542	f	t	t	f	espresso dupio	good	0
5769456	t	t	f	f	espresso con panna solo	good	0
5769459	t	t	f	f	espresso con panna dupio	good	0
5737771	t	t	f	f	iced caffe mocha 2% milk 12 fl oz	good	0
5547929	t	t	f	f	granulated sugar	good	0
5547887	f	t	t	f	iced tea | unsweetened	good	0
5547923	t	t	f	f	hot chocolate 12 fl oz	good	0
5547921	t	t	f	f	espresso macchiato single 2%	good	0
5547920	t	t	f	f	white chocolate mocha 2% milk 20 fl oz	good	0
5547888	f	t	t	f	black coffee	good	0
5547889	f	t	t	f	espresso solo	good	0
5547925	t	t	f	f	hot chocolate 20 fl oz	good	0
5547924	t	t	f	f	hot chocolate 16 fl oz	good	0
5737149	t	t	f	f	lemonade	good	0
5601530	f	t	t	f	hot tea	good	0
5769448	t	t	f	f	vanilla steamer 20 oz	good	0
5769447	t	t	f	f	vanilla steamer 16 oz	good	0
5769444	t	t	f	f	vanilla steamer 12 oz	good	0
5547938	t	t	f	f	caramel coffee syrup	good	0
5547939	t	t	f	f	caramel sugar free coffee syrup	good	0
5547931	f	t	t	f	agave nectar	good	0
5547932	f	t	t	f	Splenda	good	0
5547933	t	t	f	f	2% milk	good	0
5547934	t	t	f	f	skim milk	good	0
5547935	t	t	f	f	half & half	good	0
5547936	t	t	f	f	almond milk	good	0
5547937	t	t	f	f	soy milk	good	0
5737759	t	t	f	f	iced white chocolate mocha 12 fl oz	good	0
5601524	f	t	f	f	iced caffe latte 2% milk 12 fl oz	good	0
5601525	t	t	f	f	iced caffe mocha 2% milk 16 fl oz	good	0
5601526	t	t	f	f	iced white chocolate mocha 2% milk 16 fl oz	good	0
5601527	t	t	f	f	espresso macchiato double 2%	good	0
5769432	t	t	f	f	white hot chocolate 20 oz	good	0
5547905	t	t	f	f	caffe latte 2% milk 20 fl oz	good	0
5547904	t	t	f	f	caffe latte 2% milk 16 fl oz	good	0
5547907	t	t	f	f	caffe mocha 2% milk 16 fl oz	good	0
5547906	t	t	f	f	caffe mocha 2% milk 12 fl oz	good	0
5547903	t	t	f	f	caffe latte 2% milk 12 fl oz	good	0
5547909	t	t	f	f	cappuccino 2% milk 12 fl oz	good	0
5547908	t	t	f	f	caffe mocha 2% milk 20 fl oz	good	0
5769428	t	t	f	f	white hot chocolate 16 oz	good	0
5769421	t	t	f	f	white hot chocolate 12 oz	good	0
5547912	f	t	f	f	iced caffe latte 2% milk 16 fl oz	good	0
5547913	t	t	f	f	iced caffe latte 2% milk 20 fl oz	good	0
5547910	t	t	f	f	cappuccino 2% milk 16 fl oz	good	0
5547911	t	t	f	f	cappuccino 2% milk 20 fl oz	good	0
5547916	t	t	f	f	iced white chocolate mocha 2% milk 16 fl oz	good	0
5547917	t	t	f	f	iced white chocolate mocha 2% milk 20 fl oz	good	0
5547914	t	t	f	f	iced caffe mocha 2% milk 16 fl oz	good	0
5547915	t	t	f	f	iced caffe mocha 2% milk 20fl oz	good	0
5547918	t	t	f	f	white chocolate mocha 2% milk 12 fl oz	good	0
5547919	t	t	f	f	white chocolate mocha 2% milk 16 fl oz	good	0
5547930	t	t	f	f	honey	good	0
5737401	t	t	f	f	vanilla coffee syrup	good	0
7079959	f	t	f	f	pepperoni pizza	good	0
7254456	f	t	f	f	pepperoni pizza	good	1
7079978	t	t	f	f	grilled cheese	good	-1
7254545	f	t	t	f	house-made bean burger	good	1
7257506	f	t	t	f	old-fashioned oatmeal	good	1
7079973	f	t	t	f	house-made bean burger	good	-1
7254450	t	t	f	f	cheese pizza	good	-1
7079954	t	t	f	f	cheese pizza	good	-1
7255829	t	t	f	f	grilled cheese	good	1
7232820	f	t	t	f	old-fashioned oatmeal	good	1
7106029	f	t	f	f	chicken parmesan- Gluten free option upon request	good	0
7080069	f	t	f	f	loaded supreme pizza	good	0
7117323	t	t	f	f	antipasto salad	good	0
7117198	f	t	t	f	roasted tofu & vegetable soup	good	0
7079969	f	t	f	f	Fischer Farms beef burger	good	0
7117197	f	t	f	f	loaded baked potato soup	good	0
7114778	f	t	t	f	old-fashioned oatmeal	good	0
7106040	f	f	f	f	creamy beef stroganoff	good	0
7082745	t	f	f	f	roasted vegetable flatbread	good	0
7119646	f	f	f	f	italian beef and pepperjack flatbread	good	0
7254551	f	t	f	f	grilled all beef hot dog	good	-2
7079982	f	t	f	f	grilled all beef hot dog	good	-2
7080082	f	t	t	f	spinach tofu scramble	good	1
7294601	f	t	f	f	strawberry smoothie	good	0
7294602	f	t	f	f	raspberry vanilla	good	0
7257509	f	t	t	f	old-fashioned oatmeal	good	0
7292939	f	t	f	f	crispy chicken tenders	good	0
7292942	f	t	f	f	mahogany roast pork, ginger glaze	good	0
7170680	f	t	f	f	applewood bacon	good	0
7170681	f	t	f	f	breakfast potato's	good	0
7170684	f	t	f	f	banana coconut smoothie	good	0
7170678	f	t	t	f	vegan tofu spinach scramble	good	0
7170677	f	t	t	f	buttermilk biscuits	good	0
7106047	f	t	f	f	Fischer Farms beef burger	good	0
7106052	f	t	t	f	house-made bean burger	good	0
7106058	f	t	f	f	grilled all beef hot dog	good	0
7100302	f	t	f	f	breakfast pizza	good	0
7170705	t	t	f	f	cream of cauliflower soup	good	0
7170704	f	t	f	f	ham and bean soup with sun dried tomato	good	0
7100298	f	t	f	f	chicken bacon pizza	good	0
7100292	t	t	f	f	cheese pizza	good	0
7106063	t	t	f	f	grilled cheese	good	0
7134716	f	t	f	f	herb turkey meatballs	good	0
7164957	f	t	f	f	baked potato bar	good	0
7106068	f	f	f	f	crispy chicken tenders	good	0
\.


--
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY menu (menuid, meal, date) FROM stdin;
344	0	2017-05-19
345	1	2017-05-19
346	2	2017-05-19
\.


--
-- Name: menu_menuid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('menu_menuid_seq', 346, true);


--
-- Data for Name: menuexists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY menuexists (count) FROM stdin;
8
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rating (foodid, rating, comment, username, "time") FROM stdin;
7255829	1	\N	lancedinh7	1495006997
5547887	1	\N	lancedinh7	1494998176
7254456	1	\N	lancedinh7	1495005580
7079978	-1	\N	lancedinh7	1495007030
7254551	-1	dsadsa	lancedinh7	1494999302
7079982	-1	dasdsa	lancedinh7	1495005996
7079973	-1	\N	lancedinh7	1495007039
7254450	-1	\N	lancedinh7	1494999418
7079954	-1	\N	lancedinh7	1495007048
7254545	1	\N	lancedinh7	1494999414
7079982	-1	\N	newUser	1495007851
7254551	-1	Y no work	newUser	1495006385
7232820	1	\N	lancedinh7	1495008655
7257506	1	nice foods	lancedinh7	1495008654
7080082	1	\N	lancedinh7	1495008652
\.


--
-- Data for Name: serves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY serves (servingname, menuid) FROM stdin;
\.


--
-- Data for Name: servinglocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY servinglocation (servingname, cafename) FROM stdin;
\.


--
-- Data for Name: worksat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY worksat (employeeid, cafename) FROM stdin;
12345678	Union Cafe
11223344	Union Cafe
\.


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

