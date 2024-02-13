-- customers trasaction----------online banking--------------------

-- Total customer details in Transaction, Fixed deposit and Loan 

select distinct c.customer_account_number as Account_number,ucase(c.customer_name) as Name,
c.customer_bank_name as Bank_name ,c.customer_ifsc_code as IFSC_CODE,
c.customer_phone_no as PHONE_NUMBER,c.customer_account_type as ACCOUNT_TYPE,t.trans_type as Credit_Debit,
t.trans_amount,t.trans_balance as Account_balance,
f.fd_acc_num,f.fd_period_year,f.fd_interset,f.fd_amount,l.loan_acc_num,l
.loan_tenure,l.loan_interest,l.loan_amount
from customers as c 
left join transactions as t 
on c.customer_account_number = t.tran_acc_number
left join fixed_deposits as f 
on c.customer_account_number = f.fd_acc_num
left join loans as l 
on c.customer_account_number = l.loan_acc_num;
 
-- Customers Fixed deposit Details

select c.customer_name as Name,c.customer_account_number as Account_number,c.customer_bank_name as bank_name ,c.customer_ifsc_code as IFSC_CODE,
c.customer_phone_no as PHONE_NUMBER,c.customer_account_type as ACCOUNT_TYPE,f.fd_acc_num,f.fd_period_year,
f.fd_interset,f.fd_amount
from customers as c left join fixed_deposits as f
on c.customer_account_number = f.fd_acc_num;

-- Customers Loan Details

select c.customer_name as Name,c.customer_account_number as Account_number,c.customer_bank_name as bank_name ,c.customer_ifsc_code as IFSC_CODE,
c.customer_phone_no as PHONE_NUMBER,c.customer_account_type as ACCOUNT_TYPE,l.loan_tenure,
l.loan_interest,l.loan_amount
from customers as c left join loans as l
on c.customer_account_number = l.loan_acc_num;


-- Customers Transaction Details

select c.customer_name as Name,c.customer_account_number as Account_number,c.customer_bank_name as bank_name ,c.customer_ifsc_code as IFSC_CODE,
c.customer_phone_no as PHONE_NUMBER,c.customer_account_type as ACCOUNT_TYPE,t.trans_type as Credit_Debit,
t.trans_amount,t.trans_balance as Account_balance
from customers as c left join transactions as t 
on c.customer_account_number = t.tran_acc_number;

-- tpo 10 customers fixed deposit 

select c.customer_account_number,f.fd_start_date,f.fd_end_date,f.fd_amount
from customers as c inner join fixed_deposits as f
on c.customer_account_number = f.fd_acc_num order by f.fd_amount desc limit 10;

-- top 10 customers loan amount

select c.customer_account_number,l.loan_start_date,l.loan_end_date,l.loan_amount
from customers as c inner join loans as l
on c.customer_account_number = l.loan_acc_num 
order by l.loan_amount desc limit 10;  

-- top 10 cutomers transaction

select c.customer_account_number,count(c.customer_account_number),t.trans_amount,t.trans_balance,max(t.trans_balance) 
from customers as c left join transactions as t
on c.customer_account_number = t.tran_acc_number 
group by c.customer_id,c.customer_account_number,t.trans_amount,t.trans_balance order by t.trans_balance desc limit 10;


select c.customer_id,c.customer_account_number,count(c.customer_account_number),t.trans_amount
from customers as c left join transactions as t
on c.customer_account_number = t.tran_acc_number 
group by c.customer_id,c.customer_account_number,t.trans_amount, t.trans_type
having t.trans_type ='credit' order by c.customer_account_number;


select  c.customer_id,c.customer_account_number,count(c.customer_account_number),t.trans_amount
from customers as c left join transactions as t
on c.customer_account_number = t.tran_acc_number 
group by c.customer_id,c.customer_account_number,t.trans_amount, t.trans_type
having t.trans_type ="debit"  order by c.customer_id;

-- Bank Wise Customers

SELECT customer_bank_name AS bank_name, COUNT(customer_id) AS customer FROM customers
GROUP BY bank_name;

-- Bank Wise Customers loans

