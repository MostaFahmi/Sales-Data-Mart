------------------------------------------------------
--------------------fact_sales--------------------------
-- TABLE CREATION


-- Drop and Create fact_sales

if exists (select * from sys.objects
			where name = 'fact_sales'
			and type = 'U')
Drop Table fact_sales

go 
Create Table fact_sales
(
	order_id  nvarchar(50) not null,
	line_number int not null,
	product_key int not null,
	customer_key int not null,
	territory_key int not null,
	order_DateKey int,
	quantity int,
	unit_price money,
	unit_cost money,
	tax_amount money,
	freight money,
	extended_sales money,
	extended_cost money,
	created_at datetime not null default(getdate())

	

	-- Defining The Relaionships
	constraint pk_fact_sales 
		primary key (order_id,line_number),

	constraint fk_fact_sales_dim_product 
		foreign key (product_key) references dim_product(product_key),

	constraint fk_fact_sales_dim_customer 
		foreign key (customer_key) references dim_customer(customer_key),

	constraint fk_fact_sales_dim_territory 
		foreign key (territory_key) references dim_territory(territory_key),

	constraint fk_fact_sales_dim_date 
		foreign key (order_DateKey) references dim_date(DateKey)
)




-- create mostly used index for searching
--- order_DateKey index


if exists (select * from sys.indexes
			where name = 'fact_sales_order_DateKey'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_order_DateKey;

create index fact_sales_order_DateKey 
	on fact_sales(order_DateKey);



--- product_key index


if exists (select * from sys.indexes
			where name = 'fact_sales_product_key'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_product_key;

create index fact_sales_product_key 
	on fact_sales(product_key);



--- customer_key index


if exists (select * from sys.indexes
			where name = 'fact_sales_customer_key'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_customer_key;

create index fact_sales_customer_key 
	on fact_sales(customer_key);



--- territory_key index


if exists (select * from sys.indexes
			where name = 'fact_sales_territory_key'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_territory_key;

create index fact_sales_territory_key 
	on fact_sales(territory_key);


