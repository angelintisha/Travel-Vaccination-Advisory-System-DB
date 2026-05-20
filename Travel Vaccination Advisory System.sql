/*
i) Travel Vaccination Advisory System, ISMG 6080 Database Management System, Spring 2026
ii) Project Group 2, Angelin Tisha
iii) ORAPRJ31
iv) List of tables, attributes, pk, fk:

COUNTRY:(CID, CNAME)
PK = CID

DISEASE:(DID, DNAME, DESCRIP)
PK = DID

TRAVELER:(TRID, FNAME, LNAME, DOB, SEX, EMAIL, PHONE)
PK = TRID

TRIP:(TPID, STARTDATE, ENDDATE, TRIPSTATUS, TRAVELPURPOSE, CID)
PK = TPID 
FK = CID

VACCINE:(VID, VNAME, VCOVERAGE, DID)
PK = VID 
FK = DID

AdvisoryRule:(RID, RISKSCORE, RDATE, RTYPE, NOTES, CID, DID)
PK = RID 
FK = CID, DID

RptedCase:(RCID, RCDATE, DID, CID, CASES, SEVERITY)
PK = RCID 
FK = DID, CID

AdvisoryRpt:(ARID, SUMMARYNOTES, ARDATE, FEE, TPID)
PK = ARID 
FK = TPID

TravelerOnTrip:(TPID, TRID)
PK = TPID, TRID
FK = TPID, TRID

ReportItem:(RIID, RITYPE, REASON, ARID, VID)
PK = RIID 
FK = ARID, VID

v) Note: Based on instructor feedback, the Stage 2 aggregate disease reporting design was revised in Stage 3. 
RptedCase stores individual disease reporting events using RCDATE, CASES, and SEVERITY instead of yearly aggregate totals.
*/

----------------------------------------------------------------------------------
Drop table country cascade constraints;
Drop table disease cascade constraints;
Drop table traveler cascade constraints;
Drop table trip cascade constraints;
Drop table vaccine cascade constraints;
Drop table AdvisoryRule cascade constraints;
Drop table RptedCase cascade constraints;
Drop table AdvisoryRpt cascade constraints;
Drop table TravelerOnTrip cascade constraints;
Drop table ReportItem cascade constraints;

Purge RecycleBin; 

CREATE TABLE COUNTRY (
 CID                 VARCHAR2(10) NOT NULL,
 CNAME               VARCHAR2(50),
 CONSTRAINT COUNTRY_CID_PK PRIMARY KEY (CID));
INSERT INTO COUNTRY VALUES ('C11','Ghana');
INSERT INTO COUNTRY VALUES ('C12','Kenya');
INSERT INTO COUNTRY VALUES ('C13','Thailand');
INSERT INTO COUNTRY VALUES ('C14','Vietnam');
INSERT INTO COUNTRY VALUES ('C15','Peru');

CREATE TABLE DISEASE (
 DID                 VARCHAR2(10) NOT NULL,
 DNAME               VARCHAR2(50),
 DESCRIP             VARCHAR2(500),
 CONSTRAINT DISEASE_DID_PK PRIMARY KEY (DID));
INSERT INTO DISEASE VALUES ('D11','Diphtheria','Highly contagious bacterial infection affecting the nose, throat, and skin');
INSERT INTO DISEASE VALUES ('D12','Measles','Highly contagious airborne viral infection causing fever, cough, and rash');
INSERT INTO DISEASE VALUES ('D13','Rubella','Contagious viral infection with rash, low fever, and swollen glands');
INSERT INTO DISEASE VALUES ('D14','Mumps','Viral infection causing swelling of the salivary glands');
INSERT INTO DISEASE VALUES ('D15','Yellow Fever','Viral hemorrhagic disease transmitted by infected mosquitoes common in tropical regions');

CREATE TABLE TRAVELER (
 TRID                VARCHAR2(10) NOT NULL,
 FNAME               VARCHAR2(30),
 LNAME               VARCHAR2(30),
 DOB                 DATE,
 SEX                 VARCHAR2(10),
 EMAIL               VARCHAR2(50),
 PHONE               VARCHAR2(20),
 CONSTRAINT TRAVELER_TRID_PK PRIMARY KEY (TRID),
 CONSTRAINT TRAVELER_SEX_C CHECK (SEX IN ('Male', 'Female')));
