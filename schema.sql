/***********************************************/
/*******    DROP      ***     V1.7      ********/
/***********************************************/
/***********************************************/
/*******    Drop Views
/***********************************************/
DROP VIEW crew_location_view;
DROP VIEW restricted_crew_view;
DROP VIEW beaminglog_view;
/***********************************************/
/*******    Drop Indexes
/***********************************************/
DROP INDEX INDEX_CREW_STATION_ID;
DROP INDEX INDEX_STATION_NAME;
DROP INDEX INDEX_LOCATION_NAME;
DROP INDEX INDEX_BEAMING_CREW_ID;
/***********************************************/
/*******    Drop Triggers
/***********************************************/
DROP TRIGGER check_authority_level;
DROP TRIGGER check_timestamp;
DROP TRIGGER check_dob;
/***********************************************/
/*******    Drop Procedures
/***********************************************/
DROP PROCEDURE Beam_Crew;
DROP PROCEDURE Change_Rank;
DROP PROCEDURE Ship_Attack;
/***********************************************/
/*******    Drop Functions
/***********************************************/
DROP FUNCTION authority_level_diff;
DROP FUNCTION station_health;
DROP FUNCTION ship_health;
DROP FUNCTION age_retrieval;
DROP FUNCTION Distance_Between_SS;
DROP FUNCTION get_location;
/***********************************************/
/*******    Drop Sequences
/***********************************************/
DROP SEQUENCE beaming_seq;
DROP SEQUENCE location_seq;
DROP SEQUENCE captainlog_seq;
DROP SEQUENCE crew_seq;
DROP SEQUENCE rank_seq;
DROP SEQUENCE subsystems_seq;
DROP SEQUENCE station_seq;
DROP SEQUENCE starsystem_seq;
DROP SEQUENCE maintenancelog_seq;
/***********************************************/
/*******    Drop Tables
/***********************************************/
DROP TABLE MAINTENANCELOG CASCADE CONSTRAINTS;
DROP TABLE BEAMING CASCADE CONSTRAINTS;
DROP TABLE LOCATION CASCADE CONSTRAINTS;
DROP TABLE CAPTAINLOG CASCADE CONSTRAINTS;
DROP TABLE CREW CASCADE CONSTRAINTS;
DROP TABLE RANK CASCADE CONSTRAINTS;
DROP TABLE SUBSYSTEMS CASCADE CONSTRAINTS;
DROP TABLE STATION CASCADE CONSTRAINTS;
DROP TABLE STARSYSTEM CASCADE CONSTRAINTS;

/***********************************************/
/*******    SCHEMA      ***     V1.7    ********/
/***********************************************/
/***********************************************/
/*******    Create Tables
/***********************************************/
CREATE TABLE STARSYSTEM
(
star_system_id NUMBER(10) NOT NULL,
name VARCHAR2(30) NOT NULL,
coordinate_x NUMBER(14,3) NOT NULL,
coordinate_y NUMBER(14,3) NOT NULL,
coordinate_z NUMBER(14,3) NOT NULL,

CONSTRAINT starsystem_pk PRIMARY KEY (star_system_id)
);

CREATE TABLE STATION 
(
station_id NUMBER(2) NOT NULL,
station_name VARCHAR(30) NOT NULL,

CONSTRAINT station_pk PRIMARY KEY (station_id)
);

CREATE TABLE SUBSYSTEMS
(
sub_systems_id NUMBER(4) NOT NULL,
sub_systems_name VARCHAR2(30) NOT NULL,
sub_systems_health NUMBER(3) NOT NULL,
sub_systems_active CHAR(1),
station_id NUMBER(2),

CONSTRAINT subsystems_pk PRIMARY KEY (sub_systems_id),
CONSTRAINT subsystems_check_health CHECK (sub_systems_health BETWEEN 0 and 100),
CONSTRAINT subsystems_station_fk FOREIGN KEY ( station_id ) REFERENCES STATION (station_id)

);

CREATE TABLE RANK
(
rank_id NUMBER(2) NOT NULL,
rank_name VARCHAR2(30) NOT NULL,
authority_level NUMBER(2) NOT NULL,

CONSTRAINT rank_pk PRIMARY KEY (rank_id)
);

CREATE TABLE CREW 
(
crew_id NUMBER(5) NOT NULL,
first_name VARCHAR2(30),
last_name VARCHAR2(30) NOT NULL,
dob DATE NOT NULL,
crew_station_id NUMBER(2),
role_name VARCHAR2(30) NOT NULL,
crew_rank_id NUMBER(2) NOT NULL,
active CHAR(1) NOT NULL,

CONSTRAINT crew_pk PRIMARY KEY (crew_id),
CONSTRAINT crew_station_fk FOREIGN KEY(crew_station_id) REFERENCES STATION(station_id),
CONSTRAINT crew_rank_fk FOREIGN KEY(crew_rank_id) REFERENCES RANK (rank_id),
CONSTRAINT crew_check_active CHECK (UPPER(active) = 'Y' OR UPPER(active) = 'N') 
);

