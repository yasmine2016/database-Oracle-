--Project
-- Q1

create table pr_brands(
brand_id int NOT NULL,
brand_name VARCHAR2(50) NOT NULL,
primary key(brand_id)
);
 
create table pr_categories(
category_id int NOT NULL,
category_name VARCHAR2(50) NOT NULL,
primary key(category_id)
);

create table pr_customers(
customer_id int NOT NULL,
first_name VARCHAR2(50) NOT NULL,
last_name VARCHAR2(50) NOT NULL,
phone VARCHAR2(20) DEFAULT NULL,
email VARCHAR2(50) NOT NULL,
street VARCHAR2(50) NOT NULL,
city VARCHAR2(50) NOT NULL,
state VARCHAR2(2) NOT NULL,
zip_code INT NOT NULL,
primary key(customer_id)
);

create table pr_stores(
store_id int NOT NULL,
store_name VARCHAR2(50) NOT NULL,
phone VARCHAR2(20) NOT NULL,
email VARCHAR2(50) NOT NULL,
street VARCHAR2(50) NOT NULL,
city VARCHAR2(20) NOT NULL,
state VARCHAR2(2) NOT NULL,
zip_code int NOT NULL,
primary key(store_id)
);

create table pr_products(
product_id int NOT NULL,
product_name VARCHAR2(100) NOT NULL,
brand_id int NOT NULL,
category_id int NOT NULL,
model_year int NOT NULL,
list_price number(10,2) NOT NULL,
primary key(product_id),
constraint pr_products_fk foreign key(category_id) references pr_categories(category_id),
constraint pr_products_fk1 foreign key(brand_id) references pr_brands(brand_id)
);

ALTER table pr_products modify(model_year date);
delete from pr_products;


create table pr_order_items(
order_id int NOT NULL,
item_id int NOT NULL,
product_id int NOT NULL,
quantity int NOT NULL,
list_price number(10,2) NOT NULL,
discount number(3,2) NOT NULL,
primary key(order_id,item_id),
constraint pr_order_items_fk foreign key(product_id) references pr_products(product_id)
); 

create table pr_stocks(
store_id int NOT NULL,
product_id int NOT NULL,
quantity int NOT NULL,
primary key(store_id,product_id),
constraint pr_stocks_fk foreign key(product_id) references pr_products(product_id)
);

create table pr_staffs(
staff_id int NOT NULL,
first_name VARCHAR2(50) NOT NULL,
last_name VARCHAR2(50) NOT NULL,
email VARCHAR2(50) NOT NULL,
phone VARCHAR2(20) NOT NULL,
active int NOT NULL,
store_id int NOT NULL,
manager_id int default NULL,
primary key(staff_id),
constraint pr_staffs_fk foreign key (store_id) references pr_stores(store_id)
);

create table pr_orders(
order_id int NOT NULL,
customer_id int NOT NULL,
order_status int NOT NULL,
order_date date NOT NULL,
required_date date NOT NULL,
shipped_date date DEFAULT NULL,
store_id int NOT NULL,
staff_id int NOT NULL,
primary key(order_id),
constraint pr_orders_fk foreign key (store_id) references pr_stores(store_id),
constraint pr_orders_fk1 foreign key(staff_id) references pr_staffs(staff_id),
constraint pr_orders_fk2 foreign key(customer_id) REFERENCES pr_customers(customer_id)
);

--Q2
with qty_rank as(
select store_id,sum(quantity) as total_qty_sold,rank()over(order by sum(quantity) desc) as rank
from pr_stocks
group by store_id)
select q.store_id,p.store_name,q.total_qty_sold,q.rank
from qty_rank q, pr_stores p
where q.store_id=p.store_id;




