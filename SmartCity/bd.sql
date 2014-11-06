--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2014-11-06 19:08:58 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 190 (class 1259 OID 19588)
-- Name: citoyens; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE citoyens (
    id_citoyen bigint NOT NULL,
    login text,
    mdp text
);


ALTER TABLE public.citoyens OWNER TO eric;

--
-- TOC entry 191 (class 1259 OID 19594)
-- Name: Citoyen_idCitoyen_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE "Citoyen_idCitoyen_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Citoyen_idCitoyen_seq" OWNER TO eric;

--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 191
-- Name: Citoyen_idCitoyen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE "Citoyen_idCitoyen_seq" OWNED BY citoyens.id_citoyen;


--
-- TOC entry 192 (class 1259 OID 19596)
-- Name: affect; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE affect
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.affect OWNER TO eric;

--
-- TOC entry 193 (class 1259 OID 19598)
-- Name: affectations; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE affectations (
    p_key integer DEFAULT nextval('affect'::regclass) NOT NULL,
    id_personnel integer,
    id_zone integer,
    id_type_incident integer
);


ALTER TABLE public.affectations OWNER TO eric;

--
-- TOC entry 194 (class 1259 OID 19602)
-- Name: cantons; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE cantons (
    gid integer NOT NULL,
    num_can character varying(2),
    num_arr character varying(1),
    nom_dep character varying(30),
    num_dep character varying(3),
    nom_reg character varying(30),
    num_reg character varying(2),
    nom_canton character varying(40),
    cg character varying(100),
    num_canton smallint,
    renouv smallint,
    geom geometry,
    CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'MULTIPOLYGON'::text) OR (geom IS NULL))),
    CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326))
);


ALTER TABLE public.cantons OWNER TO eric;

--
-- TOC entry 195 (class 1259 OID 19611)
-- Name: communes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE communes (
    gid integer NOT NULL,
    nom_comm character varying(50),
    nom_dept character varying(30),
    nom_region character varying(30),
    the_geom geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'MULTIPOLYGON'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = (-1)))
);


ALTER TABLE public.communes OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 19620)
-- Name: communes_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE communes_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communes_gid_seq OWNER TO postgres;

--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 196
-- Name: communes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE communes_gid_seq OWNED BY communes.gid;


--
-- TOC entry 197 (class 1259 OID 19622)
-- Name: serial; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE serial
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serial OWNER TO eric;

--
-- TOC entry 198 (class 1259 OID 19624)
-- Name: declaration; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE declaration (
    gid integer DEFAULT nextval('serial'::regclass) NOT NULL,
    zone character varying(100),
    latitude numeric,
    longitude numeric,
    type integer,
    texte text,
    photo text,
    date_dec date,
    idcitoyen integer,
    persaffectee bigint,
    etat bit(3),
    date_fin date,
    nb_notifications integer DEFAULT 0,
    adresse text,
    date_priseencharge date,
    suivi boolean,
    urgence integer,
    id_ville integer
);


ALTER TABLE public.declaration OWNER TO eric;

--
-- TOC entry 199 (class 1259 OID 19632)
-- Name: etats; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE etats (
    message text,
    valeur bit(3),
    p_key integer NOT NULL
);


ALTER TABLE public.etats OWNER TO eric;

--
-- TOC entry 200 (class 1259 OID 19638)
-- Name: id_notif; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE id_notif
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.id_notif OWNER TO eric;

--
-- TOC entry 201 (class 1259 OID 19640)
-- Name: idcitoyen; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE idcitoyen
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.idcitoyen OWNER TO eric;

--
-- TOC entry 202 (class 1259 OID 19642)
-- Name: incident; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE incident
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incident OWNER TO eric;

--
-- TOC entry 203 (class 1259 OID 19644)
-- Name: incidents; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE incidents (
    id_type integer DEFAULT nextval('incident'::regclass) NOT NULL,
    intitule text
);


ALTER TABLE public.incidents OWNER TO eric;

--
-- TOC entry 204 (class 1259 OID 19651)
-- Name: nantes_gid_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE nantes_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nantes_gid_seq OWNER TO eric;

--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 204
-- Name: nantes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE nantes_gid_seq OWNED BY cantons.gid;


--
-- TOC entry 205 (class 1259 OID 19653)
-- Name: notifications; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE notifications (
    id integer DEFAULT nextval('id_notif'::regclass) NOT NULL,
    id_dec integer,
    id_utilisateur integer
);


ALTER TABLE public.notifications OWNER TO eric;

--
-- TOC entry 206 (class 1259 OID 19657)
-- Name: personnel; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE personnel (
    idpers bigint NOT NULL,
    nom text,
    prenom text,
    idville integer,
    login text,
    email text,
    role text
);


ALTER TABLE public.personnel OWNER TO eric;

--
-- TOC entry 207 (class 1259 OID 19663)
-- Name: personnel_idPers_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE "personnel_idPers_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."personnel_idPers_seq" OWNER TO eric;

--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 207
-- Name: personnel_idPers_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE "personnel_idPers_seq" OWNED BY personnel.idpers;


--
-- TOC entry 208 (class 1259 OID 19665)
-- Name: photos; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE photos (
    idphoto integer NOT NULL,
    iddeclaration bigint,
    nom text
);


ALTER TABLE public.photos OWNER TO eric;

--
-- TOC entry 209 (class 1259 OID 19671)
-- Name: photos_idphoto_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE photos_idphoto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_idphoto_seq OWNER TO eric;

--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 209
-- Name: photos_idphoto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE photos_idphoto_seq OWNED BY photos.idphoto;


--
-- TOC entry 210 (class 1259 OID 19673)
-- Name: trait_pkey; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE trait_pkey
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trait_pkey OWNER TO eric;

--
-- TOC entry 211 (class 1259 OID 19675)
-- Name: traitement_incidents; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE traitement_incidents (
    p_key integer DEFAULT nextval('trait_pkey'::regclass) NOT NULL,
    id_incident integer,
    id_ville integer
);


ALTER TABLE public.traitement_incidents OWNER TO eric;

--
-- TOC entry 212 (class 1259 OID 19679)
-- Name: ville; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE ville (
    idville integer NOT NULL,
    nom text
);


ALTER TABLE public.ville OWNER TO eric;