CREATE TABLE CAPTAINLOG
(
log_id NUMBER(6) NOT NULL,
entry_timestamp TIMESTAMP NOT NULL,
title VARCHAR2(50) NOT NULL,
message VARCHAR2(1500),
crew_id NUMBER(5),

CONSTRAINT captainlog_log_pk PRIMARY KEY (log_id),
CONSTRAINT captainlog_crew_fk FOREIGN KEY (crew_id) REFERENCES CREW (crew_id)
);

CREATE TABLE LOCATION
(
location_id NUMBER(10) NOT NULL,
location_name VARCHAR2(30) NOT NULL,
star_system_id NUMBER(10),

CONSTRAINT location_pk PRIMARY KEY (location_id),
CONSTRAINT location_star_system_fk  FOREIGN KEY ( star_system_id ) REFERENCES STARSYSTEM (star_system_id)
);

CREATE TABLE BEAMING
(
beaming_id NUMBER(6) NOT NULL,
return_beam CHAR(1) NOT NULL,
location_id NUMBER(10) NOT NULL,
crew_id NUMBER(5) NOT NULL,
beam_timestamp TIMESTAMP(1) NOT NULL,

CONSTRAINT beaming_pk PRIMARY KEY (beaming_id),
CONSTRAINT beaming_location_fk FOREIGN KEY(location_id) REFERENCES LOCATION (location_id),
CONSTRAINT beaming_crew_fk FOREIGN KEY (crew_id) REFERENCES CREW (crew_id),
CONSTRAINT beaming_check_return_beam CHECK (UPPER(return_beam) = 'Y' OR UPPER(return_beam) = 'N') 
);

CREATE TABLE MAINTENANCELOG
(
maintenance_id NUMBER(6) NOT NULL,
timestamp_reported TIMESTAMP(1),
maintenance_title VARCHAR2(50) NOT NULL,
maintenance_message VARCHAR2(1000),
reporter_crew_id NUMBER(5),
issue_resolved CHAR(1) NOT NULL,

CONSTRAINT maintenancelog_pk PRIMARY KEY (maintenance_id),
CONSTRAINT maintenancelog_crew_fk FOREIGN KEY (reporter_crew_id) REFERENCES CREW (crew_id),
CONSTRAINT maintenancelog_check_resolved CHECK (UPPER(issue_resolved) = 'Y' OR UPPER(issue_resolved) = 'N') 
);

/***********************************************/
/*******    Create Sequences
/***********************************************/
CREATE SEQUENCE starsystem_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE station_seq
	START WITH 1
	INCREMENT BY 1;
	
CREATE SEQUENCE subsystems_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE rank_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE crew_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE captainlog_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE location_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE beaming_seq
	START WITH 1
	INCREMENT BY 1;
	
CREATE SEQUENCE maintenancelog_seq
	START WITH 1
	INCREMENT BY 1;
/***********************************************/
/*******    Insert into Star Systems table
/***********************************************/
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Solar System', 0, 0, 0);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Alpha Centauri', 100, 100, 100);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Alnitak', 155, 75, 0);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Andromeda', 100, -250, 50);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Gamma Velorum', 60.5, 30.7, 22.123);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Alpha Serpentis', -100, -100, -100);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Lambda Scorpii', 0, -35.512, 0);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Epsilon Indi', 12345678901.345, 10000000000, 987456);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Nu Scorpii', 15000, 75896, -15739);
INSERT INTO STARSYSTEM (STAR_SYSTEM_ID, NAME, COORDINATE_X, COORDINATE_Y, COORDINATE_Z)
		VALUES (starsystem_seq.NEXTVAL, 'Alpha Herculis', -10000000000, 99999999999.999, -15000000001.52);
/***********************************************/
/*******    Insert into Station table
/***********************************************/
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'CAPTAIN DUTY STATION');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'NAVIGATION');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'COMMUNICATIONS');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'SCIENCE');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'SECURITY');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'ENGINEERING');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'EVACUATION');
INSERT INTO STATION (station_id, station_name)
		VALUES (station_seq.NEXTVAL,'MEDICAL');
/***********************************************/
/*******    Insert into Rank table   
/***********************************************/
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'UNRANKED', 2);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'RECRUIT', 5);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CREWMAN FIRST CLASS', 10);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CREWMAN SECOND CLASS', 12);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CREWMAN THIRD CLASS', 14);	
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'PETTY OFFICER FIRST CLASS', 16);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'PETTY OFFICER SECOND CLASS', 18);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'PETTY OFFICER THIRD CLASS', 20);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CHIEF PETTY OFFICER', 22);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'SENIOR CHIEF PETTY OFFICER', 24);
		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'MASTER CHIEF PETTY OFFICER', 26);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CADET FIRST CLASS', 30);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CADET SECOND CLASS', 32);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CADET THIRD CLASS', 34);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CADET FOURTH CLASS', 36);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'ENSIGN', 50);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'LIEUTENANT JUNIOR GRADE', 52);	
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'LIEUTENANT', 60);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'LIEUTENANT COMMANDER', 62);			
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'COMMANDER', 65);
		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'CAPTAIN', 70);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'COMMODORE', 80);		
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'REAR ADMIRAL', 83);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'VICE ADMIRAL', 86);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'ADMIRAL', 89);
INSERT INTO RANK (rank_id, rank_name, authority_level)
    	VALUES (rank_seq.NEXTVAL,'FLEET ADMIRAL', 92);
