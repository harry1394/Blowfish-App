--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment (
    comment_id smallint NOT NULL,
    post_id smallint NOT NULL,
    comment_message character varying(140),
    comment_time timestamp without time zone DEFAULT now(),
    user_id character varying(12)
);


ALTER TABLE comment OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comment_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_comment_id_seq OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comment_comment_id_seq OWNED BY comment.comment_id;


--
-- Name: comment_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comment_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_post_id_seq OWNER TO postgres;

--
-- Name: comment_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comment_post_id_seq OWNED BY comment.post_id;


--
-- Name: device; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device (
    device_id smallint DEFAULT nextval(('public.device_device_id_seq'::text)::regclass) NOT NULL,
    device_sn character varying(25) NOT NULL
);


ALTER TABLE device OWNER TO postgres;

--
-- Name: device_device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE device_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE device_device_id_seq OWNER TO postgres;

--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE location (
    location_id smallint NOT NULL,
    location_desc character varying(88),
    latitude numeric(9,6),
    longitude numeric(9,6)
);


ALTER TABLE location OWNER TO postgres;

--
-- Name: location_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE location_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE location_location_id_seq OWNER TO postgres;

--
-- Name: location_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE location_location_id_seq OWNED BY location.location_id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE media (
    media_id smallint DEFAULT nextval(('public.media_media_id_seq'::text)::regclass) NOT NULL,
    media_type character varying(16),
    media_filename character varying(1024) NOT NULL
);


ALTER TABLE media OWNER TO postgres;

--
-- Name: media_media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE media_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE media_media_id_seq OWNER TO postgres;

--
-- Name: post; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post (
    post_id smallint DEFAULT nextval(('public.post_post_id_seq'::text)::regclass) NOT NULL,
    media_id smallint NOT NULL,
    post_time time(6) without time zone,
    post_like integer DEFAULT 0 NOT NULL,
    location_id integer,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    user_id character varying(12)
);


ALTER TABLE post OWNER TO postgres;

--
-- Name: post_device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE post_device_id_seq OWNER TO postgres;

--
-- Name: post_like; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post_like (
    like_id bigint NOT NULL,
    device_id bigint NOT NULL,
    post_id bigint NOT NULL,
    valure integer DEFAULT 0
);


ALTER TABLE post_like OWNER TO postgres;

--
-- Name: post_like_device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_like_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_like_device_id_seq OWNER TO postgres;

--
-- Name: post_like_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE post_like_device_id_seq OWNED BY post_like.device_id;


--
-- Name: post_like_like_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_like_like_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_like_like_id_seq OWNER TO postgres;

--
-- Name: post_like_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE post_like_like_id_seq OWNED BY post_like.like_id;


--
-- Name: post_like_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_like_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_like_post_id_seq OWNER TO postgres;

--
-- Name: post_like_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE post_like_post_id_seq OWNED BY post_like.post_id;


--
-- Name: post_media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE post_media_id_seq OWNER TO postgres;

--
-- Name: post_media_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_media_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_media_id_seq1 OWNER TO postgres;

--
-- Name: post_media_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE post_media_id_seq1 OWNED BY post.media_id;


--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE post_post_id_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    user_id character varying(12) NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW view AS
 SELECT ((now() - p."timestamp") / (p.post_like)::double precision) AS post_rating
   FROM post p;


ALTER TABLE view OWNER TO postgres;

--
-- Name: comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment ALTER COLUMN comment_id SET DEFAULT nextval('comment_comment_id_seq'::regclass);


--
-- Name: post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment ALTER COLUMN post_id SET DEFAULT nextval('comment_post_id_seq'::regclass);


--
-- Name: location_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location ALTER COLUMN location_id SET DEFAULT nextval('location_location_id_seq'::regclass);


--
-- Name: media_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post ALTER COLUMN media_id SET DEFAULT nextval('post_media_id_seq1'::regclass);


--
-- Name: like_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_like ALTER COLUMN like_id SET DEFAULT nextval('post_like_like_id_seq'::regclass);