--
-- TOC entry 213 (class 1259 OID 19685)
-- Name: ville_idVille_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE "ville_idVille_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ville_idVille_seq" OWNER TO eric;

--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 213
-- Name: ville_idVille_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE "ville_idVille_seq" OWNED BY ville.idville;


--
-- TOC entry 3298 (class 2604 OID 19687)
-- Name: gid; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY cantons ALTER COLUMN gid SET DEFAULT nextval('nantes_gid_seq'::regclass);


--
-- TOC entry 3296 (class 2604 OID 19688)
-- Name: id_citoyen; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY citoyens ALTER COLUMN id_citoyen SET DEFAULT nextval('"Citoyen_idCitoyen_seq"'::regclass);


--
-- TOC entry 3302 (class 2604 OID 19689)
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY communes ALTER COLUMN gid SET DEFAULT nextval('communes_gid_seq'::regclass);


--
-- TOC entry 3310 (class 2604 OID 19690)
-- Name: idpers; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY personnel ALTER COLUMN idpers SET DEFAULT nextval('"personnel_idPers_seq"'::regclass);


--
-- TOC entry 3311 (class 2604 OID 19691)
-- Name: idphoto; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY photos ALTER COLUMN idphoto SET DEFAULT nextval('photos_idphoto_seq'::regclass);


--
-- TOC entry 3313 (class 2604 OID 19692)
-- Name: idville; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY ville ALTER COLUMN idville SET DEFAULT nextval('"ville_idVille_seq"'::regclass);


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 191
-- Name: Citoyen_idCitoyen_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('"Citoyen_idCitoyen_seq"', 3, true);


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 192
-- Name: affect; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('affect', 16, true);


--
-- TOC entry 3472 (class 0 OID 19598)
-- Dependencies: 193
-- Data for Name: affectations; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY affectations (p_key, id_personnel, id_zone, id_type_incident) FROM stdin;
1	1	43	1
2	1	44	1
3	1	45	1
4	1	46	1
5	1	47	1
6	4	48	1
7	4	49	1
8	4	50	1
9	4	51	1
10	4	52	2
11	4	53	2
12	1	52	1
13	1	43	4
14	1	44	4
15	1	45	4
16	1	46	4
\.


--
-- TOC entry 3473 (class 0 OID 19602)
-- Dependencies: 194
-- Data for Name: cantons; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY cantons (gid, num_can, num_arr, nom_dep, num_dep, nom_reg, num_reg, nom_canton, cg, num_canton, renouv, geom) FROM stdin;
\.


--
-- TOC entry 3469 (class 0 OID 19588)
-- Dependencies: 190
-- Data for Name: citoyens; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY citoyens (id_citoyen, login, mdp) FROM stdin;
1	app1	hello
2	app2	salut
3	app3	pass
14	unLogin	unMdp
15	qze	qze
16	qzd	qzd
17	aze	aze
18	wxc	wxc
19	qsd	qsd
20	bla	bla
21	uio	uio
22	fgh	fgh
23	tyu	tyu
24	dfg	dfg
25	rty	rty
26	ghj	ghj
27	sdf	sdf
28	rth	rth
29	blabla	blabla
30	essai	essai
31	unCompte	unLogin
32	loglog	mdpmdp
33	qzdqzd	qzdqzd
\.


--
-- TOC entry 3474 (class 0 OID 19611)
-- Dependencies: 195
-- Data for Name: communes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY communes (gid, nom_comm, nom_dept, nom_region, the_geom) FROM stdin;
\.


--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 196
-- Name: communes_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('communes_gid_seq', 36613, true);


