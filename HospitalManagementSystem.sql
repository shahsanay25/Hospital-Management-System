--Creating the Database:
Create database Group11_HospitalManagement;
Use Group11_HospitalManagement;

-----------------------------------------------------------------------------
-- Creating Tables in the Database:
-----------------------------------------------------------------------------
--Table Laboratory:
CREATE TABLE [Laboratory] (
  [idLaboratory] int NOT NULL	,
  [Description] varchar(200) NULL,
  PRIMARY KEY ([idLaboratory])
);


--Table Hospital:
CREATE TABLE [Hospital] (
  [Hospital_ID] int NOT NULL,
  [Hospital_Name] varchar(45) NULL,
  [Phone] varchar(15) NULL,
  [Address_Line1] varchar(45) NULL,
  [City] varchar(30) NULL,
  [Zipcode] int NULL,
  [State] varchar(30) NULL,
  [idLaboratory] int NOT NULL
			FOREIGN KEY REFERENCES Laboratory(idLaboratory),
  PRIMARY KEY ([Hospital_ID])
);


--Table Speciality:
CREATE TABLE [Speciality] (
  [Speciality_ID] int NOT NULL,
  [Speciality_Desc] varchar(200) NULL,
  PRIMARY KEY ([Speciality_ID])
);


--Table Resources:
CREATE TABLE [Resources] (
  [Resource_ID] int NOT NULL,
  [Category] varchar(45) NULL,
  [Quantity] int NULL,
  Last_Updated datetime ,
  [Hospital_ID] int NOT NULL
                FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  PRIMARY KEY ([Resource_ID])
);


-- Table Ward:
CREATE TABLE [Ward] (
  [idWard] int NOT NULL,
  [Ward_Name] varchar(45) NULL,
  [Floor Number] int NULL,
  [Hospital_ID] int NOT NULL
			FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  PRIMARY KEY ([idWard])
);


--Table Room_Details:
CREATE TABLE [Room_Details] (
  [Room_No] int NOT NULL,
  [Type] varchar(45) NULL,
  [Availability] varchar(45) NULL,
  [idWard] int NOT NULL
			FOREIGN KEY REFERENCES Ward(idWard),
  PRIMARY KEY ([Room_No]),
);


--Table Bed_Details:
CREATE TABLE [Bed_Details] (
  [idBed_Details] int NOT NULL,
  [Availability] varchar(45) NULL,
  [Room_No] int NOT NULL
			FOREIGN KEY REFERENCES Room_Details([Room_No]),
  PRIMARY KEY ([idBed_Details])
);


--Table Patient:
CREATE TABLE [Patient] (
  [idPatient] int NOT NULL,
  [Patient_FName] varchar(45) NULL,
  [Patient_MName] varchar(45) NULL,
  [Patient_LName] varchar(45) NULL,
  [Patient_EmailID] varchar(45) NULL,
  [Patient_ContacNo] varchar(15) NULL,
  [DOB] DATETIME NULL,
  [Sex] varchar(45) NULL,
  [Day of Visit] DATETIME NULL,
  [Address_Line1] varchar(45) NULL,
  [City] varchar(30) NULL,
  [State] varchar(30) NULL,
  [ZipCode] int NULL,
  PRIMARY KEY ([idPatient])
);


--Table Types_of_Cases:
CREATE TABLE [Types_of_Cases] (
  [Case_ID]  Int Identity(1, 1),
  [Type] varchar(45) NULL,
  [Description] varchar(200) NULL,
  [Admit Date] DATETIME NULL,
  [Discharge Date] DATETIME NULL,
  [idPatient] int NOT NULL
            FOREIGN KEY REFERENCES Patient(idPatient),
  [idWard] int NULL
            FOREIGN KEY REFERENCES Ward(idWard),
  [idBed_Details] int NULL
            FOREIGN KEY REFERENCES Bed_Details(idBed_Details),
  PRIMARY KEY ([Case_ID])
);


--Table Bill:
CREATE TABLE [Bill] (
  [idBill]  Int Identity(1, 1),
  Doctor_Charge MONEY,
  Accomodation_Charge MONEY,
  Other_Charges MONEY,
  [Total_Bill] MONEY NULL,
  [Pay_Date] DATETIME NULL,
  [Pay_Method ] varchar(45) NULL,
  [Case_ID] int NOT NULL
                FOREIGN KEY REFERENCES [Types_of_cases](Case_ID),
  PRIMARY KEY ([idBill])
);


-- Table Ambulance:
CREATE TABLE [Ambulance] (
  [Ambulance_ID] int NOT NULL,
  [Type] varchar(45) NULL,
  [Ambulance_Availability] varchar(45) NULL,
  [Hospital_ID] int NOT NULL
				FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  PRIMARY KEY ([Ambulance_ID])
);


--Table Pharmacy:
CREATE TABLE [Pharmacy] (
  [Medicine_ID] int NOT NULL,
  [Medicine_Desc] varchar(200) NULL,
  [Medicine _Type] varchar(45) NULL,
  [Quantity] int NULL,
  [Last_Updated] datetime ,
  [Hospital_ID] int NOT NULL
                FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  PRIMARY KEY ([Medicine_ID]) );


--Table Staff_Department:
CREATE TABLE [Staff_Department] (
  [idStaff_Department] int NOT NULL,
  [Staff_Dept_Desc] varchar(200) NULL,
  PRIMARY KEY ([idStaff_Department])
);


--Table Staff:
CREATE TABLE [Staff] (
  [Staff_ID] int NOT NULL,
  [Staff_FName] varchar(45) NULL,
  [Staff_Lname] varchar(45) NULL,
  [Staff_Contact] varchar(15) NULL,
  [Hospital_ID] int NOT NULL
				FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  [idStaff_Department] int NOT NULL
				FOREIGN KEY REFERENCES Staff_Department([idStaff_Department]),
  PRIMARY KEY ([Staff_ID])
);


--Table Medical_Devices:
CREATE TABLE [Medical_Devices] (
  [MedicalDevice_ID] int NOT NULL,
  [Device_Name] varchar(45) NULL,
  [Quantity] int NULL,
  [Hospital_ID] int NOT NULL
				FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  PRIMARY KEY ([MedicalDevice_ID])
);


--Table Doctor:
CREATE TABLE [Doctor] (
  [Doctor_ID] int NOT NULL,
  [Doc_FName] varchar(45) NULL,
  [Doc_LName] varchar(45) NULL,
  [Doc_MName] varchar(45) NULL,
  [Doc_Phone] varchar(15) NULL,
  [Doc_AddressLine1] varchar(45) NULL,
  [City] varchar(30) NULL,
  [State] varchar(30) NULL,
  [ZipCode] int NULL,
  [Hospital_ID] int NOT NULL
  				FOREIGN KEY REFERENCES Hospital([Hospital_ID]),
  PRIMARY KEY ([Doctor_ID])
);


-- Table DoctorRef:
CREATE TABLE [DoctorRef] (
  [idPatient] int NOT NULL,
  [Doctor_ID] int NOT NULL,
  [Speciality_ID] int NOT NULL,
  PRIMARY KEY ([idPatient], [Doctor_ID], [Speciality_ID]),
  CONSTRAINT [FK_DoctorRef.idPatient]
    FOREIGN KEY ([idPatient])
      REFERENCES [Hospital]([Hospital_ID]),
  CONSTRAINT [FK_DoctorRef.Doctor_ID]
    FOREIGN KEY ([Doctor_ID])
      REFERENCES [Doctor]([Doctor_ID])
);


--Table Test:
CREATE TABLE [Test] (
  [idTest]  Int Identity(1, 1),
  [Test_Name] varchar(45) NULL,
  [Date] DATETIME NULL,
  [Test_Charge] MONEY NULL,
  [Case_ID] int NOT NULL
            FOREIGN KEY REFERENCES [Types_of_Cases]([Case_ID]),
  [idLaboratory] int NOT NULL
            FOREIGN KEY REFERENCES [Laboratory]([idLaboratory]),
  PRIMARY KEY ([idTest])
);


---------------------------------------
------Trigger-----
--To calculate the total bill by adding the test charge from the test table and other charges from the bill table
---------------------------------------

GO

Create Trigger Trig_Order_Total_Bill
on [Bill]
AFTER INSERT ,UPDATE
AS
Begin
   UPDATE Bill
   Set Total_Bill = (COALESCE (B.Doctor_Charge,0) + COALESCE (B.Accomodation_Charge,0) + COALESCE (B.Other_Charges,0) + COALESCE (T.Test_Charge,0))
   FROM Bill B
   Left JOIN Types_of_Cases TC
   ON B.Case_ID =   TC.Case_ID
   Left JOIN Test t
   ON TC.Case_ID =  T.Case_ID

  END		
-----------------------------------------------
------Function----
--Computed the Age column for the Patient Table
-----------------------------------------------

GO

CREATE FUNCTION dbo.AgeCal(@DateOfBirth AS DATETIME)
RETURNS INT
AS
BEGIN
DECLARE @Years AS INT
DECLARE @BirthdayDate AS DATETIME
DECLARE @Age AS INT
SET @Years = DATEDIFF(YY,@DateOfBirth,GETDATE())
SET @BirthdayDate = DATEADD(YY,@Years,@DateOfBirth)
SET @Age = @Years -
CASE
WHEN @BirthdayDate>GETDATE() THEN 1
ELSE 0
END
RETURN @Age
END

GO	

Alter table Patient add AGE as dbo.AgeCal(DOB) ;
			
----------------------------------
--Table level Constraint---
--If a bed is available only then will it be allocated
-----------------------------------

GO

CREATE FUNCTION dbo.BedAvailCk(@WardID INT,@BedID INT)
RETURNS INT
BEGIN
    DECLARE @BedAvail INT = 0
    DECLARE @BedAvailCheck varchar(10) =(SELECT b.Availability 
    FROM Bed_Details b
    inner join Room_Details r on b.Room_No = r.Room_No
    inner join Ward w on r.idWard = w.idWard
    inner join Hospital h on w.Hospital_ID = h.Hospital_ID
    WHERE  r.idWard = @WardID  and idBed_Details  =  @BedID )
    IF(@BedAvailCheck <> 'Yes')
        SET @BedAvail = 1
    RETURN @BedAvail
END

GO

ALTER TABLE dbo.Types_of_Cases add CONSTRAINT BedAvail_Ck CHECK(dbo.BedAvailCk(idWard, idBed_Details)=0);

--------------------------------------------
--Trigger--- 
--For updating the bed availability when a patient is discharged or admitted
--------------------------------------------

GO

Create  Trigger Trig_BedAvail
on Types_of_Cases
AFTER INSERT ,UPDATE,DELETE
AS
declare @unavail varchar(10) = 'No'
declare @avail varchar(10) = 'Yes'
declare @Bedid int = (select idBed_Details from inserted) 
declare @Bedid_d int = (select idBed_Details from deleted) 
Begin
if exists (select * 
                from Types_of_Cases tc
                where (idBed_Details =@Bedid or idBed_Details =@Bedid_d )
                            and [Admit Date] is not null
                            and [Discharge Date] is null )
    begin
                    update Bed_Details 
                    set Availability = @unavail
                    from Bed_Details bd
                    join Types_of_Cases tc
                    on bd.idBed_Details = tc.idBed_Details
                    join inserted i
                    on i.idBed_Details = bd.idBed_Details
    end
    if exists (select * 
                from Types_of_Cases tc
                where (idBed_Details =@Bedid or idBed_Details =@Bedid_d )
                            and [Admit Date] is not null
                            and [Discharge Date] is not null )
    begin
                    update Bed_Details 
                    set Availability = @avail
                    from Bed_Details bd
                    join Types_of_Cases tc
                    on bd.idBed_Details = tc.idBed_Details
                    join inserted i
                    on i.idBed_Details = bd.idBed_Details
    end

    if update(idBed_Details) and exists (select * 
                from  Bed_Details bd  left join Types_of_Cases tc
                on bd.idBed_Details = tc.idBed_Details
                where tc.idBed_Details is null)
    begin
                    update Bed_Details 
                    set Availability = @avail
                    from Bed_Details bd
                    join deleted d
                    on d.idBed_Details = bd.idBed_Details
    end  

END

------------------------------
--INSERT STATEMENTS:
------------------------------

 
 ---Laboratory------
Insert into Laboratory  values (101, 'Multipurpose Test Lab');
Insert into Laboratory values  (201, 'Multipurpose  Test Lab (Cancer related tests cannot be conducted over here' );
Insert into Laboratory values (301, 'Research and Test Lab');
Insert into Laboratory values (401, 'Research,Development and Test Lab');
Insert into Laboratory values (501, 'Pathological Lab');
Insert into Laboratory values (601, 'Multipurpose Test Lab');
Insert into Laboratory values (701, 'Multipurpose  Test Lab (Cancer related tests cannot be conducted over here)' );
Insert into Laboratory values (801, 'Research,Development and Test Lab');
Insert into Laboratory values (901, 'Pathological Lab');
Insert into Laboratory values (1001, 'Pathological Lab');