--
-- Name: device_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_like ALTER COLUMN device_id SET DEFAULT nextval('post_like_device_id_seq'::regclass);


--
-- Name: post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_like ALTER COLUMN post_id SET DEFAULT nextval('post_like_post_id_seq'::regclass);


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comment (comment_id, post_id, comment_message, comment_time, user_id) FROM stdin;
12	37	This senior design project is lit!!	1970-01-17 16:33:13.976	\N
13	37	Harry was here	\N	\N
14	45	{"text":"Test"}	2016-04-11 00:06:31.597	\N
15	45	{"text":"Test"}	2016-04-11 00:07:15.289	\N
16	45	{"text":"Testing"}	2016-04-11 00:16:25.009	\N
17	45	Please no brackets	2016-04-11 01:51:05.567	\N
18	45	Commenting test	2016-04-11 02:14:38.248	\N
19	45	Heybgirl	2016-04-11 02:46:52.495	\N
20	71	Man those guys are cool	2016-04-11 04:25:14.359	\N
21	73	Wow what a face	2016-04-11 21:45:02.608	\N
30	39	Testing Cody	2016-04-11 22:19:58.817	\N
32	75	Test cody	2016-04-11 22:29:30	\N
33	75	Test 2	2016-04-11 22:29:47.919	\N
34	77	Professors are awesome	2016-04-11 23:02:26.396	\N
35	76	This guy	2016-04-11 23:12:21.906	\N
36	77	This is pretty cool	2016-04-12 01:47:13.267	\N
37	82	Keynote @ 9:25 with Chamberlain!	2016-04-12 13:27:54.03	\N
38	79	Here we go IT Expo	2016-04-12 13:28:23.683	\N
39	82	Looking forward to it!	2016-04-12 13:29:22.409	\N
40	89	Free donuts!!	2016-04-12 13:54:09.875	\N
41	89	Looks good!	2016-04-12 13:58:09.732	\N
42	90	Time for IT Tech Expo!!	2016-04-12 13:59:18.857	\N
43	88	Is your Bluetooth secure?	2016-04-12 14:00:02.975	\N
44	91	Oh yea	2016-04-12 14:02:40.855	\N
45	91	Come see our booth	2016-04-12 14:56:39.634	\N
46	92	Who's this guy?	2016-04-12 14:57:22.568	\N
47	95	The bearcat made it!!!	2016-04-12 15:32:09.537	\N
48	96	Judges!!!	2016-04-12 16:16:40.107	\N
49	96	Cool	2016-04-12 16:56:51.35	\N
50	95	Cool	2016-04-12 17:16:45.11	\N
51	82	Look at this	2016-04-13 05:08:44.703	\N
52	96	We didn't win	2016-04-14 15:09:00.723	\N
53	89	Comment	2016-04-20 19:00:03.643	\N
\.


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comment_comment_id_seq', 53, true);


--
-- Name: comment_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comment_post_id_seq', 1, false);


--
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY device (device_id, device_sn) FROM stdin;
4	F4JQLHXUGRY7
5	AAA111BBB222
6	AAA222BBB333
7	AAA333BBB444
8	AAA444BBB555
9	AAA555BBB667
10	AAA667BBB777
11	AAA777BBB888
12	AAA888BBB999
13	AAA999BBB000
14	BBB111CCC222
15	BBB222CCC333
16	BBB333CCC444
17	BBB444CCC555
18	BBB555CCC667
19	BBB667CCC777
20	BBB777CCC888
21	BBB888CCC999
22	BBB999CCC000
23	CCC111DDD222
24	CCC222DD333
27	TEST
28	TEST
32	{"TEST"}
33	{"TEST"}
34	{"TEST"}
35	{"TEST"}
36	{"DEEZNUTZ"}
37	{"DEEZNUTZ"}
39	{"HARRY"}
40	{"HARRYK"}
41	{"HARRYLK"}
42	{"HARRYLK"}
44	PHONE
45	PHONE
46	PHONE1
47	PHONE1
48	PHONE2
49	PHONE2
50	CODYSP
51	CODYSP
52	UPICDEVICE
53	UPICDEVICE
55	asdasdasd
56	ykykuyku
57	123456789011
58	123456789011
59	123456789011
60	123456789011
61	123456789011
62	123456789011
63	123456789012
64	123456789011
66	123456789011
67	123456789011
68	123456789011
71	123456789014
72	123456789014
73	123456789014
74	123456789014
75	123456789014
76	123456789014
77	123456789014
78	123456789014
79	123456789015
80	123456789015
81	123456789015
82	123456789015
83	123456789015
84	123456789015
85	123456789015
86	123456789015
87	123456789015
88	123456789015
89	123456789015
90	123456789015
91	123456789010
92	123456789018
93	123456789019
94	123456789033
95	123456789034
96	123456789035
97	12345678998
98	12345678100
99	26328d89af9a9a83
103	TESTINFO1
104	TESTINFO2
105	00987654321
106	15987728678b3237
120	3c39b5f8f2c9eb3d
\.