SELECT c.customer_bank_name AS bank_name, COUNT(loan_id) AS customer_loan FROM customers c inner join loans l 
on c.customer_account_number = l.loan_acc_num
GROUP BY bank_name;

-- Bank wise abovee 100000 to 200000 loan amount customers

select c.customer_bank_name AS bank_name, COUNT(loan_id) as customer, l.loan_amount as loanamount from Customers c inner join loans l
on c.customer_account_number = l.loan_acc_num
GROUP BY c.customer_bank_name,l.loan_amount having l.loan_amount between 100000 and 200000 ;

-- Bank wise customers fixed deposit
select c.customer_bank_name AS bank_name,count(f.fd_id) as Customers from Customers as c inner join fixed_deposits as f 
on c.customer_account_number = f.fd_acc_num
group by c.customer_bank_name;

-- Bank wise above 100000 fd amount customers
select c.customer_bank_name,count(f.fd_id),f.fd_amount as Customers from Customers as c inner join fixed_deposits as f 
on c.customer_account_number = f.fd_acc_num
group by c.customer_bank_name,f.fd_amount having f.fd_amount > 100000;

-- no loan balance customers
select c.customer_name,c.customer_account_number,c.customer_bank_name,l.loan_tenure as YEAR,l.loan_end_date,l.loan_amount
from customers as c inner join loans as l 
on c.customer_account_number=l.loan_acc_num
where l.loan_nodue_ammount = false;

-- current loan due amount customers 
select c.customer_name,c.customer_account_number as ACCOUNT_NUMBER,c.customer_bank_name,l.loan_tenure as YEAR,l.loan_end_date,l.loan_amount
from customers as c inner join loans as l 
on c.customer_account_number=l.loan_acc_num
where l.loan_nodue_ammount = true;

-- active customers bank balance
select c.customer_name,c.customer_account_number as ACCOUNT_NUMBER,c.customer_bank_name,t.trans_balance
from customers as c inner join transactions as t
on c.customer_account_number=t.tran_acc_number
where c.customer_account_status ="active";

-- inactive customers bank balance
select c.customer_name,c.customer_account_number as ACCOUNT_NUMBER,c.customer_bank_name,t.trans_balance
from customers as c inner join transactions as t
on c.customer_account_number=t.tran_acc_number
where c.customer_account_status ="inactive";

-- last 10 year how many customer to take loan from SBI bank 
select distinct  c.customer_bank_name,count(l.loan_acc_num) as Customers from Customers as c inner join loans as l 
on c.customer_account_number = l.loan_acc_num
where l.loan_start_date between "2023-01-01" and curdate() 
group by  c.customer_bank_name having customer_bank_name="SBI";

-- last 10 month how many customer fixed deposit bank wise
select c.customer_bank_name,COUNT(f.fd_acc_num) AS CUSTOMERS from Customers as c inner join fixed_deposits as f 
on c.customer_account_number = f.fd_acc_num where  f.fd_start_date >= now() - interval 10 month
group by c.customer_bank_name ;

-- last 5 month how many customer fixed deposit bank ICICI
select c.customer_bank_name,COUNT(f.fd_acc_num) from Customers as c inner join fixed_deposits as f 
on c.customer_account_number = f.fd_acc_num where  f.fd_start_date >= now() - interval 10 month
group by c.customer_bank_name having c.customer_bank_name = "ICICI";

-- first quater of the year in icici fixed deposit customers
select c.customer_bank_name,c.customer_account_number,f.fd_amount,COUNT(f.fd_acc_num) as COUNT from Customers as c right join fixed_deposits as f 
on c.customer_account_number = f.fd_acc_num where  month(f.fd_start_date) in (1,2,3) and year(f.fd_start_date) in ("2020")
group by c.customer_bank_name,c.customer_account_number,f.fd_amount having c.customer_bank_name = "ICICI";

-- month wise all bank fd amount 
select c.customer_bank_name ,monthname(f.fd_start_date) as month,sum(f.fd_amount) as total
from customers as c inner join fixed_deposits as f 
on  c.customer_account_number = f.fd_acc_num
group by monthname(f.fd_start_date),c.customer_bank_name ;