---Hospital---------
Insert into Hospital values (1,'MASSACHUSETTS GENERAL HOSPITAL','+17817994113','101 Longwood Street','Boston',22215,'Massachussetts',101);
Insert into Hospital values (1,'MASSACHUSETTS GENERAL HOSPITAL','+17817994113','101 Longwood Street','Boston',22215,'Massachussetts',101);
Insert into Hospital values (2,'ATHOL MEMORIAL HOSPITAL','+19967066942','203 Park Dr','Boston',22115,'Massachussetts',201);
Insert into Hospital values (3,'NEWYORK GENERAL  CARE HOSPITAL','+17820848591','500 Wallstreet Centre','Newyork',32215,'Newyork',301);
Insert into Hospital values (4,'The MCLEAN HOSPITAL','+13186079234','203 Copley Street','Boston',24115,'Massachussetts',401);
Insert into Hospital values (5,'SAN FRANCISCO CHILD CARE HOSPITAL','+17343994113','5320 Joseph Street','SAN FRANCISCO ',12215,'California',501);
Insert into Hospital values (6,'MIAMI MEMORIAL HOSPITAL','+19127066942','203 Park Dr','Miami',33135,'Florida',601);
Insert into Hospital values (7,'THE THOMAS HOSPITAL','+17856848591','500 Wallstreet Centre','Newyork',38215,'Newyork',701);
Insert into Hospital values (8,'LINCOLN HOSPITAL','+13187779234','203 Copley','Jersey',82415,'Massachussetts',801);
Insert into Hospital values (9,' THE GRAND CENTRAL HOSPITAL','+17817224113','325 Carnaby Street','Irving',75038,'Texas',901);
Insert into Hospital values (10,'ATHOL MEMORIAL HOSPITAL','+19961066942','200 Milk Street','Dallas',74112,'Texas',1001);


---Ambulance-----------
Insert into Ambulance values (1,'First Responder','Yes',1);
Insert into Ambulance values (2,'First Responder','Yes',1);
Insert into Ambulance values (3,'Advanced Life Support','Yes',1);
Insert into Ambulance values (4,'Rapid Organ Recovery','Yes',1);
Insert into Ambulance values (5,'Advanced Life Support','Yes',2);
Insert into Ambulance values (6,'Rapid Organ Recovery','Yes',2);
Insert into Ambulance values (7,'First Responder','Yes',3);
Insert into Ambulance values (8,'First Responder','Yes',3);
Insert into Ambulance values (9,'Advanced Life Support','Yes',4);
Insert into Ambulance values (10,'Rapid Organ Recovery','Yes',4);
Insert into Ambulance values (11,'First Responder','Yes',5);
Insert into Ambulance values (12,'First Responder','Yes',5);
Insert into Ambulance values (13,'Advanced Life Support','Yes',5);
Insert into Ambulance values (14,'Rapid Organ Recovery','Yes',6);
Insert into Ambulance values (15,'Advanced Life Support','Yes',6);
Insert into Ambulance values (16,'Rapid Organ Recovery','Yes',6);
Insert into Ambulance values (17,'First Responder','Yes',7);
Insert into Ambulance values (18,'First Responder','Yes',7);
Insert into Ambulance values (19,'Advanced Life Support','Yes',8);
Insert into Ambulance values (20,'Rapid Organ Recovery','Yes',8);
Insert into Ambulance values (21,'First Responder','Yes',9);
Insert into Ambulance values (22,'First Responder','Yes',9);
Insert into Ambulance values (23,'Advanced Life Support','Yes',10);
Insert into Ambulance values (24,'Rapid Organ Recovery','Yes',10);


---Medical_Devices--------------
Insert into Medical_Devices values (101,'ECG/EKG',10,1);
Insert into Medical_Devices values (201,'ECG/EKG',20,2);
Insert into Medical_Devices values (301,'ECG/EKG',30,3);
Insert into Medical_Devices values (401,'ECG/EKG',10,4);
Insert into Medical_Devices values (501,'ECG/EKG',10,5);
Insert into Medical_Devices values (601,'ECG/EKG',40,6);
Insert into Medical_Devices values (701,'ECG/EKG',20,7);
Insert into Medical_Devices values (801,'ECG/EKG',30,8);
Insert into Medical_Devices values (901,'ECG/EKG',50,9);
Insert into Medical_Devices values (1001,'ECG/EKG',10,10);
Insert into Medical_Devices values (102,'X-ray imaging devices',10,1);
Insert into Medical_Devices values (202,'X-ray imaging devices',20,2);
Insert into Medical_Devices values (302,'X-ray imaging devices',30,3);
Insert into Medical_Devices values (402,'X-ray imaging devices',10,4);
Insert into Medical_Devices values (502,'X-ray imaging devices',10,5);
Insert into Medical_Devices values (602,'X-ray imaging devices',40,6);
Insert into Medical_Devices values (702,'X-ray imaging devices',20,7);
Insert into Medical_Devices values (802,'X-ray imaging devices',30,8);
Insert into Medical_Devices values (902,'X-ray imaging devices',50,9);
Insert into Medical_Devices values (1002,'X-ray imaging devices',10,10);
Insert into Medical_Devices values (103,'Magnetic resonance imaging (MRI)',2,1);
Insert into Medical_Devices values (203,'Magnetic resonance imaging (MRI)',2,2);
Insert into Medical_Devices values (303,'Magnetic resonance imaging (MRI)',4,3);
Insert into Medical_Devices values (603,'Magnetic resonance imaging (MRI)',2,6);
Insert into Medical_Devices values (703,'Magnetic resonance imaging (MRI)',5,7);
Insert into Medical_Devices values (104,'Urinalysis analyzers',2,1);
Insert into Medical_Devices values (204,'Urinalysis analyzers',2,2);
Insert into Medical_Devices values (304,'Urinalysis analyzers',3,3);
Insert into Medical_Devices values (404,'Urinalysis analyzers',1,4);
Insert into Medical_Devices values (504,'Urinalysis analyzers',4,5);
Insert into Medical_Devices values (604,'Urinalysis analyzers',6,6);
Insert into Medical_Devices values (704,'Urinalysis analyzers',2,7);
Insert into Medical_Devices values (804,'Urinalysis analyzers',3,8);
Insert into Medical_Devices values (904,'Urinalysis analyzers',5,9);
Insert into Medical_Devices values (1004,'Urinalysis analyzers',7,10);
Insert into Medical_Devices values (105,'Blood Pressue Monitors',20,1);
Insert into Medical_Devices values (205,'Blood Pressue Monitors',20,2);
Insert into Medical_Devices values (305,'Blood Pressue Monitors',30,3);
Insert into Medical_Devices values (405,'Blood Pressue Monitors',25,4);
Insert into Medical_Devices values (505,'XBlood Pressue Monitors',30,5);
Insert into Medical_Devices values (605,'XBlood Pressue Monitors',60,6);
Insert into Medical_Devices values (705,'Blood Pressue Monitors',20,7);
Insert into Medical_Devices values (805,'XBlood Pressue Monitors',30,8);
Insert into Medical_Devices values (905,'Blood Pressue Monitors',50,9);
Insert into Medical_Devices values (1005,'Blood Pressue Monitors',70,10);


---Resources------
Insert into Resources values (101,'PPE KIT',1000,'2022-07-05',1);
Insert into Resources values (201,'PPE KIT',2000,'2022-07-05',2);
Insert into Resources values (301,'PPE KIT',3000,'2022-07-05',3);
Insert into Resources values (401,'PPE KIT',1000,'2022-07-05',4);
Insert into Resources values (501,'PPE KIT',1000,'2022-07-05',5);
Insert into Resources values (601,'PPE KIT',400,'2022-07-05',6);
Insert into Resources values (701,'PPE KIT',2000,'2022-07-20',7);
Insert into Resources values (801,'PPE KIT',3000,'2022-07-20',8);
Insert into Resources values (901,'PPE KIT',500,'2022-07-20',9);
Insert into Resources values (1001,'PPE KIT',1000,'2022-07-20',10);
Insert into Resources values (102,'GLOVES',10000,'2022-07-20',1);
Insert into Resources values (202,'GLOVES',20000,'2022-07-20',2);
Insert into Resources values (302,'GLOVES',30000,'2022-07-20',3);
Insert into Resources values (402,'GLOVES',10000,'2022-07-20',4);
Insert into Resources values (502,'GLOVES',10000,'2022-07-22',5);
Insert into Resources values (602,'GLOVES',4000,'2022-07-22',6);
Insert into Resources values (702,'GLOVES',20000,'2022-07-22',7);
Insert into Resources values (802,'GLOVES',30000,'2022-07-22',8);
Insert into Resources values (902,'GLOVES',5000,'2022-07-22',9);
Insert into Resources values (1002,'GLOVES',10000,'2022-07-22',10);
Insert into Resources values (103,'SYRINGE',5000,'2022-07-22',1);
Insert into Resources values (203,'SYRINGE',2500,'2022-07-22',2);
Insert into Resources values (303,'SYRINGE',3000,'2022-07-22',3);
Insert into Resources values (403,'SYRINGE',10000,'2022-07-24',4);
Insert into Resources values (503,'SYRINGE',5000,'2022-07-24',5);
Insert into Resources values (603,'SYRINGE',4000,'2022-07-24',6);
Insert into Resources values (703,'SYRINGE',10000,'2022-07-24',7);
Insert into Resources values (803,'SYRINGE',3000,'2022-07-24',8);
Insert into Resources values (903,'SYRINGE',5000,'2022-07-24',9);
Insert into Resources values (1003,'SYRINGE',10000,'2022-07-27',10);
Insert into Resources values (104,'SURGICAL MASKS',50000,'2022-07-27',1);
Insert into Resources values (204,'SURGICAL MASKS',25000,'2022-07-27',2);
Insert into Resources values (304,'SURGICAL MASKS',30000,'2022-07-27',3);
Insert into Resources values (404,'SURGICAL MASKS',10000,'2022-07-27',4);
Insert into Resources values (504,'SURGICAL MASKS',50000,'2022-07-27',5);
Insert into Resources values (604,'SURGICAL MASKS',40000,'2022-07-27',6);
Insert into Resources values (704,'SURGICAL MASKS',10000,'2022-07-27',7);
Insert into Resources values (804,'SURGICAL MASKS',30000,'2022-07-27',8);
Insert into Resources values (904,'SURGICAL MASKS',5000,'2022-07-29',9);
Insert into Resources values (1004,'SURGICAL MASKS',10000,'2022-07-27',10);
Insert into Resources values (105,'STERILE COTTON ROLLS',5000,'2022-07-29',1);
Insert into Resources values (205,'STERILE COTTON ROLLS',2500,'2022-07-29',2);
Insert into Resources values (305,'STERILE COTTON ROLLS',3000,'2022-07-29',3);
Insert into Resources values (405,'STERILE COTTON ROLLS',10000,'2022-07-29',4);
Insert into Resources values (505,'STERILE COTTON ROLLS',5000,'2022-07-29',5);
Insert into Resources values (605,'STERILE COTTON ROLLS',4000,'2022-07-29',6);
Insert into Resources values (705,'STERILE COTTON ROLLS',10000,'2022-07-29',7);
Insert into Resources values (805,'STERILE COTTON ROLLS',3000,'2022-07-29',8);
Insert into Resources values (905,'STERILE COTTON ROLLS',5000,'2022-07-29',9);
Insert into Resources values (1005,'STERILE COTTON ROLLS',1500,'2022-07-29',10);


---Doctor------
INSERT INTO dbo.Doctor
 VALUES (1, 'Emma', 'Smith', 'J', '+18676548927', 'Huntington Ave 123', 'Boston', 'Massachusetts', 22113, 1),
			 	 (2, 'Olivia', 'Martin', null, '+18679878209', 'Mass Ave 13', 'Boston', 'Massachusetts', 22149, 1),
				 (3, 'Charlotte', 'Davis', null, '+18679874826', '2nd St 2', 'Boston', 'Massachusetts', 22425, 2),
				 (4, 'Amelia', 'Chang', null, '+18679898452', '35 St 793', 'Boston', 'Massachusetts', 22117, 2),
				 (5, 'Ava', 'Wilson',null, '+18679212378', 'Green St 9', 'Newyork', 'Newyork', 11201, 3),
				 (6, 'Liam', 'Gonzalez', null, '+12539878209', 'Red Ave 11', 'Newyork', 'Newyork', 11201, 3),
				 (7, 'Noah', 'Roberts', null, '+18579878209', 'Wilson St 289', 'Boston', 'Massachusetts', 22115, 4),
				 (8, 'Lucas', 'Phillips', null, '+12349878209', 'Tremont Ave 23', 'Boston', 'Massachusetts', 22115, 4),
				 (9, 'Benjamin', 'Parker', null, '+14449878209', 'Beacon St 13', 'San Francisco', 'California', 22625, 5),
				 (10, 'Henry', 'Powell', null, '+14834567875', 'Health St 102', 'San Francisco', 'California', 22138, 5),
				 (11, 'Mary', 'Madden', null, '+18672228927', 'Loftsteads Ave 12', 'Miami', 'Florida', 33128, 6),
			 	 (12, 'Hana', 'Braun', null, '+18679878238', 'Campion Ave 29', 'Miami', 'Florida', 33184, 6),
				 (13, 'Austin', 'Watts', null, '+18579874826', '5 Ave 297', 'Newyork', 'Newyork', 11243, 7),
				 (14, 'Leon', 'Hancock', null, '+12379898452', '36 St 38', 'Newyork', 'Newyork', 11294, 7),
				 (15, 'Sheldon', 'Everett',null, '+18689212378', 'Symphony Rd 329', 'Boston', 'Massachusetts', 22112, 8),
				 (16, 'Conor', 'Ward', null, '+12986878209', 'Red Ave 11', 'Boston', 'Massachusetts', 22115, 8),
				 (17, 'Charlie', 'Fisher', null, '+19386878209', 'Queensberry St 24', 'Dallas', 'Texas', 75038, 9),
				 (18, 'Justin', 'Barajas', null, '+12449878356', 'Tremont Ave 3', 'Irving', 'Texas', 74112, 9),
				 (19, 'Johnny', 'Bean', null, '+14349873205', 'Brookline St 106', 'Dallas', 'Texas', 75038, 10),
				 (20, 'Darren', 'Huff', null, '+18345679824', 'Howard St 51', 'Irving', 'Texas', 74129, 10);


