--  Q4

set autocommit on;

create or replace function customer_bought_price(customer_no int, start_date date, end_date date)
return pr_order_items.list_price%type
is
    cursor orders_one_customer is
        select o.order_id from pr_customers c left join pr_orders o on c.customer_id=o.customer_id
        where c.customer_id = customer_no and o.order_date between to_date(start_date,'YY-MM-DD') and to_date(end_date,'YY-MM-DD');
    
    cursor order_item_price(order_no pr_orders.order_id%type) is
        select * from pr_order_items p where p.order_id = order_no;
        
    total_price pr_order_items.list_price%type;
    i_rtn pr_order_items.list_price%type;
begin
    i_rtn := 0;
    total_price :=0;

    for i_chk_order in orders_one_customer 
    loop 
        for item_price in order_item_price(i_chk_order.order_id)
        loop
            total_price := item_price.list_price + total_price;
        end loop;
    end loop;
    i_rtn := total_price;
    
    return i_rtn;
    
end customer_bought_price;

--test 1
select customer_bought_price(4,to_date('20120301','YY-MM-DD'),to_date('20190301','YY-MM-DD')) as result from dual;
--check
select * from pr_orders where customer_id=4;
select * from pr_order_items where order_id=700;

--test 2
select customer_bought_price(1,to_date('20120301','YY-MM-DD'),to_date('20150301','YY-MM-DD')) as result from dual;
--check
select * from pr_orders where customer_id=1;
