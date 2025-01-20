-- DROP and CREATE tables 

-- Drop the table 
DROP TABLE IF EXISTS departments;

-- Create a new table 
CREATE TABLE departments (
    dept_no VARCHAR(10) NOT NULL, 
    dept_name VARCHAR(50) NOT NULL, 
    CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);

-- Drop the table 
DROP TABLE IF EXISTS dept_emp;

-- Create a new table 
CREATE TABLE dept_emp (
    emp_no INTEGER NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (emp_no, dept_no),
    CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);


-- Drop the table 
DROP TABLE IF EXISTS dept_manager;

-- Create a new table 
CREATE TABLE dept_manager (
    dept_no VARCHAR(10) NOT NULL,
    emp_no INT NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (dept_no, emp_no),
    CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Drop the table 
DROP TABLE IF EXISTS employees;

-- Create a new table 
CREATE TABLE employees (
    emp_no INT NOT NULL,
    emp_title_id VARCHAR(30) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    sex VARCHAR(10) NOT NULL,
    hire_date DATE NOT NULL,
    CONSTRAINT pk_emp_no PRIMARY KEY (emp_no),
    CONSTRAINT fk_emp_title_id FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

-- Drop the table 
DROP TABLE IF EXISTS salaries;

-- Create a new table 
CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (emp_no),
    CONSTRAINT fk_salaries_emp_no FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Drop the table 
DROP TABLE IF EXISTS titles;

-- Create a new table 
CREATE TABLE titles (
    title_id VARCHAR(30) NOT NULL,
    title VARCHAR(40) NOT NULL,
    PRIMARY KEY (title_id)
);

--To upload the csv files into respective tables i had to drop the keys first 
-- Drop foreign key constraints
ALTER TABLE dept_emp DROP CONSTRAINT fk_dept_emp_emp_no;
ALTER TABLE dept_manager DROP CONSTRAINT fk_dept_manager_emp_no;
ALTER TABLE dept_manager DROP CONSTRAINT fk_dept_manager_dept_no;
ALTER TABLE salaries DROP CONSTRAINT fk_salaries_emp_no;
ALTER TABLE employees DROP CONSTRAINT fk_emp_title_id;

--Verify successful data import 
SELECT * FROM titles
SELECT * FROM employees

-- Recreate constraints
ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY (emp_no) REFERENCES employees (emp_no);
ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY (emp_no) REFERENCES employees (emp_no);
ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY (dept_no) REFERENCES departments (dept_no);
ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY (emp_no) REFERENCES employees (emp_no);
ALTER TABLE employees ADD CONSTRAINT fk_emp_title_id FOREIGN KEY (emp_title_id) REFERENCES titles (title_id);

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, s.salary, e.sex
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986 

SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE EXTRACT(YEAR FROM e.hire_date) = 1986;

--List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employees e ON dm.emp_no = e.emp_no;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name 
SELECT d.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT e.first_name, e.last_name, e.sex
FROM employees e
WHERE e.first_name = 'Hercules' AND e.last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name 
SELECT e.emp_no, e.last_name, e.first_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) 
SELECT e.last_name, COUNT(e.emp_no) AS frequency_count
FROM employees e
GROUP BY e.last_name
ORDER BY frequency_count DESC;