--
-- TOC entry 3477 (class 0 OID 19624)
-- Dependencies: 198
-- Data for Name: declaration; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY declaration (gid, zone, latitude, longitude, type, texte, photo, date_dec, idcitoyen, persaffectee, etat, date_fin, nb_notifications, adresse, date_priseencharge, suivi, urgence, id_ville) FROM stdin;
1	Lobamba	-26.46666746140	31.19999710970	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	Vatican City	41.90001222640	12.44780838890	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	Luxembourg	49.61166037910	6.13000280623	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	Shenzhen	22.55237051110	114.12212308800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	Zibo	36.79998760890	118.04999304100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	Montevideo	-34.85804156620	-56.17105228840	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	Minneapolis	44.97997926740	-93.25178633810	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	Seattle	47.57000205390	-122.33998498700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	Phoenix	33.53997987780	-112.06999170100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	San Diego	32.82002382310	-117.17998987000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	San Francisco	37.74000775050	-122.45997766300	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	Los Angeles	33.98997825020	-118.17998051100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	Denver	39.73918804840	-104.98401595200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	St. Louis	38.63501771960	-90.23998051120	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	Dallas	32.82002382310	-96.84001692890	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	Houston	29.81997438460	-95.33997929050	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	Maracaibo	10.72997682590	-71.65997766280	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	Boston	42.32996014310	-71.07001367360	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	Tampa	27.94698793440	-82.45862085140	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	Miami	25.78761069640	-80.22410608080	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	Atlanta	33.83001385400	-84.39994938330	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	Chicago	41.82999066070	-87.75005497410	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	Washington, D.C.	38.89954937650	-77.00941858080	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	Hanoi	21.03332724910	105.85001420000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
24	New York	40.74997906400	-73.98001692880	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	Philadelphia	39.99997316390	-75.16999597340	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	Caracas	10.50099855440	-66.91703719240	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	Port-of-Spain	10.65199708960	-61.51703088540	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	Detroit	42.32996014310	-83.08005578790	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	Lome	6.13193707166	1.22275711936	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	Tunis	36.80277813620	10.17967809920	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	Kiev	50.43336732900	30.51662796910	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	Abu Dhabi	24.46668357240	54.36659338260	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	Dubai	25.22999615380	55.27997432340	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
34	Ashgabat	37.94999493310	58.38329911180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	Tashkent	41.31170188300	69.29493281950	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
63	Dushanbe	38.56003521630	68.77387935270	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
37	Ho Chi Minh City	10.78002545060	106.69502722100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	Lusaka	-15.41664426790	28.28332759470	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	Harare	-17.81778969440	31.04470943070	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
40	Dili	-8.55938840855	125.57945593200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	Port-Vila	-17.73335040400	168.31664058400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
42	Tegucigalpa	14.10204490050	-87.21752933930	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	Georgetown	6.80197369275	-58.16702864750	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	Reykjavík	64.15002361970	-21.95001448720	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
45	Port-au-Prince	18.54102459610	-72.33603458830	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	Ankara	39.92723858550	32.86439164100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
50	Budapest	47.50000632640	19.08332067740	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
51	Sanaa	15.35473329570	44.20659338260	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
52	Kigali	-1.95359006868	30.06053177770	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
53	Paramaribo	5.83503012992	-55.16703088540	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
54	Madrid	40.40002626450	-3.68335168600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	Niamey	13.51670595190	2.11665604514	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
56	Barcelona	41.38329957990	2.18337031923	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	Bucharest	44.43337180490	26.09994665400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
58	Aleppo	36.22997072250	37.17002030310	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	Damascus	33.50003399560	36.29999588900	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
60	Geneva	46.21000754710	6.14002803409	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
61	Zürich	47.37998781240	8.55001013046	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
62	Stockholm	59.35075995430	18.09733473280	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	Bangkok	13.74999920550	100.51664465200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	Mbabane	-26.31665077840	31.13333451210	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	Lima	-12.04801267610	-77.05006209480	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
67	Asuncion	-25.29640297570	-57.64150516930	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
68	Managua	12.15301658010	-86.26849166030	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
69	Lisbon	38.72272287790	-9.14486630549	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
70	Dakar	14.71583172500	-17.47313012840	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
71	Freetown	8.47001141249	-13.23421574040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
72	Juba	4.82997519828	31.58002559280	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
73	Khartoum	15.58807822570	32.53417923860	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
74	Jeddah	21.51688946430	39.21919754920	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
75	The Hague	52.08003684400	4.26996130231	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
76	Oslo	59.91669028640	10.74997920600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
77	Ljubljana	46.05528830880	14.51496903350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
78	Bratislava	48.15001833000	17.11698075220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
79	Riyadh	24.64083314920	46.77274165730	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
80	Doha	25.28655600890	51.53296789430	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
81	Islamabad	33.69999595030	73.16663447970	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
82	Lahore	31.55997153630	74.35002477920	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
83	Karachi	24.86999228820	66.99000891000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
84	Kathmandu	27.71669191390	85.31664221080	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
85	Taipei	25.01667584130	121.44999222700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
86	Cape Town	-33.92001096720	18.43498815780	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
87	Bloemfontein	-29.11999387740	26.22991288120	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
88	Pretoria	-25.70692055380	28.22942907580	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
89	Johannesburg	-26.17004474000	28.03000972360	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
90	Durban	-29.86501300170	30.98001053740	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
91	Port Moresby	-9.46470782587	147.19250362100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
92	Honiara	-9.43799429509	159.94976573400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
93	Amsterdam	52.34996868810	4.91664017601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
94	Panama City	8.96801719048	-79.53303715180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
95	Casablanca	33.59997621560	-7.61636743309	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
96	Rabat	34.02529909160	-6.83613082013	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
97	Podgorica	42.46597251290	19.26630692410	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
98	Chisinau	47.00502361970	28.85771113970	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99	Maputo	-25.95527748740	32.58916296260	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
100	St. Petersburg	59.93901450510	30.31602005890	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
101	Moscow	55.75216412260	37.61552282590	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
102	Mogadishu	2.06668133433	45.36667761110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
103	Muscat	23.61332480770	58.59331213260	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
104	Sri Jawewardenepura Kotte	6.90000388481	79.94999304090	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
105	Colombo	6.93196575818	79.85775060930	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
106	Seoul	37.56634909980	126.99973099700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
107	Baguio City	16.42999066060	120.56994258500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
108	Manila	14.60415895480	120.98221716200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
109	Monterrey	25.66999513650	-100.32998478400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	Istanbul	41.10499615380	29.01000158560	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N	\N	\N
110	Guadalajara	20.67001609190	-103.33003422200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
111	Puebla	19.04995993950	-98.20003727390	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
112	Mexico City	19.44244244280	-99.13098820170	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
113	Lagos	6.44326165348	3.39153107121	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
114	Kano	11.99997682590	8.52003779973	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
115	Warsaw	52.25000062980	20.99999955110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
116	Pyongyang	39.01943869940	125.75469071400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
117	Ulaanbaatar	47.91667339990	106.91661576200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
118	Wellington	-41.29997393930	174.78327429100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
119	Windhoek	-22.57000608440	17.08354610050	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
120	Dar es Salaam	-6.80001259474	39.26834183630	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
121	Dodoma	-6.18330605177	35.75000362010	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
122	Auckland	-36.85001300180	174.76498083400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
123	Bern	46.91668275870	7.46697546248	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
124	Laayoune	27.14998231910	-13.20000594220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
125	Abuja	9.08333314914	7.53332800155	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
126	Medan	3.57997397757	98.65004024150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
127	Dublin	53.33306113600	-6.24890568178	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
128	Bissau	11.86502382300	-15.59836084130	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
129	Monrovia	6.31055665987	-10.80475162910	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
130	Naples	40.84002524730	14.24501135120	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
131	Rome	41.89595562650	12.48325842150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
132	Pristina	42.66670961410	21.16598425160	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
133	Amman	31.95002524720	35.93329992550	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
134	Milan	45.46997519840	9.20500890976	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
135	Vilnius	54.68336631180	25.31663529330	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
136	Riga	56.95002382320	24.09996537140	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
137	Bishkek	42.87307944650	74.58520422250	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
138	Kuala Lumpur	3.16666587210	101.69998327500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
139	Lanzhou	36.05602785140	103.79200028400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
140	Nanning	22.81998821920	108.32004431100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
141	Guiyang	26.58004294740	106.72003861400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
142	Chongqing	29.56497702940	106.59498164800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
143	Beijing	39.92889223130	116.38828568400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
144	Fuzhou	26.07999595030	119.30004593800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
145	Guangzhou	23.14498130190	113.32501013100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
146	Dongguan	23.04888890000	113.74472220000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
147	Nairobi	-1.28334674185	36.81665685910	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
148	Maseru	-29.31667437870	27.48327307000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
149	Antananarivo	-18.91663735060	47.51662390010	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
150	Bandung	-6.95002927768	107.57001257200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
151	Jakarta	-6.17441770541	106.82943762100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
152	Surabaya	-7.24923582065	112.75083329200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
153	Guayaquil	-2.22003375357	-79.92004195320	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
154	Quito	-0.21498818065	-78.50005110850	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
155	Medellin	6.27500327446	-75.57501001150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
156	San Jose	9.93501242974	-84.08405135270	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
157	San Salvador	13.71000164690	-89.20304122080	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
158	Kingston	17.97707662380	-76.76743371370	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
159	Bogota	4.59642356253	-74.08334395520	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
160	Cali	3.39995912568	-76.49996647310	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
161	Havana	23.13195884090	-82.36418217130	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
162	Roseau	15.30101564430	-61.38701298180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
163	Ndjamena	12.11309653620	15.04914831410	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
164	Malabo	3.75001527803	8.78327754582	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
165	Cairo	30.04996034650	31.24996821970	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
166	Alexandria	31.20001934710	29.94999588900	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
167	Asmara	15.33333925270	38.93332352580	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
168	Djibouti	11.59501446430	43.14800166710	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
169	Frankfurt	50.09997682610	8.67501542017	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
170	Hamburg	53.55002463690	9.99999914413	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
171	Zagreb	45.80000673330	15.99999466820	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
172	Munich	48.12994203600	11.57499344750	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
173	Prague	50.08333701490	14.46597977570	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
175	Tallinn	59.43387737950	24.72804072950	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
176	Kuwait	29.36971763000	47.97830114620	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
177	Urumqi	43.80501222640	87.57500565490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
178	Putrajaya	2.91401979462	101.70194698000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
179	Xian	34.27502545070	108.89499629600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
180	Taiyuan	37.87501242990	112.54505773800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
181	Wuhan	30.58003135070	114.27001704800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
182	Changsha	28.19996990870	112.96999304100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
183	Chengdu	30.67000001930	104.07001949000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
184	Kunming	25.06998008120	102.67997513700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
185	Zhengzhou	34.75499615380	113.66509273200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
186	Shenyeng	41.80497926740	123.44997351000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
187	Jinan	36.67498231920	116.99501867600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
188	Tianjin	39.13002626450	117.20001908300	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
189	Nanchang	28.67999228820	115.87999629600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
190	Nanjing	32.05001914370	118.77997432400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
191	Shanghai	31.21645245260	121.43650467800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
192	Hangzhou	30.24997397770	120.17001867600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
205	Banjul	13.45387646030	-16.59170148920	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
193	Hiroshima	34.38783510240	132.44291296300	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
194	Changchun	43.86500856430	125.33998734400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
195	Baotou	40.65220725410	109.82201981500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
196	Harbin	45.74998394680	126.64998490300	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
197	Sapporo	43.07497926740	141.34004431100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
198	Kyoto	35.02999228820	135.74999792400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
199	Osaka	34.75003521630	135.46014481500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
200	Tokyo	35.68501690580	139.75140742900	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
201	Kinshasa	-4.32972410189	15.31497188180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
202	Lilongwe	-13.98329506550	33.78330196000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
203	Guatemala	14.62113466280	-90.52696557790	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
204	Santo Domingo	18.47007285460	-69.90008508470	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
206	Libreville	0.38538860972	9.45796504582	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
207	Accra	5.55003460583	-0.21671574035	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
208	Delhi	28.66999289860	77.23000402720	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
209	New Delhi	28.60002300920	77.19998002010	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
210	Hyderabad	17.39998313290	78.47995357150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
211	Bangalore	12.96999513650	77.56000972380	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
212	Pune	18.53001751600	73.85000362030	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
213	Nagpur	21.16995973610	79.08999385470	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
214	Mumbai	19.01699037570	72.85698929740	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
215	Suva	-18.13301593140	178.44170731500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
217	Santiago	-33.45001381550	-70.66704085460	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
218	Valparaiso	-33.04776446660	-71.62101363290	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
219	Nouakchott	18.08642702120	-15.97534041490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
220	Bamako	12.65001466770	-8.00003910464	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
221	Athens	37.98332623190	23.73332108430	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
222	Skopje	42.00000612290	21.43346146510	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
223	Tripoli	32.89250001940	13.18001175810	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
224	Beirut	33.87197511700	35.50970821000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
225	Tbilisi	41.72500998850	44.79079544960	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
226	Tel Aviv-Yafo	32.07999147440	34.77001175820	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
227	Baghdad	33.33864849750	44.39386877320	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
228	Addis Ababa	9.03331036268	38.70000443400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
229	Helsinki	60.17556337400	24.93412634150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
230	Astana	51.18112530430	71.42777420950	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
231	Tehran	35.67194276840	51.42434403360	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
232	Mashhad	36.27001995750	59.56999670290	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
233	Jaipur	26.92113323870	75.80998734430	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
234	Kanpur	26.45999859520	80.31999629610	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
235	Kolkata	22.49496929830	88.32467565810	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
236	Patna	25.62495912580	85.13003861380	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
237	Chennai	13.08998781220	80.27999873750	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
238	Ahmedabad	23.03005291640	72.58000362030	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
239	Surat	21.19998374330	72.84003942760	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
240	Vientiane	17.96669272760	102.59998002000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
241	Brazzaville	-4.25918577181	15.28468949250	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
242	København	55.67856419040	12.56348574730	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
243	Conakry	9.53152284641	-13.68023502750	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
269	Yerevan	40.18115073550	44.51355139040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
244	Abidjan	5.31999696749	-4.04004825989	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
245	Yamoussoukro	6.81838096000	-5.27550256491	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
246	Belem	-1.45000323599	-48.48002303220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
247	Brasilia	-15.78334023150	-47.91605228840	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
248	Porto Alegre	-30.05001462930	-51.20001204590	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
249	Curitiba	-25.42001300170	-49.31999760090	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
250	Fortaleza	-3.75001788444	-38.57998132480	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
251	Salvador	-12.96997190470	-38.47998742830	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
252	Rio de Janeiro	-22.92502317420	-43.22502079420	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
253	Vancouver	49.27341658410	-123.12164421800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
254	Ottawa	45.41669679670	-75.70001530120	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
255	Toronto	43.69997987780	-79.42002079440	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
270	Baku	40.39527203270	49.86221716190	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
256	Montréal	45.49999920560	-73.58329695810	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
257	Belgrade	44.81864544580	20.46799068060	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
258	Bandar Seri Begawan	4.88333111462	114.93328405700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
259	Sucre	-19.04097084670	-65.25951562670	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
260	Goiania	-16.72002724320	-49.30002465980	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
261	Buenos Aires	-34.60250160850	-58.39753137370	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
262	Sao Paulo	-23.55867958700	-46.62501998040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
263	Recife	-8.07564532586	-34.91560551100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
264	Belmopan	17.25203350720	-88.76707299980	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
265	Bangui	4.36664430635	18.55828812530	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
266	Yaounde	3.86670066214	11.51665075550	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
267	Tirana	41.32754070950	19.81888301460	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
268	Brussels	50.83331707670	4.33331660830	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
271	Kabul	34.51669028630	69.18326004930	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
272	Phnom Penh	11.55003012990	104.91663448000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
273	Dhaka	23.72305971170	90.40857946670	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
274	Luanda	-8.83828611363	13.23442704130	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
275	La Paz	-16.49797361370	-68.14998519050	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
276	Bridgetown	13.10200258280	-59.61652673510	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
277	Porto-Novo	6.48331097302	2.61662552757	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
278	Cotonou	6.40000856417	2.51999059918	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
279	Algiers	36.76306479800	3.05055252952	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
280	Sofia	42.68334942530	23.31665401070	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
281	Vienna	48.20001527820	16.36663895540	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
282	Minsk	53.89997743640	27.56662715530	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
283	Thimphu	27.47298585920	89.63901403700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
284	Chittagong	22.32999228820	91.79996740620	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
285	Gaborone	-24.64631345740	25.91194779330	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
286	Canberra	-35.28302854540	149.12902624400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
287	Sydney	-33.92001096720	151.18517980900	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
288	Melbourne	-37.82003131230	144.97501623500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
289	Ouagadougou	12.37031597790	-1.52472375630	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
290	Sarajevo	43.85002239900	18.38300166700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
291	Naypyidaw	19.76655702610	96.11861852920	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
292	Rangoon	16.78335410460	96.16667761130	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
293	Bujumbura	-3.37608722037	29.36000606150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
294	Palikir	6.91664369601	158.14997432400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
295	Majuro	7.10300431122	171.38000017600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
296	Funafuti	-8.51665199904	179.21664709400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
297	San Marino	43.91715008450	12.46667028670	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
298	Melekeok	7.48739617298	134.62654846700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
299	Bir Lehlou	26.11916668600	-9.65252221825	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
301	Vaduz	47.13372377430	9.51666947291	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
302	Tarawa	1.33818750562	173.01757082900	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
303	Moroni	-11.70415769570	43.24024409870	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
304	Andorra	42.50000144350	1.51648596051	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
305	Kingstown	13.14827882790	-61.21206242030	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
306	Castries	14.00197348930	-61.00000818040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
307	Basseterre	17.30203045550	-62.71700931970	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
308	Nukualofa	-21.13851235670	-175.22056447800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
309	Hargeysa	9.56002239882	44.06531001670	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
310	Singapore	1.29303346649	103.85582067800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
311	Victoria	-4.61663165397	55.44998978560	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
312	Sao Tome	0.33340211883	6.73332515323	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
313	Apia	-13.84154504240	-171.73864160900	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
314	Port Louis	-20.16663857140	57.49999385460	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
315	Valletta	35.89973248190	14.51471065130	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
316	Male	4.16670818981	73.49994746800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
317	Jerusalem	31.77840781560	35.20662593460	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
318	Saint George's	12.05263340170	-61.74164322610	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
319	Hong Kong	22.30498089500	114.18500931700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
320	Praia	14.91669801730	-23.51668888500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
321	Manama	26.23613629050	50.58305171590	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
322	Nassau	25.08339011540	-77.35004378430	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44919	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	1	1	001	\N	0	drgdrg	\N	\N	\N	\N
4499	test	47.221608	-1.588726	1	salutsjkjfekjk		2013-07-27	1	4	001	\N	0	gyjgyj	\N	\N	\N	\N
4444	test	47.222191	-1.575594	1	salutsjkjfekjk		2013-07-27	2	1	100	\N	0	yjygyj	\N	\N	\N	\N
4919	test	47.206742	-1.543322	1	salutsjkjfekjk		2013-07-27	3	1	010	\N	1	gyjg	2013-08-29	\N	\N	1
499	test	47.22155	-1.56023	4	salutsjkjfekjk	\N	2013-07-27	2	1	001	\N	0	zdqzd	\N	\N	\N	1
1035	44	47.20829792749427	-1.5335288476073856	1	un champ		2013-08-08	1	1	001	\N	0	1-3 Rue Célestin Freinet, 44200 Nantes, France	\N	\N	\N	\N
423214	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	1	1	001	\N	0	qzdqzd	\N	\N	\N	\N
6266	test	1.3737	1.3737	1	testsocket		2013-08-02	1	4	001	\N	0	rdg	\N	\N	\N	\N
1010	undefined	47.21056	-1.566238	1	patate		2013-08-06	3	1	001	\N	0	efs	\N	\N	\N	\N
6666	test	1.3737	NaN	1	testsocket		2013-08-02	3	1	001	\N	0	drgdr	\N	\N	\N	\N
423114	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	2	4	001	\N	0	qzdqzd	\N	\N	\N	\N
216	Paris	48.86669293120	2.33333532574	1	adzdzdz	\N	2013-07-16	2	1	100	2013-07-12	0	\N	\N	\N	\N	\N
1007	undefined	47.205342	-1.560144	1	blabla		2013-08-06	2	5	001	\N	0	ws	\N	\N	\N	\N
530	test	46.89987	-1.566925	1	Une Description	\N	2013-07-29	1	1	100	\N	0	zqdq	\N	\N	\N	1
1006	undefined	47.205342	-1.560144	1	blabla		2013-08-06	1	1	001	\N	0	wscs	\N	\N	\N	\N
1005	undefined	47.205342	-1.560144	1	blabla		2013-08-06	1	1	001	\N	0	scwsc	\N	\N	\N	\N
1004	undefined	47.205342	-1.560144	1	blabla		2013-08-06	2	1	001	\N	0	qzddzq	\N	\N	\N	\N
422324	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	1	1	001	\N	0	zdq	\N	\N	\N	\N
42234	Rennes	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	2	1	001	\N	0	drgdr	\N	\N	\N	\N
62676	test	1.3737	45.7897	1	testsocket		2013-08-02	1	4	001	\N	0	tyuty	\N	\N	\N	\N
1014	undefined	47.207791	-1.527615	1	hola		2013-08-06	3	1	001	\N	1	efsfs	\N	\N	\N	\N
422111	test	-1.3789737	3.78878	1	salutsjkjfekjk		2013-07-28	1	4	001	\N	0	tyutyu	\N	\N	\N	\N
421241	test	-1.3789737	NaN	1	salutsjkjfekjk		2013-07-28	3	1	001	\N	0	muiy	\N	\N	\N	\N
421114	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	1	1	001	\N	0	tyu	\N	\N	\N	\N
42124111	test	-1.3789737	3.78878	1	salutsjkjfekjk		2013-07-28	3	1	001	\N	0	qzd	\N	\N	\N	\N
1040	44	47.206496956245594	-1.5388537502929012	1	une description lala		2013-08-08	1	1	001	\N	1	Boulevard Général de Gaulle, 44200 Nantes, France	\N	\N	\N	\N
4224111	test	-1.3789737	3.78878	1	salutsjkjfekjk		2013-07-28	3	4	001	\N	0	qzd	\N	\N	\N	\N
4221241	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	1	1	001	\N	0	qzd	\N	\N	\N	\N
300	Nantes	43.73964568790	7.40691317347	0	Bonjour, j'ai trouvé sur mon chemin un arbre abattu par la tempête. Merci de régler ce soucis rapidement.	video.mp4	2013-06-28	2	1	001	2013-07-12	0	efeefe	\N	\N	\N	\N
1012	undefined	47.211756	-1.521349	1	patate		2013-08-06	3	1	001	\N	3	zeferf	\N	\N	\N	\N
400	Nantes	47.229827	-1.55056	2		\N	2013-07-10	1	4	010	2013-07-12	0	efe	\N	\N	\N	\N
532	test	47.2157817	-1.5350959	2	Une Description	\N	2013-07-29	2	2	001	\N	4	qzddqz	\N	\N	\N	1
666	test	47.222191	-1.575594	1	testsocket	\N	2013-08-02	3	4	001	\N	0	qzddqz	\N	\N	\N	1
531	test	47.220443	-1.569929	1	Une Description	\N	2013-07-29	3	2	010	\N	0	qzdzq	\N	\N	\N	\N
42324	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	1	4	001	\N	0	drgdr	\N	\N	\N	\N
46	Rennes	51.49999472970	-0.11672184386	2	hey salut il y a un tag tout pas beau sur un mur	\N	2013-07-07	2	4	010	2013-07-12	2	\N	\N	\N	\N	\N
1034	44	47.20829792749427	-1.5335288476073856	1	un champ		2013-08-08	1	1	001	\N	1	1-3 Rue Célestin Freinet, 44200 Nantes, France	\N	\N	\N	\N
1002	undefined	47.217411	-1.529717	1	blabla		2013-08-06	1	4	001	\N	0	qzdzq	\N	\N	\N	1
1016	49	47.217791	-1.537615	1	hola		2013-08-06	1	4	001	\N	1	svfzse	\N	\N	\N	1
1030	49	47.214857898893385	-1.5377340359984828	1	Ceci est une descrription		2013-08-08	1	4	001	\N	5	26 Mail Pablo Picasso, 44000 Nantes, France	\N	\N	\N	\N
1029	44	47.206098287995005	-1.5408636561279536	1	bla		2013-08-08	1	1	001	\N	2	5 Boulevard Vincent Gâche, 44200 Nantes, France	\N	\N	\N	\N
449	test	47.218169	-1.558771	1	salutsjkjfekjk	\N	2013-07-27	1	1	001	\N	0	zdq	\N	\N	\N	1
1021	44	47.205342	-1.560144	1	blablaaaaaaa		2013-08-08	1	1	001	\N	0	\N	\N	\N	\N	\N
43221241	test	1.3737	NaN	1	salutsjkjfekjk		2013-07-27	3	4	001	\N	0	qzdzqd	\N	\N	\N	\N
1003	undefined	47.205342	-1.560144	1	blabla		2013-08-06	1	1	010	\N	0	qzdqzd	2013-08-29	\N	\N	\N
1017	49	47.217791	-1.537615	1	hola		2013-08-06	2	4	001	\N	0	sefsefs	\N	\N	\N	1
1020	44	47.205342	-1.560144	1	blablaaaaaaa		2013-08-08	1	1	001	\N	0	\N	\N	\N	\N	\N
1019	44	47.205342	-1.560144	1	blabla		2013-08-08	1	1	001	\N	0	\N	\N	\N	\N	\N
1018	49	47.217791	-1.537615	1	hola		2013-08-07	1	4	001	\N	0	uhkhu	\N	\N	\N	\N
1036	44	47.205342	-1.560144	1	blablaaaaaaa	VID_20130812_090740.mp4	2013-08-08	1	1	001	\N	0	jflkefjlekjfle	\N	\N	\N	1
401	Rennes	44.848567	-0.576897	1	yo	\N	2013-07-10	2	4	001	2013-07-12	0	efe	\N	\N	\N	1
1011	undefined	47.2007	-1.566238	1	patate		2013-08-06	1	1	001	\N	0	zdqz	\N	\N	\N	\N
1071	44	47.21066219105893	-1.5233721263671214	1	ghj	\N	2013-08-20	26	1	001	\N	1	Allée Titus Brandsma, 44200 Nantes, France	\N	\N	\N	\N
1072	zone	47.208613868961	-1.528825959741198	1	qzd	\N	2013-08-20	28	1	001	\N	1	21 Boulevard Georges Pompidou, 44200 Nantes, France	\N	\N	\N	\N
1070	44	47.21066219105893	-1.5233721263671214	1	ghj	\N	2013-08-20	26	1	001	\N	0	Allée Titus Brandsma, 44200 Nantes, France	\N	\N	\N	1
1066	44	47.21706017504627	-1.5528748525146057	1	aze		2013-08-13	1	1	001	\N	0	29 Rue de Briord, 44000 Nantes, France	\N	\N	\N	1
49	Kampala	0.31665895477	32.58332352570	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1068	49	47.21788954249198	-1.5409711021607109	1	hj		2013-08-13	1	4	001	\N	0	22 Boulevard Stalingrad, 44000 Nantes, France	\N	\N	\N	\N
1067	44	47.211476457338954	-1.5543183742187239	1	aze		2013-08-13	1	1	001	\N	0	1 Place Alexis-Ricordeau, 44000 Nantes, France	\N	\N	\N	\N
1063	49	47.217937140144016	-1.5423061778319607	1	fhg		2013-08-13	1	4	001	\N	0	26 Boulevard Stalingrad, 44000 Nantes, France	\N	\N	\N	\N
1060	49	47.215788599999996	-1.5350911999999999	1	qzd		2013-08-12	1	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	\N	\N	\N
1054	44	47.206496956245594	-1.5388537502929012	1	Description		2013-08-12	1	1	001	\N	0	Boulevard Général de Gaulle, 44200 Nantes, France	\N	\N	\N	\N
1069	44	47.208769038621966	-1.5320018952148757	1	qsd		2013-08-20	1	1	001	\N	1	2 Boulevard Alexandre Millerand, 44200 Nantes, France	\N	\N	\N	\N
1073	zone	47.210719896164086	-1.5353331920654227	1	Bwaaaah	\N	2013-08-23	16	1	001	\N	0	Pont Willy Brandt, 44200 Nantes, France	\N	t	1	1
1075	zone	47.2157814	-1.5350808	1	Une description	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	2	\N
1076	zone	47.2157766	-1.5350823	1	test	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	1	\N
1077	zone	47.2157969	-1.5350802	1	ttttt	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1078	zone	47.2157969	-1.5350802	1	aze	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1079	zone	47.2157838	-1.5350914	1	qzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1080	zone	47.2157682	-1.5350914	1	azd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1081	zone	47.2157963	-1.5350891999999998	1	wsc	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1082	zone	47.2157966	-1.5350891	1	qzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1083	zone	47.2157966	-1.5350891	1	qzdqzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1084	zone	47.215801	-1.5350464	1	qzdqzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1085	zone	47.215801	-1.5350464	1	qqzqe	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1086	zone	47.2158004	-1.5350496	1	qzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1087	zone	47.2157957	-1.5350796	1	qzdqzdqzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1088	zone	47.2157957	-1.5350770999999999	1	qzdqzdqzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1089	zone	47.2157957	-1.5350770999999999	1	qzdqzdqzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1090	zone	47.2157957	-1.5350770999999999	1	qzdqzdqzd	\N	2013-08-29	2	4	001	\N	0	26 Mail Pablo Picasso, 44000 Nantes, France	\N	f	3	\N
1091	zone	47.2053930597635	-1.5545601662842046	4	Problèèèèèèmes!	1377766909558.jpg	2013-08-29	31	1	001	\N	0	2 Place de la République, 44200 Nantes, France	\N	t	2	\N
1093	zone	47.20013505868593	-1.5727019568969354	1	Ceci est une description	1377767226263.jpg	2013-08-29	32	1	001	\N	0	2 Rue de Saint-Domingue, 44200 Nantes, France	\N	t	1	\N
1094	zone	47.20039198188965	-1.5443386143554108	4	blablabla	\N	2013-08-29	32	1	001	\N	0	10 Place Victor Mangin, 44200 Nantes, France	\N	t	2	\N
1074	zone	47.2157708	-1.5350485	3	Un arrêt de bus a été dégradé, merci de votre intervention.	\N	2013-08-26	30	2	001	\N	2	26 Mail Pablo Picasso, 44000 Nantes, France	\N	t	2	1
\.


