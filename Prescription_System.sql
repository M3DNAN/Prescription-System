create database Prescription_System 
create table Patient 
( Ur_number int primary key ,
  Name varchar (50) not null , 
  Address varchar (50) not null ,
  Age int not null ,
  Email varchar (50) not null ,
  phone int not null ,
  medical_card_number int 
)
create table Doctor  
( id int primary key ,
  Name varchar (50) not null , 
  Email varchar (50) not null ,
  phone int not null ,
  specialization varchar (50) not null , 
  years_of_experience int 
)

create table Drug_company  
(
  Name varchar (50) primary key , 
  Address varchar (50) not null ,
  phone int not null ,
)
create table Drug
(
  trade_name varchar (50) primary key , 
  strength  varchar (50) not null ,
  Drug_company_name varchar (50) not null ,
  CONSTRAINT fk_Drug_company FOREIGN KEY (Drug_company_name) 
  REFERENCES Drug_company (Name)
  on update cascade
  on delete  cascade,
)
create table prescription 
(
  id int primary key ,
  dosage_date date not null ,
  quantity int not null ,

  Ur_number int,
  trade_name varchar (50)  , 
  doctor_id  int  ,

  CONSTRAINT fk_Ur_number FOREIGN KEY (Ur_number) 
  REFERENCES Patient (Ur_number),
  CONSTRAINT fk_trade_name FOREIGN KEY (trade_name) 
  REFERENCES Drug (trade_name),
  CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) 
  REFERENCES doctor (id)
)
create table Patient_Doctor
(
  Ur_number int,
  doctor_id  int  
  PRIMARY KEY(Ur_number,doctor_id)
  CONSTRAINT fk_Doctor_Patient_UR FOREIGN KEY (Ur_number) 
  REFERENCES Patient (Ur_number),
  CONSTRAINT fk_Patient_Doctor_ID FOREIGN KEY (doctor_id) 
  REFERENCES doctor (id)
)

--SELECT: Retrieve all columns from the Doctor table.
select *
from Doctor

--ORDER BY: List patients in the Patient table in ascending order of their ages.
select *
from Patient
order by Age asc

--OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
select *
from Patient
order by Name asc
OFFSET 4 ROWS 
FETCH NEXT 10 ROWS ONLY;

--SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
select top 5
years_of_experience
from Doctor

--SELECT DISTINCT: Get a list of unique address from the Patient table.
select DISTINCT address
from Patient

-- WHERE: Retrieve patients from the Patient table who are aged 25.
select *
from Patient
where Age = 25

-- NULL: Retrieve patients from the Patient table whose email is not provided.
select *
from Patient
where Email is null

--AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
select *
from Doctor
where years_of_experience >= 5 and specialization = 'Cardiology'

--IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
select *
from Doctor
where specialization in ('Oncology' , 'Dermatology' )

--BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
select *
from Patient
where Age between 18 and 30

--LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.

select *
from Doctor
where Name like 'Dr%'

--Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
select Name 'Doctor Name' , Email 'Doctor Email'
from Doctor

--Joins: Retrieve all prescriptions with corresponding patient names.

select pa.Ur_number ,pa.Name , pr.*
from  Patient pa
join prescription pr
on pa.Ur_number = pr.Ur_number

-- GROUP BY: Retrieve the count of patients grouped by their cities.

select Address , count(*) AS Patient_Count
from  Patient 
group by Address

-- HAVING: Retrieve cities with more than 3 patients.
select Address 
from  Patient 
GROUP BY Address
having count(*) >3

-- UNION: Retrieve a combined list of doctors and patients. 

SELECT Name
FROM Patient
UNION
SELECT Name
FROM Doctor

-- Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.
WITH cta_patients_doctors  as(
SELEct P.Ur_number , P.Name , D.id ,  D.Name  
from  Doctor d join Patient_Doctor pd
on pd.doctor_id = D.id  
join Patient p
on pd.Ur_number = P.Ur_number)

select*
from cta_patients_doctors

--INSERT: Insert a new doctor into the Doctor table.

insert into Doctor (id , Name ,Email,phone ,specialization,years_of_experience)
values (1,'Ahmed','email.com',0100,'Cardiology',3 )

-- INSERT Multiple Rows: Insert multiple patients into the Patient table.

insert into Patient (Ur_number , Name ,Email,phone ,Age,Address,medical_card_number)
values (1,'Ali','Patient1.com',0150,23, 'Eg' , null ) ,
(2,'Omar','Patient2.com',0110,28, 'Eg' , 5 ) ,
(3,'Osama','Patient3.com',0140,20, 'Sa' , 56758 )

-- UPDATE: Update the phone number of a doctor.
UPDATE Patient
SET Email = 'Patient0.com' 
WHERE Email = 'Patient1.com'

-- UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
UPDATE 
    Patient
SET 
   Patient.Address = 'Cairo'  
from  Doctor d join Patient_Doctor pd
on pd.doctor_id = D.id  
join Patient p
on pd.Ur_number = P.Ur_number
WHERE 
    D.Name='Ahmed';

-- DELETE: Delete a patient from the Patient table.
DELETE  
from Patient
where Name = 'ali'

-- Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
BEGIN TRANSACTION
insert into Doctor (id , Name ,Email,phone ,specialization,years_of_experience)
values (2,'Alaa','email2.com',0179,'Dermatology',10 )
insert into Patient (Ur_number , Name ,Email,phone ,Age,Address,medical_card_number)
values (1,'Ali','Patient1.com',0150,23, 'Eg' , null ) 
commit

--View: Create a view that combines patient and doctor information for easy access.

Create view patient_and_doctor
as
select d.Name 'Doctor Name' , p.Name 'Patient Name' , d.phone 'Doctor phone' , P.phone 'Patient phone' 
from Patient p , Doctor d

-- Index: Create an index on the 'phone' column of the Patient table to improve search performance.

CREATE INDEX Patient_phone
ON Patient(phone)

-- Backup: Perform a backup of the entire database to ensure data safety.
BACKUP DATABASE Prescription_System 
TO DISK = 'C:\Users\mostafa\OneDrive\Documents\SQL Server Management Studio'