---Speciality-------------------------------
 INSERT INTO dbo.Speciality
 VALUES (1, 'Family Medicine'),
				 (2, 'Obstetrics'),    --Women's Health
				 (3, 'Cardiology'),   --Heart
				 (4, 'Psychiatry'),     --Mind
				 (5, 'Gastroenterology'),   --Digestion System
				 (6, 'Internal Medicine'),   
				 (7, 'Neurology'),     --nerve
				 (8, 'Pulmonary Medicine'),      --lung
				 (9, 'Orthopaedic'),    --bone
				 (10, 'Dermatology');   --skin


---DoctorRef--------------------
 INSERT dbo.DoctorRef
 VALUES (1,10,1), (2,9,1), (3,8,1), (4,7,1), (5,13,1), (6,11,2), (7,1,1), (8,1,2), (9,1,1), (10,12,1);  --(patient, doctor, speciality)


---Staff_Department---------------
 INSERT dbo.Staff_Department
 VALUES (1,'Outpatient Department (OPD)'), (2,'Inpatient Service (IP)'), (3,'Medical Department'),
				 (4,'Nursing Department'), (5,'Paramedical Department'), (6,'Rehabilitation Department'),
				 (7,'Operation Theatre Complex (OT)'), (8,'Pharmacy Department'), (9,'Radiology Department (X-ray)'),
				 (10,'Dietary Department'), (11,'Business Management'), (12,'Medical Record Department (MRD)'),
				 (13,'Personnel Department');


---Staff--------------------
 INSERT dbo.Staff
 VALUES (1, 'Bob', 'Chen','+16832734566',1,1),
				 (2, 'Adan', 'Prince','+18302141991',1,2),
				 (3, 'Raiden', 'Raiden','+13253335408',1,13),
				 (4, 'Carley', 'Carley','+17158869196',2,1),
				 (5, 'Jermaine', 'Jermaine','+12527937375',3,2),
				 (6, 'Brayden', 'Beasley','+18026812676',4,3),
				 (7, 'William', 'Simon','+15732602154',5,4),
				 (8, 'Franco', 'Ho','+18125887502',6,5),
				 (9, 'Cindy', 'Mack','+13869170830',7,6),
				 (10, 'Kelly', 'Glass','+12018128624',8,8),
				 (11, 'Suzanne', 'Berry','+16832734566',1,1),   
				 (12, 'Lorraine', 'Prince','+18302141991',1,1),
				 (13, 'Benny', 'Morris','+13253335408',1,2),
				 (14, 'Jerald', 'Carley','+17158869196',1,2),
				 (15, 'Kathy', 'Morris','+12527937375',1,3),
				 (16, 'Amos', 'Beasley','+18026812676',1,3),
				 (17, 'Karen', 'Berry','+15732602154',1,4),
				 (18, 'Franco', 'Ho','+18125887502',1,4),
				 (19, 'Wendy', 'Mack','+13869170830',1,5),
				 (20, 'Laverne', 'Glass','+12018128624',1,5),
				 (21, 'Rudy', 'Becker','+16832734566',1,6),  
				 (22, 'Katrina', 'Matthews','+18302141991',1,6),
				 (23, 'Alejandro', 'Ross','+13253335408',1,7),
				 (24, 'Leigh', 'Chen','+17158869196',1,7),
				 (25, 'Ella', 'Zimmerman','+12527937375',1,8),
				 (26, 'Terry', 'Beasley','+18026812676',1,8),
				 (27, 'Joshua', 'Liu','+15732602154',1,9),
				 (28, 'Johanna', 'Zimmerman','+18125887502',1,9),
				 (29, 'Joanna', 'Gibson','+13869170830',1,10),
				 (30, 'Abel', 'Santos','+12018128624',1,10),
				 (31, 'Kathy', 'Morris','+12527937375',1,11),
				 (32, 'Amos', 'Beasley','+18026812676',1,11),
				 (33, 'Karen', 'Berry','+15732602154',1,12),
				 (34, 'Franco', 'Ho','+18125887502',1,12),
				 (35, 'Wendy', 'Mack','+13869170830',1,13),
				 (36, 'Laverne', 'Glass','+12018128624',1,13),
			 (37, 'Larry', 'Pierce','+15732602154',2,1),
				 (38, 'Jody', 'Davis','+18125887502',2,1),
				 (39, 'Emma', 'Reese','+13869170830',2,2),
				 (40, 'Patricia', 'Strickland','+12018128624',2,2),
				 (41, 'Michael', 'Goodwin','+12527937375',2,3),
				 (42, 'Jean', 'Beasley','+18026812676',2,3),
				 (43, 'Sheryl', 'Banks','+15732602154',2,4),
				 (44, 'Arturo', 'Ho','+18125887502',2,4),
				 (45, 'Teri', 'Banks','+13869170830',2,5),
				 (46, 'Katherine', 'Glass','+12018128624',2,5),				 
				 (47, 'Alison', 'Liu','+15732602154',2,6),
				 (48, 'Cynthia', 'Zimmerman','+18125887502',2,6),
				 (49, 'Arthur', 'Banks','+13869170830',2,7),
				 (50, 'Stacy', 'Santos','+12018128624',2,7),
				 (51, 'Stan', 'Morris','+12527937375',2,8),
				 (52, 'Iris', 'Andrews','+18026812676',2,9),
				 (53, 'Monica', 'Berry','+15732602154',2,10),
				 (54, 'Winnie', 'Ho','+18125887502',2,11),
				 (55, 'Brain', 'Bell','+13869170830',2,12),
				 (56, 'Roosevelt', 'Miller','+12018128624',2,13),
			 (57, 'Donald', 'Perry','+15732602154',3,1),
				 (58, 'Rebecca', 'Hernandez','+18125887502',3,2),
				 (59, 'Deborah', 'Brooks','+13869170830',3,3),
				 (60, 'Rose', 'Murphy','+12018128624',3,4),
				 (61, 'Michelle', 'Richardson','+12527937375',3,5),
				 (62, 'Brian', 'Roberts','+18026812676',3,6),
				 (63, 'Joyce', 'Lee','+15732602154',3,7),
				 (64, 'Samuel', 'Hall','+18125887502',3,8),
				 (65, 'Emily', 'Curry','+13869170830',3,9),
				 (66, 'Beverly', 'Thompson','+12018128624',3, 10),				 
				 (67, 'Ryan', 'Perez','+15732602154',3, 11),
				 (68, 'Roy', 'Young','+18125887502',3, 12),
				 (69, 'Roger', 'Ward','+13869170830',3, 13),
				 (70, 'George', 'Reed','+12018128624',3, 13),
				 (71, 'Sara', 'Morgan','+12527937375',4, 1),
				 (72, 'Helen', 'Andrews','+18026812676',4, 2),
				 (73, 'Teresa', 'Allen','+15732602154',4, 3),
				 (74, 'Marie', 'Richardson','+18125887502',4, 4),
				 (75, 'Brain', 'Bell','+13869170830',4, 5),
				 (76, 'Roosevelt', 'Miller','+12018128624',4, 6),				 
				 (77, 'Alison', 'Liu','+15732602154',4,7),
				 (78, 'Cynthia', 'Zimmerman','+18125887502',4,8),
				 (79, 'Arthur', 'Banks','+13869170830',4,9),
				 (80, 'Stacy', 'Santos','+12018128624',4,10),
				 (81, 'Cynthia', 'Zimmerman','+18125887502',4,11),
				 (82, 'Arthur', 'Banks','+13869170830',4,12),
				 (83, 'Stacy', 'Santos','+12018128624',4,13),
				  (84, 'Paul', 'Simmons','+18125887502',5,1),
				 (85, 'Jonathan', 'Parker','+13869170830',5,2),
				 (86, 'Ruby', 'Thompson','+12018128624',5, 3),				 
				 (87, 'Sandra', 'Flores','+15732602154',6,8),
				 (88, 'Randy', 'Morgan','+18125887502',5,5),
				 (89, 'Dorothy', 'Ward','+13869170830',5,6),
				 (90, 'Joe', 'Reed','+12018128624',5,7),
				 (91, 'Debra', 'Morgan','+12527937375',5,8),
				 (92, 'Maria', 'Andrews','+18026812676',5,9),
				 (93, 'Mariette', 'Allen','+15732602154',5,10),
				 (94, 'Cathryn', 'Richardson','+18125887502',5,11),
				 (95, 'Galen', 'Bell','+13869170830',5,12),
				 (96, 'Vania', 'Miller','+12018128624',5,13),				 
				 (97, 'Dian', 'Liu','+15732602154',6,1),
				 (98, 'Shamika', 'Zimmerman','+18125887502',6,2),
				 (99, 'Jeff', 'Banks','+13869170830',6,3),
				 (100, 'Jerry', 'Santos','+12018128624',6,4),
				 (101, 'Kenny', 'Zimmerman','+18125887502',6,9),
				 (102, 'Jacob', 'Banks','+13869170830',6,6),
				 (103, 'Freeman', 'Santos','+12018128624',6,7),
				 (104, 'Kerry', 'Lan','+18125887502',6,10),
				 (105, 'Amy', 'Curry','+13869170830',6,11),
				 (106, 'Annie', 'Thompson','+12018128624',6,12),				 
				 (107, 'Mia', 'Page','+15732602154',6,13),
				 (108, 'Benjamin', 'Barlowe','+18125887502',7,5),
				 (109, 'Phillip', 'Caddel','+13869170830',7,1),
				 (110, 'Luther', 'Hart','+12018128624',7,7),
				 (111, 'Earl', 'Katz','+12527937375',7,8),
				 (112, 'Suzanne', 'Madden','+18026812676',7,9),
				 (113, 'Estelle', 'Elrod','+15732602154',7,10),
				 (114, 'Kim', 'Whitlock','+18125887502',7,11),
				 (115, 'Ralph', 'Hope','+13869170830',7,12),
				 (116, 'Lester', 'McKenna','+12018128624',7,13),				 
				 (117, 'Jana', 'Liu','+15732602154',8,1),
				 (118, 'Jeff', 'Zimmerman','+18125887502',8,2),
				 (119, 'Maurice', 'Banks','+13869170830',8,3),
				 (120, 'Harriet', 'Su','+12018128624',8,4),
				 (121, 'Gary', 'Zimmerman','+18125887502',8,9),
				 (122, 'Ali', 'Wang','+13869170830',8,6),
				 (123, 'Beatriz', 'Santos','+12018128624',8,7),
				 (124, 'Charles', 'Dawson','+18125887502',8,10),
				 (125, 'Amy', 'Curry','+13869170830',8,11),
				 (126, 'Diya', 'Thompson','+12018128624',8,12),				 
				 (127, 'Kiki', 'Page','+15732602154',8,13),
				 (128, 'Eric', 'Morgan','+18125887502',7,2),
				 (129, 'Hanna', 'Ward','+13869170830',7,3),
				 (130, 'Gabriel', 'Finnegan','+12018128624',7,4),
				  (131, 'Selena', 'Huffman','+12527937375',9,1),
				 (132, 'Sydnee', 'Hodge','+18026812676',9,2),
				 (133, 'Kylee', 'Ware','+15732602154',9,3),
				 (134, 'Danika', 'Haas','+18125887502',9,4),
				 (135, 'June', 'Dean','+13869170830',9,5),
				 (136, 'Adrianna', 'Fleming','+12018128624',9,6),				 
				 (137, 'Kathy', 'Rush','+15732602154',9,7),
				 (138, 'Cassie', 'Russell','+18125887502',9,8),
				 (139, 'Beckett', 'Bean','+13869170830',9,9),
				 (140, 'Sophia', 'Huffman','+12018128624',9, 10),
				 (141, 'Gary', 'Coffey','+18125887502',9,11),
				 (142, 'Steven', 'Wang','+13869170830',9,12),
				 (143, 'Marlee', 'Santos','+12018128624',9,13),
				 (144, 'Barrett', 'Dawson','+18125887502',10,1),
				 (145, 'Victoria', 'Dominguez','+13869170830',10,2),
				 (146, 'Julianne', 'Thompson','+12018128624',10,3),				 
				 (147, 'Amina', 'Page','+15732602154',10,4),
				 (148, 'Diana', 'Morgan','+18125887502',10,5),
				 (149, 'Edgar', 'Chang','+13869170830',10,6),
				 (150, 'Alvin', 'Chang','+12018128624',10,7),
				 (151, 'Claire', 'Chang','+18125887502',10,8),
				 (152, 'Hebe', 'Wang','+13869170830',10,9),
				 (153, 'Bella', 'Santos','+12018128624',10,10),
				 (154, 'Gina', 'Dawson','+18125887502',10,11),
				 (155, 'Ariel', 'Curry','+13869170830',10,12),
				 (156, 'Zoey', 'Thompson','+12018128624',10,13)	