INSERT INTO TRAVELER VALUES ('TR211','Nina','Patel',TO_DATE('18-FEB-1993','DD-MON-YYYY'),'Female','n.patel@email.com','555-111-2101');
INSERT INTO TRAVELER VALUES ('TR212','Owen','Garcia',TO_DATE('09-JUL-1987','DD-MON-YYYY'),'Male','o.garcia@email.com','555-111-2102');
INSERT INTO TRAVELER VALUES ('TR213','Lila','Chen',TO_DATE('21-OCT-2001','DD-MON-YYYY'),'Female','l.chen@email.com','555-111-2103');
INSERT INTO TRAVELER VALUES ('TR214','Marcus','Reed',TO_DATE('03-DEC-1979','DD-MON-YYYY'),'Male','m.reed@email.com','555-111-2104');
INSERT INTO TRAVELER VALUES ('TR215','Priya','Nair',TO_DATE('30-MAY-1998','DD-MON-YYYY'),'Female','p.nair@email.com','555-111-2105');
INSERT INTO TRAVELER VALUES ('TR216','Ethan','Brooks',TO_DATE('14-AUG-2010','DD-MON-YYYY'),'Male','e.brooks@email.com','555-111-2106');

CREATE TABLE TRIP (
 TPID                 VARCHAR2(10) NOT NULL,
 STARTDATE            DATE,
 ENDDATE              DATE,
 TRIPSTATUS           VARCHAR2(20),
 TRAVELPURPOSE        VARCHAR2(30),
 CID                  VARCHAR2(10),
 CONSTRAINT TRIP_CID_FK FOREIGN KEY (CID) REFERENCES COUNTRY (CID),
 CONSTRAINT TRIP_TPID_PK PRIMARY KEY (TPID),
 CONSTRAINT TRIP_DATE_C CHECK (ENDDATE >= STARTDATE),
 CONSTRAINT TRIP_TRIPSTATUS_C CHECK (TRIPSTATUS IN ('Planned', 'In Progress', 'Completed', 'Cancelled')),
 CONSTRAINT TRIP_TRAVELPURPOSE_C CHECK (TRAVELPURPOSE IN ('Work','Volunteer','Leisure','Study')));
INSERT INTO TRIP VALUES ('TP211',TO_DATE('10-JAN-2026','DD-MON-YYYY'),TO_DATE('22-JAN-2026','DD-MON-YYYY'),'Completed','Work','C11');
INSERT INTO TRIP VALUES ('TP212',TO_DATE('18-FEB-2026','DD-MON-YYYY'),TO_DATE('28-FEB-2026','DD-MON-YYYY'),'Completed','Volunteer','C12');
INSERT INTO TRIP VALUES ('TP213',TO_DATE('03-AUG-2026','DD-MON-YYYY'),TO_DATE('17-AUG-2026','DD-MON-YYYY'),'Planned','Leisure','C13');
INSERT INTO TRIP VALUES ('TP214',TO_DATE('12-FEB-2026','DD-MON-YYYY'),TO_DATE('26-FEB-2026','DD-MON-YYYY'),'Cancelled','Study','C14');
INSERT INTO TRIP VALUES ('TP215',TO_DATE('01-SEP-2026','DD-MON-YYYY'),TO_DATE('12-SEP-2026','DD-MON-YYYY'),'Planned','Work','C11');
INSERT INTO TRIP VALUES ('TP216',TO_DATE('05-OCT-2026','DD-MON-YYYY'),TO_DATE('20-OCT-2026','DD-MON-YYYY'),'Planned','Leisure','C15');
INSERT INTO TRIP VALUES ('TP217',TO_DATE('11-NOV-2026','DD-MON-YYYY'),TO_DATE('24-NOV-2026','DD-MON-YYYY'),'Planned','Volunteer','C12');
INSERT INTO TRIP VALUES ('TP218',TO_DATE('01-DEC-2026','DD-MON-YYYY'),TO_DATE('10-DEC-2026','DD-MON-YYYY'),'Planned','Study','C13');