--
-- TOC entry 3478 (class 0 OID 19632)
-- Dependencies: 199
-- Data for Name: etats; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY etats (message, valeur, p_key) FROM stdin;
Nouveau	001	1
En cours	010	2
Terminé	100	3
\.


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 200
-- Name: id_notif; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('id_notif', 32, true);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 201
-- Name: idcitoyen; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('idcitoyen', 33, true);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 202
-- Name: incident; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('incident', 7, true);


--
-- TOC entry 3482 (class 0 OID 19644)
-- Dependencies: 203
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY incidents (id_type, intitule) FROM stdin;
2	Tags
3	Nid de poule
6	Encombrement
7	Détritus
1	Abribus
4	Routes et trottoirs
5	Dégradation matérielle
\.


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 204
-- Name: nantes_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('nantes_gid_seq', 59, true);


--
-- TOC entry 3484 (class 0 OID 19653)
-- Dependencies: 205
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY notifications (id, id_dec, id_utilisateur) FROM stdin;
1	300	1
26	1074	1
27	1016	2
28	1074	2
5	4919	1
6	4444	1
7	46	1
8	46	3
9	1030	24
10	1030	25
11	1072	1
12	532	1
13	1030	2
14	532	24
15	1012	1
16	1012	17
17	1012	16
18	1071	16
19	1034	16
20	1069	16
21	1014	16
22	1030	16
23	532	16
24	1030	29
25	532	29
29	1040	32
30	1029	32
31	4919	32
32	1029	33
\.