---Pharmacy--------------------				
Insert into Pharmacy values (101,'Hydrocodone','Tablet: help relieve severe ongoing pain',1000,'2022-07-05',1);
Insert into Pharmacy values (201,'Hydrocodone','Tablet: help relieve severe ongoing pain',2000,'2022-07-05',2);
Insert into Pharmacy values (301,'Hydrocodone','Tablet: help relieve severe ongoing pain',3000,'2022-07-05',3);
Insert into Pharmacy values (401,'Hydrocodone','Tablet: help relieve severe ongoing pain',1000,'2022-07-05',4);
Insert into Pharmacy values (501,'Hydrocodone','Tablet: help relieve severe ongoing pain',1000,'2022-07-05',5);
Insert into Pharmacy values (601,'Hydrocodone','Tablet: help relieve severe ongoing pain',400,'2022-07-05',6);
Insert into Pharmacy values (701,'Hydrocodone','Tablet: help relieve severe ongoing pain',2000,'2022-07-20',7);
Insert into Pharmacy values (801,'Hydrocodone','Tablet: help relieve severe ongoing pain',3000,'2022-07-20',8);
Insert into Pharmacy values (901,'Hydrocodone','Tablet: help relieve severe ongoing pain',500,'2022-07-20',9);
Insert into Pharmacy values (1001,'Hydrocodone','Tablet: help relieve severe ongoing pain',1000,'2022-07-20',10);
Insert into Pharmacy values (102,'Metformin','Tablet: to control high blood sugar',10000,'2022-07-20',1);
Insert into Pharmacy values (202,'Metformin','Tablet: to control high blood sugar',20000,'2022-07-20',2);
Insert into Pharmacy values (302,'Metformin','Tablet: to control high blood sugar',30000,'2022-07-20',3);
Insert into Pharmacy values (402,'Metformin','Tablet: to control high blood sugar',10000,'2022-07-20',4);
Insert into Pharmacy values (502,'Metformin','Tablet: to control high blood sugar',10000,'2022-07-22',5);
Insert into Pharmacy values (602,'Metformin','Tablet: to control high blood sugar',4000,'2022-07-22',6);
Insert into Pharmacy values (702,'Metformin','Tablet: to control high blood sugar',20000,'2022-07-22',7);
Insert into Pharmacy values (802,'Metformin','Tablet: to control high blood sugar',30000,'2022-07-22',8);
Insert into Pharmacy values (902,'Metformin','Tablet: to control high blood sugar',5000,'2022-07-22',9);
Insert into Pharmacy values (1002,'Metformin','Tablet: to control high blood sugar',10000,'2022-07-22',10);
Insert into Pharmacy values (103,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',5000,'2022-07-22',1);
Insert into Pharmacy values (203,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',2500,'2022-07-22',2);
Insert into Pharmacy values (303,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',3000,'2022-07-22',3);
Insert into Pharmacy values (403,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',10000,'2022-07-24',4);
Insert into Pharmacy values (503,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',5000,'2022-07-24',5);
Insert into Pharmacy values (603,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',4000,'2022-07-24',6);
Insert into Pharmacy values (703,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',10000,'2022-07-24',7);
Insert into Pharmacy values (803,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',3000,'2022-07-24',8);
Insert into Pharmacy values (903,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',5000,'2022-07-24',9);
Insert into Pharmacy values (1003,'Losartan','Tablet: Tablet:to treat whigh blood pressure ',10000,'2022-07-27',10);
Insert into Pharmacy values (104,'Albuterol','Tablet:to treat wheezing ,breathing prob',50000,'2022-07-27',1);
Insert into Pharmacy values (204,'Albuterol','Tablet:to treat wheezing ,breathing prob',25000,'2022-07-27',2);
Insert into Pharmacy values (304,'Albuterol','Tablet:to treat wheezing ,breathing prob',30000,'2022-07-27',3);
Insert into Pharmacy values (404,'Albuterol','Tablet:to treat wheezing ,breathing prob',10000,'2022-07-27',4);
Insert into Pharmacy values (504,'Albuterol','Tablet:to treat wheezing ,breathing prob',50000,'2022-07-27',5);
Insert into Pharmacy values (604,'Albuterol','Tablet:to treat wheezing ,breathing prob',40000,'2022-07-27',6);
Insert into Pharmacy values (704,'Albuterol','Tablet:to treat wheezing ,breathing prob',10000,'2022-07-27',7);
Insert into Pharmacy values (804,'Albuterol','Tablet:to treat wheezing ,breathing prob',30000,'2022-07-27',8);
Insert into Pharmacy values (904,'Albuterol','Tablet:to treat wheezing ,breathing prob',5000,'2022-07-29',9);
Insert into Pharmacy values (1004,'Albuterol','Tablet:to treat wheezing ,breathing prob',10000,'2022-07-27',10);
Insert into Pharmacy values (105,'Paracetamol','Tablet: Fever',5000,'2022-07-29',1);
Insert into Pharmacy values (205,'Paracetamol','Tablet: Fever',2500,'2022-07-29',2);
Insert into Pharmacy values (305,'Paracetamol','Tablet: Fever',3000,'2022-07-29',3);
Insert into Pharmacy values (405,'Paracetamol','Tablet: Fever',10000,'2022-07-29',4);
Insert into Pharmacy values (505,'Paracetamol','Tablet: Fever',5000,'2022-07-29',5);
Insert into Pharmacy values (605,'Paracetamol','Tablet: Fever',4000,'2022-07-29',6);
Insert into Pharmacy values (705,'Paracetamol','Tablet: Fever',10000,'2022-07-29',7);
Insert into Pharmacy values (805,'Paracetamol','Tablet: Fever',3000,'2022-07-29',8);
Insert into Pharmacy values (905,'Paracetamol','Tablet: Fever',5000,'2022-07-29',9);
Insert into Pharmacy values (1005,'Paracetamol','Tablet: Fever',1500,'2022-07-29',10);


--Patient----------
insert into Patient values(1, 'David','W','Warner','davidwarner@gmail.com', 2346547890, '06-05-1988', 'M', '07-30-2022', '75 Saint Street', 'Boston','MA', 22102);
insert into Patient values(2, 'Virat','A','Kohli','virat.kohli@gmail.com', 3364457420, '06-07-1998', 'M', '07-30-2021', '21 Smith Street', 'NewYork','NY', 22120);
insert into Patient values(3, 'Rohit','S','Sharma','sharma.rohit@gmail.com', 6265988004, '10-16-1965', 'M', '12-30-2021', 'Fenway Park Street', 'Los Angeles','CA', 99950);
insert into Patient values(4, 'Rishab','M','Pant','pant.rish@gmail.com', 3697516998, '04-09-1984', 'M', '01-12-2022', '370 Huntington Street', 'San Diego','CA', 85001);
insert into Patient values(5, 'Mayank','R','Gandhi','mayank.g@gmail.com', 6265988004, '05-13-2005', 'M', '05-20-2022', '75 Tremont Street', 'San Francisco','CA', 12112);
insert into Patient values(6, 'Niyati','M','Shah','shah.niyati@gmail.com', 7804055277, '09-27-2007', 'F', '05-20-2022', '21A Highland Street', 'San Diego','CA', 21002);
insert into Patient values(7, 'Moksha','A','Doshi','doshi.mok@gmail.com', 8451031651, '11-04-2002', 'F', '07-30-2022', '2C Smith Street', 'Austin','TX', 40002);
insert into Patient values(8, 'Krushna','A','Tyagi','ktyagi@gmail.com', 5877839071, '03-20-1999', 'F', '06-04-2022', ' Roxbury Crossing Park Street', 'Nashville','TN', 40001);
insert into Patient values(9, 'Sanay','S','Shah','shahsanay@gmail.com', 7804056507, '04-12-1996', 'M', '06-20-2022', 'Parker Street Near Lechmere', 'San Jose','CA', 99950);
insert into Patient values(10, 'Albert','W','Pruto','pruto.albert@gmail.com', 7804053849, '04-25-1997', 'M', '03-23-2022', '12 Downtown Jamaican Plain', 'San Antonio','TX', 35004);
insert into Patient values(11, 'David','P','Paul','davidpaul@gmail.com', 1346547878, '01-02-1986', 'M', '04-10-2022', '85 Saint Street', 'Boston','MA', 22102);
insert into Patient values(12, 'Viraj','M','Kali','virat.kali@gmail.com', 3364457420, '06-07-1998', 'M', '04-30-2021', '21 Smith Street', 'NewYork','NY', 22120);
insert into Patient values(13, 'Rajat','S','Sharma','sharma.rajat@gmail.com', 6265988004, '10-16-1965', 'M', '01-30-2021', 'Fenway Park Street', 'Los Angeles','CA', 99950);
insert into Patient values(14, 'Roashan','M','Subhash','subh.rosh@gmail.com', 3697516998, '04-09-1984', 'M', '01-12-2022', '370 Huntington Street', 'San Diego','CA', 85001);
insert into Patient values(15, 'Maya','R','Gandhi','maya.g@gmail.com', 6265988004, '05-13-2005', 'M', '01-20-2022', '75 Tremont Street', 'San Francisco','CA', 12112);
insert into Patient values(16, 'Niya','M','Shah','shah.niya@gmail.com', 7804055277, '09-27-2007', 'F', '01-25-2022', '21A Highland Street', 'San Diego','CA', 21002);
insert into Patient values(17, 'Mohan','A','Das','das.mohan@gmail.com', 8451031651, '11-04-2002', 'F', '01-10-2022', '2C Smith Street', 'Austin','TX', 40002);
insert into Patient values(18, 'Krish','A','Kapoor','kkrish@gmail.com', 5877839071, '03-20-1999', 'F', '01-04-2022', ' Roxbury Crossing Park Street', 'Nashville','TN', 40001);
insert into Patient values(19, 'Sanay','S','Patel','patelsanay@gmail.com', 7804056507, '04-12-1996', 'M', '01-20-2022', 'Parker Street Near Lechmere', 'San Jose','CA', 99950);
insert into Patient values(20, 'Alam','W','Rito','rito.alam@gmail.com', 7804053849, '04-25-1997', 'M', '01-23-2022', '12 Downtown Jamaican Plain', 'San Antonio','TX', 35004);
insert into Patient values(21, 'Sam','G','Pat','patsam@gmail.com', 2346547890, '06-05-1988', 'M', '01-10-2022', '75 Saint Street', 'Boston','MA', 22102);
insert into Patient values(22, 'Vikas','A','Purohit','vikas.purohit@gmail.com', 3364457420, '06-07-1998', 'M', '01-30-2021', '21 Smith Street', 'NewYork','NY', 22120);
insert into Patient values(23, 'Neha','D','Dongre','neha.d@gmail.com', 6265988004, '10-16-1996', 'F', '11-30-2021', 'Fenway Park Street', 'Los Angeles','CA', 99950);
insert into Patient values(24, 'Rish','M','Dave','dave.rish@gmail.com', 3697516998, '04-09-1984', 'M', '01-12-2022', '370 Huntington Street', 'San Diego','CA', 85001);
insert into Patient values(25, 'Sagar','P','Gandhi','sagar.g@gmail.com', 6265988004, '05-13-2005', 'M', '04-20-2022', '75 Tremont Street', 'San Francisco','CA', 12112);
insert into Patient values(26, 'Niyam','M','Shah','shah.niyam@gmail.com', 7804055277, '09-27-2007', 'M', '04-20-2022', '21A Highland Street', 'San Diego','CA', 21002);
insert into Patient values(27, 'Moksh','A','Doshi','doshi.mok@gmail.com', 8451031651, '11-04-2002', 'M', '04-30-2022', '2C Smith Street', 'Austin','TX', 40002);
insert into Patient values(28, 'Kajal','A','Tyagi','ktyagi@gmail.com', 5877839071, '03-20-1999', 'F', '01-04-2022', ' Roxbury Crossing Park Street', 'Nashville','TN', 40001);
insert into Patient values(29, 'Manay','S','Shah','shahmanay@gmail.com', 7804056507, '04-12-1996', 'M', '04-20-2022', 'Parker Street Near Lechmere', 'San Jose','CA', 99950);
insert into Patient values(30, 'Adam','W','Pauja','pauja.adam@gmail.com', 7804053849, '04-25-1997', 'M', '03-23-2022', '12 Downtown Jamaican Plain', 'San Antonio','TX', 35004);
insert into Patient values(31, 'Benjamin','T','Franklin','frankbenj@gmail.com', 2346547890, '06-05-1988', 'M', '04-30-2022', '75 Saint Street', 'Boston','MA', 22102);
insert into Patient values(32, 'Viral','H','Gohil','viral.gohil@gmail.com', 3364457420, '06-07-1998', 'M', '03-30-2021', '21 Smith Street', 'NewYork','NY', 22120);
insert into Patient values(33, 'Roshni','S','Sharma','sharma.rosh@gmail.com', 6265988004, '10-16-1995', 'F', '12-30-2021', 'Fenway Park Street', 'Los Angeles','CA', 99950);
insert into Patient values(34, 'Rishi','M','Gavkar','g.rishi@gmail.com', 3697516998, '04-09-1984', 'M', '01-12-2022', '370 Huntington Street', 'San Diego','CA', 85001);
insert into Patient values(35, 'Mayur','R','Pandey','mayur.p@gmail.com', 6265988004, '05-13-2005', 'M', '01-20-2022', '75 Tremont Street', 'San Francisco','CA', 12112);
insert into Patient values(36, 'Namo','M','Pandey','pandey.namo@gmail.com', 7804055277, '09-27-2007', 'F', '01-20-2022', '21A Highland Street', 'San Diego','CA', 21002);
insert into Patient values(37, 'Nita','A','Doshi','doshi.nita@gmail.com', 8451031651, '11-04-1968', 'F', '01-30-2022', '2C Smith Street', 'Austin','TX', 40002);
insert into Patient values(38, 'Rajvi','S','Porwal','prajvi@gmail.com', 5877839071, '03-20-1995', 'F', '01-04-2022', ' Roxbury Crossing Park Street', 'Nashville','TN', 40001);
insert into Patient values(39, 'Het','S','Shah','shahhet@gmail.com', 7804056507, '11-04-2004', 'M', '01-20-2022', 'Parker Street Near Lechmere', 'San Jose','CA', 99950);
insert into Patient values(40, 'Ajay','A','Doshi','doshi.ajay@gmail.com', 7804053849, '04-25-1967', 'M', '01-23-2022', '12 Downtown Jamaican Plain', 'San Antonio','TX', 35004);
insert into Patient values(41, 'Barney','T','Stinson','sbarney@gmail.com', 2346547890, '06-05-1968', 'M', '04-30-2022', '75 Saint Street', 'Boston','MA', 22102);
insert into Patient values(42, 'Marshal','H','Ericksen','marshal.eric@gmail.com', 3364457420, '06-07-1998', 'M', '03-30-2021', '21 Smith Street', 'NewYork','NY', 22120);
insert into Patient values(43, 'Robin','S','Schrebatsky','srobin@gmail.com', 6265988004, '10-16-1995', 'F', '12-30-2021', 'Fenway Park Street', 'Los Angeles','CA', 99950);
insert into Patient values(44, 'Ted','M','Mosby','m.ted@gmail.com', 3697516998, '04-09-1984', 'M', '01-12-2022', '370 Huntington Street', 'San Diego','CA', 85001);
insert into Patient values(45, 'Lily','M','Ericksen','e.lily@gmail.com', 6265988004, '05-13-2005', 'M', '01-20-2022', '75 Tremont Street', 'San Francisco','CA', 12112);
insert into Patient values(46, 'Namo','M','Guhad','pandey.namo@gmail.com', 7804055277, '09-27-2007', 'F', '01-20-2022', '21A Highland Street', 'San Diego','CA', 21002);
insert into Patient values(47, 'Sara','S','Khan','khansara@gmail.com', 8451031651, '11-04-1992', 'F', '01-30-2022', '2C Smith Street', 'Austin','TX', 40002);
insert into Patient values(48, 'Samuel','S','Adam','adamsam@gmail.com', 5877839071, '03-20-1995', 'F', '01-04-2022', ' Roxbury Crossing Park Street', 'Nashville','TN', 40001);
insert into Patient values(49, 'Khilji','S','Shah','shahkhilji@gmail.com', 7804056507, '11-04-2004', 'M', '01-20-2022', 'Parker Street Near Lechmere', 'San Jose','CA', 99950);
insert into Patient values(50, 'Asma','A','Kyle','kyleasma@gmail.com', 4804053849, '04-21-1987', 'F', '01-23-2022', '2 Downtown Jamaican Plain', 'San Antonio','TX', 35004);

			
----Ward----------------------
INSERT INTO Ward VALUES (1, 'ICU', 2, 10);
INSERT INTO Ward VALUES (2, 'General', 3, 2);
INSERT INTO Ward VALUES (3, 'Emergency', 4, 8);
INSERT INTO Ward VALUES (4, 'ICU', 4, 4);
INSERT INTO Ward VALUES (5, 'General', 4, 1);
INSERT INTO Ward VALUES (6, 'ICU', 4, 10);
INSERT INTO Ward VALUES (7, 'Emergency', 4, 5);
INSERT INTO Ward VALUES (8, 'ICU', 2, 10);
INSERT INTO Ward VALUES (9, 'ICU', 3, 1);
INSERT INTO Ward VALUES (10, 'ICU', 1, 9);
INSERT INTO Ward VALUES (11, 'General', 4, 4);
INSERT INTO Ward VALUES (12, 'ICU', 1, 9);
INSERT INTO Ward VALUES (13, 'Emergency', 4, 8);
INSERT INTO Ward VALUES (14, 'ICU', 2, 6);
INSERT INTO Ward VALUES (15, 'General', 2, 8);
INSERT INTO Ward VALUES (16, 'Emergency', 1, 7);
INSERT INTO Ward VALUES (17, 'Emergency', 1, 3);
INSERT INTO Ward VALUES (18, 'Emergency', 3, 2);
INSERT INTO Ward VALUES (19, 'General', 3, 9);
INSERT INTO Ward VALUES (20, 'General', 5, 4);
INSERT INTO Ward VALUES (21, 'General', 3, 10);
INSERT INTO Ward VALUES (22, 'Emergency', 5, 7);
INSERT INTO Ward VALUES (23, 'ICU', 1, 8);
INSERT INTO Ward VALUES (24, 'Emergency', 4, 7);
INSERT INTO Ward VALUES (25, 'Emergency', 2, 6);
INSERT INTO Ward VALUES (26, 'General', 3, 2);
INSERT INTO Ward VALUES (27, 'ICU', 5, 2);
INSERT INTO Ward VALUES (28, 'General', 5, 7);
INSERT INTO Ward VALUES (29, 'General', 4, 1);
INSERT INTO Ward VALUES (30, 'Emergency', 1, 5);
INSERT INTO Ward VALUES (31, 'Emergency', 5, 10);
INSERT INTO Ward VALUES (32, 'ICU', 4, 3);
INSERT INTO Ward VALUES (33, 'ICU', 5, 4);
INSERT INTO Ward VALUES (34, 'Emergency', 2, 9);
INSERT INTO Ward VALUES (35, 'Emergency', 2, 7);
INSERT INTO Ward VALUES (36, 'General', 3, 10);
INSERT INTO Ward VALUES (37, 'Emergency', 4, 5);
INSERT INTO Ward VALUES (38, 'Emergency', 5, 10);
INSERT INTO Ward VALUES (39, 'Emergency', 1, 7);
INSERT INTO Ward VALUES (40, 'Emergency', 5, 3);
INSERT INTO Ward VALUES (41, 'General', 5, 4);
INSERT INTO Ward VALUES (42, 'General', 1, 8);
INSERT INTO Ward VALUES (43, 'ICU', 5, 9);
INSERT INTO Ward VALUES (44, 'General', 5, 7);
INSERT INTO Ward VALUES (45, 'General', 3, 7);
INSERT INTO Ward VALUES (46, 'Emergency', 1, 9);
INSERT INTO Ward VALUES (47, 'General', 5, 10);
INSERT INTO Ward VALUES (48, 'ICU', 4, 10);
INSERT INTO Ward VALUES (49, 'Emergency', 2, 3);
INSERT INTO Ward VALUES (50, 'ICU', 5, 3);


----Room_Details-----------------
INSERT INTO Room_Details VALUES (1, 'B', 'Yes', 36);
INSERT INTO Room_Details VALUES (2, 'A', 'Yes', 44);
INSERT INTO Room_Details VALUES (3, 'B', 'Yes', 2);
INSERT INTO Room_Details VALUES (4, 'B', 'Yes', 49);
INSERT INTO Room_Details VALUES (5, 'A', 'Yes', 18);
INSERT INTO Room_Details VALUES (6, 'B', 'Yes', 23);
INSERT INTO Room_Details VALUES (7, 'A', 'No', 11);
INSERT INTO Room_Details VALUES (8, 'A', 'No', 34);
INSERT INTO Room_Details VALUES (9, 'C', 'No', 42);
INSERT INTO Room_Details VALUES (10, 'C', 'No', 30);
INSERT INTO Room_Details VALUES (11, 'B', 'Yes', 32);
INSERT INTO Room_Details VALUES (12, 'B', 'No', 2);
INSERT INTO Room_Details VALUES (13, 'B', 'Yes', 22);
INSERT INTO Room_Details VALUES (14, 'A', 'No', 17);
INSERT INTO Room_Details VALUES (15, 'C', 'Yes', 47);
INSERT INTO Room_Details VALUES (16, 'B', 'Yes', 39);
INSERT INTO Room_Details VALUES (17, 'A', 'No', 15);
INSERT INTO Room_Details VALUES (18, 'A', 'Yes', 10);
INSERT INTO Room_Details VALUES (19, 'C', 'No', 29);
INSERT INTO Room_Details VALUES (20, 'A', 'No', 35);
INSERT INTO Room_Details VALUES (21, 'C', 'Yes', 15);
INSERT INTO Room_Details VALUES (22, 'C', 'No', 26);
INSERT INTO Room_Details VALUES (23, 'C', 'No', 43);
INSERT INTO Room_Details VALUES (24, 'C', 'No', 4);
INSERT INTO Room_Details VALUES (25, 'A', 'Yes', 9);
INSERT INTO Room_Details VALUES (26, 'A', 'Yes', 20);
INSERT INTO Room_Details VALUES (27, 'B', 'Yes', 20);
INSERT INTO Room_Details VALUES (28, 'C', 'No', 27);
INSERT INTO Room_Details VALUES (29, 'A', 'Yes', 9);
INSERT INTO Room_Details VALUES (30, 'A', 'No', 38);
INSERT INTO Room_Details VALUES (31, 'C', 'Yes', 11);
INSERT INTO Room_Details VALUES (32, 'A', 'No', 25);
INSERT INTO Room_Details VALUES (33, 'A', 'No', 7);
INSERT INTO Room_Details VALUES (34, 'A', 'No', 38);
INSERT INTO Room_Details VALUES (35, 'C', 'No', 7);
INSERT INTO Room_Details VALUES (36, 'C', 'No', 19);
INSERT INTO Room_Details VALUES (37, 'B', 'No', 2);
INSERT INTO Room_Details VALUES (38, 'A', 'Yes', 19);
INSERT INTO Room_Details VALUES (39, 'B', 'Yes', 13);
INSERT INTO Room_Details VALUES (40, 'B', 'Yes', 22);
INSERT INTO Room_Details VALUES (41, 'C', 'Yes', 18);
INSERT INTO Room_Details VALUES (42, 'C', 'No', 25);
INSERT INTO Room_Details VALUES (43, 'C', 'No', 44);
INSERT INTO Room_Details VALUES (44, 'C', 'Yes', 50);
INSERT INTO Room_Details VALUES (45, 'C', 'Yes', 5);
INSERT INTO Room_Details VALUES (46, 'A', 'Yes', 6);
INSERT INTO Room_Details VALUES (47, 'C', 'Yes', 11);
INSERT INTO Room_Details VALUES (48, 'B', 'No', 18);
INSERT INTO Room_Details VALUES (49, 'B', 'No', 24);
INSERT INTO Room_Details VALUES (50, 'B', 'Yes', 8);
INSERT INTO Room_Details VALUES (51, 'C', 'No', 39);
INSERT INTO Room_Details VALUES (52, 'C', 'Yes', 9);
INSERT INTO Room_Details VALUES (53, 'A', 'No', 21);
INSERT INTO Room_Details VALUES (54, 'B', 'Yes', 5);
INSERT INTO Room_Details VALUES (55, 'B', 'Yes', 9);
INSERT INTO Room_Details VALUES (56, 'C', 'No', 40);
INSERT INTO Room_Details VALUES (57, 'C', 'Yes', 5);
INSERT INTO Room_Details VALUES (58, 'A', 'No', 37);
INSERT INTO Room_Details VALUES (59, 'B', 'Yes', 24);
INSERT INTO Room_Details VALUES (60, 'B', 'Yes', 30);
INSERT INTO Room_Details VALUES (61, 'B', 'Yes', 3);
INSERT INTO Room_Details VALUES (62, 'C', 'Yes', 40);
INSERT INTO Room_Details VALUES (63, 'B', 'Yes', 6);
INSERT INTO Room_Details VALUES (64, 'A', 'Yes', 3);
INSERT INTO Room_Details VALUES (65, 'B', 'Yes', 38);
INSERT INTO Room_Details VALUES (66, 'B', 'Yes', 8);
INSERT INTO Room_Details VALUES (67, 'A', 'Yes', 44);
INSERT INTO Room_Details VALUES (68, 'A', 'No', 48);
INSERT INTO Room_Details VALUES (69, 'C', 'No', 25);
INSERT INTO Room_Details VALUES (70, 'B', 'No', 36);
INSERT INTO Room_Details VALUES (71, 'A', 'Yes', 21);
INSERT INTO Room_Details VALUES (72, 'B', 'Yes', 42);
INSERT INTO Room_Details VALUES (73, 'A', 'No', 2);
INSERT INTO Room_Details VALUES (74, 'C', 'No', 47);
INSERT INTO Room_Details VALUES (75, 'B', 'No', 29);
INSERT INTO Room_Details VALUES (76, 'A', 'Yes', 26);
INSERT INTO Room_Details VALUES (77, 'C', 'No', 21);
INSERT INTO Room_Details VALUES (78, 'B', 'Yes', 8);
INSERT INTO Room_Details VALUES (79, 'C', 'No', 40);
INSERT INTO Room_Details VALUES (80, 'B', 'No', 43);
INSERT INTO Room_Details VALUES (81, 'C', 'Yes', 12);
INSERT INTO Room_Details VALUES (82, 'A', 'Yes', 20);
INSERT INTO Room_Details VALUES (83, 'A', 'No', 24);
INSERT INTO Room_Details VALUES (84, 'B', 'Yes', 6);
INSERT INTO Room_Details VALUES (85, 'C', 'No', 42);
INSERT INTO Room_Details VALUES (86, 'B', 'No', 15);
INSERT INTO Room_Details VALUES (87, 'B', 'Yes', 3);
INSERT INTO Room_Details VALUES (88, 'C', 'No', 21);
INSERT INTO Room_Details VALUES (89, 'B', 'Yes', 16);
INSERT INTO Room_Details VALUES (90, 'C', 'Yes', 35);
INSERT INTO Room_Details VALUES (91, 'A', 'Yes', 16);
INSERT INTO Room_Details VALUES (92, 'B', 'Yes', 16);
INSERT INTO Room_Details VALUES (93, 'C', 'Yes', 18);
INSERT INTO Room_Details VALUES (94, 'A', 'Yes', 47);
INSERT INTO Room_Details VALUES (95, 'A', 'No', 41);
INSERT INTO Room_Details VALUES (96, 'B', 'No', 49);
INSERT INTO Room_Details VALUES (97, 'A', 'Yes', 31);
INSERT INTO Room_Details VALUES (98, 'B', 'Yes', 33);
INSERT INTO Room_Details VALUES (99, 'C', 'Yes', 33);
INSERT INTO Room_Details VALUES (100, 'A', 'Yes', 12);
INSERT INTO Room_Details VALUES (101, 'B', 'Yes', 21);
INSERT INTO Room_Details VALUES (102, 'C', 'No', 46);
INSERT INTO Room_Details VALUES (103, 'A', 'Yes', 9);
INSERT INTO Room_Details VALUES (104, 'C', 'Yes', 35);
INSERT INTO Room_Details VALUES (105, 'B', 'Yes', 50);
INSERT INTO Room_Details VALUES (106, 'B', 'No', 12);
INSERT INTO Room_Details VALUES (107, 'A', 'Yes', 35);
INSERT INTO Room_Details VALUES (108, 'C', 'Yes', 46);
INSERT INTO Room_Details VALUES (109, 'A', 'No', 17);
INSERT INTO Room_Details VALUES (110, 'C', 'No', 28);
INSERT INTO Room_Details VALUES (111, 'B', 'No', 35);
INSERT INTO Room_Details VALUES (112, 'B', 'No', 1);
INSERT INTO Room_Details VALUES (113, 'B', 'No', 11);
INSERT INTO Room_Details VALUES (114, 'C', 'No', 2);
INSERT INTO Room_Details VALUES (115, 'A', 'Yes', 37);
INSERT INTO Room_Details VALUES (116, 'B', 'Yes', 45);
INSERT INTO Room_Details VALUES (117, 'A', 'Yes', 38);
INSERT INTO Room_Details VALUES (118, 'B', 'No', 17);
INSERT INTO Room_Details VALUES (119, 'B', 'Yes', 37);
INSERT INTO Room_Details VALUES (120, 'A', 'Yes', 40);
INSERT INTO Room_Details VALUES (121, 'A', 'Yes', 32);
INSERT INTO Room_Details VALUES (122, 'B', 'No', 34);
INSERT INTO Room_Details VALUES (123, 'C', 'Yes', 44);
INSERT INTO Room_Details VALUES (124, 'B', 'No', 16);
INSERT INTO Room_Details VALUES (125, 'B', 'Yes', 44);
INSERT INTO Room_Details VALUES (126, 'B', 'No', 46);
INSERT INTO Room_Details VALUES (127, 'C', 'No', 36);
INSERT INTO Room_Details VALUES (128, 'A', 'Yes', 42);
INSERT INTO Room_Details VALUES (129, 'C', 'No', 5);
INSERT INTO Room_Details VALUES (130, 'C', 'Yes', 11);
INSERT INTO Room_Details VALUES (131, 'B', 'No', 20);
INSERT INTO Room_Details VALUES (132, 'B', 'Yes', 36);
INSERT INTO Room_Details VALUES (133, 'C', 'No', 45);
INSERT INTO Room_Details VALUES (134, 'A', 'Yes', 39);
INSERT INTO Room_Details VALUES (135, 'C', 'No', 39);
INSERT INTO Room_Details VALUES (136, 'A', 'No', 12);
INSERT INTO Room_Details VALUES (137, 'A', 'Yes', 28);
INSERT INTO Room_Details VALUES (138, 'C', 'No', 32);
INSERT INTO Room_Details VALUES (139, 'C', 'No', 46);
INSERT INTO Room_Details VALUES (140, 'C', 'Yes', 25);
INSERT INTO Room_Details VALUES (141, 'C', 'Yes', 35);
INSERT INTO Room_Details VALUES (142, 'A', 'No', 34);
INSERT INTO Room_Details VALUES (143, 'A', 'No', 41);
INSERT INTO Room_Details VALUES (144, 'A', 'Yes', 48);
INSERT INTO Room_Details VALUES (145, 'C', 'Yes', 50);
INSERT INTO Room_Details VALUES (146, 'A', 'No', 29);
INSERT INTO Room_Details VALUES (147, 'B', 'Yes', 28);
INSERT INTO Room_Details VALUES (148, 'B', 'Yes', 21);
INSERT INTO Room_Details VALUES (149, 'B', 'Yes', 40);
INSERT INTO Room_Details VALUES (150, 'B', 'No', 8);


----Bed_Details----------
INSERT INTO Bed_Details VALUES (1, 'No', 31);
INSERT INTO Bed_Details VALUES (2, 'Yes', 72);
INSERT INTO Bed_Details VALUES (3, 'Yes', 97);
INSERT INTO Bed_Details VALUES (4, 'No', 49);
INSERT INTO Bed_Details VALUES (5, 'Yes', 149);
INSERT INTO Bed_Details VALUES (6, 'Yes', 8);
INSERT INTO Bed_Details VALUES (7, 'Yes', 67);
INSERT INTO Bed_Details VALUES (8, 'No', 45);
INSERT INTO Bed_Details VALUES (9, 'Yes', 38);
INSERT INTO Bed_Details VALUES (10, 'No', 70);
INSERT INTO Bed_Details VALUES (11, 'No', 150);
INSERT INTO Bed_Details VALUES (12, 'Yes', 115);
INSERT INTO Bed_Details VALUES (13, 'No', 140);
INSERT INTO Bed_Details VALUES (14, 'No', 126);
INSERT INTO Bed_Details VALUES (15, 'Yes', 32);
INSERT INTO Bed_Details VALUES (16, 'No', 147);
INSERT INTO Bed_Details VALUES (17, 'No', 53);
INSERT INTO Bed_Details VALUES (18, 'Yes', 28);
INSERT INTO Bed_Details VALUES (19, 'Yes', 31);
INSERT INTO Bed_Details VALUES (20, 'No', 140);
INSERT INTO Bed_Details VALUES (21, 'Yes', 35);
INSERT INTO Bed_Details VALUES (22, 'No', 129);
INSERT INTO Bed_Details VALUES (23, 'No', 147);
INSERT INTO Bed_Details VALUES (24, 'No', 112);
INSERT INTO Bed_Details VALUES (25, 'No', 136);
INSERT INTO Bed_Details VALUES (26, 'Yes', 1);
INSERT INTO Bed_Details VALUES (27, 'No', 114);
INSERT INTO Bed_Details VALUES (28, 'No', 90);
INSERT INTO Bed_Details VALUES (29, 'No', 139);
INSERT INTO Bed_Details VALUES (30, 'No', 87);
INSERT INTO Bed_Details VALUES (31, 'No', 29);
INSERT INTO Bed_Details VALUES (32, 'Yes', 98);
INSERT INTO Bed_Details VALUES (33, 'Yes', 143);
INSERT INTO Bed_Details VALUES (34, 'Yes', 72);
INSERT INTO Bed_Details VALUES (35, 'No', 119);
INSERT INTO Bed_Details VALUES (36, 'Yes', 79);
INSERT INTO Bed_Details VALUES (37, 'Yes', 116);
INSERT INTO Bed_Details VALUES (38, 'Yes', 93);
INSERT INTO Bed_Details VALUES (39, 'No', 100);
INSERT INTO Bed_Details VALUES (40, 'No', 104);
INSERT INTO Bed_Details VALUES (41, 'Yes', 150);
INSERT INTO Bed_Details VALUES (42, 'Yes', 127);
INSERT INTO Bed_Details VALUES (43, 'Yes', 75);
INSERT INTO Bed_Details VALUES (44, 'Yes', 105);
INSERT INTO Bed_Details VALUES (45, 'No', 102);
INSERT INTO Bed_Details VALUES (46, 'Yes', 46);
INSERT INTO Bed_Details VALUES (47, 'No', 3);
INSERT INTO Bed_Details VALUES (48, 'No', 68);
INSERT INTO Bed_Details VALUES (49, 'No', 140);
INSERT INTO Bed_Details VALUES (50, 'No', 39);
INSERT INTO Bed_Details VALUES (51, 'No', 67);
INSERT INTO Bed_Details VALUES (52, 'No', 44);
INSERT INTO Bed_Details VALUES (53, 'Yes', 131);
INSERT INTO Bed_Details VALUES (54, 'Yes', 70);
INSERT INTO Bed_Details VALUES (55, 'Yes', 109);
INSERT INTO Bed_Details VALUES (56, 'Yes', 91);
INSERT INTO Bed_Details VALUES (57, 'Yes', 114);
INSERT INTO Bed_Details VALUES (58, 'Yes', 43);
INSERT INTO Bed_Details VALUES (59, 'No', 24);
INSERT INTO Bed_Details VALUES (60, 'No', 71);
INSERT INTO Bed_Details VALUES (61, 'Yes', 54);
INSERT INTO Bed_Details VALUES (62, 'No', 61);
INSERT INTO Bed_Details VALUES (63, 'Yes', 69);
INSERT INTO Bed_Details VALUES (64, 'No', 20);
INSERT INTO Bed_Details VALUES (65, 'Yes', 120);
INSERT INTO Bed_Details VALUES (66, 'No', 44);
INSERT INTO Bed_Details VALUES (67, 'No', 143);
INSERT INTO Bed_Details VALUES (68, 'Yes', 92);
INSERT INTO Bed_Details VALUES (69, 'No', 101);
INSERT INTO Bed_Details VALUES (70, 'No', 45);
INSERT INTO Bed_Details VALUES (71, 'No', 67);
INSERT INTO Bed_Details VALUES (72, 'No', 57);
INSERT INTO Bed_Details VALUES (73, 'Yes', 63);
INSERT INTO Bed_Details VALUES (74, 'No', 104);
INSERT INTO Bed_Details VALUES (75, 'Yes', 111);
INSERT INTO Bed_Details VALUES (76, 'Yes', 69);
INSERT INTO Bed_Details VALUES (77, 'Yes', 19);
INSERT INTO Bed_Details VALUES (78, 'No', 149);
INSERT INTO Bed_Details VALUES (79, 'Yes', 149);
INSERT INTO Bed_Details VALUES (80, 'No', 68);
INSERT INTO Bed_Details VALUES (81, 'Yes', 135);
INSERT INTO Bed_Details VALUES (82, 'Yes', 36);
INSERT INTO Bed_Details VALUES (83, 'No', 113);
INSERT INTO Bed_Details VALUES (84, 'No', 80);
INSERT INTO Bed_Details VALUES (85, 'Yes', 62);
INSERT INTO Bed_Details VALUES (86, 'No', 53);
INSERT INTO Bed_Details VALUES (87, 'Yes', 18);
INSERT INTO Bed_Details VALUES (88, 'No', 59);
INSERT INTO Bed_Details VALUES (89, 'No', 83);
INSERT INTO Bed_Details VALUES (90, 'Yes', 26);
INSERT INTO Bed_Details VALUES (91, 'Yes', 12);
INSERT INTO Bed_Details VALUES (92, 'Yes', 6);
INSERT INTO Bed_Details VALUES (93, 'No', 9);
INSERT INTO Bed_Details VALUES (94, 'No', 136);
INSERT INTO Bed_Details VALUES (95, 'No', 88);
INSERT INTO Bed_Details VALUES (96, 'Yes', 31);
INSERT INTO Bed_Details VALUES (97, 'Yes', 25);
INSERT INTO Bed_Details VALUES (98, 'Yes', 103);
INSERT INTO Bed_Details VALUES (99, 'No', 127);
INSERT INTO Bed_Details VALUES (100, 'Yes', 97);
INSERT INTO Bed_Details VALUES (101, 'Yes', 60);
INSERT INTO Bed_Details VALUES (102, 'No', 73);
INSERT INTO Bed_Details VALUES (103, 'No', 141);
INSERT INTO Bed_Details VALUES (104, 'No', 55);
INSERT INTO Bed_Details VALUES (105, 'No', 67);
INSERT INTO Bed_Details VALUES (106, 'Yes', 128);
INSERT INTO Bed_Details VALUES (107, 'Yes', 55);
INSERT INTO Bed_Details VALUES (108, 'Yes', 12);
INSERT INTO Bed_Details VALUES (109, 'No', 2);
INSERT INTO Bed_Details VALUES (110, 'No', 82);
INSERT INTO Bed_Details VALUES (111, 'No', 149);
INSERT INTO Bed_Details VALUES (112, 'No', 51);
INSERT INTO Bed_Details VALUES (113, 'Yes', 41);
INSERT INTO Bed_Details VALUES (114, 'Yes', 8);
INSERT INTO Bed_Details VALUES (115, 'Yes', 100);
INSERT INTO Bed_Details VALUES (116, 'Yes', 139);
INSERT INTO Bed_Details VALUES (117, 'No', 145);
INSERT INTO Bed_Details VALUES (118, 'Yes', 66);
INSERT INTO Bed_Details VALUES (119, 'No', 21);
INSERT INTO Bed_Details VALUES (120, 'Yes', 78);
INSERT INTO Bed_Details VALUES (121, 'Yes', 10);
INSERT INTO Bed_Details VALUES (122, 'Yes', 135);
INSERT INTO Bed_Details VALUES (123, 'No', 11);
INSERT INTO Bed_Details VALUES (124, 'No', 31);
INSERT INTO Bed_Details VALUES (125, 'Yes', 24);
INSERT INTO Bed_Details VALUES (126, 'No', 8);
INSERT INTO Bed_Details VALUES (127, 'No', 34);
INSERT INTO Bed_Details VALUES (128, 'No', 50);
INSERT INTO Bed_Details VALUES (129, 'No', 100);
INSERT INTO Bed_Details VALUES (130, 'No', 69);
INSERT INTO Bed_Details VALUES (131, 'Yes', 63);
INSERT INTO Bed_Details VALUES (132, 'Yes', 16);
INSERT INTO Bed_Details VALUES (133, 'No', 90);
INSERT INTO Bed_Details VALUES (134, 'Yes', 144);
INSERT INTO Bed_Details VALUES (135, 'No', 91);
INSERT INTO Bed_Details VALUES (136, 'Yes', 138);
INSERT INTO Bed_Details VALUES (137, 'No', 138);
INSERT INTO Bed_Details VALUES (138, 'No', 18);
INSERT INTO Bed_Details VALUES (139, 'No', 19);
INSERT INTO Bed_Details VALUES (140, 'Yes', 46);
INSERT INTO Bed_Details VALUES (141, 'Yes', 39);
INSERT INTO Bed_Details VALUES (142, 'No', 53);
INSERT INTO Bed_Details VALUES (143, 'Yes', 12);
INSERT INTO Bed_Details VALUES (144, 'No', 24);
INSERT INTO Bed_Details VALUES (145, 'No', 129);
INSERT INTO Bed_Details VALUES (146, 'No', 26);
INSERT INTO Bed_Details VALUES (147, 'Yes', 11);
INSERT INTO Bed_Details VALUES (148, 'Yes', 137);
INSERT INTO Bed_Details VALUES (149, 'Yes', 114);
INSERT INTO Bed_Details VALUES (150, 'No', 102);
INSERT INTO Bed_Details VALUES (151, 'No', 7);
INSERT INTO Bed_Details VALUES (152, 'No', 24);
INSERT INTO Bed_Details VALUES (153, 'Yes', 84);
INSERT INTO Bed_Details VALUES (154, 'Yes', 78);
INSERT INTO Bed_Details VALUES (155, 'Yes', 99);
INSERT INTO Bed_Details VALUES (156, 'No', 67);
INSERT INTO Bed_Details VALUES (157, 'No', 34);
INSERT INTO Bed_Details VALUES (158, 'Yes', 98);
INSERT INTO Bed_Details VALUES (159, 'Yes', 78);
INSERT INTO Bed_Details VALUES (160, 'Yes', 109);
INSERT INTO Bed_Details VALUES (161, 'Yes', 129);
INSERT INTO Bed_Details VALUES (162, 'No', 85);
INSERT INTO Bed_Details VALUES (163, 'No', 131);
INSERT INTO Bed_Details VALUES (164, 'No', 150);
INSERT INTO Bed_Details VALUES (165, 'Yes', 27);
INSERT INTO Bed_Details VALUES (166, 'Yes', 115);
INSERT INTO Bed_Details VALUES (167, 'Yes', 75);
INSERT INTO Bed_Details VALUES (168, 'No', 52);
INSERT INTO Bed_Details VALUES (169, 'No', 100);
INSERT INTO Bed_Details VALUES (170, 'No', 25);
INSERT INTO Bed_Details VALUES (171, 'Yes', 89);
INSERT INTO Bed_Details VALUES (172, 'Yes', 148);
INSERT INTO Bed_Details VALUES (173, 'No', 12);
INSERT INTO Bed_Details VALUES (174, 'No', 137);
INSERT INTO Bed_Details VALUES (175, 'No', 107);
INSERT INTO Bed_Details VALUES (176, 'No', 82);
INSERT INTO Bed_Details VALUES (177, 'No', 70);
INSERT INTO Bed_Details VALUES (178, 'Yes', 134);
INSERT INTO Bed_Details VALUES (179, 'Yes', 135);
INSERT INTO Bed_Details VALUES (180, 'No', 39);
INSERT INTO Bed_Details VALUES (181, 'No', 84);
INSERT INTO Bed_Details VALUES (182, 'Yes', 147);
INSERT INTO Bed_Details VALUES (183, 'No', 116);
INSERT INTO Bed_Details VALUES (184, 'No', 123);
INSERT INTO Bed_Details VALUES (185, 'No', 94);
INSERT INTO Bed_Details VALUES (186, 'Yes', 21);
INSERT INTO Bed_Details VALUES (187, 'Yes', 35);
INSERT INTO Bed_Details VALUES (188, 'No', 135);
INSERT INTO Bed_Details VALUES (189, 'No', 148);
INSERT INTO Bed_Details VALUES (190, 'No', 63);
INSERT INTO Bed_Details VALUES (191, 'No', 93);
INSERT INTO Bed_Details VALUES (192, 'No', 104);
INSERT INTO Bed_Details VALUES (193, 'No', 119);
INSERT INTO Bed_Details VALUES (194, 'Yes', 137);
INSERT INTO Bed_Details VALUES (195, 'Yes', 8);
INSERT INTO Bed_Details VALUES (196, 'Yes', 65);
INSERT INTO Bed_Details VALUES (197, 'Yes', 145);
INSERT INTO Bed_Details VALUES (198, 'Yes', 29);
INSERT INTO Bed_Details VALUES (199, 'Yes', 106);
INSERT INTO Bed_Details VALUES (200, 'No', 26);
INSERT INTO Bed_Details VALUES (201, 'Yes', 28);
INSERT INTO Bed_Details VALUES (202, 'Yes', 67);
INSERT INTO Bed_Details VALUES (203, 'Yes', 147);
INSERT INTO Bed_Details VALUES (204, 'Yes', 19);
INSERT INTO Bed_Details VALUES (205, 'No', 45);
INSERT INTO Bed_Details VALUES (206, 'No', 6);
INSERT INTO Bed_Details VALUES (207, 'No', 125);
INSERT INTO Bed_Details VALUES (208, 'Yes', 57);
INSERT INTO Bed_Details VALUES (209, 'Yes', 127);
INSERT INTO Bed_Details VALUES (210, 'No', 109);
INSERT INTO Bed_Details VALUES (211, 'Yes', 94);
INSERT INTO Bed_Details VALUES (212, 'Yes', 124);
INSERT INTO Bed_Details VALUES (213, 'No', 66);
INSERT INTO Bed_Details VALUES (214, 'Yes', 52);
INSERT INTO Bed_Details VALUES (215, 'No', 137);
INSERT INTO Bed_Details VALUES (216, 'No', 132);
INSERT INTO Bed_Details VALUES (217, 'No', 20);
INSERT INTO Bed_Details VALUES (218, 'No', 131);
INSERT INTO Bed_Details VALUES (219, 'No', 11);
INSERT INTO Bed_Details VALUES (220, 'Yes', 118);
INSERT INTO Bed_Details VALUES (221, 'No', 49);
INSERT INTO Bed_Details VALUES (222, 'Yes', 2);
INSERT INTO Bed_Details VALUES (223, 'No', 78);
INSERT INTO Bed_Details VALUES (224, 'No', 140);
INSERT INTO Bed_Details VALUES (225, 'No', 135);
INSERT INTO Bed_Details VALUES (226, 'No', 139);
INSERT INTO Bed_Details VALUES (227, 'No', 149);
INSERT INTO Bed_Details VALUES (228, 'No', 116);
INSERT INTO Bed_Details VALUES (229, 'No', 34);
INSERT INTO Bed_Details VALUES (230, 'Yes', 36);
INSERT INTO Bed_Details VALUES (231, 'Yes', 65);
INSERT INTO Bed_Details VALUES (232, 'Yes', 109);
INSERT INTO Bed_Details VALUES (233, 'No', 95);
INSERT INTO Bed_Details VALUES (234, 'No', 103);
INSERT INTO Bed_Details VALUES (235, 'Yes', 5);
INSERT INTO Bed_Details VALUES (236, 'Yes', 24);
INSERT INTO Bed_Details VALUES (237, 'No', 99);
INSERT INTO Bed_Details VALUES (238, 'No', 119);
INSERT INTO Bed_Details VALUES (239, 'No', 96);
INSERT INTO Bed_Details VALUES (240, 'No', 87);
INSERT INTO Bed_Details VALUES (241, 'Yes', 117);
INSERT INTO Bed_Details VALUES (242, 'No', 124);
INSERT INTO Bed_Details VALUES (243, 'No', 38);
INSERT INTO Bed_Details VALUES (244, 'Yes', 38);
INSERT INTO Bed_Details VALUES (245, 'No', 45);
INSERT INTO Bed_Details VALUES (246, 'Yes', 95);
INSERT INTO Bed_Details VALUES (247, 'No', 74);
INSERT INTO Bed_Details VALUES (248, 'No', 67);
INSERT INTO Bed_Details VALUES (249, 'No', 108);
INSERT INTO Bed_Details VALUES (250, 'No', 111);
INSERT INTO Bed_Details VALUES (251, 'Yes', 125);
INSERT INTO Bed_Details VALUES (252, 'No', 126);
INSERT INTO Bed_Details VALUES (253, 'Yes', 109);
INSERT INTO Bed_Details VALUES (254, 'Yes', 17);
INSERT INTO Bed_Details VALUES (255, 'Yes', 53);
INSERT INTO Bed_Details VALUES (256, 'Yes', 59);
INSERT INTO Bed_Details VALUES (257, 'No', 27);
INSERT INTO Bed_Details VALUES (258, 'No', 40);
INSERT INTO Bed_Details VALUES (259, 'No', 26);
INSERT INTO Bed_Details VALUES (260, 'Yes', 48);
INSERT INTO Bed_Details VALUES (261, 'No', 23);
INSERT INTO Bed_Details VALUES (262, 'Yes', 14);
INSERT INTO Bed_Details VALUES (263, 'No', 137);
INSERT INTO Bed_Details VALUES (264, 'Yes', 89);
INSERT INTO Bed_Details VALUES (265, 'No', 27);
INSERT INTO Bed_Details VALUES (266, 'No', 31);
INSERT INTO Bed_Details VALUES (267, 'Yes', 72);
INSERT INTO Bed_Details VALUES (268, 'Yes', 123);
INSERT INTO Bed_Details VALUES (269, 'Yes', 55);
INSERT INTO Bed_Details VALUES (270, 'Yes', 100);
INSERT INTO Bed_Details VALUES (271, 'No', 115);
INSERT INTO Bed_Details VALUES (272, 'No', 131);
INSERT INTO Bed_Details VALUES (273, 'Yes', 101);
INSERT INTO Bed_Details VALUES (274, 'Yes', 123);
INSERT INTO Bed_Details VALUES (275, 'No', 39);
INSERT INTO Bed_Details VALUES (276, 'Yes', 52);
INSERT INTO Bed_Details VALUES (277, 'No', 134);
INSERT INTO Bed_Details VALUES (278, 'No', 107);
INSERT INTO Bed_Details VALUES (279, 'Yes', 127);
INSERT INTO Bed_Details VALUES (280, 'No', 87);
INSERT INTO Bed_Details VALUES (281, 'Yes', 27);
INSERT INTO Bed_Details VALUES (282, 'No', 89);
INSERT INTO Bed_Details VALUES (283, 'No', 15);
INSERT INTO Bed_Details VALUES (284, 'Yes', 77);
INSERT INTO Bed_Details VALUES (285, 'No', 59);
INSERT INTO Bed_Details VALUES (286, 'Yes', 70);
INSERT INTO Bed_Details VALUES (287, 'Yes', 106);
INSERT INTO Bed_Details VALUES (288, 'No', 34);
INSERT INTO Bed_Details VALUES (289, 'No', 50);
INSERT INTO Bed_Details VALUES (290, 'Yes', 144);
INSERT INTO Bed_Details VALUES (291, 'Yes', 137);
INSERT INTO Bed_Details VALUES (292, 'No', 106);
INSERT INTO Bed_Details VALUES (293, 'No', 72);
INSERT INTO Bed_Details VALUES (294, 'No', 79);
INSERT INTO Bed_Details VALUES (295, 'Yes', 126);
INSERT INTO Bed_Details VALUES (296, 'No', 128);
INSERT INTO Bed_Details VALUES (297, 'Yes', 121);
INSERT INTO Bed_Details VALUES (298, 'Yes', 87);
INSERT INTO Bed_Details VALUES (299, 'No', 47);
INSERT INTO Bed_Details VALUES (300, 'Yes', 137);
INSERT INTO Bed_Details VALUES (301, 'No', 15);
INSERT INTO Bed_Details VALUES (302, 'Yes', 136);
INSERT INTO Bed_Details VALUES (303, 'No', 55);
INSERT INTO Bed_Details VALUES (304, 'No', 127);
INSERT INTO Bed_Details VALUES (305, 'Yes', 85);
INSERT INTO Bed_Details VALUES (306, 'Yes', 33);
INSERT INTO Bed_Details VALUES (307, 'Yes', 66);
INSERT INTO Bed_Details VALUES (308, 'Yes', 23);
INSERT INTO Bed_Details VALUES (309, 'Yes', 145);
INSERT INTO Bed_Details VALUES (310, 'Yes', 30);
INSERT INTO Bed_Details VALUES (311, 'Yes', 145);
INSERT INTO Bed_Details VALUES (312, 'No', 129);
INSERT INTO Bed_Details VALUES (313, 'No', 109);
INSERT INTO Bed_Details VALUES (314, 'Yes', 2);
INSERT INTO Bed_Details VALUES (315, 'Yes', 79);
INSERT INTO Bed_Details VALUES (316, 'Yes', 22);
INSERT INTO Bed_Details VALUES (317, 'No', 72);
INSERT INTO Bed_Details VALUES (318, 'No', 69);
INSERT INTO Bed_Details VALUES (319, 'Yes', 6);
INSERT INTO Bed_Details VALUES (320, 'No', 85);
INSERT INTO Bed_Details VALUES (321, 'Yes', 36);
INSERT INTO Bed_Details VALUES (322, 'Yes', 65);
INSERT INTO Bed_Details VALUES (323, 'Yes', 147);
INSERT INTO Bed_Details VALUES (324, 'Yes', 89);
INSERT INTO Bed_Details VALUES (325, 'Yes', 24);
INSERT INTO Bed_Details VALUES (326, 'No', 77);
INSERT INTO Bed_Details VALUES (327, 'No', 64);
INSERT INTO Bed_Details VALUES (328, 'Yes', 136);
INSERT INTO Bed_Details VALUES (329, 'Yes', 93);
INSERT INTO Bed_Details VALUES (330, 'Yes', 21);
INSERT INTO Bed_Details VALUES (331, 'No', 103);
INSERT INTO Bed_Details VALUES (332, 'Yes', 62);
INSERT INTO Bed_Details VALUES (333, 'No', 85);
INSERT INTO Bed_Details VALUES (334, 'No', 3);
INSERT INTO Bed_Details VALUES (335, 'No', 29);
INSERT INTO Bed_Details VALUES (336, 'No', 33);
INSERT INTO Bed_Details VALUES (337, 'Yes', 104);
INSERT INTO Bed_Details VALUES (338, 'No', 148);
INSERT INTO Bed_Details VALUES (339, 'No', 145);
INSERT INTO Bed_Details VALUES (340, 'No', 138);
INSERT INTO Bed_Details VALUES (341, 'Yes', 78);
INSERT INTO Bed_Details VALUES (342, 'Yes', 78);
INSERT INTO Bed_Details VALUES (343, 'Yes', 14);
INSERT INTO Bed_Details VALUES (344, 'Yes', 45);
INSERT INTO Bed_Details VALUES (345, 'No', 56);
INSERT INTO Bed_Details VALUES (346, 'Yes', 71);
INSERT INTO Bed_Details VALUES (347, 'No', 65);
INSERT INTO Bed_Details VALUES (348, 'No', 136);
INSERT INTO Bed_Details VALUES (349, 'Yes', 122);
INSERT INTO Bed_Details VALUES (350, 'Yes', 104);
INSERT INTO Bed_Details VALUES (351, 'Yes', 96);
INSERT INTO Bed_Details VALUES (352, 'No', 140);
INSERT INTO Bed_Details VALUES (353, 'Yes', 140);
INSERT INTO Bed_Details VALUES (354, 'No', 79);
INSERT INTO Bed_Details VALUES (355, 'Yes', 34);
INSERT INTO Bed_Details VALUES (356, 'Yes', 20);
INSERT INTO Bed_Details VALUES (357, 'No', 56);
INSERT INTO Bed_Details VALUES (358, 'No', 86);
INSERT INTO Bed_Details VALUES (359, 'Yes', 75);
INSERT INTO Bed_Details VALUES (360, 'No', 40);
INSERT INTO Bed_Details VALUES (361, 'No', 113);
INSERT INTO Bed_Details VALUES (362, 'Yes', 31);
INSERT INTO Bed_Details VALUES (363, 'No', 70);
INSERT INTO Bed_Details VALUES (364, 'Yes', 3);
INSERT INTO Bed_Details VALUES (365, 'No', 34);
INSERT INTO Bed_Details VALUES (366, 'Yes', 144);
INSERT INTO Bed_Details VALUES (367, 'Yes', 118);
INSERT INTO Bed_Details VALUES (368, 'No', 111);
INSERT INTO Bed_Details VALUES (369, 'No', 71);
INSERT INTO Bed_Details VALUES (370, 'No', 105);
INSERT INTO Bed_Details VALUES (371, 'Yes', 119);
INSERT INTO Bed_Details VALUES (372, 'No', 26);
INSERT INTO Bed_Details VALUES (373, 'Yes', 10);
INSERT INTO Bed_Details VALUES (374, 'Yes', 11);
INSERT INTO Bed_Details VALUES (375, 'No', 36);
INSERT INTO Bed_Details VALUES (376, 'No', 142);
INSERT INTO Bed_Details VALUES (377, 'No', 146);
INSERT INTO Bed_Details VALUES (378, 'Yes', 122);
INSERT INTO Bed_Details VALUES (379, 'Yes', 62);
INSERT INTO Bed_Details VALUES (380, 'No', 144);
INSERT INTO Bed_Details VALUES (381, 'Yes', 41);
INSERT INTO Bed_Details VALUES (382, 'No', 11);
INSERT INTO Bed_Details VALUES (383, 'No', 109);
INSERT INTO Bed_Details VALUES (384, 'Yes', 65);
INSERT INTO Bed_Details VALUES (385, 'No', 112);
INSERT INTO Bed_Details VALUES (386, 'No', 97);
INSERT INTO Bed_Details VALUES (387, 'No', 76);
INSERT INTO Bed_Details VALUES (388, 'Yes', 113);
INSERT INTO Bed_Details VALUES (389, 'Yes', 133);
INSERT INTO Bed_Details VALUES (390, 'No', 15);
INSERT INTO Bed_Details VALUES (391, 'Yes', 30);
INSERT INTO Bed_Details VALUES (392, 'No', 140);
INSERT INTO Bed_Details VALUES (393, 'Yes', 88);
INSERT INTO Bed_Details VALUES (394, 'Yes', 150);
INSERT INTO Bed_Details VALUES (395, 'Yes', 123);
INSERT INTO Bed_Details VALUES (396, 'Yes', 99);
INSERT INTO Bed_Details VALUES (397, 'Yes', 102);
INSERT INTO Bed_Details VALUES (398, 'Yes', 26);
INSERT INTO Bed_Details VALUES (399, 'No', 86);
INSERT INTO Bed_Details VALUES (400, 'No', 63);


-----Bill---------
SET IDENTITY_INSERT Bill ON;

INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (1, 300, 400, 250, 0, 2022-06-30, 'Insurance', 4);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (2, 200, 800, 450, 0, 2022-04-22, 'Insurance', 10);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (3, 500, 100, 500, 0, 2022-05-13, 'Credit Card', 14);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (4, 200, 600, 550, 0, 2022-08-01, 'Insurance', 15);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (5, 200, 400, 350, 0, 2022-07-31, 'Credit Card', 16);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (6, 600, 1000, 550, 0, 2022-04-28, 'Insurance', 17);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (7, 200, 6000, 1050, 0, 2022-04-20, 'Insurance', 18);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (8, 200, 100, 100, 0, 2022-03-02, 'Credit Card', 19);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (9, 400, 1200, 950, 0, 2022-04-22, 'Insurance', 20);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (10, 400, 0, 50, 0, 2022-05-30, 'Insurance', 1);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (11, 400, 0, 250, 0, 2022-06-29, 'Insurance', 2);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (12, 200, 0, 20, 0, 2022-07-14, 'Credit Card', 3);
INSERT INTO Bill (idBill, Doctor_Charge, Accomodation_Charge, Other_Charges, Total_Bill, Pay_Date, Pay_Method, Case_ID) VALUES (13, 200, 0, 90,0, 2022-06-30, 'Insurance', 4);

SET IDENTITY_INSERT Bill OFF;


----Type Of Cases--------
SET IDENTITY_INSERT Types_of_Cases ON;

insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values (1,'Critical', 'Short of breath', '2022-08-02 15:32:06', NULL, 1, 29, 77);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(2,'Minor', 'Regular Check up', NULL, NULL, 2, NULL, NULL);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(3,'Critical', 'Burn on face, chest, back', '2022-08-02 05:12:06', NULL, 11, 29, 139);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(4,'Major', 'Covid- Low Oxygen Level', '2022-06-22 15:32:06', '2022-06-30 10:22:06', 4, 2, 27);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(5,'Critical','Heart Attack Severe pain in chest', '2022-07-29 09:02:46', NULL, 5, 2, 57);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values (6,'Critical','Tumour- Internal Bleeding', '2022-07-28 15:32:06', NULL, 6, 32, 123);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(7,'Minor','Arthritis - Pain in joints', Null, NULL, 7,NULL, NULL);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(8,'Minor','Stone in stomach', Null, NULL, 8, NULL, NULL);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(9,'Minor','Dizziness', Null, NULL, 9, NULL, NULL);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(10,'Major','Pneumonia', '2022-04-04 10:10:10', '2022-04-22 12:10:49', 10, 32, 147);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(11,'Critical', 'Accident', '2022-08-01 15:32:06', NULL, 22, 9, 97 );
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(12,'Minor', 'Regular Check up', NULL, NULL, 23, NULL, NULL);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(13,'Critical', 'Suicide Attempt', '2022-08-02 01:12:06', NULL, 24, 9, 170);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(14,'Major', 'Covid- Low Oxygen Level', '2022-04-27 15:32:06', '2022-05-13 11:22:06', 25, 27, 18);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(15,'Critical','Heart Attack Severe pain in chest', '2022-07-24 09:02:46', '2022-08-01 10:00:00', 26, 18, 260);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(16,'Critical','Tumour- Internal Bleeding', '2022-07-22 15:32:06', '2022-07-31 11:22:00', 27, 41, 33);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(17,'Minor','Covid', '2022-04-22 15:32:06', '2022-04-28 15:32:06', 28, 41, 67);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(18,'Minor','Covid', '2022-04-12 15:32:06', '2022-04-20 15:32:06', 29, 20, 163);
insert into Types_of_Cases  (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(19,'Minor','Dizziness', '2022-03-05 15:32:06', '2022-03-2 15:32:06', 30, 33, 155);
insert into Types_of_Cases (Case_id,Type, Description, [Admit Date],[Discharge Date], [idPatient],[idWard],[idBed_Details])
values(20,'Major','Surgery disk replacement', '2022-04-04 10:10:10', '2022-04-22 12:10:49', 31, 20, 53);

SET IDENTITY_INSERT Types_of_Cases OFF;


-----Test--------
insert into Test values('CT Scan', '2022-08-02', 234.50, 1, 101);
insert into Test values('Urinalysis', '2022-08-03', 550.99, 2, 101);
insert into Test values('CT Scan, X-ray, Blood test', '2022-06-23', 775.45, 3, 201);
insert into Test values('ECG', '2022-07-29', 370, 4, 201);
insert into Test values('MRI', '2022-07-30', 450, 5, 301);
insert into Test values('CT Scan', '2022-04-12', 300, 6, 301);
insert into Test values('X-ray, CT Scan', '2022-08-01', 680.75, 7, 101);
insert into Test values('CT Scan', '2022-04-24', 234.50, 8, 401);
insert into Test values('CT Scan', '2022-04-15', 234.50, 9, 401);
insert into Test values('CT Scan', '2022-08-02', 234.50, 10, 401);


------------------------------------------
--View:
--To check the current status of the number of rooms and beds available in the hospital
------------------------------------------
GO

Create  View Availibilty as (
SELECT  Hospital_ID, w.idWard,count(bd.Room_No) as  No_of_Rooms_Available,  count(idBed_Details) as No_of_Beds_Available
FROM Ward w JOIN Room_Details rd ON w.idWard = rd.idWard
JOIN Bed_Details bd ON bd.Room_No= rd.Room_No
WHERE rd.Availability='Yes' and bd.Availability='Yes'
group by  Hospital_ID, w.idWard
);

GO

------------------------------------------
--View:
--To check the daily increase/decrease in the number of cases and the type of cases
------------------------------------------
GO

Create  VIEW DailyIncreasedCases as
 with temp as
( select CAST([Admit Date] as DATE) as Date,			
			COUNT(Case_ID) as [IncreasedCases],
			STRING_AGG(Case_ID , ', ') as Cases
 from Types_of_Cases
 where [Admit Date] is not null
 group by CAST([Admit Date] as DATE)  ),
 temp2 as
 ( select CAST([Admit Date] as DATE) as Date,
			count(case_id)  as [Critical Cases]			
 from Types_of_Cases
 where Type = 'Critical' and [Admit Date] is not null
 group by CAST([Admit Date] as DATE) ),
  temp3 as
 ( select CAST([Admit Date] as DATE) as Date,
			count(case_id)  as [Major Cases]			
 from Types_of_Cases
 where Type = 'Major' and [Admit Date] is not null
 group by CAST([Admit Date] as DATE) ),
  temp4 as
 ( select CAST([Admit Date] as DATE) as Date,
			count(case_id)  as [Moderate Cases]			
 from Types_of_Cases
 where Type = 'Moderate' and [Admit Date] is not null
 group by CAST([Admit Date] as DATE) ),
 temp5 as
 ( select CAST([Admit Date] as DATE) as Date,
			count(case_id)  as [Minor Cases]			
 from Types_of_Cases
 where Type = 'Minor' and [Admit Date] is not null
 group by CAST([Admit Date] as DATE) )

 select  t1.Date, 
			  t1.IncreasedCases , 
			  COALESCE(t2.[Critical Cases] , 0) as [Critical Cases],
			  COALESCE(t3.[Major Cases] , 0) as [Major Cases],
			  COALESCE(t4.[Moderate Cases] , 0) as [Moderate Cases],
			  COALESCE(t5.[Minor Cases] , 0) as [Minor Cases],
			  t1.Cases as[All Case ID]
 from temp2 t2 
			FULL OUTER join temp   t1 on t2.Date = t1.Date
			FULL OUTER join temp3 t3 on t3.Date = t1.Date
			FULL OUTER join temp4 t4 on t4.Date = t1.Date
			FULL OUTER join temp5 t5 on t5.Date = t1.Date

GO

------------------------------------------
--View:
--To check which hospital patients are admitted into i.e which ward, room and bed they have been allocated 
--This, in turn, would be extremely informative for any visitors
------------------------------------------
GO

Create View  Admitted_Patients as (
Select  distinct  p.idPatient as PatientID,h.Hospital_Name ,
concat(p.Patient_FName,' ',p.Patient_MName , ' ' ,p.Patient_LName) as FullName ,
p.Patient_ContacNo as [Phone No],t.type as [Situation],w.idward as [Ward No],w.[Floor Number], 
bd.Room_No  as [Room No],t.idbed_details as [Bed_no]
from patient p
inner join Types_of_Cases t
on p.idPatient =t.idPatient
inner join Bed_Details bd 
on bd.idBed_Details =t.idBed_Details
inner join Room_Details rd
on bd.idBed_Details =rd.Room_No
inner join Ward w 
on rd.idWard =w.idWard
inner join Hospital h 
on w.Hospital_ID =h.Hospital_ID 
where t.[discharge date] is NULL
);

GO
 			


