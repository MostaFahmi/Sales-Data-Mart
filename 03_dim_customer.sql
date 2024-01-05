------------------------------------------------------
--------------------dim_customer--------------------------
-- TABLE CREATION


-- Drop dim_customer and fact_sales relationship

if exists (select * from sys.foreign_keys
			where name = 'fk_fact_sales_dim_customer'
			and parent_object_id = object_id('fact_sales'))
alter table fact_sales drop constraint fk_fact_sales_dim_customer
;



-- Drop and Create dim_customer

if exists (select * from sys.objects
			where name = 'dim_customer'
			and type = 'U')
Drop Table dim_customer

go 
Create Table dim_customer
(
	customer_key int not null primary key identity(1,1),--surrogate key
	customer_id int not null, --alternate key - business key
	customer_name nvarchar(150) not null,
	address1 nvarchar(100) null,
	address2 nvarchar(100),
	city nvarchar(50),
	phone nvarchar(25),

	-- metadata
	source_system_code tinyint not null,

	-- SCD
	start_date datetime not null default(getdate()),
	end_date datetime,
	Is_Current tinyint not null default(1),

)





-- insert the UNKOWN record

set identity_insert dim_customer on

insert into dim_customer(customer_key,customer_id,customer_name,address1,address2,city,phone,source_system_code,start_date,end_date,Is_Current)
values(0,0,'UNKOWN','UNKOWN','UNKOWN','UNKOWN','UNKOWN',0,'1900-01-01',null,1)

set identity_insert dim_customer off






-- re-define dim_customer and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_customer foreign key (customer_key) references dim_customer(customer_key)






-- create mostly used index for searching
--- customer_id index


if exists (select * from sys.indexes
			where name = 'dim_customer_customer_id'
			and object_id = object_id('dim_customer'))
drop index dim_customer.dim_customer_customer_id;

create index dim_customer_customer_id 
	on dim_customer(customer_id);


--- customer_name index


if exists (select * from sys.indexes
			where name = 'dim_customer_customer_name'
			and object_id = object_id('dim_customer'))
drop index dim_customer.dim_customer_customer_name;

create index dim_customer_customer_name
	on dim_customer(customer_name);