-- analytic functiond
-- inline lag and over
select month,amount,customer_bank_name ,month_number,lag(amount) over(order by month_number) as previous_year_amount
from(
	select c.customer_bank_name ,monthname(f.fd_start_date) as month,sum(f.fd_amount) as AMOUNT,month(f.fd_start_date) as month_number
	from customers as c inner join fixed_deposits as f 
	on  c.customer_account_number = f.fd_acc_num where  month(f.fd_start_date) in (4,5,6) and year(f.fd_start_date) in ("2015")
	group by month(f.fd_start_date), monthname(f.fd_start_date),c.customer_bank_name having c.customer_bank_name="ICICI" 
    ) as result  order by month_number;
    
-- inline lead and over 
select month,amount,customer_bank_name ,month_number,lead(amount) over(order by month_number) as next_year_amount
from(
	select c.customer_bank_name ,monthname(f.fd_start_date) as month,sum(f.fd_amount) as AMOUNT,month(f.fd_start_date) as month_number
	from customers as c inner join fixed_deposits as f 
	on  c.customer_account_number = f.fd_acc_num where  month(f.fd_start_date) in (4,5,6) and year(f.fd_start_date) in ("2015")
	group by month(f.fd_start_date), monthname(f.fd_start_date),c.customer_bank_name having c.customer_bank_name="ICICI" 
    ) as result ;

-- first quater of the year in AXIS fixed deposit customers amounts
select c.customer_bank_name ,monthname(f.fd_start_date) as MONTH,sum(f.fd_amount) as AMOUNT
from customers as c inner join fixed_deposits as f 
on  c.customer_account_number = f.fd_acc_num where  month(f.fd_start_date) in (1,2,3) and year(f.fd_start_date) in ("2023")
group by monthname(f.fd_start_date),c.customer_bank_name having c.customer_bank_name="AXIS" order by max(f.fd_start_date) ;

-- second quater of the year in HDFC fixed deposit customers amounts
select c.customer_bank_name ,monthname(f.fd_start_date) as MONTH,sum(f.fd_amount) as AMOUNT
from customers as c inner join fixed_deposits as f 
on  c.customer_account_number = f.fd_acc_num where  month(f.fd_start_date) in (4,5,6) and year(f.fd_start_date) in ("2023")
group by monthname(f.fd_start_date),c.customer_bank_name having c.customer_bank_name="HDFC" order by max(f.fd_start_date) ;


-- third quater of the year in ICICI fixed deposit customers
select c.customer_bank_name ,monthname(f.fd_start_date) as MONTH,sum(f.fd_amount) as AMOUNT
from customers as c inner join fixed_deposits as f 
on  c.customer_account_number = f.fd_acc_num where  month(f.fd_start_date) in (7,8,9) and year(f.fd_start_date) in ("2023")
group by monthname(f.fd_start_date),c.customer_bank_name having c.customer_bank_name="ICICI" order by max(f.fd_start_date) ;


-- lowest bank balance customer 
select c.customer_name,c.customer_bank_name,t.trans_balance
from customers as c inner join transactionS as t
on c.customer_account_number=t.tran_acc_number
order by t.trans_balance  limit 1;

-- highest bank balance
select c.customer_name,c.customer_bank_name,t.trans_balance
from customers as c inner join transactionS as t
on c.customer_account_number=t.tran_acc_number
order by t.trans_balance DESC  limit 1;

-- top 5 highest loan intErest amount customer 
select c.customer_name,c.customer_account_number as ACCOUNT_NUMBER,c.customer_bank_name,l.loan_interest,l.loan_amount
from customers as c inner join loanS as l
on c.customer_account_number=l.loan_acc_num
order by l.loan_interest desc limit 5;

-- top 5 lowest fixed deposit intErest amount customers
select c.customer_name,c.customer_account_number as ACCOUNT_NUMBER,c.customer_bank_name,l.loan_interest,l.loan_amount
from customers as c inner join loanS as l
on c.customer_account_number=l.loan_acc_num
order by l.loan_interest limit 5;


-- group the loan type bank wise how many customers
select c.customer_bank_name,l.type_of_loan,count(c.customer_account_number) as CUSTOMERS
from customers as c right join loanS as l
on c.customer_account_number = l.loan_acc_num
group by c.customer_bank_name,l.type_of_loan;