--
-- Name: device_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('device_device_id_seq', 120, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY location (location_id, location_desc, latitude, longitude) FROM stdin;
5	University of Cincinnati, UC MainStreet	39.132136	-84.516850
6	Xavier University	39.148784	-84.474047
\.


--
-- Name: location_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('location_location_id_seq', 6, true);


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY media (media_id, media_type, media_filename) FROM stdin;
136	image/jpeg	http://10.126.66.246:8080/media-1459729749090.jpg
203	image/jpeg	http://10.126.66.246:8080/media-1459741757338.JPG
139	image/jpeg	http://10.126.66.246:8080/media-1459730442553.jpg
205	image/jpeg	http://10.126.66.246:8080/media-1459741966112.JPG
142	image/jpeg	http://10.126.66.246:8080/media-1459732309592.jpg
207	image/jpeg	http://10.126.66.246:8080/media-1459742155225.JPG
208	image/jpeg	http://10.126.66.246:8080/media-1459742225426.JPG
145	image/jpeg	http://10.126.66.246:8080/media-1459732328108.jpg
209	image/jpeg	http://10.126.66.246:8080/media-1459742254813.JPG
210	image/jpeg	http://10.126.66.246:8080/media-1459801276836.jpg
148	image/jpeg	http://10.126.66.246:8080/media-1459732392543.jpg
211	image/jpeg	http://10.126.66.246:8080/media-1459801439221.jpg
212	image/jpeg	http://10.126.66.246:8080/media-1459801515898.jpg
151	image/jpeg	http://10.126.66.246:8080/media-1459732606203.jpg
213	image/jpeg	http://10.126.66.246:8080/media-1459801697083.jpg
214	image/jpeg	http://10.126.66.246:8080/media-1459802573922.jpg
154	image/jpeg	http://10.126.66.246:8080/media-1459734182443.jpg
215	image/jpeg	http://10.126.66.246:8080/media-1459802858737.jpg
216	image/jpeg	http://10.126.66.246:8080/media-1459803082223.jpg
157	image/jpeg	http://10.126.66.246:8080/media-1459734252456.jpg
217	image/jpeg	http://10.126.66.246:8080/media-1459803165107.jpg
218	image/jpeg	http://10.126.66.246:8080/media-1459803189191.jpg
160	image/jpeg	http://10.126.66.246:8080/media-1459735942579.jpg
219	image/jpeg	http://10.126.66.246:8080/media-1459806086985.jpg
220	image/jpeg	http://10.126.66.246:8080/media-1459808130679.jpg
163	image/jpeg	http://10.126.66.246:8080/media-1459736202000.JPG
221	image/jpeg	http://10.126.66.246:8080/media-1460321142116.jpg
222	image/jpeg	http://10.126.66.246:8080/media-1460321535653.jpg
223	image/jpeg	http://10.126.66.246:8080/media-1460321657613.jpg
167	image/jpeg	http://10.126.66.246:8080/media-1459737048826.jpg
224	image/jpeg	http://10.126.66.246:8080/media-1460322201180.jpg
225	image/jpeg	http://10.126.66.246:8080/media-1460323098347.jpg
170	image/jpeg	http://10.126.66.246:8080/media-1459737151018.jpg
226	image/jpeg	http://10.126.66.246:8080/media-1460323404703.jpg
172	image/jpeg	http://10.126.66.246:8080/media-1459737171543.jpg
227	image/jpeg	http://10.126.66.246:8080/media-1460323441148.jpg
228	image/jpeg	http://10.126.66.246:8080/media-1460323550184.jpg
175	image/jpeg	http://10.126.66.246:8080/media-1459737328554.jpg
229	image/jpeg	http://10.126.66.246:8080/media-1460324416856.jpg
230	image/jpeg	http://10.126.66.246:8080/media-1460325502428.jpg
178	image/jpeg	http://10.126.66.246:8080/media-1459737462225.JPG
231	image/jpeg	http://10.126.66.246:8080/media-1460325769858.jpg
180	image/jpeg	http://10.126.66.246:8080/media-1459737780299.JPG
232	image/jpeg	http://10.126.66.246:8080/media-1460325883837.jpg
182	image/jpeg	http://10.126.66.246:8080/media-1459738675895.JPG
233	image/jpeg	http://10.126.66.246:8080/media-1460326377385.jpg
184	image/jpeg	http://10.126.66.246:8080/media-1459739611286.JPG
234	image/jpeg	http://10.126.66.246:8080/media-1460326518403.jpg
186	image/jpeg	http://10.126.66.246:8080/media-1459739754244.JPG
235	image/jpeg	http://10.126.66.246:8080/media-1460326733307.jpg
188	image/jpeg	http://10.126.66.246:8080/media-1459740141944.JPG
236	image/jpeg	http://10.126.66.246:8080/media-1460326894072.jpg
190	image/jpeg	http://10.126.66.246:8080/media-1459740352390.JPG
237	image/jpeg	http://10.126.66.246:8080/media-1460327051928.jpg
192	image/jpeg	http://10.126.66.246:8080/media-1459740419630.JPG
238	image/jpeg	http://10.126.66.246:8080/media-1460327268170.jpg
239	image/jpeg	http://10.126.66.246:8080/media-1460327327155.jpg
195	image/jpeg	http://10.126.66.246:8080/media-1459741393839.JPG
240	image/jpeg	http://10.126.66.246:8080/media-1460327463079.jpg
197	image/jpeg	http://10.126.66.246:8080/media-1459741524319.JPG
241	image/jpeg	http://10.126.66.246:8080/media-1460327831482.jpg
199	image/jpeg	http://10.126.66.246:8080/media-1459741547417.JPG
242	image/jpeg	http://10.126.66.246:8080/media-1460340389565.jpg
201	image/jpeg	http://10.126.66.246:8080/media-1459741644820.JPG
243	image/jpeg	http://10.126.66.246:8080/media-1460340463463.jpg
244	image/jpeg	http://10.126.66.246:8080/media-1460341615069.jpg
245	image/jpeg	http://10.126.66.246:8080/media-1460341873816.jpg
246	image/jpeg	http://10.126.66.246:8080/media-1460341899013.jpg
247	image/jpeg	http://10.126.66.246:8080/media-1460342007332.jpg
248	image/jpeg	http://10.126.66.246:8080/media-1460342118454.jpg
249	image/jpeg	http://10.126.66.246:8080/media-1460342166230.jpg
250	image/jpeg	http://10.126.66.246:8080/media-1460342385405.jpg
251	image/jpeg	http://10.126.66.246:8080/media-1460342845067.jpg
252	image/jpeg	http://10.126.66.246:8080/media-1460342903482.jpg
253	image/jpeg	http://10.126.66.246:8080/media-1460343149523.jpg
254	image/jpeg	http://10.126.66.246:8080/media-1460343534898.jpg
255	image/jpeg	http://10.126.66.246:8080/media-1460343768077.jpg
256	image/jpeg	http://10.126.66.246:8080/media-1460343847244.jpg
115	image/jpeg	http://10.126.66.246:8080/media-1458178859142.jpg
118	image/jpeg	http://10.126.66.246:8080/media-1459382915557.jpg
121	image/jpeg	http://10.126.66.246:8080/media-1459466173257.jpg
124	video/mp4	http://10.126.66.246:8080/media-1459466578370.mp4
127	image/jpeg	http://10.126.66.246:8080/media-1459466677439.mp4
130	image/jpeg	http://10.126.66.246:8080/media-1459722005900.jpg
133	image/jpeg	http://10.126.66.246:8080/media-1459722044568.jpg
257	image/jpeg	http://10.126.66.246:8080/media-1460343958373.jpg
258	image/jpeg	http://10.126.66.246:8080/media-1460344172428.jpg
259	image/jpeg	http://10.126.66.246:8080/media-1460344688675.jpg
260	image/jpeg	http://10.126.66.246:8080/media-1460344821804.jpg
261	image/jpeg	http://10.126.66.246:8080/media-1460344917369.jpg
262	image/jpeg	http://10.126.66.246:8080/media-1460405192267.jpg
263	image/jpeg	http://10.126.66.246:8080/media-1460405822306.jpg
264	image/jpeg	http://10.126.66.246:8080/media-1460406107876.jpg
265	image/jpeg	http://10.126.66.246:8080/media-1460406557213.jpg
266	image/jpeg	http://10.126.66.246:8080/media-1460406601606.jpg
267	image/jpeg	http://10.126.66.246:8080/media-1460406691765.jpg
268	image/jpeg	http://10.126.66.246:8080/media-1460406807848.jpg
269	image/jpeg	http://10.126.66.246:8080/media-1460406979191.jpg
270	image/jpeg	http://10.126.66.246:8080/media-1460407918975.jpg
271	image/jpeg	http://10.126.66.246:8080/media-1460409876923.jpg
272	image/jpeg	http://10.126.66.246:8080/media-1460410899024.jpg
273	image/jpeg	http://10.126.66.246:8080/media-1460411883313.jpg
274	image/jpeg	http://10.126.66.246:8080/media-1460421853183.jpg
275	image/jpeg	http://10.126.66.246:8080/media-1460463564220.jpg
276	image/jpeg	http://10.126.66.246:8080/media-1460463854880.jpg
277	image/jpeg	http://10.126.66.246:8080/media-1460464144222.jpg
278	image/jpeg	http://10.126.66.246:8080/media-1460464720355.jpg
279	image/jpeg	http://10.126.66.246:8080/media-1460464842473.jpg
280	image/jpeg	http://10.126.66.246:8080/media-1460465258895.jpg
281	image/jpeg	http://10.126.66.246:8080/media-1460465348698.jpg
282	image/jpeg	http://10.126.66.246:8080/media-1460465410545.jpg
283	image/jpeg	http://10.126.66.246:8080/media-1460465444329.jpg
284	image/jpeg	http://10.126.66.246:8080/media-1460465728845.jpg
285	image/jpeg	http://10.126.66.246:8080/media-1460465962360.jpg
286	image/jpeg	http://10.126.66.246:8080/media-1460469259010.jpg
287	image/jpeg	http://10.126.66.246:8080/media-1460469836585.jpg
288	image/jpeg	http://10.126.66.246:8080/media-1460469883012.jpg
289	image/jpeg	http://10.126.66.246:8080/media-1460470615395.jpg
290	image/jpeg	http://10.126.66.246:8080/media-1460474016956.jpg
\.


--
-- Name: media_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('media_media_id_seq', 290, true);


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY post (post_id, media_id, post_time, post_like, location_id, "timestamp", user_id) FROM stdin;
88	282	\N	2	5	2016-04-12 13:52:49.765+01	7703273602
45	220	\N	0	5	2016-04-10 21:40:07+01	9221518945
78	274	\N	-1	5	2016-04-12 01:46:52.819+01	7703273602
37	115	\N	0	5	2016-04-10 21:34:28.798+01	9221518945
92	286	\N	0	5	2016-04-12 14:56:57.973+01	7703273602
74	270	\N	0	5	2016-04-11 21:54:38.333+01	7703273602
93	287	\N	1	5	2016-04-12 15:06:35.661+01	7703273602
79	275	\N	5	5	2016-04-12 13:22:04.571+01	7703273602
94	288	\N	5	5	2016-04-12 15:07:21.85+01	7703273602
90	284	\N	2	5	2016-04-12 13:58:08.174+01	7703273602
83	277	\N	4	5	2016-04-12 13:31:44.662+01	7703273602
91	285	\N	0	5	2016-04-12 14:02:01.838+01	7703273602
77	273	\N	0	5	2016-04-11 23:00:42.297+01	9221518945
76	272	\N	0	5	2016-04-11 22:44:18.026+01	7703273602
85	279	\N	4	5	2016-04-12 13:43:21.637+01	7703273602
75	271	\N	0	5	2016-04-11 22:27:15.988+01	7703273602
72	268	\N	0	5	2016-04-11 21:36:06.877+01	9221518945
73	269	\N	-1	5	2016-04-11 21:38:58.209+01	9221518945
71	261	\N	-1	5	2016-04-11 04:24:36.855+01	9221518945
82	276	\N	3	5	2016-04-12 13:26:55.281+01	7703273602
39	118	\N	1	5	2016-04-10 21:34:28.798+01	9221518945
84	278	\N	3	5	2016-04-12 13:41:21.352+01	7703273602
95	289	\N	8	5	2016-04-12 15:19:34.701+01	7703273602
96	290	\N	5	5	2016-04-12 16:16:16.188+01	7703273602
89	283	\N	10	5	2016-04-12 13:53:23.619+01	7703273602
\.


--
-- Name: post_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_device_id_seq', 40, true);


--
-- Data for Name: post_like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY post_like (like_id, device_id, post_id, valure) FROM stdin;
\.


--
-- Name: post_like_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_like_device_id_seq', 1, false);


--
-- Name: post_like_like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_like_like_id_seq', 1, false);


--
-- Name: post_like_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_like_post_id_seq', 1, false);


--
-- Name: post_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_media_id_seq', 1, false);


--
-- Name: post_media_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_media_id_seq1', 42, true);


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_post_id_seq', 96, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (user_id, device_id) FROM stdin;
0920942328	57
2933972419	73
3731803198	75
4479836419	76
2614966699	78
4439105010	82
1842752880	83
4043388234	84
9705620089	85
8064102839	86
7662794289	88
1595434404	89
1961103566	90
5930570625	91
8731883511	92
2906910017	93
1836589865	94
1895010460	95
4606807330	96
5544003524	97
4524942715	98
9221518945	99
3202752445	103
9831380037	104
9001014106	105
7703273602	106
3602075477	120
Harryiphone	63
\.


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: device_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_device_id_key UNIQUE (device_id);


--
-- Name: device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_pkey PRIMARY KEY (device_id, device_sn);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- Name: media_media_filename_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_media_filename_key UNIQUE (media_filename);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (media_id);


--
-- Name: post_like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post_like
    ADD CONSTRAINT post_like_pkey PRIMARY KEY (like_id);


--
-- Name: post_media_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_media_id_key UNIQUE (media_id);


--
-- Name: post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: users_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_device_id_key UNIQUE (device_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: comment_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_fk FOREIGN KEY (post_id) REFERENCES post(post_id);


--
-- Name: comment_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_fk1 FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post
    ADD CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES location(location_id);


--
-- Name: media_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post
    ADD CONSTRAINT media_id FOREIGN KEY (media_id) REFERENCES media(media_id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: post_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_fk FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: post_like_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_like
    ADD CONSTRAINT post_like_fk FOREIGN KEY (device_id) REFERENCES device(device_id) ON UPDATE CASCADE;


--
-- Name: post_like_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post_like
    ADD CONSTRAINT post_like_fk1 FOREIGN KEY (post_id) REFERENCES post(post_id) ON UPDATE CASCADE;


--
-- Name: users_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

