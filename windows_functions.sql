SELECT * FROM employees.employees;

-- extract maximun salary grouping for each department
select department_name, max(salary) as max_salary 
from employees
group by department_name;

--
select e.*,
max(salary) over(partition by department_name) as max_salary
from employees e;

-- row number, rank, dense_rank, lead and lag

select e.*,
row_number() over() as rn
from employees e;

select e.*,
row_number() over(partition by department_name order by id ) as rn
from employees e;

-- fetch the first 2 employees from each department to join the company
select * from (
	select e.*,
	row_number() over(partition by department_name order by id ) as rn
	from employees e) x
where x.rn < 3 ;

-- Rank() -- fetch the top 3 employyes in each department earning the max salary

select * from (select e.*,
	rank() over(partition by department_name order by salary desc) as rnk
	from employees e) x
where x.rnk <4;

-- denk rank() --
select e.*,
rank() over(partition by department_name order by salary desc) as rnk,
dense_rank() over(partition by department_name order by salary desc) as dns_rnk
from employees e;

-- lag ()
select e.*,
lag(salary) over(partition by department_name order by id) as previous_emp_salary,
lead(salary) over(partition by department_name order by id) as next_emp_salary
from employees e;

---

-- first values
select *,
first_value(first_name) over(partition by department_name order by salary desc) as max_earner
from employees;

-- last value

select *,
first_value(first_name) over(partition by department_name order by salary desc) as max_earner,
last_value(first_name) over (partition by department_name order by salary desc 
range between unbounded preceding and unbounded following) as low_earner_by_period

from employees;

-- alternate way to write window /over
select *,
first_value(first_name) over w as max_earner,
last_value(first_name) over w as low_earner_by_period
from employees
window w as (partition by department_name order by salary desc 
			range between unbounded preceding and unbounded following);

-- nth value()
select *,
first_value(first_name) over w as max_earner,
last_value(first_name) over w as low_earner_by_period,
nth_value(first_name, 3) over w as third_person
from employees
window w as (partition by department_name order by salary desc 
			range between unbounded preceding and unbounded following);

-- 