CREATE TABLE VACCINE (
 VID                 VARCHAR2(10) NOT NULL,
 VNAME               VARCHAR2(100),
 VCOVERAGE           NUMBER(5,2),
 DID                 VARCHAR2(10),
 CONSTRAINT VACCINE_DID_FK FOREIGN KEY (DID) REFERENCES DISEASE (DID),
 CONSTRAINT VACCINE_VID_PK PRIMARY KEY (VID),
 CONSTRAINT VACCINE_VCOVERAGE_C CHECK (VCOVERAGE between 0 and 100));
INSERT INTO VACCINE VALUES ('V11','Measles containing vaccination',72.5,'D12');
INSERT INTO VACCINE VALUES ('V12','Rubella containing vaccination',39,'D13');
INSERT INTO VACCINE VALUES ('V13','DTP-containing vaccine',88,'D11');
INSERT INTO VACCINE VALUES ('V14','MMR vaccine',83,'D12');
INSERT INTO VACCINE VALUES ('V15','Mumps containing vaccine',66,'D14');
INSERT INTO VACCINE VALUES ('V16','Yellow Fever vaccine',85,'D15');

CREATE TABLE AdvisoryRule (
 RID                  VARCHAR2(10) NOT NULL,
 RISKSCORE            NUMBER(2),
 RDATE                DATE,
 RTYPE                VARCHAR2(20),
 NOTES                VARCHAR2(300),
 CID                  VARCHAR2(10),
 DID                  VARCHAR2(10),
 CONSTRAINT AdvisoryRule_CID_FK FOREIGN KEY (CID) REFERENCES COUNTRY (CID),
 CONSTRAINT AdvisoryRule_DID_FK FOREIGN KEY (DID) REFERENCES DISEASE (DID),
 CONSTRAINT AdvisoryRule_RID_PK PRIMARY KEY (RID),
 CONSTRAINT AdvisoryRule_RTYPE_C CHECK (RTYPE IN ('Required', 'Recommended')),
 CONSTRAINT AdvisoryRule_RISKSCORE_C CHECK (RISKSCORE BETWEEN 1 AND 10));
INSERT INTO AdvisoryRule VALUES ('R11',5,TO_DATE('05-JAN-2026','DD-MON-YYYY'),'Required','Immunity documentation required for extended work travel','C11','D12');
INSERT INTO AdvisoryRule VALUES ('R12',4,TO_DATE('05-JAN-2026','DD-MON-YYYY'),'Recommended','Booster advised if last dose is outdated','C11','D11');
INSERT INTO AdvisoryRule VALUES ('R13',3,TO_DATE('05-JAN-2026','DD-MON-YYYY'),'Recommended','Check rubella immunity before long stays','C13','D13');
INSERT INTO AdvisoryRule VALUES ('R14',3,TO_DATE('05-JAN-2026','DD-MON-YYYY'),'Recommended','Outbreak-related caution for volunteer groups','C12','D14');
INSERT INTO AdvisoryRule VALUES ('R15',4,TO_DATE('05-JAN-2026','DD-MON-YYYY'),'Recommended','Review measles immunity before group housing travel','C12','D12');
INSERT INTO AdvisoryRule VALUES ('R16',2,TO_DATE('05-JAN-2026','DD-MON-YYYY'),'Recommended','Routine protection suggested for student travelers','C14','D11');

CREATE TABLE RptedCase (
 RCID                 VARCHAR2(10) NOT NULL,
 RCDATE               DATE,
 DID                  VARCHAR2(10),
 CID                  VARCHAR2(10),
 CASES                NUMBER(10),
 SEVERITY             VARCHAR2(20),
 CONSTRAINT RptedCase_CID_FK FOREIGN KEY (CID) REFERENCES COUNTRY (CID),
 CONSTRAINT RptedCase_DID_FK FOREIGN KEY (DID) REFERENCES DISEASE (DID),
 CONSTRAINT RptedCase_RCID_PK PRIMARY KEY (RCID),
 CONSTRAINT RptedCase_CASES_C CHECK (CASES >= 0),
 CONSTRAINT RptedCase_SEVERITY_C CHECK (SEVERITY IN ('Low','Medium','High','Critical')));
