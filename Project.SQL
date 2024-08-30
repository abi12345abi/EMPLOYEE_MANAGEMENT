-- Selecting Schema project_employee -- 
USE project_employee;

-- Create table Employee_type --
 
CREATE TABLE Address_Type(
	address_id int auto_increment PRIMARY KEY,
    address_type varchar(20) NOT NULL,
    c tinytext
    );

-- Create table Employee_Type --

CREATE TABLE Employee_Type (
    employee_type_id int auto_increment PRIMARY KEY,
    employee_type varchar(50),
    employee_type_desc tinytext,
    pay_type varchar(10),
    compensation_package decimal(12,2)
);

-- Create table Employee_Role --

CREATE TABLE Employee_Role (
    employee_role_id int PRIMARY KEY,
    role_name varchar(30) Not null,
    role_desc tinytext
);

-- Create table Organization --

CREATE TABLE Organization(
	organization_id int auto_increment primary KEY,
    client_org_name varchar(20) NOT NULL,
    client_org_code int(4) NOT NULL,
    superior_org_name varchar(20) ,
    availability_date DATE,
    top_level_name varchar(20) ,
    ISO_country_code varchar(20) 
    );
    
-- Create table Person -- 
   
CREATE TABLE Person(
	person_id int auto_increment PRIMARY KEY, 
	first_name varchar(20) NOT NULL,
	middle_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
	age INT NOT NULL,
	phone_number varchar(15) ,
    email_id varchar(100) NOT NULL,
    address_id int ,
    insurance_id varchar(20) ,
    device_type varchar(20) ,
	FOREIGN KEY (address_id) REFERENCES Address_Type (address_id) 
    );

-- Create table Employee --

CREATE TABLE Employee (
    employee_id int auto_increment PRIMARY KEY,
	employee_role_id int ,
	employee_type_id int ,
	organization_id int ,
	person_id int not null,
    home_country varchar(50),
    work_country varchar(50),
    gender Char(1), -- make a select list maybe
    DOB date, -- format type 
    martial_status varchar(20), -- letter based
    ethnicity varchar(20),
    FOREIGN KEY(organization_id)
        REFERENCES Organization(organization_id),
    
    FOREIGN KEY(employee_role_id) 
		references Employee_Role(employee_role_id),
    
    FOREIGN KEY(person_id) 
		references Person(person_id),
    
    FOREIGN KEY(employee_type_id)
		references Employee_Type(employee_type_id)
);



-- View employeeView with attributes from all tables --

desc organization;
desc address_type;
create view employeeView
as
select address_type.address_type_description, address_type.address_type, 
employee_type.employee_type, employee_type.compensation_package,
employee_role.role_name, employee_role.role_desc , 
organization.Client_org_name, organization.top_level_name,
person.first_name, person.middle_name, person.age,  
employee.home_country, employee.DOB , employee.employee_role_id
from address_type, employee_type, employee_role, organization, person, employee
where address_type.address_id  = Person.address_id and employee_type.employee_type_id = employee.employee_type_id and
employee_role.employee_role_id = employee.employee_role_id and organization.organization_id = employee.organization_id and
person.person_id = employee.person_id;

select * from employeeView;


-- View using Inner Join --

create view employeeView_1
as
select 
employee_type.employee_type, employee_type.compensation_package,
employee_role.role_name, employee_role.role_desc , 
organization.Client_org_name,  organization.top_level_name,
person.first_name, person.middle_name, person.age,  
employee.home_country, employee.DOB,employee.employee_role_id
from address_type, employee, employee_type, organization, Person, employee_role
inner join address_type on address_type.address_id  = Person.address_id
inner join employee_type on  employee_type.employee_type_id = employee.employee_type_id
inner join employee_role on employee_role.employee_role_id = employee.employee_role_id
inner join organization on organization.organization_id = employee.organization_id 
inner join person on person.person_id = employee.person_id;

select * from employeeView_1;


--creating stored procedure for inserting data into table employee_type--

DELIMITER $$
 
CREATE PROCEDURE insert_employee_type(
employee_type_id int,
employee_type varchar(50),
employee_type_desc tinytext,
pay_type varchar(10),
compensation_package decimal(12,2)
)
BEGIN
    INSERT INTO Employee_Type values ( employee_type_id,
employee_type,
employee_type_desc,
pay_type,
compensation_package);
END $$ 
DELIMITER ;


--creating stored procedure for inserting data into table person--

DELIMITER $$
 
CREATE PROCEDURE insert_person(
person_id int,
first_name varchar(20),
middle_name varchar(20),
last_name varchar(20),
age INT,
phone_number varchar(15),
email_id varchar(100),
address_id int,
insurance_id varchar(20),
device_type varchar(20)

)
BEGIN
    INSERT INTO Person values (person_id,
first_name,
middle_name,
last_name,
age,
phone_number,
email_id,
address_id,
insurance_id,
device_type);
END $$ 
DELIMITER ;


--creating stored procedure for inserting data into table address_type--

DELIMITER $$
CREATE PROCEDURE insert_address_type(
	address_id int ,
    address_type varchar(20) ,
    address_type_description varchar(20) 
    )
BEGIN
    INSERT INTO Address_Type values (address_id, address_type, address_type_description );
END $$ 
DELIMITER ;



--Calling stored procedure--

call insert_address_type (1, 'Home2', 'Decentralized static approach');
call insert_person (person_id, first_name, middle_name, last_name, age, phone_number, email_id, address_id, insurance_id, device_type) values (1, 'Bessy', 'Stillman', 'Maxfield', 53, '110 205 3647', 'smaxfield0@sohu.com', 4, 'U845AU475', 'iPad');
call insert_Employee_Type (employee_type_id, employee_type,   employee_type_desc, pay_type, compensation_package) values (1, 'Training', 'Configurable attitude-oriented leverage', 'Bi-Weekly', 0.03);




--select queries--

select * from address_type;
select * from employee_type;
select * from employee_role;
select * from organization;
select * from person;
select * from employee;
select employee_type, pay_time from employee_type;
select employee_role_id, role_name from employee_role;
select organization_id, client_org_name, client_org_code from organization;
select * from person where age between 30 and 40 order by age;
select * from person where age between 30 and 40 order by age limit 10;
select * from person where age between 30 and 40 order by age limit 2,10;
select * from employee where home_country  like ‘c%’;
delete from person where person_id between 20 and 25;
delete from person where  person_id in (22,42);
update employee set home_country  = “india” where employee_id = 21;
drop table employee;
truncate table person;

--joining the table--

select address_type.address_id, address_type.Address_Type_description, person.first_name, person.age 
from address_type 
inner join person
on address_type.Address_ID = person.address_id;


select employee_type.employee_type_id, employee_type.pay_time, employee. Home_country, employee.dob from employee_type left join employee on employee_type.employee_type_id = employee.employee_type_id;


select employee_role.employee_role_id, employee.work_country, employee.gender from employee_role.employee_role_id = employee.employee_role_id;


select person.person_id, person.first_name, person.phone_number, employee.home_country from person cross join employee on person.person_id = employee.person_id;



--aggregate functions--

select max(age) from person;
select min(age) from person;
select avg(compensation_package) from employee_type;
select count(Employee_Type_ID) from employee_type;
select sum(compensation_package) from employee_type;
