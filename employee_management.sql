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

-- ANY
-- Bài toán: Liệt kê nhân viên có lương cao hơn ít nhất một nhân viên ở các phòng đặt tại “Hồ Chí Minh”.
-- Lương của mỗi e > ANY một mức lương trong tập nhân viên ở HCM
SELECT e.*
FROM employees e
WHERE e.salary > ANY (
  SELECT e2.salary
  FROM employees e2
  JOIN departments d2 ON d2.id = e2.department_id
  WHERE d2.location = N'Hồ Chí Minh'
);
-- > ANY (subquery) ~ “lớn hơn ít nhất một phần tử trong tập con”

-- Lương > ALL(...)  => lớn hơn TẤT CẢ mức lương trong tập (khắt khe hơn ANY)
SELECT e.*
FROM employees e
WHERE e.salary > ALL (
  SELECT e2.salary
  FROM employees e2
  JOIN departments d2 ON d2.id = e2.department_id
  WHERE d2.location = N'Hồ Chí Minh'
);

-- EXISTS:
-- Bài toán A: Liệt kê phòng ban có ít nhất 1 nhân viên ≥ 20 tuổi
SELECT d.*
FROM departments d
WHERE EXISTS (
  SELECT 1
  FROM employees e
  WHERE e.department_id = d.id
    AND e.age >= 20
);

-- Bài toán B (đối ngược): Liệt kê phòng ban chưa có nhân viên nào ≥ 20 tuổi
SELECT d.*
FROM departments d
WHERE NOT EXISTS (
  SELECT 1
  FROM employees e
  WHERE e.department_id = d.id
    AND e.age >= 20
);

-- 3) Lồng phân cấp (nested, không tương quan)
-- Bài toán: Liệt kê nhân viên thuộc các phòng đặt tại thành phố có “ít nhất một nhân viên lương > 17,000”. (2 tầng lồng, không tham chiếu bảng ngoài)
SELECT e.*
FROM employees e
WHERE e.department_id IN (
  SELECT d.id
  FROM departments d
  WHERE d.location IN (
    SELECT d2.location
    FROM employees e2
    JOIN departments d2 ON d2.id = e2.department_id
    WHERE e2.salary > 17000
    GROUP BY d2.location
  )
);

-- 4) Lồng tương quan (correlated subquery)
-- Bài toán A: Liệt kê nhân viên có lương cao hơn mức lương trung bình của chính phòng ban đó
SELECT e.*
FROM employees e
WHERE e.salary > (
  SELECT AVG(e2.salary)
  FROM employees e2
  WHERE e2.department_id = e.department_id
);

-- Bài toán B: Liệt kê nhân viên có lương cao nhất trong phòng ban của họ
SELECT e.*
FROM employees e
WHERE e.salary >= ALL (
  SELECT e2.salary
  FROM employees e2
  WHERE e2.department_id = e.department_id
);


-- 5) Phép chia trong SQL (Division) – biểu diễn bằng NOT EXISTS
-- Dữ liệu hiện có phù hợp để demo “một phòng ban có đủ tất cả các giới tính” (ở đây tập S = {‘Nam’, ‘Nữ’}). Ý tưởng: tìm department_id sao cho không tồn tại giới tính nào trong S mà phòng đó không có nhân viên.

-- Bước 1 (S tập chia): Tạo tập giới tính mục tiêu (dùng CTE hoặc table tạm)
WITH Genders AS (
  SELECT N'Nam' AS gender
  UNION ALL
  SELECT N'Nữ'
)
SELECT d.*
FROM departments d
WHERE NOT EXISTS (
  SELECT 1
  FROM Genders g
  WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
      AND e.gender = g.gender
  )
);

-- Đọc ngược: chọn phòng ban d sao cho không tồn tại giới tính g trong tập mục tiêu mà phòng d không có nhân viên giới tính đó. Đây chính là mẫu “phép chia” dùng NOT EXISTS

-- Biến thể: “Nhân viên có lương không nhỏ hơn bất kỳ mức lương nào ở HCM” (một dạng “chia” theo tập chuẩn—but ở đây hợp với ALL/NOT EXISTS)
SELECT e.*
FROM employees e
WHERE NOT EXISTS (
  SELECT 1
  FROM employees hcm
  JOIN departments d ON d.id = hcm.department_id
  WHERE d.location = N'Hồ Chí Minh'
    AND e.salary <= hcm.salary
);
-- Diễn giải: không tồn tại ai ở HCM mà lương ≥ lương của e ⇒ lương e lớn hơn tất cả ở HCM (tương đương e.salary > ALL(...))