--
-- TOC entry 3485 (class 0 OID 19657)
-- Dependencies: 206
-- Data for Name: personnel; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY personnel (idpers, nom, prenom, idville, login, email, role) FROM stdin;
1	Ferrari	Enzo	1	eriic	eric.chauty@capgemini.com	agent
4	Zidane	Zinedine	2	mia	eric.chauty@capgemini.com	agent
2	Vert	Géant	4	geant	\N	agent
5	admin	admin	1	admin	\N	admin
\.


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 207
-- Name: personnel_idPers_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('"personnel_idPers_seq"', 5, true);


--
-- TOC entry 3487 (class 0 OID 19665)
-- Dependencies: 208
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY photos (idphoto, iddeclaration, nom) FROM stdin;
7	300	img.png
8	300	img2.png
9	300	img3.png
10	400	img.png
11	1052	1375965614395.jpg
\.


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 209
-- Name: photos_idphoto_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('photos_idphoto_seq', 11, true);


--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 197
-- Name: serial; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('serial', 1094, true);


--
-- TOC entry 3294 (class 0 OID 16655)
-- Dependencies: 172
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 210
-- Name: trait_pkey; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('trait_pkey', 11, true);


--
-- TOC entry 3490 (class 0 OID 19675)
-- Dependencies: 211
-- Data for Name: traitement_incidents; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY traitement_incidents (p_key, id_incident, id_ville) FROM stdin;
1	1	1
2	2	1
3	3	1
4	4	1
5	5	1
6	6	1
7	7	1
8	1	2
9	2	2
11	4	2
10	3	2
\.