/***********************************************/
/*******    Insert into Crew table   
/***********************************************/
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'James','Kirk', DATE '1976-11-11','8','Acting Captain','21','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL, NULL,'Spock', DATE '1966-04-30','8','Science Officer','20','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Allen','Crosby', DATE '1984-05-21','4','Mechanical Engineer','15','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Liberty','Ballard', DATE '1963-07-16','1','Tactical Officer','19','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Oren','Crawford', DATE '1960-01-11','2','Network Engineer','17','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Shaine','Wade', DATE '1967-08-28','7','Geological Engineer','4','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Calvin','Flowers', DATE '1973-10-26','7','Operator','17','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Emmanuel','Winters', DATE '1963-04-20','3','Armory Officer','2','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Shellie','Moore', DATE '1964-09-23','6','Analyst','11','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Indigo','Mullen', DATE '1988-04-22','1','Electronics Engineer','14','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Jorden','Meyer', DATE '1978-08-26','4','Operator','15','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Geoffrey','Rhodes', DATE '1969-10-03','6','Flight Officer','19','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Ila','Wood', DATE '1970-09-02','7','Mechanical Engineer','1','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Martena','Schneider', DATE '1981-05-11','7','Operator','19','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Noel','Maynard', DATE '1995-08-21','2','Flight Officer','3','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Luke','Hughes', DATE '1980-12-10','4','Doctor','14','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL, NULL,'Collier', DATE '1974-04-01','5','Flight Officer','14','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Helen','Carey', DATE '1972-12-04','6','Nurse','18','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Len','Christian', DATE '1982-08-23','4','Security Officer','10','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Lyle','Newman', DATE '1970-06-28','4','Analyst','15','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Tiger','Sampson', DATE '1983-06-01','7','Translator','6','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Alma','Hays', DATE '1970-01-06','6','Armory Officer','10','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL, NULL,'Nunez', DATE '1987-02-12','8','Translator','2','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Brent','Cantrell', DATE '1963-11-29','2','Electronics Engineer','11','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Arsenio','Decker', DATE '1991-10-08','8','Flight Officer','8','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Erasmus','Joseph', DATE '1981-02-15','8','Electronics Engineer','12','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Tamekah','Abbott', DATE '1978-07-25','1','Intelligence Officer','8','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Ashely','Curtis', DATE '1996-10-12','1','Communications Officer','1','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Cameron','Mercer', DATE '1975-05-28','3','Security Officer','3','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Chaney','Mitchell', DATE '1970-04-03','5','Communications Officer','4','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Brynne','Bond', DATE '1975-08-15','2','Translator','19','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Robert','Zamora', DATE '1978-10-04','5','Chemist','10','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Gisela','Hancock', DATE '1974-01-27','4','Geological Engineer','8','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Forrest','Mcdonald', DATE '1983-10-20','2','Chemist','5','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Tanner','Padilla', DATE '1996-12-10','3','Electronics Engineer','1','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Keaton','Martin', DATE '1991-02-20','7','Weapons Specialist','7','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL, NULL,'Murray', DATE '1983-11-17','4','Intelligence Officer','12','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Rigel','Ochoa', DATE '1976-07-20','7','Security Officer','14','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Freya','Rosa', DATE '1987-07-14','5','Weapons Specialist','12','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Gemma','Burton', DATE '1968-02-28','3','Operator','16','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Magee','Bailey', DATE '1973-11-10','4','Intelligence Officer','4','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Urielle','Burt', DATE '1975-06-02','6','Weapons Specialist','9','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Chiquita','Robinson', DATE '1982-09-22','6','Flight Officer','7','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Alexis','Calderon', DATE '1964-08-03','7','Analyst','14','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Kenyon','Harris', DATE '1970-07-07','1','Chemist','17','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Ciaran','Key', DATE '1993-07-05','8','Intelligence Officer','19','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Stuart','Garrison', DATE '1993-06-12','7','Nurse','8','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Rahim','Bowman', DATE '1981-05-17','7','Translator','2','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Kaye','Morales', DATE '1983-09-13','6','Translator','14','Y');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Byron','Hammond', DATE '1987-05-20','6','Translator','4','N');
INSERT INTO CREW (crew_id,first_name,last_name,dob,crew_station_id,role_name,crew_rank_id,active) VALUES (crew_seq.NEXTVAL,'Kirestin','Lowe', DATE '1964-01-30','6','Intelligence Officer','3','Y');
/***********************************************/
/*******    Insert into Location table
/***********************************************/
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'Earth', 1);
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'Mars', 1);
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'Proxima Centauri b', 2);
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'PSR B1620-26 b', 4);	
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'Epsilon Eridani ', 5);	
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, '91 Aquarii b', 3);	
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'HD 209458 b', 7);	
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'Gliese 876 b', 9);
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'V391 Pegasi b', 6);
INSERT INTO LOCATION (location_id, location_name, star_system_id)
	VALUES (location_seq.NEXTVAL, 'Fomalhaut b', 10);
