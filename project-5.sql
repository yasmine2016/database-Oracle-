-- Q5

create or replace procedure add_product(product_no pr_products.product_id%TYPE, product_nm pr_products.product_name%TYPE, 
                                        category_no pr_categories.category_id%TYPE, category_nm pr_categories.category_name%TYPE, 
                                        brand_no pr_brands.brand_id%TYPE, brand_nm pr_brands.brand_name%TYPE, 
                                        m_year pr_products.model_year%TYPE, l_price pr_products.list_price%TYPE)
AS
    i_chk_product int;
    i_chk_category int;
    i_chk_brand_id int;
begin
    --check brands
    select count(*) into i_chk_brand_id from pr_brands where brand_id = brand_no;
    if i_chk_brand_id > 0 then
    
        update pr_brands set brand_name = brand_nm where brand_id = brand_no;
    else
        insert into pr_brands(brand_id,brand_name) values(brand_no,brand_nm);
    end if;
    
    --check categories
    select count(*) into i_chk_category from pr_categories where category_id = category_no;
    if i_chk_category > 0 then
        update pr_categories set category_name = category_nm where category_id = category_no;
    else
        insert into pr_categories(category_id,category_name) values(category_no,category_nm);
    end if;

    --check products
    select count(*) into i_chk_product from pr_products where product_id = product_no;
    if i_chk_product > 0 then
        update pr_products set product_name = product_nm , brand_id = brand_no, category_id = category_no,model_year=m_year,list_price=l_price
        where product_id = product_no;
    else
        insert into pr_products(product_id,product_name,brand_id,category_id,model_year,list_price) 
        values(product_no,product_nm,brand_no,category_no,m_year,l_price);
    end if;

end add_product;

--test 1
call add_product(322,'test product name111',8,'Aged Bikes',10,'BEAU',2020,1850.99);
-- check
select * from pr_products ORDER BY product_id DESC;
select * from pr_categories order by category_id desc;
select * from pr_brands order by brand_id desc ;

--test 2
call add_product(100,'test product name222',5,'Girl Bikes',8,'pritty',2020,2222.88);
-- check
select * from pr_products where product_id = 100;
select * from pr_categories where category_id = 5;
select * from pr_brands where brand_id = 8 ;