--
-- TOC entry 3491 (class 0 OID 19679)
-- Dependencies: 212
-- Data for Name: ville; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY ville (idville, nom) FROM stdin;
1	Nantes
2	Rennes
3	Bordeaux
4	all
\.


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 213
-- Name: ville_idVille_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('"ville_idVille_seq"', 4, true);


--
-- TOC entry 3315 (class 2606 OID 19694)
-- Name: Citoyen_pkey; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY citoyens
    ADD CONSTRAINT "Citoyen_pkey" PRIMARY KEY (id_citoyen);


--
-- TOC entry 3317 (class 2606 OID 19696)
-- Name: citoyen_login_key; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY citoyens
    ADD CONSTRAINT citoyen_login_key UNIQUE (login);


--
-- TOC entry 3325 (class 2606 OID 19698)
-- Name: communes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY communes
    ADD CONSTRAINT communes_pkey PRIMARY KEY (gid);


--
-- TOC entry 3328 (class 2606 OID 19700)
-- Name: gid; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY declaration
    ADD CONSTRAINT gid UNIQUE (gid);


--
-- TOC entry 3330 (class 2606 OID 19702)
-- Name: id_dec; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY declaration
    ADD CONSTRAINT id_dec PRIMARY KEY (gid);


--
-- TOC entry 3323 (class 2606 OID 19704)
-- Name: nantes_pkey; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY cantons
    ADD CONSTRAINT nantes_pkey PRIMARY KEY (gid);


