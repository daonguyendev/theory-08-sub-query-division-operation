create database employee_management_v3;

alter database employee_management_v3
collate Latin1_General_100_CI_AS_SC_UTF8;

use employee_management_v3;
go

-- use master;
-- drop database employee_management_v3;

create table departments (
	id	int not null identity(1,1) primary key,
	name nvarchar(45) not null,
	location nvarchar(45) not null,
);

insert into departments(name, location) values
('HR', 'Hà Nội'),
('Marketing', 'Hồ Chí Minh'),
('Sales', 'Hà Nội'),
('Sales', 'Đà Nẵng'),
('Sales', 'Hồ Chí Minh'),
('IT', 'Hà Nội'),
('Dev', 'Hồ Chí Minh');

create table employees (
	id	int not null identity(1,1) primary key,
	department_id int not null,
	name nvarchar(45) not null,
	salary int not null,
	gender char(10) not null,
	age int not null,
	foreign key (department_id) references departments(id)
);

insert into employees(name, department_id, salary, gender, age) values
('Nguyễn Văn Tý', 1, 15000, 'Nam', 22),
('Nguyễn Thị Sửu', 1, 18000, 'Nữ', 25),
('Lê Thị Dần', 2, 20000, 'Nữ', 26),
('Trần Văn Mão', 2, 15000, 'Nam', 18),
('Lê Thị Thìn', 3, 15000, 'Nữ', 18),
('Trần Văn Tỵ', 3, 15000, 'Nam', 20),
('Đinh Tiến Ngọ', 3, 15000, 'Nữ', 20),
('Lê Thị Mùi', 3, 15000, 'Nữ', 18),
('Trần Văn Thân', 3, 15000, 'Nam', 20),
('Đinh Tiến Dậu', 4, 15000, 'Nữ', 20),
('Trần Văn Tuất', 5, 15000, 'Nam', 20),
('Đinh Tiến Hợi', 5, 15000, 'Nữ', 20)
;

select * from employees;
select count(id) from employees;

-- Lấy tất cả nhân viên trên 18 tuổi thuộc các phòng ban ở Hồ Chí Minh bằng câu vấn con
select * from departments where location = 'Hồ Chí Minh';
select id from departments where location = 'Hồ Chí Minh';

select id, name, age, city 
from employees
where age > 18 and department_id in (select id 
									 from departments 
									 where location = 'Hồ Chí Minh');

-- Lấy tất cả nhân viên nam từ 18 tuổi thuộc các phòng ban ở Hà Nội bằng câu vấn con
select *
from employees
where gender = 'Nam' and age >= 18 and department_id in (select id 
														 from departments
														 where location = 'Hà Nội');

select * from departments;

select * from employees;
select count(id) from employees;

-- Lấy tất cả nhân viên trên 18 tuổi thuộc các phòng ban ở Hồ Chí Minh bằng câu vấn con
select * from departments where location = 'Hồ Chí Minh';
select id from departments where location = 'Hồ Chí Minh';

select id, name, age, city 
from employees
where age > 18 and department_id in (select id 
									 from departments 
									 where location = 'Hồ Chí Minh');

-- Lấy tất cả nhân viên nam từ 18 tuổi thuộc các phòng ban ở Hà Nội bằng câu vấn con
select *
from employees
where gender = 'Nam' and age >= 18 
					 and department_id 
					 in (select id 
						 from departments
						 where location = 'Hà Nội');

select *
from employees
where department_id in (1, 2) and salary >= all 
	(select salary from employees);