/***********************************************/
/*******    Insert into Sub-System table   
/***********************************************/
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'SHIELDS CONTROL','100','N','5');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'EXOTIC PARTICLE GENERATOR','100','N','4');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'DRAIN EXPERTISE','100','N','4');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'ENGINE FLOW REGULATOR','100','N','6');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'MAINTENANCE EQUIPMENT','100','N','6');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'CLOAK CONTROL','100','N','4');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'SUB-SPACE COMMUNICATION','100','N','3');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'ASTROGATOR','100','N','2');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'ESCAPE POD','100','N','7');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'COCKPIT','100','N','1');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'TREATMENT AREA','100','N','8');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'SURGERY AREA','100','N','8');
INSERT INTO SUBSYSTEMS (sub_systems_id, sub_systems_name, sub_systems_health, sub_systems_active, station_id)
    	VALUES (subsystems_seq.NEXTVAL,'SELF DEFENSE MECHANISM','100','N','5');
/***********************************************/
/*******    Insert into Captain's Log table   
/***********************************************/
INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
	VALUES (captainlog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-01 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Start of Mission', 'We have begun our five year mission to explore strange new worlds; to seek out new life; and new civilizations, to boldly go where no man has gone before', 1);
INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
	VALUES (captainlog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-01 06:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Forgot Something', 'Somone left something behind and has been transported back to earth to get it', 1);
INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
	VALUES (captainlog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-01 06:30:30', 'YYYY-MM-DD HH24:MI:SS'), 'Crew member back abored', 'I have been informed they are now back', 1);
INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
	VALUES (captainlog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-01 09:18:46', 'YYYY-MM-DD HH24:MI:SS'), 'Mars', 'Somone has gone to check out the Mars base', 1);
INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
	VALUES (captainlog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-01 22:42:34', 'YYYY-MM-DD HH24:MI:SS'), 'End of Day 1', 'It is the end of the first day, everything is going well so far', 1);
INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
	VALUES (captainlog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-02 05:55:00', 'YYYY-MM-DD HH24:MI:SS'), 'Start of Day 2', 'It is the start of a new day, nothing eventful happened in the night, lets see how today goes', 1);
/***********************************************/
/*******    Insert into Beaming Table   
/***********************************************/
INSERT INTO BEAMING (beaming_id, return_beam, location_id, crew_id, beam_timestamp)
	VALUES (beaming_seq.NEXTVAL, 'N', 1, 1, TO_TIMESTAMP('2019-01-01 06:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO BEAMING (beaming_id, return_beam, location_id, crew_id, beam_timestamp)
	VALUES (beaming_seq.NEXTVAL, 'Y', 1, 1, TO_TIMESTAMP('2019-01-01 06:27:16', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO BEAMING (beaming_id, return_beam, location_id, crew_id, beam_timestamp)
	VALUES (beaming_seq.NEXTVAL, 'N', 2, 4, TO_TIMESTAMP('2019-01-01 09:17:35', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO BEAMING (beaming_id, return_beam, location_id, crew_id, beam_timestamp)
	VALUES (beaming_seq.NEXTVAL, 'N', 3, 10, TO_TIMESTAMP('2019-01-03 17:54:47', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO BEAMING (beaming_id, return_beam, location_id, crew_id, beam_timestamp)
	VALUES (beaming_seq.NEXTVAL, 'Y', 2, 4, TO_TIMESTAMP('2019-01-03 09:17:35', 'YYYY-MM-DD HH24:MI:SS'));
/***********************************************/
/*******    Insert into Maintenancelog Table   
/***********************************************/
INSERT INTO MAINTENANCELOG (maintenance_id, timestamp_reported, maintenance_title, maintenance_message, reporter_crew_id, issue_resolved)
	VALUES (maintenancelog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-02 11:46:54', 'YYYY-MM-DD HH24:MI:SS'), 'Broken Dial', 'The Speed Dial on the bridge is reading only 0', 1,'Y');
INSERT INTO MAINTENANCELOG (maintenance_id, timestamp_reported, maintenance_title, maintenance_message, reporter_crew_id, issue_resolved)
	VALUES (maintenancelog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-02 13:59:22', 'YYYY-MM-DD HH24:MI:SS'), 'Door handle fell off', 'The handle on the door to room 215b came off in my hand', 4,'Y');
INSERT INTO MAINTENANCELOG (maintenance_id, timestamp_reported, maintenance_title, maintenance_message, reporter_crew_id, issue_resolved)
	VALUES (maintenancelog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-03 10:27:43', 'YYYY-MM-DD HH24:MI:SS'), 'Port Engine Broken', 'The port engine warning light came on followed shortly after by a complete loss of power', 1,'N');
INSERT INTO MAINTENANCELOG (maintenance_id, timestamp_reported, maintenance_title, maintenance_message, reporter_crew_id, issue_resolved)
	VALUES (maintenancelog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-06 13:47:15', 'YYYY-MM-DD HH24:MI:SS'), 'Airlock 26 Jammed', 'The outer door of Port Airlock #23 has become jammed open.', 3,'Y');
INSERT INTO MAINTENANCELOG (maintenance_id, timestamp_reported, maintenance_title, maintenance_message, reporter_crew_id, issue_resolved)
	VALUES (maintenancelog_seq.NEXTVAL, TO_TIMESTAMP('2019-01-03 10:27:43', 'YYYY-MM-DD HH24:MI:SS'), 'Landing Lights not working', 'The landing lights in the main hanger keep flickering on and off.', 7,'N');	
/***********************************************/
/*******    Functions   
/***********************************************/
/***********************************************/
/*******    authority_level_diff   
/***********************************************/
CREATE OR REPLACE FUNCTION authority_level_diff(p_crew_id IN CREW.crew_id%TYPE, p_rank_id IN RANK.rank_id%TYPE)
RETURN NUMBER IS 
auth_diff NUMBER;
crew_auth_lvl RANK.authority_level%TYPE; 
rank_auth_lvl RANK.authority_level%TYPE; 
crew_rank_id CREW.crew_rank_id%TYPE;  
	
BEGIN

	SELECT authority_level
	INTO rank_auth_lvl
	FROM RANK
	WHERE Rank.rank_id = p_rank_id;

	SELECT authority_level
	INTO crew_auth_lvl
	FROM RANK r
	INNER JOIN CREW c
	ON r.rank_id = c.crew_rank_id
	AND c.crew_id = p_crew_id;
                        	
    RETURN (crew_auth_lvl - rank_auth_lvl);
END; 
/
/***********************************************/
/*******    station_health   
/***********************************************/
create or replace FUNCTION Station_health (p_station_id IN Station.station_id%TYPE)  
RETURN subsystems.sub_systems_health%TYPE IS 
health subsystems.sub_systems_health%TYPE; 
BEGIN 

    SELECT AVG(sub_systems_health)
	INTO health
	FROM SUBSYSTEMS s  
	WHERE s.station_id = p_station_id;
	
	IF(health <= 100 AND health >= 0) THEN
	    RETURN health;
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	    dbms_output.put_line('Error with the calculated health of station(' || p_station_id || ') = ' || health);
	RETURN NULL;
END; 
/
/***********************************************/
/*******    ship_health   
/***********************************************/
CREATE OR REPLACE FUNCTION Ship_Health
RETURN SUBSYSTEMS.sub_systems_health%TYPE IS 
health NUMBER; 
stn_count NUMBER;
CURSOR stations_cur 
IS
	SELECT Station.station_id
	FROM station;
BEGIN
	health := 0;
	FOR stn IN stations_cur 
	LOOP
	    health := health + Station_Health(stn.station_id);
		stn_count := stations_cur%ROWCOUNT;
	END LOOP;
    health := (health / stn_count);
    IF(health <= 100 AND health >= 0) THEN
        RETURN health;
    END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	    dbms_output.put_line('Error with the calculated health of ship = ' || health);
	RETURN NULL;
END; 
/
/***********************************************/
/*******    age_retrieval   
/***********************************************/
CREATE OR REPLACE FUNCTION age_retrieval (c_id CREW.crew_id%TYPE)
RETURN NUMBER IS
age NUMBER;
v_dob CREW.dob%TYPE;
BEGIN
   SELECT dob
   INTO v_dob
   FROM CREW
   WHERE crew_id = c_id;
   age := trunc(months_between(sysdate,v_dob)/12);
   RETURN age;
END;
/
/***********************************************/
/*******    Distance_Between_SS   
/***********************************************/
CREATE OR REPLACE FUNCTION Distance_Between_SS (SS1_ID STARSYSTEM.star_system_id%TYPE, SS2_ID STARSYSTEM.star_system_id%TYPE) 
RETURN NUMBER IS
    SS1_X STARSYSTEM.coordinate_x%TYPE;
    SS1_Y STARSYSTEM.coordinate_y%TYPE;
    SS1_Z STARSYSTEM.coordinate_z%TYPE;
    SS2_X STARSYSTEM.coordinate_x%TYPE;
    SS2_Y STARSYSTEM.coordinate_y%TYPE;
    SS2_Z STARSYSTEM.coordinate_z%TYPE;
BEGIN
	SELECT coordinate_x, coordinate_y, coordinate_z 
	INTO SS1_X, SS1_Y, SS1_Z 
	FROM STARSYSTEM
	WHERE star_system_id = SS1_ID;
	
	SELECT coordinate_x, coordinate_y, coordinate_z 
	INTO SS2_X, SS2_Y, SS2_Z 
	FROM STARSYSTEM
	WHERE star_system_id = SS2_ID;
	
	RETURN POWER(POWER((SS2_X - SS1_X),2) + POWER((SS2_Y - SS1_Y),2) + POWER((SS2_Z - SS1_Z),2),0.5);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	dbms_output.put_line('Error star system ID not found');
	RETURN NULL;
END;
/
/***********************************************/
/*******    get_location    
/***********************************************/
CREATE OR REPLACE FUNCTION get_location ( p_crew_id CREW.crew_id%TYPE )
RETURN VARCHAR2 IS
    v_returning BEAMING.return_beam%TYPE;
    v_station_name STATION.station_name%TYPE;
    v_location_name LOCATION.location_name%TYPE;
    v_location_id LOCATION.location_id%TYPE;
    CURSOR station_cur 
    IS 
    	SELECT station_name
    	FROM STATION s
    	INNER JOIN CREW c
    	ON s.station_id = c.crew_station_id AND c.crew_id = p_crew_id;
    						
    CURSOR beam_cur(c_crew_id NUMBER) 
    IS 
    	SELECT return_beam, location_id 
    	FROM BEAMING
    	INNER JOIN (
    	    SELECT crew_id, MAX(beam_timestamp) ts
    		FROM BEAMING
    		GROUP BY crew_id
    	) latest_beam ON BEAMING.crew_id = latest_beam.crew_id 
    	    AND BEAMING.crew_id = c_crew_id
    	    AND BEAMING.beam_timestamp = latest_beam.ts;
BEGIN
	
    IF NOT beam_cur%ISOPEN THEN
        OPEN beam_cur(p_crew_id);
	END IF;
	
	IF NOT station_cur%ISOPEN THEN
		OPEN station_cur;
	END IF;
	
	FETCH station_cur INTO v_station_name;
	FETCH beam_cur INTO v_returning, v_location_id;
	
	IF beam_cur%FOUND THEN
    	
    	SELECT location_name 
    	INTO v_location_name
    	FROM LOCATION
    	WHERE location_id = v_location_id;
    	
		IF v_returning = 'Y' THEN 
			RETURN v_station_name;
		ELSE
			RETURN v_location_name;
		END IF;
	ELSE 
		RETURN v_station_name; 
	END IF;
END;
/
/***********************************************/
/*******    Procedures   
/***********************************************/
/***********************************************/
/*******    Beam_Crew   
/***********************************************/
CREATE OR REPLACE PROCEDURE Beam_Crew (crewid NUMBER, isreturning CHAR, locationid NUMBER) AS
	time_now TIMESTAMP;
BEGIN  
	IF (UPPER(isreturning) !='Y' AND UPPER(isreturning) !='N') THEN
		dbms_output.put_line('ERROR: Returning must be Y or N');  
	ELSE
	time_now := LOCALTIMESTAMP;  
	INSERT INTO BEAMING (beaming_id, return_beam, location_id, crew_id, beam_timestamp)  
		VALUES (beaming_seq.NEXTVAL, isreturning, locationid, crewid, time_now);  
    END IF;
END;
/
/***********************************************/
/*******    Change_Rank   
/***********************************************/
CREATE OR REPLACE PROCEDURE Change_Rank (p_crew_id IN CREW.crew_id%TYPE, p_rank_id IN RANK.rank_id%TYPE) AS
	v_auth_diff NUMBER;
	v_outcome VARCHAR2(10);
	v_crew_name CREW.last_name%TYPE;
BEGIN  
	v_auth_diff := authority_level_diff(p_crew_id, p_rank_id);
	
	SELECT last_name
	INTO v_crew_name 
	FROM CREW
	WHERE Crew.crew_id = p_crew_id;
	
	IF(v_auth_diff != 0) THEN
		IF(v_auth_diff > 0) THEN
			v_outcome := 'Promoted';
		ELSE
			v_outcome := 'Demoted';
		END IF;
		
		UPDATE CREW
				SET crew_rank_id = p_rank_id
				WHERE crew_id = p_crew_id;
				
		INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
			VALUES (captainlog_seq.NEXTVAL, CURRENT_TIMESTAMP, 'Crew Member (' || v_crew_name || ') has been ' || v_outcome, 'Member of the crews rank was changed', p_crew_id);
			
	ELSE
		dbms_output.put_line('Crew member cannot be changed to rank they currently are.');
	END IF;
END;
/
/***********************************************/
/*******    Attack_Ship   
/***********************************************/
CREATE OR REPLACE PROCEDURE ship_attack AS
	attack_time TIMESTAMP;
	crew_num NUMBER(5);
	station_security CONSTANT STATION.station_name%TYPE	:= 'SECURITY'; 
	station_evacuation CONSTANT STATION.station_name%TYPE	:= 'EVACUATION'; 
BEGIN
	attack_time := LOCALTIMESTAMP;  

	SELECT COUNT(*)
	INTO crew_num
	FROM CREW
	WHERE active = 'Y';
	
	INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
			VALUES (captainlog_seq.NEXTVAL, attack_time, 'AUTOMATED MESSAGE: Ship Attacked',
			'THIS IS AN AUTOMATED MESSAGE: At ' || attack_time || ' an attack on the ship was reported. At the time of attack the integrity of the ship is ' 
			|| ship_health || ' and there are ' || crew_num || ' active crew members.', NULL);
	
	UPDATE SUBSYSTEMS
	SET sub_systems_active = 'Y'
	WHERE station_id = (SELECT station_id FROM STATION WHERE station_name = station_security);

	IF(Ship_health < 20) THEN
		UPDATE SUBSYSTEMS
		SET sub_systems_active = 'Y'
		WHERE station_id = (SELECT station_id FROM STATION WHERE station_name = station_evacuation);
		
		INSERT INTO CAPTAINLOG (log_id, entry_timestamp, title, message, crew_id)
			VALUES (captainlog_seq.NEXTVAL, LOCALTIMESTAMP, 'AUTOMATED MESSAGE: Ship Integrity has been detected as LOW',
			'THIS IS AN AUTOMATED MESSAGE: At ' || LOCALTIMESTAMP || ': Ship Integrity has been detected as LOW, please follow emergency procedure', NULL);
	END IF;
END;
/	
/***********************************************/
/*******    Triggers   
/***********************************************/
/***********************************************/
/*******    check_authority_level   
/***********************************************/
CREATE OR REPLACE TRIGGER check_authority_level
    BEFORE INSERT OR UPDATE ON CAPTAINLOG
    FOR EACH ROW
DECLARE
    v_cpt_rank RANK.rank_id%TYPE;
	V_cpt_rank_name CONSTANT RANK.rank_name%TYPE := 'CAPTAIN'; 
BEGIN
    SELECT rank_id
    INTO v_cpt_rank
    FROM RANK
    WHERE Rank.rank_name = V_cpt_rank_name;
    
    IF(authority_level_diff(:new.crew_id, v_cpt_rank) < 0) THEN
        RAISE_APPLICATION_ERROR( -20001, 'Crew Member does not have high enough rank to perform entry into the Captains Log.' );
    END IF;
END;
/
/***********************************************/
/*******    check_timestamp   
/***********************************************/	
CREATE OR REPLACE TRIGGER check_timestamp
  BEFORE INSERT OR UPDATE ON BEAMING
  FOR EACH ROW
BEGIN
  IF( :new.beam_timestamp > systimestamp )
  THEN
    RAISE_APPLICATION_ERROR( -20002, 'Beam timestamp must be in the past or present' );
  END IF;
END;
/
/***********************************************/
/*******    check_dob   
/***********************************************/	
CREATE OR REPLACE TRIGGER check_dob
  BEFORE INSERT OR UPDATE ON CREW
  FOR EACH ROW
BEGIN
  IF( :new.dob > sysdate )
  THEN
    RAISE_APPLICATION_ERROR( -20003, 'DOB must be in the past or present' );
  END IF;
END;
/
/***********************************************/
/*******    INDEXES   
/***********************************************/	
CREATE INDEX INDEX_CREW_STATION_ID ON CREW (crew_station_id);
CREATE INDEX INDEX_STATION_NAME ON STATION (station_name);
CREATE INDEX INDEX_LOCATION_NAME ON LOCATION (location_name);
CREATE INDEX INDEX_BEAMING_CREW_ID ON BEAMING (crew_id);

/***********************************************/
/*******    VIEWS   
/***********************************************/	
CREATE VIEW beaminglog_view AS
	SELECT b.beaming_id, c.last_name, l.location_name location, b.return_beam, b.beam_timestamp
	FROM BEAMING b
	INNER JOIN LOCATION l ON b.location_id = l.location_id
	INNER JOIN CREW c ON c.crew_id = b.crew_id;

CREATE VIEW restricted_crew_view AS
	SELECT c.crew_id, c.first_name, c.last_name, r.rank_name, c.role_name
	FROM CREW c
	JOIN RANK r ON r.rank_id = c.crew_rank_id;

CREATE VIEW crew_location_view AS
	SELECT c.crew_id, c.first_name, c.last_name, r.rank_name Rank, get_location(c.crew_id) location
	FROM CREW c
	JOIN RANK r ON r.rank_id = c.crew_rank_id;
	
/***********************************************/
/*******    ACCESS CONTROL    V1.7      ********/
/***********************************************/

/* Create Roles */
CREATE ROLE shipcaptain;
CREATE ROLE beamoperator;
CREATE ROLE personnelmgr;
CREATE ROLE technicalofficer;


/* shipcaptain permissions */
GRANT SELECT ON restricted_crew_location TO shipcaptain;
GRANT SELECT ON crew_location_view TO shipcaptain;
GRANT SELECT ON beaminglog_view TO shipcaptain;

GRANT SELECT, INSERT, UPDATE, DELETE ON BEAMING TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON LOCATION TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON CAPTAINLOG TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON CREW TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON RANK TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON SUBSYSTEMS TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON STATION TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON STARSYSTEM TO shipcaptain;
GRANT SELECT, INSERT, UPDATE, DELETE ON MAINTENANCELOG TO shipcaptain;

GRANT EXECUTE ON Beam_Crew  TO shipcaptain;
GRANT EXECUTE ON change_rank  TO shipcaptain;
GRANT EXECUTE ON ship_attack  TO shipcaptain;
GRANT EXECUTE ON get_location  TO shipcaptain;
GRANT EXECUTE ON age_retrieval  TO shipcaptain;
GRANT EXECUTE ON Distance_Between_SS TO shipcaptain;
GRANT EXECUTE ON change_rank  TO shipcaptain;
GRANT EXECUTE ON Ship_Health  TO shipcaptain;
GRANT EXECUTE ON Station_health  TO shipcaptain; 
GRANT EXECUTE ON authority_level_diff  TO shipcaptain;

GRANT USAGE ON starsystem_seq TO shipcaptain;
GRANT USAGE ON station_seq TO shipcaptain;
GRANT USAGE ON subsystems_seq TO shipcaptain;
GRANT USAGE ON rank_seq TO shipcaptain;
GRANT USAGE ON crew_seq TO shipcaptain;
GRANT USAGE ON captainlog_seq TO shipcaptain;
GRANT USAGE ON location_seq TO shipcaptain;
GRANT USAGE ON beaming_seq TO shipcaptain;
GRANT USAGE ON maintenancelog_seq TO shipcaptain;


/* beamoperator permissions */
GRANT SELECT ON restricted_crew_view TO beamoperator;
GRANT SELECT ON crew_location_view TO beamoperator;
GRANT SELECT ON beaminglog_view TO beamoperator;
GRANT SELECT ON STATION TO beamoperator;
GRANT SELECT ON SUBSYSTEMS TO beamoperator;
GRANT SELECT, INSERT, UPDATE, DELETE ON BEAMING TO beamoperator;
GRANT SELECT, INSERT, UPDATE, DELETE ON LOCATION TO beamoperator;
GRANT SELECT, INSERT, UPDATE, DELETE ON STARSYSTEM TO beamoperator;
GRANT SELECT, INSERT, UPDATE, DELETE ON MAINTENANCELOG TO beamoperator;

GRANT EXECUTE ON Beam_Crew  TO beamoperator;
GRANT EXECUTE ON Distance_Between_SS TO beamoperator;
GRANT EXECUTE ON get_location  TO beamoperator;

GRANT USAGE ON starsystem_seq TO beamoperator;
GRANT USAGE ON location_seq TO beamoperator;
GRANT USAGE ON beaming_seq TO beamoperator;
GRANT USAGE ON maintenancelog_seq TO beamoperator;


/* personnelmgr permissions */
GRANT SELECT ON restricted_crew_view TO beamoperator;
GRANT SELECT ON crew_location_view TO beamoperator;
GRANT SELECT ON beaminglog_view TO beamoperator;
GRANT SELECT, INSERT, UPDATE, DELETE ON CREW TO personnelmgr;
GRANT SELECT, INSERT, UPDATE, DELETE ON RANK TO personnelmgr;
GRANT SELECT, INSERT, UPDATE, DELETE ON MAINTENANCELOG TO personnelmgr;
GRANT SELECT ON BEAMING TO personnelmgr;
GRANT SELECT ON LOCATION TO personnelmgr;
GRANT SELECT ON STARSYSTEM TO personnelmgr;

GRANT EXECUTE ON age_retrieval  TO personnelmgr;
GRANT EXECUTE ON get_location  TO personnelmgr;
GRANT EXECUTE ON change_rank  TO personnelmgr;

GRANT USAGE ON rank_seq TO personnelmgr;
GRANT USAGE ON crew_seq TO personnelmgr;
GRANT USAGE ON maintenancelog_seq TO personnelmgr;


/* technicalofficer permissions */
GRANT SELECT ON restricted_crew_view TO technicalofficer;
GRANT SELECT ON STATION TO technicalofficer;
GRANT SELECT, INSERT, UPDATE, DELETE ON SUBSYSTEMS TO technicalofficer;
GRANT SELECT, INSERT, UPDATE, DELETE ON LOCATIONS TO technicalofficer;
GRANT SELECT, INSERT, UPDATE, DELETE ON STARSYSTEM TO technicalofficer;
GRANT SELECT, INSERT, UPDATE, DELETE ON MAINTENANCELOG TO technicalofficer;

GRANT EXECUTE ON Station_health  TO technicalofficer; 
GRANT EXECUTE ON Ship_Health  TO technicalofficer; 
GRANT EXECUTE ON Distance_Between_SS TO technicalofficer;
GRANT EXECUTE ON get_location  TO technicalofficer;
GRANT EXECUTE ON ship_attack  TO technicalofficer;

GRANT USAGE ON starsystem_seq TO technicalofficer;
GRANT USAGE ON subsystems_seq TO technicalofficer;
GRANT USAGE ON location_seq TO technicalofficer;
GRANT USAGE ON maintenancelog_seq TO technicalofficer;	
	
	
	
	
	
	
	