--
-- TOC entry 3332 (class 2606 OID 19706)
-- Name: p_key; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY etats
    ADD CONSTRAINT p_key PRIMARY KEY (p_key);


--
-- TOC entry 3338 (class 2606 OID 19708)
-- Name: personnel_pkey; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY personnel
    ADD CONSTRAINT personnel_pkey PRIMARY KEY (idpers);


--
-- TOC entry 3340 (class 2606 OID 19710)
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (idphoto);


--
-- TOC entry 3321 (class 2606 OID 19712)
-- Name: pkey; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY affectations
    ADD CONSTRAINT pkey PRIMARY KEY (p_key);


--
-- TOC entry 3336 (class 2606 OID 19714)
-- Name: prim; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT prim PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 19716)
-- Name: prim_key; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY traitement_incidents
    ADD CONSTRAINT prim_key PRIMARY KEY (p_key);


--
-- TOC entry 3334 (class 2606 OID 19718)
-- Name: type; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY incidents
    ADD CONSTRAINT type PRIMARY KEY (id_type);


--
-- TOC entry 3344 (class 2606 OID 19720)
-- Name: ville_pkey; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY ville
    ADD CONSTRAINT ville_pkey PRIMARY KEY (idville);


--
-- TOC entry 3326 (class 1259 OID 19721)
-- Name: fki_idville; Type: INDEX; Schema: public; Owner: eric; Tablespace: 
--