INSERT INTO RptedCase VALUES ('RC211',TO_DATE('09-FEB-2024','DD-MON-YYYY'),'D13','C11',118,'High');
INSERT INTO RptedCase VALUES ('RC212',TO_DATE('13-JUN-2024','DD-MON-YYYY'),'D13','C11',102,'Medium');
INSERT INTO RptedCase VALUES ('RC213',TO_DATE('19-SEP-2024','DD-MON-YYYY'),'D13','C11',126,'High');
INSERT INTO RptedCase VALUES ('RC214',TO_DATE('27-APR-2019','DD-MON-YYYY'),'D13','C12',18,'Low');
INSERT INTO RptedCase VALUES ('RC215',TO_DATE('11-MAR-2024','DD-MON-YYYY'),'D14','C13',51,'Medium');
INSERT INTO RptedCase VALUES ('RC216',TO_DATE('29-JUL-2024','DD-MON-YYYY'),'D14','C13',83,'High');
INSERT INTO RptedCase VALUES ('RC217',TO_DATE('16-FEB-2022','DD-MON-YYYY'),'D11','C14',31,'Low');
INSERT INTO RptedCase VALUES ('RC218',TO_DATE('08-OCT-2022','DD-MON-YYYY'),'D11','C14',44,'Medium');
INSERT INTO RptedCase VALUES ('RC219',TO_DATE('25-MAR-2023','DD-MON-YYYY'),'D12','C12',280000,'Critical');
INSERT INTO RptedCase VALUES ('RC220',TO_DATE('30-AUG-2023','DD-MON-YYYY'),'D12','C12',301400,'Critical');
INSERT INTO RptedCase VALUES ('RC221',TO_DATE('12-MAY-2024','DD-MON-YYYY'),'D15','C11',64,'High');
INSERT INTO RptedCase VALUES ('RC222',TO_DATE('03-SEP-2024','DD-MON-YYYY'),'D15','C15',41,'Medium');

CREATE TABLE AdvisoryRpt (
 ARID                 VARCHAR2(10) NOT NULL,
 SUMMARYNOTES         VARCHAR2(500),
 ARDATE               DATE,
 FEE                  NUMBER(8,2),
 TPID                 VARCHAR2(10),
 CONSTRAINT AdvisoryRpt_TPID_U UNIQUE (TPID),
 CONSTRAINT AdvisoryRpt_TPID_FK FOREIGN KEY (TPID) REFERENCES TRIP (TPID),
 CONSTRAINT AdvisoryRpt_ARID_PK PRIMARY KEY (ARID),
 CONSTRAINT AdvisoryRpt_FEE_C CHECK (FEE >= 0));
INSERT INTO AdvisoryRpt VALUES ('AR211','Reviewed itinerary and existing vaccine history; recommendations prepared',TO_DATE('01-JAN-2026','DD-MON-YYYY'),85,'TP211');
INSERT INTO AdvisoryRpt VALUES ('AR212','Discussed volunteer travel precautions and routine immunizations',TO_DATE('15-JAN-2026','DD-MON-YYYY'),70,'TP212');
INSERT INTO AdvisoryRpt VALUES ('AR213','Reviewed destination outbreak alerts and immunity gaps',TO_DATE('18-JUL-2026','DD-MON-YYYY'),90,'TP213');
INSERT INTO AdvisoryRpt VALUES ('AR214','Student travel consult completed before cancellation',TO_DATE('30-JAN-2026','DD-MON-YYYY'),50,'TP214');
INSERT INTO AdvisoryRpt VALUES ('AR215','Work travel advisory finalized with outbreak-based recommendations',TO_DATE('15-AUG-2026','DD-MON-YYYY'),95,'TP215');
INSERT INTO AdvisoryRpt VALUES ('AR216','Leisure travel counseling and vaccine review completed',TO_DATE('20-SEP-2026','DD-MON-YYYY'),78,'TP216');
INSERT INTO AdvisoryRpt VALUES ('AR217','Volunteer housing and exposure risks reviewed',TO_DATE('22-OCT-2026','DD-MON-YYYY'),72,'TP217');

