--Q3
create table order_item_log (
order_id int NOT NULL, 
customer_id int NOT NULL, 
item_id int NOT NULL, 
product_id int NOT NULL, 
quantity int NOT NULL, 
changed_by varchar2(20) NOT NULL,
changed_date date not null, 
change_type varchar2(1) not null
);

set autocommit on;
create or REPLACE trigger order_items_trigger 
after insert or update or delete on pr_order_items
for each row
declare
    opt_type varchar2(1);
    opt_user varchar2(20);
    opt_customer_id pr_orders.customer_id%type;
    new_date date;
begin
    
    if INSERTING then
        opt_type := 'I';
    elsif UPDATING then
        opt_type := 'U';
    elsif DELETING then
        opt_type := 'D';
    end if;
    
    new_date := to_date(SYSDATE,'YY-MM-DD');
    SELECT sys_context('USERENV', 'CURRENT_USER') into  opt_user FROM dual;
     
    --insert log 
    if INSERTING or UPDATING then
        select customer_id into opt_customer_id from pr_orders where order_id = :new.order_id;
        insert into order_item_log(order_id, customer_id, item_id, product_id, quantity, changed_by, changed_date, change_type)
        values(:new.order_id,opt_customer_id,:new.item_id,:new.product_id,:new.quantity,opt_user,new_date,opt_type);
    elsif DELETING then
        select po.customer_id into opt_customer_id from pr_orders po where :old.order_id = po.order_id;
        insert into order_item_log(order_id, customer_id, item_id, product_id, quantity, changed_by, changed_date, change_type)
        values(:old.order_id,opt_customer_id,:old.item_id,:old.product_id,:old.quantity,opt_user,new_date,opt_type);
    end if;
end;

--TEST 1
UPDATE pr_order_items SET quantity = 10 WHERE order_id = 4;
--CHECK
SELECT * FROM pr_order_items WHERE ORDER_ID = 4;
SELECT * FROM order_item_log ;

--TEST 2
DELETE FROM pr_order_items  WHERE order_id = 1 AND item_id = 1;
--CHECK
SELECT * FROM pr_order_items WHERE order_id = 1 AND item_id = 1;
SELECT * FROM order_item_log ;

--TEST 3
INSERT INTO pr_order_items(order_id,item_id,product_id,quantity,list_price,discount) VALUES(4,5,2,100,555.99,0.02);
--CHECK
SELECT * FROM pr_order_items WHERE order_id = 1 AND item_id = 1;
SELECT * FROM order_item_log ;