CREATE INDEX fki_idville ON declaration USING btree (id_ville);


--
-- TOC entry 3318 (class 1259 OID 19722)
-- Name: fki_incident; Type: INDEX; Schema: public; Owner: eric; Tablespace: 
--

CREATE INDEX fki_incident ON affectations USING btree (id_type_incident);


--
-- TOC entry 3319 (class 1259 OID 19723)
-- Name: fki_type; Type: INDEX; Schema: public; Owner: eric; Tablespace: 
--

CREATE INDEX fki_type ON affectations USING btree (id_type_incident);


--
-- TOC entry 3347 (class 2606 OID 19724)
-- Name: affectation; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY declaration
    ADD CONSTRAINT affectation FOREIGN KEY (persaffectee) REFERENCES personnel(idpers);


--
-- TOC entry 3351 (class 2606 OID 19729)
-- Name: declaration; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT declaration FOREIGN KEY (id_dec) REFERENCES declaration(gid);


--
-- TOC entry 3348 (class 2606 OID 19734)
-- Name: idCitoyen; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY declaration
    ADD CONSTRAINT "idCitoyen" FOREIGN KEY (idcitoyen) REFERENCES citoyens(id_citoyen);


--
-- TOC entry 3349 (class 2606 OID 19739)
-- Name: idville; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY declaration
    ADD CONSTRAINT idville FOREIGN KEY (id_ville) REFERENCES ville(idville);


--
-- TOC entry 3345 (class 2606 OID 19744)
-- Name: incident; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY affectations
    ADD CONSTRAINT incident FOREIGN KEY (id_type_incident) REFERENCES incidents(id_type);


--
-- TOC entry 3354 (class 2606 OID 19749)
-- Name: incident; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY traitement_incidents
    ADD CONSTRAINT incident FOREIGN KEY (id_incident) REFERENCES incidents(id_type);


--
-- TOC entry 3346 (class 2606 OID 19754)
-- Name: personnel; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY affectations
    ADD CONSTRAINT personnel FOREIGN KEY (id_personnel) REFERENCES personnel(idpers);


--
-- TOC entry 3352 (class 2606 OID 19759)
-- Name: personnel_idville_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY personnel
    ADD CONSTRAINT personnel_idville_fkey FOREIGN KEY (idville) REFERENCES ville(idville);


--
-- TOC entry 3350 (class 2606 OID 19764)
-- Name: utilisateur; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT utilisateur FOREIGN KEY (id_utilisateur) REFERENCES citoyens(id_citoyen);


--
-- TOC entry 3353 (class 2606 OID 19769)
-- Name: ville; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY traitement_incidents
    ADD CONSTRAINT ville FOREIGN KEY (id_ville) REFERENCES ville(idville);


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-11-06 19:08:59 CET

--
-- PostgreSQL database dump complete
--