CREATE TABLE TravelerOnTrip (
 TPID                VARCHAR2(10) NOT NULL,
 TRID                VARCHAR2(10) NOT NULL,
 CONSTRAINT TravelerOnTrip_TPID_FK FOREIGN KEY (TPID) REFERENCES TRIP (TPID),
 CONSTRAINT TravelerOnTrip_TRID_FK FOREIGN KEY (TRID) REFERENCES TRAVELER (TRID),
 CONSTRAINT TravelerOnTrip_TPID_TRID_PK PRIMARY KEY (TPID, TRID));
INSERT INTO TravelerOnTrip VALUES ('TP211','TR211');
INSERT INTO TravelerOnTrip VALUES ('TP211','TR212');
INSERT INTO TravelerOnTrip VALUES ('TP212','TR214');
INSERT INTO TravelerOnTrip VALUES ('TP212','TR215');
INSERT INTO TravelerOnTrip VALUES ('TP213','TR211');
INSERT INTO TravelerOnTrip VALUES ('TP213','TR213');
INSERT INTO TravelerOnTrip VALUES ('TP213','TR216');
INSERT INTO TravelerOnTrip VALUES ('TP214','TR213');
INSERT INTO TravelerOnTrip VALUES ('TP215','TR212');
INSERT INTO TravelerOnTrip VALUES ('TP215','TR214');
INSERT INTO TravelerOnTrip VALUES ('TP216','TR211');
INSERT INTO TravelerOnTrip VALUES ('TP216','TR215');
INSERT INTO TravelerOnTrip VALUES ('TP216','TR216');
INSERT INTO TravelerOnTrip VALUES ('TP217','TR212');
INSERT INTO TravelerOnTrip VALUES ('TP217','TR214');
INSERT INTO TravelerOnTrip VALUES ('TP217','TR215');
INSERT INTO TravelerOnTrip VALUES ('TP215','TR211');
INSERT INTO TravelerOnTrip VALUES ('TP211','TR215');
INSERT INTO TravelerOnTrip VALUES ('TP212','TR212');
INSERT INTO TravelerOnTrip VALUES ('TP213','TR214');
INSERT INTO TravelerOnTrip VALUES ('TP218','TR213');

CREATE TABLE ReportItem (
 RIID                 VARCHAR2(10) NOT NULL,
 RITYPE               VARCHAR2(20),
 REASON               VARCHAR2(500),
 ARID                 VARCHAR2(10),
 VID                  VARCHAR2(10),
 CONSTRAINT ReportItem_ARID_FK FOREIGN KEY (ARID) REFERENCES AdvisoryRpt (ARID),
 CONSTRAINT ReportItem_VID_FK FOREIGN KEY (VID) REFERENCES VACCINE (VID),
 CONSTRAINT ReportItem_RIID_PK PRIMARY KEY (RIID),
 CONSTRAINT ReportItem_RITYPE_C CHECK (RITYPE IN ('Required', 'Recommended')));
INSERT INTO ReportItem VALUES ('RI211','Required','Measles immunity required due to destination guidance','AR211','V11');
INSERT INTO ReportItem VALUES ('RI212','Recommended','Rubella protection should be reviewed before departure','AR211','V12');
INSERT INTO ReportItem VALUES ('RI213','Recommended','DTP booster advised for long-term volunteer work','AR212','V13');
INSERT INTO ReportItem VALUES ('RI214','Recommended','MMR booster suggested due to outbreak alerts','AR213','V14');
INSERT INTO ReportItem VALUES ('RI215','Recommended','Mumps protection advised for shared housing conditions','AR213','V15');
INSERT INTO ReportItem VALUES ('RI216','Recommended','Rubella vaccine recommended for student travel review','AR214','V12');
INSERT INTO ReportItem VALUES ('RI217','Recommended','DTP booster suggested before border crossing','AR214','V13');
INSERT INTO ReportItem VALUES ('RI218','Required','Measles vaccination required for work-related entry guidance','AR215','V11');
INSERT INTO ReportItem VALUES ('RI219','Recommended','MMR coverage should be updated if documentation is missing','AR215','V14');
INSERT INTO ReportItem VALUES ('RI220','Recommended','Mumps vaccine advised due to recent local reports','AR216','V15');
INSERT INTO ReportItem VALUES ('RI221','Recommended','DTP booster recommended before rural leisure travel','AR216','V13');
INSERT INTO ReportItem VALUES ('RI222','Required','Measles coverage required for volunteer intake','AR217','V11');
INSERT INTO ReportItem VALUES ('RI223','Recommended','Rubella vaccine advised for incomplete immunization history','AR217','V12');
INSERT INTO ReportItem VALUES ('RI224','Recommended','Additional measles protection recommended for family travel','AR216','V11');
INSERT INTO ReportItem VALUES ('RI225','Recommended','Mumps vaccine suggested for crowded travel settings','AR212','V15');
INSERT INTO ReportItem VALUES ('RI226','Recommended','DTP booster advised due to outdated previous dose','AR211','V13');
INSERT INTO ReportItem VALUES ('RI227','Recommended','Rubella review recommended before long work assignment','AR215','V12');
INSERT INTO ReportItem VALUES ('RI228','Recommended','MMR booster advised for mixed-risk itinerary','AR217','V14');
INSERT INTO ReportItem VALUES ('RI229','Recommended','Mumps protection suggested because of recent outbreak alerts','AR214','V15');
INSERT INTO ReportItem VALUES ('RI230','Recommended','DTP booster recommended for extended volunteer exposure','AR212','V13');
INSERT INTO ReportItem VALUES ('RI231','Required','Yellow fever vaccination required for entry in some countries','AR215','V16');

commit;
----------------------------------------------------------------------------------
--QUERY 01 (INNER JOIN)
--List travelers going to Ghana and the vaccines listed in their advisory reports.

select distinct traveler.trid, fname, lname, vaccine.vid, vname
from traveler inner join travelerontrip on traveler.trid = travelerontrip.trid
inner join trip on travelerontrip.tpid = trip.tpid
inner join country on trip.cid = country.cid
inner join advisoryrpt on trip.tpid = advisoryrpt.tpid
inner join reportitem on advisoryrpt.arid = reportitem.arid
inner join vaccine on reportitem.vid = vaccine.vid
where upper(cname) = 'GHANA'
order by traveler.trid;

----------------------------------------------------------------------------------
--QUERY 02 (OUTER JOIN)
--List all trips and any advisory reports, including trips that do not yet have an advisory report.

select trip.tpid, arid
from trip left join advisoryrpt on trip.tpid = advisoryrpt.tpid;

----------------------------------------------------------------------------------
--QUERY 03 (SET OPERATION - INTERSECT)
--List diseases that appear in both advisory rules and reported case records.
select did
from advisoryrule

INTERSECT

select did
from rptedcase;

----------------------------------------------------------------------------------
--QUERY 04 (SET OPERATION - MINUS)
--List diseases that appear in reported case records but not in advisory rules.

select did
from rptedcase

MINUS

select did
from advisoryrule;

----------------------------------------------------------------------------------
--QUERY 05 (AGGREGATE)
--Find total reported cases by country and disease for 2024.

select cid, did, sum(cases) "Total Reported Cases"
from rptedcase
where to_char(rcdate, 'yyyy') = '2024'
group by cid, did;

----------------------------------------------------------------------------------
--QUERY 06 (AGGREGATE)
--Countries whose average consultation fee is greater than 75.

select country.cid, cname, avg(fee) "Avg Consultation Fee"
from advisoryrpt inner join trip on advisoryrpt.tpid = trip.tpid
inner join country on trip.cid = country.cid
group by country.cid, cname
having avg(fee) > 75;

----------------------------------------------------------------------------------
--QUERY 07 (SUBQUERY)
--Find vaccines whose vaccination coverage is below the average vaccination coverage of all vaccines.

select vid, vname, vcoverage
from vaccine
where vcoverage < (select avg(vcoverage)
from vaccine);

----------------------------------------------------------------------------------